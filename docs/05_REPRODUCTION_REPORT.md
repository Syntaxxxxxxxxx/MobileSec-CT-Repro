# 05_REPRODUCTION_REPORT.md

## 1. 当前阶段

当前已完成 P00.5 论文阅读计划、P03 本地 mock server、P04 Android Custom Tabs 实验 app 构建。E01-E04 的正式运行证据尚未采集。

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
- Android SDK Platform 33：`env/android-sdk/platforms/android-33`
- Gradle 8.0：`env/gradle-8.0`

已确认论文 artifact / repo：

- 论文 `purl.org/ct-paper` 最终跳转到 `https://github.com/beerphilipp/tabbed-out`。
- 仓库包含 `analysis` 和 `pocs` 两部分。
- 已克隆到 `env/paper_artifacts/tabbed-out`，当前 commit 为 `3ada3bb1fc317cdf9a442a52445614ee5a8b7cff`。
- 本项目将其作为后续 Android app 与实验机制的主要代码参考，但不直接运行攻击 PoC。
- 由于 Windows 保留文件名限制，已使用 sparse checkout 排除 `analysis/results/`。

尚未配置：

- Android Emulator system image。
- AVD。
- Server 与 Android app 尚未在模拟器中联调。

## 6. P03 Mock Server 当前状态

已实现本地 Flask mock server。默认监听 `0.0.0.0:8000`，Android 模拟器通过 `http://10.0.2.2:8000` 访问。

已实现 endpoint：

- `/basic`
- `/status/200`
- `/status/404-empty`
- `/status/404-body`
- `/redirect/http`
- `/redirect/html`
- `/content/pdf`
- `/download`
- `/delay/<ms>`
- `/login`
- `/profile`

已完成本机自测：

- 状态码 endpoint 返回符合设计。
- HTTP redirect 返回 302 并指向 `/basic`。
- HTML redirect 页面返回 200。
- PDF endpoint 返回 `application/pdf`。
- Download endpoint 返回 attachment。
- `/delay/100` 总耗时约 0.103 秒。
- `/profile` 在 login 前显示 not logged in，访问 `/login` 后显示 logged-in demo user。
- `server/server.log` 只记录 `cookie_present=yes/no`，不记录 cookie 值。

当前 server 仍未与 Android app 联调；E01-E03 的 callback 证据需要等 app 完成后采集。

## 7. P04 Android Custom Tabs 实验 app 状态

已完成 Android Kotlin 实验 app 的第一版实现，位置为 `app/`。

已实现能力：

- 通过 `androidx.browser` 打开 Custom Tab。
- 使用 `CustomTabsCallback` 记录 navigation callback 与 `extraCallback`。
- 事件写入 UI。
- 事件写入 Logcat，tag 为 `CT_REPRO`。
- 事件导出为 CSV。
- CSV 字段覆盖项目要求的 `experiment_id,timestamp_ms,relative_ms_from_launch,event_name,event_code,url,browser_package,android_version,browser_version,note`。

构建结果：

```text
命令：& X:\env\gradle-8.0\bin\gradle.bat -p X:\app assembleDebug --no-daemon --console=plain --stacktrace
结果：BUILD SUCCESSFUL
APK：D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
APK size：1268863 bytes
```

兼容性记录：

- 当前使用 `compileSdk 33 / targetSdk 33`。
- 当前使用 `androidx.browser:browser:1.5.0`，与论文 artifact 中 `pocs/state_inference` 的 AndroidX Browser 版本一致。
- 原计划 `compileSdk 35` 在 AGP 8.0.2 / aapt2 8.0.2 下无法链接 Android 35 平台资源，因此降到 33。
- `androidx.browser:browser:1.8.0` 需要 `compileSdk >= 34`，与 AGP 8.0.2 推荐上限冲突，因此不采用。

尚未完成：

- 尚未安装 APK 到模拟器或授权测试设备。
- 尚未运行 E01 页面访问流程。
- 尚未采集 `CT_REPRO` logcat、CSV、截图或录屏。

