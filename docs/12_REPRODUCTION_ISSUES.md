# 12_REPRODUCTION_ISSUES.md

记录当前复现过程中发现的与原论文存在偏差或需要修正的问题。  
最后更新：2026-05-27

---

## ISSUE-01：`/redirect/html` 同时触发两种跳转机制，callback 序列偏离论文描述

**严重程度：中**（结论方向正确，但序列结构与论文不符）

### 论文原文（Sec. 3.4.1）

> If the login page `example.com/login` redirects to the landing page `example.com/home` using HTML or JavaScript redirections, **two `NAVIGATION_STARTED` and, respectively, also two `NAVIGATION_FINISHED` events are fired** — one for each page.

论文描述的是每个页面产生一对 START/FINISH，即双段序列：

```
NAVIGATION_STARTED → NAVIGATION_FINISHED → NAVIGATION_STARTED → NAVIGATION_FINISHED
```

### 实验实际结果（E02 run_20260527_153912）

```
TAB_SHOWN → NAVIGATION_STARTED → NAVIGATION_FINISHED
         → NAVIGATION_STARTED → NAVIGATION_ABORTED
         → NAVIGATION_STARTED → NAVIGATION_FINISHED → TAB_HIDDEN
```

出现了三段 navigation，中间有一个多余的 `NAVIGATION_ABORTED`。

### 根本原因（server/app.py:129-137）

```python
@app.get("/redirect/html")
def redirect_html() -> Response:
    body = """
  <meta http-equiv="refresh" content="0; url=/basic">
  <script>
    window.setTimeout(function () { window.location.href = "/basic"; }, 50);
  </script>
"""
```

`/redirect/html` 同时放置了 `<meta http-equiv="refresh" content="0">` 和 JS `setTimeout(..., 50ms)` 两个跳转触发器。meta refresh 在 t=0 立即发起导航，50ms 后 JS 再次发起导航时页面已处于跳转过程中，导致第二次 `NAVIGATION_STARTED → NAVIGATION_ABORTED`，Chrome 随后完成最终跳转产生第三段 `NAVIGATION_STARTED → NAVIGATION_FINISHED`。

论文测试的是单一跳转机制，而 mock server 同时触发了两种机制。

### 影响

- 核心结论（HTML redirect 比 HTTP redirect 产生更多事件）仍然成立。
- 但中间的 `NAVIGATION_ABORTED` 是 mock server 设计缺陷产生的噪声，论文中没有描述此事件。
- 报告若直接引用此序列而不说明，评阅者可能认为复现结果与论文描述不一致。

### 修复方案

只保留一种跳转机制。建议保留 `<meta http-equiv="refresh">`，因论文在 Sec. 3.4.1 明确提及此方式：

```python
@app.get("/redirect/html")
def redirect_html() -> Response:
    body = """
  <p>本页面通过 HTML meta refresh 跳转到 <code>/basic</code>。</p>
  <meta http-equiv="refresh" content="0; url=/basic">
"""
    return html_page("HTML redirect", body)
```

修复后预期序列：

```
NAVIGATION_STARTED → NAVIGATION_FINISHED → NAVIGATION_STARTED → NAVIGATION_FINISHED
```

---

## ISSUE-02：E04 测试的 Header Injection 攻击向量与论文机制不符

**严重程度：高**（测试了完全不相关的攻击面，不等价于论文 Sec. 3.5）

### 论文原文（Sec. 3.5）

论文描述的攻击链：

1. 攻击者 app 通过 `CustomTabsSession` API（bundle extras）向 CT 请求附加 CORS-approvelisted header。
2. 将 header value 设置为包含换行符的字符串，例如 `"normal-value\nX-Injected: malicious"`。
3. 旧版 Chrome/Edge/Brave 不过滤 header value 中的 `\n`，导致 HTTP 层面实际发出了两个 header，注入成功。
4. 已在 Chrome 109、Edge 109、Brave 1.47 修复。

攻击的关键要素是通过 **Android `CustomTabsSession` API 的 header value 中嵌入 `\n`**，属于应用层 API 调用路径问题。

### E04 实际测试方式

```
app CT 打开: /headers/echo?probe=line1%0D%0AX-CT-Repro-Injected:%20yes
```

