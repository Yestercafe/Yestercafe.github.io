---
layout: wiki
title: Docker
---

## Docker CLI

```bash
sudo pacman -S docker
```

在 Arch Linux 上测试，其他发行版应该均可使用包管理进行在线安装。

## Docker Desktop

[https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

macOS 和 Windows 可以直接安装 Docker Desktop，Linux 各发行版参考官方 docs 安装 Docker CE。

## 换源

[https://mirrors.ustc.edu.cn/help/dockerhub.html](https://mirrors.ustc.edu.cn/help/dockerhub.html)

这里只介绍使用 systemd 的系统。

编辑 `/etc/docker/daemon.json`，没有则创建。

添加内容：

```json
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"]
}
```

重启 daemon 和 Docker 服务：

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

检查 Docker 服务状态和配置是否生效：
```bash
# 服务状态
sudo systemctl status docker

# 是否生效看 Registry Mirrors
sudo docker info
```

其他系统参考上面的 USTC 源 help。

其他相关内容参考：

[Docker CE 源使用帮助](https://mirrors.ustc.edu.cn/help/docker-ce.html)

## Cheatsheet

### 查看正在运行的容器

```bash
docker ps
# -a：all（不加这个选项不会显示已经停止的容器）
# -q：仅显示每行的 ID 列
```

### 运行镜像

```bash
docker run ubuntu
# -i：交互模式
# -t：终端模式
# -d：默认 detached
# --name NAME：改名
# -p HPORT:CPORT：将容器的 CPORT 端口映射到本机的 HPORT 端口
# -v HPATH:CPATH：将本地的 HPATH 路径映射到容器的 CPATH 路径

# 如果没有下载则会下载，下载过的会直接从本地加载

docker run yescafe/gitpage:1.0-beta

docker run yescafe/gitpage:1.0-beta echo hello
```

### 启动/停止容器

```bash
docker start $container-id
docker stop $container-id
```

### 连接已启动容器（attach）

```bash
docker attach $container-id
```

### 断开当前连接容器连接（detach）

C-p, C-q

### 删除容器

```bash
docker rm $container-id

# 比如
docker rm `docker ps -aq`
```

### 查看本地镜像

```bash
docker image ls
# -a：未知
# -q：仅显示 ID
```

### 删除本地镜像

```bash
docker rmi $image-repository
```

### Diff & Commit（自打包镜像）

想了想这个标题还是直接叫这个，这样比较好理解。这组功能类似于 git。

与原镜像对比，可以在容器运行时操作：

```bash
docker diff $container-id
```

提交更改，将容器打包成镜像：

```bash
docker commit $container-id $new-image-name
# 这个 $new-image-name 一般为 user_name/repo_name:tag 构成，如 yescafe/gitpage:1.0-beta
```

## Dockefile

[https://www.bilibili.com/video/BV1v5411G7xc](https://www.bilibili.com/video/BV1v5411G7xc)

`hello-world.js`:

```js
console.log('Hello World)
```

`Dockerfile`:

```dockerfile
FROM ubuntu

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean

RUN apt update && apt install nodejs -y

WORKDIR /app

COPY . .

CMD ["node", "/app/hello-world.js"]
```

### 打包为镜像

```bash
docker build -t $new-image-name $path-to-dockerfile-workdir

# 比如 
docker build -t yescafe/gitpage:1.0-beta .
```