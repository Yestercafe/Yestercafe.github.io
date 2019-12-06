---
layout: post
title: PC Assembly Language - 6.828 Assembly Guide Book
categories: [Assembly, MIT 6.828]
description: MIT 6.828 指定的汇编教材
keywords: Assembly, 6.828
---

csapp, 还有以后可能还会读一些汇编的书, 所以专门开了一个汇编category. 而且还放在6.828的分类下面.    
Lab1真的挺麻烦的, 看不懂代码, 需要的前置知识有点小多, 汇编就是一个部分.  
于是, 啃这个828的指定汇编书.   

因为内容不算太多, 所以就放在一篇里面了. 新的这个博客模板也挺方便的, 旁边会自动生成目录.  

## Chapter 1 - Introduction 导论  
最开始的导论部分说了一些基础知识.    

### 1.1 Number Systems 数字系统  
内存不会直接去存十进制数, 因为还是存二进制数简单, 这就不用多解释了.  

#### 1.1.1 Decimal 十进制数  
十进制数, 就是每一位乘上一个以10为底数的幂后求和, 具体是什么举个例子:    
$234 = 2 \times 10^2 + 3 \times 10^1 + 4 \times 10^0$  

#### 1.1.2 Binary 二进制数
二进制位之可能是1或者0, 表示方法类似十进制, 举个例子:  
$11001_2\\
= 1 \times 2^4 + 1 \times 2^3 + 0 \times 2^2 + 0 \times 2^1 + 1 \times 2^0 \\
= 16 + 8 + 1 \\
= 25$    
这个过程就是进制转换成十进制的方法.   
然后写了一些关于二进制加法, 乘法, 除法余数的内容, 内容比较多但是比较简单就不复制了.  

#### 1.1.3 Hexadecimal 十六进制数  
十六进制也好说, 表示一个位的数有十六个, A表示十进制10, B表示十进制11, 以此类推. 举例:  
$2BD_{16} \\
= 2 \times 16^2 + 11 \times 16^1 + 13 \times 16^0 \\
= 512 + 176 + 13
= 701
$  
后面说了一下怎么用8421码转换二进制为十六进制, 很简单, 这辈子也都不会忘, 所以略过.  

### 1.2 Computer Organization 计算机组件  
#### 1.2.1 Memory
在没有弄清楚memory这个词的实际意义之前, 先不在这里把翻译标成"内存", 即使十有八九都是对的.  

存储空间(memory)有着一套特殊的计量单位体系, 最小的单位是1字节(1 byte), 注意不是1个位(1 bit). 一台有32 megabytes(32 MiB)存储空间(原文依旧是memory)可以保存32兆字节(32 million bytes)的数据信息. *看到这个兆字节我就想到了Android O开始中文语言环境下存储空间单位也变成汉字(类似"兆字节""吉字节")这种睿智的改动.* 在内存(memory)中的每一个字节, 都被标上了一个独一无二的标签, 这就是**地址(address)**.  

内存在通常情况下都是一大块一大块得使用的(原文是is used in lager chunks than single bytes). 在PC架构中, 这些较大的块(sections)经常是以2字节的*字*(word), 4字节的*双字*(double word), 8字节的*四字*(quad word)和16字节的*节*(paragraph)出现的, 除了最后一个, 其他的东西也基本都在csapp里见过了.   

内存里的数据都是以数值(numeric)的方式存储的(这也是必然, 毕竟二进制不管是转十六进制还是十进制都比较容易). 字符的话, 需要一套合适的*字符码(character code)*, 来提供到数字的映射. 比较常见的, 美国标准信息交换码, 也就是俗称的ASCII. 后来出来一个升级版的叫Unicode, ASCII表示一个字符要一个字节, Unicode表示一个字符要一个字. 这样就能表示更多的字符了.  

#### 1.2.2 The CPU 中央处理器
总是说处理器频率, 算力什么的, 到底这只是一个执行指令的物理设备. 中央处理器处理的通常都是一些最简单的指令, 这些指令通常需要在CPU自己内部的一些*特殊存储(special storage)*里的数据, 这些*特殊存储*就是**寄存器(registers)**了. 这些寄存器的访问速度比内存要快上太多. *在csapp里提到的存储分级金字塔中, 寄存器是L0, 内存是L4, 中间还夹着三级高速缓存呢, 这怎么比.* 但是因为寄存器的数量有限(造价昂贵?), 程序员在编写代码的时候需要注意怎么分配使用寄存器了.  

