---
layout: wiki
title: LaTeX
---

## $\LaTeX$文档基本结构

```latex
%%% 简单文档
% 导言：格式设置
\documentclass{ctexart}
\usepackage[b5paper]{geometry}
% 正文：填写内容
\begin{document}
使用 \LaTeX
\end{document}
```

## 文档部件

- 标题：`\title`, `\author`, `\date`, `\maketitle`
- 摘要/前言：`abstract`, `\chapter*`
- 目录：`\tableofcontents`
- 章节：`\chapter`, `\section`, ...
- 附录：`\appendix` + `\chapter` 或 `\section` ...
- 文献：`\bibliography`
- 索引：`\printindex`

## 文档划分

- 大型文档：`\frontmatter`, `\mainmatter`, `\backmatter`（跟页码划分有关）
- 一般文档：`\appendix`

章节层次：

| 层次 | 名称          | 命令             | 说明                                |
| ---: | ------------- | ---------------- | ----------------------------------- |
|   -1 | part          | `\part`          | 可选的最高层                        |
|    0 | chapter       | `\chapter`       | report, book 类最高层               |
|    1 | section       | `\section`       | article 类最高层                    |
|    2 | subsection    | `\subsection`    |                                     |
|    3 | subsubsection | `\subsubsection` | report, book 类默认不编号、不编目录 |
|    4 | paragraph     | `\paragraph`     | 默认不编号、不编目录                |
|    5 | subparagraph  | `\subparagraph`  | 默认不编号、不编目录                |

## 磁盘文件组织

- 主文档，给出文档框架结构
- 按内容章节划分不同的文件
- 使用单独的类文件和格式文件设置格式
- 用小文件隔离复杂的图表

相关命令：

- `\documentclass`：读入文档类文件（.cls）
- `\usepackage`：读入一个格式文件——宏包（.sty）
- `\include`：分页，并读入章节文件（.tex）
- `\input`：读入任意文件

## 语法结构

- 命令：参数总在后面的花括号表示，用中括号可以表示可选参数

  ```latex
  \cmd{arg1}{arg2}
  \cmd[opt]{arg1}{arg2}
  ```

  举例：$\frac{1}{2}$

  ```latex
  \frac{1}{2}
  ```

- 环境

  ```latex
  \begin{env}
    ......
  \end{env}
  ```

  举例：$\LaTeX$的矩阵

  ```latex
  \begin{matrix} ... \\ ... \end{matrix}
  ```

- 注释：以符号 `%` 开头，该行在 `%` 后面的部分。

## 正文符号

一些特殊符号被占用了需要使用命令的形式输入（类似转义字符）。其它的不说，只说一下反斜线：

```latex
\textbackslash
```

还有一些特殊符号比如$\S \P$，之类的可以看 symbols 文档。

## 数学模式

数学模式下的字体、符号、间距与正文都不同，一切数学符号（包括单个符号 $n$,  $\pi$）都要在数学模式下输入：

- 行内（inline）公式：使用一堆符号 `$ $` 来标示。如 `$a+b=c$`
- 显示（display）公式：
  - 简单的不编号公式使用命令 `\[` 和 `\]` 标示。（不要使用双美元符号）
  - 基本的编号的公式用 `equation` 环境
  - 更复杂的结构，使用 `amsmath` 宏包提供的专门的数学环境。（不要使用 `eqnarray` 环境） 

## 数学结构

- 上标和下标：用 `^` 和 `_` 表示。
- 上下画线与花括号：`\overline`, `\underline`, `\overbrace`, `\underbrace`
- 分式：`\frac{分子}{分母}`
- 根式：`\sqrt[次数]{根号下}`
- 矩阵：使用 amsmath 宏包提供的专门的矩阵环境 `matrix`, `pmatrix`, `bmatrix` 等。特别复杂的矩阵（如带线条）使用 `array` 环境作为表格画出。

## 数学符号

- 数学字母 $a, b, \alpha, \Delta$，数学字体 `\mathbb`（$\mathbb{R}$）、`mathcal`（$\mathcal{P}$）等
- 普通符号：如 `\infty`（$\infty$），`\angle`（$\angle$）
- 二元运算符：$a+b$，$a-b$，及 $a \oplus b$（前后空了一点距离）
- 二元关系符：$a=b$，$a \le b$
- 括号：$\langle a, b \rangle$，使用 `\left`，`\right` 放大
- 标点：逗号、冒号（`\colon`，直接输入冒号是比例符号）

## 列表环境

- `enumerate` 带标号
- `itemize` 不编号
- `description` 有标题

比如：

```latex
\begin{enumerate}
\item a
\item b
\item c
\end{enumerate}
```

## 定理类环境

- `\newtheorem` 定义定理类环境，如

  ```latex
  \newtheorem{thm}{定理}[section]
  ```

- 使用定理类环境，如

  ```latex
  \begin{thm}
  一个定理
  \end{thm}
  ```

## 诗歌与引文

- `verse`
- `quote`
- `quotation`

## 抄录代码

- `\verb` 命令，如

  ```latex
  \verb|#include<stdio.h>|
  ```

- `verbatim` 环境，如

  ```latex
  \begin{verbatim}
  #include <stdio.h>
  int main() {
  	puts("hello world");
  }
  \end{verbatim}
  ```

- 语法高亮，使用 listings 宏包：

  ```latex
  \begin{lstlisting}[language=C,
  	basicstyle=\ttfamily,
  	stringstyle=\color{blue}]
  #include <stdio.h>
  int main() {
  	puts("hello world");
  }
  \end{lstlisting}
  ```

  这个代码我测试了不太行不知道为什么。

## 算法结构

- clrscode 宏包
- algorithm2e 宏包
- algorithmicx 宏包的 algpseudocode 格式

```latex
\usepackage{clrscode}
\begin{codebox}
\Procname{$\proc{Merge-Sort}(A,p,r)}
\li \If $p<r$
\li \Then $q \gets \lfloor(p+r)/2\rfloor$
\li   $\proc{Merge-Sort}(A,p,q)$
\li   $\proc{Merge-Sort}(A,q+1,r)$
\li   $\proc{Merge}(A,p,q,r)$
		\End
\end{codebox}
```

## 表格

使用 `tabular` 环境。

```latex
\begin{tabular}{|rr|}
\hline
输入& 输出\\ \hline
$-2$ & 4 \\
0 & 0 \\
2 & 4 \\ \hline
\end{tabular}
```

生成表格的网站：[Create LaTeX tables online – TablesGenerator.com](https://www.tablesgenerator.com/)

## 插图

使用 `graphicx` 宏包提供的 `\includegraphics` 命令。

## 浮动体

- `figure` 环境
- `table` 环境
- 其他环境可以使用 `float` 宏包得到

浮动体的标题用 `\caption` 命令得到，自动编号。

## 文献

用 BIBTeX，和 `\cite`、`\nocite` 命令。
