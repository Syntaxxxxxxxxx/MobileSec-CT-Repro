# MobileSec-CT-Repro

![Codex occupied](https://img.shields.io/badge/Codex-occupied-111111?style=for-the-badge)
![Android Custom Tabs](https://img.shields.io/badge/Android-Custom%20Tabs-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Local only](https://img.shields.io/badge/scope-local%20lab-blue?style=for-the-badge)
![No real targets](https://img.shields.io/badge/real%20targets-nope-red?style=for-the-badge)

## Codex 宣布占领本仓库！

准确地说，是帮忙把这个移动应用安全大作业从“桌面上一堆文件夹”占领成“看起来像个 repo 的东西”。人类还在，人类负责选题、验收、背锅和最后上台讲；Codex 负责在旁边疯狂敲字、整理实验记录，以及假装自己很懂 Android。

This repository has been peacefully occupied by Codex. The human still owns the grade, the topic, the safety boundary, and the consequences. Codex just moved in, labeled the folders, wrote too much Markdown, and started treating logcat as a lifestyle.

---

移动应用安全课的大作业仓库。主线任务：复现 IEEE S&P 2024 论文 **Tabbed Out: Subverting the Android Custom Tab Security Model** 里适合课堂展示的部分。

题目选了 IEEE S&P 2024 的 **Tabbed Out: Subverting the Android Custom Tab Security Model**。选题的时候觉得 “Custom Tabs 嘛，应该挺小一个东西”，后来发现它牵出来的是浏览器状态、Android app 回调、本地服务、CSV、logcat、截图、模拟器网络，以及“为什么这个 callback 又不按我想的来”。

Mobile App Security final project. The paper is about Android Custom Tabs; this repo is what happened after the project met a local mock server, an emulator, and several CSV files with trust issues.

## 🛑 先说清楚

这个仓库只做本地复现实验。

不打真实网站，不登录真实账号，不收集真实 cookie/token/password，不做真实 phishing 页面。所有 endpoint 都应该是 `localhost`、`127.0.0.1`、`10.0.2.2` 或者明确的本地测试地址。

In short: local lab only. No real targets, no real accounts, no real secrets. If something looks like an exploit idea, it gets translated into a boring local mock endpoint first. Boring is the point.

## 🧪 现在它在干什么

大概是这几件事：

- Android app 打开 Custom Tab，然后把 `CustomTabsCallback` 事件记下来。
- Flask server 装成各种奇怪 HTTP 行为：redirect、download、不同 Content-Type、delay。
- app 同时把事件写到 UI、logcat 和 CSV。
- 每跑一次实验，就把命令、截图、日志和观察结果丢进 `experiments/`。
- 如果现代浏览器已经把某个现象修了，那就老老实实写成 negative result，而不是硬编一个“复现成功”。

The English version is not much fancier: open Custom Tabs, record callbacks, poke local HTTP endpoints, collect evidence, and explain what happened without pretending the browser owes me the result I expected.

## 📋 实验列表

| ID | Name | 这组实验想看什么 |
|---|---|---|
| E01 | `callback_baseline` | 先确认 callback 记录链路能跑，别一上来就玄学 |
| E02 | `state_inference_oracle` | 不同 HTTP 行为会不会留下可区分的 callback/timing 痕迹 |
| E03 | `state_sharing_cookie` | Custom Tab 和浏览器共享本地测试状态这件事到底长什么样 |
| E04 | `modern_mitigation_negative` | 现代浏览器修了/挡了/不配合时，应该怎么记录 |

## 🗂️ 目录

```text
paper/        论文和笔记
app/          Kotlin Android app
server/       本地 Flask mock server
scripts/      PowerShell 小工具
docs/         计划、矩阵、实验日志、报告
experiments/  每次实验的命令、日志、CSV、截图、观察
artifacts/    最后整理出来能展示的东西
env/          本地环境和大文件，别随手提交
```

## 🔎 从哪里看起

如果只是想知道这仓库是不是在认真干活：

- `docs/03_EXPERIMENT_MATRIX.md`
- `docs/04_LAB_NOTEBOOK.md`
- `docs/05_REPRODUCTION_REPORT.md`

如果想复跑：

- `docs/02_ENVIRONMENT.md`
- `scripts/`
- `experiments/*/commands.md`

If you are grading this: the evidence is in `experiments/`, the story is in `docs/`, and the code is split between `app/` and `server/`.

## 🧯 一些不太学术但很真实的备注

- callback 序列看起来很客观，直到模拟器、Chrome 版本、网络地址一起开始整活。
- `10.0.2.2` 是朋友，除非你不用 Android 官方模拟器。
- logcat 很吵，但没有它又不行。
- CSV 是为了让“我感觉它不一样”变成“它确实有点不一样”。
- negative result 不是失败，是现代浏览器终于做了点该做的事。

## 📍 当前进度

E01 已经有一批 baseline 记录。E02 开始跑不同响应行为的 callback/timing 对比。后面还要继续补 E03/E04、整理 presentation，并把报告写得像人类真的读过论文。

E01 has baseline evidence. E02 has started collecting response-behavior traces. E03/E04 and the final presentation are still on the menu.
