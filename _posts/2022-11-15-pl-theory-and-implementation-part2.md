---
layout: post
title: Introduction to language design and implementation - Part 2
description: 程序语言理论和实现 Week 0 - 局部变量的语义与编译过程
categories: PL
tags: [PL]
---

## Tiny Language 1

```rescript
type rec expr =
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)
    | Var (string)
    | Let (string, expr, expr)

type env= list<(string, int)>

let rec eval = (expr, env) => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => eval (a, env) + eval (b, env)
    | Mul (a, b) => eval (a, env) * eval (b, env)
    | Var(x) => assoc (x, env)
    | Let(x, e1, e2) => eval(e2, list{(x, eval(e1, env)), ...env})
    }
}
```

### Formalization

<table>
    <tr>
        <td style="text-align:left">terms:</td>
        <td style="text-align:left">$e ::= \operatorname{Cst}(i) \mid \operatorname{Add}(e_1, e_2) \mid \operatorname{Mul}(e_1, e_2) \mid \operatorname{Var}(i) \mid \operatorname{Let}(x, e_1, e_2)$</td>
    </tr>
    <tr>
        <td style="text-align:left">envs:</td>
        <td style="text-align:left">$\Gamma ::= \epsilon \mid (x, v) :: \Gamma$</td>
    </tr>
</table>

Notations of the environment:

<table>
    <tr>
        <td style="text-align:left">variable access:</td>
        <td style="text-align:left">$\Gamma [x]$</td>
    </tr>
    <tr>
        <td style="text-align:left">variable update:</td>
        <td style="text-align:left">$\Gamma [x := v]$</td>
    </tr>
</table>

The evaluation rules:

$$
\frac{}{\Gamma \vdash \operatorname{Cst}(i) \Downarrow i} \operatorname{E-const}
$$

$$
\frac{\Gamma \vdash e_1 \Downarrow v_1\ \ \ \ \ \ \ \Gamma \vdash e_2 \Downarrow v_2}{\Gamma \vdash \operatorname{Add}(e_1, e_2) \Downarrow (v_1 + v_2)} \operatorname{E-add}
$$

$$
\frac{\Gamma \vdash e_1 \Downarrow v_1\ \ \ \ \ \ \ \Gamma \vdash e_2 \Downarrow v_2}{\Gamma \vdash \operatorname{Mul}(e_1, e_2) \Downarrow (v_1 * v_2)} \operatorname{E-mul}
$$

$$
\frac{\Gamma [x] = v}{\Gamma \vdash \operatorname{Var}(x) \Downarrow v} \operatorname{E-var}
$$

$$
\frac{\Gamma \vdash e_1 \Downarrow v_1\ \ \ \ \ \ \ \Gamma [x := v_1]\vdash e_2 \Downarrow v_2}{\Gamma \vdash \operatorname{Let}(x, e_1, e_2) \Downarrow v_2} \operatorname{E-let}
$$

$\vdash$ 叫 turnstile，$\LaTeX$ 记作 `\vdash`。

运行时靠变量名查环境表比较耗时，引入 partial evaluation，让编译器完成更多静态工作。

## Tiny Language 2

```rescript
module Nameless {
    type rec expr =
        | Cst (int)
        | Add (expr, expr)
        | Mul (expr, expr)
        | Var (int)
        | Let (expr, expr)
}

type env = list<int>

let rec eval = (expr : Nameless.expr, env) => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => eval (a, env) + eval (b, env)
    | Mul (a, b) => eval (a, env) * eval (b, env)
    | Var(n) => List.nth (env, n)
    | Let(e1, e2) => eval(e2, list{eval(e1, env)}, ...env)
    }
}
```

### Semantics

<table>
    <tr>
        <td style="text-align:left">envs:</td>
        <td style="text-align:left">$s ::= \epsilon \mid v :: s$</td>
    </tr>
</table>

$$
\frac{}{s \vdash \operatorname{Cst}(i) \Downarrow i} \operatorname{E-const}
$$

$$
\frac{s \vdash e_1 \Downarrow v_1\ \ \ \ \ \ \ s \vdash e_2 \Downarrow v_2}{s \vdash \operatorname{Add}(e_1, e_2) \Downarrow (v_1 + v_2)} \operatorname{E-add}
$$

$$
\frac{s \vdash e_1 \Downarrow v_1\ \ \ \ \ \ \ s \vdash e_2 \Downarrow v_2}{s \vdash \operatorname{Mul}(e_1, e_2) \Downarrow (v_1 * v_2)} \operatorname{E-mul}
$$

