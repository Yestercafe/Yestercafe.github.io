---
layout: post
title: C++ Templates-The Complete Guide Node Part I
categories: cpp
description: C++ Templates-The Complete Guide 阅读笔记第一部分
keywords: cpp
---

在写这篇之前, 需要强调一下书里也强调了的东西. 因为使用的书是17年出版的C++ Templates第二版, 书中大量地使用了C++14, C++17甚至是C++2a(目前是2a, 不保证我能在20年C++20出来之前看完)标准中的features. 在此列举一些将可能会使用到的特性, 但也不局限于此:  
- Variadic templates (C++11)
- 可变模板
- Alias templates (C++11)
- 模板别名
- Move semantics, rvalue references, and perfect forwarding (C++11)
- 移动语义, 右值引用, 完美转发
- Standard type traits (C++11)
- 标准库中的type_traits(类型特征)
- Variable templates (C++14)
- 变量模板
- Generic Lambdas (C++14)
- 通用Lambda表达式
- Class template argument deduction (C++17)
- 类模板参数推导
- Compile-time if (C++17)
- 编译期if
- Fold expressions (C++17)
- 折叠表达式

因为之前写的一些内容比较累赘, 基本就是在翻译全书了, 所以本次会大幅度减少篇幅.  

# Part I. The Basics
本部分主要介绍一些模板基础.  

## Chapter 1 - Function Templates  
### Defining and Using 声明和使用
`basics/max1.hpp`  
```c++  
template<typename T>
T max (T a, T b)
{
    // if b < a then yield a else yield b
    return b < a ? a : b;
}
```  
这样的模板定义会指定一个家族的函数. 模板就不多解释了, 毕竟这本书的重点不是基础知识.   

```c++
template< comma-separated-list-of-parameters >
```
模板声明一般格式.  

强调几点: 
1. 模板参数列表使用的是angle brackets.  
2. C++关键字`typename`用于*类型参数(type parameter)*的类型.    
3. 代码中出现的`T`, 代表该函数被调用时使用作为类似实际参数(后面提到的所有模板调用中的实参均表示同等地位的模板参数)的类型.  
4. `T`类型必须要支持`operator<`.
5. 并且`T`类型还需要支持拷贝构造.  
6. 老标准用的是`class`关键字, `typename`是进化版本. 原因没有多复杂, 仅仅是`class`这个词容易产生误解而已, 因为任何类型都可以作为`class`类型的实参.  

`basics/max1.cpp`  
```c++
#include "max1.hpp"
#include <iostream>
#include <string>
int main()
{
    int i = 42;
    std::cout << "max(7,i): " << ::max(7,i) << '\n';
    double f1 = 3.4; double f2 = -6.7;
    std::cout << "max(f1,f2): " << ::max(f1,f2) << '\n';
    std::string s1 = "mathematics";
    std::string s2 = "math";
    std::cout << "max(s1,s2): " << ::max(s1,s2) << '\n';
}
```
`Outputs:`  
```
max(7,i): 42
max(f1,f2): 3.4
max(s1,s2): mathematics
```

**不要轻易using名称空间中的内容!** 这里的max函数就面临这样一个问题 -- max在iostream的std名称空间下有**相同签名**的定义.  

C++编译器会自动为不同类型模板调用生成不同套的代码, 比如上面的int型数据传进去就会*自动生成*:  
```c++
int max (int a, int b)
{
    return b < a ? a : b;
}
```   
这里的*自动生成*被叫做**实例化(instantiation)**, 没错, 就跟类实例化那个一个名字, 所以习惯还是叫*模板实例化*. 这样一段生成代码, 同样, 被叫做模板的**实例(instance)**. 

每次对函数模板的使用会自动触发这样的实例化过程.  

注意, `void`也是一个合法的模板参数, for example:  
```c++
template<typename T>
T foo(T*)
{
}

void* vp = nullptr;
foo(vp);  // OK: deduces void
foo(void*)
```

### Two-Phase Translation 二相翻译, 双阶段翻译
模板实例化代码的编译是有一个尝试过程的. 整个模板实例化"编译"过程分为两个阶段:  
1. 在*definition time*不进行实例化. 模板代码需要先忽略模板参数先检查自身的的错误, 比如: 少了个逗号分号之类的语法错误\用了没有声明的标识符\静态断言断炸了.  
2. 在*instantiation time*进行实例化. 把模板参数的类型代入代码再次检查所有的错误.  

for example:  
```c++
template<typename T>
void foo(T t)
{
    undeclared();  // 第一阶段炸
    undeclared(t);  // 第二阶段炸
    static_assert(sizeof(int) > 10, "int too small");  // 第一阶段炸, 因为好像还没有哪个编译器int型size会超过10的
    static_assert(sizeof(T) > 10, "T too small");  // 第二阶段可能会炸, 这要看T类型有多大了
}
```
很后面还会有一个叫*two-phase lookup*的东西, 所以不急.  

