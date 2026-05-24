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
