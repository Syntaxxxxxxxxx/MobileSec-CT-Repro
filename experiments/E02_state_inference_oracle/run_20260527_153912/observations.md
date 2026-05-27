# E02_state_inference_oracle 运行观察

## 实验目的

验证不同本地 HTTP 行为是否产生可区分的 Chrome Custom Tabs callback 序列或 timing 差异，为论文中的 callback/timing oracle 机制提供安全、本地化复现证据。

## Hypothesis

- HTTP redirect 与 HTML/JS redirect 会产生不同 navigation callback 序列。
- `Content-Disposition: attachment` 下载与 `application/pdf` inline content 可能触发 `NAVIGATION_ABORTED`。
- `/delay/1000` 与 `/delay/3000` 的 `NAVIGATION_STARTED` 到终止事件耗时应接近服务端延迟差异。

## 环境

- 模拟器：LDPlayer，ADB 路径 `F:\Mobile Security\env\leidian\LDPlayer9\adb.exe`
- Android：Android 9 API 28
- 浏览器：Chrome `com.android.chrome`，版本 `138.0.7204.179`
- Custom Tabs service：`com.android.chrome/org.chromium.chrome.browser.customtabs.CustomTabsConnectionService`
- server：Flask mock server，监听 `0.0.0.0:8000`
- LDPlayer 访问宿主机地址：`http://198.18.0.1:8000`

## 命令

完整命令见 `commands.md`。本次每个 endpoint 有效运行 3 次：`/redirect/http`、`/redirect/html`、`/download`、`/content/pdf`、`/delay/1000`、`/delay/3000`。

注意：第一次自动化命令使用了 `?trial=...&run=...`，其中 `&` 被 Android shell 当作命令分隔符，导致远端报 `--ez: not found`，因此已保留为失败点并使用不含 `&` 的 URL 参数重新运行。最终统计只使用 `events_*_ok_t*.csv`。

## Expected result

- 每个 endpoint 至少 3 次有效运行并导出 CSV。
- 统计每个 endpoint 的 callback sequence。
- 统计 `NAVIGATION_STARTED` 到 `NAVIGATION_FINISHED` / `NAVIGATION_ABORTED` / `NAVIGATION_FAILED` 的时间差。
- 形成可写入报告的 Markdown 表格。

## Observed result

| Endpoint | 次数 | 主要 callback sequence | 终止事件统计 | 首个终止平均 ms | 最后终止平均 ms | 最后终止 min-max ms |
|---|---:|---|---|---:|---:|---:|
| `content_pdf` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 97.7 | 97.7 | 82-114 |
| `delay_1000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 1027 | 1027 | 1012-1050 |
| `delay_3000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 3020 | 3020 | 3020-3020 |
| `download` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 91.7 | 91.7 | 70-103 |
| `redirect_html` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> NAVIGATION_STARTED -> NAVIGATION_ABORTED -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 55.3 | 258 | 219-320 |
| `redirect_http` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 245 | 245 | 123-458 |

## 关键结论

- `/redirect/http`：表现为单段 `NAVIGATION_STARTED -> NAVIGATION_FINISHED`，平均最后终止耗时约 245 ms。
- `/redirect/html`：稳定出现多段 navigation：初始 HTML 页面 finish，随后 JS/meta redirect 过程出现一次 aborted，再进入 `/basic` finished；这与 HTTP redirect 明显可区分。
- `/download`：三次均为 `NAVIGATION_STARTED -> NAVIGATION_ABORTED`，平均约 91.7 ms。
- `/content/pdf`：三次均为 `NAVIGATION_STARTED -> NAVIGATION_ABORTED`，平均约 97.7 ms。
- `/delay/1000`：三次均 finish，平均约 1027 ms。
- `/delay/3000`：三次均 finish，平均约 3020 ms。

## 证据路径

- 命令记录：`experiments/E02_state_inference_oracle/run_20260527_153912/commands.md`
- server log：`experiments/E02_state_inference_oracle/run_20260527_153912/server.log`
- 完整 logcat：`experiments/E02_state_inference_oracle/run_20260527_153912/logcat_full.txt`
- CT_REPRO logcat：`experiments/E02_state_inference_oracle/run_20260527_153912/logcat_ct_repro.txt`
- 合并 CSV：`experiments/E02_state_inference_oracle/run_20260527_153912/data/events.csv`
- 单次 timing CSV：`experiments/E02_state_inference_oracle/run_20260527_153912/data/timing_summary.csv`
- 汇总 CSV：`experiments/E02_state_inference_oracle/run_20260527_153912/data/sequence_timing_summary.csv`
- Markdown 表格：`experiments/E02_state_inference_oracle/run_20260527_153912/data/summary_tables.md`
- 截图目录：`experiments/E02_state_inference_oracle/run_20260527_153912/screenshots/`

## 与论文机制的对应关系

本实验对应论文 Sec. 3.4 / Sec. 3.4.1 中将 Custom Tabs callback sequence 和 timing 差异作为 Cross-Context State Inference oracle 的机制。本地实验不访问真实网站，而是用 mock endpoint 安全模拟 redirect、download、content-type、delay 等响应行为，证明宿主 app 可以观察到可区分序列和时间差。

## Limitation

- 本次只使用本地 mock server，不验证真实网站状态。
- timing 受模拟器性能、Chrome 缓存、页面预热影响；更严谨的统计可增加 trial 数并清理 Chrome 缓存。
- `/redirect/html` 的 first terminal 与 last terminal 含义不同：first terminal 代表初始 HTML 页面，last terminal 更接近完整跳转链结束。
- 自动化中发现 URL `&` 会被远端 shell 截断，后续脚本应对 URL 做 shell quoting 或避免裸 `&`。

## 结论

E02_state_inference_oracle 已完成。redirect、download、PDF content-type 和 delay 均产生可区分 callback sequence 或 timing 差异，其中最稳定的本地 oracle 包括：HTML redirect 多段 navigation、download/PDF 的 `NAVIGATION_ABORTED`、以及 1000 ms / 3000 ms delay 的明显 timing 差异。
