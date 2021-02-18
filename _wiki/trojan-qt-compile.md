---
layout: wiki
title: Trojan-qt 编译手册
categories: Software
description: Trojan-qt 编译指南
keywords: Software, VPN, guidebook
archived: true
---

## 仓库
[https://github.com/trojan-gfw/trojan-qt](https://github.com/trojan-gfw/trojan-qt)
[https://github.com/Yescafe/trojan-qt](https://github.com/Yescafe/trojan-qt)

## 仓库克隆
```bash
git clone https://github.com/Yescafe/trojan-qt
cd ./trojan-qt/src/trojan
git clone https://github.com/trojan-gfw/trojan
git checkout 34df04b
```

## 依赖配置
### Qt
*Qt >= 5*  
官网下载十分麻烦, 换使用清华开源镜像站下载:   
[https://mirrors.tuna.tsinghua.edu.cn/](https://mirrors.tuna.tsinghua.edu.cn/)  
[https://mirrors.tuna.tsinghua.edu.cn/qt/official_releases/qt/5.14/5.14.1/qt-opensource-linux-x64-5.14.1.run](https://mirrors.tuna.tsinghua.edu.cn/qt/official_releases/qt/5.14/5.14.1/qt-opensource-linux-x64-5.14.1.run)  
qt 的安装程序有 GUI. 安装完成即可.  
qt 还缺少 OpenGL 的依赖:  
```bash
sudo apt install -y mesa-common-dev
sudo apt install -y libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev
```

### Cmake
*Cmake >= 2.8.12*
```bash
sudo apt install -y cmake
```

### Boost
*Boost >= 1.54.0*  
到官网下载, 解压. 下面以 1.72.0 版本为例:  
```bash
wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
tar -zxvf boost_1_72_0.tar.gz; cd boost_1_72_0
sudo ./b2 install
```
等待编译完成即可.  

### OpenSSL
*OpenSSL >= 1.0.2*
```bash
sudo apt install openssl
```

### libmysqlclient
```bash
sudo apt install libmysqlclient-dev
```

## 编译运行
```bash
cd ..  # trojan-qt
sudo apt install -y make
make
./trojan
```
