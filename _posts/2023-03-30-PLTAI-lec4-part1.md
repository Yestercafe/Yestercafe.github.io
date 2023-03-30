---
layout: post
title: Stack Machine and Compilation - Part 1
description: 程序语言理论和实现 Week 4 - 新指令集、编解码和虚拟机
categories: PL
tags: [PL]
---

## New Instructions: Call and Ret

```rescript
type instr = ... | Call(label, int) | Ret(int)
```

## New Instructions: Conditions

```rescript
type instr = ... | Goto(label) | IfZero(label)
```

比如，`[[ if a then b else c ]]` 会被编译到：

```
[[a]]
IfZero(if_not)
[[b]]
Goto(end_if)
Label(if_not)
[[c]]
Label(end_if)
```

## Instructions

```rescript
type instr =
    | Cst(int) | Add | Mul | Var(int) | Swap | Pop | Label(string)
    | Call(string, int) | Ret(int) | Goto(label) | IfZero(label)    // control flow instructions
    | Exit
```

## Encoding Spec

![encoding spec](/images/posts/2023-03-30-PLTAI-lec4.md.assets/QQ20230330-153317.png)

## HW

Implement the virtual machine in C/C++/Rust.

实现一台能够运行这个新指令集的虚拟机，这个虚拟机是能够做到语言无关的。我这里使用了 Rust 实现，具体代码在：<https://github.com/Yescafe/language_learning/tree/master/Rust/pltai/lec4>。

下面说两个重要的部分：

```rust
Some(Opcode::Call) => {
    let callee_addr = self.code[self.pc + 1];
    let arity = self.code[self.pc + 2];
    let mut args = vec![];
    // 将 arity 个参数出栈保留下来
    for _ in 0..arity {
        args.push(self.rts.pop().unwrap());
    }
    // 返回地址入栈
    self.rts.push(i32::try_from(self.pc + 3).unwrap());
    // 将刚出栈的参数再放回去。这样就做到了把返回地址插到 arity 个参数之前
    for arg in args {
        self.rts.push(arg);
    }
    self.pc += usize::try_from(callee_addr).unwrap();
},
```

对应下图：

![hw_call](/images/posts/2023-03-30-PLTAI-lec4.md.assets/QQ20230330-165549.png)

```rust
Some(Opcode::Ret) => {
    let arity = self.code[self.pc + 1];
    // 返回值出栈，保留
    let return_value = self.rts.pop().unwrap();
    // 所有实参出栈
    for _ in 0..arity { self.rts.pop(); }
    // 返回地址出栈
    let return_addr = self.rts.pop().unwrap();
    // 返回值重新入栈。在 x86 机器上返回值一般是存在 EAX 寄存器里的，这种经常需要用到的东西，
    // 如果放在栈上会产生没有必要的 memory traffic
    self.rts.push(return_value);
    self.pc = usize::try_from(return_addr).unwrap();
},
```

对应下图：

![hw_ret](/images/posts/2023-03-30-PLTAI-lec4.md.assets/QQ20230330-172952.png)

其它的不太重要的部分见完整代码仓库。

我的栈可能建反了，到 Part2 的时候再看要不要改。
