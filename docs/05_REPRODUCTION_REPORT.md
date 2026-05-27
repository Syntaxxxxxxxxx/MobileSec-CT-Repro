# MobileSec-CT-Repro 中文复现报告

## 1. 论文背景

论文《Tabbed Out: Subverting the Android Custom Tab Security Model》研究 Android Custom Tabs 的安全边界。Custom Tabs 的设计目标是让 Android app 在不内嵌完整 WebView 的情况下，用系统浏览器渲染网页，同时保留浏览器已有的登录状态、cookie、权限、缓存等用户体验能力。

论文的核心安全观察有两点：

1. Custom Tabs 与底层浏览器共享状态。论文依据主要在 Sec. 2.1。
2. 宿主 app 可以通过 `CustomTabsCallback` 观察页面导航生命周期。论文依据主要在 Sec. 2.2。

二者结合后，宿主 app 可能通过 callback sequence 或 timing 差异推断 Web 侧状态。论文将这类现象用于 Cross-Context State Inference，并在 Sec. 3.4 / Sec. 3.4.1 中讨论 status、redirect、download、Content-Type、timing 等 oracle。Header Injection 和 SameSite Strict Cookie Bypass 分别来自 Sec. 3.5 与 Sec. 3.6；论文 Sec. 4.2 / Sec. 4.3 讨论了部分修复与缓解。

本项目不复现真实攻击链，而是把论文机制转化为本地安全靶场实验。

## 2. 复现目标

本项目目标是为移动应用安全课程期末考核构建可控复现实验，说明以下机制：

1. Custom Tabs callback 可以被宿主 app 记录。
2. 不同本地 HTTP 行为会产生可区分 callback sequence 或 timing 差异。
3. Custom Tab 与 Chrome 共享本地 demo cookie 状态。
4. 现代 Chrome 对论文中部分旧版浏览器问题表现为 negative result 或 mitigation。

本报告只声称本地安全复现结果，不声称复现真实网站攻击效果。

## 3. 安全边界

本项目严格遵守以下边界：

- 只访问本地 mock server。
- 不攻击真实网站。
- 不收集真实账号、真实密码、真实 token、真实 cookie 或真实隐私数据。
- cookie 只使用 demo/test 值。
- server log 不记录 cookie 值，只记录 `cookie_present`、`strict_cookie_present` 等是否存在。
- Header Injection 只做本地安全模拟，不向真实站点发送测试。
- SameSite 只做本地 demo cookie negative result，不使用真实认证站点。
- 不安装来源不明旧版浏览器。

## 4. 实验环境

| 项目 | 内容 |
|---|---|
| 操作系统 | Windows，本地工作目录 `D:\IEEE S&P` |
| 模拟器 | LDPlayer，ADB 路径 `F:\Mobile Security\env\leidian\LDPlayer9\adb.exe` |
| Android | app 侧记录为 Android 9 API 28 |
| 浏览器 | Chrome `com.android.chrome` |
| Chrome 版本 | `138.0.7204.179` |
| Custom Tabs service | `com.android.chrome/org.chromium.chrome.browser.customtabs.CustomTabsConnectionService` |
| 本地 server | Flask mock server，默认监听 `0.0.0.0:8000` |
| LDPlayer 访问宿主地址 | 主要使用 `http://198.18.0.1:8000` |
| Android app | Kotlin + `androidx.browser` Custom Tabs |
| Logcat tag | `CT_REPRO` |

环境证据：

- E01 CSV 中记录 Chrome 包名、版本和 Custom Tabs service：`experiments/E01_callback_baseline/run_20260527_152504/data/events.csv`
- E01 CT_REPRO logcat：`experiments/E01_callback_baseline/run_20260527_152504/logcat_ct_repro.txt`
- E04 server log 中记录 Chrome User-Agent：`experiments/E04_modern_mitigation_negative/run_20260527_182908/server.log`

