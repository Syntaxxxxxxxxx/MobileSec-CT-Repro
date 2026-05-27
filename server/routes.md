# server/routes.md

## 1. 服务说明

本服务是 MobileSec-CT-Repro 的本地 mock server，只用于 Android Custom Tabs 课程复现实验。

- 默认监听：`0.0.0.0:8000`
- 本机访问：`http://127.0.0.1:8000`
- Android 模拟器访问：`http://10.0.2.2:8000`
- 启动脚本：`scripts/run_server.ps1`
- 默认日志：`server/server.log`

安全边界：

- 只服务本地 endpoint。
- 不访问真实网站。
- 不记录真实 cookie 值。
- server log 只记录 `cookie_present`，不记录 cookie 内容。

## 2. Server Log 字段

每个请求都会写入 CSV 格式 server log：

| 字段 | 含义 |
|---|---|
| `timestamp` | 本地时区 ISO 时间 |
| `method` | HTTP method |
| `path` | 请求 path，不含 query |
| `status` | HTTP 响应状态码 |
| `user_agent` | User-Agent header |
| `cookie_present` | 是否存在本地 demo session cookie，值为 `yes` 或 `no` |

## 3. Endpoint 列表

| Endpoint | 方法 | 实验编号 | 响应行为 | 预期用途 |
|---|---|---|---|---|
| `/` | GET | 环境检查 | 返回服务说明页面 | 确认 server 正常运行 |
| `/basic` | GET | E01 | HTTP 200，HTML 非空响应体 | callback baseline |
| `/status/200` | GET | E01/E02 | HTTP 200，HTML 非空响应体 | 对照组 |
| `/status/404-empty` | GET | E01/E02 | HTTP 404，空响应体 | 观察 4xx empty body callback 差异 |
| `/status/404-body` | GET | E01/E02 | HTTP 404，HTML 非空响应体 | 对比 empty body 与 non-empty body |
| `/redirect/http` | GET | E02 | HTTP 302 跳转到 `/basic` | 观察 HTTP redirect callback/timing |
| `/redirect/html` | GET | E02 | HTML meta refresh + JS 跳转到 `/basic` | 观察 HTML/JS redirect callback/timing |
| `/content/pdf` | GET | E02 | `Content-Type: application/pdf`，inline PDF | 观察 Content-Type 对 callback 的影响 |
| `/download` | GET | E02 | `Content-Disposition: attachment` | 观察 download 行为是否触发 aborted |
| `/delay/<ms>` | GET | E02 | 延迟 `ms` 毫秒后返回，范围 0-10000 | timing oracle 本地模拟 |
| `/login` | GET | E03 | 设置本地 demo session cookie | 构造 demo logged-in 状态 |
| `/profile` | GET | E03 | 根据 demo cookie 是否存在显示不同页面 | 验证 state sharing 本地现象 |

## 4. 自测命令

启动 server：

```powershell
.\scripts\run_server.ps1
```

本机请求：

```powershell
Invoke-WebRequest http://127.0.0.1:8000/basic -UseBasicParsing
Invoke-WebRequest http://127.0.0.1:8000/status/404-empty -UseBasicParsing -SkipHttpErrorCheck
Invoke-WebRequest http://127.0.0.1:8000/redirect/http -UseBasicParsing -MaximumRedirection 0 -SkipHttpErrorCheck
Invoke-WebRequest http://127.0.0.1:8000/delay/1000 -UseBasicParsing
```

Cookie demo：

```powershell
$s = New-Object Microsoft.PowerShell.Commands.WebRequestSession
Invoke-WebRequest http://127.0.0.1:8000/profile -WebSession $s -UseBasicParsing
Invoke-WebRequest http://127.0.0.1:8000/login -WebSession $s -UseBasicParsing
Invoke-WebRequest http://127.0.0.1:8000/profile -WebSession $s -UseBasicParsing
```