E04 把 CRLF 编码放入 **URL 查询参数**，让浏览器在 URL 解析阶段（HTTP 层之前）处理 `%0D%0A`。这与论文机制完全无关：

| 维度 | 论文攻击（Sec. 3.5） | E04 实际测试 |
|---|---|---|
| 注入路径 | `CustomTabsSession` API 的 header value | URL query string 中的 `%0D%0A` |
| 注入位置 | HTTP header 层 | URL 解析层（浏览器解码 query 参数时处理） |
| 需要 DAL | 否（只需 CORS-approvelisted header） | 无关 |
| 漏洞本质 | CT API header value 换行过滤缺失 | URL 编码处理（与 CT 无关） |

任何现代浏览器都会在 URL 解析时清理 `%0D%0A`，与论文漏洞是否已修复无关。E04 的 negative result 无法证明"Chrome 138 对论文 Sec. 3.5 漏洞的修复有效"。

### 影响

- 当前 E04 对 Header Injection 的测试结论**不能**作为"论文 Sec. 3.5 漏洞已在 Chrome 138 上被修复"的证据。
- 若报告中写"E04 验证了 Chrome 138 不受 Header Injection 影响"，属于论据不支持结论。

### 修复方案

**方案 A（推荐，课程范围内可做）：**  
在 Android app 中实际调用 `CustomTabsIntent.Builder` 时，通过 `setCustomHeaders()` 或等价 bundle key 向 CT 请求注入含 `\n` 的 header value，观察 server 是否收到注入 header。Chrome 138 预期不会注入（negative result），但攻击路径和论文一致。

**方案 B（报告层面）：**  
如果不修改 app 代码，在报告中明确写：

> "E04 的 Header Injection 测试使用 URL CRLF 编码模拟，不等价于论文 Sec. 3.5 描述的 `CustomTabsSession` API header value 注入路径。本实验无法作为 Chrome 138 对该漏洞修复有效性的验证；该验证需要通过 app 侧 `CustomTabsSession.setCustomHeaders()` API 实施。"

---

## ISSUE-03：State Inference 完整攻击链未端到端演示

**严重程度：低**（课程安全边界合理，但报告需说明）

### 论文原文（Sec. 3.4）

论文的完整 State Inference Attack 链条：

```
用户已在浏览器中登录目标网站
    ↓  （Sec. 2.1 state sharing）
CT 打开该网站的某资源 URL
    ↓  （Sec. 3.4.1 callback oracle）
宿主 app 观察 callback 序列（redirect / 404-empty / ABORTED 等）
    ↓
app 推断用户是否登录（状态推断成功）
```

E02 和 E03 分别演示了：
- E02：不同 HTTP 行为产生可区分 callback（oracle 机制）
- E03：CT 与浏览器共享 cookie 状态（state sharing 前提）

但两者没有串联——没有演示"因为状态共享，所以 callback 序列会随用户登录状态变化，宿主 app 据此推断出用户状态"这一完整链条。

### 影响

- 论文的核心 contribution 是 State Inference Attack，而非只是"callback 序列可区分"。
- 报告需要明确说明 E02 + E03 是该攻击的两个前提，并解释为何不做端到端演示（安全边界：不访问真实网站）。

### 建议

在报告中明确写：

> "完整 State Inference Attack 需要目标网站根据用户登录状态返回不同 HTTP 行为（如登录后 302 到首页，未登录返回 404-empty），这需要访问真实网站的真实账号状态，超出本项目安全边界。E02 和 E03 分别验证了攻击的两个前提：callback oracle 机制（Sec. 3.4.1）和状态共享机制（Sec. 2.1），但未串联演示完整攻击链。"

---

## 问题优先级汇总

| 编号 | 问题 | 严重程度 | 是否影响结论正确性 | 建议处理方式 |
|---|---|---|---|---|
| ISSUE-01 | HTML redirect 双跳转机制 → callback 序列有多余 ABORTED | 中 | 是（序列与论文不符） | 修改 server/app.py，只保留 meta refresh |
| ISSUE-02 | Header Injection 测试向量与论文机制不符 | 高 | 是（论据不支持结论） | 修改 app 侧 API 调用，或在报告中如实说明局限性 |
| ISSUE-03 | State Inference 完整攻击链未端到端演示 | 低 | 否（前提已验证） | 在报告中说明安全边界和两实验的关系即可 |
