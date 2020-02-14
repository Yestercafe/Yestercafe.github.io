---
layout: wiki
title: Ubuntu
categories: Linux
description: 个人的 Ubuntu 配置方法
keywords: Linux, Ubuntu
---
重装系统后反复去找一些东西的配置非常麻烦, 于是整合一下. 注意两点:  
1. 长期更新  
2. 不一定是按顺序配置的

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
Tsinghua Open Source Mirror: [https://mirrors.tuna.tsinghua.edu.cn](https://mirrors.tuna.tsinghua.edu.cn)    

### 发行版
KDE neon: [https://neon.kde.org](https://neon.kde.org)   

### repos
electron-ssr-backup repo: [https://github.com/qingshuisiyuan/electron-ssr-backup](https://github.com/qingshuisiyuan/electron-ssr-backup)  
ClashY repo: [https://github.com/SpongeNobody/Clashy](https://github.com/SpongeNobody/Clashy)   
ohmyzsh: [https://github.com/ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)  
zsh-syntax-highlighting: [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/ohmyzsh/ohmyzsh)  
zsh-autosuggestions: [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)  

## Ubuntu 安装
不知道为何, 在我的 x1c 上安装 Ubuntu 18.04 以后的版本会显示不出 grub 菜单. 而且稳定起见, 也还是推荐安装 Ubuntu 16.04 LTS 或者 Ubuntu 18.04 LTS. 速度慢的话可以去 Tsinghua Open Source Mirror 下载.   
还有一个比较好的 KDE 桌面环境的版本, KDE neon. 但是因为*听说* kde 桌面环境的系统级代理只能作用于 kde 的 stock app, 所以还没有尝试过, 毕竟装系统非常麻烦.  

Tsinghua Open Source Mirror: [https://mirrors.tuna.tsinghua.edu.cn](https://mirrors.tuna.tsinghua.edu.cn)   
KDE neon: [https://neon.kde.org](https://neon.kde.org)   

# 时间
Windows 和 Ubuntu 会因为时间存储标准不同产生时差. 双方面均可修改, 这里选用在 Windows 下修改.
在 Powershell 下执行: 
```powershell
reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1
```
或者添加指令对应的注册表文件项重启即可.

reference: [https://www.jianshu.com/p/cf445a2c55e8](https://www.jianshu.com/p/cf445a2c55e8)

## apt
先到 Software & Updates 中更换 apt 源.
```bash
sudo apt update && sudo apt upgrade && sudo apt autoremove
sudo apt install -y gcc g++ clang python3 python3-pip vim git wget curl zsh gnome-tweak-tool
sudo apt install -y ibus-pinyin ibus-mozc  # IME
```

## 完成 git 配置
### git 配置
```bash
git config --global user.name yescafe
git config --global user.email qyc027@gmail.com
```
### ssh 密钥
```bash
ssh-keygen -t rsa -C qyc027@gmail.com
```
添加到 GitHub 上.   

## 代理配置
### 方案一. Electron-ssr
直接找到存盘的 deb 包进行安装. 
```bash
sudo dpkg -i `ls | grep ssr`
```
然后使用 Terminal 启动 `electron-ssr`, Terminal 中会输出 debugging log, 便于锁定缺失的依赖.   
根据 source repo(backup) 提供的 guide 提示, 可以一键补充一些依赖:  
```bash
sudo apt install -y python libcanberra-gtk-module libcanberra-gtk3-module gconf2 gconf-service libappindicator1 libssl-dev libsodium-dev
```

### 方案二. ClashY
直接到 ClashY repo releases 中下载 AppImage 包, 或者应该会有存盘, 加 executable 权限运行. 
desktop 文件参考配置: 
```desktop
[Desktop Entry]
Name=clashy
Exec=/home/ivan/Documents/Clashy.AppImage
Terminal=false
Type=Application
Icon=electron-ssr
Categories=Development;
```

Terminal 中的配置, 注意端口号的不同.  
electron-ssr:  
```bash
export http_proxy=127.0.0.1:12333;export https_proxy=127.0.0.1:12333
```
ClashY:  
```bash
export http_proxy=127.0.0.1:2340;export https_proxy=127.0.0.1:2340
```

electron-ssr-backup repo: [https://github.com/qingshuisiyuan/electron-ssr-backup](https://github.com/qingshuisiyuan/electron-ssr-backup)  
ClashY repo: [https://github.com/SpongeNobody/Clashy](https://github.com/SpongeNobody/Clashy)  

## zsh
zsh 在第二步已经一并装好了, 直接安装 oh-my-zsh 
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
插件 zsh-syntax-highlighting:
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```
插件 zsh-autosuggestions:
```bash
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

最后为当前用户和 root 用户设置默认终端: 
```bash
chsh -s /bin/zsh `whoami`
chsh -s /bin/zsh root
```

ohmyzsh: [https://github.com/ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)  
zsh-syntax-highlighting: [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)  
zsh-autosuggestions: [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)  

## snap 的代理配置
```bash
sudo systemctl edit snapd

### nano: append
[Service]
Environment="http_proxy=http://127.0.0.1:port"
Environment="https_proxy=http://127.0.0.1:port"
### nano: save&exit

sudo systemctl daemon-reload
sudo systemctl restart snapd
```

reference: [https://kuricat.com/gist/snap-install-too-slow-zmbjy](https://kuricat.com/gist/snap-install-too-slow-zmbjy)  

## pip
pip 官方 source 的下载速度鸡贼慢, 使用代理除外. 这个源是不推荐换的, 因为截止到去年年底, 使用清华源还是无法正确安装 Tensorflow 2.1, 建议还是使用 pip 官方 source.
```
# vim ~/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
```
提供一些其他的源: 
> （1）阿里云 http://mirrors.aliyun.com/pypi/simple/  
> （2）豆瓣 http://pypi.douban.com/simple/  
> （3）清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/  
> （4）中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/  
> （5）华中科技大学 http://pypi.hustunique.com/  

reference: [https://blog.csdn.net/sinat_21591675/article/details/82770360](https://blog.csdn.net/sinat_21591675/article/details/82770360)    

### pqi
在知乎上看到一个自动配置 pip 源的工具, 很方便, pip 就可以装:   
```bash
pip install pqi
```
用法见指令.    

## Tensorflow
```bash
# pip install --upgrade pip
python3 -m pip install --upgrade pip
# pip install tensorflow
pip install tensorflow --user
```
Tensorflow: [https://www.tensorflow.org](https://www.tensorflow.org)  
Tensorflow google.cn: [https://tensorflow.google.cn](https://tensorflow.google.cn/)  

## conda
Anaconda 可以去官网或者清华镜像站下载. 

conda 源不确定有没有像 pip 一样的隐患, 速度慢可以配一下: 
```
# vim ~/.condarc
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
reference: [https://mirror.tuna.tsinghua.edu.cn/help/anaconda](https://mirror.tuna.tsinghua.edu.cn/help/anaconda)  

## PyTorch
可以自己去官网配, 这里只提供使用 conda 安装的两种方案:  
non-cuda: 
```bash
conda install pytorch torchvision cpuonly -c pytorch
```
cuda 10.1:
```bash
conda install pytorch torchvision cudatoolkit=10.1 -c pytorch
```

PyTorch: [https://pytorch.org](https://pytorch.org)   
