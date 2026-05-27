# Android Custom Tabs 实验 app

本目录是 MobileSec-CT-Repro 的 Android Kotlin 实验 app，用于记录 Custom Tabs callback 事件。

## 功能

- 输入 `experiment_id`。
- 输入目标 URL，默认 `http://10.0.2.2:8000/basic`。
- 打开 Custom Tab。
- 注册 `CustomTabsCallback`，记录：
  - `NAVIGATION_STARTED`
  - `NAVIGATION_FINISHED`
  - `NAVIGATION_FAILED`
  - `NAVIGATION_ABORTED`
  - `TAB_SHOWN`
  - `TAB_HIDDEN`
  - `extraCallback:*`
- 事件显示在 UI 中。
- 事件写入 Logcat，tag 为 `CT_REPRO`。
- 事件可导出为 CSV。

## CSV 字段

```text
experiment_id,timestamp_ms,relative_ms_from_launch,event_name,event_code,url,browser_package,android_version,browser_version,note
```

CSV 默认导出到 app 私有外部目录：

```text
/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/
```

## 构建

建议先设置本项目内 JDK 与 Android SDK：

```powershell
$env:JAVA_HOME = (Resolve-Path ..\env\jdk-17.0.19+10).Path
$env:ANDROID_HOME = (Resolve-Path ..\env\android-sdk).Path
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
```

如果使用 Gradle wrapper：

```powershell
.\gradlew.bat assembleDebug
```

如果当前工作区路径包含 `&`，例如 `D:\IEEE S&P`，建议先映射临时盘符再构建：

```powershell
subst X: "D:\IEEE S&P"
$env:JAVA_HOME='X:\env\jdk-17.0.19+10'
$env:ANDROID_HOME='X:\env\android-sdk'
$env:ANDROID_SDK_ROOT=$env:ANDROID_HOME
$env:Path="$env:JAVA_HOME\bin;$env:Path"
& X:\env\gradle-8.0\bin\gradle.bat -p X:\app assembleDebug --no-daemon --console=plain --stacktrace
```

当前构建产物：

```text
D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

当前使用 `compileSdk 33 / targetSdk 33` 与 `androidx.browser:browser:1.5.0`，用于匹配论文 PoC 的 AGP 8.0.2 参考栈。

## 安全边界

- 默认只访问本地 mock server。
- 不访问真实网站。
- 不记录真实 cookie、token、password。
- Header Injection、SameSite Cookie Bypass、Scroll Inference、Bottom Bar 相关代码只允许作为本地安全实验或 negative result 使用。
