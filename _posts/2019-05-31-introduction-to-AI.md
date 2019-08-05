---
layout: post
title: 大数据与人工智能培训-人工智能概论
categories: AI
description: 大数据与人工智能培训第二天上午的内容
keywords: AI
---

大数据与人工智能培训第二天上午的内容  

> 挺可惜的, 昨天的大数据实战因为C语言期末考试而错过了, 后三天的内容全是人工智能了.

## 人工智能 (Artificial Intelligence)  
> 所谓的"智能", 其实难以下一个明确的定义.   

### 机器学习 (Machine Learning, ML)  
- 理论与实践相结合  
	- 面向理论  
		- 推导深层次的理解  
		- 大众兴趣度低  
	- 面向技术  
		- 不考虑细节, 凸显实践的闪光  
		- 太多技术, 很难选择, 很难正确使用  
		
### 从基础切入  
混合哲学思想, 关键理论, 核心技术, 实践应用  
- <strong>When</strong>&nbsp;&nbsp;&nbsp;&nbsp;(直觉+技术)  
- <strong>Why</strong>&nbsp;&nbsp;&nbsp;&nbsp;(理论+直觉)  
- <strong>How</strong>&nbsp;&nbsp;&nbsp;&nbsp;(技术+实践)   
- <strong>How better</strong>&nbsp;&nbsp;&nbsp;&nbsp;(实践+理论)   

### IPO模型 (Input, Process, Output)  
- __Normal Learning:__  
从观察出发, 获得技巧    
observations $\rightarrow$ learning $\rightarrow$ skill  
- __Machine Learning:__  
data $\rightarrow$ ML $\rightarrow$ Improved/ Performance/ measure  

### 为什么使用机器学习?  
- 定义范式很困难  
- 从数据中学习(观察)很容易  
- 机器学习是一个更容易实现复杂系统的可选路径  

### 机器学习应用场景   
- __很难定义范式 (机器通过学习和环境互动)__  
- __不容易写出规则__  
	e.g.: 语音/ 视觉识别或处理   
- __需要人们快速决策__  
	e.g.:量化交易  
- __需要个性化定制__  
	e.g.:推荐系统, 用户画像  
 
 
### 应用机器学习的三个关键  
- 存在某种潜在模式可以去学习  
- 但是模式很难去定义   
- 需要一定量的数据  

### Q: Which of the following is best suited for machine learning?  
1. Predicting whether the next cry of the baby girl happens at an even-numbered minute or not.  
2. Determining whether a given graph contains a cycle.  
3. Deciding whether to approve credit card to some customer.  
4. Guessing whether the earth will be destroyed by the misuse of nuclear power in the next ten yerars.  

### 学习问题的形式化   
基本符号:   
- 输入: $x \in X$   
- 输出: $y \in Y$  
- 需要学习的未知模式(目标函数)   
	$f: X \rightarrow Y$   
- 数据$\leftrightarrow$训练样本   
	$D=\lbrace(x_{1},y_{1}),(x_{2},y_{2}),...,{x_{N},y_{N}}\rbrace$  
- 假设$\leftrightarrow$skill    
	$\lbrace(x_{n},y_{n})\rbrace from f \rightarrow ML \rightarrow g$  
		
### 机器学习与数据挖掘的区别
- 有时候两者等价   
- 两者可以相互促进   
- 很难分辨  

DM(Data Mining)找到隐含在资料中的有用信息, 使用大量数据寻找感兴趣的特性   

### 是非题 (PLA)  
$\sum_{i=1}^{d}w_{i}x_{i}>threshold$  
$\sum_{i=1}^{d}w_{i}x_{i}<threshold$  
$y: \lbrace+1(good),-1(bad)\rbrace$  
$h(x)=sign((\sum\limits_{i=1}^{d}-threshold))$  
  
"知错能改"算法: $w_{t+1} \leftarrow w_{t}+y_{n}()$  

### 机器学习分类  
1. 输出空间  
2. 数据标签  
3. 学习方式  
	- 批量学习  
	- 在线学习  
	- 主动学习  
4. 输入方式  
	- 特征工程    
	- 特征提取  
	- 特征选择  

### 机器学习相关概念  
- 学习率  
- [梯度下降](https://baike.baidu.com/item/梯度下降)  
- 牛顿方向  
- [最小二乘法](https://baike.baidu.com/item/最小二乘法)  





















