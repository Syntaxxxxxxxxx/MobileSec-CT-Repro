# 04_LAB_NOTEBOOK.md

## 2026-05-24 P00.5 论文阅读与复现计划

### 本次目标

按照 `docs/01_CODEX_PROMPTS.md` 中 P00.5 的要求，在不编写 Android app、不编写 server 的前提下，先阅读论文并完成复现计划：

1. 阅读 `AGENTS.md`、`docs/00_PROJECT_GUIDE.md`、`paper/TabbedOut.pdf`。
2. 生成/更新 `docs/08_PAPER_READING_PLAN.md`。
3. 更新 `docs/03_EXPERIMENT_MATRIX.md`。
4. 给出本项目推荐复现范围。

### 已执行的阅读与检索

- 使用 `pdftotext -layout` 将论文 PDF 提取为 `env/TabbedOut.txt`，用于本地关键词检索。
- 检索并回查了以下论文位置：
  - Sec. 2.1：Custom Tabs state sharing。
  - Sec. 2.2：Navigation callbacks。
  - Sec. 3.4 / Sec. 3.4.1：Cross-Context State Inference Attack 及 status、redirect、download、Content-Type、timing vectors。
  - Sec. 3.5：HTTP Header Injection。
  - Sec. 3.6：SameSite Cookie Bypass。
  - Sec. 3.7：Scroll Inference Attack。
  - Sec. 3.8：Bottom Bar Spoofing。
  - Sec. 4.2 / Sec. 4.3：mitigation 与已采用修复。
  - Table 2、Table 4、Table 6、Table 7、Fig. 3、Fig. 4、Fig. 5。

### 本次文档更新

- `docs/08_PAPER_READING_PLAN.md`：补全论文核心机制、攻击点映射、推荐复现范围、必须回查论文的实验点。
- `docs/03_EXPERIMENT_MATRIX.md`：建立从论文攻击点到 E01-E04 的本地实验矩阵。
- `docs/05_REPRODUCTION_REPORT.md`：补充当前阶段的论文依据与推荐范围摘要。
- `env/MANIFEST.md`：登记从论文 PDF 提取出的 `env/TabbedOut.txt`。

### 当前结论

推荐主线是 E01-E04：

1. E01 先验证 callback recorder。
2. E02 用本地 HTTP 响应差异构造 callback/timing oracle。
3. E03 用本地 demo cookie 展示 state sharing。
4. E04 对 Header Injection、SameSite Strict Cookie Bypass 等高风险或已修复点做 negative result/mitigation analysis。

不建议复现真实网站攻击、真实 phishing、真实 header injection、真实 SameSite 绕过，也不建议安装来源不明旧版浏览器。

### 证据与产物路径

- 论文原文：`paper/Beer 等 - 2024 - Tabbed out Subverting the android custom tab security model.pdf`
- 本地检索文本：`env/TabbedOut.txt`
- 阅读计划：`docs/08_PAPER_READING_PLAN.md`
- 实验矩阵：`docs/03_EXPERIMENT_MATRIX.md`

### 下一步建议

下一步可以进入 P03：实现本地 mock server 的安全 endpoint。实现前仍应以 `docs/03_EXPERIMENT_MATRIX.md` 中的 endpoint 和安全边界为准。

## 2026-05-24 P03 本地 mock server 实现与自测

### 本次目标

执行 `docs/01_CODEX_PROMPTS.md` 中 P03：实现本地 Flask mock server、`requirements.txt`、`server/routes.md`、`scripts/run_server.ps1`，并用本地请求做基本自测。

### 实现文件

- `server/app.py`
- `server/requirements.txt`
- `server/routes.md`
- `scripts/run_server.ps1`
- `docs/03_EXPERIMENT_MATRIX.md`
- `docs/04_LAB_NOTEBOOK.md`
- `docs/05_REPRODUCTION_REPORT.md`

### 实现 endpoint

已实现：

