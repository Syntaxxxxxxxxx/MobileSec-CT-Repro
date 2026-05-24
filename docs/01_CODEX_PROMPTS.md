# 01_CODEX_PROMPTS.md

本文件记录本项目每一阶段喂给 Codex 的 prompt。

使用原则：

1. 每次新会话先输入 P00。
2. 大任务先输入“计划 prompt”，不要直接让 Codex 大改。
3. 每次实现后要求 Codex 更新 docs/04_LAB_NOTEBOOK.md 和 docs/05_REPRODUCTION_REPORT.md。
4. 所有工作必须中文记录。
5. 严格遵守本地实验和安全边界。

---

## P00：每次新会话恢复上下文

请先阅读以下文件：

- AGENTS.md
- docs/00_PROJECT_GUIDE.md
- docs/01_CODEX_PROMPTS.md
- docs/02_ENVIRONMENT.md
- docs/03_EXPERIMENT_MATRIX.md
- docs/04_LAB_NOTEBOOK.md
- docs/05_REPRODUCTION_REPORT.md
- 最近一次 experiments/*/observations.md

然后用中文回答：

1. 当前项目状态。
2. 已完成内容。
3. 缺失证据。
4. 当前最优先的三个下一步。
5. 每一步的验收标准。

暂时不要修改代码，先给计划。

---

## P00.5：先读论文并生成复现计划

请先不要写代码。请阅读：

- AGENTS.md
- docs/00_PROJECT_GUIDE.md
- paper/TabbedOut.pdf

然后生成 docs/08_PAPER_READING_PLAN.md 和更新 docs/03_EXPERIMENT_MATRIX.md。

要求：

1. 用中文总结论文的核心问题：
   - Custom Tabs state sharing
   - navigation callbacks
   - Cross-Context Leaks
   - State Inference Attack
   - HTTP Header Injection
   - SameSite Cookie Bypass
   - Scroll Inference Attack
   - Bottom Bar Spoofing

2. 为每个攻击/实验点建立表格：
   - 论文 section
   - 原论文实验现象
   - 是否适合本课程安全复现
   - 本项目是否复现
   - 本地替代实验设计
   - 需要的 app 功能
   - 需要的 server endpoint
   - 需要采集的证据
   - 风险等级
   - presentation 展示价值

3. 给出最终推荐的复现范围：
   - 必做实验
   - 可选实验
   - 不建议复现实验
   - 只做 negative result 的实验

4. 明确说明哪些内容只能做本地 mock，不得访问真实网站。

5. 更新 docs/04_LAB_NOTEBOOK.md，记录本次论文阅读和 plan 生成过程。

完成后只输出：
- 生成/修改的文件列表
- 推荐实验路线
- 下一步建议

不要实现 Android app，不要实现 server。

## P01：初始化项目文档和规范

你现在是我的移动应用安全课程论文复现工程助手。请全程使用中文工作。

项目目标：复现论文《Tabbed Out: Subverting the Android Custom Tab Security Model》中 Android Custom Tabs 的核心实验现象，并整理为期末 presentation。

请完成：

1. 阅读 AGENTS.md、docs/00_PROJECT_GUIDE.md、paper/TabbedOut.pdf。
2. 检查当前项目结构是否符合 docs/00_PROJECT_GUIDE.md。
3. 补全以下文档：
   - docs/02_ENVIRONMENT.md
   - docs/03_EXPERIMENT_MATRIX.md
   - docs/04_LAB_NOTEBOOK.md
   - docs/05_REPRODUCTION_REPORT.md
   - docs/06_PRESENTATION_OUTLINE.md
   - docs/07_RISK_AND_ETHICS.md
4. 初始化 experiments/E01 到 E04 的 README、commands.md、observations.md。
5. 输出第一阶段任务计划和验收标准。

安全要求：

- 不攻击真实网站。
- 不收集真实 cookie/token/password。
- 所有实验 endpoint 只使用本地 mock server。

---

## P02：创建项目内 skills

请在 .agents/skills/ 下补全四个项目内 skill：

1. mobile-paper-repro
2. android-ct-lab
3. experiment-recorder
4. presentation-builder

每个 skill 都必须包含 SKILL.md，并包含：

- name
- description
- 适用场景
- 输入材料
- 输出材料
- 工作步骤
- 安全边界
- 完成标准

要求：

- 全中文。
- 与 AGENTS.md 保持一致。
- 不要引入攻击真实网站的步骤。
- 完成后更新 docs/04_LAB_NOTEBOOK.md。

---

## P03：实现本地 mock server

请实现 server/app.py，使用 Flask 或 FastAPI 均可。

目标：为 Android Custom Tabs 实验提供本地 endpoint。

要求：

1. 默认监听 0.0.0.0:8000。
2. Android 模拟器通过 http://10.0.2.2:8000 访问。
3. 实现 endpoint：
   - /basic
   - /status/200
   - /status/404-empty
   - /status/404-body
   - /redirect/http
   - /redirect/html
   - /content/pdf
   - /download
   - /delay/<ms>
   - /login
   - /profile
4. 每个请求记录 server log：
   - timestamp
   - method
   - path
   - status
   - user_agent
   - cookie_present
5. 不记录真实 cookie 值。
6. 提供 requirements.txt。
7. 提供 scripts/run_server.ps1。
8. 更新 server/routes.md。
9. 更新 docs/03_EXPERIMENT_MATRIX.md。

完成后请运行基本自测，并把命令和结果写入 docs/04_LAB_NOTEBOOK.md。

---

## P04：创建 Android app 初版

请在 app/ 下创建 Android Kotlin 实验 app，用于 E01_callback_baseline。

功能要求：

1. 首页提供 URL 输入框，默认 http://10.0.2.2:8000/basic。
2. 提供按钮：
   - 打开 Custom Tab
   - 清空事件日志
   - 导出事件 CSV
3. 使用 androidx.browser Custom Tabs。
4. 绑定支持 Custom Tabs 的浏览器，优先 Chrome。
5. 创建 CustomTabsSession 并注册 CustomTabsCallback。
6. 记录事件：
   - NAVIGATION_STARTED
   - NAVIGATION_FAILED
   - NAVIGATION_ABORTED
   - NAVIGATION_FINISHED
   - TAB_SHOWN
   - TAB_HIDDEN
   - extraCallback 的 name 和 bundle 摘要，如果可用
7. 每条事件记录字段：
   - experiment_id
   - timestamp_ms
   - relative_ms_from_launch
   - event_name
   - event_code
   - url
   - browser_package
   - android_version
   - browser_version
   - note
8. 所有事件同时：
   - 显示在 UI
   - 写入 Logcat，tag 为 CT_REPRO
   - 可导出 CSV
9. 注释和 README 使用中文。
10. 不请求真实网站。

完成后运行 Gradle build，记录命令、结果和 APK 路径。

---

## P05：补全 Windows 脚本

请补全 scripts/ 下的 PowerShell 脚本：

1. run_server.ps1
2. build_app.ps1
3. install_app.ps1
4. collect_logcat.ps1
5. screenshot.ps1
6. screenrecord.ps1
7. export_artifacts.ps1

要求：

- 每个脚本都有中文注释。
- 每个脚本支持传入 experiment_id 和 run_id。
- 输出文件统一保存到对应 experiments/E*/run_YYYYMMDD_HHMMSS/。
- logcat 只采集 CT_REPRO tag 的版本和完整版本各一份。
- 截图和录屏使用 adb。
- 每个脚本失败时给出清晰错误信息。

