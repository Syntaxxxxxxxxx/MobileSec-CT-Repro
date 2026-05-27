# E01_callback_baseline 运行观察

## 实验目的

验证在已安装 Chrome 的 LDPlayer 环境中，本地 Android Kotlin app 能否通过 `CustomTabsCallback` 记录 Custom Tabs 导航生命周期事件，并对比不同本地 HTTP 响应的 callback 序列。

## Hypothesis

当 Chrome 暴露 `android.support.customtabs.action.CustomTabsService` 后，访问本地 mock server 的 `/basic`、`/status/200`、`/status/404-empty`、`/status/404-body` 应产生可记录的 `TAB_SHOWN`、`NAVIGATION_STARTED`、`NAVIGATION_FINISHED` 等事件。空 body 的 404 可能与带 body 的 404 产生不同 callback 序列。

## 环境

- 模拟器：LDPlayer，ADB 路径 `F:\Mobile Security\env\leidian\LDPlayer9\adb.exe`
- Android：Android 9 API 28
- 浏览器：`com.android.chrome`，版本 `138.0.7204.179`
- Custom Tabs service：`com.android.chrome/org.chromium.chrome.browser.customtabs.CustomTabsConnectionService`
- server：Flask mock server，监听 `0.0.0.0:8000`
- LDPlayer 访问宿主机地址：`http://198.18.0.1:8000`

## 命令

详见本目录 `commands.md`。关键步骤包括：

- 构建 APK：`scripts/build_app.ps1`
- 安装 APK：`scripts/install_app.ps1`
- 启动 server：直接启动 `python .\server\app.py`
- 清除 Android 全局代理：`settings put global http_proxy :0`
- 通过 `am start` 传入 `experiment_id`、`url`、`auto_launch=true`
- 采集 `logcat_full.txt`、`logcat_ct_repro.txt`、`data/events.csv` 和截图

## Expected result

- Chrome Custom Tabs service 能成功连接。
- server 能收到来自 Chrome 的本地请求。
- 200 响应应至少出现 `NAVIGATION_STARTED -> NAVIGATION_FINISHED`。
- 404 响应可能出现与 200 不同的 callback 序列，尤其是 empty body 情况。

## Observed result

Chrome 安装后，Custom Tabs provider 可用。第一轮访问失败，原因是此前为了 Google Play 登录设置的 Android 全局代理仍然存在，Chrome Custom Tabs 未能直连本地 server，callback 中出现约 5.6 秒后的 `NAVIGATION_FAILED -> NAVIGATION_FINISHED`，server 未收到对应请求。

清除 Android 全局代理后复跑，server 收到来自 Chrome 的请求：

| Endpoint | HTTP 状态 | 观察到的主要 callback 序列 |
|---|---:|---|
| `/basic` | 200 | `SERVICE_CONNECTED -> extraCallback:onWarmupCompleted -> LAUNCH_REQUESTED -> TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` |
| `/status/200` | 200 | `SERVICE_CONNECTED -> extraCallback:onWarmupCompleted -> LAUNCH_REQUESTED -> TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` |
| `/status/404-empty` | 404 | `SERVICE_CONNECTED -> extraCallback:onWarmupCompleted -> LAUNCH_REQUESTED -> TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FAILED -> NAVIGATION_FINISHED -> TAB_HIDDEN` |
| `/status/404-body` | 404 | `SERVICE_CONNECTED -> extraCallback:onWarmupCompleted -> LAUNCH_REQUESTED -> TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` |

关键差异：`/status/404-empty` 比 `/status/404-body` 多出 `NAVIGATION_FAILED`，说明空响应体 404 与带 HTML body 的 404 在 Chrome Custom Tabs callback 序列上可区分。

## 证据路径

- 命令记录：`experiments/E01_callback_baseline/run_20260527_152504/commands.md`
- server log：`experiments/E01_callback_baseline/run_20260527_152504/server.log`
- 完整 logcat：`experiments/E01_callback_baseline/run_20260527_152504/logcat_full.txt`
- CT_REPRO logcat：`experiments/E01_callback_baseline/run_20260527_152504/logcat_ct_repro.txt`
- 合并 CSV：`experiments/E01_callback_baseline/run_20260527_152504/data/events.csv`
- 单 endpoint CSV：
  - `data/events_basic_localnet.csv`
  - `data/events_status_200_localnet.csv`
  - `data/events_status_404_empty_localnet.csv`
  - `data/events_status_404_body_localnet.csv`
- 截图：
  - `screenshots/e01_basic_localnet.png`
  - `screenshots/e01_status_200_localnet.png`
  - `screenshots/e01_status_404_empty_localnet.png`
  - `screenshots/e01_status_404_body_localnet.png`

## 与论文机制的对应关系

论文 Sec. 2.2 说明宿主 app 可以通过 Custom Tabs navigation callbacks 观察页面加载生命周期；Sec. 3.4 / Sec. 3.4.1 将 callback sequence 和 timing 用作 Cross-Context State Inference 的 oracle。本地 E01 没有访问真实网站，而是用 mock server 证明同一宿主 app 能观察到不同 HTTP 行为导致的 callback 序列差异。

本次结果支持后续 E02：`404-empty` 与 `404-body` 的差异可以作为本地、安全的 callback oracle 示例。

## 不一致原因与环境说明

- LDPlayer 不使用 Android Studio 模拟器常见的 `10.0.2.2`；本次有效地址为 `198.18.0.1`。
- 为了 Google Play 登录曾设置 Android 全局代理 `198.18.0.1:7890`，这会干扰 Chrome Custom Tabs 访问本地 `198.18.0.1:8000`，清除代理后本地 server 可达。
- Chrome User-Agent 中显示 Android 10，但 app 侧系统字段为 Android 9 API 28；该差异来自 Chrome UA 字符串，不影响 callback 采集。

## Limitation

- 本次只覆盖 E01 基线 endpoint，未包含 redirect、download、PDF、delay 等 E02 oracle endpoint。
- 截图只作为页面加载证据，核心判据仍以 `CT_REPRO` logcat、server log 和 CSV 为准。
- `run_server.ps1` 后台启动在当前路径/权限组合下不稳定，本次使用直接 `Start-Process python .\server\app.py` 作为 fallback，后续可修正脚本。

## 结论

E01_callback_baseline 在安装 Chrome 并清除 Android 全局代理后完成。当前阶段可以进入下一步 E02_state_inference_oracle，重点扩大 endpoint 类型并量化 callback sequence/timing 差异。