- `/basic`
- `/status/200`
- `/status/404-empty`
- `/status/404-body`
- `/redirect/http`
- `/redirect/html`
- `/content/pdf`
- `/download`
- `/delay/<ms>`
- `/login`
- `/profile`

### Server log

默认日志路径：`server/server.log`

字段：

```text
timestamp,method,path,status,user_agent,cookie_present
```

安全检查：server log 只记录 demo cookie 是否存在，不记录 cookie 值。

### 启动命令

本次自测使用本机监听地址启动，避免占用外部接口：

```powershell
$env:CT_REPRO_HOST = "127.0.0.1"
$env:CT_REPRO_PORT = "8000"
$env:CT_REPRO_SERVER_LOG = "D:\IEEE S&P\server\server.log"
python server/app.py
```

正式运行可使用：

```powershell
.\scripts\run_server.ps1
```

默认监听 `0.0.0.0:8000`，Android 模拟器访问 `http://10.0.2.2:8000/basic`。

### 自测命令

```powershell
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" http://127.0.0.1:8000/basic
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" http://127.0.0.1:8000/status/200
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" http://127.0.0.1:8000/status/404-empty
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" http://127.0.0.1:8000/status/404-body
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" -L --max-redirs 0 http://127.0.0.1:8000/redirect/http
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" http://127.0.0.1:8000/redirect/html
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" http://127.0.0.1:8000/content/pdf
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" -OJ http://127.0.0.1:8000/download
curl.exe -s -o NUL -w "%{http_code} %{content_type} %{redirect_url} %{time_total}" http://127.0.0.1:8000/delay/100
```

Cookie demo 自测：

```powershell
$cookiePath = "env\tmp\ct_cookie_test.txt"
curl.exe -s -c $cookiePath -b $cookiePath http://127.0.0.1:8000/profile
curl.exe -s -c $cookiePath -b $cookiePath http://127.0.0.1:8000/login
curl.exe -s -c $cookiePath -b $cookiePath http://127.0.0.1:8000/profile
```

### 自测结果

```text
basic: 200 text/html; charset=utf-8  0.002764
status200: 200 text/html; charset=utf-8  0.002683
status404empty: 404 text/plain; charset=utf-8  0.002350
status404body: 404 text/html; charset=utf-8  0.002463
redirectHttp: 302 text/html; charset=utf-8 http://127.0.0.1:8000/basic 0.002738
redirectHtml: 200 text/html; charset=utf-8  0.002458
pdf: 200 application/pdf  0.002297
download: 200 text/plain; charset=utf-8  0.002832
delay100: 200 text/html; charset=utf-8  0.103165
profileBeforeContainsNotLoggedIn: true
loginSetCookie: true
profileAfterContainsLoggedIn: true
```

### Server log 抽样

```text
timestamp,method,path,status,user_agent,cookie_present
2026-05-24T23:32:57.761+08:00,GET,/profile,200,curl/8.19.0,no
2026-05-24T23:32:57.785+08:00,GET,/login,200,curl/8.19.0,no
2026-05-24T23:32:57.808+08:00,GET,/profile,200,curl/8.19.0,yes
```

结论：P03 mock server 基本自测通过。下载测试产生的 `ct-repro-download.txt` 与 demo cookie jar 已清理。

## 2026-05-24 环境配置与论文 artifact 检查

### 本次目标

先完成基础环境配置，并确认论文是否提供代码或 repo。仍然不实现 Android app，不实现 server。

### 论文 artifact / repo 检查

论文 Sec. 1 末尾写明 artifact 地址为 `purl.org/ct-paper`。本次联网检查得到跳转链：

1. `http://purl.org/ct-paper`
2. `https://purl.org/ct-paper`
3. `https://purl.archive.org/ct-paper`
4. `https://github.com/beerphilipp/tabbed-out`

GitHub 仓库 README 显示该仓库包含：

- `analysis`：Custom Tab 大规模应用分析代码与结果。
- `pocs`：论文攻击 PoC，包括 state inference、header injection、scroll inference、bottom bar spoofing 等。

