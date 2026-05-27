## 2026-05-27 P08 E03_state_sharing_cookie

### Run

`experiments/E03_state_sharing_cookie/run_20260527_181001/`

### 执行结果

已完成本地 demo cookie 状态共享实验。最终有效流程使用 `http://198.18.0.1:8000`：

| Step | Endpoint | 上下文 | `cookie_present` |
|---|---|---|---|
| reset | `/logout` | Custom Tab | yes，随后清理 |
| before | `/profile` | Custom Tab | no |
| login | `/login` | Custom Tab | no |
| after_ct | `/profile` | Custom Tab | yes |
| after_browser | `/profile` | Chrome 浏览器 | yes |

### 证据路径

- `experiments/E03_state_sharing_cookie/run_20260527_181001/commands.md`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/server.log`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/logcat_ct_repro.txt`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/data/events.csv`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/screenshots/e03_final_ct_profile_before.png`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/screenshots/e03_final_ct_profile_after.png`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/screenshots/e03_final_browser_profile_after.png`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/observations.md`

### 结论

E03 已完成。Custom Tab 中 `/login` 设置的本地 demo cookie 会影响随后 Custom Tab 和普通 Chrome 浏览器访问 `/profile` 的状态，server log 仅记录 `cookie_present=yes/no`，未记录 cookie 值。