## 5. 工程架构

项目由四部分构成：

- `server/`：本地 Flask mock server，提供 `/basic`、status、redirect、download、PDF、delay、demo cookie、SameSite、header echo 等 endpoint。
- `app/`：Android Kotlin 实验 app，通过 Custom Tabs 打开本地 URL，并记录 callback。
- `scripts/`：PowerShell 辅助脚本，用于构建、安装、采集 logcat、截图和 artifacts。
- `experiments/`：每个实验的 run 目录，保存 commands、server log、logcat、events.csv、截图和 observations。

关键实现文件：

- `server/app.py`
- `server/routes.md`
- `app/app/src/main/java/edu/mobilesec/ctrepro/MainActivity.kt`
- `app/app/src/main/java/edu/mobilesec/ctrepro/CtEvent.kt`
- `scripts/build_app.ps1`
- `scripts/install_app.ps1`
- `scripts/collect_logcat.ps1`
- `scripts/screenshot.ps1`

## 6. E01 callback baseline

### 6.1 目标

验证 Android app 能通过 Chrome Custom Tabs service 记录基础 callback，并比较 200、404 empty body、404 body 的 callback sequence。

最终有效 run：

```text
experiments/E01_callback_baseline/run_20260527_152504/
```

### 6.2 实验流程

1. 启动本地 Flask server。
2. 安装 Android 实验 app。
3. 确认 Chrome Custom Tabs provider 可用。
4. 分别打开：
   - `/basic`
   - `/status/200`
   - `/status/404-empty`
   - `/status/404-body`
5. 采集 `events.csv`、`logcat_ct_repro.txt`、`server.log` 和截图。

### 6.3 观察结果

| Endpoint | HTTP 状态 | 主要 callback 结论 |
|---|---:|---|
| `/basic` | 200 | `NAVIGATION_STARTED -> NAVIGATION_FINISHED` |
| `/status/200` | 200 | `NAVIGATION_STARTED -> NAVIGATION_FINISHED` |
| `/status/404-empty` | 404 | `NAVIGATION_STARTED -> NAVIGATION_FAILED -> NAVIGATION_FINISHED` |
| `/status/404-body` | 404 | `NAVIGATION_STARTED -> NAVIGATION_FINISHED` |

### 6.4 结论

E01 证明本地 app 可以通过 `CustomTabsCallback` 记录 Chrome Custom Tabs 的导航事件。`404-empty` 与 `404-body` 在 callback sequence 上可区分，可作为后续 oracle 分析的基础。

该结论的证据路径：

- 命令记录：`experiments/E01_callback_baseline/run_20260527_152504/commands.md`
- app 事件 CSV：`experiments/E01_callback_baseline/run_20260527_152504/data/events.csv`
- CT_REPRO logcat：`experiments/E01_callback_baseline/run_20260527_152504/logcat_ct_repro.txt`
- server log：`experiments/E01_callback_baseline/run_20260527_152504/server.log`
- 截图：
  - `experiments/E01_callback_baseline/run_20260527_152504/screenshots/e01_basic_localnet.png`
  - `experiments/E01_callback_baseline/run_20260527_152504/screenshots/e01_status_200_localnet.png`
  - `experiments/E01_callback_baseline/run_20260527_152504/screenshots/e01_status_404_empty_localnet.png`
  - `experiments/E01_callback_baseline/run_20260527_152504/screenshots/e01_status_404_body_localnet.png`
- 观察记录：`experiments/E01_callback_baseline/run_20260527_152504/observations.md`

## 7. E02 callback oracle

### 7.1 目标

验证 redirect、download、Content-Type、delay 等不同本地 HTTP 行为是否产生可区分 callback sequence 或 timing 差异。

最终有效 run：

```text
experiments/E02_state_inference_oracle/run_20260527_153912/
```

### 7.2 实验流程

每个 endpoint 至少运行 3 次：

