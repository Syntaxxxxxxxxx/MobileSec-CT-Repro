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