本项目判断：该仓库可作为论文 artifact 参考，但不直接运行 PoC，不把真实网站或真实用户状态带入复现实验。

### 已完成环境配置

- 下载并解压 Microsoft OpenJDK 17 到 `env/jdk-17.0.19+10`。
- 下载并解压 Apache Maven 3.9.11 到 `env/apache-maven-3.9.11`。
- 下载并解压 Android command-line tools 到 `env/android-sdk/cmdline-tools/latest/cmdline-tools`。
- 使用 Android SDK manager 接受 licenses。
- 安装 Android SDK Platform Tools 37.0.0。
- 安装 Android SDK Platform 35。

### 验证结果

- `java -version`：`openjdk version "17.0.19"`。
- `mvn -version`：`Apache Maven 3.9.11`，运行时为 `D:\IEEE S&P\env\jdk-17.0.19+10`。
- `adb version`：`Android Debug Bridge version 1.0.41`，platform-tools version `37.0.0-14910828`。
- `sdkmanager --list_installed`：已安装 `platform-tools` 与 `platforms;android-35`。

### 注意事项

当前工作区路径 `D:\IEEE S&P` 包含 `&`，会影响部分 Android `.bat` 脚本。后续如需运行 `sdkmanager.bat`，建议使用 `subst X: "D:\IEEE S&P"` 临时映射盘符后执行。

### 本次文档更新

- `docs/02_ENVIRONMENT.md`：补充环境路径、验证命令、SDK 组件、论文 repo 检查结果。
- `env/MANIFEST.md`：登记 JDK、Android command-line tools、Maven、SDK platform-tools、Android 35 平台。
- `docs/04_LAB_NOTEBOOK.md`：记录本次配置过程。
- `docs/05_REPRODUCTION_REPORT.md`：记录当前环境准备状态。

## 2026-05-24 克隆论文 artifact 仓库

### 本次目标

将论文官方 artifact 仓库克隆到本地，作为后续实现 Android app 与实验流程的主要代码参考。

### 仓库信息

- 远程仓库：`https://github.com/beerphilipp/tabbed-out.git`
- 本地路径：`env/paper_artifacts/tabbed-out`
- 当前 commit：`3ada3bb1fc317cdf9a442a52445614ee5a8b7cff`
- 用途：参考 Custom Tabs PoC 的项目结构、CustomTabsSession/Callback 用法、bottom bar/header/scroll/state inference 相关实现。

### Windows checkout 问题与处理

第一次直接 `git clone` 时，Git for Windows 在 checkout 阶段失败：

```text
error: invalid path 'analysis/results/con.hotspot.vpn.free.master.res.json'
fatal: unable to checkout working tree
```

原因：`analysis/results/` 中包含以 `con.` 开头的文件名，`con` 是 Windows 保留设备名。

处理方式：

1. 删除失败的残缺 checkout。
2. 使用 `git clone --no-checkout` 重新克隆。
3. 设置 sparse checkout，仅检出后续需要参考的目录。
4. 配合 `core.protectNTFS=false` 完成 sparse checkout。

实际保留内容：

- `README.md`
- `LICENSE`
- `pocs/`
- `analysis/README.md`
- `analysis/pipeline/`
- `analysis/input/`

未检出内容：

- `analysis/results/`

### 可参考的 PoC 目录

- `pocs/state_inference`
- `pocs/header_injection`
- `pocs/scroll_inference`
- `pocs/bottom_bar_spoofing`

### 本项目使用原则

- 后续 Android app 实现应优先参考 `pocs/state_inference` 中 Custom Tabs session、callback 和事件展示结构。
- Header Injection、Scroll Inference、Bottom Bar 相关代码只作为理解 API 的参考，不直接复现真实攻击。
- 所有 URL 必须替换为本地 mock server endpoint，例如 `http://10.0.2.2:8000/*`。
- 不运行论文 PoC 去访问真实网站，不收集真实 cookie/token/password。