- `/redirect/http`
- `/redirect/html`
- `/download`
- `/content/pdf`
- `/delay/1000`
- `/delay/3000`

统计 `NAVIGATION_STARTED` 到终止事件的时间差。终止事件包括 `NAVIGATION_FINISHED`、`NAVIGATION_ABORTED`、`NAVIGATION_FAILED`。

### 7.3 汇总结果

| Endpoint | 次数 | 主要 callback sequence | 终止事件统计 | 首个终止平均 ms | 最后终止平均 ms | 最后终止 min-max ms |
|---|---:|---|---|---:|---:|---:|
| `content_pdf` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 97.7 | 97.7 | 82-114 |
| `delay_1000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 1027 | 1027 | 1012-1050 |
| `delay_3000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 3020 | 3020 | 3020-3020 |
| `download` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 91.7 | 91.7 | 70-103 |
| `redirect_html` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> NAVIGATION_STARTED -> NAVIGATION_ABORTED -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 55.3 | 258 | 219-320 |
| `redirect_http` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 245 | 245 | 123-458 |

### 7.4 结论

E02 证明本地 redirect、download、PDF content-type 和 delay 行为能产生可区分的 callback sequence 或 timing 差异：

- HTTP redirect 与 HTML/JS redirect 可区分。
- download 与 PDF 均稳定触发 `NAVIGATION_ABORTED`。
- `/delay/1000` 与 `/delay/3000` 的 timing 差异明显。

这些结果支持论文 Sec. 3.4 / Sec. 3.4.1 中 callback sequence/timing 可作为 oracle 的机制，但本项目只验证本地 mock endpoint，不推断真实网站状态。

该结论的证据路径：

- 命令记录：`experiments/E02_state_inference_oracle/run_20260527_153912/commands.md`
- app 事件 CSV：`experiments/E02_state_inference_oracle/run_20260527_153912/data/events.csv`
- timing 汇总：`experiments/E02_state_inference_oracle/run_20260527_153912/data/timing_summary.csv`
- sequence/timing 汇总：`experiments/E02_state_inference_oracle/run_20260527_153912/data/sequence_timing_summary.csv`
- Markdown 表格：`experiments/E02_state_inference_oracle/run_20260527_153912/data/summary_tables.md`
- CT_REPRO logcat：`experiments/E02_state_inference_oracle/run_20260527_153912/logcat_ct_repro.txt`
- server log：`experiments/E02_state_inference_oracle/run_20260527_153912/server.log`
- 截图目录：`experiments/E02_state_inference_oracle/run_20260527_153912/screenshots/`
- 观察记录：`experiments/E02_state_inference_oracle/run_20260527_153912/observations.md`

### 7.5 执行问题

第一次 E02 自动化 URL 使用了 `?trial=...&run=...`，其中 `&` 被 Android shell 当作命令分隔符，导致远端报 `--ez: not found`。最终统计只使用修正后的 `events_*_ok_t*.csv`。

证据路径：

- 命令记录：`experiments/E02_state_inference_oracle/run_20260527_153912/commands.md`
- 修正后 CSV：`experiments/E02_state_inference_oracle/run_20260527_153912/data/events.csv`

## 8. E03 state sharing cookie

### 8.1 目标

使用本地 demo cookie 验证 Custom Tab 与普通 Chrome 浏览器共享状态。实验不使用真实账号，不记录 cookie 值。

最终有效 run：

```text
experiments/E03_state_sharing_cookie/run_20260527_181001/
```

### 8.2 实验流程

1. Custom Tab 访问 `/logout`，清理本地 demo cookie。
2. Custom Tab 访问 `/profile`，记录未登录状态。
3. Custom Tab 访问 `/login`，设置本地 demo cookie。
4. Custom Tab 再访问 `/profile`，记录 logged-in demo 状态。
5. 普通 Chrome 浏览器访问 `/profile`，验证浏览器侧也能看到同一 demo 状态。

