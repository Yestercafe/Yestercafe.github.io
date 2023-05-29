---
layout: post
title: Static Program Analysis - Interprocedural Analysis
description: 南大《软件分析》课程 07
categories: PL
tags: [PL]
---

<https://cs.nju.edu.cn/tiantan/software-analysis/Inter.pdf>

## Method Calls in Java

![jvm-ir-invoke](/images/posts/2023-05-17-static-program-analysis-7.md.assets/QQ20230517-204603.png)

## Method Dispatch of Virtual Calls

在运行时，a virtual call 的解析基于 (以 `o.foo(...)` 为例)：

1. receiver object（pointed by `o`）的类型
2. 调用时方法的具体签名

在这个课中，我们把*签名*作为函数的一个 identifier：

- signature = class type + method name + descriptor
- descriptor = return type + parameter types

## Class Hierarchy Analysis (CHA)

- 需要整个程序的类继承信息
- 通过类继承解析虚调用

## Class Resolution of CHA

![class-resolution-of-CHA](/images/posts/2023-05-17-static-program-analysis-7.md.assets/QQ20230517-211857.png)

## Features of CHA

- Advantage: fast. 因为它只用考虑继承信息。
- Disadvantage: imprecise. 很容易引入假的目标方法。
- 常用于 IDE。

## Call Graph Construction

BFS.

## Interprocedural Control-flow Graph

ICFG 在 CFG 的基础上，多了两种类型的边：

- Call edges. from call sites to the entry nodes of their callees.
- Return edges. from return statements of the callees to the statements *following* their call sites (i.e., return sites)

## Interprocedural Data-flow Analysis

|                        | Intraprocedural |        Interprocedural        |
| :--------------------: | :-------------: | :---------------------------: |
| Program representation |       CFG       |             ICFG              |
|   Transfer functions   |  Node transfer  | Node transfer + edge transfer |

- edge transfer = call edge transfer + return edge transfer
- There is no standard method to do interprocedural data-flow analysis, so this is Tian Tan's method :p

## Interprocedural Constant Propagation

- Call edge transfer: pass argument values
- Return edge transfer: pass return values
- Node transfer plus that kill the LHS variable

