# 08_PAPER_READING_PLAN.md

## 1. 论文基本信息

- 论文标题：Tabbed Out: Subverting the Android Custom Tab Security Model
- 作者：Philipp Beer, Marco Squarcina, Lorenzo Veronese, Martina Lindorfer
- 单位：TU Wien
- 研究对象：Android Custom Tabs（CT）及其与底层浏览器共享状态、向宿主 app 暴露导航/滚动回调、允许 UI 自定义等机制。
- 本项目目标：只在本地 mock server、Android 模拟器或授权测试设备上复现论文中可安全展示的机制现象，不攻击真实网站，不收集真实 cookie/token/password。

## 2. 论文核心问题总结

### 2.1 Custom Tabs state sharing

论文依据：Sec. 2.1、Sec. 3.4、Sec. 4.1.2。

论文指出 CT 与底层浏览器共享 cookies、permissions、Service Workers、cache 等状态。用户如果在浏览器里已登录某网站，CT 打开同一网站时也可能处于登录状态。这个设计改善了移动端登录体验，但也让宿主 app 有机会借助 CT 观察 Web 侧状态。

本项目处理：只使用本地 demo cookie/session 验证“CT 与浏览器共享本地测试状态”的现象，对应 E03_state_sharing_cookie。server 日志只记录 `cookie_present`，不记录 cookie 值。

### 2.2 Navigation callbacks

论文依据：Sec. 2.2。

CT 宿主 app 可以通过 `CustomTabsCallback` 接收 `NAVIGATION_STARTED`、`NAVIGATION_FAILED`、`NAVIGATION_ABORTED`、`NAVIGATION_FINISHED`、`TAB_SHOWN`、`TAB_HIDDEN` 等事件。论文认为这些 callback 与状态共享结合后，会形成跨上下文信息泄露通道。

本项目处理：先复现基础 callback 记录能力，对应 E01_callback_baseline；再比较不同 HTTP 行为产生的 callback sequence/timing 差异，对应 E02_state_inference_oracle。

### 2.3 Cross-Context Leaks

论文依据：Abstract、Sec. 1、Sec. 3.4。

论文提出 Cross-Context Leaks：信息不是在两个 Web origin 之间泄露，而是在 Web 上下文与移动 app 上下文之间泄露。其核心组合是：Web 状态由浏览器持有，CT 继承该状态，宿主 app 又能观察 CT 的外部行为。

本项目处理：将真实网站案例全部替换为本地 endpoint，演示机制而不是攻击目标。Presentation 中应明确：本项目关注“状态共享 + callback oracle”的安全模型问题，不复现真实站点探测。

### 2.4 State Inference Attack

论文依据：Sec. 3.4、尤其 Sec. 3.4.1；Fig. 5 是真实站点 timing case study；Table 2 标出该攻击影响 Chrome/Edge/Brave 且根因是 by-design navigation callback reporting。

论文列出多个可形成 oracle 的响应维度：

- HTTP status：4xx/5xx 且 empty body 会触发额外 `NAVIGATION_FAILED`，随后 `NAVIGATION_FINISHED`；2xx/3xx 或 4xx/5xx 非空 body 通常只触发 `NAVIGATION_FINISHED`。
- Redirection：HTML/JavaScript redirect 可导致两组 start/finish；HTTP 3xx redirect 通常只产生初始 start/finish。
- Download：触发下载的资源在 Chrome/Edge/Brave 上会触发 `NAVIGATION_ABORTED`，不触发 `NAVIGATION_FINISHED`。
- Content-Type：`video/mp4`、`audio/mpeg`、`application/pdf` 等可能触发 `NAVIGATION_ABORTED`。
- Timing：`NAVIGATION_STARTED` 到 `NAVIGATION_FINISHED` 的耗时可泄露状态差异。

本项目处理：作为推荐主线。用本地 `/status/*`、`/redirect/*`、`/download`、`/content/pdf`、`/delay/*` 构造可控差异，采集 `events.csv`、Logcat、截图、server log。

### 2.5 HTTP Header Injection

论文依据：Sec. 3.5、Sec. 3.5.1、Sec. 3.5.2、Table 2、Table 6、Table 7、Sec. 4.2、Sec. 4.3。

论文描述旧版 Chrome/Edge/Brave 对 CT 中附加 header 值的换行符 sanitization 不充分，导致可借助 CORS-approvelisted header 注入非 approvelisted header。Table 2 标明影响版本大致为 Chrome <108、Edge <108、Brave <1.46；Sec. 4.2 指出修复方式是拒绝包含 `\n` 的 malformed header value。

本项目处理：不做真实 header 注入攻击，不安装来源不明旧版浏览器。只做本地安全模拟或 negative result：使用现代浏览器向本地 `/headers/echo` 或同类 endpoint 发送受控 header，记录现代浏览器是否拒绝/清洗异常值；如果实现该 endpoint，也不得访问真实站点。

### 2.6 SameSite Cookie Bypass

论文依据：Sec. 3.6、Table 2、Sec. 4.2、Sec. 4.3。