### 8.3 观察结果

| Step | Endpoint | 上下文 | `cookie_present` |
|---|---|---|---|
| reset | `/logout` | Custom Tab | yes，随后清理 |
| before | `/profile` | Custom Tab | no |
| login | `/login` | Custom Tab | no |
| after_ct | `/profile` | Custom Tab | yes |
| after_browser | `/profile` | Chrome 浏览器 | yes |

### 8.4 结论

E03 证明本地 demo cookie 在 Chrome Custom Tab 与普通 Chrome 浏览器之间共享。Custom Tab 中 `/login` 设置 demo cookie 后，Custom Tab 和普通 Chrome 再访问 `/profile` 均表现为 `cookie_present=yes`。

这支持论文 Sec. 2.1 中 Custom Tabs 复用底层浏览器状态的机制，但本项目没有读取或保存 cookie 值，也没有使用真实登录态。

该结论的证据路径：

- 命令记录：`experiments/E03_state_sharing_cookie/run_20260527_181001/commands.md`
- server log：`experiments/E03_state_sharing_cookie/run_20260527_181001/server.log`
- app 事件 CSV：`experiments/E03_state_sharing_cookie/run_20260527_181001/data/events.csv`
- CT_REPRO logcat：`experiments/E03_state_sharing_cookie/run_20260527_181001/logcat_ct_repro.txt`
- 截图：
  - `experiments/E03_state_sharing_cookie/run_20260527_181001/screenshots/e03_final_ct_profile_before.png`
  - `experiments/E03_state_sharing_cookie/run_20260527_181001/screenshots/e03_final_ct_profile_after.png`
  - `experiments/E03_state_sharing_cookie/run_20260527_181001/screenshots/e03_final_browser_profile_after.png`
- 观察记录：`experiments/E03_state_sharing_cookie/run_20260527_181001/observations.md`

### 8.5 执行问题

E03 初次运行时旧 E02 server 仍占用端口，导致请求写入 E02 的 `server.log`。已停止旧 server，并在 E03 run 目录重新启动 server。后续为了可靠重置本地状态，新增 `/logout` endpoint，只删除本地 demo cookie，不记录 cookie 值。

证据路径：

- E03 观察记录：`experiments/E03_state_sharing_cookie/run_20260527_181001/observations.md`
- server 实现：`server/app.py`
- routes 文档：`server/routes.md`

## 9. E04 mitigation / negative result

### 9.1 目标

记录现代 Chrome 对论文中 SameSite Strict Cookie Bypass 与 HTTP Header Injection 相关问题的 mitigation / negative result。本实验只做本地安全模拟。

最终有效 run：

```text
experiments/E04_modern_mitigation_negative/run_20260527_182908/
```

### 9.2 本地安全 endpoint

- `/samesite/set`：设置本地 `SameSite=Strict` demo cookie。
- `/samesite/check`：只显示 Strict demo cookie 是否存在。
- `/samesite/clear`：清理 Strict demo cookie。
- `/samesite/cross-redirect`：从另一本地 host 302 到 `198.18.0.1:8000/samesite/check`。
- `/headers/echo`：只判断受控测试 header 是否存在，不回显敏感 header 值。

server log 字段包括：

- `cookie_present`
- `strict_cookie_present`
- `injected_header_present`

不记录 cookie 值或 header 值。

### 9.3 观察结果

