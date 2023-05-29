---
layout: post
title: Static Program Analysis - Pointer Analysis
description: 南大《软件分析》课程 08
categories: PL
tags: [PL]
---

## Keys Facts and Choice in This Course

![facts](/images/posts/2023-05-29-static-program-analysis-8.md.assets/QQ20230529-155540.png)

## What Do We Analyze

### Pointers in Java

- Local variable: x
- Static field: C.f
- Instance field: x.f
- Array element: array[i]: 会忽略下标，把它们都当成是 array 的一个 field 比如叫 arr，比如 `array[0]` 也是 `array.arr`，`array[1]` 也是 `array.arr`

### Pointer-affected Statements

- New. `x = new T()`
- Assign. `x = y`
- Store. `x.f = y`
- Load. `y = x.f`
- Call. `r = x.k(a, ...)`

### Domains and Notations

![notations](/images/posts/2023-05-29-static-program-analysis-8.md.assets/QQ20230529-161405.png)

### Rules

![rules](/images/posts/2023-05-29-static-program-analysis-8.md.assets/QQ20230529-161940.png)

![rules2](/images/posts/2023-05-29-static-program-analysis-8.md.assets/QQ20230529-162855.png)
