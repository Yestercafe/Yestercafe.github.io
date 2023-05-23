---
layout: post
title: Static Program Analysis - Data Flow Analysis - Applications
description: 南大《软件分析》课程 03、04
categories: PL
tags: [PL]
---

<https://cs.nju.edu.cn/tiantan/software-analysis/DFA-AP.pdf>

## Overview

How application-specific data flows on through nodes (BBs/statements) and edges (control flows) of CFG (a program)?

## Preliminaries of Data Flow Analysis

在每一个 data-flow analysis 应用中，我们把每一个 program point 关联到一个 data-flow value，这样的 data-flow value 代表的是在那一点可能的 program state 的抽象。

![prelim1](/images/posts/2023-04-08-static-program-analysis-3-4.assets/QQ20230408-143120.png)

Data-flow analysis is to find a solution to a set of safe-approximation-directed constraints on the IN[s]’s and OUT[s]’s, for all statements s.
- constraints based on semantics of statements (transfer functions)
- constraints based on the flows of control

图比较多，详见 slides。

## Reaching Definitions Analysis

### Reaching Definitions

A *definition d* at program point p reaches a point q if there is a path from p to q such that d is not "killed" along that path.

- A definition of a variable v is a statement that assigns a value to v
- 如果 p 到 q 的路径上没有新的 v 定义，那么说 p 点的变量 v 定义 *reaches* q 点
- Reaching definitions can be used to detect possible undefined variables

### Algorithm of Reaching Definitions Analysis

![algo1](/images/posts/2023-04-08-static-program-analysis-3-4.assets/QQ20230408-153032.png)

### Why this iterative algorithm can finally stop?

![algo2](/images/posts/2023-04-08-static-program-analysis-3-4.assets/QQ20230408-153521.png)

This algorithm can reach a fixed point.

## Live Variables Analysis

如果有一条 path，从程序点 p 开始，在这条 path 上有使用 v 的地方，同时在期间没有被 redefined，那么我们说 v 在 p 处是 alive/live variable。

这个过程看上去跟 reaching definitions analysis 的定义是反的？有什么用？比如现在寄存器占用满了，如果在静态分析时就对变量做 live analysis，那么就可以将 dead variables 从寄存器中替换掉。

Live variables analysis 的 safe-approximation 是 may analysis/over-approximation。

![live-variables-analysis-1](/images/posts/2023-04-08-static-program-analysis-3-4.assets/QQ20230513-170744.png)

## Available Expressions Analysis

An expression $x op y$ is available at program point p if:

1. *all* paths from the entry to p *must* pass through the evaluation of $x op y$
2. after the last evaluation of $x op y$, there is no redefinition of x or y

这个分析应该是为了判断在某一个点，某一个表达式的运算结果能不能复用的。是 must analysis/under-approximation。

有一个特别的情况：

![available-expr-analysis-1](/images/posts/2023-04-08-static-program-analysis-3-4.assets/QQ20230513-172608.png)

这在最下面的 BB 中，$e^{16} * x$ 依然是 available 的，原因图上有。

safe-approximation 要保证的是一定不能误报，要根据场合选择用 under/over。即为了达到 soundness，比如对优化而言，宁可不优化也不能去做错优化。

![available-expr-analysis-2](/images/posts/2023-04-08-static-program-analysis-3-4.assets/QQ20230513-173244.png)

## Analysis Comparison

![comparison](/images/posts/2023-04-08-static-program-analysis-3-4.assets/QQ20230513-183950.png)