在CPU里跑的是最基础的**机器语言(machine language)**, 这些机器语言的指令是纯数字, 而且还是二进制, 或者可以表示成十六进制, 但是还是太难看了. 于是人们就发明了一些更方便用文本字符形式描述的语言, 但是这些语言都必须要通过一些手段翻译(deciphered)成机器码, 这些用于翻译的程序被叫做**编译器(compiler)**程序.   
每种类型的CPU的机器码都是独特的, 所以mac上写的机器码不能在IBM机子上跑.  

计算机会使用**时钟(clock)**来*同步指令执行(to synchronize the execution of the instructions)*. 这个时钟会以固定的频率发出脉冲(这个固定频率一般被叫做**时钟速度(clock speed)**). 比如你买了个1.5GHz的电脑, 那它的时钟发脉冲的频率就是1.5GHz. 这个单位挺有意思, Hz好像不常识中的按每分钟计的, 而是以一个常数比率进行节拍(beats). CPU的各个部分会根据这个节拍(通常被称为**时钟周期(cycle)**)让他们的操作正确的进行, 就像节拍器能帮助曲子以正确的旋律演奏一样. *真可爱, 这是原文的比喻哦~* 一个指令需要多少个这样的节拍执行, 是跟CPU代数和型号有关系的. *这意思就是不能光看频率了? 频率相同性能也可能不同?* 

#### 1.2.3 The 80x86 family of CPUs 80x86家族的CPU全家福
IBM型PC有一块来自80x86家族的CPU, 这些CPU只是代数或者型号不同, 都是一个妈生的, 所以*基础机器语言*是一样的, 但是每一代都有增强(enhance). 下面是原文:  
> **8088,8086:** These CPU’s from the programming standpoint are identical. They were the CPU’s used in the earliest PC’s. They provide several 16-bit registers: AX, BX, CX, DX, SI, DI, BP, SP, CS, DS, SS, ES, IP, FLAGS. They only support up to one megabyte of memory and only operate in *real mode*. In this mode, a program may access any memory address, even the memory of other programs! This makes debugging and security very difficult! Also, program memory has to be divided into *segments*. Each segment can not be larger than 64K.  
> **80286:** This CPU was used in AT class PC’s. It adds some new instructions to the base machine language of the 8088/86. However, its main new feature is 16-bit protected mode. In this mode, it can access up to 16 megabytes and protect programs from accessing each other’s memory.  
> However, programs are still divided into segments that could not be bigger than 64K.  
> **80386:** This CPU greatly enhanced the 80286. First, it extends many of the registers to hold 32-bits (EAX, EBX, ECX, EDX, ESI, EDI, EBP, ESP, EIP) and adds two new 16-bit registers FS and GS. It also adds a new 32-bit protected mode. In this mode, it can access up to 4 gigabytes. Programs are again divided into segments, but now each segment can also be up to 4 gigabytes in size!  
> **80486/Pentium/Pentium Pro:** These members of the 80x86 family add very few new features. They mainly speed up the execution of the instructions.  
> **Pentium MMX:** This processor adds the MMX (MultiMedia eXentions) instructions to the Pentium. These instructions can speed up common graphics operations.  
> **Pentium II:** This is the Pentium Pro processor with the MMX instructions added. (The Pentium III is essentially just a faster Pentium II.)   

太多了不翻译了, 也挺好读的. 强调两个我关注到的点:  
1. 初代处理器提供了14个16位寄存器, 并且只支持1MiB的内存, 而且是在*实模式(real mode)*下操作的. 并且程序内存被分成了*段(segment)*, 每个段最大只能有64KiB. *这就是在以前的游戏机卡带只有那么小的原因?*  
2. 在80386那一代, 已经进入了32位处理器时代, 很多以前16位的寄存器被升级成了32位的, 新加入了两个16位寄存器, 引入了全新的32位保护模式.  

