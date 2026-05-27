# env/MANIFEST.md

本文件记录 env/ 中大文件和外部资源的来源。

| 日期 | 文件路径 | 来源 | 用途 | SHA256 | 是否进入 Git | 备注 |
|---|---|---|---|---|---|---|
| YYYY-MM-DD | env/paper_artifacts/example.zip | 原论文 artifact | 参考实验结构 | 待填写 | 否 | 仅本地使用 |
| 2026-05-24 | env/TabbedOut.txt | 由 `paper/Beer 等 - 2024 - Tabbed out Subverting the android custom tab security model.pdf` 使用 `pdftotext -layout` 提取 | 论文关键词检索与 section/table/figure 回查 | 7DC6174BFD46670CCE43595F1FCE9ADE2A11494972C6EE60D03F0B3DE3D63479 | 否 | 本地中间文本，不含实验数据或敏感信息 |
| 2026-05-24 | env/microsoft-jdk-17.0.18-windows-x64.zip | Microsoft JDK 官方下载地址 `https://aka.ms/download-jdk/microsoft-jdk-17-windows-x64.zip` | Android/Java 构建运行时安装包 | 394D1D8253D58B462300F15F9C81369478CF8813F82DCA914C3B5DFDEF080F9F | 否 | 解压后目录为 `env/jdk-17.0.19+10` |
| 2026-05-24 | env/commandlinetools-win-14742923_latest.zip | Android 官方下载地址 `https://dl.google.com/android/repository/commandlinetools-win-14742923_latest.zip` | Android SDK command-line tools 安装包 | CC610CCBE83FADDB58E1AA68E8FC8743BB30AA5E83577ECEB4CC168DAE95F9EE | 否 | 解压到 `env/android-sdk/cmdline-tools/latest` |
| 2026-05-24 | env/apache-maven-3.9.11-bin.zip | Maven Central `https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.11/apache-maven-3.9.11-bin.zip` | Maven 3.9.11 安装包 | 0D7125E8C91097B36EDB990EA5934E6C68B4440EEF4EA96510A0F6815E7EEADB | 否 | 解压后目录为 `env/apache-maven-3.9.11` |
| 2026-05-24 | env/android-sdk/platform-tools | Android SDK Manager | ADB 与 platform-tools | SDK manager installed package | 否 | version 37.0.0 |
| 2026-05-24 | env/android-sdk/platforms/android-35 | Android SDK Manager | Android API 35 编译平台 | SDK manager installed package | 否 | `platforms;android-35` version 2 |
| 2026-05-24 | env/paper_artifacts/tabbed-out | 论文 artifact 仓库 `https://github.com/beerphilipp/tabbed-out.git` | 后续 Android app 与实验机制的主要代码参考 | commit `3ada3bb1fc317cdf9a442a52445614ee5a8b7cff` | 否 | 使用 sparse checkout；检出 `README.md`、`LICENSE`、`pocs/`、`analysis/README.md`、`analysis/pipeline/`、`analysis/input/`；排除 `analysis/results/`，因为其中存在 Windows 保留文件名 |
| 2026-05-25 | env/gradle-8.0-bin.zip | Gradle 官方分发包 `https://services.gradle.org/distributions/gradle-8.0-bin.zip` | Android app 本地构建工具 | 4159B938EC734A8388CE03F52AA8F3C7ED0D31F5438622545DE4F83A89B79788 | 否 | 解压后目录为 `env/gradle-8.0` |
| 2026-05-25 | env/build-tools_r35_windows.zip | Android Repository `https://dl.google.com/android/repository/build-tools_r35_windows.zip` | Android Build Tools 35.0.0 离线安装包 | 5753C679A1B90BCF6FBC9945A2CE39DFB9E74F1DF0831A1E1866AE5B594326F0 | 否 | 解压到 `env/android-sdk/build-tools/35.0.0` |
| 2026-05-25 | env/platform-33-ext3_r03.zip | Android Repository `https://dl.google.com/android/repository/platform-33-ext3_r03.zip` | Android API 33 编译平台离线安装包 | B32B10F787867987F03AE8E101D217E053A9065B7136379FB353B388379AED1D | 否 | 解压并整理到 `env/android-sdk/platforms/android-33`；用于兼容 AGP 8.0.2 |
| 2026-05-25 | env/maven-repo | Gradle cache 与 Maven/Google 仓库下载缓存 | Android app 构建时优先使用的本地 Maven 仓库 | 多文件，按需重新生成 | 否 | 包含 AGP/Kotlin plugin marker、`aapt2`、`androidx.arch.core:core-runtime` 等构建依赖缓存 |
| 2026-05-25 | env/leidian | 从 `F:\Mobile Security\env\leidian` 本地复制 | 雷电模拟器与其自带 adb，用于后续 E01-E04 本地实验 | 本地目录，约 2.67 GB / 429 files | 否 | 含 `LDPlayer9/adb.exe`；仅用于本地授权模拟器测试 |
