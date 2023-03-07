---
layout: wiki
title: Archlinux
---

现在可以直接用 `archinstall` 安装了。

## Light Display Manager

```shell
sudo pacman -S lightdm
sudo pacman -S lightdm-gtk-greeter
```

## DWM

ref: <https://wiki.archlinux.org/title/dwm>

```shell
sudo pacman -S git
sudo pacman -S libx11
sudo pacman -S libxft
sudo pacman -S libxinerama
git clone git://git.suckless.org/dwm
cd dwm && make && make install
```

Config DWM for LightDM:

`/usr/share/xsessions/dwm.desktop`:

```
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
```

## Q&A

### error: linux-firmware: signature from xxx is unknown trust

```shell
pacman-key --init
pacman-key --populate archlinux
```