仅从这两点就可以看出, 这升级也是有够明显的.  

#### 1.2.4 8086 16-bit Registers 8086的16位寄存器
8086CPU提供了四个一般用途(general purpose)的寄存器, 或者叫通用寄存器吧, AX, BX, CX和DX. 这四个寄存器都能被分解成2个8位寄存器, 比如AX可以被分成AH和AL. *8位? 8位也就是一个字节, 于是自然这就是高8位和低8位了, AH的H表示HIGH, AL的L表示LOW.* 虽然可以拆, 但不代表他们独立, 修改了AX的值, AH和AL的值也会随之改变, 并且? *vis versa*? 搜了一下好像是"反之亦然"的意思.

SI和DI通常作为指针使用, 也可以当通用寄存器, 但是不能被分解成两个8位的.   

BP和SP通常用于指向机器语言栈中的数据.  

CS, DS, SS和ES被叫作*段寄存器(segment registers)*, CS是Code segment, DS是Data segment, SS是Stack segment, ES是Extra segment. 

IP是*Instruction Pointer*, 这个和CS已经在Lab1里遇到过了, 毕竟是回头再来看汇编的. IP与CS配合使用来跟踪下一个指令的地址. 一般情况下, CPU每处理一个指令IP就会指向下一个指令地址.  

FLAGS挺特殊的, 写C的时候也经常用到flag, 道理都差不多, 就是存上一个指令的执行信息的(如果有这样的信息的话), 只占一个位, 取值是1或者0.  

#### 1.2.5 80386 32-bit Registers 80386的32位寄存器  
刚才也提到过了, 80386开始16位寄存器都被扩展成32位了. 但是为了保证对下的兼容性, AX还是原来的那个16位寄存器, EAX表示新扩展出来的32位寄存器. 于是AX就变成了EAX的低16位, AL就变成了EAX的低8位. **注意!** 没有可以**直接访问**EAX的高16位的方法.  

#### 1.2.6 Real Mode 实模式
实模式中的内存被限制到1MiB($2^{20}$字节), 合法的地址范围是十六进制00000~FFFFF. 显然这个20位数无法放到8086的16位寄存器中. 因特尔解决了这个问题, 他使用了两个16位数推导一个地址, 第一个16位数被叫做*selector*, 第二个被叫做*offset*. 物理地址需要一个32位*selector*引用, 于是这里有一个计算公式:   
$$16*selector+offset$$    
乘以16非常简单, 只需要在十六进制最右边加一个0就行了. 比如推导物理地址引用047C:0048,   
$$047C0+0048=04808$$  
实际上, selector值就是一个节数(16字节).   

但是实模式这种切割地址的方式有一些缺点:  
1. 单个selector只能引用64K的内存, 如果程序代码超过64K怎么办?  
2. 每一个字节内存的索引方式不唯一. 比如刚才的04808可以被047C:0048, 047D:0038,
047E:0028或者是047B:0058引用. 这样会对比较地址造成一定的影响.  

#### 1.2.7 16-bit Protected Mode 16位保护模式
在80286的16位保护模式中, selector值翻译成物理地址的方式与实模式完全不同. 在保护模式中, selector值来自*描述符表(descriptor table)*中的一个*索引(index)*值. 在两个模式中, 程序都是被分块(segements)的. 在实模式中, 程序块的地址都是固定的, 并用selector值表示一个块开始位置的节的值; 但是在保护模式中, 这些块的地址不是固定的, 甚至都不用全部放入内存.  

保护模式使用了一种技术叫做**虚拟内存(virtual memory)**, 虚拟内存最基本的用途是让正在使用的数据和代码在内存中, 其他的数据和代码临时存放在disk中, segments能按需在内存和disk中切换. 这些切换操作对操作系统是完全透明的, 程序不需要针对虚拟内存这种设计专门编写.  

在保护模式中, 每一个代码块都会在描述附表中被声明成一个个条目(entry). 这个条目包含了操作系统需要的信息, 比如这个块是否在内存中, 在内存的哪里, 访问权限. 这些描述符表中条目的索引, 存放在*段寄存器*中.   

