# 00_PROJECT_GUIDE.md

## 1. 项目定位

本项目是移动应用安全期末论文复现实验。目标是围绕论文《Tabbed Out: Subverting the Android Custom Tab Security Model》构建一个可控的本地实验环境，复现 Android Custom Tabs 的关键安全机制。

最终交付包括：

1. Android Custom Tabs 实验 app。
2. 本地 mock server。
3. 四组实验 E01-E04。
4. 完整实验记录，包括命令、日志、截图、CSV、观察结论。
5. 中文复现报告。
6. 中文 presentation 大纲。

## 2. 复现边界

本项目不攻击真实网站，不收集真实用户数据。
所有现象通过本地 server endpoint 构造。

允许：

- 本地状态码实验。
- 本地 redirect 实验。
- 本地 delay/timing 实验。
- 本地 content-type/download 实验。
- 本地 cookie/session demo。
- 现代浏览器 negative result 分析。

禁止：

- 真实网站探测。
- 真实账号登录探测。
- 真实 cookie/token 收集。
- 真实 phishing 页面。
- 利用旧版浏览器攻击真实服务。

## 3. 核心机制

论文中的 Custom Tabs 安全问题主要来自两个机制的组合：

1. CT 与底层浏览器共享状态，例如 cookies、permissions、cache 等。
2. 宿主 app 可以接收 CT navigation callbacks，例如 NAVIGATION_STARTED、NAVIGATION_FINISHED、NAVIGATION_FAILED、NAVIGATION_ABORTED、TAB_SHOWN、TAB_HIDDEN。

如果不同用户状态或不同服务端响应会导致 callback 序列、事件类型或 timing 不同，则宿主 app 可以把 callback 当作 oracle，推断 Web 侧状态。

## 4. 实验总线

本项目使用：

- Android Kotlin app：负责打开 Custom Tab、注册 callbacks、记录事件。
- Python mock server：负责构造不同 HTTP 行为。
- PowerShell scripts：负责构建、安装、采集日志、截图、录屏。
- docs/ 与 experiments/：负责记录过程和证据。

## 5. 实验列表

### E01_callback_baseline

目的：验证 Android app 能够打开 Custom Tab 并记录基础 callback。
Endpoint：

- /basic
- /status/200
- /status/404-empty
- /status/404-body

证据：

- events.csv
- logcat.txt
- screenshots

### E02_state_inference_oracle

目的：验证不同 HTTP 响应行为会造成可区分 callback 序列或 timing 差异。
Endpoint：

- /redirect/http
- /redirect/html
- /download
- /content/pdf
- /delay/1000
- /delay/3000

证据：

- 不同 endpoint 的 callback sequence 对比表。
- timing 差异统计。

### E03_state_sharing_cookie

目的：验证 CT 与浏览器共享本地测试 cookie/session 的实验现象。
Endpoint：

- /login
- /profile

流程：

1. 先在 Chrome/CT 中访问 /login 设置 demo cookie。
2. 再用 CT 访问 /profile。
3. 比较有无 cookie 时 server 返回和 callback 结果。

证据：

- server.log 中 cookie_present 字段。
- app events.csv。
- 截图。

### E04_modern_mitigation_negative

目的：记录现代浏览器上某些论文漏洞无法直接复现的结果，并解释 mitigation。
内容：

- SameSite Strict Cookie Bypass 的 negative result 或安全模拟。
- Header Injection 的 negative result 或安全模拟。
- 记录 Chrome/Edge/Brave 版本。
- 说明与论文原结果的差异。

## 6. 最终 presentation 建议结构

1. 题目与复现目标
2. Android Custom Tabs 背景
3. 论文核心问题：state sharing + callbacks
4. 本地复现实验架构
5. E01 callback baseline
6. E02 callback oracle
7. E03 state sharing cookie
8. E04 modern mitigation / negative result
9. 工程过程记录：日志、截图、踩坑
10. 总结与安全启示