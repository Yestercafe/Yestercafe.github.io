---
layout: post
title: Introduction to Language Design and Implementation
description: 程序语言理论和实现 Week 0
categories: PL
tags: [PL]
---

## Resources

website: <https://bobzhang.github.io/courses/>

slides: <https://bobzhang.github.io/courses/slides1.pdf>

video part 1: <https://www.bilibili.com/video/BV1ee4y1e7CU>

video part 2: <https://www.bilibili.com/video/BV1Ug41187Zh>

## ReScript

ref: <https://bobzhang.github.io/courses/rescript_setup.html>

安装 node.js 然后克隆模板仓库使用 npm 构建、运行：

```bash
git clone https://github.com/rescript-lang/rescript-project-template rescript-project
cd rescript-project
npm install
npm run res:build
node src/Demo.bs.js  # 执行 demo
```

vim 插件：

```vimscript
Plug 'rescript-lang/vim-rescript'
```

## Compilation Phases

### Lexing & Parsing

这个部分的目标是将字符串转换成 abstract tree。一般分两个阶段：

1. Tokenization. Split the string into tokens by using regex.
2. Parsing. 现代语言中到 parsing 基本都与语义无关了。这里的反例是 C++，C++ 太杂糅了。

There are lots of typical compiler frontend tools supporting, such as Lex, Yacc, Bison, etc.

这里还有一条路径，string -> concrete syntax -> abstract tree，一套 abstract syntax 可能有多个对应的 concrete syntax。

### Sematic Analysis

- Build the symbol table, resolve variables
- Type checking & inference
  - 保证每个操作的类型正确
  - 用户没有标注类型需要推断（infer, not induce）
  - Typeclass/Implictis resolving
  - Check other safety/security problems
    - 比如 Rust 的 lifetime
