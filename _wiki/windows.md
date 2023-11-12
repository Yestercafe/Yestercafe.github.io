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

## 解决将系统语言从中文切到英文后某些文本依然是中文的问题

### 欢迎界面

到 Settings - Time & language - Language & region - Administrative language settings - Welcome screen and new accounts - Copy settings...，将当前系统的语言设置拷贝到欢迎界面和系统账户。

### 编码问题

同样的 Administrative language settings，下面的 Language for non-Unicode programs，我这里保留了 Chinese (Simplified, China)，并且没有开启 UTF-8。

### Visual Studio

注册表找到：

1. `\Computer\HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode\(Default)`
2. `\Computer\HKEY_CLASSES_ROOT\Directory\shell\AnyCode\(Default)`

的值的路径中的 2052 改成 1033，前提是要装英文语言包。

### Visual Studio Code

直接卸载重装，会保留用户配置插件的。

### Bandizip

进软件修改语言 Windows 10 和 Windows 11 的右键菜单里都会变。