下一步建议先执行 E01_callback_baseline：启动本地 mock server，安装 APK，打开 `http://10.0.2.2:8000/basic`、`/status/404-body`、`/redirect/http` 等安全本地 endpoint，采集 callback 序列并回填实验记录。

## 8. P05 Windows 脚本状态

已补全 P05 所需脚本，并复制雷电模拟器到当前项目 `env/leidian`。

脚本能力：

- `run_server.ps1`：启动本地 mock server。
- `build_app.ps1`：构建 app。
- `install_app.ps1`：安装 APK。
- `collect_logcat.ps1`：采集完整 logcat 与 `CT_REPRO` tag logcat。
- `screenshot.ps1`：采集截图。
- `screenrecord.ps1`：采集录屏。
- `export_artifacts.ps1`：导出 server log、CSV 和 artifact 清单。

验证结果：

- `build_app.ps1` 已成功产出 APK。
- `run_server.ps1` 已成功启动 server，并通过 `http://127.0.0.1:8000/basic` 返回 HTTP 200。
- adb 相关脚本在雷电模拟器未启动时给出明确中文错误提示。

下一步进入 P06 前，需要先启动雷电模拟器，使 `env/leidian/LDPlayer9/adb.exe devices` 出现 `device` 状态。

## 9. E01_callback_baseline 执行状态

Run 目录：

```text
experiments/E01_callback_baseline/run_20260525_225429/
```

当前结果：未完成完整 E01，阻塞于雷电模拟器 adb 设备不可用。

已完成：

- mock server 启动成功。
- E01 endpoints 本机请求验证成功：
  - `/basic` -> 200
  - `/status/200` -> 200
  - `/status/404-empty` -> 404
  - `/status/404-body` -> 404
- Android app 构建成功，APK 可用：
  `D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk`

未完成：

- app 未安装到模拟器。
- 未运行 Custom Tabs。
- 未采集真实 `CT_REPRO` logcat。
- 未采集真实 callback `events.csv`。
- 未采集模拟器截图。

失败点：

- `ldconsole launch --index 0` 可尝试启动雷电实例，但实例无法稳定保持运行，或无法注册 adb。
- `adb devices` 始终为空设备列表。
- 已尝试当前项目 `env/leidian` 和原始 `F:\Mobile Security\env\leidian` 两份路径。
- 已尝试将实例从 6 核/6144 MB 调整到 4 核/4096 MB，仍未解决。

判断：

本次不是论文机制 negative result，也不是 app/server 逻辑失败；它是本地模拟器运行环境阻塞。修复模拟器后应重新执行 E01，并以真实 callback sequence 更新本报告。

## 10. E01_callback_baseline 原路径雷电结果

使用原路径 `F:\Mobile Security\env\leidian\LDPlayer9\adb.exe` 后，雷电模拟器成功连接 adb，E01 重新执行并保存到：

```text
experiments/E01_callback_baseline/run_20260525_230617/
```

已完成：

- server 启动与 endpoint 状态码检查。
- app 构建与安装。
- app 自动化启动四个 endpoint。
- 采集 `commands.md`、`server.log`、`logcat_full.txt`、`logcat_ct_repro.txt`、`data/events.csv` 和截图。

结果：

```text
/basic -> BROWSER_NOT_FOUND, LAUNCH_SKIPPED
/status/200 -> BROWSER_NOT_FOUND, LAUNCH_SKIPPED
/status/404-empty -> BROWSER_NOT_FOUND, LAUNCH_SKIPPED
/status/404-body -> BROWSER_NOT_FOUND, LAUNCH_SKIPPED
```

解释：

当前雷电 Android 9 镜像中没有 Chrome，也没有任何支持 `android.support.customtabs.action.CustomTabsService` 的浏览器 provider。因此 E01 得到的是环境 negative result，而不是论文机制本身的反例。论文 Sec. 2.2 / Sec. 3.4 的 callback sequence 实验仍需要在存在 Custom Tabs provider 的浏览器环境中复跑。

