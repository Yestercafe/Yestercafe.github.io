---
layout: post
title: Semantics Analysis and Type Systems - Part 1
description: 程序语言理论和实现 Week 5 - 作用域分析与 STLC
categories: PL
tags: [PL]
---

## What is Semantics Analysis

- 停机问题：能停机的 pass，不能停机的 fail
- 对 free variables：没用就 pass， 用了就 fail
- 一个函数是否会把一个字符串当作一个函数来 invoke？
- 有没有除以 0 的操作？

## Scope Analysis

看例子：

```
let x = (1, 2) in
switch x {
    (x, y) => ...
}
```

比如有一个这样的 pattern match 的语法，can be naively transformed to:

```
let x = (1, 2) in
let x = fst x in
let y = snd x in
...
```

这样的上面的 `x` 会被 shadow，这是没有任何问题的，但是这样在 `let y` 处再取 `snd x`，就会取到 shadow 的 `x`。这需要用到 scope analysis 解决。

修改方法很简单，给每一个变量多加一个 tag：

let x/1 = (1, 2) in
switch x/1 {
    (x/2, y/3) => ...
}
```

这样就可以转成：

``
let x/1 = (1, 2) in
let x/2 = fst x/1 in
let y/3 = snd x/1 in
...
```

### Implementation

引入一个 `ident` 类型作为变量的唯一标识符：

```rescript
type ident = { name: string, stamp: int }  // stamp is unique
```

引入新的表达式类型：

```rescript
module Resolve = {
    type rec expr =
    | Cst (int) | Var (ident)
    | Let (ident, expr, expr) | Prim (prim, list<expr>)
}

// 将原始版本的变量名，转成带 stamp 的变量名
let fresh = (x: string): ident => { ... }
```

这个 `ident` 比 de Bruijn index 要高级，这里的 stamp 是一个唯一的标识符，就是说不是一定像 de Bruijn index 那样会是连续的，比如做 dead code elimination 的时候，de Bruijn index 是可能需要更新的，但是这个 stamp 是没必要的。

## Type

### What is Type?

A concise, formal description of the behavior of a program fragment.

- 类型可以在一定程度上规范程序的行为
- 可以对 type safety property 进行形式化证明
- 类型检查的内核可以非常小，但是它非常强大。相比于其它的静态分析，静态类型检查的 overhead 比较小，所以一般会被做进编译器里，而其它的静态分析需要额外的工具。

### Why Type?

> Well-typed programs do not go wrong.

## Simply Typed Lambda Calculus

- Types  
  $T ::= Int \mid Bool \mid T \rightarrow T$  
  ```rescript
  type rec ty = TInt | TBool | Tarr (ty, ty)
  ```
- Terms  
  $t ::= i \mid b \mid x \mid \lambda x : T. t \mid t\ t$  
  ```rescript
  type rec t = CstI (int) | CstB (bool) | Var (string)
             | App (t, t) | Abs (string, ty, t)
  ```

### Runtime Semantics

#### Type-passing semantics

$$\frac{t_1 \rightarrow t_1'}{t_1\ t_2 \rightarrow t_1'\ t_2}$$

$$\frac{t_2 \rightarrow t_2'}{v_1\ t_2 \rightarrow v_1\ t_2'}$$

$$\frac{}{(\lambda x: T. t)\ v \rightarrow t[v/x]}$$

#### Type-erasing semantics

- $\lfloor \lambda x: T. t \rfloor = \lambda x. t$
- overloading vs. dynamic dispatch：这里在说的是静态的重载和动态的重载，感觉比较像 Rust 的 `impl` 和 `dyn` 的 traits

### Typing

#### Typing environment

$\Gamma ::=$  
$\ \ \ \mid \epsilon$  
$\ \ \ \mid \Gamma, x : T$  

#### Typing rules

$$\frac{x: T \in \Gamma}{\Gamma \vdash x: T} \operatorname{T-Var}$$

$$\frac{}{\Gamma \vdash i: Int} \operatorname{T-Int}$$

$$\frac{}{\Gamma \vdash b: Bool} \operatorname{T-Bool}$$

$$\frac{\Gamma , x : T_1 \vdash t_2 : T_2}{\Gamma \vdash \lambda x : T_1. t_2: T_1 \rightarrow T_2} \operatorname{T-Abs}$$

$$\frac{\Gamma \vdash t_1 : T_1 \rightarrow T_2\ \ \ \ \ \Gamma \vdash t_2 : T_1}{\Gamma \vdash t_1\ t_2 : T_2} \operatorname{T-App}$$

## System F (Polymorphic Lambda Calculus)

两个例子：

- 我们没有办法 typing $\omega = \lambda x. x\ x$
- 对于：
  ```
  let id = fun x -> x in
      (id(1), id(true))
  ```
  在类型检查时会 fail

这是 STLC 表达力（expressive power）的不足。

### Syntax

$t ::= i \mid b \mid x \mid \lambda x: T. t \mid t\ t \mid \lambda X: Type. t \mid t\ [T]$

### Types

$T ::= Int \mid Bool \mid T \rightarrow T \mid X \mid \forall X. T$

类比 Haskell 的 typeclasses：

```haskell
id :: a -> a
id x = x
```

Term abstraction 是抽象了一个计算过程，相对的这里新加入的 type abstraction 是将类型抽象了出来。

### Semantics

$$\frac{\Gamma, X: Type \vdash t : T}{\Gamma \vdash \lambda X : Type. t: \forall X. T} \operatorname{T-TAbs}$$

$$\frac{\Gamma \vdash : \forall X . T}{\Gamma \vdash t\ [T_1]: T[T_1 / X]} \operatorname{T-TApp}$$

### Decidability

- 相比 STLC 虽然 System F 的表达力更强，但它的 type inference 是 undecidable 的
- 类型系统的不可能三角：sound, complete, decidable：soundness 会保证类型安全，decidable 能保证类型检查会停机，所以一般会选 sound + decidable，在它们的基本上尽可能的 complete
- System F 的表达能力过强了，所以 undecidable 了。所以引入一个 fragment of System F: let-polymorphism，它保留了一部分 System F 的表达能力，且是 decidable 的