### Compiling and Linking 编译和链接  
后面好像还有专门讲的, 这里只强调一点:  
**带模板函数的定义和声明都放在头文件里, 写在一起, 分文件写会报链接错误.**

### Template Argument Deduction 模板参数推导
这玩意编译器写得很智能, 不用考虑那么多的. 比如:  
```c++
template<typename T>
T max (T const& a, T const& b)
{
    return b < a ? a : b;
}
```
传`int`变量进去, `T`会自动推导成`int`, 因为传进去的实参类型能与`int const&`匹配.  

*自动类型转换*在类型推导时被**严格限制**了:  
- 调用函数时, 参数使用引用传递, 任何自动类型转换都不能正常进行. 简单说就是所有的`T`类型必须要全部精准的一模一样才能正常推导.   
- 调用函数时, 参数使用值传递, 类型会在*消去限制类类型修饰符(decay)*后检查匹配. 这个单词是我乱翻译的, 解释一下就是: const或volatile被忽略\引用转换为被引用的类型, 比如int&转换为int\原生数组或者函数转换位对应的指针类型. 简而言之就是所有的`T`在*decay*之后类型要一模一样才能正常推导.  

比如:  
```c++
template<typename T>
T max (T a, T b);
...
int const c = 42;
max(i, c);  // OK: T is deduced as int
max(c, c);  // OK: T is deduced as int
int& ir = i;
max(i, ir);  // OK: T is deduced as int
int arr[4];
foo(&i, arr);  // OK: T is deduced as int*
```
又比如反例:  
```c++
max(4, 7.2);   // ERROR: T can be deduced as int or double
std::string s;
foo("hello", s);  //ERROR: T can be deduced as char const[6] or std::string
```

好了, 解决刚才第一个ERROR的方法有三种, 简单说明一下:  
1. 手动加个转换:  
```c++
max(static_cast<double>(4), 7.2);
```  
2. 别让编译器自动推导:  
```c++
max<double>(4, 7.2);
```
3. 在写max的时候弄两个模板参数. 参考下面的"多模板参数"节.  

关于默认参数的问题, 需要提一下:  
```c++
template<typename T>
void f(T = "");
...
f();
```
上面这种留默认参数的方式是推导不出`T`的类型的, 需要手动指定:  
```c++
template<typename T = std::string>
void f(T = "");
...
f();
```

### Multiple Template Parameters 多模板参数
直接上代码.  
```c++
template<typename T1, typename T2>
T1 max (T1 a, T2 b)
{
    return b < a ? a : b;
}
...
auto m = ::max(4, 7.2);
```
这里的`auto`会被推导成`T1`的那个类型, `T1`在模板实例化被推导成实参`a`的类型, 实参`a`是字面值`4`, 所以类型自然是`const int`, 在根据刚才的那个自动类型推导的方案, `T1`会被推导成`int`型, 所以`m`会是`int`型的.  

但是仔细想一想还是挺糟糕的, 因为`T1`和`T2`在编译期之前并不会知道谁是谁的上位类型, 甚至这两个类型都不能进行单向转换. 于是这里需要采取一些策略解决返回值类型的问题.  

#### Template Parameters for Return Types 用模板参数作为返回值类型
```c++
template<typename T1, typename T2, typename RT>
RT max (T1 a, T2 b);
...
::max<int, double, double>(4, 7.2);
```
手动指定`RT`返回值类型, 或者, 可以让编译器推导部分它可以推导的类型:  
```c++
template<typename RT, typename T1, typename T2>
RT max (T1 a, T2 b);
...
::max<double>(4, 7.2);
```
#### Deducing the Return Type 推导返回值类型
这块真的出现了很多的推导, 这个节标题中的推导是`auto`关键字的类型推导.  
```c++
template<typename T1, typename T2>
auto max (T1 a, T2 b)
{
    return b < a ? a : b;
}
```
`auto`关键字作为函数返回值直接写在函数名前面的这种, 是C++14的特性. 之后我会渐渐弱化"某某是C++1x标准的特性"的概念, 反正我们都是直接`-std=c++2a`, 目的是为了研究C++的高阶用法, **而不是**研究某一个版本的标准. 
C++11的版本写起来要复杂一点点, 因为11时代还不支持函数从`return`语句中直接推导返回值类型, 需要一个*后置返回值类型侦测*(这东西原文叫做*a corresponding trailing return
type (which would be introduced with a -> at the end)*)

```c++
// C++11
template<typename T1, typename T2>
auto max (T1 a, T2 b) -> decltype(b<a?a:b)
{
    return b < a ? a : b;
}
```