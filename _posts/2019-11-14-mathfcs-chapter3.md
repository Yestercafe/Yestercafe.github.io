---
layout: post
title: 计算机科学中的数学第三章笔记和习题
categories: Maths
description: 
tags: [Maths]
---

## 真值表


| $P$ | $_{\mathrm{NOT}}(P)$ |
| :--: | :--: |
| $\mathbf{T}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{T}$ |

| $P$ | $Q$ | $P\ _{\mathrm{AND}}\ Q$ |
|    :--:      |    :--:      |     :--:     |
| $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{F}$ |

| $P$ | $Q$ | $P\ _{\mathrm{OR}}\ Q$ |
|    :--:      |    :--:      |     :--:     |
| $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{T}$ |
| $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{F}$ |

| $P$ | $Q$ | $P\ _{\mathrm{XOR}}\ Q$ |
|    :--:      |    :--:      |     :--:     |
| $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{F}$ |
| $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{T}$ |
| $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{F}$ |

| $P$ | $Q$ | $P\ _{\mathrm{IFF}}\ Q$ |
|    :--:      |    :--:      |     :--:     |
| $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{T}$ |

| $P$ | $Q$ | $P\ _{\mathrm{IMPLIES}}\ Q$ |
|    :--:      |    :--:      |     :--:     |
| $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{T}$ |

## 符号表示


| English | Symbolic Notation |
| :------ | :---------------- |
| $_{\mathrm{NOT}}(P)$ | $\lnot P, \bar{P}$ |
| $P\ _{\mathrm{AND}}\ Q$ | $P\land Q$ |
| $P\ _{\mathrm{OR}}\ Q$ | $P\lor Q$ |
| $P\ _{\mathrm{IMPLIES}}\ Q$ | $P\longrightarrow Q$ |
| $\mathrm{if}\ P\ \mathrm{then}\ Q$ | $P\longrightarrow Q$ |
| $P\ _{\mathrm{IFF}}\ Q$ | $P\longleftrightarrow Q$ |
| $P\ _{\mathrm{XOR}}\ Q$ | $P\oplus Q$ |

## 析取范式和合取范式
析取范式(disjunctive normal form, DNF), 对$\mathrm{AND}$项取$\mathrm{OR}$的范式.  
合取范式(conjunctive normal form, CNF), 对$\mathrm{OR}$项取$\mathrm{AND}$的范式.  
问我范式是什么? 说不清楚, 只可意会.  

举个栗子: 对于公式 $A\ \mathrm{AND}\ (B\ \mathrm{OR}\ C)$
的真值表:   


| $A$ | $B$ | $C$ | $A\ \mathrm{AND}\ (B\ \mathrm{OR}\ C)$ |
| :----------: | :----------: | :----------: | :----------: |
| $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{T}$ |
| $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{F}$ |

DNF: $(A\ \mathrm{AND}\ B\ \mathrm{AND}\ C)\ \mathrm{OR}\ (A\ \mathrm{AND}\ B\ \mathrm{AND}\ \bar{C})\ \mathrm{OR}\ (A\ \mathrm{AND}\ \bar{B}\ \mathrm{AND}\ C)$  
CNF: $(\bar{A}\ \mathrm{OR}\ B\ \mathrm{OR}\ C)\ \mathrm{AND}\ (A\ \mathrm{OR}\ \bar{B}\ \mathrm{OR}\ \bar{C})\ \mathrm{AND}\ (A\ \mathrm{OR}\ \bar{B}\ \mathrm{OR}\ C)\ \mathrm{AND}\ (A\ \mathrm{OR}\ B\ \mathrm{OR}\ \bar{C})\ \mathrm{AND}\ (A\ \mathrm{OR}\ B\ \mathrm{OR}\ C)$