16位保护模式的最大缺点还是offset只有16位, 因此块大小还是被限制在了64K, 大序列(array)的索引还是一个问题.  

#### 1.2.8 32-bit Protected Mode 32位保护模式
80386引入了32位保护模式. 80286的16位保护模式和80386的32位保护模式有两个主要区别:  
1. offsets被扩展到了32位. 这就允许offset能够将最大范围扩大到四十亿字节. 从而, 块被扩展到了4 gigabytes(4 GiB).  
2. 块能被分成更小的4K单位, 被称为**页面(pages)**. 虚拟内存的工作对象从原来的块变成了pages, 这意味只有块中的某个部分会被放到内存中工作. 毕竟最大已经可以扩展到4GiB了, 整块再放进去不合实际.  

> In Windows 3.x, standard mode referred to 286 16-bit protected mode
and enhanced mode referred to 32-bit mode. Windows 9X, Windows NT/2000/XP,
OS/2 and Linux all run in paged 32-bit protected mode.  

上面这段不翻译了.  

#### 1.2.9 Interrupts 中断机制

有时候程序必须要暂停去处理一些需要相应的重要事件. 计算机硬件提供了一种叫做**中断(interrupts)**的机制去处理(handle)这些事件. 比如鼠标移动了, 计算机需要暂停程序运行, 去移动屏幕上的光标. 这时终止请求会被的递交给*interrupt handler(中断控制器)*, 中断控制器会处理中断. 每种不同类型的中断用不同的整数来表示. 在物理内存的开始处, 有一个*中断向量表(table of interrupt vectors)*, 其中包含了中断控制器的分块地址. 刚才说的用来表示中断类型的整数是表中的必不可少的索引值.  

*下面这段中出现的"发起", 都翻译自raised from这个词, 感觉有点像raise exceptions的那个意思.*  
CPU外还可以发起*外部中断(external interrupts)*, 其实鼠标属于这种外部发起的. 很多的I/O设备都会发起外部中断.  
相对的, 内部中断在CPU内部被发起, 无论是CPU内部错误还是直接发起的中断指令, 其中错误中断被叫做*traps*. 产生中断的中断指令被叫做*软件中断(software interrupts)*. 比如DOS提供了各种各样的中断用的API, 现代的操作系统可以直接调用C提供的接口.  

很多中断控制器会在引起本次中断的程序运行完毕后返回. 它们会恢复中断前的所有寄存器值. 所以, 中断控制器发生前后看起来就好像跟什么都没发生过一样, 除了损失了一些时钟周期. *traps*在通常情况下不会返回, 他们通常会中断程序运行. 

### 1.3 Assembly Language 汇编语言
#### 1.3.1 Machine language 机器语言
每一个指令都有它自己特定的**操作码(*operation code*, or *opcode* for short)**, opcode总是在一条指令的开头. 很多指令会包含数据(data). 机器语言用二进制表示(或者是十六进制).   

#### 1.3.2 Assembly language汇编语言
汇编语言用文本存储. 比如举个例子:  
```asm  
add eax, ebx
```  
汇编指令的通用格式为:
```asm
mnemonic operand(s)
```
mnemonic查了一下是助记符号的意思, operand操作数. 
这里提到了一个名词, *assembler(汇编器)*, 之前还遇到过一个叫disassembler的软件, 那个是反汇编器. 干吗用的, 就跟高级语言的编译器一样, 将汇编代码转换成机器码. 但是考虑到汇编指令转换机器码, 就只是映射关系, 所以比高级语言编译器要简单的多.  

#### 1.3.3 Instuction operands 指令运算数
每一个指令自己有一个运算数定值(0到3), 并且分别对应下面四种运算数类型:  
> **register:** These operands refer directly to the contents of the CPU’s registers.  
> **memory:** These refer to data in memory. The address of the data may be a constant hardcoded into the instruction or may be computed using values of registers. Address are always offsets from the beginning of a segment.  
> **immediate:** These are fixed values that are listed in the instruction itself. They are stored in the instruction itself (in the code segment), not in the data segment.  
> **implied:** There operands are not explicitly shown. For example, the increment instruction adds one to a register or memory. The one is implied.  

