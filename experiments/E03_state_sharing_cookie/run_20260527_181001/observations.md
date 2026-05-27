# E03_state_sharing_cookie 运行观察

## 实验目的

验证本地 demo cookie/session 在 Chrome Custom Tab 与底层 Chrome 浏览器之间共享的现象。实验只使用本地 mock server，不使用真实账号，不记录 cookie 值，只记录 `cookie_present=yes/no`。

## Hypothesis

如果 Custom Tab 与 Chrome 共享底层浏览器状态，则在 Custom Tab 中访问 `/login` 设置本地 demo cookie 后：

- Custom Tab 再访问 `/profile` 时，server log 应显示 `cookie_present=yes`。
- 普通 Chrome 浏览器再访问同一 host 的 `/profile` 时，server log 也应显示 `cookie_present=yes`。

## 环境

- 模拟器：LDPlayer，ADB 路径 `F:\Mobile Security\env\leidian\LDPlayer9\adb.exe`
- Android：Android 9 API 28
- 浏览器：Chrome `com.android.chrome`，版本 `138.0.7204.179`
- Custom Tabs service：`com.android.chrome/org.chromium.chrome.browser.customtabs.CustomTabsConnectionService`
- server：Flask mock server，监听 `0.0.0.0:8000`
- 有效访问地址：`http://198.18.0.1:8000`

## 命令

完整命令见 `commands.md`。最终有效流程：

1. Custom Tab 访问 `/logout`，清理本地 demo cookie。
2. Custom Tab 访问 `/profile`，记录未登录状态。
3. Custom Tab 访问 `/login`，设置本地 demo cookie。
4. Custom Tab 再访问 `/profile`，记录 logged-in demo 状态。
5. 普通 Chrome 浏览器访问 `/profile`，验证浏览器侧也能看到同一 demo 状态。

## Expected result

server log 只记录 `cookie_present`，不记录 cookie 值。预期序列：

| Step | Endpoint | 访问上下文 | 预期 `cookie_present` |
|---|---|---|---|
| reset | `/logout` | Custom Tab | 可能为 yes，随后清理 |
| before | `/profile` | Custom Tab | no |
| login | `/login` | Custom Tab | no |
| after_ct | `/profile` | Custom Tab | yes |
| after_browser | `/profile` | Chrome 浏览器 | yes |

## Observed result

最终有效 server log：

| 时间 | Endpoint | 上下文 | `cookie_present` | 说明 |
|---|---|---|---|---|
| 2026-05-27 18:18:31 | `/logout` | Custom Tab / Chrome UA | yes | 访问 reset endpoint 时仍带旧 demo cookie，随后删除 |
| 2026-05-27 18:18:31 | `/favicon.ico` | Chrome UA | no | reset 后 favicon 请求已不带 demo cookie |
| 2026-05-27 18:18:41 | `/profile` | Custom Tab / Chrome UA | no | login 前未登录状态 |
| 2026-05-27 18:18:52 | `/login` | Custom Tab / Chrome UA | no | 设置本地 demo cookie，未记录 cookie 值 |
| 2026-05-27 18:19:03 | `/profile` | Custom Tab / Chrome UA | yes | Custom Tab 中可见 logged-in demo 状态 |
| 2026-05-27 18:19:13 | `/profile` | 普通 Chrome / Chrome UA | yes | 普通浏览器共享同一 demo cookie 状态 |

app 侧 `events.csv` 显示 `/logout`、`/profile before`、`/login`、`/profile after` 均通过 `com.android.chrome` Custom Tabs service 打开，并记录了 `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` 序列。

## 证据路径

- 命令记录：`experiments/E03_state_sharing_cookie/run_20260527_181001/commands.md`
- server log：`experiments/E03_state_sharing_cookie/run_20260527_181001/server.log`
- 完整 logcat：`experiments/E03_state_sharing_cookie/run_20260527_181001/logcat_full.txt`
- CT_REPRO logcat：`experiments/E03_state_sharing_cookie/run_20260527_181001/logcat_ct_repro.txt`
- 合并 CSV：`experiments/E03_state_sharing_cookie/run_20260527_181001/data/events.csv`
- 单步 CSV：
  - `data/events_final_ct_logout_reset.csv`
  - `data/events_final_ct_profile_before.csv`
  - `data/events_final_ct_login.csv`
  - `data/events_final_ct_profile_after.csv`
- 截图：
  - `screenshots/e03_final_ct_logout_reset.png`
  - `screenshots/e03_final_ct_profile_before.png`
  - `screenshots/e03_final_ct_login.png`
  - `screenshots/e03_final_ct_profile_after.png`
  - `screenshots/e03_final_browser_profile_after.png`

## 与论文机制的对应关系

论文 Sec. 2.1 指出 Custom Tabs 复用底层浏览器状态，包括 cookies；Sec. 3.4 / Sec. 4.1.2 进一步讨论该共享状态可成为 state inference 的基础。本实验用本地 demo cookie 安全复现“状态共享”这一前提，不访问真实网站，不读取或保存真实 cookie/token/账号数据。

## 不一致原因与实验修正

- 初次 E03 运行时旧 E02 server 仍占用端口，导致 E03 请求写入了 E02 的 `server.log`。已停止旧 server 并重启当前 run server。
- 尝试用 `172.16.1.1` 避免既有 cookie 状态，但该地址只 ICMP 可达，Chrome HTTP 请求没有进入 Flask，因此不作为最终证据。
- 为了可靠重置本地 demo 状态，新增 `/logout` endpoint，只删除 demo cookie，不记录 cookie 值。

## Limitation

- 本实验只证明本地 demo cookie 在 Chrome Custom Tab 与普通 Chrome 间共享，不涉及真实站点登录态。
- `server.log` 不记录 query string，因此上下文判断依赖命令记录、截图文件名和时间顺序。
- Chrome User-Agent 显示 Android 10，而 app 侧系统字段为 Android 9 API 28；这是 Chrome UA 字符串差异，不影响 cookie 状态共享判断。

## 结论

E03_state_sharing_cookie 已完成。最终证据显示：Custom Tab 中 `/login` 设置的本地 demo cookie 使 Custom Tab `/profile` 变为 `cookie_present=yes`，随后普通 Chrome 浏览器访问 `/profile` 也为 `cookie_present=yes`。这支持“Custom Tab 与底层浏览器共享状态”的本地安全复现结论。
