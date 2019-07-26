---
layout: post
title:  "MIT 6.828 Startup/Lab1 记录"
date:   2019-07-26
excerpt: "MIT 6.828 操作系统工程 准备工作/Lab1 记录"
tag:
- OS
- MIT 6.828
comments: true
---

计划了一个多月了, 终于把这个项目给开了. MIT的6.828课程已是久仰大名了, 没想到有一天, 真的能够自己来过一遍这个课程, 来当一回MIT的"云学生".  

**该Lab1的工作环境为:** Ubuntu 18.04.2 LTS; gcc (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0; GNU Make 4.1;   

## 0. Tools and Tools Guide  
### Compiler Toolchain
在Lab开始之前, 我们需要检查编译器链的配置, 防止之后的编译报错.  
- 检查objdump:  
    ```    
    % objdump -i
    ```  
    要求: 第二行显示elf32-i386.  
    如我本地环境的输出结果为:  
    ```  
    BFD header file version (GNU Binutils for Ubuntu) 2.30
    elf64-x86-64
    (header little endian, data little endian)
    i386
    elf32-i386
    (header little endian, data little endian)
    i386
    elf32-iamcu
    (header little endian, data little endian)
    iamcu
    elf32-x86-64
    (header little endian, data little endian)
    i386
    a.out-i386-linux
    (header little endian, data little endian)
    i386
    pei-i386
    (header little endian, data little endian)
    i386
    pei-x86-64
    (header little endian, data little endian)
    i386
    elf64-l1om
    (header little endian, data little endian)
    l1om
    elf64-k1om
    (header little endian, data little endian)
    k1om
    elf64-little
    (header little endian, data little endian)
    i386
    l1om
    k1om
    iamcu
    --More--
    ```  
    考虑到我不是32位系统, 所以可能和官网描述有点误差, 暂时先不考虑这个问题, 如果有问题之后再想办法解决.  
- 检查gcc环境:  
    ```   
    % gcc -m32 -print-libgcc-file-name
    ```  
    要求: 输出结果类似 /usr/lib/gcc/i486-linux-gnu/*version*/libgcc.a or /usr/lib/gcc/x86_64-linux-gnu/*version*/32/libgcc.a 即可.  
    如我本地环境的输出结果为:  
    ```  
    /usr/lib/gcc/x86_64-linux-gnu/7/32/libgcc.a
    ```  
    因为我的gcc版本是7.4, 所以*version*的位置是7.  
    Ubuntu这个发行版还是比较舒服的, 很多库都是预置的, 即使没有使用apt装也是非常方便的. 在刚才的输出结果与上文不匹配时, 需要尝试安装下面这样东西:  
    ```
    % sudo apt-get install gcc-multilib
    ```
    然后需要安装两样工具:  
    ```
    % sudo apt-get install build-essential gdb
    ```

### QEMU Emulator  
我们需要为接下来编写的操作系统提供一个虚拟运行环境, 这里使用的是qemu模拟器. 下面一段摘自百度百科[$^{[1]}$](#ref1):  
> **软件优点编辑**   
> 1. 默认支持多种架构。可以模拟 IA-32 (x86)个人电脑，AMD 64个人电脑，MIPS R4000, 升阳的SPARCsun3 与PowerPC(PReP 及 Power Macintosh)架构  
> 2. 可扩展，可自定义新的指令集  
> 3. 开源，可移植，仿真速度快  
> 4. 在支持硬件虚拟化的x86构架上可以使用KVM加速配合内核ksm大页面备份内存，速度稳定远超过VMware ESX  
> 5. 增加了模拟速度，某些程序甚至可以实时运行  
> 6. 可以在其他平台上运行Linux的程序  
> 7. 可以储存及还原运行状态(如运行中的程序)  
> 8. 可以虚拟网络卡 

总之看了半天, 我也不清楚为什么要用它, 反正官方叫用的, 那就用就对了.  

根据"みさか9982"同学所提供的资料[$^{[2]}$](#ref2), 我尝试手动编译qemu. 在补全了所需的环境后, make出现了编译错误, 导致了编译的无法进行, 而且并没有找到原因(可能是gcc的版本过高了?). 在Jo叔的建议下, 直接使用apt进行安装:  
```
% sudo apt install qemu
```

### Debugging tips
这部分暂时不提了, 等用到的时候再说.   
直接参考官网文档: [https://pdos.csail.mit.edu/6.828/2018/labguide.html](https://pdos.csail.mit.edu/6.828/2018/labguide.html)

## Lab1: Booting a PC  
### Introducion   
这部分整了半天, 一觉醒来才发现, 哎哟woc, 原来我不是真的mit的学生.  
这部分是给mit学生提交作业评分用的, 略读的时候已经隐约感觉到了, 之后跟叔确认了一下, 确实是这样的.  
所以这个部分跳过.  

### Part I: PC Bootstrap
大多数专用名字我不是很喜欢翻译, 但是bootstrap这个词比较重要. 平时我们见的比较多的可能是它的简写形式, boot. 全写是bootstrap, 译为"引导".   
#### Getting Started with x86 assembly
讲的汇编, 说是不需要通读手册, 而是在需要的时候回来查.   
AT&T的汇编, 在我看csapp第三章的时候已经略有了解, 但是水平还是很菜, 并且没有真正写过. 走一步看一步好了.    



### 参考资料
[本家]: [6.828 / Fall 2018](https://pdos.csail.mit.edu/6.828/2018/index.html)  
[1]: <a id="ref1">[QEMU - 百度百科](https://baike.baidu.com/item/QEMU/)</a>  
[2]: <a id="ref2">[MIT-6.828-JOS-环境搭建](https://www.cnblogs.com/gatsby123/p/9746193.html)</a>  