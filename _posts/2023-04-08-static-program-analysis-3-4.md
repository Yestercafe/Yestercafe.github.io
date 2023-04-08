---
layout: post
title: Static Program Analysis - Data Flow Analysis - Applications
description: 南大《软件分析》课程 03
categories: PL
tags: [PL]
---

<https://cs.nju.edu.cn/tiantan/software-analysis/DFA-AP.pdf>

## Overview

How application-specific data flows on through nodes (BBs/statements) and edges (control flows) of CFG (a program)?

## Preliminaries of Data Flow Analysis

在每一个 data-flow analysis 应用中，我们把每一个 program point 关联到一个 data-flow value，这样的 data-flow value 代表的是在那一点可能的 program state 的抽象。

![prelim1](/images/posts/2023-04-08-static-program-analysis-3.assets/QQ20230408-143120.png)

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

![algo1](/images/posts/2023-04-08-static-program-analysis-3.assets/QQ20230408-153032.png)

### Why this iterative algorithm can finally stop?

![algo2](/images/posts/2023-04-08-static-program-analysis-3.assets/QQ20230408-153521.png)

This algorithm can reach a fixed point.