寄存器, 内存, 立即数和蕴含数(?).  

#### 1.3.4 Basic instructions 基础指令
最基础的就是mov了, 不解释了.  
```asm
mov dest, src
```
数据从src中拷贝到dest. 
注意两点:  
1. dest和src都不能是内存操作数.  
2. 两个操作数必须是同一规格的.  

例子:  
```asm  
mov eax, 3 ; store 3 into EAX register (3 is immediate operand)
mov bx, ax ; store the value of AX into the BX register
```    

add指令用来加整数:    
```asm  
add eax, 4 ; eax = eax + 4
add al, ah ; al = al + ah
```   

sub指令用来减:  
```asm   
sub bx, 10 ; bx = bx - 10
sub ebx, edi ; ebx = ebx - edi
```   

inc和dec用来使值增减1. 因为这里的增量1是隐含的操作数, 所以inc和dec的机器码要比执行类似操作的add和sub要短.  
```asm
inc ecx  ; ecx++
dev dl   ; dl--
```  

#### 1.3.5 Directives(指令, 但不同于instructions)
Directives是汇编器的而不是CPU的artifact(something observed in a scientific investigation or experiment that is not naturally present but occurs as a result of the preparative or investigative procedure). 它们被用于指导汇编器去做什么事或者是通知汇编器什么. **它们不会被翻译成机器码.** 指令的常用法:  
- 定义常量
- 定义存储数据的内存
- 组织内存为segment
- 视情况包含源代码
- 包含其它文件