- Type soundness：没有运行时类型错误（这个在 [nju 静态分析](https://yescafe.github.io/2021-12-22/static-program-analysis-introduction)里有说到？）

### Language Specific Lowering, Optimizations

- Class/Module/Objects/Typeclass desugaring
- Pattern match desugaring
- Closure conversion
- Language specific optimizations
- IR，一层层的 IR

### Linearization & Optimizations

经过多层 IR 的转译之后，因为 CPU 是流水线架构，最终需要得到 linear IR（平台无关）。

- Language & platform agnostics
- Optimizations
  - Constant folding, propagation（常数传播），CSE(common subexpression elimination)，parital evaluation
  - loop 的优化
  - 尾递归优化
  - intra-procedural, inter-procedural opt。这里说到全局优化是函数内部的优化，全局环境中的优化是 LTO（link time optimization）
- IR simplified：三地址码，LLVM IR 等

### Platform Specific Code

- Instruction selection
- Register allocation. 这个很重要。
  这里存在一个 hierarchy，要尽可能将 heap 上的内存转到 stack，将 stack 转到 registers。
- 指令调度和机器相关优化。这方面影响最大的主要是一些数值算法，比如神经网络。

## Tiny Language 0

### Formalization

<style>
/* Clear floats after the columns */
.row:after {
    content: "";
    display: table;
    clear: both;
}

.column-2-1 {
    float: left;
    width: 10%;
}

.column-2-2 {
    float: left;
    width: 90%;
}
</style>

<table>
    <tr>
        <td style="text-align:left">terms:</td>
        <td style="text-align:left">$e ::= \operatorname{Cst}(i) \mid \operatorname{Add}(e_1, e_2) \mid \operatorname{Mul}(e_1, e_2)$</td>
    </tr>
    <tr>
        <td style="text-align:left">values:</td>
        <td style="text-align:left">$v ::= i \in \operatorname{Int}$</td>
    </tr>
</table>

The evaluation rules（形式化语义）:

<style>
.column-3 {
    float: left;
    width: 33.33%;
}
</style>

<div class="row">
    <div class="column-3">
        $$
        \frac{}{\operatorname{Cst}(i) \Downarrow i} \operatorname{E-const}
        $$
    </div>
    <div class="column-3">
        $$
        \frac{e_1 \Downarrow v_1\ \ \ \ \ \ \ e_2 \Downarrow v_2}{\operatorname{Add}(e_1, e_2) \Downarrow (v_1 + v_2)} \operatorname{E-add}
        $$
    </div>
    <div class="column-3">
        $$
        \frac{e_1 \Downarrow v_1\ \ \ \ \ \ \ e_2 \Downarrow v_2}{\operatorname{Mul}(e_1, e_2) \Downarrow (v_1 * v_2)} \operatorname{E-mul}
        $$
    </div>
</div>

For example, $\operatorname{Add}(\operatorname{Cst}(1), \operatorname{Cst}(2)) \Downarrow 3$'s proof tree:

$$
\frac{\frac{}{\operatorname{Cst}(1) \Downarrow 1} \operatorname{E-Const}\ \ \ \ \ \ \frac{}{\operatorname{Cst}(2) \Downarrow 2} \operatorname{E-const}}{\operatorname{Add} (\operatorname{Cst}(1), \operatorname{Cst}(2)) \Downarrow 3} \operatorname{E-add}
$$

### Parser & Interpreter Codes（非形式化语义）

```rescript
type rec expr =
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)

let rec eval = (expr : expr) => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => eval (a) + eval (b)
    | Mul (a, b) => eval (a) * eval (b)
    }
}
```

但是这里有个问题：就比如：

```rescript
| Add (a, b) => eval (a) + eval (b)
```

这里的递归用到了宿主语言的 stack，这里需要将它 lowering 到低级语言从而不用到宿主语言的 stack。

### Lowering to a Stack Machine and Interpret

```rescript
type instr = Cst (int) | Add | Mul  // no recursive
type instrs = list <instr>
type operand = int
type stack = list <operand>

let rec eval = (instrs: instrs, stk: stack) => {
    switch (instrs, stk) {
    | (list{Cst (i), ...rest}, _) =>
        eval(rest, list{i, ...stk})
    | (list{Add, ...rest}, list{a, b, ...stk}) =>
        eval(rest, list{a + b, ...stk})
    | (list{Mul, ...rest}, list{a, b, ...stk}) =>
        eval(rest, list{a * b, ...stk})
    | _ => assert false
    }
}
```

下面给出该虚拟机的形式化语义：

这个虚拟机由两个部分（数据结构）组成：

- 指令集 `c`。原文是 a code pointer `c` giving the next instruction to execute.
- Stack `s`.
  - push `v` on `s`: $s \rightarrow v :: s$
  - pop `v` off `s`: $v :: s \rightarrow s$

Code and stack:

<table>
    <tr>
        <td style="text-align:left">code:</td>
        <td style="text-align:left">$c ::= \epsilon \mid i; c$</td>
    </tr>
    <tr>
        <td style="text-align:left">stack:</td>
        <td style="text-align:left">$s ::= \epsilon \mid v :: s$</td>
    </tr>
</table>

Transition of the machine:
<table>
    <tr>
        <th>$(\operatorname{Cst}(i); c, s) \rightarrow (c, i :: s)$</th>
        <th>(I-Cst)</th>
    </tr>
    <tr>
        <th>$(\operatorname{Add}; c, n_2 :: n_1 :: s) \rightarrow (c, (n_1 + n_2) :: s)$</th>
        <th>(I-Add)</th>
    </tr>
    <tr>
        <th>$(\operatorname{Mul}; c, n_2 :: n_1 :: s) \rightarrow (c, (n_1 \times n_2) :: s)$</th>
        <th>(I-Mul)</th>
    </tr>
</table>

经过很多步的状态转移后，stack 中只剩一个元素，代码计算完成，得到 `v` in stack 就是结果：

$$
\frac{(c, \epsilon) \rightarrow ^* (\epsilon, v :: \epsilon)}{c \downarrow v}
$$

编译对应的数学形式化表示：

$$
[\![ \operatorname{Cst}(i) ]\!] = \operatorname{Cst}(i)
$$


$$
[\![ \operatorname{Add}(e_1, e_2) ]\!] = [\![ e_1 ]\!]; [\![ e_2 ]\!]; \operatorname{Add}
$$


$$
[\![ \operatorname{Mul}(e_1, e_2) ]\!] = [\![ e_1 ]\!]; [\![ e_2 ]\!]; \operatorname{Mul}
$$

关于如何证明编译过程的正确，利用到栈平衡的性质，使用数学归纳法。具体需要用到 Coq。

正确的编译实现会使下面的式子成立：

$$
e \Downarrow v \Longleftrightarrow [\![ e ]\!] \downarrow v
$$

前者被叫作 big step operational semantics（大步语义），后者被叫作 small step operational semantics（小步语义）。

### Homework

将编译使用非形式化语言实现，即将大步语义转换为小步语义：

```rescript
type rec expr =
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)

type instr = Cst (int) | Add | Mul
type instrs = list<instr>
type operand = int
type stack = list<operand>

let rec compile = (expr: expr): list<instr> => {
    switch expr {
    | Cst(i) => list{ Cst(i) }
    | Add(e1, e2) => List.append(List.append(compile(e1), compile(e2)), list{Add})
    | Mul(e1, e2) => List.append(List.append(compile(e1), compile(e2)), list{Mul})
    }
}
```