论文发现旧版 Chromium 系 CT 初始请求会携带 `SameSite=Strict` cookie。Table 2 标明影响版本大致为 Chrome <109、Edge <110、Brave <1.48；Sec. 4.3 说明该问题后来被修复，并引入 CVE-2022-4926 相关披露。

本项目处理：只做本地 demo Strict cookie negative result 或安全模拟。预期现代浏览器上应记录为 mitigation/negative result；若结果异常，必须回查 Sec. 3.6、Sec. 4.2、Sec. 4.3 后再解释。

### 2.7 Scroll Inference Attack

论文依据：Sec. 3.7、Fig. 3、Table 2、Sec. 4.2。

论文利用 URL Fragment Text Directive 与浏览器实现相关的 `extraCallback` scroll events，推断页面中是否存在特定字符串。论文还指出 Chrome/Edge 的诊断/改进体验开关会影响 scroll callback 可用性；Sec. 4.2 提到 Google 后续采取了限制 text fragment 场景 scroll callback 等 mitigation。

本项目处理：不推荐作为必做实验。可作为可选观察：仅在本地长页面中观察 `extraCallback` 是否出现，不推断真实用户隐私，不构造真实搜索/医疗/地图信息探测。

### 2.8 Bottom Bar Spoofing

论文依据：Sec. 3.8、Sec. 3.8.1、Sec. 3.8.2、Fig. 4、Table 2、Sec. 4.2。

论文描述 bottom bar 可以伪装成网页 UI，造成 URL 泄露或 phishing 风险。Sec. 3.8.1 关注点击 bottom bar intent 泄露当前 URL；Sec. 3.8.2 关注利用已登录页面作为 trust anchor 诱导用户。

本项目处理：不实现真实 phishing，不伪造真实品牌页面。可选做本地 UI 风险说明截图：使用中性本地页面展示 bottom bar 与网页内容边界不清的问题，并在报告中作为安全设计分析。

## 3. 论文攻击点与本地复现映射

| 攻击/机制 | 论文依据 | 原论文现象 | 是否适合课程安全复现 | 本项目是否复现 | 本地替代设计 | 需要的 app 功能 | 需要的 server endpoint | 证据 | 风险等级 | presentation 价值 |
|---|---|---|---|---|---|---|---|---|---|---|
| CT state sharing | Sec. 2.1, Sec. 3.4 | CT 继承底层浏览器 cookie/session 等状态 | 适合，但必须使用 demo cookie | 是，E03 必做 | `/login` 设置 demo cookie，`/profile` 根据 cookie_present 返回不同页面 | 打开 CT、记录 callback、导出 CSV | `/login`, `/profile` | server.log、events.csv、截图 | 低 | 高：解释 CT 设计基础 |
| Navigation callbacks | Sec. 2.2 | 宿主 app 可接收导航与可见性事件 | 适合 | 是，E01 必做 | `/basic` 与状态码页面验证 callback recorder | `CustomTabsCallback`、UI/Logcat/CSV 三路记录 | `/basic`, `/status/200`, `/status/404-empty`, `/status/404-body` | events.csv、Logcat、截图 | 低 | 高：后续 oracle 的前提 |
| State Inference: status/body | Sec. 3.4.1 | 4xx/5xx empty body 额外触发 `NAVIGATION_FAILED` | 适合 | 是，E01/E02 | 比较 200、404 empty、404 body 的 callback sequence | 同上 | `/status/200`, `/status/404-empty`, `/status/404-body` | sequence 对比表 | 低 | 高：最清晰的 callback oracle |
| State Inference: redirect | Sec. 3.4.1 | HTML/JS redirect 与 HTTP redirect callback 数量不同 | 适合 | 是，E02 | 本地 HTTP 302 与 HTML meta/JS redirect 对比 | 记录多次 navigation events | `/redirect/http`, `/redirect/html` | events.csv、timing 表、截图 | 低 | 高：展示可区分路径 |
| State Inference: download | Sec. 3.4.1 | 下载资源触发 `NAVIGATION_ABORTED` 而非 finish | 适合 | 是，E02 | 本地 attachment 下载 | 记录 aborted/finished | `/download` | events.csv、Logcat、下载提示截图 | 低到中 | 中高：解释 content-disposition oracle |
| State Inference: Content-Type | Sec. 3.4.1 | PDF/音视频等 Content-Type 可能触发 `NAVIGATION_ABORTED` | 适合 | 是，E02 | 本地 PDF 或简单二进制响应 | 记录 aborted/finished | `/content/pdf` | events.csv、截图 | 低 | 中高：容易演示响应类型差异 |
| State Inference: timing | Sec. 3.4.1, Fig. 5 | 加载时间差异可暗示用户状态 | 适合本地模拟，不做真实站点 | 是，E02 | `/delay/1000` 与 `/delay/3000` 统计 start-finish delta | 记录 timestamp_ms、relative_ms | `/delay/1000`, `/delay/3000` | timing 统计表 | 低 | 高：适合图表展示 |
| Header Injection | Sec. 3.5, Table 6, Table 7 | 旧版浏览器 header value 换行注入 | 不适合真实复现 | 只做 E04 negative result/安全模拟 | 现代浏览器 + 本地 echo，验证不能利用或只记录原理 | 可选 header 参数测试；不访问真实站 | 可选 `/headers/echo` | server.log、浏览器版本、negative result | 中到高 | 中：说明已修复实现 bug |
| SameSite Strict bypass | Sec. 3.6, Sec. 4.3 | 旧版 CT 初始请求携带 Strict cookie | 不适合真实复现 | 只做 E04 negative result/安全模拟 | 本地 Strict demo cookie，现代浏览器记录是否发送 | 打开本地 CT、记录浏览器版本 | 可选 `/samesite/set`, `/samesite/check` | server.log、截图、版本 | 中 | 高：说明现代 mitigation |
| Scroll Inference | Sec. 3.7, Fig. 3 | text fragment + scroll callback 推断页面字符串 | 不建议必做 | 可选观察 | 本地长页面，只观察 extraCallback 是否存在 | 记录 `extraCallback` name/bundle 摘要 | 可选 `/long-page` | events.csv、截图 | 中 | 中：可作为扩展机制 |
| Bottom Bar Info Leakage | Sec. 3.8.1, Fig. 4a | bottom bar intent 可带当前 URL | 不建议真实复现敏感 URL | 可选安全演示 | 本地中性页面，演示 URL 不含敏感数据 | bottom bar 本地按钮/intent 观察 | `/basic` 或本地页面 | 截图、说明 | 中 | 中：UI 风险可视化 |
| Bottom Bar Phishing | Sec. 3.8.2, Fig. 4b | bottom bar 伪装成网页 UI 诱导操作 | 不建议复现 | 不做攻击，只做文字分析 | 不伪造品牌，不做诱导式页面 | 无，或仅报告截图示意 | 无 | 报告引用论文图/机制说明 | 高 | 中：安全伦理边界展示 |

