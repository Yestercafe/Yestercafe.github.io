---
layout: wiki
title: Archlinux
---

## 装系统

现在可以直接用 `archinstall` 安装了。

`archinstall` 不太好用的话可以装 Archlinux GUI（ALG），全 GUI 安装。

## AUR

安装 paru：

```shell
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

或者安装 yay，不过 yay 现在也依赖于 paru：

```shell
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

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

先尝试安装 `archlinux-keyring`：

```shell
sudo pacman -Syy
sudo pacman -S archlinux-keyring
```

如果换用国内源，继续尝试：

```shell
sudo pacman -S archlinuxcn-keyring
```

不行再重建一下 gpg：

```shell
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux
# 还不行则尝试
sudo pacman-key --refresh-keys
```

### Pacman: failed to synchronize all databases (unable to lock database)

```shell
sudo rm -rf /var/lib/pacman/db.lck
```

### Emacs 29 缺一些库，2023-08-02

没的装，Archlinux 提供的库太新了/太旧了，直接用 $ln$ 把别的版本做软链过去就可以了。

举个例子：

```bash
# emacs: error while loading shared libraries: libicudata.so.73: cannot open shared object file: No such file or directory
sudo ln -s /usr/lib/libicudata.so /usr/lib/libicudata.so.73
```

### vim: version GLIBC_2.28 not found (required by vim)

开启 32 位库源：打开 `/etc/pacman.conf`，取消注释 `[multilib]` 的两行的注释。

安装 `glibc` 和 `lib32-glibc`。
