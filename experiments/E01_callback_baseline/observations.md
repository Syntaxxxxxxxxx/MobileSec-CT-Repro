# E01_callback_baseline observations

## 2026-05-25 P04 Android app 构建观察

### Hypothesis

实现一个本地 Android Kotlin app 后，应能通过 `CustomTabsSession` 注册 `CustomTabsCallback`，在打开本地 mock server URL 时把 navigation callback 写入 UI、Logcat 和 CSV。构建阶段至少应产出 debug APK，供后续模拟器实验安装。

### Expected result

- app 使用 `androidx.browser` Custom Tabs。
- Logcat tag 统一为 `CT_REPRO`。
- 每条事件包含 `experiment_id,timestamp_ms,relative_ms_from_launch,event_name,event_code,url,browser_package,android_version,browser_version,note`。
- UI 能展示事件。
- CSV 能导出到 app 私有外部目录。
- Gradle debug build 成功，产出 APK。

### Observed result

- 已创建 Android Kotlin app：`app/`。
- 已实现 `MainActivity` 和 `CtEvent`。
- 已实现 callback 记录、UI 展示、Logcat 输出和 CSV 导出。
- 已产出 APK：`D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk`。
- Gradle 构建命令最终成功，退出码为 0。

### Logcat / server log

本次只完成构建自测，尚未连接模拟器运行 Custom Tab，因此尚未产生 `CT_REPRO` logcat、截图或 CSV。后续执行 E01 时需要补充：

- `experiments/E01_callback_baseline/logs/logcat_*.txt`
- `experiments/E01_callback_baseline/data/events_*.csv`
- `experiments/E01_callback_baseline/screenshots/*.png`

### 与论文机制的对应关系

论文 Sec. 2.2 描述 Custom Tabs 允许宿主 app 通过 callbacks 观察导航生命周期；Sec. 3.4 / 3.4.1 将 callback sequence/timing 用作 state inference oracle。本次 P04 app 是后续 E01-E03 的测量端：只记录本地 mock server 的 callback 现象，不访问真实网站，不采集真实状态。

本地实现主要参考论文 artifact 仓库 `env/paper_artifacts/tabbed-out/pocs/state_inference` 中对 `CustomTabsSession`、`CustomTabsCallback` 和事件展示的用法，但已移除真实目标站点和攻击性 PoC 流程。

### Limitation

- 尚未运行模拟器或真机，因此 callback 序列本身还没有实测。
- 当前构建使用 `compileSdk 33 / targetSdk 33`，原因是论文仓库参考栈 AGP 8.0.2 与 Android 35 平台资源链接不兼容。
- AndroidX Browser 使用 `1.5.0`，与论文 PoC 版本一致；较新 `1.8.0` 需要 `compileSdk >= 34`。
- 构建机 PowerShell profile 在提升权限命令中会出现 execution policy 警告，但 Gradle 构建成功，未影响 APK 产出。

### Conclusion

P04 的 app 实现和 Gradle build 已完成。E01 的实验完成度目前停留在“工具链与 APK 准备完成”，还需要后续安装运行、采集 Logcat/CSV/截图后才能满足完整 Done Definition。

## 2026-05-25 P05 脚本准备观察

### Hypothesis

如果 P05 脚本补全正确，后续 E01 应可以通过统一脚本创建 run 目录，启动 server、构建 APK、安装 app、采集 logcat、截图、录屏和导出 CSV/artifacts。

### Expected result

- 每个脚本支持 `ExperimentId` 和 `RunId`。
- 输出统一进入 `experiments/E01_callback_baseline/<run_id>/`。
- adb 不可用时给出明确中文错误。
- 构建脚本和 server 脚本可以在当前 Windows 环境运行。

### Observed result

- `build_app.ps1` 验证成功，APK 构建完成。
- `run_server.ps1` 验证成功，`/basic` 返回 HTTP 200。
- `install_app.ps1`、`collect_logcat.ps1`、`screenshot.ps1`、`export_artifacts.ps1` 在雷电模拟器未启动时给出明确中文错误：未发现可用 Android 设备。
- 已将雷电模拟器复制到 `env/leidian`，默认 adb 路径为 `env/leidian/LDPlayer9/adb.exe`。

### Limitation

尚未启动雷电模拟器，因此 P05 只完成脚本级验证，没有产生真实设备截图、录屏、logcat 或 app CSV。P06 需要先让 `adb devices` 出现 `device` 状态。

### Conclusion

P05 已完成，可以进入 P06 的 E01_callback_baseline 实验执行阶段。

## 2026-05-25 P06 执行尝试

### Run

`experiments/E01_callback_baseline/run_20260525_225429/`

### Hypothesis

在 Custom Tab 中打开 `/basic`、`/status/200`、`/status/404-empty`、`/status/404-body` 时，app 应记录 `CT_REPRO` callback，并导出 CSV。该机制对应论文 Sec. 2.2 的 navigation callbacks，以及 Sec. 3.4 / 3.4.1 中 callback sequence 作为 state inference oracle 的基础。

### Expected result

- server endpoint 返回预期状态码。
- app 安装到雷电模拟器。
- 逐个打开 endpoint。
- 采集 `logcat_full.txt`、`logcat_ct_repro.txt`、`data/events.csv` 和截图。

### Observed result

- server 启动成功，本机请求验证通过：`/basic` 200，`/status/200` 200，`/status/404-empty` 404，`/status/404-body` 404。
- app 构建成功，APK 路径为 `D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk`。
- 雷电模拟器可短暂启动，但随后退出或无法注册 adb；`adb devices` 一直为空。
- 因无 adb `device`，app 未安装，Custom Tab 未运行，未产生真实 callback、截图或 app CSV。