完成后更新 docs/02_ENVIRONMENT.md 和 docs/04_LAB_NOTEBOOK.md。

---

## P06：执行 E01_callback_baseline

请使用 experiment-recorder skill 执行 E01_callback_baseline。

实验 endpoint：

- /basic
- /status/200
- /status/404-empty
- /status/404-body

要求：

1. 创建 experiments/E01_callback_baseline/run_YYYYMMDD_HHMMSS/。
2. 记录环境信息。
3. 启动 server。
4. 构建并安装 app。
5. 清空 logcat。
6. 逐个打开 endpoint。
7. 导出 events.csv。
8. 采集 logcat。
9. 截图。
10. 写 observations.md。

observations.md 必须包含：

- hypothesis
- expected callback sequence
- observed callback sequence
- 是否符合论文机制
- 截图路径
- logcat 路径
- events.csv 路径
- 问题与修复建议

完成后更新 docs/04_LAB_NOTEBOOK.md 和 docs/05_REPRODUCTION_REPORT.md。

---

## P07：执行 E02_state_inference_oracle

请执行 E02_state_inference_oracle，目标是验证不同 HTTP 行为是否产生可区分 callback 序列或 timing 差异。

实验 endpoint：

- /redirect/http
- /redirect/html
- /download
- /content/pdf
- /delay/1000
- /delay/3000

要求：

1. 每个 endpoint 至少运行 3 次。
2. 导出 events.csv。
3. 统计每个 endpoint 的 callback sequence。
4. 统计 NAVIGATION_STARTED 到 NAVIGATION_FINISHED/ABORTED/FAILED 的时间差。
5. 生成一个 Markdown 表格写入 observations.md。
6. 如果现象与论文不一致，记录浏览器版本和可能原因。
7. 不访问真实网站。

完成后更新 docs/04_LAB_NOTEBOOK.md 和 docs/05_REPRODUCTION_REPORT.md。

---

