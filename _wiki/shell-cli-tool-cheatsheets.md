---
layout: wiki
title: Shell/CLI Tool Cheatsheets
---

## SSH

SSH 默认会使用 `~/.ssh/id_rsa` 私钥的身份，可以使用 `-i` 参数手动指定私钥，比如：

```bash
ssh -i ~/Aliyun-id_rsa Aliyun
```

## Conda

使用 `conda` 创建环境：

```shell
conda create -n your_env_name python=x.x
```

删除环境

```shell
conda remove -n your_env_name --all
```

## Powershell

设置 PATH：

```powershell
$env:PATH += 'xxxx'
```

## NuShell

在 `$nu.env` 中加入：

```nu
$env.EDITOR = code
```

可以设置 `config nu` 和 `config env` 的编辑器。

