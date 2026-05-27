# 03_EXPERIMENT_MATRIX.md

## 1. 总体复现原则

本项目只复现论文《Tabbed Out: Subverting the Android Custom Tab Security Model》中适合课程展示的本地安全实验。所有 endpoint 必须位于 `localhost`、`127.0.0.1`、`10.0.2.2` 或明确授权的本地测试域名。不得访问真实网站，不得收集真实账号、真实 cookie、真实 token、真实密码或真实隐私数据。

论文依据优先级：

1. Sec. 2.1：Custom Tabs state sharing。
2. Sec. 2.2：Navigation callbacks。
3. Sec. 3.4：Cross-Context State Inference Attack。
4. Sec. 3.5：HTTP Header Injection。
5. Sec. 3.6：SameSite Cookie Bypass。
6. Sec. 3.7：Scroll Inference Attack。
7. Sec. 3.8：Bottom Bar Spoofing。
8. Table 2、Table 4、Table 6、Table 7、Fig. 3、Fig. 4、Fig. 5。

## 2. 攻击点到本地实验映射

| 编号 | 论文攻击/机制 | 论文 section / table / figure | 原论文实验现象 | 是否适合本课程安全复现 | 本项目是否复现 | 本地替代实验设计 | 需要的 app 功能 | 需要的 server endpoint | 需要采集的证据 | 风险等级 | Presentation 展示价值 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| M01 | Custom Tabs state sharing | Sec. 2.1, Sec. 3.4, Sec. 4.1.2 | CT 共享底层浏览器 cookies、permissions、cache 等状态 | 适合，限 demo 数据 | 是，E03 | 本地 `/login` 设置 demo cookie，`/profile` 判断 `cookie_present` | 打开 CT、记录 callback、导出 CSV、显示浏览器包名/版本 | `/login`, `/profile` | server.log、events.csv、Logcat、截图 | 低 | 高 |
| M02 | Navigation callbacks | Sec. 2.2 | app 可接收 `NAVIGATION_STARTED/FAILED/ABORTED/FINISHED`、`TAB_SHOWN/HIDDEN` | 适合 | 是，E01 | 打开本地基础页面与状态码页面，验证 callback 记录链路 | `CustomTabsCallback`、UI/Logcat/CSV 三路记录 | `/basic`, `/status/200`, `/status/404-empty`, `/status/404-body` | events.csv、Logcat、截图 | 低 | 高 |
| M03 | Status/body callback oracle | Sec. 3.4.1 | 4xx/5xx empty body 会额外触发 `NAVIGATION_FAILED`，非空 body 或 2xx/3xx 通常只 finish | 适合 | 是，E01/E02 | 比较 200、404 empty、404 body callback sequence | 记录 event_name/event_code/timestamp/url | `/status/200`, `/status/404-empty`, `/status/404-body` | sequence 对比表、events.csv | 低 | 高 |
| M04 | Redirect callback oracle | Sec. 3.4.1 | HTML/JS redirect 可能产生两组 start/finish，HTTP 3xx 通常只产生初始 start/finish | 适合 | 是，E02 | 本地 HTTP 302 与 HTML meta/JS redirect 对比 | 多次打开 endpoint，记录完整 sequence | `/redirect/http`, `/redirect/html` | events.csv、timing 表、截图 | 低 | 高 |
| M05 | Download callback oracle | Sec. 3.4.1 | 下载资源触发 `NAVIGATION_ABORTED`，不触发 `NAVIGATION_FINISHED` | 适合 | 是，E02 | 本地 attachment 下载 | 记录 aborted/finished 差异 | `/download` | events.csv、Logcat、下载提示截图 | 低到中 | 中高 |
| M06 | Content-Type callback oracle | Sec. 3.4.1 | `video/mp4`、`audio/mpeg`、`application/pdf` 等可能触发 `NAVIGATION_ABORTED` | 适合 | 是，E02 | 本地 PDF 响应 | 记录 aborted/finished 差异 | `/content/pdf` | events.csv、截图 | 低 | 中高 |
| M07 | Timing side channel | Sec. 3.4.1, Fig. 5 | start-finish delta 可区分不同状态或缓存/计算路径 | 适合本地模拟 | 是，E02 | `/delay/1000` 与 `/delay/3000` 三次以上采样 | 记录 `timestamp_ms` 和 `relative_ms_from_launch` | `/delay/1000`, `/delay/3000` | timing 统计表、events.csv | 低 | 高 |
| M08 | HTTP Header Injection | Sec. 3.5, Sec. 3.5.1, Sec. 3.5.2, Table 2, Table 6, Table 7 | 旧版 Chromium 系 CT header value 未正确清洗换行，可注入非 approvelisted header | 不适合真实攻击复现 | E04 只做 negative result/安全模拟 | 现代浏览器 + 本地 echo，验证换行 header 不可利用或被拒绝 | 可选：受控 header 测试，不访问真实站 | 可选 `/headers/echo` | server.log、浏览器版本、negative result | 中到高 | 中 |
| M09 | SameSite Strict Cookie Bypass | Sec. 3.6, Sec. 4.2, Sec. 4.3, Table 2 | 旧版 CT 初始请求携带 `SameSite=Strict` cookie，后续已修复 | 不适合真实攻击复现 | E04 只做 negative result/安全模拟 | 本地 Strict cookie 设置与检查，记录现代浏览器行为 | 打开本地 CT、记录浏览器版本 | 可选 `/samesite/set`, `/samesite/check` | server.log、截图、版本信息 | 中 | 高 |
| M10 | Scroll Inference Attack | Sec. 3.7, Fig. 3, Table 2 | text fragment 自动滚动 + scroll extraCallback 推断页面字符串 | 不建议必做 | 可选观察 | 本地长页面中观察 `extraCallback`，不推断真实隐私 | 记录 `extraCallback` name/bundle 摘要 | 可选 `/long-page` | events.csv、截图 | 中 | 中 |
| M11 | Bottom Bar Info Leakage | Sec. 3.8.1, Fig. 4a, Table 2 | bottom bar click intent 可携带当前 URL，可能泄露 query/fragment | 不建议处理敏感 URL | 可选安全演示 | 本地中性页面，URL 不含敏感数据 | 可选 bottom bar 点击观察 | `/basic` 或本地中性页面 | 截图、说明 | 中 | 中 |
| M12 | Bottom Bar Phishing | Sec. 3.8.2, Fig. 4b, Table 2 | bottom bar 可伪装成网页 UI，利用真实页面信任锚诱导操作 | 不适合复现 | 不做攻击，只做报告分析 | 不伪造品牌，不构造账号密码输入，不诱导用户 | 无 | 无 | 报告文字分析 | 高 | 中 |

