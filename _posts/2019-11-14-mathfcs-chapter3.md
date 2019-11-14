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