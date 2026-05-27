# E02 sequence/timing summary

| Endpoint | 次数 | 主要 callback sequence | 终止事件统计 | 首个终止平均 ms | 最后终止平均 ms | 最后终止 min-max ms |
|---|---:|---|---|---:|---:|---:|
| `content_pdf` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 97.7 | 97.7 | 82-114 |
| `delay_1000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 1027 | 1027 | 1012-1050 |
| `delay_3000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 3020 | 3020 | 3020-3020 |
| `download` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 91.7 | 91.7 | 70-103 |
| `redirect_html` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> NAVIGATION_STARTED -> NAVIGATION_ABORTED -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 55.3 | 258 | 219-320 |
| `redirect_http` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 245 | 245 | 123-458 |

## 单次 timing 表

| Endpoint | Trial | 首个终止事件 | 首个终止 delta_ms | 最后终止事件 | 最后终止 delta_ms |
|---|---|---|---:|---|---:|
| `content_pdf` | `content_pdf_ok_t1` | `NAVIGATION_ABORTED` | 114 | `NAVIGATION_ABORTED` | 114 |
| `content_pdf` | `content_pdf_ok_t2` | `NAVIGATION_ABORTED` | 97 | `NAVIGATION_ABORTED` | 97 |
| `content_pdf` | `content_pdf_ok_t3` | `NAVIGATION_ABORTED` | 82 | `NAVIGATION_ABORTED` | 82 |
| `delay_1000` | `delay_1000_ok_t1` | `NAVIGATION_FINISHED` | 1050 | `NAVIGATION_FINISHED` | 1050 |
| `delay_1000` | `delay_1000_ok_t2` | `NAVIGATION_FINISHED` | 1012 | `NAVIGATION_FINISHED` | 1012 |
| `delay_1000` | `delay_1000_ok_t3` | `NAVIGATION_FINISHED` | 1019 | `NAVIGATION_FINISHED` | 1019 |
| `delay_3000` | `delay_3000_ok_t1` | `NAVIGATION_FINISHED` | 3020 | `NAVIGATION_FINISHED` | 3020 |
| `delay_3000` | `delay_3000_ok_t2` | `NAVIGATION_FINISHED` | 3020 | `NAVIGATION_FINISHED` | 3020 |
| `delay_3000` | `delay_3000_ok_t3` | `NAVIGATION_FINISHED` | 3020 | `NAVIGATION_FINISHED` | 3020 |
| `download` | `download_ok_t1` | `NAVIGATION_ABORTED` | 102 | `NAVIGATION_ABORTED` | 102 |
| `download` | `download_ok_t2` | `NAVIGATION_ABORTED` | 70 | `NAVIGATION_ABORTED` | 70 |
| `download` | `download_ok_t3` | `NAVIGATION_ABORTED` | 103 | `NAVIGATION_ABORTED` | 103 |
| `redirect_html` | `redirect_html_ok_t1` | `NAVIGATION_FINISHED` | 58 | `NAVIGATION_FINISHED` | 320 |
| `redirect_html` | `redirect_html_ok_t2` | `NAVIGATION_FINISHED` | 48 | `NAVIGATION_FINISHED` | 235 |
| `redirect_html` | `redirect_html_ok_t3` | `NAVIGATION_FINISHED` | 60 | `NAVIGATION_FINISHED` | 219 |
| `redirect_http` | `redirect_http_ok_t1` | `NAVIGATION_FINISHED` | 458 | `NAVIGATION_FINISHED` | 458 |
| `redirect_http` | `redirect_http_ok_t2` | `NAVIGATION_FINISHED` | 123 | `NAVIGATION_FINISHED` | 123 |
| `redirect_http` | `redirect_http_ok_t3` | `NAVIGATION_FINISHED` | 154 | `NAVIGATION_FINISHED` | 154 |
