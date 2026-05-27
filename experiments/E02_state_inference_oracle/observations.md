## 2026-05-27 P07 E02_state_inference_oracle

### Run

`experiments/E02_state_inference_oracle/run_20260527_153912/`

### 执行结果

已对 `/redirect/http`、`/redirect/html`、`/download`、`/content/pdf`、`/delay/1000`、`/delay/3000` 各运行 3 次，并采集 `events.csv`、server log、logcat、截图和统计表。

### 汇总表

| Endpoint | 次数 | 主要 callback sequence | 终止事件统计 | 首个终止平均 ms | 最后终止平均 ms | 最后终止 min-max ms |
|---|---:|---|---|---:|---:|---:|
| `content_pdf` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 97.7 | 97.7 | 82-114 |
| `delay_1000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 1027 | 1027 | 1012-1050 |
| `delay_3000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 3020 | 3020 | 3020-3020 |
| `download` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 91.7 | 91.7 | 70-103 |
| `redirect_html` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> NAVIGATION_STARTED -> NAVIGATION_ABORTED -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 55.3 | 258 | 219-320 |
| `redirect_http` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 245 | 245 | 123-458 |

### 关键观察

- HTTP redirect 表现为单段 navigation finished。
- HTML/meta/JS redirect 稳定产生多段 navigation，包含中间 `NAVIGATION_ABORTED`。
- download 与 PDF content-type 均稳定触发快速 `NAVIGATION_ABORTED`。
- `/delay/1000` 与 `/delay/3000` 的平均耗时分别约 1027 ms 和 3020 ms，timing oracle 明显。

### 证据路径

- `experiments/E02_state_inference_oracle/run_20260527_153912/commands.md`
- `experiments/E02_state_inference_oracle/run_20260527_153912/server.log`
- `experiments/E02_state_inference_oracle/run_20260527_153912/logcat_ct_repro.txt`
- `experiments/E02_state_inference_oracle/run_20260527_153912/data/events.csv`
- `experiments/E02_state_inference_oracle/run_20260527_153912/data/summary_tables.md`
- `experiments/E02_state_inference_oracle/run_20260527_153912/observations.md`

### 结论

E02 已完成。结果支持论文 Sec. 3.4 / Sec. 3.4.1 中 callback sequence/timing 可作为 oracle 的机制，但本项目仅使用本地 mock endpoint，不访问真实网站。
