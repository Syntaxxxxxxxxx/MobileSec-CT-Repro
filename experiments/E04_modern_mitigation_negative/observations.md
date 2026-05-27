## 2026-05-27 P09 E04_modern_mitigation_negative

### Run

`experiments/E04_modern_mitigation_negative/run_20260527_182908/`

### 执行结果

已使用现代 Chrome `com.android.chrome 138.0.7204.179` 完成本地 negative result / 安全模拟。

| 测试项 | 观察结果 | 结论 |
|---|---|---|
| SameSite Strict control | set 后 favicon 子请求可见 `strict_cookie_present=yes`，说明 Strict demo cookie 已设置 | 检测有效，未记录 cookie 值 |
| SameSite Strict 主文档 check | `/samesite/check` 主请求 `strict_cookie_present=no` | 现代 Chrome 未在初始主文档导航异常发送 Strict cookie |
| SameSite cross redirect | `10.12.173.13` -> `198.18.0.1` 目标 check 为 `strict_cookie_present=no` | 未复现 SameSite Strict bypass |
| Custom Tab direct check | CT 打开 `/samesite/check` 为 `strict_cookie_present=no` | native app CT 初始请求未异常携带 Strict cookie |
| Header CRLF probe | URL query 中 `%0D%0A X-CT-Repro-Injected` 未生成 header，`injected_header_present=no` | 未复现 Header Injection |
| Header control | PowerShell 显式 header 请求为 `injected_header_present=yes` | server 检测逻辑有效 |

### 证据路径

- `experiments/E04_modern_mitigation_negative/run_20260527_182908/commands.md`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/server.log`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/logcat_ct_repro.txt`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/data/events.csv`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/screenshots/`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/observations.md`

### 结论

E04 已完成。未安装不可信旧版浏览器，未访问真实网站；现代 Chrome 的本地观察结果作为 SameSite/Header Injection 相关问题的 mitigation / negative result。