## 2026-05-25 P04 Android Kotlin Custom Tabs 实验 app

### 本次目标

执行 P04：创建 Android Kotlin Custom Tabs 实验 app，实现 callback 记录、Logcat 输出、UI 展示和 CSV 导出；完成 Gradle build，并记录 APK 路径、命令、结果和失败点。

### 代码参考

主要参考论文 artifact 仓库：

- `env/paper_artifacts/tabbed-out/pocs/state_inference`
- 参考点：`CustomTabsSession`、`CustomTabsCallback`、事件列表展示、Custom Tab launch 流程。
- 本项目没有复用真实攻击目标站点，也没有运行论文 PoC；所有默认 URL 指向本地 mock server：`http://10.0.2.2:8000/basic`。

### 已实现内容

- Android Kotlin app 目录：`app/`。
- 包名：`edu.mobilesec.ctrepro`。
- Logcat tag：`CT_REPRO`。
- 默认实验：`E01_callback_baseline`。
- 默认 URL：`http://10.0.2.2:8000/basic`。
- 支持记录 `onNavigationEvent`：`NAVIGATION_STARTED`、`NAVIGATION_FINISHED`、`NAVIGATION_FAILED`、`NAVIGATION_ABORTED`、`TAB_SHOWN`、`TAB_HIDDEN`。
- 支持记录 `extraCallback:*`。
- 事件同时写入 UI 与 Logcat。
- CSV 导出目录：`/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/`。

CSV 字段：

```text
experiment_id,timestamp_ms,relative_ms_from_launch,event_name,event_code,url,browser_package,android_version,browser_version,note
```

### 构建命令

由于工作区路径 `D:\IEEE S&P` 包含 `&`，构建时使用 `subst` 映射盘符：

```powershell
subst X: "D:\IEEE S&P"
$env:JAVA_HOME='X:\env\jdk-17.0.19+10'
$env:ANDROID_HOME='X:\env\android-sdk'
$env:ANDROID_SDK_ROOT=$env:ANDROID_HOME
$env:Path="$env:JAVA_HOME\bin;$env:Path"
& X:\env\gradle-8.0\bin\gradle.bat -p X:\app assembleDebug --no-daemon --console=plain --stacktrace
```

### 构建结果

```text
BUILD SUCCESSFUL
APK: D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
Size: 1268863 bytes
```

### 失败点与处理

1. 直接在 `D:\IEEE S&P` 下运行 `.bat` 会导致 `JAVA_HOME` 被 `&` 截断。处理：使用 `subst X: "D:\IEEE S&P"`。
2. `compileSdk 35` 在 AGP 8.0.2 / aapt2 8.0.2 下链接失败，报 `RES_TABLE_TYPE_TYPE entry offsets overlap actual entry data`。处理：改为 `compileSdk 33 / targetSdk 33`。
3. `sdkmanager` 下载 Android 33 platform 时 TLS handshake 失败。处理：从 Android Repository 手动下载 `platform-33-ext3_r03.zip`，解压整理到 `env/android-sdk/platforms/android-33`。
4. `androidx.browser:browser:1.8.0` 与 `androidx.core:core-ktx:1.13.1` 要求 `compileSdk >= 34`。处理：参照论文 PoC，使用 `androidx.browser:browser:1.5.0`，移除当前代码不需要的 `core-ktx`。

### 当前限制

本次完成的是构建自测，尚未安装到模拟器运行，因此尚未产生 `CT_REPRO` logcat、CSV、截图或录屏。E01 正式执行时需要补采这些证据。

## 2026-05-25 P05 Windows PowerShell 实验脚本

### 本次目标

执行 P05：补全 Windows PowerShell 脚本，用于启动 server、构建 app、安装 app、采集 logcat、截图、录屏和导出 artifacts。每个脚本都需要中文注释和清晰错误提示，并支持 `experiment_id` 与 `run_id`。

