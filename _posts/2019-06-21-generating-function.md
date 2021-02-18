---
layout: post
title: 差劲的算法学习 - 母函数
categories: Algorithms
description: 差劲的算法学习系列, 母函数的简单研究
tags: [Algorithms]
archived: true
---
期末考试还剩下三门比较复杂的学科, 稍作休息今天先来研究一下母函数.  
离散数学学科的学校学习中, 由于时间有限, 代课老师并没有教组合数学分支的内容. 而不仅仅是离散数学, 在平时的算法竞赛中, 组合数学母函数相关的题目出现的还是比较多的. 于是今天闲来无事就稍微研究了一下.  

首先, 还是要感谢csdn上的某博主提供的博文. 链接依旧会放在这篇文章的结尾.   

## 母函数引言
组合数学作为离散数学中**充满魅力**的一个分支, 我在高中的时候就稍微有所了解了. 虽然学习时间不长, 学习的内容不深, 但是仍能感觉到, 组合数学中散发出的那种魔力.  
这里的引言, 就从百度百科以及csdn博主共同提到的一个问题开始.   

> 有1克、2克、3克、4克的砝码各一枚，能称出哪几种重量？每种重量各有几种可能方案？

这题按照正常的思路 -- 穷举, 原因很简单, 因为只有四种砝码嘛, 虽然穷举是最无脑的方法, 但是也是最容易编写代码的方法. 下面给出一个$O(N^4)$的"*算法?*".

```c++
#include <bits/stdc++.h>
using namespace std;

int main()
{
    int count[11];
    for (auto &c: count) {
        c = 0;
    }

    for (int use1 = 0; use1 <= 1; ++use1) {
        for (int use2 = 0; use2 <= 1; ++use2) {
            for (int use3 = 0; use3 <= 1; ++use3) {
                for (int use4 = 0; use4 <= 1; ++use4) {
                    auto sum = (use1 ? 1 : 0) + (use2 ? 2 : 0) 
                             + (use3 ? 3 : 0) + (use4 ? 4 : 0);
                    cout << sum << endl;
                    ++count[sum];
                }
            }
        }
    }

    int n; // 需要凑成多少克的砝码
    while (cin >> n) {
        cout << count[n] << endl;
    }

    return 0;
}
```   

说句老实话, 这是我今年写过**最蠢**的代码了. 

## 普通母函数  
这个题目我能想到的方法就是使用dp, 具体怎么实现就不在这里赘述了. 但是考虑到这题的数据实在是少, 确实优先会考虑直接用暴力解决, 也就是上面的代码...   
母函数, Generating function, 我更喜欢叫作生成函数, 也就是它直译的名字. 关于生成函数的具体定义, 百度百科上是没有的. 这边在维基百科上摘取了一段:
> 在数学中，某个序列 $(a_{n})_{n\in\mathbb{N}}$ 的母函数（又称生成函数，英语：Generating function）是一种形式幂级数，其每一项的系数可以提供关于这个序列的信息。使用母函数解决问题的方法称为母函数方法。  
> 母函数可分为很多种，包括普通母函数、指数母函数、L级数、贝尔级数和狄利克雷级数。对每个序列都可以写出以上每个类型的一个母函数。构造母函数的目的一般是为了解决某个特定的问题，因此选用何种母函数视乎序列本身的特性和问题的类型。  

所以, 我们还是举一些具体的例子, 来说明母函数到底是什么. 这边我们考虑到做算法题用不到那么复杂的母函数, 所以不会深入研究, 如果有需要, 会在专门的离散数学专栏开一篇研究文章.   

首先, 问题还是刚才那个砝码问题, 我们将原题的所有情况*符号化*表示:  