## 3. 实验矩阵

### E01_callback_baseline

| 字段 | 内容 |
|---|---|
| 论文依据 | Sec. 2.2；Sec. 3.4.1 status/body attack vector |
| Hypothesis | Custom Tabs 打开本地页面时，宿主 app 可以稳定记录基础 navigation callbacks；不同状态码/响应体可能产生不同 callback sequence。 |
| Endpoint | `/basic`, `/status/200`, `/status/404-empty`, `/status/404-body` |
| 变量 | status code、response body 是否为空 |
| Expected result | `/basic` 与 `/status/200` 至少出现 start/finish；`/status/404-empty` 可能出现 failed + finished；`/status/404-body` 可能只出现 finished。 |
| Evidence | `events.csv`、Logcat、截图、server.log |
| Limitation | 具体 callback 行为可能因 Chrome/Edge/Brave 版本变化；异常时必须回查 Sec. 3.4.1。 |
| 安全边界 | 仅访问 `http://10.0.2.2:8000/*`。 |

### E02_state_inference_oracle

| 字段 | 内容 |
|---|---|
| 论文依据 | Sec. 3.4.1；Fig. 5 |
| Hypothesis | redirect、download、Content-Type、delay 会造成可区分 callback sequence 或 timing 差异，可作为本地 callback oracle。 |
| Endpoint | `/redirect/http`, `/redirect/html`, `/download`, `/content/pdf`, `/delay/1000`, `/delay/3000` |
| 变量 | redirect 类型、content-disposition、content-type、server delay |
| Expected result | HTML redirect 比 HTTP redirect 多一组 navigation；download/PDF 可能出现 aborted；delay endpoint 的 start-finish delta 应随 delay 增大。 |
| Evidence | 每 endpoint 至少 3 次 `events.csv`、sequence 表、timing 表、Logcat、截图。 |
| Limitation | 现代浏览器可能改变 PDF/download 处理；需记录浏览器版本并回查 Sec. 3.4.1。 |
| 安全边界 | 不访问论文真实案例网站；只用本地 delay 和 mock content。 |

### E03_state_sharing_cookie