## 等价公式  
Commutativity of $\mathrm{AND}$ ($\mathrm{AND}$的交换律): $A\ \mathrm{AND}\ B\longleftrightarrow B\ \mathrm{AND}\ A$  
Associativity of $\mathrm{AND}$ ($\mathrm{AND}$的结合律): $(A\ \mathrm{AND}\ B)\ \mathrm{AND}\ C\longleftrightarrow A\ \mathrm{AND}\ (B\ \mathrm{AND}\ C)$  
Identity for $\mathrm{AND}$ ($\mathrm{AND}$的同一律): $\mathbf{T}\ \mathrm{AND}\ A\longleftrightarrow A$  
Zero for $\mathrm{AND}$ ($\mathrm{AND}$的零律): $\mathbf{F}\ \mathrm{AND}\ A\longleftrightarrow F$  
Distibutivity of $\mathrm{AND}$ over $\mathrm{OR}$ ($\mathrm{AND}$对$\mathrm{OR}$的分配律): $A\ \mathrm{AND}\ (B\ \mathrm{OR}\ C)\longleftrightarrow (A\ \mathrm{AND}\ B)\ \mathrm{OR}\ (A\ \mathrm{AND}\ C)$   
Distibutivity of $\mathrm{OR}$ over $\mathrm{AND}$ ($\mathrm{OR}$对$\mathrm{AND}$的分配律): $A\ \mathrm{OR}\ (B\ \mathrm{AND}\ C)\longleftrightarrow (A\ \mathrm{OR}\ B)\ \mathrm{AND}\ (A\ \mathrm{OR}\ C)$     
Idempotence for $\mathrm{AND}$ ($\mathrm{AND}$的幂等律): $A\ \mathrm{AND}\ A\longleftrightarrow A$   
Contradiction for $\mathrm{AND}$ ($\mathrm{AND}$的矛盾律): $A\ \mathrm{AND}\ \bar{A}\longleftrightarrow \mathbf{F}$   
Double Negation (双重否定律): $\mathrm{NOT}(\bar{A})\longleftrightarrow A$    
Validity for $\mathrm{AND}$ ($\mathrm{AND}$的永真律): $A\ \mathrm{OR}\ \bar{A}\longleftrightarrow \mathbf{T}$   
DeMorgan for $\mathrm{AND}$ ($\mathrm{AND}$的德摩根律): $\mathrm{NOT}(A\ \mathrm{AND}\ B)\longleftrightarrow \bar{A}\ \mathrm{OR}\ \bar{B}$  
DeMorgan for $\mathrm{OR}$ ($\mathrm{OR}$的德摩根律): $\mathrm{NOT}(A\ \mathrm{OR}\ B)\longleftrightarrow \bar{A}\ \mathrm{AND}\ \bar{B}$   

## 谓词公式
量词的引入对整个谓词公式系统影响较大, 但是比较简单, 两个量词, for all($\forall$)和there exists($\exists$).   
记几个公式:  
$$\mathrm{NOT}(\forall x.\ P(x)) \longleftrightarrow \exists x.\ \mathrm{NOT}(P(x))$$  
$$\mathrm{NOT}(\exists x.\ P(x)) \longleftrightarrow \forall x.\ \mathrm{NOT}(P(x))$$
$$\exists x \forall y.\ P(x, y)\ \mathrm{IMPLIES}\ \forall y\exists x.\ P(x, y) \longleftrightarrow \mathbf{T}$$

## 3.1节习题   
### 练习题  
#### 习题3.1
"如果P为假, 则P IMPLIES Q"应该等价于$P \land Q$.  

#### 习题3.2  
(a). $P\land \lnot Q$  
(b). $P\land Q\land R$  
(c). $P\longrightarrow R$  
(d). $P\land \lnot Q\land R$  

### 随堂练习
#### 习题3.3
站在否命题的角度考虑. 前者是微积分学中的定理, 懂一点微积分学的人都知道, 连续但不可微的函数是存在的, 即对于D和C, 如果设它们之间构成的逻辑关系为R, 则它们的真值表应为:  

| $D$ | $C$ | $D\ \mathrm{R}\ C$ |
| :--: | :--: | :--: |
| $\mathbf{T}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{T}$ | $\mathbf{F}$ | $\mathbf{F}$ |
| $\mathbf{F}$ | $\mathbf{T}$ | $\mathbf{T}$ |
| $\mathbf{F}$ | $\mathbf{F}$ | $\mathbf{T}$ |

很明显, 这就是$\mathrm{IMPLIES}$.    
但是对于做作业和看电视, 这两事件的发生明显是相互绑定的, 所以必然是IFF.  

### 课后作业  
#### 习题3.4  
我在想原题的描述是不是有问题, 这根本就是一个行为$2^n$, 列为n的矩阵. 是个递归, 用Python简单实现一下:  
```python
def generate(lst, limits):
    if len(lst) == limits:
        for e in lst: print(e, end = ' ')
        print()
    else:
        lst.append('T')
        generate(lst, limits)
        lst.append('F')
        generate(lst, limits)
    if len(lst) != 0: lst.pop()

if __name__ == '__main__':
    n = int(input('Input n: '))
    generate([], n)

```