$set\ F(X): 使用Xg砝码.$   
$$
(F(1)\lor\lnot F(1)) \land (F(2)\lor\lnot F(2)) \land (F(3)\lor\lnot F(3)) \land (F(4)\lor\lnot F(4))  
$$  
显然, 这是一个非常非常标准的合取式. 如果我们:  
$set\ p: 使用1g砝码\ q: 使用2g砝码\ r: 使用3g砝码\ s: 使用4g砝码.$  
$$  
(F(1)\lor\lnot F(1)) \land (F(2)\lor\lnot F(2)) \land (F(3)\lor\lnot F(3)) \land (F(4)\lor\lnot F(4))\Rightarrow p\land q\land r\land s  
$$  
接着我们也可以很容易写出真值表, 列出所有的情形.  
根据简单计数原理的知识, 其实很容易算出一共有$2^4=16$种可能性.   
但是这只是在砝码比较少的情况下. 假设这里给出了$100000$个不同重量的砝码, 一共可以组成多少种情况?   
$$  
2^{100000}=10^x\\
\lg2^{100000}=lg10^x\\
100000\lg2=x\\
x\approx30103
$$      
额, 所以可见这个情况数的数量级有点太大了. 并且考虑到算法的复杂度, 高达$O(N^{100000})$. *算法导论*上提到的, $O(N^4)$以上的算法, 就不能再被叫做算法了, 这就是为什么前文里的*算法*我打了引号.    

我们再来考虑一下另外一个问题, 有100000个100000面的色子(虽然这种色子可能存在吗? 但是想想OJ的测试点里什么没有?), 那么存在多少种情况呢?    
$$100000^{100000}=10^{500000}$$   
显然这不应该是我们应该用循环或者递归去写的算法..., 因为它的时间复杂度高达$O(N^N)$, 达到了幂指级.  

这时候母函数的作用就体现出来了, 它能将这个复杂度高达$O(N^N)$的算法降到$O(N^3)$.  

这里我们还是先将第二个问题里出现的色子的情形, 使用符号语言表示一下.   
$set\ F_i(K): 第i个色子掷到K点数$   
$$
\bigwedge\limits_{i=1}^N\bigvee\limits_{j=1}^NF_i(j)
$$  

稍微考虑一下, 这里所有的色子其实都是等价的, 并没有特别的必要进行区分, 这里的$i$也仅仅是对每一个色子进行了标号. 对于一个色子的所有可能的情况, 我们把它表示成一个多项式的形式:    
$$
K(x)=\sum\limits^N_{i=1}x^i=x+x^2+x^3+\ldots+x^N
$$  
这里$K(x)$的变量$x$的指数, 就是上文中提到的 -- 色子可能出现的点数, 我们这里关注一下幂的运算规律.  
$$  
a^p\cdot a^q=a^{p+q}   
$$  
如果把$K(x)$所有项系数看作是"投掷一个筛子出现i(指数)点数的可能数", 所有系数和看作"出现的所有情况数"的话, 根据刚才提到的幂的运算法则, 我们可以尝试把, $K(x$)乘上他自己.  
$$  
f(x)=K^2(x)=(x+x^2+x^3+\ldots+x^N)(x+x^2+x^3+\ldots+x^N)
$$  
针对刚才例子中的情况, 我们把情况降到投两个普通的6面色子, 那么, 代入上式:  
$$  
f_{N=6}(x)={K_{N=6}}^2(x)=(x+x^2+x^3+x^4+x^5+x^6)(x+x^2+x^3+x^4+x^5+x^6)\\  
=x^2+2x^3+3x^4+4x^5+5x^6+6x^7+5x^8+4x^9+3x^{10}+2x^{11}+x^{12}   
$$  
根据技术原理的加法法则和乘法法则, 我们知道不同时发生的事情使用加法法则, 同时发生的事使用乘法法则. 两个色子被掷下, 产生的点数的事件同时发生, 使用乘法法则, 即比如说1号色子投到2点, 2号色子投到6点, 那么根据的两个理论, 一个是幂运算法则, 一个是系数表示可能的情况种数, 我们可以得到: 第一个多项式的$x^2$项, 乘上第二个多项式的$x^6$项, 即$x^2\cdot x^6=x^8$, 这个8也正好就是两个色子加起来的和点数.    
于是像这样所有的$6\times 6=36$个项乘完之后, 合并同类项, 最终得到的最简多项式, 每一项的系数, 也就对应出现"幂指数和"情况时的所有可能数.   