### 雷电模拟器复制

已将雷电模拟器从课程环境复制到当前项目：

```text
Source: F:\Mobile Security\env\leidian
Dest:   D:\IEEE S&P\env\leidian
Size:   2.67 GB / 429 files
ADB:    D:\IEEE S&P\env\leidian\LDPlayer9\adb.exe
```

复制命令：

```powershell
robocopy "F:\Mobile Security\env\leidian" ".\env\leidian" /E /R:2 /W:2 /NFL /NDL /NP
```

结果：成功，`robocopy exit code=1`，表示有文件被复制且无失败。

### 已补全脚本

- `scripts/common.ps1`：公共路径、run 目录、adb、命令记录辅助函数。
- `scripts/run_server.ps1`：后台启动 Flask mock server，写入 `server.pid`、`server.log` 和 server stdout。
- `scripts/build_app.ps1`：构建 Android app，写入 `logs/build_app.log` 和 `apk_path.txt`。
- `scripts/install_app.ps1`：通过 adb 安装 APK。
- `scripts/collect_logcat.ps1`：导出 `logcat_full.txt` 和 `logcat_ct_repro.txt`。
- `scripts/screenshot.ps1`：通过 adb 截图到 `screenshots/`。
- `scripts/screenrecord.ps1`：通过 adb 录屏到 `videos/`。
- `scripts/export_artifacts.ps1`：复制 server log、拉取 app 导出的 CSV，并生成 `artifacts.md`。

### 验证结果

构建脚本验证：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\build_app.ps1 -ExperimentId E01_callback_baseline -RunId run_p05_script_check
```

结果：成功。APK 仍为：

```text
D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

server 脚本验证：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\run_server.ps1 -ExperimentId E01_callback_baseline -RunId run_p05_script_check
Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1:8000/basic'
```

结果：server 后台启动成功，本地 `/basic` 返回 HTTP 200。验证后已停止该 server 进程。

adb 相关脚本验证：

当前未启动雷电模拟器，`env\leidian\LDPlayer9\adb.exe devices` 输出为空设备列表。因此 `install_app.ps1`、`collect_logcat.ps1`、`screenshot.ps1`、`export_artifacts.ps1` 都能给出预期中文错误：

```text
未发现可用 Android 设备。请先启动雷电模拟器，并确认 adb devices 显示 device 状态。
```

### 当前限制

- P05 是脚本补全阶段，尚未执行 E01。
- 需要用户手动启动雷电模拟器，或后续增加专门的 `start_leidian.ps1`。
- 启动雷电模拟器后即可进入 P06：安装 APK、运行 endpoint、采集 logcat/截图/录屏/CSV。

## 2026-05-25 P06 E01_callback_baseline 执行尝试

### 本次目标

执行 E01_callback_baseline：启动 server、构建并安装 app、逐个打开 `/basic`、`/status/200`、`/status/404-empty`、`/status/404-body`，采集 commands、server log、logcat、events.csv 和截图。

### Run 目录

```text
experiments/E01_callback_baseline/run_20260525_225429/
```

### 已完成部分

- 已启动 mock server。
- 已用本机请求验证 E01 endpoint：
  - `/basic` -> 200
  - `/status/200` -> 200
  - `/status/404-empty` -> 404
  - `/status/404-body` -> 404
- 已执行 app 构建，成功产出 APK：

```text
D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

### 阻塞点

雷电模拟器无法稳定进入 adb `device` 状态：

- `env\leidian\LDPlayer9\ldconsole.exe launch --index 0` 可尝试启动实例，但 VM 随后退出或无法注册 adb。
- `env\leidian\LDPlayer9\adb.exe devices` 始终为空设备列表。
- 尝试原始 `F:\Mobile Security\env\leidian` 路径和当前 `env\leidian` 路径，结果一致。
- 尝试将实例 CPU/内存从 6 核/6144 MB 调整到 4 核/4096 MB 后仍失败。