#### 习题3.5  
(a). 真值表是简单但又复杂的东西, 不列了.   
(b). 他犯的错误, 是忘记了他的前提"Q为真"是假设的, 所以接下来的证明, 并无法涵盖"Q为假"时的所有情况.    

## 3.2节习题  
### 随堂练习
#### 习题3.6
题目字真的好多...   
(a).  
$c_0 = b$  
$\dots$  
$s_i = a_i\ \mathrm{XOR}\ c_i$  
$c_{i + 1} = a_0\ \mathrm{AND}\ c_i$   
$\dots$  
$c = c_{n+1}$  
(b).  
$c_1 = a_0\ \mathrm{AND}\ b_0$  
$\dots$  
$s_i = a_i\ \mathrm{XOR}\ b_i\ \mathrm{XOR}\ c_i$  
$c_{i + 1} = (a_0\ \mathrm{AND}\ b_0)\ \mathrm{OR}\ (a_0\ \mathrm{AND}\ c_0)\ \mathrm{OR}\ (b_0\ \mathrm{AND}\ c_0)$  
$\dots$  
$c = c_{n + 1}$  
(c).  
$7n+1$. 但我觉得我的方法不是最简的.  

### 课后作业  
#### 习题3.7  

### 测试题  
#### 习题3.8  
(a). 有6个变量嘛, 所以应该是$2^6 = 64$行. 所以也就说明了列真值表这种方法, 也不是在所有场合下都很有效.  
(b). 我们先假设$P$为真的情况, 此时$\bar{P}$为假, 所以$Q$就必须为真; 以此类推可以推出, $R$, $S$都必为真, 接着容易得$M$为真, $N$为假, 这是一组解; 假设$P$为假的情形, 从后往前推, $M$依旧必须为真, $N$依旧必须为假, 同样的, $\bar{S}\ \mathrm{OR}\ P$必须为真, 于是$S$必须为假, 以此类推, $R$, $Q$必须为假, 这是另外一组解. 根据刚才的推理, 我们发现有且仅有这两种组合.  

#### 习题3.9  
(a). $n-1$.  
(c). **证明.** 根据题目和图形的描述, 很容易理解到, 这题就是求叶子节点个数为n的完满二叉树的非叶子结点的个数, 我们使用数学手段推导:  
底层节点有$n$个, 根据二叉树的性质, 上层节点数应为下层节点数的$\frac{1}{2}$. 根节点只有一个, 我们干脆反过来考虑, 统计总节点数:    
$$2^0 + 2^1 + 2^2 + \dots + 2^{\ulcorner logn \urcorner - 1} + n$$  
题目中也说到n是2的幂了(不然也不会是完满二叉树的), 所以上式就可以化为:  
$$2^0 + 2^1 + 2^2 + \dots + 2^{logn - 1} + n$$   
我们要求的其实不是所有节点的数目, 而是非叶子节点的数目, 所以直接减掉:   
$$2^0 + 2^1 + 2^2 + \dots + 2^{logn - 1}$$   
然后就是一个非常简单的级数求和了:   
$$2^{logn}-1 = n -1$$
所以在$n$位输入顺序电路中, 一共有$n- 1$个$\mathrm{AND}$门. $\square$   
(b). 同样我们还是使用数学手段来说明这个问题. 设一个$\mathrm{AND}$门的运算速度为$v$, 当然, 多个与门并行运算的速度也为$v$, 我们这里来计算$n-1$个与门在两种方案下的平均运算速度:  
- 先考虑线性运算的方案, 很显然, 这些与门的平均运算速度为$\frac{(n-1)v}{n-1} = v$.  
- 考虑树形的运算速度. 按树状运算, 树的每一层的与运算都应该是并行的, 整个花费的时间, 应该为树深度乘速度, 即$\frac{(n - 1)v}{depth}$. 参考离散数学中的知识, 二叉树的深度应该为$\llcorner logN \lrcorner + 1$, 其中$N$为树的节点数. 代入式中, 有$\frac{(n - 1)v}{\llcorner log(n-1) \lrcorner + 1}$.  
- 所以树形运算的平均速度应为线性运算的$\frac{n-1}{logn+1}$倍, 即$\bar{v} _2 = \frac{n-1}{logn+1} \bar{v} _1$, 当$n\rightarrow \infty$时, 该等式变为了$\lim\limits_{n\rightarrow \infty}\bar{v}_2=\frac{n}{logn}\bar{v}_1\stackrel{n::=2^k}{\iff}\lim\limits_{n\rightarrow \infty}\bar{v}_2=\frac{2^k}{k}\bar{v}_1$.   

