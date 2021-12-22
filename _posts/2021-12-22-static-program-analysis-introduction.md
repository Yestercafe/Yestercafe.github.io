---
layout: post
title: Static Program Analysis - Introduction
categories: PL
tags: [PL]
---

南京大学《软件分析》课程01（Introduction）：[https://www.bilibili.com/video/av91858985](https://www.bilibili.com/video/av91858985)

## 学习静态分析的意义

- 非常有趣，非常想学，那就学
- 有了静态分析学习的思维，更能写出更可靠、更安全、更高效的代码
- 老师名言：现在的社会非常浮躁，毕业了比的是什么，很多人比的是我能不能找到一份好的工作，我年薪能不能比我旁边的同学高，我找到工作之后我能不能付得起自己的首付，过几年之后我能不能买得到房子，然后我以后过的怎么样。大概就是这样的物欲横流的社会价值和环境，已经束缚了我们本身的价值观。我觉得这是大家需要相当警惕的一件事情。你作为一个大学生，（尤其是作为中国顶级学校的大学生，）应该有自我的思考。其实人生有一门课，大家时常记在心里，就是不断地认识自己，发掘自己，看看真正什么东西能够使你快乐起来，什么东西是你真正愿意花时间和精力去搞，你现在不清楚没有关系，但你要思考，不然就要随波逐流了，那你这一辈子本可以多的更多的选择就没有了。……哪怕你就是以后开个奶茶店，不搞计算机，但你既然选了这门课程，你就要看看你在计算机这条路上能走多远，这是给自己一个交代。

## Rice’s Theorem

> Any non-trivial property of the behavior of programs in a r.e. language is undecidable.

r.e.(recursively enumerable) = recognizable by a Turing-machine

任何在如今绝大部分的编程语言的程序中的 non-trivial 的行为属性都是不可预测的。

**什么是 non-trivial？**

A property is trivial if either it is not satisfied by any r.e. language, or if it is satisfied by all r.e. languages; otherwise it is non-trivial.

简单来说 non-trivial 属性是一些*有趣的*的属性，这些属性关联到程序的运行时行为。

## Sound & Complete

![image-20211222175133984](/images/posts/2021-12-22-static-analysis.assets/image-20211222175133984.png)

The `Truth` is sound & complete.

真实是即 sound 又 complete 的。倾向于 sound 的是 over-approximated，倾向于 complete 的是 under-approximated。

![image-20211222180409044](/images/posts/2021-12-22-static-analysis.assets/image-20211222180409044.png)

完美的静态分析被 Rice 打脸了，是不实际的。但是存在有用的静态分析：

- Compromise soundness (false negatives)
- Compromise completeness (false positives)

妥协 soundness 被叫做 false negatives，中文为漏报；妥协 completeness 被叫做 false positives，中文为误报。优先选择妥协 completeness，选择 sound。即允许误报不允许漏报。