---
layout: wiki
title: OpenCV
---

## 先决条件

```bash
sudo apt install -y cmake g++ wget unzip
sudo apt install build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libopenexr-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip
unzip opencv.zip
```

## CMake, Build and Install

```bash
cd opencv-4.x
cmake -B build .
cmake --build build -j$(nproc)
sudo cmake --install build
```

## Reference

1. <https://docs.opencv.org/4.6.0/d7/d9f/tutorial_linux_install.html>
2. <https://www.bilibili.com/read/cv18786305/>
3. <https://linuxize.com/post/how-to-install-opencv-on-ubuntu-20-04/>