| 字段 | 内容 |
|---|---|
| 论文依据 | Sec. 2.1；Sec. 3.4；Sec. 4.1.2 |
| Hypothesis | 本地 demo cookie/session 会在底层浏览器与 CT 之间共享，导致 `/profile` 页面状态改变。 |
| Endpoint | `/login`, `/profile` |
| 变量 | demo cookie 是否存在 |
| Expected result | 访问 `/login` 前 `/profile` 显示未登录；访问 `/login` 设置 demo cookie 后 `/profile` 显示 logged-in demo 状态。 |
| Evidence | server.log 中 `cookie_present`、events.csv、截图、Logcat。 |
| Limitation | 不验证真实网站账号；cookie 清理方式与浏览器版本会影响复现。 |
| 安全边界 | cookie 值必须是 demo/test；server log 不记录 cookie 值。 |

### E04_modern_mitigation_negative

| 字段 | 内容 |
|---|---|
| 论文依据 | Sec. 3.5, Sec. 3.6, Sec. 4.2, Sec. 4.3, Table 2, Table 6, Table 7 |
| Hypothesis | 现代浏览器已修复或缓解 Header Injection 与 SameSite Strict Cookie Bypass，本项目主要记录 negative result 与 mitigation 分析。 |
| Endpoint | 可选 `/headers/echo`, `/samesite/set`, `/samesite/check` |
| 变量 | 浏览器包名/版本、header 值、SameSite 属性 |
| Expected result | Header Injection 不应可利用；SameSite Strict cookie 不应在不可信跨上下文场景中异常发送。 |
| Evidence | 浏览器版本、server.log、events.csv、截图、negative result 说明。 |
| Limitation | 不安装来源不明旧版浏览器；若行为异常，先回查论文再调整实验。 |
| 安全边界 | 不向真实站点发送 header/cookie 测试；不保存真实 cookie/token。 |

## 4. 推荐实验路线

1. 先完成 E01：建立 callback recorder 的可信证据链。
2. 再完成 E02：用本地 HTTP 行为展示 callback oracle 与 timing oracle。
3. 然后完成 E03：展示 state sharing 是 oracle 成立的状态基础。
4. 最后完成 E04：把高风险或已修复问题写成 negative result/mitigation analysis。

## 5. P03 Mock Server 实现状态

更新时间：2026-05-24

| Endpoint | 实现状态 | 对应实验 | 自测结果 |
|---|---|---|---|
| `/basic` | 已实现 | E01 | HTTP 200，`text/html; charset=utf-8` |
| `/status/200` | 已实现 | E01/E02 | HTTP 200，`text/html; charset=utf-8` |
| `/status/404-empty` | 已实现 | E01/E02 | HTTP 404，空响应体，`text/plain; charset=utf-8` |
| `/status/404-body` | 已实现 | E01/E02 | HTTP 404，非空 HTML 响应体 |
| `/redirect/http` | 已实现 | E02 | HTTP 302，`Location: /basic` |
| `/redirect/html` | 已实现 | E02 | HTTP 200，HTML meta refresh + JS redirect |
| `/content/pdf` | 已实现 | E02 | HTTP 200，`application/pdf` |
| `/download` | 已实现 | E02 | HTTP 200，`Content-Disposition: attachment` |
| `/delay/<ms>` | 已实现 | E02 | `/delay/100` 自测耗时约 0.103 秒；限制范围 0-10000 ms |
| `/login` | 已实现 | E03 | 设置本地 demo cookie；server log 不记录 cookie 值 |
| `/profile` | 已实现 | E03 | 无 cookie 显示 not logged in；有 demo cookie 显示 logged-in demo user |

Server log 已实现 CSV 写入，字段为 `timestamp,method,path,status,user_agent,cookie_present`。自测确认 `/profile` 在 login 前记录 `cookie_present=no`，login 后记录 `cookie_present=yes`，未记录 cookie 值。

## 6. 不进入本项目实现范围的内容

| 内容 | 原因 | 处理方式 |
|---|---|---|
| 真实网站登录状态探测 | 涉及真实用户状态和隐私 | 只在报告中说明论文案例，不复现 |
| 真实 Header Injection 攻击 | 完整攻击具有完整性风险 | 只做本地 echo/negative result |
| 真实 SameSite 绕过 | 可能触发真实认证请求 | 只做本地 demo cookie/negative result |
| 真实 phishing 页面 | 违反安全边界 | 不做；只做 UI 风险文字分析 |
| 旧版浏览器攻击验证 | 来源和环境风险高 | 不安装来源不明 APK；以现代 mitigation 为主 |
| 真实 URL query/fragment 泄露 | 可能包含 PII/token | 只使用本地中性 URL |
