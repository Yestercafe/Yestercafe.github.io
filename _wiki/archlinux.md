---
layout: wiki
title: Archlinux
---

现在可以直接用 `archinstall` 安装了。

## Q&A

### error: linux-firmware: signature from xxx is unknown trust

```shell
pacman-key --init
pacman-key --populate archlinux
```