| 测试项 | 观察结果 | 结论 |
|---|---|---|
| SameSite Strict control | set 后 favicon 子请求可见 `strict_cookie_present=yes` | Strict demo cookie 已设置，检测有效 |
| SameSite Strict 主文档 check | `/samesite/check` 主请求 `strict_cookie_present=no` | 现代 Chrome 未在初始主文档导航异常发送 Strict cookie |
| SameSite cross redirect | `10.12.173.13` -> `198.18.0.1` 目标 check 为 `strict_cookie_present=no` | 未复现 SameSite Strict bypass |
| Custom Tab direct check | CT 打开 `/samesite/check` 为 `strict_cookie_present=no` | native app CT 初始请求未异常携带 Strict cookie |
| Header CRLF probe | URL query 中 `%0D%0A X-CT-Repro-Injected` 未生成 header，`injected_header_present=no` | 未复现 Header Injection |
| Header control | PowerShell 显式 header 请求为 `injected_header_present=yes` | server 检测逻辑有效 |

### 9.4 结论

E04 未在 Chrome `138.0.7204.179` 中复现论文描述的 SameSite Strict Cookie Bypass 或 Header Injection。结果应记录为现代浏览器 mitigation / negative result。

该结论对应论文 Sec. 3.5、Sec. 3.6 与 Sec. 4.3。由于本项目没有安装旧版浏览器，因此不声称复现论文 vulnerable behavior，只说明现代 Chrome 在本地安全模拟下没有表现出这些旧问题。

该结论的证据路径：

- 命令记录：`experiments/E04_modern_mitigation_negative/run_20260527_182908/commands.md`
- server log：`experiments/E04_modern_mitigation_negative/run_20260527_182908/server.log`
- app 事件 CSV：`experiments/E04_modern_mitigation_negative/run_20260527_182908/data/events.csv`
- CT_REPRO logcat：`experiments/E04_modern_mitigation_negative/run_20260527_182908/logcat_ct_repro.txt`
- 截图：
  - `experiments/E04_modern_mitigation_negative/run_20260527_182908/screenshots/e04_browser_samesite_check_control.png`
  - `experiments/E04_modern_mitigation_negative/run_20260527_182908/screenshots/e04_browser_samesite_cross_redirect.png`
  - `experiments/E04_modern_mitigation_negative/run_20260527_182908/screenshots/e04_ct_samesite_check_direct.png`
  - `experiments/E04_modern_mitigation_negative/run_20260527_182908/screenshots/e04_ct_header_crlf_probe.png`
  - `experiments/E04_modern_mitigation_negative/run_20260527_182908/screenshots/e04_browser_header_crlf_probe.png`
- 观察记录：`experiments/E04_modern_mitigation_negative/run_20260527_182908/observations.md`

## 10. 复现问题与修复

| 问题 | 影响 | 处理方式 | 证据路径 |
|---|---|---|---|
| 复制到项目 `env/leidian` 的 LDPlayer 不稳定 | 无法稳定 adb 连接 | 改用原路径 `F:\Mobile Security\env\leidian\LDPlayer9\adb.exe` | `experiments/E01_callback_baseline/run_20260525_225429/observations.md` |
| 初始 LDPlayer 无 Chrome Custom Tabs provider | E01 只能得到 `BROWSER_NOT_FOUND -> LAUNCH_SKIPPED` | 安装 Chrome 后重新运行 E01 | `experiments/E01_callback_baseline/run_20260525_230617/observations.md`，`experiments/E01_callback_baseline/run_20260527_152504/observations.md` |
| Android 全局代理影响本地 server 访问 | Chrome CT 访问本地 endpoint 失败 | 清除 `http_proxy` 后复跑 | `experiments/E01_callback_baseline/run_20260527_152504/observations.md` |
| LDPlayer 不适用 `10.0.2.2` | Android 无法访问宿主 server | 使用 `198.18.0.1:8000` | `experiments/E01_callback_baseline/run_20260527_152504/observations.md` |
| E02 URL 中裸 `&` 被 shell 解释 | 部分 trial 未 auto-launch | 改用无裸 `&` 的 URL 参数并重新运行 | `experiments/E02_state_inference_oracle/run_20260527_153912/commands.md` |
| E03 旧 server 占用端口 | server log 写入错误 run | 停止旧 server，重启当前 run server | `experiments/E03_state_sharing_cookie/run_20260527_181001/observations.md` |
| E03 需要可重置 demo 状态 | 可能受历史 cookie 影响 | 新增 `/logout` 清理 demo cookie | `server/app.py`，`server/routes.md` |