我们将最终的结果转化为向量, 即:  
```c++
std::vector<int> coefficient_vec {1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1};  
```  
并对出现的所有情况进行求和:  
```c++
auto sum = std::accumulate(std::begin(coefficient_vec), std::end(coefficient_vec), 
                           0, std::plus<int>());
assert(6 * 6 == sum);
```  
接着便可以求每一种情况出现的概率了:  
```c++
for (int i = 0; i < coefficient_vec.size(); ++i) {
    std::cout << i + 1 << ": " 
              << std::setprecision(3) << std::fixed
              << coefficient_vec.at(i) / double(sum)
              << std::endl;
}
```  

完整的测试代码:
```c++
#include <iostream>
#include <cassert>  // assert
#include <vector>   // std::vector
#include <functional>  // std::plus
#include <numeric>  // std::accumulate
#include <iomanip>
using namespace std;

int main()
{
    vector<int> coefficient_vec {1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1};

    auto sum = accumulate(begin(coefficient_vec), end(coefficient_vec),
                          0, plus<int>());
    assert(6 * 6 == sum);  // cout << sum << endl;

    for (int i = 0; i < coefficient_vec.size(); ++i) {
        cout << i + 1 << ": " 
             << setprecision(3) << fixed
             << coefficient_vec.at(i) / double(sum)
             << endl;
    }

    return 0;
}
```  

这意味着假如我们要投掷*10*个色子, 我们其实只需要将类似这样的*10*个多项式相乘化简即可. 我们知道两个多项式相乘的复杂度为$O(N^2)$, *10*个多项式相乘只需要重复刚才的$O(N^2)$即可, 也就是变成了$O(N^3)$.  
下面将给出一个程序实例, 计算投$n$个$m(1...m)$面色子出现点数之和$k$的概率.  
```c++
#include <iostream>  // std::cout, std::endl
#include <cassert>  // assert
#include <vector>   // std::vector
#include <functional>  // std::plus
#include <numeric>  // std::accumulate
#include <iomanip>  // std::setprecision, std::fixed
#include <map>  // std::map
#include <utility>  // std::make_pair
using namespace std;
using ll = int64_t;

// #define __DEBUG 1

int main()
{
    int n, m, k;
    while (cin >> n >> m >> k) {
        map<int, int> proto;
        map<int, int> multi;
        map<int, int> reslt;
        reslt.insert(make_pair(0, 1));
        for (int p = 1; p <= m; ++p) {
            ++proto[p];
        }

        for (int _ = 0; _ < n; ++_) {
            multi = move(reslt);
            for (const auto& fstPr: proto) {
                for (const auto& sndPr: multi) {
                    reslt[fstPr.first + sndPr.first] += fstPr.second * sndPr.second;
                }
            }
#ifdef __DEBUG
            bool firstIn = true;
            for (const auto& p: reslt) {
                if (firstIn) {
                    firstIn = false;
                } else {
                    cout << '+';
                }
                if (p.second == 1)
                    cout << "x^" << p.first;
                else
                    cout << p.second << "x^" << p.first;
            }
            cout << endl;
#endif  /* __DEBUG */
        }
        
        ll psum = 0ll;
        for (const auto& p: reslt) {
            psum += p.second;
        }

#ifdef __DEBUG
        auto ssum = 0.;
        for (const auto& p: reslt) {
            cout << fixed << setprecision(3)
                 << p.first << ": "
                 << double(p.second) / psum << endl;
            ssum += double(p.second) / psum;
        }
#endif  /* __DEBUG */

        cout << fixed << setprecision(3)
             << double(reslt[k]) / psum << endl;
    }

    return 0;
}
```

上面的代码只是提供了一个思路, 实际运行起来效率还是非常慢.  






### 参考资料:
> 1. [鸡冠花12138 - 母函数（对于初学者的最容易理解的）](https://blog.csdn.net/yu121380/article/details/79914529)
> 2. [百度百科词条 - 母函数](https://baike.baidu.com/item/母函数)
> 3. [维基百科词条 - 母函数](https://zh.wikipedia.org/wiki/%E6%AF%8D%E5%87%BD%E6%95%B0)

