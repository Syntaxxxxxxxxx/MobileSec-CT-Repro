# 02_ENVIRONMENT.md

## 1. 当前环境状态

更新时间：2026-05-24

本项目环境优先使用 `env/` 下的项目内工具，不依赖系统全局 Java/Android SDK。这样可以降低课程复现实验在不同机器上的漂移。

| 工具 | 项目内路径 | 当前状态 | 验证结果 |
|---|---|---|---|
| Microsoft OpenJDK 17 | `env/jdk-17.0.19+10` | 已安装 | `openjdk version "17.0.19"` |
| Apache Maven | `env/apache-maven-3.9.11` | 已安装 | `Apache Maven 3.9.11` |
| Android command-line tools | `env/android-sdk/cmdline-tools/latest/cmdline-tools` | 已安装 | `sdkmanager.bat` 可用 |
| Android Platform Tools | `env/android-sdk/platform-tools` | 已安装 | `adb version 37.0.0-14910828` |
| Android SDK Platform | `env/android-sdk/platforms/android-35` | 已安装 | `platforms;android-35` version 2 |
| Python | `F:\anaconda\python.exe` | 系统已有 | Python 3.12 |
| Git | `F:\Git\cmd\git.exe` | 系统已有 | Git 2.47.1 |

系统全局 Java 当前指向 Java 8，不适合后续 Android Gradle 构建；后续命令应显式使用 `env/jdk-17.0.19+10`。

## 2. 推荐 PowerShell 环境变量

在执行 Android 构建、ADB 或 SDK 工具前，建议在当前 PowerShell 会话中设置：

```powershell
$env:JAVA_HOME = (Resolve-Path .\env\jdk-17.0.19+10).Path
$env:ANDROID_HOME = (Resolve-Path .\env\android-sdk).Path
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:Path = "$env:JAVA_HOME\bin;$env:ANDROID_HOME\platform-tools;$(Resolve-Path .\env\apache-maven-3.9.11\bin);$env:Path"
```

验证命令：

```powershell
& ".\env\jdk-17.0.19+10\bin\java.exe" -version
& ".\env\apache-maven-3.9.11\bin\mvn.cmd" -version
& ".\env\android-sdk\platform-tools\adb.exe" version
```

## 3. Windows 路径注意事项

当前工作区路径为 `D:\IEEE S&P`，其中 `&` 会影响部分 `.bat` 脚本，尤其是 Android `sdkmanager.bat`。如果需要再次运行 SDK manager，建议临时映射一个无特殊字符盘符：

```powershell
subst X: "D:\IEEE S&P"
$env:JAVA_HOME = "X:\env\jdk-17.0.19+10"
& X:\env\android-sdk\cmdline-tools\latest\cmdline-tools\bin\sdkmanager.bat --sdk_root=X:\env\android-sdk --list_installed
```

本次已用该方式完成 SDK license 接受和组件安装。普通 `java.exe`、`mvn.cmd`、`adb.exe` 验证可以直接使用带引号的完整路径。

## 4. 已安装 Android SDK 组件

通过 `sdkmanager --list_installed` 验证：

```text
platform-tools       | 37.0.0 | Android SDK Platform-Tools
platforms;android-35 | 2      | Android SDK Platform 35
```

后续 Android app 建议使用：

- `compileSdk = 35`
- `minSdk` 可按课程设备/模拟器选择，建议不低于 23
- Java/Kotlin 构建运行时使用 JDK 17

## 5. 论文 artifact / repo 检查结果

论文在 Sec. 1 末尾说明 artifact 位于 `purl.org/ct-paper`。本次检查到跳转链：

1. `http://purl.org/ct-paper`
2. `https://purl.org/ct-paper`
3. `https://purl.archive.org/ct-paper`
4. `https://github.com/beerphilipp/tabbed-out`

GitHub 仓库：`https://github.com/beerphilipp/tabbed-out`

仓库 README 说明：

- `analysis`：Custom Tabs 大规模应用分析代码与结果。
- `pocs`：论文提出攻击的 Proof of Concepts。

本项目处理原则：

- 可以参考论文仓库的目录结构和安全边界说明。
- 不直接运行其攻击 PoC。
- 不把真实网站 URL、真实账号、真实 cookie/token/password 带入本地复现。
- 如需下载该仓库，只能放入 `env/paper_artifacts/`，并在 `env/MANIFEST.md` 中登记来源、用途和校验信息。

## 6. 本次下载与安装命令摘要

下载：

```powershell
curl.exe -L --ssl-no-revoke --retry 5 --retry-all-errors -o .\env\microsoft-jdk-17.0.18-windows-x64.zip https://aka.ms/download-jdk/microsoft-jdk-17-windows-x64.zip
curl.exe -L --ssl-no-revoke --retry 5 --retry-all-errors --connect-timeout 60 -o .\env\commandlinetools-win-14742923_latest.zip https://dl.google.com/android/repository/commandlinetools-win-14742923_latest.zip
curl.exe -L --ssl-no-revoke --retry 5 --retry-all-errors -o .\env\apache-maven-3.9.11-bin.zip https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.11/apache-maven-3.9.11-bin.zip
```

安装：

```powershell
Expand-Archive -LiteralPath .\env\microsoft-jdk-17.0.18-windows-x64.zip -DestinationPath .\env -Force
Expand-Archive -LiteralPath .\env\apache-maven-3.9.11-bin.zip -DestinationPath .\env -Force
Expand-Archive -LiteralPath .\env\commandlinetools-win-14742923_latest.zip -DestinationPath .\env\android-sdk\cmdline-tools\latest -Force
```

SDK 组件：

```powershell
subst X: "D:\IEEE S&P"
$env:JAVA_HOME = "X:\env\jdk-17.0.19+10"
1..20 | ForEach-Object { "y" } | & X:\env\android-sdk\cmdline-tools\latest\cmdline-tools\bin\sdkmanager.bat --sdk_root=X:\env\android-sdk --licenses
& X:\env\android-sdk\cmdline-tools\latest\cmdline-tools\bin\sdkmanager.bat --sdk_root=X:\env\android-sdk "platform-tools" "platforms;android-35"
```

## 7. 尚未配置内容

- Android Emulator system image 尚未安装。
- AVD 尚未创建。
- Android Studio 未检查。
- Gradle wrapper 尚未创建，因为当前阶段尚未实现 Android app。

这些内容应在进入 app 构建阶段前再配置，避免现在引入不必要的大文件。