实际计算出来速度好像不是单纯的指数倍, 但是时间确实是指数倍没毛病的.  

## 3.3节习题  
### 练习题  
#### 习题3.10  
$M\longrightarrow Q$, $\mathbf{N}$, 真值赋值为$\mathbf{TT, TF, FF}$.  

$M\longrightarrow (\bar{P}\lor \bar{Q})$, $\mathbf{N}$, 真值赋值为$\mathbf{TFF, TFT, TTF, TTT, FTT}$.   

$M\ \mathrm{IMPLIES}\ [M\ \mathrm{AND}\ (P\ \mathrm{IMPLIES}\ M)]$, 这后面的都有些麻烦, 先化简.  
这里先引入一个mfcs中没有提到, 但是离散数学中提到了的一个公式:  
$$p\rightarrow q \iff p\lor \lnot q$$  
所以,   
$M\longrightarrow (M\land (P\longrightarrow M))$  
$\iff M\lor \lnot (M\land (P\longrightarrow M))$  
$\iff M\lor \lnot (M\land (P\lor \bar M))$  
$\iff M\lor \lnot (M\land (P\lor \bar M))$  
$\iff M\lor \lnot ((M\land P)\lor (M\land \bar M))$  
$\iff M\lor \lnot(M\land P)$  
$\iff M\lor (\bar M \lor\bar P)$  
$\iff (M\lor \bar M)\lor \bar P$  
$\iff \mathbf{T}\lor \bar P$  
$\iff \mathbf{T}$  
所以这是一个$\mathbf{V}$.   

$(P\lor Q)\longrightarrow Q$  
$\iff (P\lor Q)\lor \bar Q$  
$\iff P\lor (Q\lor \bar Q)$  
$\iff P\lor \mathbf{T}$  
$\iff T$  
所以这也是一个$\mathbf{V}$.

$(P\lor Q)\longrightarrow (\bar P\land \bar Q)$   
$\iff (P\lor Q)\longrightarrow \lnot(P\lor Q)$  
$\stackrel{R::=P\lor Q}{\iff} R\longrightarrow \bar R$  
因为$\mathbf{T}\longrightarrow \mathbf{F}$为真, $\mathbf{F}\longrightarrow \mathbf{T}$为假, 所以这是一个$\mathbf{N}$. 真值赋值为$\mathbf{TT, TF, FT}$.  

$(P\lor Q)\longrightarrow (M\land (P\longrightarrow M))$  
$\iff \dots \iff (P\lor Q)\lor \lnot(\bar M \lor\bar P)$  
$\iff \dots \iff\mathbf{T}$   
这是一个$\mathbf{V}$.  

$(P\oplus Q)\longrightarrow Q$  
$\iff ((P\lor Q)\land \lnot(P\land Q))\longrightarrow Q$  
$\iff ((P\lor Q)\land (\bar P\lor \bar Q))\lor \bar Q$  
$\iff (((P\lor Q)\land \bar P)\lor ((P\lor Q)\land \bar Q)))\lor \bar Q$  
$\iff ((Q\land \bar P)\lor (P\land \bar Q))\lor \bar Q$  
$\iff (P\land \bar Q)\lor ((Q\land \bar P)\lor \bar Q)$  
$\iff (P\land \bar Q)\lor (P\lor \bar Q)$  
$\iff ((P\land \bar Q)\lor P)\lor \bar Q$  
$\iff P\lor \bar Q$(吸收律)  
早想到吸收律了, 但是由于这本书里没有说这个, 所以一直在尝试使用已知的公式去替换, 结果循环了. 吸收律公式如下:  
$$P\land (P\lor Q) \iff P\lor (P\land Q)\iff P$$   
所以这也是一个$\mathbf{N}$, 成真赋值为$\mathbf{TT, TF, FF}$.  

