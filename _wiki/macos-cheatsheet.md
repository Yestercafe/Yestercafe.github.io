---
layout: wiki
title: MacOS Cheatsheet
---

- [破解版软件下载（学习所用，请勿传播）](#破解版软件下载学习所用请勿传播)
- [解决 Homebrew update 过慢的问题](#解决-homebrew-update-过慢的问题)
- [修复 App 损坏](#修复-app-损坏)
- [允许所有来源下载的 App](#允许所有来源下载的-app)
- [修复刚开机的锁屏界面壁纸始终为默认的问题（重建锁屏壁纸缓存）](#修复刚开机的锁屏界面壁纸始终为默认的问题重建锁屏壁纸缓存)
- [修改 dock 栏自动隐藏时指针悬浮后显示的响应时间](#修改-dock-栏自动隐藏时指针悬浮后显示的响应时间)
- [修改 dock 栏显示或自动隐藏的动画时间](#修改-dock-栏显示或自动隐藏的动画时间)
- [修复 TNT 破解版 Parallels Desktop 16 在 macOS Big Sur 中的网络初始化问题](#修复-tnt-破解版-parallels-desktop-16-在-macos-big-sur-中的网络初始化问题)
- [修改 VMware Fusion 中的虚机网络 IP 地址段](#修改-vmware-fusion-中的虚机网络-ip-地址段)

## 破解版软件下载（学习所用，请勿传播）

[https://www.macbl.com/](https://www.macbl.com/)

[https://www.inpandora.com/](https://www.inpandora.com/)

## 解决 Homebrew update 过慢的问题

[https://yescafe.github.io/wiki/linux-deploy-help/#homebrew-macos](https://yescafe.github.io/wiki/linux-deploy-help/#homebrew-macos)

或

[https://www.cnblogs.com/tp0829/p/Homebrew.html](https://www.cnblogs.com/tp0829/p/Homebrew.html)

## 修复 App 损坏

```bash
sudo xattr -rd com.apple.quarantine /Applications/sample.app
```

## 允许所有来源下载的 App

```bash
sudo spctl --master-disable
```

关闭不一定需要 `--master-enable`，直接在“系统偏好设置-安全性与隐私”中切换即可。

## 修复刚开机的锁屏界面壁纸始终为默认的问题（重建锁屏壁纸缓存）

打开 Finder，`Command+Shift+G` 进入目标文件夹 `/Library/Caches/`，创建目录 `Desktop Pictures`，进入，再创建一个与用户 UUID 相同的文件夹。用户的 UUID 不是 UID。在“系统偏好设置-用户与群组”中，解锁后，右击左侧的用户项，在“高级选项…”（如果没有解锁就没有这个）中有一栏 UUID。最后在设置中重新设置壁纸，可以看到目录下自动生成了 `lockscreen.png`。

最后的目标是：

```
/Library/Caches/Desktop Pictures/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/lockscreen.png
```

成功生成。

## 修改 dock 栏自动隐藏时指针悬浮后显示的响应时间

[https://blog.csdn.net/leebe/article/details/46789455](https://blog.csdn.net/leebe/article/details/46789455)

```bash
# 修改为自定义值
defaults write com.apple.Dock autohide-delay -float 0.2 && killall Dock

# 还原为默认值
defaults delete com.apple.Dock autohide-delay && killall Dock
```

## 修改 dock 栏显示或自动隐藏的动画时间

[https://blog.csdn.net/weixin_30408739/article/details/99605755](https://blog.csdn.net/weixin_30408739/article/details/99605755)

```bash
# 修改为自定义值
defaults write com.apple.dock autohide-time-modifier -float 0.5 && killall Dock

# 还原为默认值
defaults delete com.apple.dock autohide-time-modifier && killall Dock
```

## 修复 TNT 破解版 Parallels Desktop 16 在 macOS Big Sur 中的网络初始化问题

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

## 修改 VMware Fusion 中的虚机网络 IP 地址段

[https://blog.csdn.net/netgc/article/details/108182377](https://blog.csdn.net/netgc/article/details/108182377)

修改文件 `/Library/Preferences/VMware\ Fusion/networking`，可以看到 `VNET_8_HOSTONLY_SUBNET` 的 token，修改它的 value。vnet8 是 VMware 默认的 NAT 网络模式的虚拟网卡。

而后停止、配置、重新开启网络服务：

```bash
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```

如果没有提前关闭 VMware，就重启。如果虚拟机网络的 DHCP 模式没有自动调整 IP 地址，使用 `dhclient` 手动重新调整。手动模式就手动调整。