因此本次未能安装 app、未能打开 Custom Tabs、未能采集真实 `CT_REPRO` logcat、截图或 app CSV。

### 已保存证据

- `experiments/E01_callback_baseline/run_20260525_225429/commands.md`
- `experiments/E01_callback_baseline/run_20260525_225429/server.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/build_app.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/adb_devices_before_install.txt`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/install_app_attempt.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/collect_logcat_attempt.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/screenshot_attempt.log`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/leidian_logCrash.txt`
- `experiments/E01_callback_baseline/run_20260525_225429/logs/leidian_VBox.log`
- `experiments/E01_callback_baseline/run_20260525_225429/observations.md`

### 结论

P06 尚未完整完成。当前可确认 app/server/脚本链路可用，真实 E01 callback 采集被阻塞在模拟器启动与 adb 注册阶段。修复雷电模拟器后可以直接复跑 P06，无需重写 app 或 server。

## 2026-05-25 P06 原路径雷电模拟器复跑

### 关键修复

复制版 `env\leidian` 启动不稳定，切回原路径后 adb 可用：

```text
F:\Mobile Security\env\leidian\LDPlayer9\adb.exe devices
emulator-5554    device
```

因此本次 E01 使用原路径雷电 adb，artifact 仍保存到当前项目。

### Run 目录

```text
experiments/E01_callback_baseline/run_20260525_230617/
```

### 执行结果

- server 启动成功。
- app 构建成功。
- app 安装成功。
- `adb reverse tcp:8000 tcp:8000` 已执行，app 使用 `http://127.0.0.1:8000/*` 访问宿主机 server。
- 采集了 full logcat、`CT_REPRO` logcat、CSV 和截图。

### 观察结论

雷电 Android 9 镜像中未安装 Chrome，也未发现支持 Custom Tabs 的浏览器服务。四个 endpoint 的 callback 记录均为：

```text
BROWSER_NOT_FOUND -> LAUNCH_SKIPPED
```

这说明当前环境还不能复现论文中的 navigation callback sequence，只能作为环境 negative result 记录。app 侧没有回退到普通 ACTION_VIEW，避免把非 Custom Tabs 行为误记为实验结果。

### 证据路径

- `experiments/E01_callback_baseline/run_20260525_230617/commands.md`
- `experiments/E01_callback_baseline/run_20260525_230617/server.log`
- `experiments/E01_callback_baseline/run_20260525_230617/logcat_full.txt`
- `experiments/E01_callback_baseline/run_20260525_230617/logcat_ct_repro.txt`
- `experiments/E01_callback_baseline/run_20260525_230617/data/events.csv`
- `experiments/E01_callback_baseline/run_20260525_230617/screenshots/e01_browser_not_found.png`
- `experiments/E01_callback_baseline/run_20260525_230617/observations.md`

### 下一步

安装可信来源 Chrome/Chromium，或换用自带 Chrome Custom Tabs provider 的模拟器。确认 `pm query-services -a android.support.customtabs.action.CustomTabsService` 返回 provider 后，重新执行 E01。

## 2026-05-27 E01_callback_baseline Chrome 环境复跑

### 目标

在 Chrome 已安装并打开后，重新执行 E01_callback_baseline，确认 Custom Tabs provider 可用，并采集 commands、server log、logcat、events.csv 和截图。

### Run 目录

```text
experiments/E01_callback_baseline/run_20260527_152504/
```

### 环境确认

- `adb devices`：`emulator-5554 device`
- Chrome 包名：`com.android.chrome`
- Custom Tabs service：`com.android.chrome/org.chromium.chrome.browser.customtabs.CustomTabsConnectionService`
- Chrome 版本：`138.0.7204.179`
- app 侧系统字段：Android 9 API 28
- server 访问地址：`http://198.18.0.1:8000`

### 执行记录

