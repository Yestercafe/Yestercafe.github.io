---
layout: wiki
title: Ubuntu
categories: Linux
description: 个人的 Ubuntu 配置方法
keywords: Linux, Ubuntu
archived: true
---
重装系统后反复去找一些东西的配置非常麻烦，于是整合一下。注意两点：  
1. 长期更新；  
2. 不一定是按顺序配置的；  
3. 下列所有在 Ubuntu 18.04 LTS 测试通过。  

## 常用的 URL 集合
### 软件
VSCode: [https://code.visualstudio.com/docs/?dv=linux64_deb](https://code.visualstudio.com/docs/?dv=linux64_deb)  
IntelliJ IDEA: [https://www.jetbrains.com/idea/download](https://www.jetbrains.com/idea/download)  
PyCharm: [https://www.jetbrains.com/pycharm/download](https://www.jetbrains.com/pycharm/download)  

### 库
Tensorflow: [https://www.tensorflow.org](https://www.tensorflow.org)  
Tensorflow google.cn: [https://tensorflow.google.cn](https://tensorflow.google.cn)  
PyTorch: [https://pytorch.org](https://pytorch.org)  

### 镜像站
Tsinghua Open Source Mirrors: [https://mirrors.tuna.tsinghua.edu.cn](https://mirrors.tuna.tsinghua.edu.cn)    

### 发行版
KDE neon: [https://neon.kde.org](https://neon.kde.org)   

### 仓库
electron-ssr-backup: [https://github.com/qingshuisiyuan/electron-ssr-backup](https://github.com/qingshuisiyuan/electron-ssr-backup)  
ClashY: [https://github.com/SpongeNobody/Clashy](https://github.com/SpongeNobody/Clashy)   
ohmyzsh: [https://github.com/ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)  
zsh-syntax-highlighting: [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/ohmyzsh/ohmyzsh)  
zsh-autosuggestions: [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)  

## Ubuntu 安装
不知道为何，在我的 x1c 上安装 Ubuntu 18.04 以后的版本会显示不出 grub 菜单。而且稳定起见，也还是推荐安装 Ubuntu 16.04 LTS 或者 Ubuntu 18.04 LTS。速度慢的话可以去 Tsinghua Open Source Mirror 下载。   
还有一个比较好的 KDE 桌面环境的版，KDE neon。但是因为*听说* kde 桌面环境的系统级代理只能作用于 kde 的原生应用，所以还没有尝试过，毕竟装系统非常麻烦。 

Tsinghua Open Source Mirror: [https://mirrors.tuna.tsinghua.edu.cn](https://mirrors.tuna.tsinghua.edu.cn)   
KDE neon: [https://neon.kde.org](https://neon.kde.org)   

使用 USTC 源时，可能会被解析到 IPv6 地址，此时需要禁用 IPv6。
```
# /etc/gai.conf
# 取消注释 precedence ::ffff:0:0/96  100
```

## 时间(双系统)
Windows 和 Ubuntu 会因为时间存储标准不同产生时差，双方面均可修改，这里选用在 Windows 下修改。**但是警告，这么做让 BIOS 时间产生错误。** 
在 Powershell 下执行： 
```powershell
reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1
```
或者添加指令对应的注册表文件项重启即可。

reference: [https://www.jianshu.com/p/cf445a2c55e8](https://www.jianshu.com/p/cf445a2c55e8)

## apt
先到 `Software & Updates` 中更换 apt 源。推荐清华源。 
```bash
sudo apt update && sudo apt upgrade && sudo apt autoremove
sudo apt install -y gcc g++ clang python3 python3-pip vim git wget curl zsh gnome-tweak-tool openjdk-8-jdk gdebi exfat-fuse
sudo apt install -y ibus-pinyin ibus-mozc  # IME
```

## git
### git 配置
```bash
git config --global user.name yescafe
git config --global user.email qyc027@gmail.com
```
### git 代理
#### HTTP 协议
```bash
git config --global http.proxy 127.0.0.1:HTTP_PORT
git config --global https.proxy 127.0.0.1:HTTP_PORT
```
#### git 协议
git 协议是走 SSH 的，直接修改 SSH 的配置： 
`~/.ssh/config`:
```
Host github.com
    User git
    # ProxyCommand socat - PROXY:127.0.0.1:%h:%p,proxyport=HTTP_PORT
    # ProxyCommand nc -v -x 127.0.0.1:SOCKS_PORT %h %p
```
使用 HTTP 代理解注释 L3，需安装 socat；使用 SOCKS5 代理解注释 L4，需安装 netcat。

### SSH 密钥
```bash
ssh-keygen -t rsa -C qyc027@gmail.com
```
添加到 GitHub 上。  

## 代理
### Shell 代理
#### proxychains
安装：   
```bash
sudo apt install proxychains
```
配置 `proxychains`：  
```
# /etc/proxychains.conf
# 注释最后一行
# 添加
http 127.0.0.1 HTTP_PORT
```
使用：  
```
proxychains git fetch
```

#### 变量
```
export http_proxy=127.0.0.1:HTTP_PORT
export https_proxy=127.0.0.1:HTTP_PORT
```
使用局部值修饰指令，举例：
```
http_proxy=127.0.0.1:HTTP_PORT https_proxy=127.0.0.1:HTTP_PORT git fetch
```

### 代理工具
#### Qv2ray
[https://github.com/Qv2ray/Qv2ray/releases](https://github.com/Qv2ray/Qv2ray/releases)
[https://github.com/v2ray/v2ray-core/releases](https://github.com/v2ray/v2ray-core/releases)

#### ClashY (deprecated)
直接到 ClashY repo releases 中下载 AppImage 包，或者应该会有存盘，加 executable 权限运行。 
*更新：ClashY 已经有 deb 包了。*  
desktop 文件参考配置：  
```desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=ClashY
Exec=/home/ivan/Programs/ClashY/Clashy-0.1.9.AppImage
Icon=/home/ivan/Programs/ClashY/icon.ico
StartupWMClass=ClashY
```
*图标可以去 source repo 下载: [icon.ico](https://github.com/SpongeNobody/Clashy/raw/master/build-resources/icon.ico)*

ClashY 目前不支持 Linux/GNOME 自动设置系统代理，所以系统代理需要手动配置。  
ClashY repo: [https://github.com/SpongeNobody/Clashy](https://github.com/SpongeNobody/Clashy)  

#### Electron-SSR (deprecated)
直接找到存盘的 deb 包进行安装。  
```bash
sudo dpkg -i `ls | grep ssr`
```
然后使用 Terminal 启动 `electron-ssr`，Terminal 中会输出 debugging log，便于锁定缺失的依赖。   
根据 source repo(backup) 提供的 readme，需要补充一些依赖：  
```bash
sudo apt install -y python libcanberra-gtk-module libcanberra-gtk3-module gconf2 gconf-service libappindicator1 libssl-dev libsodium-dev
```

electron-ssr-backup repo: [https://github.com/qingshuisiyuan/electron-ssr-backup](https://github.com/qingshuisiyuan/electron-ssr-backup)  

## zsh
zsh 在第二步已经一并装好了，直接安装 `oh-my-zsh`  
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
插件 `zsh-syntax-highlighting`：
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```
插件 `zsh-autosuggestions`：
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

最后为当前用户和 `root` 用户设置默认终端：  
```bash
chsh -s /bin/zsh `whoami`
chsh -s /bin/zsh root
```

ohmyzsh: [https://github.com/ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)  
zsh-syntax-highlighting: [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)  
zsh-autosuggestions: [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)  

## snap 代理
```bash
sudo systemctl edit snapd

### nano: append
[Service]
Environment="http_proxy=http://127.0.0.1:HTTP_PORT"
Environment="https_proxy=http://127.0.0.1:HTTP_PORT"
### nano: save&exit

sudo systemctl daemon-reload
sudo systemctl restart snapd
```

reference: [https://kuricat.com/gist/snap-install-too-slow-zmbjy](https://kuricat.com/gist/snap-install-too-slow-zmbjy)  

## pip
```
# ~/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
```
提供一些其他的源：  
> （1）阿里云 http://mirrors.aliyun.com/pypi/simple/  
> （2）豆瓣 http://pypi.douban.com/simple/  
> （3）清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/  
> （4）中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/  
> （5）华中科技大学 http://pypi.hustunique.com/  

reference: [https://blog.csdn.net/sinat_21591675/article/details/82770360](https://blog.csdn.net/sinat_21591675/article/details/82770360)    

### 使用 pqi
在知乎上看到一个自动配置 pip 源的工具，很方便, pip 就可以装：   
```bash
pip install pqi
```
用法见指令。   

## Tensorflow
```bash
# pip install --upgrade pip
python3 -m pip install --upgrade pip
# pip install tensorflow
pip install tensorflow --user
```
Tensorflow: [https://www.tensorflow.org](https://www.tensorflow.org)  
Tensorflow google.cn: [https://tensorflow.google.cn](https://tensorflow.google.cn/)  

## Anaconda
Anaconda 可以去官网或者清华镜像站下载。  

### Anaconda 国内镜像站
```
# ~/.condarc
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

Anaconda: [https://www.anaconda.com/distribution](https://www.anaconda.com/distribution)  
Anaconda 2019.10 on Tsinghua Mirrors: [https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2019.10-Linux-x86_64.sh](https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2019.10-Linux-x86_64.sh)  
reference: [https://mirror.tuna.tsinghua.edu.cn/help/anaconda](https://mirror.tuna.tsinghua.edu.cn/help/anaconda)   

Anaconda Desktop 配置参考： 
```
[Desktop Entry]
Version=1.0
Type=Application
Name=Anaconda
Exec=/home/ivan/anaconda3/bin/anaconda-navigator
Icon=/home/ivan/anaconda3/pkgs/anaconda-navigator-1.9.7-py37_0/lib/python3.7/site-packages/anaconda_navigator/static/images/anaconda-icon-256x256.png
Categories=Development;
Terminal=false
StartupNotify=true
StartupWMClass=Anaconda-Navigator
Actions=notebook;jupyterlab;

[Desktop Action notebook]
Name=Jupyter Notebook
Exec=/home/ivan/anaconda3/bin/jupyter notebook

[Desktop Action jupyterlab]
Name=JupyterLab
Exec=/home/ivan/anaconda3/bin/jupyter lab
```

## PyTorch
可以自己去官网配，这里只提供使用 conda 安装的两种方案：  
without cuda:  
```bash
conda install pytorch torchvision cpuonly -c pytorch
```
with cuda 10.1:
```bash
conda install pytorch torchvision cudatoolkit=10.1 -c pytorch
```

PyTorch: [https://pytorch.org](https://pytorch.org)   

## VSCode
VSCode 已经自带同步功能。  

VSCode 64-bit .deb download: [https://code.visualstudio.com/docs/?dv=linux64_deb](https://code.visualstudio.com/docs/?dv=linux64_deb)

## SwitchyOmega
登录 Google Account 即可开启同步。  
这里备份以下 GFWList 的 URL：  
[https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt](https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt)

## `deb` 包
使用 `gdebi` 工具可以快速安装 `deb` 包和补全依赖。  
安装：  
```bash
sudo apt install gdebi
```
使用方法：  
```bash
sudo gdebi crossover.deb
```

## Crossover
```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install gdebi
wget http://crossover.codeweavers.com/redirect/crossover.deb
sudo gdebi crossover.deb
/opt/cxoffice/bin/cxfix --auto
```

reference: [https://www.codeweavers.com/support/wiki/linux/linuxtutorial/install](https://www.codeweavers.com/support/wiki/linux/linuxtutorial/install)

## thefuck
Installation:
```bash
pip3 install thefuck --user
```

`eval` config (add into Bash RC):
```
# thefuck configuration
eval $(thefuck --alias)
```

reference: [https://github.com/ma6174/vim](https://github.com/ma6174/vim)