下一步：

- 安装可信来源 Chrome/Chromium，或更换带 Chrome 的模拟器。
- 确认 Custom Tabs provider 可查询。
- 复跑 E01，获得 `NAVIGATION_STARTED` / `NAVIGATION_FINISHED` 等真实 callback sequence。

## 11. E01_callback_baseline Chrome 复跑结论

Run 目录：

```text
experiments/E01_callback_baseline/run_20260527_152504/
```

Chrome 安装后，`com.android.chrome` 暴露了 `org.chromium.chrome.browser.customtabs.CustomTabsConnectionService`，E01 已进入真实 Custom Tabs callback 采集阶段。LDPlayer 对宿主机 server 的有效访问地址为 `198.18.0.1:8000`，不是 Android Studio 模拟器常见的 `10.0.2.2:8000`。

本次有效观察如下：

```text
/basic            -> NAVIGATION_STARTED -> NAVIGATION_FINISHED
/status/200       -> NAVIGATION_STARTED -> NAVIGATION_FINISHED
/status/404-empty -> NAVIGATION_STARTED -> NAVIGATION_FAILED -> NAVIGATION_FINISHED
/status/404-body  -> NAVIGATION_STARTED -> NAVIGATION_FINISHED
```

这说明同为 404，空响应体与带 HTML body 的响应在 Chrome Custom Tabs callback 序列上可区分。该结果符合论文 Sec. 2.2 关于 navigation callbacks 的机制描述，也为 Sec. 3.4 / Sec. 3.4.1 中 callback sequence/timing oracle 的本地安全复现提供了基础。

证据路径：

- `experiments/E01_callback_baseline/run_20260527_152504/commands.md`
- `experiments/E01_callback_baseline/run_20260527_152504/server.log`
- `experiments/E01_callback_baseline/run_20260527_152504/logcat_ct_repro.txt`
- `experiments/E01_callback_baseline/run_20260527_152504/data/events.csv`
- `experiments/E01_callback_baseline/run_20260527_152504/screenshots/`
- `experiments/E01_callback_baseline/run_20260527_152504/observations.md`

阶段结论：E01 已完成，可以进入 E02_state_inference_oracle，继续测试 redirect、download、Content-Type、delay 等 endpoint 的 callback/timing 差异。
## 12. E02_state_inference_oracle 复现结果

Run 目录：

```text
experiments/E02_state_inference_oracle/run_20260527_153912/
```

本次使用 Chrome `138.0.7204.179` 和 LDPlayer，所有 endpoint 均为本地 mock server `http://198.18.0.1:8000`。每个 endpoint 有效运行 3 次。

| Endpoint | 次数 | 主要 callback sequence | 终止事件统计 | 首个终止平均 ms | 最后终止平均 ms | 最后终止 min-max ms |
|---|---:|---|---|---:|---:|---:|
| `content_pdf` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 97.7 | 97.7 | 82-114 |
| `delay_1000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 1027 | 1027 | 1012-1050 |
| `delay_3000` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 3020 | 3020 | 3020-3020 |
| `download` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_ABORTED` | `NAVIGATION_ABORTED:3` | 91.7 | 91.7 | 70-103 |
| `redirect_html` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> NAVIGATION_STARTED -> NAVIGATION_ABORTED -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 55.3 | 258 | 219-320 |
| `redirect_http` | 3 | `TAB_SHOWN -> NAVIGATION_STARTED -> NAVIGATION_FINISHED -> TAB_HIDDEN` | `NAVIGATION_FINISHED:3` | 245 | 245 | 123-458 |

结论：E02 成功复现出 callback sequence 与 timing oracle 的本地安全版本。HTML redirect、download/PDF content handling、以及 1000 ms/3000 ms delay 均可被宿主 app 的 Custom Tabs callback 记录为可区分模式。该结果对应论文 Sec. 3.4 / Sec. 3.4.1，但没有访问真实站点，也没有收集真实 cookie/token/账号数据。

