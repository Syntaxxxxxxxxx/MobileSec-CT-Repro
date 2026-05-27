# E01_callback_baseline commands

## 2026-05-25 P04 Android app 构建

### 构建环境准备

工作区路径 `D:\IEEE S&P` 包含 `&`，直接运行 Android/Gradle `.bat` 时会被 `cmd.exe` 拆断。因此本次构建先映射临时盘符：

```powershell
subst X: "D:\IEEE S&P"
$env:JAVA_HOME='X:\env\jdk-17.0.19+10'
$env:ANDROID_HOME='X:\env\android-sdk'
$env:ANDROID_SDK_ROOT=$env:ANDROID_HOME
$env:Path="$env:JAVA_HOME\bin;$env:Path"
```

### 最终构建命令

```powershell
& X:\env\gradle-8.0\bin\gradle.bat -p X:\app assembleDebug --no-daemon --console=plain --stacktrace
```

### 构建结果

```text
BUILD SUCCESSFUL
APK: D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
Size: 1268863 bytes
```

### 已记录的失败点与处理

```text
1. 直接使用 D:\IEEE S&P 路径运行 .bat：
   JAVA_HOME 被截断为 D:\IEEE S，原因是路径中的 & 被 cmd.exe 解释。
   处理：使用 subst X: "D:\IEEE S&P"。

2. AGP 8.0.2 + compileSdk 35：
   aapt2 无法解析 android-35/android.jar，报 RES_TABLE_TYPE_TYPE entry offsets overlap actual entry data。
   处理：改为 compileSdk 33 / targetSdk 33，并安装 Android SDK Platform 33。

3. sdkmanager 下载 Android 33 平台：
   出现 Remote host terminated the handshake。
   处理：按 repository2-1.xml 中的 URL 手动下载 platform-33-ext3_r03.zip，解压到 env/android-sdk/platforms/android-33。

4. androidx.browser:browser:1.8.0 与 androidx.core:core-ktx:1.13.1：
   依赖要求 compileSdk >= 34。
   处理：参照论文仓库 pocs/state_inference，将 browser 降为 1.5.0，并移除当前代码不需要的 core-ktx。
```

### 后续运行命令模板

```powershell
# 启动本地 mock server
.\scripts\run_server.ps1

# 安装 APK 到模拟器或授权测试设备
& .\env\android-sdk\platform-tools\adb.exe install -r .\app\app\build\outputs\apk\debug\app-debug.apk

# 采集 CT_REPRO logcat
& .\env\android-sdk\platform-tools\adb.exe logcat -c
& .\env\android-sdk\platform-tools\adb.exe logcat -s CT_REPRO
```

## 2026-05-25 P05 脚本化命令模板

P05 后，E01 建议统一使用脚本创建 run 目录并采集 artifact：

```powershell
$runId = "run_20260525_220000"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\run_server.ps1 -ExperimentId E01_callback_baseline -RunId $runId
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\build_app.ps1 -ExperimentId E01_callback_baseline -RunId $runId
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install_app.ps1 -ExperimentId E01_callback_baseline -RunId $runId
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\collect_logcat.ps1 -ExperimentId E01_callback_baseline -RunId $runId -ClearBefore
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\screenshot.ps1 -ExperimentId E01_callback_baseline -RunId $runId -Name baseline_basic
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\screenrecord.ps1 -ExperimentId E01_callback_baseline -RunId $runId -Seconds 20
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\export_artifacts.ps1 -ExperimentId E01_callback_baseline -RunId $runId
```

雷电模拟器 adb 路径：

```text
D:\IEEE S&P\env\leidian\LDPlayer9\adb.exe
```

进入 P06 前先确认：

```powershell
.\env\leidian\LDPlayer9\adb.exe devices
```

输出中必须出现 `device` 状态。
