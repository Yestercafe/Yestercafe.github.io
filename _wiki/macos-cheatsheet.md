---
layout: wiki
title: MacOS Cheatsheet
---

- [系统管理](#系统管理)
  - [Recovery 模式](#recovery-模式)
  - [Time Machine](#time-machine)
  - [搭载 T2 芯片的 MacBook 重置 SMC](#搭载-t2-芯片的-macbook-重置-smc)
  - [重置 NVRAM 和 PRAM](#重置-nvram-和-pram)
- [Dock 栏、Finder、Desktop 等](#dock-栏finderdesktop-等)
  - [修改 Dock 栏自动隐藏时指针悬浮后显示的响应时间](#修改-dock-栏自动隐藏时指针悬浮后显示的响应时间)
  - [修改 Dock 栏显示或自动隐藏的动画时间](#修改-dock-栏显示或自动隐藏的动画时间)
  - [关闭切换应用时自动切换 Desktop/workspace](#关闭切换应用时自动切换-desktopworkspace)
  - [启动长按按键连续输入](#启动长按按键连续输入)
  - [修改截图保存路径](#修改截图保存路径)
  - [修正 Finder 中的一些图标位置错位的异常](#修正-finder-中的一些图标位置错位的异常)
- [软件问题](#软件问题)
  - [解决 Homebrew update 过慢的问题](#解决-homebrew-update-过慢的问题)
  - [修复 App 损坏](#修复-app-损坏)
- [macOS Big Sur 相关](#macos-big-sur-相关)
  - [修复 TNT 破解版 Parallels Desktop 16 在 macOS Big Sur 中的网络初始化问题](#修复-tnt-破解版-parallels-desktop-16-在-macos-big-sur-中的网络初始化问题)
  - [VSCode 内建终端卡顿](#vscode-内建终端卡顿)
- [杂类整合](#杂类整合)
  - [允许所有来源下载的 App](#允许所有来源下载的-app)
  - [修复刚开机的锁屏界面壁纸始终为默认的问题（重建锁屏壁纸缓存）](#修复刚开机的锁屏界面壁纸始终为默认的问题重建锁屏壁纸缓存)
  - [修改 VMware Fusion 中的虚机网络 IP 地址段](#修改-vmware-fusion-中的虚机网络-ip-地址段)
  - [关于 `._` 开头的文件](#关于-_-开头的文件)
- [外链](#外链)

## 系统管理

### Recovery 模式

开机时按住 `Command + R`。

### Time Machine

Reserve.

### 搭载 T2 芯片的 MacBook 重置 SMC

电源、电池、风扇相关的问题可以通过重制 SMC 尝试解决。

<div style="text-align:center"><em>
  <span style="font-size:14px">都市传说：针对于非全新安装的 Big Sur 卡顿也有奇效。</span><br>
  <span style="font-size:10px">不过经过测试好像真的有点效果（心理作用）。</span>
</em></div>

1. 关机
2. 按住 Command + Option + **右** Shift 7秒
3. 在不松开的上三个键情况下，再加按电源键（一共四个键）7 秒
4. 电脑全程应该会经历出现 Logo，然后强制关机。等待几秒后按电源键开机。

无 T2 参考官方：[https://support.apple.com/zh-cn/HT201295](https://support.apple.com/zh-cn/HT201295)

### 重置 NVRAM 和 PRAM

[https://support.apple.com/zh-cn/HT204063](https://support.apple.com/zh-cn/HT204063)

这俩类似 BIOS 存储的信息，这个操作可能跟取下 BIOS 电池晾一天效果类似。

> 将 Mac 关机，然后开机并立即同时按住以下四个按键：Option、Command、P 和 R。您可以在大约 20 秒后松开这些按键，在此期间您的 Mac 可能看似在重新启动。  
> - 如果 Mac 电脑发出启动声，您可以在第二次启动声过后松开这些按键。
> - 在搭载 Apple T2 安全芯片的 Mac 电脑上，您可以在 Apple 标志第二次出现并消失后松开这些按键。 

## Dock 栏、Finder、Desktop 等

### 修改 Dock 栏自动隐藏时指针悬浮后显示的响应时间

[https://blog.csdn.net/leebe/article/details/46789455](https://blog.csdn.net/leebe/article/details/46789455)

```bash
# 修改为自定义值
defaults write com.apple.Dock autohide-delay -float 0.2 && killall Dock

# 还原为默认值
defaults delete com.apple.Dock autohide-delay && killall Dock
```

### 修改 Dock 栏显示或自动隐藏的动画时间

[https://blog.csdn.net/weixin_30408739/article/details/99605755](https://blog.csdn.net/weixin_30408739/article/details/99605755)

```bash
# 修改为自定义值
defaults write com.apple.dock autohide-time-modifier -float 0.5 && killall Dock

# 还原为默认值
defaults delete com.apple.dock autohide-time-modifier && killall Dock
```

### 关闭切换应用时自动切换 Desktop/workspace

[http://www.michael1e.com/disable-desktop-switching-mac-osx/](http://www.michael1e.com/disable-desktop-switching-mac-osx/)

```bash
defaults write com.apple.dock workspaces-auto-swoosh -bool NO && killall Dock
```

恢复

```bash
defaults delete com.apple.dock workspaces-auto-swoosh && killall Dock
```

### 启动长按按键连续输入

即“关闭 Apple 按下长按功能”。

```bash
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
```

重启。

恢复

```bash
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true
```

### 修改截图保存路径

```bash
defaults write com.apple.screencapture location /path/to/screenshots/ && killall SystemUIServer
```

### 修正 Finder 中的一些图标位置错位的异常

[https://zh.wikipedia.org/wiki/.DS_Store](https://zh.wikipedia.org/wiki/.DS_Store)

不太好描述，举个例子。我有个移动硬盘，这个移动硬盘在我每次重新挂载上再打开里面的文件夹时，在图标视图下里面文件的排列方式很是奇怪，并不对齐，需要手动整理才行。

此时才去了解到，Finder 窗口的大小、位置、显示选项等等都是与 `.DS_Store` 相关的。所以压缩文件的时候也无需特地回避的，不会泄露什么隐私信息。

使用 `find` 指令可以递归删除所有 `.DS_Store`：

```bash
find . -name .DS_Store -delete
```

参考 Wikipedia，禁止生成 `.DS_Store` 可以执行：

```bash
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

# 恢复
defaults delete com.apple.desktopservices DSDontWriteNetworkStores
```

## 软件问题

### 解决 Homebrew update 过慢的问题

[https://yescafe.github.io/wiki/linux-deploy-help/#homebrew-macos](https://yescafe.github.io/wiki/linux-deploy-help/#homebrew-macos)

或

[https://www.cnblogs.com/tp0829/p/Homebrew.html](https://www.cnblogs.com/tp0829/p/Homebrew.html)

### 修复 App 损坏

```bash
sudo xattr -rd com.apple.quarantine /Applications/sample.app
```

## macOS Big Sur 相关

### 修复 TNT 破解版 Parallels Desktop 16 在 macOS Big Sur 中的网络初始化问题

[https://blog.csdn.net/sinat_30732593/article/details/111305700](https://blog.csdn.net/sinat_30732593/article/details/111305700)

修改文件 `/Library/Preferences/Parallels/network.desktop.xml`，在 `ParallelsNetworkConfig` 标签中添加：

```xml
<UseKextless>0</UseKextless>
```

最后效果类似：

```xml
<ParallelsNetworkConfig>
  ………………
  ………………
  <UseKextless>0</UseKextless>
</ParallelsNetworkConfig>
```

### VSCode 内建终端卡顿

```bash
codesign --remove-signature /Applications/Visual\ Studio\ Code.app/Contents/Frameworks/Code\ Helper\ \(Renderer\).app
```

## 杂类整合

### 允许所有来源下载的 App

```bash
sudo spctl --master-disable
```

关闭不一定需要 `--master-enable`，直接在“系统偏好设置-安全性与隐私”中切换即可。

### 修复刚开机的锁屏界面壁纸始终为默认的问题（重建锁屏壁纸缓存）

打开 Finder，`Command+Shift+G` 进入目标文件夹 `/Library/Caches/`，创建目录 `Desktop Pictures`，进入，再创建一个与用户 UUID 相同的文件夹。用户的 UUID 不是 UID。在“系统偏好设置-用户与群组”中，解锁后，右击左侧的用户项，在“高级选项…”（如果没有解锁就没有这个）中有一栏 UUID。最后在设置中重新设置壁纸，可以看到目录下自动生成了 `lockscreen.png`。

最后的目标是：

```
/Library/Caches/Desktop Pictures/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/lockscreen.png
```

成功生成。

### 修改 VMware Fusion 中的虚机网络 IP 地址段

[https://blog.csdn.net/netgc/article/details/108182377](https://blog.csdn.net/netgc/article/details/108182377)

修改文件 `/Library/Preferences/VMware\ Fusion/networking`，可以看到 `VNET_8_HOSTONLY_SUBNET` 的 token，修改它的 value。vnet8 是 VMware 默认的 NAT 网络模式的虚拟网卡。

而后停止、配置、重新开启网络服务：

```bash
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```

如果没有提前关闭 VMware，就重启。如果虚拟机网络的 DHCP 模式没有自动调整 IP 地址，使用 `dhclient` 手动重新调整。手动模式就手动调整。

### 关于 `._` 开头的文件

为 macOS 保存文件属性的元数据，不会在苹果的分区里出现（应该）。我第一次见到是在 exfat 分区中 `ls -a`。

无需留意，也无需删除。因为删除了还是会生成。

## 外链

Cheatsheets:

[https://sourabhbajaj.com/mac-setup/](https://sourabhbajaj.com/mac-setup/)

[https://macos-defaults.com/](https://macos-defaults.com/)

破解版软件下载（学习所用，请勿传播）:

[https://www.macbl.com/](https://www.macbl.com/)

[https://www.inpandora.com/](https://www.inpandora.com/)