- `run_server.ps1` 后台启动在当前环境中未稳定保持运行，因此改用 direct fallback：`Start-Process python .\server\app.py`。
- 首轮运行受 Android 全局代理影响，Chrome Custom Tabs 未能访问本地 server，出现 `NAVIGATION_FAILED`。
- 执行 `settings put global http_proxy :0` 并删除全局代理 host/port 后复跑。
- 复跑后 server 收到 Chrome 请求：`/basic`、`/status/200`、`/status/404-empty`、`/status/404-body`。

### 关键观察

| Endpoint | HTTP 状态 | callback 结论 |
|---|---:|---|
| `/basic` | 200 | `NAVIGATION_STARTED -> NAVIGATION_FINISHED` |
| `/status/200` | 200 | `NAVIGATION_STARTED -> NAVIGATION_FINISHED` |
| `/status/404-empty` | 404 | `NAVIGATION_STARTED -> NAVIGATION_FAILED -> NAVIGATION_FINISHED` |
| `/status/404-body` | 404 | `NAVIGATION_STARTED -> NAVIGATION_FINISHED` |

### 证据路径

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

### 结论

E01_callback_baseline 已完成。Chrome Custom Tabs provider 可用，app 能记录 UI/Logcat/CSV；`404-empty` 与 `404-body` 的 callback 差异可作为 E02 本地 oracle 候选。
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

### 证据路径

- `experiments/E02_state_inference_oracle/run_20260527_153912/commands.md`
- `experiments/E02_state_inference_oracle/run_20260527_153912/server.log`
- `experiments/E02_state_inference_oracle/run_20260527_153912/logcat_ct_repro.txt`
- `experiments/E02_state_inference_oracle/run_20260527_153912/data/events.csv`
- `experiments/E02_state_inference_oracle/run_20260527_153912/data/summary_tables.md`
- `experiments/E02_state_inference_oracle/run_20260527_153912/observations.md`

### 结论

E02 已完成。HTML redirect、download/PDF handling、以及 1000 ms/3000 ms delay 均表现出可区分 callback sequence 或 timing 差异。
## 2026-05-27 P08 E03_state_sharing_cookie

### Run

`experiments/E03_state_sharing_cookie/run_20260527_181001/`

### 执行结果

已完成本地 demo cookie 状态共享实验。为了可靠重置本地状态，新增安全 endpoint `/logout`，只删除 demo cookie，不记录 cookie 值。最终有效流程：

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

E03 已完成。结果支持论文 Sec. 2.1 中 Custom Tabs 共享底层浏览器 cookie 状态的机制，本项目只使用本地 demo session，未记录 cookie 值。
## 2026-05-27 P09 E04_modern_mitigation_negative

### Run

`experiments/E04_modern_mitigation_negative/run_20260527_182908/`

### 执行结果

已使用现代 Chrome `com.android.chrome 138.0.7204.179` 完成本地 negative result / 安全模拟。新增本地 endpoint：`/samesite/set`、`/samesite/check`、`/samesite/clear`、`/samesite/cross-redirect`、`/headers/echo`。

| 测试项 | 观察结果 | 结论 |
|---|---|---|
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

## 2026-05-27 P10 中文复现报告整理

### 执行内容

根据 E01-E04 的 `observations.md`、`commands.md`、`server.log`、`logcat_ct_repro.txt`、`events.csv`、截图和汇总表，整理完整中文复现报告 `docs/05_REPRODUCTION_REPORT.md`。

### 处理原则

- 每个实验结论均附带证据路径。
- E04 只表述为现代 Chrome 下的 mitigation / negative result，不声称复现旧漏洞。
- 报告明确安全边界：仅使用本地 mock server 和模拟器，不攻击真实网站，不记录真实 cookie、token、密码或账号数据。

### 产出

- `docs/05_REPRODUCTION_REPORT.md`

### 结论

P10 已完成。报告覆盖论文背景、复现目标、安全边界、实验环境、工程架构、E01-E04 结果、复现问题与修复、与论文一致性和差异、局限性和最终总结。
