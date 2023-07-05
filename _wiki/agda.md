---
layout: wiki
title: Agda
---

## 安装

首先通过安装 GHCup 来获取 cabal 或者 stack：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

对于不同的系统需要

特别的，对于 Fedora，需要提前安装：

```bash
sudo dnf install gmp-devel zlib-devel ncurses-devel
```

而后使用 cabal 下载编译 Agda 源码：

```bash
cabal install Agda
```


## PLFA

PLFA-zh 在线版地址：<https://agda-zh.github.io/PLFA-zh/>

克隆 PLFA 仓库到本地。注意，plfa 需要放在家目录：

```bash
# 官方
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/plfa/plfa.github.io ~/plfa
# 我的
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/Yescafe/plfa ~/plfa
```

创建 Agda 配置：

```bash
mkdir -p ~/.agda
cp ~/plfa/data/dotagda/* ~/.agda
```


## Emacs

Agda 的 Emacs 配置不在 ELPA 中。使用 cabal 或 stack 安装完 Agda 后，会同时得到指令 `agda-mode`，可以使用 `agda-mode locate` 获得 el 配置路径，可在 Emacs 直接 `load-file`：

```elisp
(load-file (let ((coding-system-for-read 'utf-8))
           (shell-command-to-string "agda-mode locate")))
```

而后可以在 Agda 代码中使用 `M-x agda2-mode` 激活 Agda mode。

键绑定表：

| 功能 | agda2-mode 默认 | zero.emacs 默认 |
| --- | --- | --- |
| 加载文件 | C-c C-l |  |
| 分项 | C-c C-c |  |
| 填洞 | C-c C-SPC | C-c SPC |
| 用构造子精化 | C-c C-r |  |
| 自动填洞 | C-c C-a |  |

使用 `M-x quail-show-key` 可以在 mini buffer 中查看当前 Unicode 字符的输入方式。
