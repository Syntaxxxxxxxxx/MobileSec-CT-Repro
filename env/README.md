# env/

本目录用于存放本地环境文件、大文件、临时下载物和不适合进入 Git 的实验材料。

## 目录说明

- downloads/：下载的 zip、tar、外部资源。
- paper_artifacts/：论文 artifact、PoC、measurement results 等外部材料。
- apks/：测试 APK、浏览器 APK、样例 APK。
- emulator/：模拟器配置、镜像说明或导出的环境索引。
- raw_logs/：体积较大的原始日志。
- tmp/：临时文件。

## Git 规则

env/ 下的大文件默认不提交 Git。
只提交 README.md 和 MANIFEST.md，用于记录文件来源、下载时间、用途和校验信息。

## 安全规则

- 不保存真实账号、真实密码、真实 cookie、真实 token。
- 不保存真实用户隐私数据。
- 不保存来源不明的危险 APK。
- 若保存浏览器旧版本 APK，仅用于离线安全复现实验说明，不用于攻击真实网站。