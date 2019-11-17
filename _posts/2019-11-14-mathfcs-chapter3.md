---
layout: post
title: 计算机科学中的数学第三章笔记和习题
categories: Maths
description: 
keywords: Maths
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
```Python
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
