---
layout: post
title: Stack Machine and Compilation - Part 2
description: 程序语言理论和实现 Week 4 - 编译函数声明与调用
categories: PL
tags: [PL]
---

## Funarg Problem

[Funarg problem](https://en.wikipedia.org/wiki/Funarg_problem)：栈式的内存管理不太方便直接支持 first-class functions 的编译。

所以本篇内用到的语言被简化，函数不再是一等公民，而是 C-style 的函数。这样大大降低实现的难度。

## Tiny Language 4

essentially equivalent to Tiny C:

```rescript
type prim = Add | Mul | ...
type rec expr =
    | Cst (int)
    | Var (string)
    | Let (string, expr, expr)
    | Letfn (string, list<string>, expr, expr)
    | App (string, list<expr>)
    | Prim (prim, list<expr>)
    | If (expr, expr, expr)
```
要求：

- 函数中没有自由变量：函数不捕获外部变量，变量的生命周期会和函数调用对齐
- 没有间接调用：比如 `(if cond then f else g) a` 这样的，`f` 和 `g` 都是函数。

### Example: Fibonacci Function

Concrete syntax:

```rescript
letfn fib(n) =
    if n <= 1 then { 1 }
    else { fib(n - 1) + fib(n - 2) }
in fib(5)
```

Abstract syntax:

```
Letfn(
    fib, [n],
    If (Prim(<= [Var(n), Cst(1)]),
        Cst(1),
        Prim(+, [App(fib, ...), App(fib, ...)]))
    App(fib, [Cst(5)])
)
```

## Overview

- Preprocess: flatten the code by lifting the functions
- Compilation: compile the functions:
  - caller: push arguments to the stack
  - callee: find the arguments on the stack
- Postprocess: add an entrance and an exit

### Whole Program

预处理后程序应该变成了 $[main, f_1, \dots, f_n]$。

$\mathbf{Prog}[[prog]] = \mathbf{Prog}[[main, f_1, \dots, f_n]]$
$\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ = Call(main, 0); Exit; \mathbf{Fun}[[main]]; \mathbf{Fun}[[f_1]]; \dots ; \mathbf{Fun}[[f_n]]$

对应的 ReScript 表示（synonyms）：

```rescript
type fun = (string, list<string>, expr)
type prog = list<fun>
```

### Functions

$\mathbf{Fun}[[(f, [p_1, \dots, p_n], e)]] = Label(f); \mathbf{Expr}[[e]]_{p_n, \dots, p_1}; Ret(n)$

### Expressions

- $\mathbf{Expr}[[Cst(i)]]_s = Cst(i)$
- $\mathbf{Expr}[[Var(x)]]_s = Var($`get_index`$(x, s))$
- $\mathbf{Expr}[[Let(x, e_1, e_2)]] = \mathbf{Expr}[[e_1]]; \mathbf{Expr}[[e_2]]_{x::s}; Swap; Pop$
- $\mathbf{Expr}[[Prim(p, [e1, \dots, e_n])]]_s = \mathbf{Expr}[[e_1]]_s, \mathbf{Expr}[[e_2]] _{*::s}, \dots, Add/Mul$
- $\mathbf{Expr}[[App(f, [a_1, \dots, a_n])]]_s = \mathbf{Exprs}[[a_1, \dots, a_n]]_s; Call(f, n)$
- $\mathbf{Expr}[[If(cond, e_1, e_2)]]_s = \dots$（见 part1）

For expressions:

$\mathbf{Exprs}[[a_1, \dots, a_n]]_s = \mathbf{Expr}[[a_1]]_s; \mathbf{Expr}[[a_2]] _{*::s} ; \dots$

#### 为什么这里没有对 `Letfn` 的编译

因为经过预处理之后一定没有了 `Letfn` 的语句。这里的**一定不会出现**是一种 *Invariant*，我们除了在对 `Expr` 做模式匹配时对 `Letfn` 分支做比如 `Expr Letfn ... = assert false` 这样一个恒假断言这种方法以外，还可以使用基于类型的限制：创建一个新的叫 `Flat.Expr` 的类型，只包含 6 种表达式类型。

可以使用类型系统来满足一些不定式的要求。（type-driven develop?）

## HW

实现从 AST 到指令集的编译，并在虚拟机上运行。

<https://github.com/Yescafe/language_learning/tree/9c8b376669732ee0219cf4d1a63b7fab369555ec/Rust/pltai/lec4/src>