## 11. 与论文结果的一致性和差异

### 一致性

1. 论文 Sec. 2.2：Custom Tabs callback 可由宿主 app 观察。  
   本地证据：E01/E02/E03/E04 的 `events.csv` 与 `logcat_ct_repro.txt` 均记录到 Chrome Custom Tabs callback。

2. 论文 Sec. 3.4 / Sec. 3.4.1：不同响应行为可形成 callback/timing oracle。  
   本地证据：E01 的 `404-empty` 与 `404-body` 差异，E02 的 redirect、download、PDF、delay 汇总表。

3. 论文 Sec. 2.1：Custom Tabs 共享底层浏览器状态。  
   本地证据：E03 中 Custom Tab `/login` 后，普通 Chrome `/profile` 为 `cookie_present=yes`。

4. 论文 Sec. 4.3：现代浏览器对部分旧漏洞已有修复。  
   本地证据：E04 中 Chrome 138 未复现 SameSite Strict bypass 和 Header Injection。

### 差异

1. 本项目不复现真实网站攻击，只复现本地机制。  
   证据：所有 server log 均来自 `server/app.py` 本地 endpoint，实验路径在 `experiments/E*/run_*`。

2. 本项目不安装旧版浏览器，因此 E04 只记录 modern negative result。  
   证据：E04 记录浏览器为 Chrome `138.0.7204.179`，见 `experiments/E04_modern_mitigation_negative/run_20260527_182908/data/events.csv`。

3. SameSite Strict 的本地模拟不能覆盖所有真实 Web 场景。  
   证据：E04 observations 中明确标注 limitation，见 `experiments/E04_modern_mitigation_negative/run_20260527_182908/observations.md`。

## 12. 局限性

- 实验环境是 LDPlayer + Chrome 138，不代表所有 Android 设备或浏览器。
- 所有 Web 目标都是本地 mock endpoint，不代表真实网站行为。
- timing 结果受模拟器性能、Chrome 缓存、预热状态影响。
- E04 不安装旧版浏览器，因此不能复现论文中的 vulnerable versions，只能记录现代 negative result。
- server log 不记录 query string，因此部分 step 需要结合 commands、截图文件名和时间顺序解释。
- Chrome User-Agent 显示 Android 10，而 app 侧记录 Android 9 API 28；这是 UA 字符串与系统 API 记录的差异，不影响 callback 结论。

## 13. 总结

本项目完成了 E01-E04 的本地安全复现实验：

| 实验 | 结论 | 证据入口 |
|---|---|---|
| E01 callback baseline | app 可以记录 Chrome Custom Tabs callback；`404-empty` 与 `404-body` 可区分 | `experiments/E01_callback_baseline/run_20260527_152504/observations.md` |
| E02 state inference oracle | redirect、download、PDF、delay 产生可区分 sequence 或 timing | `experiments/E02_state_inference_oracle/run_20260527_153912/observations.md` |
| E03 state sharing cookie | Custom Tab 与普通 Chrome 共享本地 demo cookie 状态 | `experiments/E03_state_sharing_cookie/run_20260527_181001/observations.md` |
| E04 modern mitigation negative | Chrome 138 未复现 SameSite Strict bypass 或 Header Injection | `experiments/E04_modern_mitigation_negative/run_20260527_182908/observations.md` |

最终结论：本项目成功复现了论文中 Custom Tabs state sharing、navigation callback 和 callback/timing oracle 的本地机制；对 SameSite Strict Cookie Bypass 与 Header Injection 只得到现代 Chrome 的 negative result。所有实验均限定在本地 mock server 和模拟器环境内，没有攻击真实网站，也没有收集真实敏感数据。