### 证据路径

- `experiments/E01_callback_baseline/run_20260525_225429/commands.md`
- `experiments/E01_callback_baseline/run_20260525_225429/server.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/build_app.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/install_app_attempt.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/collect_logcat_attempt.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/screenshot_attempt.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/leidian_logCrash.txt`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/leidian_VBox.log`
- `experiments/E01_callback_baseline/run_20260525_225429/observations.md`

### 结论

E01 本次未完成完整 Done Definition，阻塞点是雷电模拟器/adb 设备不可用，不是 app 或 server 代码失败。修复模拟器后可直接复跑 P06。

## 2026-05-25 P06 原路径雷电模拟器执行结果

### Run

`experiments/E01_callback_baseline/run_20260525_230617/`

### Hypothesis

若雷电模拟器中存在支持 Custom Tabs 的浏览器，打开 `/basic`、`/status/200`、`/status/404-empty`、`/status/404-body` 时应产生 Custom Tabs navigation callback sequence。

### Observed result

- 使用原路径 `F:\Mobile Security\env\leidian\LDPlayer9\adb.exe` 后，adb 成功识别 `emulator-5554 device`。
- app 构建和安装成功。
- server endpoint 本机验证成功：200/200/404/404。
- app 可运行并写入 `CT_REPRO` logcat 与 CSV。
- 当前雷电镜像没有 Chrome，也没有暴露 `android.support.customtabs.action.CustomTabsService` 的浏览器。
- 四个 endpoint 的 observed sequence 均为：`BROWSER_NOT_FOUND -> LAUNCH_SKIPPED`。

### Evidence

- `experiments/E01_callback_baseline/run_20260525_230617/commands.md`
- `experiments/E01_callback_baseline/run_20260525_230617/server.log`
- `experiments/E01_callback_baseline/run_20260525_230617/logcat_full.txt`
- `experiments/E01_callback_baseline/run_20260525_230617/logcat_ct_repro.txt`
- `experiments/E01_callback_baseline/run_20260525_230617/data/events.csv`
- `experiments/E01_callback_baseline/run_20260525_230617/screenshots/e01_browser_not_found.png`
- `experiments/E01_callback_baseline/run_20260525_230617/observations.md`

### Conclusion

E01 已完成一次可追溯运行，但结果是环境 negative result：当前雷电镜像缺少 Custom Tabs provider，无法进入论文 Sec. 2.2 / Sec. 3.4 所需的 navigation callback 阶段。下一步需要安装可信来源 Chrome/Chromium 或更换带 Custom Tabs provider 的模拟器后复跑 E01。

## 2026-05-27 P06 Chrome 安装后复跑结果

### Run

`experiments/E01_callback_baseline/run_20260527_152504/`

### Hypothesis

安装 Chrome 后，LDPlayer 应暴露 `android.support.customtabs.action.CustomTabsService`，app 能通过 `CustomTabsCallback` 记录真实 Chrome Custom Tabs navigation callback。不同本地 HTTP 响应，特别是 `404-empty` 与 `404-body`，可能产生可区分的 callback 序列。

### Observed result

- Chrome 包名：`com.android.chrome`。
- Custom Tabs service：`com.android.chrome/org.chromium.chrome.browser.customtabs.CustomTabsConnectionService`。
- 有效本地访问地址为 `http://198.18.0.1:8000`；LDPlayer 下 `10.0.2.2` 不适合作为本次 server 地址。
- 清除 Android 全局代理后，server 收到来自 Chrome 的请求。
- `/basic` 和 `/status/200`：`NAVIGATION_STARTED -> NAVIGATION_FINISHED`。
- `/status/404-body`：`NAVIGATION_STARTED -> NAVIGATION_FINISHED`。
- `/status/404-empty`：`NAVIGATION_STARTED -> NAVIGATION_FAILED -> NAVIGATION_FINISHED`。

### Evidence

- `experiments/E01_callback_baseline/run_20260527_152504/commands.md`
- `experiments/E01_callback_baseline/run_20260527_152504/server.log`
- `experiments/E01_callback_baseline/run_20260527_152504/logcat_full.txt`
- `experiments/E01_callback_baseline/run_20260527_152504/logcat_ct_repro.txt`
- `experiments/E01_callback_baseline/run_20260527_152504/data/events.csv`
- `experiments/E01_callback_baseline/run_20260527_152504/screenshots/e01_basic_localnet.png`
- `experiments/E01_callback_baseline/run_20260527_152504/screenshots/e01_status_200_localnet.png`
- `experiments/E01_callback_baseline/run_20260527_152504/screenshots/e01_status_404_empty_localnet.png`
- `experiments/E01_callback_baseline/run_20260527_152504/screenshots/e01_status_404_body_localnet.png`
- `experiments/E01_callback_baseline/run_20260527_152504/observations.md`

### 与论文机制的对应关系

本次结果对应论文 Sec. 2.2 的 Custom Tabs navigation callbacks，以及 Sec. 3.4 / Sec. 3.4.1 中将 callback sequence/timing 作为 state inference oracle 的机制。本地实验没有访问真实网站，只用 mock server 证明不同响应行为能够被宿主 app 观察为不同 callback 序列。

### Conclusion

E01_callback_baseline 已完成。`404-empty` 与 `404-body` 的 callback 差异可以进入 E02 作为本地 oracle 的核心候选现象。