## P08：执行 E03_state_sharing_cookie

请执行 E03_state_sharing_cookie，目标是验证本地测试 cookie/session 在 Custom Tab 与浏览器之间的状态共享现象。

实验 endpoint：

- /login
- /profile

流程：

1. 清理或记录当前浏览器状态。
2. 访问 /profile，记录未登录状态。
3. 访问 /login，设置 demo cookie。
4. 再访问 /profile，记录 logged-in 状态。
5. server log 只记录 cookie_present，不记录 cookie 值。
6. app 记录 callback sequence。
7. 截图记录页面差异。
8. 写 observations.md。

要求：

- 不使用真实账号。
- 不记录真实 cookie。
- 明确说明这是本地 demo session。

完成后更新 docs/04_LAB_NOTEBOOK.md 和 docs/05_REPRODUCTION_REPORT.md。

---

## P09：执行 E04_modern_mitigation_negative

请执行 E04_modern_mitigation_negative。

目标：记录现代浏览器对论文中部分漏洞的 mitigation 或 negative result。

内容：

1. 记录浏览器包名和版本。
2. 对 SameSite Strict Cookie Bypass 做本地安全模拟或 negative result 记录。
3. 对 HTTP Header Injection 做本地安全模拟或 negative result 记录。
4. 不安装来源不明的旧版浏览器。
5. 不攻击真实网站。
6. 说明 observed result 与论文结果的差异。
7. 分析可能的 mitigation 原因。

完成后更新 docs/04_LAB_NOTEBOOK.md 和 docs/05_REPRODUCTION_REPORT.md。

---

## P10：整理复现报告

请根据以下材料整理 docs/05_REPRODUCTION_REPORT.md：

- paper/TabbedOut.pdf
- docs/03_EXPERIMENT_MATRIX.md
- experiments/E01*/observations.md
- experiments/E02*/observations.md
- experiments/E03*/observations.md
- experiments/E04*/observations.md
- events.csv
- logcat
- server.log
- screenshots

报告结构：

1. 论文背景
2. 复现目标
3. 安全边界
4. 实验环境
5. 工程架构
6. E01 实验
7. E02 实验
8. E03 实验
9. E04 实验
10. 复现问题与修复
11. 与论文结果的一致性和差异
12. 局限性
13. 总结

要求：

- 全中文。
- 不夸大结果。
- 每个实验都要有证据路径。
- 明确说明没有攻击真实网站。

---

## P11：生成 presentation 大纲

请根据 docs/05_REPRODUCTION_REPORT.md 生成 docs/06_PRESENTATION_OUTLINE.md。

要求：

- 中文。
- 8 到 10 页。
- 每页包含：
  - 页标题
  - 3 到 5 个 bullet
  - 建议放置的截图、日志或图表
  - 演讲备注
- 结构建议：
  1. 标题页
  2. Android Custom Tabs 背景
  3. 论文核心发现
  4. 本地复现实验架构
  5. E01 callback baseline
  6. E02 callback oracle
  7. E03 state sharing cookie
  8. E04 mitigation / negative result
  9. 工程记录与踩坑
  10. 总结

---

## P12：最终检查

请对整个项目做最终检查。

检查内容：

1. 项目是否能构建。
2. server 是否能运行。
3. app 是否能安装。
4. E01-E04 是否都有：
   - commands.md
   - observations.md
   - logs
   - screenshots
   - events.csv，如果适用
5. docs/05_REPRODUCTION_REPORT.md 是否完整。
6. docs/06_PRESENTATION_OUTLINE.md 是否适合展示。
7. 是否存在违反安全边界的内容。
8. 是否有真实网站、真实 cookie、真实账号、真实 token 泄露。

输出：

- 已通过项目
- 缺失项目
- 必须修复项
- 可选优化项
- 最终展示建议

## P13：遇到实验异常时回查论文

当前实验出现了异常或结果不符合预期。请不要立刻大改代码。

请先做以下事情：

1. 阅读当前实验的：
   - experiments/E*/README.md
   - experiments/E*/commands.md
   - experiments/E*/observations.md
   - 最近的 logcat
   - 最近的 server.log
   - 最近的 events.csv

2. 回查 paper/TabbedOut.pdf 中与该实验相关的 section、figure、table。

3. 输出问题分析：

   - 本地 observed result 是什么？
   - 论文 expected behavior 是什么？
   - 两者是否真的矛盾？
   - 如果矛盾，可能原因是什么？
     - 浏览器版本差异
     - Android API 差异
     - server endpoint 构造不一致
     - app callback 记录不完整
     - 现代浏览器 mitigation
     - 实验步骤错误
   - 应优先检查哪三个点？

4. 只给出最小修改计划，不要直接重构。

5. 更新对应 observations.md 的“异常分析”小节。