证据：

- `experiments/E02_state_inference_oracle/run_20260527_153912/commands.md`
- `experiments/E02_state_inference_oracle/run_20260527_153912/server.log`
- `experiments/E02_state_inference_oracle/run_20260527_153912/logcat_ct_repro.txt`
- `experiments/E02_state_inference_oracle/run_20260527_153912/data/events.csv`
- `experiments/E02_state_inference_oracle/run_20260527_153912/data/sequence_timing_summary.csv`
- `experiments/E02_state_inference_oracle/run_20260527_153912/screenshots/`
- `experiments/E02_state_inference_oracle/run_20260527_153912/observations.md`
## 13. E03_state_sharing_cookie 复现结果

Run 目录：

```text
experiments/E03_state_sharing_cookie/run_20260527_181001/
```

本次使用本地 demo cookie 验证 Custom Tab 与普通 Chrome 浏览器共享状态。为保证实验可重置，mock server 增加 `/logout`，只清理 demo cookie，不记录 cookie 值。

| Step | Endpoint | 上下文 | `cookie_present` |
|---|---|---|---|
| reset | `/logout` | Custom Tab | yes，随后清理 |
| before | `/profile` | Custom Tab | no |
| login | `/login` | Custom Tab | no |
| after_ct | `/profile` | Custom Tab | yes |
| after_browser | `/profile` | Chrome 浏览器 | yes |

结论：Custom Tab 中 `/login` 设置的本地 demo cookie 会被同一底层 Chrome 浏览器状态共享；随后 Custom Tab 与普通 Chrome 访问 `/profile` 均为 `cookie_present=yes`。该结果对应论文 Sec. 2.1 的 state sharing 机制，并为 Sec. 3.4 的 state inference oracle 提供本地安全前提验证。

证据：

- `experiments/E03_state_sharing_cookie/run_20260527_181001/commands.md`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/server.log`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/logcat_ct_repro.txt`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/data/events.csv`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/screenshots/`
- `experiments/E03_state_sharing_cookie/run_20260527_181001/observations.md`
## 14. E04_modern_mitigation_negative 复现结果

Run 目录：

```text
experiments/E04_modern_mitigation_negative/run_20260527_182908/
```

本次使用现代 Chrome `com.android.chrome 138.0.7204.179`，只访问本地 mock server，不安装旧版浏览器，不访问真实网站。

| 测试项 | 观察结果 | 结论 |
|---|---|---|
| SameSite Strict 主文档 check | `/samesite/check` 主请求 `strict_cookie_present=no` | 现代 Chrome 未在初始主文档导航异常发送 Strict cookie |
| SameSite cross redirect | `10.12.173.13` -> `198.18.0.1` 目标 check 为 `strict_cookie_present=no` | 未复现 SameSite Strict bypass |
| Custom Tab direct check | CT 打开 `/samesite/check` 为 `strict_cookie_present=no` | native app CT 初始请求未异常携带 Strict cookie |
| Header CRLF probe | URL query 中 `%0D%0A X-CT-Repro-Injected` 未生成 header，`injected_header_present=no` | 未复现 Header Injection |
| Header control | PowerShell 显式 header 请求为 `injected_header_present=yes` | server 检测逻辑有效 |

结论：E04 记录为现代浏览器 mitigation / negative result。该结果对应论文 Sec. 3.5、Sec. 3.6 与 Sec. 4.3；论文中的旧版浏览器问题没有在 Chrome 138 本地安全模拟中复现。server log 只记录 cookie/header 是否存在，不记录 cookie 值或 header 值。

证据：

- `experiments/E04_modern_mitigation_negative/run_20260527_182908/commands.md`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/server.log`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/logcat_ct_repro.txt`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/data/events.csv`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/screenshots/`
- `experiments/E04_modern_mitigation_negative/run_20260527_182908/observations.md`
