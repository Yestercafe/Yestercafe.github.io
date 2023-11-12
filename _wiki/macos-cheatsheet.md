---
layout: wiki
title: MacOS Cheatsheet
---

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
2. 按住 Control + Option + **右** Shift 7秒
3. 在不松开的上三个键情况下，再加按电源键（一共四个键）7 秒
4. 电脑全程应该会经历出现 Logo，然后强制关机。等待几秒后按电源键开机。

无 T2 参考官方：[https://support.apple.com/zh-cn/HT201295](https://support.apple.com/zh-cn/HT201295)

### 重置 NVRAM 和 PRAM

[https://support.apple.com/zh-cn/HT204063](https://support.apple.com/zh-cn/HT204063)

这俩类似 BIOS 存储的信息，这个操作可能跟取下 BIOS 电池晾一天效果类似。

> 将 Mac 关机，然后开机并立即同时按住以下四个按键：Option、Command、P 和 R。您可以在大约 20 秒后松开这些按键，在此期间您的 Mac 可能看似在重新启动。  
> - 如果 Mac 电脑发出启动声，您可以在第二次启动声过后松开这些按键。
> - 在搭载 Apple T2 安全芯片的 Mac 电脑上，您可以在 Apple 标志第二次出现并消失后松开这些按键。 

### Terminal 中显示主机名是 192 并无法在设置的共享中修改

```
sudo scutil --set HostName 'yourHostName'
```

ref: <https://stackoverflow.com/questions/67785772/mac-terminal-shows-myname192-instead-of-mynamemyname-mac-pro>

## Dock 栏、Finder、Desktop 等

### 重置 Dock 栏（包括图标摆设和 Dock 栏设置）

```bash
defaults delete com.apple.dock; killall Dock
```

### 重置 Launchpad 布局

```bash
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock
```

### 修改 Dock 栏图标大小

```bash
defaults write com.apple.dock "tilesize" -int "36" && killall Dock
```

### 修改 Launchpad 显示图标行列数量

```bash
defaults write com.apple.dock springboard-columns -int 8 && killall Dock
defaults write com.apple.dock springboard-rows -int 6 && killall Dock
```

复原直接删除即可重启即可。

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
defaults write com.apple.dock workspaces-auto-swoosh -bool YES && killall Dock
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

关闭在网络设备、服务器和可移动设备中生成 `.DS_Store`：

```bash
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
```

### 修复桌面图标消失、无法右击

```bash
defaults write com.apple.finder CreateDesktop true; killall Finder
```

### 强制开启 HiDPI

注意，[xzhih/one-key-hidpi](https://github.com/xzhih/one-key-hidpi) 对于无法解开 SIP 的 Big Sur 已经失效。这里采用的是另一个分支 [mlch911/one-key-hidpi](https://github.com/mlch911/one-key-hidpi)，支持 Big Sur 支持老版本系统。

```bash
git clone https://github.com/mlch911/one-key-hidpi.git
cd one-key-hidpi && ./hidpi.command
```

接着选择需要开启 HiDPI 的显示器，开启 HiDPI 无需注入 EDID。再之后是关键。经过我的测试，我的 VGA 接口的 1080P（1920x1080）的显示器，无法通过缺省的任何一个选项开启 HiDPI。HDMI 显示器没有测试。

我自己试出来的一种可行的方法是，手动输入分辨率：

```
3840x2160 1920x1080
```

最后重启电脑。将显示器设置中的分辨率调成显示器默认。

## 软件问题

### 解决 Homebrew update 过慢的问题

见 [#homebrew](#homebrew)。

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

## Homebrew

[https://brew.sh/](https://brew.sh/)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Homebrew 换源参考的是 [https://www.cnblogs.com/tp0829/p/Homebrew.html](https://www.cnblogs.com/tp0829/p/Homebrew.html)。网上大部分的文章都是在扯淡，根本没有完全换源，update 速度还是很慢。

替换 Homebrew、homebrew-core、homebrew-cask 的 Git remote 源：

```bash
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
# 确保 homebrew-cask 目录已经存在，没有可以使用 brew install --cask xxx 指令自动 clone
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-cask"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
```

修改 Homebrew-bottles 源。将下面的全局变量加入终端程序的 RC 文件中：

```bash
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
```

详情参考 [USTC Mirror Help](http://mirrors.ustc.edu.cn/help/)。

### Nerd Font
```bash
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
brew install --cask font-caskaydia-cove-nerd-font
brew install --cask font-victor-mono-nerd-font
brew install --cask font-source-code-pro
```

### Emacs plus

```bash
brew tap d12frosted/emacs-plus
brew install emacs-plus
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

[https://github.com/mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)

破解版软件下载（学习所用，请勿传播）:

[https://www.macbl.com/](https://www.macbl.com/)

[https://www.inpandora.com/](https://www.inpandora.com/)