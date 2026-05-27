# E04_modern_mitigation_negative 运行观察

## 实验目的

记录现代 Chrome 对论文中 SameSite Strict Cookie Bypass 和 HTTP Header Injection 相关问题的 mitigation / negative result。实验只使用本地 mock server，不安装来源不明旧版浏览器，不访问真实网站，不记录 cookie/header 值。

## Hypothesis

- SameSite Strict：现代 Chrome 不应在来自本地跨 host redirect 或 native app Custom Tab 初始导航的主文档请求中异常发送 Strict demo cookie。
- Header Injection：把 CRLF 编码放入 URL query 不应变成真实 HTTP header；server 不应看到受控测试 header `X-CT-Repro-Injected`。

## 环境

- 模拟器：LDPlayer，ADB 路径 `F:\Mobile Security\env\leidian\LDPlayer9\adb.exe`
- Android：Android 9 API 28
- 浏览器：Chrome `com.android.chrome`，版本 `138.0.7204.179`
- Custom Tabs service：`com.android.chrome/org.chromium.chrome.browser.customtabs.CustomTabsConnectionService`
- server：Flask mock server，监听 `0.0.0.0:8000`
- 本地 host：`198.18.0.1:8000` 与 `10.12.173.13:8000`

## 本地安全 endpoint

- `/samesite/set`：设置本地 `SameSite=Strict` demo cookie。
- `/samesite/check`：只显示 Strict demo cookie 是否存在。
- `/samesite/clear`：清理 Strict demo cookie。
- `/samesite/cross-redirect`：从另一本地 host 302 到 `198.18.0.1:8000/samesite/check`。
- `/headers/echo`：只判断受控测试 header 是否存在，不回显敏感 header 值。

server log 只记录存在性字段：`cookie_present`、`strict_cookie_present`、`injected_header_present`，不记录 cookie/header 值。

## Observed result

| 测试项 | 请求 | 观察结果 | 结论 |
|---|---|---|---|
| SameSite clear | Chrome -> `/samesite/clear` | `strict_cookie_present=no` after favicon | Strict demo cookie 已清理 |
| SameSite set | Chrome -> `/samesite/set` | set 主请求为 `strict_cookie_present=no`，随后 favicon 为 `yes` | cookie 已设置，值未记录 |
| SameSite control check | Chrome -> `/samesite/check` | 主文档请求 `strict_cookie_present=no`，随后 favicon 为 `yes` | 现代 Chrome 对主文档初始导航未发送 Strict cookie；同站子请求可见 cookie |
| SameSite cross redirect | Chrome -> `10.12.173.13/samesite/cross-redirect` -> `198.18.0.1/samesite/check` | redirect 入口 `no`，目标 check 主请求 `strict_cookie_present=no` | 未复现 Strict cookie bypass |
| Custom Tab direct check | app CT -> `198.18.0.1/samesite/check` | 主请求 `strict_cookie_present=no` | native app 打开的 CT 初始请求未异常携带 Strict cookie |
| Header CRLF probe | app CT -> `/headers/echo?probe=line1%0D%0AX-CT-Repro-Injected:%20yes` | `injected_header_present=no` | URL 中 CRLF 编码未变成 HTTP header |
| Header CRLF probe | Chrome -> 同一 URL | `injected_header_present=no` | 普通 Chrome 同样未产生 header injection |
| Header detection control | PowerShell 本地请求显式设置 `X-CT-Repro-Injected` | `injected_header_present=yes` | server 检测逻辑有效，但未记录 header 值 |

## 证据路径

- 命令记录：`experiments/E04_modern_mitigation_negative/run_20260527_182908/commands.md`
- server log：`experiments/E04_modern_mitigation_negative/run_20260527_182908/server.log`
- 完整 logcat：`experiments/E04_modern_mitigation_negative/run_20260527_182908/logcat_full.txt`
- CT_REPRO logcat：`experiments/E04_modern_mitigation_negative/run_20260527_182908/logcat_ct_repro.txt`
- 合并 CSV：`experiments/E04_modern_mitigation_negative/run_20260527_182908/data/events.csv`
- 单步 CSV：
  - `data/events_ct_samesite_check_direct.csv`
  - `data/events_ct_header_crlf_probe.csv`
- 截图：
  - `screenshots/e04_browser_samesite_check_control.png`
  - `screenshots/e04_browser_samesite_cross_redirect.png`
  - `screenshots/e04_ct_samesite_check_direct.png`
  - `screenshots/e04_ct_header_crlf_probe.png`
  - `screenshots/e04_browser_header_crlf_probe.png`

## 与论文机制的对应关系

论文 Sec. 3.5 描述旧版 Chromium 系 Custom Tabs header value 换行清洗不足导致的 HTTP Header Injection；Table 6 / Table 7 和 Sec. 4.3 讨论相关修复。论文 Sec. 3.6 描述旧版 Custom Tabs 初始请求携带 `SameSite=Strict` cookie 的 bypass；Table 2 和 Sec. 4.3 指出 Chrome 109 之后相关问题已修复。

本地 Chrome `138.0.7204.179` 的观察结果与现代 mitigation 预期一致：未通过本地安全模拟复现 Header Injection 或 SameSite Strict bypass。

## Limitation

- 本实验没有安装旧版浏览器，因此不复现论文中的 vulnerable behavior，只记录现代 Chrome negative result。
- Header Injection 仅做 URL CRLF 安全模拟与检测控制；没有向真实站点或真实 header 注入目标发送请求。
- SameSite 模拟使用本地 IP host 与 redirect，不能等价覆盖所有 Web 攻击场景，但足以作为课程项目中的安全负结果证据。
- `cookie_present=yes` 字段可能来自 E03 的 Lax demo cookie 残留；E04 判断只使用 `strict_cookie_present`。

## 结论

E04_modern_mitigation_negative 已完成。现代 Chrome `138.0.7204.179` 在本地安全模拟中没有复现论文中的 SameSite Strict Cookie Bypass 或 HTTP Header Injection；结果应作为 modern mitigation / negative result 写入报告。
