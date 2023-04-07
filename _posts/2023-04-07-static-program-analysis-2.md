---
layout: post
title: Static Program Analysis - Intermediate Representation
description: 南大《软件分析》课程 02
categories: PL
tags: [PL]
---

## Compilers and Static Analyzers

### Compiler

- Source Code
- Scanner (Lexical Analysis) ==(regular expressions)=> Tokens
- Parser (Syntax Analysis) ==(context-free grammar)=> AST
- Type Checker (Semantic Analysis) ==(attribute grammar)=> Decorated AST
- Translator ===> IR (e.g. 3AC)
- *Static Analysis*, e.g, code optimization
- Code Generator
- Machine Code

IR 之前可以被作为编译器前端，之后的被作为后端。

## AST vs. IR

```
do i = i + 1; while (a[i] < v);
```

AST:

![to-ast](/images/posts/2023-04-07-static-program-analysis-2.assets/QQ20230407-163623.png)

IR ("3-address" form):

```
1: i = i + 1
2: t1 = a [ i ]
3: if t1 < v goto 1
```

![ast-vs-ir](/images/posts/2023-04-07-static-program-analysis-2.assets/QQ20230407-163815.png)

## IR: Three-Address Code (3AC)

为什么叫 3 地址码？3AC 最多包括 3 个*地址*。

**Address** 可以是：

- Name：`a`，`b`
- Constant：`3`
- Compiler-generated temporary: `t1`，`t2`

### Forms

E.g.:

- x = y *bop* z, *bop* is binary arithmetic or logical operation
- x = *uop* y, *uop* is unary operation
- x = y
- goto **L**, **L** is a label to represent a program location
- if x goto **L**
- if x *rop* y goto **L**, *rop* is relational operator(<, >, ...)

### Soot and Its IR: Jimple

Soot 是 Java 的静态分析器，Jimple 是它的 3AC。

Jimple 是一种 typed 3-address code.

#### For loop

```java
package nju.sa.examples;
public class ForLoop3AC {
    public static void main(String[] args) {
        int x = 0;
        for (int i = 0; i < 10; i++) {
            x = x + 1;
        }
    }
}
```

转成真实世界的三地址码（这里应该是 Jimple）：

```jimple
public static void main(java.lang.String[])
{
    java.lang.String[] r0;
    int i1;

    r0 := @parameter0: java.lang.String[];

    i1 = 0;

label1:
    if i1 >= 10 goto label2;

    i1 = i1 + 1;

    goto label1;

label2:
    return;
}
```

（x 被 Soot 提前优化掉了，不用管）

#### Do while loop

```java
package nju.sa.examples;
public class DoWhileLoop3AC {
    public static void main(String[] args) {
        int[] arr = new int[10];
        int i = 0;
        do {
            i = i + 1;
        } while (arr[i] < 10);
    }
}
```

```jimple
public static void main(java.lang.String[])
{
    java.lang.String[] r0;
    int[] r1;
    int $i0, i1;

    r0 := @parameter0: java.lang.String[];

    r1 = newarray (int)[10];
    i1 = 0;

label1:
    i1 = i1 + 1;

    $i0 = r1[i1];

    if $i0 < 10 goto label1;

    return;
}
```

#### Method call

![method-call-jimple1](/images/posts/2023-04-07-static-program-analysis-2.assets/QQ20230407-170719.png)

![method-call-jimple2](/images/posts/2023-04-07-static-program-analysis-2.assets/QQ20230407-165809.png)

JVM 中的四种 function invoke：

1. invokespecial: call constructor, call superclass methods, call private methods
2. invokevirtual: instance methods call (virtual dispatch)
3. invokeinterface: cannot optimization, checking interface implementation
4. invokestatic: call static methods

JVM 还有个 invokedynamic，是给在 JVM 上运行的动态语言提供的。

invoke 后面的尖括号里的是 method signature。

#### Class

![class-jimple](/images/posts/2023-04-07-static-program-analysis-2.assets/QQ20230407-171052.png)

## Static Single Assignment (SSA)

- Every variable has exactly one definition
- 如果出现这种情况：
  ![phi-funtion](/images/posts/2023-04-07-static-program-analysis-2.assets/QQ20230407-172009.png)
  引入一个 phi function，用以合并控制流传递过来的 value。

为什么不用 SSA：

- SSA 会引入太多的变量和 phi-functions
- 转换回字节码时会引入 inefficiency problem

## Control Flow Analysis

### Basic Blocks

BB 是最大化的连续 3 地址码指令序列，并且满足：

- 必须从这个 BB 的第一个指令进入
- 必须从这个 BB 的最后一个指令退出

### To Build Basic Blocks

P 是一个 3 地址码指令序列。

1. 考虑 P 中的所有 leaders
  - P 的第一个指令是 leader
  - jump 的目的地（比如 goto 的目标）是一个 leader
  - jump 后面的那个指令是一个 leader
2. Build BBs for P
  - 从一个 leader 连到下一个 leader 之前就是一个 BB
  - 或者是最后一个 BB

### Control Flow Graph (CFG)

- The nodes of CFG are BBs
- There is an edge(directed) from block A to block B IFF
  - jump 的起点到目的地要添边
  - 原本贴在一起的 BB 要添边，除了：
  - 某一个 BB 的结尾是一个 unconditional jump
- （可以提前）给 BB 和 jump 的目的地重新排个 label
- 最后再加 Entry 和 Exit 的特殊节点
