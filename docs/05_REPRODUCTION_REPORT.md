# 05_REPRODUCTION_REPORT.md

## 1. 当前阶段

当前处于 P00.5：论文阅读与复现范围确定阶段。尚未实现 Android app，尚未实现 server，尚未执行 E01-E04 实验。

## 2. 论文依据摘要

论文《Tabbed Out: Subverting the Android Custom Tab Security Model》的核心发现是：Android Custom Tabs 同时具备两个对安全敏感的特性：

1. CT 与底层浏览器共享状态，包括 cookies、permissions、cache 等，见 Sec. 2.1。
2. CT 向宿主 app 暴露 navigation callbacks，见 Sec. 2.2。

二者结合后，宿主 app 可通过 callback sequence 或 timing 差异观察 Web 侧状态，形成论文所称的 Cross-Context Leaks。State Inference 的主要实验依据来自 Sec. 3.4 / Sec. 3.4.1；Header Injection、SameSite Cookie Bypass、Scroll Inference、Bottom Bar Spoofing 分别来自 Sec. 3.5、Sec. 3.6、Sec. 3.7、Sec. 3.8。

## 3. 本项目推荐复现范围

必做：

1. E01_callback_baseline：复现基础 callback 记录链路。
2. E02_state_inference_oracle：用本地状态码、redirect、download、Content-Type、delay 展示 callback/timing oracle。
3. E03_state_sharing_cookie：用本地 demo cookie/session 展示 state sharing。
4. E04_modern_mitigation_negative：对 Header Injection 与 SameSite Strict Cookie Bypass 做现代浏览器 negative result/mitigation analysis。

可选：

1. Scroll callback 本地观察。
2. Bottom bar UI 风险的中性本地演示。

不做：

1. 真实网站状态探测。
2. 真实 phishing。
3. 真实 Header Injection 攻击。
4. 真实 SameSite 绕过攻击。
5. 真实 cookie/token/password/账号数据采集。

## 4. 后续报告待补充

E01-E04 执行后，需要补充实验环境、命令、observed result、日志/截图/CSV 路径、与论文结果的一致性和差异分析。

## 5. 当前环境准备状态

已完成基础环境配置：

- JDK 17：`env/jdk-17.0.19+10`
- Maven 3.9.11：`env/apache-maven-3.9.11`
- Android command-line tools：`env/android-sdk/cmdline-tools/latest/cmdline-tools`
- Android platform-tools：`env/android-sdk/platform-tools`
- Android SDK Platform 35：`env/android-sdk/platforms/android-35`

已确认论文 artifact / repo：

- 论文 `purl.org/ct-paper` 最终跳转到 `https://github.com/beerphilipp/tabbed-out`。
- 仓库包含 `analysis` 和 `pocs` 两部分。
- 本项目不直接运行攻击 PoC，只参考其论文 artifact 结构与机制说明。

尚未配置：

- Android Emulator system image。
- AVD。
- Gradle wrapper。
- Android app 和 server 仍未实现。