$$
\frac{s [i] = v}{s \vdash \operatorname{Var}(i) \Downarrow v} \operatorname{E-var}
$$

$$
\frac{s \vdash e_1 \Downarrow v_1\ \ \ \ \ \ \ v_1 \cdot s\vdash e_2 \Downarrow v_2}{s \vdash \operatorname{Let}(e_1, e_2) \Downarrow v_2} \operatorname{E-let}
$$

$s$ is a stack-like list, $v_1 \cdot s$ means stack push.

### Explanation

原来的 $\Gamma$ 环境既包含「名字」又包含值，而「名字」实为静态的，在编译过程中即可处理掉。

接下来是将 expr 编译到 Nameless.expr：

### Lowering `expr` to `Nameless.expr`

```rescript
type cenv = list<int>

let rec comp = (expr: expr, cenv: cenv): Nameless.expr => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => Add(comp(a, cenv) + comp(b, cenv))
    | Mul (a, b) => Mul(comp(a, cenv), comp(b, cenv))
    | Var(x) => Var(index(cenv, x))
    | Let(x, e1, e2) => Let(comp(e1, cenv), comp(e2, list{x, ...cenv}))
    }
}
```

Similar to `expr`'s eval.

## Compile `Nameless.expr`

为 stack machine 引入新的语义：

<table>
    <tr>
        <th>$(\operatorname{Var}(i); c, s) \rightarrow (c, s[i] :: s)$</th>
        <th>(I-Var)</th>
    </tr>
    <tr>
        <th>$(\operatorname{Pop}; c, n :: s)$</th>
        <th>(I-Pop)</th>
    </tr>
    <tr>
        <th>$(\operatorname{Swap}; c, n_2 :: n_1 :: s) \rightarrow (c, n_2 :: n_1 :: s)$</th>
        <th>(I-Swap)</th>
    </tr>
</table>

例子：

![example1](/images/posts/2022-11-15-pl-theory-and-implementation-part2.assets/example1.png)

Swap 和 Pop 的组合可以去除栈里留下的 $x$ 保留下 $v$。Swap 和 Pop 是为了保持栈平衡才引入的，因为 stack machine 的 eval 的最后结果一定会保证栈里的元素只有 1 个。所以需要 Swap & Pop 将「临时」存入栈的不需要的 local variable 的「值（value）」移除。

比如对应的上图中的 `Cst(17)` 临时入栈，是为了在后面的过程中，能把这个栈中的 17 当成「x」来使用。而后面的 `Swap; Pop` 针对的也就是这个 17。

关于红色的部分 `Var(0)` 为什么变成了 `Var(1)`，是因为 `Var(0)` 会伴随着 `s[0]` 入栈，但是这个下标就比较反传统的用线性表建栈的形式，因为传统我们用线性表作为栈的 push 是 `s[len++] = x`，栈底是不变的；而这里从头到尾都是 `list {x, ...cenv}`，栈顶永远是 0。类似 Lisp 的 `(x . s)`，然后取栈顶就是很简单的 `(car s)`。（所以说到底他用的就不是线性表而是单链表，用 C 写单链表做栈也得这样，主要的反直觉是在 C 的数组才用下标访问而不是链表）

Another example:

![example2](/images/posts/2022-11-15-pl-theory-and-implementation-part2.assets/example2.png)

## Summary

- $\Gamma$ 是 local variables 环境符号。另外还有 temporary variables、parameters、stack frame，编译器需要处理这四种变量的寻址方式，最终要将这 4 个栈合成 1 个。
- expr（IR0）、Nameless.expr（IR1）都有用到宿主的栈，所以最终编译到 stack machine（IR2）不需要再用宿主的栈。
- 整个编译过程是 IR0 -> IR1 -> IR2，但是 IR0 -> IR2 也是一条路径。

## Q&A

先是问到类似 variable hiding 的代码是如何从 IR0 编译到 IR1 的。这里课里有说到，对于 Nameless.expr 名字变的不重要，两个 x 直接就是两独立的变量，如 $\Gamma$ 原本是 `[(x, 2), (x, 1)]`，到 $s$ 中就会被编译为 `[2, 1]`。

第二个问题没懂，问的是 IR0 -> IR1 的 comp 中怎么体现「静态」。我觉得可能想问的是编译程序是「动态」执行的，cenv 也在实时变化，那这个静态是体现在哪。

作业稍后。

## Homework



