---
layout: wiki
title: Windows & WSL
---

## 解决 Windows RDP 和文件共享登录时密码总是不正确的问题

ref: Stack Overflow，链接找不到了

我是使用的微软账号登录，并且在登录时使用 Authenticator，估计 Windows 大概是不知道我微软账号的密码的。

方法是重新从微软账号同步密码到本地：

```powershell
runas /u:[mail]@outlook.com cmd.exe
```

然后会让你输入微软账号的密码。等 cmd 窗口弹出，密码即同步完成。

此时即可使用你的用户名和微软账号密码访问 RDP 和文件共享了。

## 拒绝在 Windows 11 安装向导中联网

登录邮箱使用 no@thankyou.com 可能有效（网传，没有测试）。

ref: <https://zhuanlan.zhihu.com/p/629105280>

或者直接 Shift + F10 开 cmd，使用 `oobe\bypassnro` 程序绕过。

