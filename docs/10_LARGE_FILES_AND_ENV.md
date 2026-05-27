# 10_LARGE_FILES_AND_ENV.md

## 1. env/ 使用规则

`env/` 用于存放本地大文件、下载物、外部 artifact、测试 APK、原始日志和临时文件。默认不提交 Git。

允许保存：

- 官方 JDK、Android SDK、Maven 等环境安装包。
- 论文 PDF 提取出的本地检索文本。
- 论文 artifact 或参考仓库的只读副本，但必须标明来源。
- 原始实验日志、截图、录屏、APK 等大文件。

禁止保存：

- 真实账号、真实密码。
- 真实 cookie、token、API key。
- 真实用户隐私数据。
- 来源不明 APK。
- 针对真实网站的攻击输出或敏感响应。

## 2. 当前已登记大文件/外部资源

详见 `env/MANIFEST.md`。当前已登记：

- `env/TabbedOut.txt`
- `env/paper_artifacts/tabbed-out`
- `env/microsoft-jdk-17.0.18-windows-x64.zip`
- `env/commandlinetools-win-14742923_latest.zip`
- `env/apache-maven-3.9.11-bin.zip`
- `env/android-sdk/platform-tools`
- `env/android-sdk/platforms/android-35`

## 3. 论文 artifact 仓库处理规则

论文 artifact 地址 `purl.org/ct-paper` 最终跳转到：

```text
https://github.com/beerphilipp/tabbed-out
```

仓库包含论文分析代码和攻击 PoC。若后续需要下载该仓库：

1. 只能保存到 `env/paper_artifacts/`。
2. 必须在 `env/MANIFEST.md` 记录来源、用途、时间和校验信息。
3. 只允许作为论文 artifact 参考，不直接运行攻击 PoC。
4. 不允许将真实网站 URL、真实 cookie、真实账号状态带入 PoC。

当前已克隆到：

```text
env/paper_artifacts/tabbed-out
```

Windows 注意事项：仓库的 `analysis/results/` 包含 Windows 保留文件名，例如 `con.*`。本项目使用 sparse checkout 保留 `pocs/` 和分析代码，排除 `analysis/results/`。
