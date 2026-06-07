---
title: macOS Clash TUN 旁路由搭建
slug: clash-tun-gateway-macos
date: 2026-06-07
tags: [macos, clash, network, proxy, tun]
---

## 背景

在 macOS 上使用 Clash Verge 的 TUN 模式，让同一局域网内的其他设备通过这台 Mac 作为网关（旁路由）上网，无需每台设备单独安装代理客户端。

## 架构

```
┌─────────┐     ┌─────────┐     ┌──────────┐
│ 设备 A   │────▶│         │────▶│          │
│ .50.192  │     │  Mac    │     │ Internet │
└─────────┘     │ .50.109 │     │          │
                │         │     └──────────┘
┌─────────┐     │ Clash   │
│ 设备 B   │────▶│ TUN     │
│ .50.xxx  │     │         │
└─────────┘     └─────────┘
```

其他设备将默认网关指向 Mac（192.168.50.109），流量经 Mac 的 Clash TUN 转发到外网。

---

## 一、Mac 端配置

### 1. 开启 IP 转发

```bash
sudo sysctl net.inet.ip.forwarding=1
```

持久化（重启后保留）：

```bash
echo "net.inet.ip.forwarding=1" | sudo tee -a /etc/sysctl.conf
```

### 2. 配置 pf NAT 规则

其他设备的流量到达 Mac 的 `en0` 后需要做源地址转换（NAT），否则回包无法正确返回。

创建 NAT 锚点文件 `/etc/pf.anchors/clash-nat`：

```
nat on en0 from 192.168.50.0/24 to any -> (en0)
```

> 将 `192.168.50.0/24` 替换为你的局域网网段，`en0` 替换为你的物理网卡。

编辑 `/etc/pf.conf`，在 `rdr-anchor` 之后和 `load anchor "com.apple"` 之后分别插入：

```
nat-anchor "clash-nat/*"
load anchor "clash-nat" from "/etc/pf.anchors/clash-nat"
```

最终 `/etc/pf.conf` 应该类似：

```
scrub-anchor "com.apple/*"
nat-anchor "com.apple/*"
rdr-anchor "com.apple/*"
nat-anchor "clash-nat/*"
dummynet-anchor "com.apple/*"
anchor "com.apple/*"
load anchor "com.apple" from "/etc/pf.anchors/com.apple"
load anchor "clash-nat" from "/etc/pf.anchors/clash-nat"
```

启用 pf 并加载规则：

```bash
sudo pfctl -e -f /etc/pf.conf
```

验证：

```bash
sudo pfctl -a "clash-nat" -s nat
# 应输出: nat on en0 inet from 192.168.50.0/24 to any -> (en0) round-robin
```

### 3. 确保 Clash TUN 已启用

在 Clash Verge 中确认 TUN 模式已开启，且 `fake-ip-range` 网段有对应的路由。

Clash Verge 的 TUN 配置示例（`config.yaml`）：

```yaml
tun:
  enable: true
  stack: mixed
  auto-route: true
  auto-detect-interface: true
  dns-hijack:
    - any:53
```

DNS 配置示例（`dns_config.yaml`）：

```yaml
dns:
  enable: true
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
```

---

## 二、其他设备配置

### DNS 配置

将设备的 DNS 服务器设为外网 DNS（如 `8.8.8.8`），这样 DNS 请求会经过 Mac 网关被 Clash TUN 截获，返回 Fake IP 实现透明代理。

**不要用路由器地址作为 DNS**，否则 DNS 请求不会经过 Mac 网关，Clash 无法拦截。

#### Linux（systemd-resolved）

```bash
# 查看网卡名
resolvectl status | grep "Link "

# 设置 DNS（假设网卡为 wlp0s20f3）
sudo resolvectl dns wlp0s20f3 8.8.8.8
sudo resolvectl flush-caches
```

#### 其他系统

在网络设置中将 DNS 手动指定为 `8.8.8.8`。

### 网关配置

将设备的默认网关设为 Mac 的局域网 IP：

```bash
# Linux 示例
sudo ip route replace default via 192.168.50.109
```

---

## 三、GitHub SSH 问题

由于 Clash TUN 开启 Fake IP 后所有 DNS 返回 `198.18.x.x`，SSH 连接 `github.com:22` 会被 TUN 拦截但无法正确转发（非 HTTP 流量）。

### 解决方案：SSH over HTTPS 端口

GitHub 支持通过 443 端口进行 SSH 连接（`ssh.github.com`）。在 `~/.ssh/config` 中添加：

```
Host github.com
    Hostname ssh.github.com
    Port 443
    User git
```

信任主机密钥：

```bash
ssh-keyscan -p 443 ssh.github.com >> ~/.ssh/known_hosts
```

验证：

```bash
ssh -T git@github.com
# 应输出: Hi <username>! You've successfully authenticated...
```

之后 `git clone/push/pull` 均正常，SSH 流量走 443 端口，Clash TUN 可以正确处理。

---

## 四、验证

在任意客户端设备上：

```bash
# 确认网关
ip route | grep default

# DNS 测试
nslookup google.com 8.8.8.8

# HTTP 测试
curl -I https://www.google.com

# 检查是否走了代理（返回 198.18.x.x 说明 Clash Fake IP 生效）
nslookup google.com
```

在 Mac 上抓包确认流量走向：

```bash
sudo tcpdump -i en0 -n host <客户端IP>
```

---

## 五、避坑指南

### ❌ 不要手动添加 Fake IP 路由

错误做法：

```bash
# 不要执行！
sudo route add -net 198.18.0.0/15 198.18.0.1
```

Clash 的 `auto-route: true` 会自动创建所需路由（`1/8`、`2/7`、`4/6`、……、`128/1`），覆盖全部公网 IP。手动加路由不仅多余，还可能导致 SSH 等非 HTTP 流量被错误导向 TUN 而失败。只要 `<client>` → Mac 的 NAT 通了，TUN 会自动接管后续转发。

### ❌ 不要让客户端 DNS 指向局域网地址

如果客户端 DNS 设为路由器（如 `192.168.50.1`），由于在同一个二层网络，DNS 请求通过 ARP 直连路由器，不会经过 Mac 网关，Clash 的 `dns-hijack` 无法拦截，Fake IP 不生效。

正确做法：客户端 DNS 设为外网地址（如 `8.8.8.8`）。非局域网目标迫使 DNS 包走默认网关（Mac），TUN 在 53 端口截获并返回 Fake IP。

### ❌ 不要每台设备配 hosts 绕过

遇到某个域名（如 github.com）SSH 不通，正确的修法是让 SSH 走 443 端口（见第三节），而不是 `echo "xxx github.com" >> /etc/hosts`。hosts 方案不可扩展且会漏过代理。

---

## 六、注意事项

1. **Mac 重启后**：IP 转发和 pf NAT 规则需确认生效（`sysctl net.inet.ip.forwarding`、`sudo pfctl -s nat`）。
2. **Clash 未运行时**：通过 Mac 转发流量的设备将无法上网。
3. **与 `allow-lan` 的区别**：`allow-lan` 只是允许局域网设备连接 Clash 的 HTTP/SOCKS 代理端口（需手动配代理），本文方案是网关模式（透明代理）。