## 4. 推荐复现范围

### 4.1 必做实验

1. E01_callback_baseline：验证 callback recorder 能稳定记录基础事件。
2. E02_state_inference_oracle：用本地状态码、redirect、download、Content-Type、delay 构造 callback sequence/timing 差异。
3. E03_state_sharing_cookie：用本地 demo cookie/session 展示 CT 与浏览器共享状态。
4. E04_modern_mitigation_negative：记录现代浏览器对 Header Injection 与 SameSite Strict bypass 的修复/负结果。

### 4.2 可选实验

1. Scroll callback 观察：只在本地长页面中观察 `extraCallback`，不推断真实隐私。
2. Bottom bar UI 风险安全演示：只使用中性本地页面，不伪造真实品牌，不诱导输入账号密码。

### 4.3 不建议复现实验

1. 真实网站登录状态探测。
2. 真实 Header Injection 攻击。
3. 真实 SameSite 绕过攻击。
4. 真实 phishing 页面或真实品牌 UI 伪装。
5. 安装来源不明或不可信旧版浏览器进行攻击验证。
6. 任何涉及真实 cookie、token、password、账号截图、个人隐私数据的实验。

### 4.4 只做 negative result 的内容

1. Header Injection：现代 Chromium 系浏览器应已做 header sanitization；若没有出现可利用行为，记录为 mitigation。
2. SameSite Strict Cookie Bypass：现代 Chromium 系浏览器应已修复 Strict cookie 发送问题；若本地 Strict cookie 不随 CT 跨上下文请求发送，记录为 mitigation。
3. Scroll Inference：若现代浏览器禁用 text fragment 场景 scroll callback，应记录为 mitigation。

## 5. 必须回查论文的实验点

出现以下情况时，先回查论文再改实验设计：

1. `/status/404-empty` 没有出现论文 Sec. 3.4.1 描述的 `NAVIGATION_FAILED` 差异。
2. `/redirect/html` 与 `/redirect/http` 的 callback 数量无法区分。
3. `/download` 或 `/content/pdf` 没有触发 `NAVIGATION_ABORTED`。
4. timing 结果与 `/delay/*` 设计不一致。
5. 现代浏览器仍表现出 Header Injection 或 SameSite Strict bypass 风险。
6. `extraCallback` 行为与 Sec. 3.7 不一致。

每次回查需在对应 `experiments/E*/observations.md` 记录：论文 section/table/figure、论文预期、本地观察、一致性判断、差异原因猜测、是否修改实验设计。

## 6. Presentation 推荐叙事主线

1. CT 的便利性：浏览器体验、状态共享、OAuth 常用。
2. CT 的安全张力：Web 状态由浏览器持有，但 app 可以观察 callback。
3. 本地靶场：用 mock server 替代真实网站，严格限制数据与目标。
4. E01/E02：callback oracle 如何由响应差异产生。
5. E03：本地 demo cookie 如何展示 state sharing。
6. E04：旧论文结果与现代浏览器 mitigation 的差异。
7. 结论：CT 安全模型需要考虑 cross-context 边界，课程复现应强调机制、证据与伦理边界。