NASM代码(之前没介绍, 这是本书用的汇编)使用像C一样的预处理器来实现指令. NASM的预处理器指令以%开头(C中用的是#).  

##### 1.3.5.1 ```equ```指令
用于定义一个符号(symbol). 格式:  
```asm  
[symbol] equ [value]
```    
符号不能被二次定义.   

##### 1.3.5.2 ```%define```指令
用法类似于C语言的宏:  
```asm
%define SIZE 100
move   eax, SIZE
```  

##### 1.3.5.3 数据指令
这里说到了数据指令有两种手段去保留内存, 一个是定义一个内存空间, 另一个是定义空间并初始化值.  
第一种可以使用RES*X*指令, X是一个字母, 用来表示对象的规格. 比如B表示字节, W表示字, D表示双字, Q表示四字, T表示十字节. 
第二种使用D*X*, X同上. 可以给这些内存空间标上一个label(从后文来看这些标签不一定是L加上数字的组合), 举一些例子:  
```asm
L1 db   0       ; byte labeled L1 with initial value 0
L2 dw   1000    ; word labeled L2 with initial value 1000
L3 db   110101b ; byte initialized to binary 110101 (53 in decimal)
L4 db   12h     ; byte initialized to hex 12 (18 in decimal)
L5 db   17o     ; byte initialized to octal 17 (15 in decimal)
L6 dd   1A92h   ; double word initialized to hex 1A92
L7 resb 1       ; 1 uninitialized byte
L8 db   "A"     ; byte initialized to ASCII code for A (65)
```  
单引号和双引号的作用一样. 以上的这些数据被线性安排在内存里, 比如L2就在L1的后面.  
可以定义内存序列:  
```asm  
L9  db 0, 1, 2, 3            ; defines 4 bytes
L10 db "w", "o", "r", ’d’, 0 ; defines a C string = "word"
L11 db ’word’, 0             ; same as L10
```  
对于较大的内存序列, NASM有一个TIMES指令:  
```asm   
L12 times 100 db 0 ; equivalent to 100 (db 0)’s
L13 resw 100       ; reserves room for 100 words
```  
要注意的是这些标签, 同C的指针类似, 它们是表示的是内存空间的地址, 取值需要有类似"解引用"的操作:  
```asm
mov al, [L1]   ; copy byte at L1 into AL
mov eax, L1    ; EAX = address of byte at L1
mov [L1], ah   ; copy AH into byte at L1
mov eax, [L6]  ; copy double word at L6 into EAX
add eax, [L6]  ; EAX = EAX + double word at L6
add [L6], eax  ; double word at L6 += EAX
mov al, [L6]   ; copy first byte of double word at L6 into AL
```  
最后一行, 我们看到的是L6只有第一个字节被拷贝进了al寄存器中, 这是NASM的一个重要属性--不会持续追踪label的数据规格. 不同于C, C是可以通过指针类型来判断指针指向内存空间的规格的. 

考虑下面这个指令:   
```asm
mov [L6], 1         ; store a 1 at L6
```  
上面说了不追踪label的规格, 所以这里编译器并不知道L6的规格, 于是需要手动指定, 加上一个*规格指定器(size specifier)*:  
```asm
mov dword [L6], 1   ; store a 1 at L6
```  
这告诉汇编器以双字1存储到L6位置.   
其它的规格指定器还有BYTE, WORD, QWORD和TWORD.  

#### 1.3.6 Input & Output
输入输出行为依赖于系统, 像C一样的高级语言有标准库提供输入输出, 而汇编没有, 于是必须直接访问硬件(这是在保护模式中的特权操作), 抑或是使用操作系统提供的较为低级的例行程序(routine)去完成输入输出的操作.  
汇编可以和C对接, 所以汇编里也可以直接使用C标准库. 但是因为这种交互比较麻烦, 所以作者(the author, 说的是这书的作者?)开发了一套自己的routine, 比C的用起来更简单. 下面简单介绍一下:  
- ```print_int```: 打印```EAX```中存储整数.
- ```print_char```: 打印```AL```中存储整数ASCII码对应的字符.
- ```print_string```: 打印```EAX```中存储的地址所存储的字符串, 这个字符串必须是C风格的(比如null表示结尾).
- ```print_nl```: 打印一个'\n'.
- ```read_int```: 从键盘输入读取一个整数存到```EAX```中.
- ```read_char```: 从键盘输入读取单个字符, 将其ASCII码存到```AL```中.

接着提供了include这些routines的方法. 同样类似于C语言的预处理器:  
```asm
%include "asm_io.inc"
```

想使用这些routines可以使用```CALL```指令. 

#### 1.3.7 Debuging
然后作者说在asm_io.inc加入了一套调试用的程序:  
- ```dump_regs```: 打印寄存器值到标准输出的宏. 接受一个参数. 这个参数用来区分不同的dump_regs指令. 
- ```dump_mem```: 打印一块内存的值. 接受三个参数. 第一个参数同dump_reg的单参, 第二个是显示的地址(可以是标签), 第三个是用来指定想要显示第二个参数(地址)开始的16字节的节的数目.
- ```dump_stack```: 顾名思义, 打印CPU栈中的值. 三个参数, 第一个同, 第二个参数指定将要打印栈指针```EBP```地址以降(below)的双字数目, 第三个参数指定同第二个参数中地址以升(above)的双字数目. 
- ```dump_math```: 打印数字处理器(math coprocessor)的寄存器值. 单参同dump_regs.

### 1.4 Creating a Program
```asm
; file: first.asm

%include "asm_io.inc"

; 初始化的数据放到.data段中
segment .data

prompt1 db "Enter a number: ", 0
prompt2 db "Enter another number: ", 0
outmsg1 db "You entered ", 0
outmsg2 db " and ", 0
outmsg3 db ", the sum of these is ", 0

; 未初始化的数据方到.bss段中
input1 resd 1
input2 resd 2

; 代码放到.text段中
segment .text
        global   asm_main
asm_main:
        enter    0,0                  ; 开始执行
        pusha

        mov      eax, prompt1
        call     print_string

        call     read_int
        mov      [input1], eax

        mov      eax, prompt2
        call     print_string

        call     read_int
        mov      [input2], eax

        mov      eax, [input1]
        add      eax, [input2]
        mov      ebx, eax

        dump_regs 1
        dump_mem  2, outmsg1, 1

        mov      eax, outmsg1
        call     print_string
        mov      eax, [input1]
        call     print_int
        mov      eax, outmsg2
        call     print_string
        mov      eax, [input2]
        call     print_int
        mov      eax, outmsg3
        call     print_string
        mov      eax, ebx
        call     print_int
        call     print_nl
        
        popa
        mov      eax, 0
        leave
        ret
```