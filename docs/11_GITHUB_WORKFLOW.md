# 11_GITHUB_WORKFLOW.md

## 1. 仓库

https://github.com/Syntaxxxxxxxxx/MobileSec-CT-Repro.git
仓库名：MobileSec-CT-Repro
可见性：Public
默认分支：master
开发分支：无，项目采用线性提交历史

## 2. 分支规则

- master：唯一长期分支，用于记录课程复现过程、实验记录和最终展示材料。

项目保持线性历史；除非课程展示或回滚需要，不额外创建长期开发分支。

## 3. Issue 规则

每个任务必须有 issue。
commit 和 PR 应关联 issue 编号。

Issue 类型：

- area:paper
- area:android
- area:server
- area:scripts
- area:docs
- area:experiment
- area:presentation

## 4. Commit 规则

格式：

type(scope): summary

常见类型：

- feat
- fix
- docs
- test
- chore
- refactor

示例：

- docs(plan): add paper reading reproduction plan
- feat(server): add local callback oracle endpoints
- feat(android): record custom tabs navigation callbacks
- test(exp-e01): add baseline callback observations

commit body 包含：

- Related issue
- Evidence
- Verification
- Limitation

## 5. PR 规则

PR 必须包含：

- 修改内容
- 关联 issue
- 运行过的命令
- 实验证据路径
- 已知限制
- 是否涉及安全边界

## 6. Codex 使用规则

Codex 每次任务完成后必须：

1. 运行 git status。
2. 查看 git diff --stat。
3. 检查是否误加入 env/ 或大文件。
4. 更新 docs/04_LAB_NOTEBOOK.md。
5. 达到验收标准后创建语义化 commit。
6. push 前确认 public 仓库会公开提交历史，并得到用户明确指令。

## 7. 大文件规则

env/ 默认不进入 Git。
实验精选证据放 artifacts/。
大型原始日志、APK、视频放 env/ 或本地备份。
