---
layout: post
title: C++ Templates 阅读记录 Part I. The Basics 
categories: cpp
description: C++ Templates. The Complete Guide Note - Part I. The Basics
tags: [C++]
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

## Part I. The Basics 基础知识  
本部分主要介绍一些模板基础.  

## Chapter 1 - Function Templates 函数模板
### Defining and Using 声明和使用
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
**函数模板的定义和声明都放在头文件里, 写在一起, 分文件写会报链接错误.**

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

但是, *自动类型转换*在类型推导时被**严格限制**了:  
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
这里其实可以采取简化的写法, 把`b<a`改称`true`也还是可以推导出`a`和`b`的上位类型. 

但是在有些情况下, `T`必须是引用类型, 这时的返回值可能需要一些细微的调整:  
```c++
#include <type_traits>
template<typename T1, typename T2>
auto max (T1 a, T2 b) -> typename std::decay<decltype(true?
a:b)>::type
{
    return b < a ? a : b;
}
```
`std::decay`是`type_traits`中提供的使用C++元能力编写出来的"结构体", 当然这玩意儿是结构体只是一个幌子了.  

#### Return Type as Common Type 以common_type_t类型返回
顾名思义, 直接上代码:  
```c++
#include <type_traits>
template<typename T1, typename T2>
std::common_type_t<T1,T2> max (T1 a, T2 b)
{
    return b < a ? a : b;
}
```
虽然说好不提C++1x的特性, 但是点名批评C++11. 虽然C++11算是Modern C++的一个好的开始, 但是还是有不少特性上的"bug"在后期的版本才有修复. 以上的版本只适用于C++14以后的版本, C++11的版本:  
```c++
#include <type_traits>
template<typename T1, typename T2>
typename std::common_type<T1,T2>::type max (T1 a, T2 b)
{
    return b < a ? a : b;
}
```

### Default Template Arguments 默认模板参数
刚才的有一个代码里已经出现过了的, 类似于函数的默认参数, 函数模板也可以指定模板参数的默认值.  
```c++
#include <type_traits>
template<
    typename T1, 
    typename T2, 
    typename RT = std::decay_t<decltype(true ? T1() : T2())>
>
RT max (T1 a, T2 b)
{
    return b < a ? a : b;
}
```
稍微把原书的代码按照标准文档上的标准重新排版了一下.  
代码比较简单也就不解释了. 需要注意的是, 上面的这个代码调用了`T1`和`T2`的默认构造器.  
下面再给出使用`common_type`的版本:  
```c++
#include <type_traits>
template<
    typename T1, 
    typename T2,
    typename RT = std::common_type_t<T1, T2>
>
RT max (T1 a, T2 b)
{
    return b < a ? a : b;
}
```

### Overloading Function Templates 重载函数模板
想常规的函数一样, 函数模板也支持重载, 并且C++编译器会帮助决定到底应该使用函数的哪一个版本. 但实际编译器实现这个功能的方法是非常复杂的, 这里不做讨论.  

```c++
int max (int a, int b)
{
    return b < a ? a : b;
}
template<typename T>
T max (T a, T b)
{
    return b < a ? a : b;
}
int main()
{
    ::max(7, 42);  // calls the nontemplate for two ints
    ::max(7.0, 42.0);  // calls max<double> (by argument deduction)
    ::max('a', 'b');  // calls max<char> (by argument deduction)
    ::max<>(7, 42);  // calls max<int> (by argument deduction)
    ::max<double>(7, 42);  // // calls max<double> (no argument deduction)
    ::max('a', 42.7);  // //calls the nontemplate for two ints
}
```

需要特别提出的只有两个调用, 一个是`::max<>(7, 42)`, 这个很明显, 是有意调用带模板的版本的; 一个是`::max('a', 42.7)`, 因为模板参数不支持自动类型转换, 所以调用的是`int (int, int)`的版本.  

接下来, 讨论两种推导之间的PK:  
```c++
template<typename T1, typename T2>
auto max (T1 a, T2 b)
{
    return b < a ? a : b;
}
template<typename RT, typename T1, typename T2>
RT max (T1 a, T2 b)
{
    return b < a ? a : b;
}
```
这个主要还是会根据指定的模板参数来定:  
```c++
auto a = ::max(4, 7.2);  // uses first template
auto b = ::max<long double>(7.2, 4);  // uses second template
auto c = ::max<int>(4, 7.2);  // ERROR: both function templates match
```
原文使用了我非常喜欢的一个词, ambiguity, Both templates match, which causes the overload resolution process normally to prefer none and result in an ambiguity error.

接着讨论C风格字符串和指针之间的问题.  
```c++
#include <cstring>
#include <string>

// maximum of two values of any type:
template<typename T>
T max (T a, T b)
{
    return b < a ? a : b;
}

// maximum of two pointers:
template<typename T>
T* max (T* a, T* b)
{
    return *b < *a ? a : b;
}

// maximum of two C-strings:
char const* max (char const* a, char const* b)
{
    return std::strcmp(b,a) < 0 ? a : b;
}

int main()
{
    int a = 7;
    int b = 42;
    auto m1 = ::max(a,b);  // max() for two values of type int
    std::string s1 = "hey";
    std::string s2 = "you";
    auto m2 = ::max(s1,s2);  // max() for two values of type std::string
    int* p1 = &b;
    int* p2 = &a;
    auto m3 = ::max(p1,p2); // max() for two pointers
    char const* x = "hello";
    char const* y = "world";
    auto m4 = ::max(x,y);  // max() for two C-strings
}
```
注意, 所有`max`的重载都是值传递.  
在常规情况下, 应该尽量不在不必要重载函数模板的时候做更多的更改, 简单点讲就是尽量不要用模板生产出更多的函数重载. 否则, 可能会产生一些奇怪的问题. 比如下面这种情况, 我先稍微研究一下, 等下再说:    
```c++
#include <cstring>

// maximum of two values of any type (call-by-reference)
template<typename T>
T const& max (T const& a, T const& b)
{
    return b < a ? a : b;
}

// maximum of two C-strings (call-by-value)
char const* max (char const* a, char const* b)
{
    return std::strcmp(b,a) < 0 ? a : b;
}

// maximum of three values of any type (call-by-reference)
template<typename T>
T const& max (T const& a, T const& b, T const& c)
{
    return max (max(a,b), c); // error if max(a,b) uses call-by-value
}

int main ()
{
    auto m1 = ::max(7, 42, 68);  // OK
    char const* s1 = "frederic";
    char const* s2 = "anica";
    char const* s3 = "lucas";
    auto m2 = ::max(s1, s2, s3);  //run-time ERROR
}
```
这个代码错误最恶心的地方是, 他会报一个run-time error, 而不是编译错误. 原因是, 在C风格字符串作为实参调用`max(a, b)`的时候, 创造了一个全新的临时*局部*值, 并作为引用返回, 但是显然这个引用引用的原临时变量, 会在函数返回后被销毁, 最终变成了一个*无效引用(dangling reference)*. 

其实这段话我是没怎么读懂的. 这里参考了一下由objdump解析出来的汇编代码:  
```x86asm
0000000000401159 <main>:
  401159:	55                   	push   %rbp
  40115a:	48 89 e5             	mov    %rsp,%rbp
  40115d:	48 83 ec 40          	sub    $0x40,%rsp
  401161:	c7 45 e4 44 00 00 00 	movl   $0x44,-0x1c(%rbp)
  401168:	c7 45 e8 2a 00 00 00 	movl   $0x2a,-0x18(%rbp)
  40116f:	c7 45 ec 07 00 00 00 	movl   $0x7,-0x14(%rbp)
  401176:	48 8d 55 e4          	lea    -0x1c(%rbp),%rdx
  40117a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  40117e:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
  401182:	48 89 ce             	mov    %rcx,%rsi
  401185:	48 89 c7             	mov    %rax,%rdi
  401188:	e8 42 00 00 00       	callq  4011cf <_Z3maxIiERKT_S2_S2_S2_>
  40118d:	8b 00                	mov    (%rax),%eax
  40118f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  401192:	48 c7 45 d8 10 20 40 	movq   $0x402010,-0x28(%rbp)
  401199:	00 
  40119a:	48 c7 45 d0 19 20 40 	movq   $0x402019,-0x30(%rbp)
  4011a1:	00 
  4011a2:	48 c7 45 c8 1f 20 40 	movq   $0x40201f,-0x38(%rbp)
  4011a9:	00 
  4011aa:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  4011ae:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  4011b2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  4011b6:	48 89 ce             	mov    %rcx,%rsi
  4011b9:	48 89 c7             	mov    %rax,%rdi
  4011bc:	e8 49 00 00 00       	callq  40120a <_Z3maxIPKcERKT_S4_S4_S4_>
  4011c1:	48 8b 00             	mov    (%rax),%rax
  4011c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  4011c8:	b8 00 00 00 00       	mov    $0x0,%eax
  4011cd:	c9                   	leaveq 
  4011ce:	c3                   	retq

000000000040120a <_Z3maxIPKcERKT_S4_S4_S4_>:
  40120a:	55                   	push   %rbp
  40120b:	48 89 e5             	mov    %rsp,%rbp
  40120e:	53                   	push   %rbx
  40120f:	48 83 ec 38          	sub    $0x38,%rsp
  401213:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  401217:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  40121b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  40121f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  401223:	48 8b 18             	mov    (%rax),%rbx
  401226:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  40122a:	48 8b 10             	mov    (%rax),%rdx
  40122d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  401231:	48 8b 00             	mov    (%rax),%rax
  401234:	48 89 d6             	mov    %rdx,%rsi
  401237:	48 89 c7             	mov    %rax,%rdi
  40123a:	e8 e7 fe ff ff       	callq  401126 <_Z3maxPKcS0_>
  40123f:	48 89 de             	mov    %rbx,%rsi
  401242:	48 89 c7             	mov    %rax,%rdi
  401245:	e8 dc fe ff ff       	callq  401126 <_Z3maxPKcS0_>
  40124a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  40124e:	b8 00 00 00 00       	mov    $0x0,%eax
  401253:	48 83 c4 38          	add    $0x38,%rsp
  401257:	5b                   	pop    %rbx
  401258:	5d                   	pop    %rbp
  401259:	c3                   	retq
```
拷贝的有点多, 主要是不知道要怎么裁减. 主要盯着callq指令调用地址后面的tag就行了.  

主函数第二次callq的函数是`_Z3maxIPKcERKT_S4_S4_S4_`, 这很正常, 区别是`S2`的`int`型, 但是从这里并无法确定`S4`究竟是什么类型. 进入`_Z3maxIPKcERKT_S4_S4_S4_`的代码, 函数两次调用了`_Z3maxPKcS0_`, 这个函数没有尾缀, 所以一定是上面没有模板的`max`函数. 这样之前的困惑就得到了解决, `S4`应该是`char const*`型的. 

这个需要考虑到编译器的机制了. 站在写代码人的角度考虑, 刚才说过:  
> 在常规情况下, 应该尽量不在不必要重载函数模板的时候做更多的更改, 简单点讲就是尽量不要用模板生产出更多的函数重载. 否则, 可能会产生一些奇怪的问题  

所以编译器也定然会符合这个要求做事 -- 如果能找到现成的函数签名能符合要求, 就不再通过模板去再生成一套代码, 毕竟为了防止冲突嘛. 主函数中的C风格字符串是`char const*`型的, 首先编译器会生成一套`T`为`char const*`的三参数`max`函数代码. 并且以引用的方式将主函数中的三个字符型指针传到了这个`max`里. 但是在三参数`max`调用二参数`max`的时候使用的是`char const*`版本, 它的返回值也是`char const*`. 而三参数`max`将`max (max(a,b), c)`调用之后临时生成的局部变量引用返回了, 但实际这个临时变量在三参数`max`返回之后就已经销毁了, 所以, dangling reference出现在这里.  

为什么整型调用的时候没有出现这种情况? 那是因为`int`型的三参数`max`调用的是模板实例化出来的二参数`max`, 全程使用引用, 所以不存在这样的问题.  

其实把`char const*`参数版本的`max`的定义给删掉, 这个代码就可以正常运行了. 或者将参数类型改成`char const* const&`.  

下面这个代码, 涉及一种特殊情况:   
```c++
#include <iostream>

// maximum of two values of any type:
template<typename T>
T max (T a, T b)
{
    std::cout << "max<T>() \n";
    return b < a ? a : b;
}

// maximum of three values of any type:
template<typename T>
T max (T a, T b, T c)
{
    return max (max(a,b), c);  // uses the template version even for ints
}  // because the following declaration comes
   // too late:

// maximum of two int values:
int max (int a, int b)
{
    std::cout << "max(int,int) \n";
    return b < a ? a : b;
}
int main()
{
    ::max(47,11,33);  // OOPS: uses max<T>() instead of max(int,int)
}
```

这里为什么会调用模板的版本, 因为对于三参数`max`来说, 模板版本的二参数`max`在其之前被声明, 而非模板版本的`max`在其之后被声明, 所以没有可见性.  

### But, Shouldn't We ...? 但是, 什么是禁止做的?   
#### Pass by Value or by Reference? 值传递还是引用传递?  
这个问题上面遇到了. 直接给出答案就是更多的时候使用值传递. 但是很奇怪, 之前看过的书上或者人们推崇的不都是引用+`const`修饰来传递除简单类型(比如fundamental types或者`std::string_view`)外的其他类型吗? 为什么这里又建议用值传递了? 书中给出了值传递的好处:  
- The syntax is simple.  
- 语法简单.  
- Compilers optimize better.  
- 编译器更容易优化.   
- Move semantics often makes copies cheap.  
- 移动语义更容易作用于拷贝传递.  
- And sometimes there is no copy or move at all.
- 有时根本不会有拷贝和移动. 这句没怎么懂.  
另外, 加上模板后:  
- A template might be used for both simple and complex types, so choosing the approach for complex types might be counter-productive for simple types.
- 模板参数可以接收简单类型和复杂类型, 如果一味地使用对专门对复杂类型考虑的优化操作, 有可能会对简单类型产生适得其反的效果.  
- As a caller you can often still decide to pass arguments by reference, using std::ref() and std::cref() (see Section 7.3 on page 112).
- functional中提供了可供调用者决定使用的`std::ref()`和`std::cref()`进行强制引用.  
- Although passing string literals or raw arrays always can become a problem, passing them by reference often is considered to become the bigger problem. All this will be discussed in detail in Chapter 7. For the moment inside the book we will usually pass arguments by value unless some functionality is only possible when using references.
- 字符串字面值和原生数组可能会在引用时遇到更大的麻烦. 更多的内容会在后面讨论.  

#### Why Not inline? 内联函数
不知道原文在说啥, 也从来不用`inline`, 懒得看了.  

#### Why Not constexpr? `constexpr`函数  
编译期函数嘛, 学过C++的都知道. 上代码:   
```c++
template<typename T1, typename T2>
constexpr auto max (T1 a, T2 b)
{
    return b < a ? a : b;
}
```
然后就可以  
```c++
int a[::max(sizeof(char),1000u)];
std::array<std::string, ::max(sizeof(char),1000u)> arr;
```
了, 用法没什么特别的地方. 但是要注意一定要传`unsigned`型的字面值, 不然比较大小的时候会有警告.  

### 章总结
- 函数模板能为不同模板参数生成一个家族或者说是一个系列的函数.  
- 你传实际参数进用模板参数类型的参数时, 大多情况下编译期会自动推导模板参数.  
- 可以指定leading的模板参数.   
    举个例子就是`template<typename RT, typename T1, typename T2>`, 之前的这个`RT`就是所谓的leading. 
- 可以指定默认模板参数.  
- 可以重载函数模板.  
- 在手动重载函数模板之前, 确保重载出来的函数签名没有用过, 或者是产生冲突之类的.  
- 尽量少的重载函数模板, 主要也就是防止冲突.  
- 确保调用某个函数时编译器对所有函数重载版本的可见性.  


## Chapter 2 - Class Templates 类模板  
### Implementation of Class Template Stack 类模板栈的实现
```c++
#include <vector>
#include <cassert>

template<typename T>
class Stack {
  private:
    std::vector<T> elems;
  public:
    void push(T const& elem);
    void pop();
    T const& top() const;
    bool empty() const {
        return elems.empty();
    }
};

template<typename T>
void Stack<T>::push (T const& elem)
{
    elems.push_back(elem);
}

template<typename T>
void Stack<T>::pop ()
{
    assert(!elems.empty());
    elems.pop_back();
}

template<typename T>
T const& Stack<T>::top () const
{
    assert(!elems.empty());
    return elems.back();
}
```

这个类模板内部调用了C++标准库的vector<>类模板. 所以在做它的实现的时候不用考虑内存管理, 拷贝构造器, 赋值运算符这些东西.  

#### Declaration of Class Templates 类模板的声明
声明类模板和函数模板基本一致:  
```c++
template<typename T>
class Stack {
    ...
};
```
同样的, 这里的`typename`也可以用`class`替代.  

同函数模板一样, 在把类模板用作声明的时候需要指定模板参数, 除非模板参数通过某种途径能够被编译器自动推导. 

但是在类的定义中使用自己的类名时不需要指定模板参数, 不指定时就表示他自己, 用Java的话说就是`this.class`:  
```c++
template<typename T>
class Stack {
    ...
    Stack (Stack const&);
    Stack& operator= (Stack const&);
    ...
};
```
等价于:   
```c++
template<typename T>
class Stack {
    Stack (Stack<T> const&);
    Stack<T>& operator= (Stack<T> const&);
    ...
};
```
但是在类外的成员方法定义中出现的类名需要指定模板参数:  
```c++
template<typename T>
bool operator== (Stack<T> const& lhs, Stack<T> const& rhs);
```

注意: 不同于非模板类, 类模板不能在函数或代码块中声明. 通常情况下, 模板只能在全局或者名称空间scope中, 以及类中声明.   

#### Implementation of Member Functions 成员函数的实现
上面的代码中, 类中的`push`函数的实现没有什么特别需要说明的地方.   
但是需要说明的是, 为什么`vector<>::pop_back()`没有返回移除的那个最后的元素. 这样可以保证*异常安全性(exception safety)*, 你不可能保证返回移除元素版本的`pop()`是完备的异常安全的. *比如说移除的元素不能被拷贝?* 如果忽略这样的风险, 就可以实现下面的版本了:  
```c++
template<typename T>
T Stack<T>::pop ()
{
    assert(!elems.empty());
    T elem = elems.back();
    elems.pop_back();
    return elem;
}
```

`top`函数也没什么需要特别说明的地方.  

`empty`函数的定义时写在类内的, 所以默认内联.  

### Use of Class Template Stack 类模板栈的使用
看原文中介绍好像说C++17才开始支持类模板参数的推导的, 但是正常情况写C++17的时候其实很少, 习惯上还是保留了类模板参数的手动指定.  

代码部分学过C++的都会写, 不贴了.  

注意, 只有被调用了的类模板的成员函数(其实按照代码来看它们也都是函数模板)才会被实例化.  

下面的行为都是被允许的:  
```c++
void foo(Stack <int> const& s)
{
    using IntStack = Stack<int>;
    Stack<int> istack[10];
    IntStack istack2[10];

    Stack<float*> floatPtrStack;

    Stack<Stack<int>> intStackStack;
}
```
从上面的代码可以看到, 类模板类型可以alias, 支持类型闭包.  

### Partial Usage of Class Templates 类模板的部分用法
模板参数**必须**提供所有需要的操作符支持.  

#### Concepts
刚才说了模板参数必须要提供所有需要的支持, 这个该如何办到呢? C++17正式引入了新的语义*概念(concept)*, 来提供在**标准库中**模板实例化时的一些限制.  
但是很可惜的是, C++17使用concepts或多或少只是出现在标准文档或者注释中, 真正引入是C++20. C++20正式引入*concept*成为了C++语法的一个部分. 目前不论是20的range, 还是concepts, 这方面的资料比较少, 或者说我没有特别去关注这个, 所以代码暂时还不知道应该怎么去写.  

但是别忘了, 早在C++11, Modern C++问世的时候, C++的元能力被完全开发, 标准库中加入了**type_traits**, 提供给我们的一些元函数可以帮助我们解决这个问题:  
```c++
template<typename T>
class C
{
    static_assert(std::is_default_constructible<T>::value, "Class C requires default-constructible elements");
    ...
};
```
*traits*这本书的后面肯定会讨论的, 猜都不用猜.  

本书的Appendix E部分(也是本篇的Appendix E部分, 放在最后了)给出了C++20的concepts的代码实现, 这里将会尝试在加了`-std=c++2a`的g++中复现下面的代码.  

### Friends 友元





## Appendix E - Concepts
非常幸运的是, 标准委员会在这本书出版之前, 为C++20草案提出了一个新的内容 -- **concepts**. 如今我才有幸能在这本书的附录看到关于C++20 concepts的相关代码. 虽然可能和最终版有所偏差, 但是我会在C++2a标准下尽量进行所有尝试. 目前的gcc版本是`gcc (GCC) 9.2.1 20190827 (Red Hat 9.2.1-1)`.  

### Using Concepts 使用*概念*
#### Dealing with Requirements 处理*要求*
首先, 通过修复前面Chapter 1中的`max`函数模板的漏洞的代码, 先熟悉一下concepts的相关语法.  
```c++
template<typename T> requires LessThanComparable<T>
    T max(T a, T b) {
    return b < a ? a : b;
}
```
稍微找了一下markdown的配置代码, Java, Python的高亮关键字都看到了, 就是没见到C++的. 所以, requires已经是关键字了, 只是这里显示不出来.   

这第一个代码暂时还没法跑起来. [`LessThanComparable`](https://en.cppreference.com/w/cpp/named_req/LessThanComparable)是一个叫做[*named requirements*](https://en.cppreference.com/w/cpp/named_req)的东西, 不是某个头文件里面定义的, 2a暂时还没有这玩意儿. 但是稍后在下一节会给出如何作为concept来手动定义它.     

`LessThanComparable<T>`是一个*布尔谓词(Boolean predicate)*, 简单说就是他能够产生一个布尔值. 这个布尔谓词通过一个常量表达式进行评估(应该是类似traits的东西), 并且最重要的是, 同静态断言, 这个评估会在编译期进行, 会在编译期给予程序*约束(constraint)*.   
当我们尝试使用这个模板时, 在二相翻译的第一阶段结束之后, 第二阶段之前会优先进行**requires语句(requires clause)**的评估, 并且需要其产生一个`true`值, 第二阶段翻译才能开始; 反之, 如果它产生了一个`false`值, 编译期会发出错误并指出是哪一个**要求(requirement)**部分失败.  

`require`语句不一定需要通过*概念(concepts)*进行表示, 任何一个布尔常量表达式都可以使用, 甚至可以使用`true`. 所以接下来的这个代码将可以运行:  
```c++
class Person
{
  private:
    std::string name;
  public:
    template<typename STR>
      requires std::is_convertible_v<STR, std::string>
    explicit Person(STR&& n)
     : name(std::forward<STR>(n)) {
        std::cout << "TMPL-CONSTR for ’" << name << "’\n";
    }
    ...
};
```
这里面涉及一些比较复杂的东西, 比如*traits*, *完美转发(perfect forwarding)*, 这些是正文需要讨论的东西, 这里不做讨论.   
[`std::is_convertible_v<>`](https://en.cppreference.com/w/cpp/types/is_convertible)来自traits, 原来的版本是`std::is_convertible<>::value`, 学习过C++17特性的都知道, `_v`和`_t`这种尾缀是C++17搞出来的traits的新特性, 比以前更方便使用: 
```c++
template<class From, class To>
inline constexpr bool is_convertible_v = is_convertible<From, To>::value;
```
就不用多说了, 判断类型转换是否可行的traits.

上面的代码, 加上头文件进行细微修改之后的版本是:  
```c++
#include <type_traits>
#include <string>
#include <iostream>

class Person
{
  private:
    std::string name;
  public:
    template<typename STR>
      requires std::is_convertible_v<STR, std::string>
    explicit Person(STR&& n)
     : name(std::forward<STR>(n)) {
        std::cout << "TMPL-CONSTR for ’" << name << "’\n";
    }
};
```
使用`g++ -fconcepts -std=c++2a -c ./concepts_demo.cpp`进行编译, 可得目标文件.  

#### Dealing with Multiple Requirements 处理多*要求*
上代码:  
```c++
template<typename Seq>
  requires Sequence<Seq> &&
           EqualityComparable<typename Seq::value_type>
typename Seq::iterator find(Seq const& seq,
                            typename Seq::value_type const& val)
{
    return std::find(seq.begin(), seq.end(), val);
}
```
这里使用的两个named requirement, 第一个`Sequence`, cppreference上提供的名称是[`SequenceContainer`](https://en.cppreference.com/w/cpp/named_req/SequenceContainer), 用来约束模板参数为线性容器; 第二个[`EqualityComparable`](https://en.cppreference.com/w/cpp/named_req/EqualityComparable), 用来约束模板参数可以进行*等价比较*(瞎编的, 其实就是支不支持`operator==`).   

然后衔接这两个requirement的是非常熟悉的`&&`逻辑且运算符. 同样的, 如果想表达'alternative'的意思, 可以使用`||`逻辑或运算符. 但是不推荐使用或, 这可能会潜在地增加编译器负担.  

在有些情况下, 用concept是非常爽的:  
```c++
template<typename T>
  requires Integral<T> ||
           FloatingPoint<T>
T power(T b, T p);
```
这样子使用requirement非常繁琐.  
```c++
template<typename T, typename U>
  requires SomeConcept<T, U>
auto f(T x, U y) -> decltype(x+y)
```
使用了用户定义的concept之后, 类似的操作变得简单了.  

#### Shorthand Notation for Single Requirements 单个*要求*的简写
在模板参数列表后面再加上一串requires clause会让代码显得头重脚轻, 于是C++提供了一种缩写的方式, 不知道这能不能算语法糖?  
```c++
// Original 
template<typename T>
  requires LessThanComparable<T>
T max(T a, T b) {
    return b < a ? a : b;
}

// Shorthand Notation
template<LessThanComparable T>
T max(T a, T b) {
    return b < a ? a : b;
}
```
又比如刚才上面那个代码:  
```c++
// Original 
template<typename Seq>
  requires Sequence<Seq> &&
           EqualityComparable<typename Seq::value_type>
typename Seq::iterator find(Seq const& seq,
                            typename Seq::value_type const& val)
{
    return std::find(seq.begin(), seq.end(), val);
}

// Shorthand Notation 
template<Sequence Seq>
  requires EqualityComparable<typename Seq::value_type>
typename Seq::iterator find(Seq const& seq,
                            typename Seq::value_type const& val)
{
    return std::find(seq.begin(), seq.end(), val);
}
```
这样就看起来舒服多了.   
这样定义的模板被叫做*约束模板(constrained template)*.  

### Defining Concepts 定义*概念*
概念的定义更像布尔型`constexpr`变量模板, 但是没有明确指出变量类型:  
```c++
template<typename T>
concept MyConcept = ... ;
```
比如刚才的`LessThanComparable`, 我们的自主定义是:  
```c++
template<typename T>
concept LessThanComparable = requires(T x, T y) {
    { x < y } -> bool;
};
```
这里有一些非常有意思的东西, 颠覆了以往的C++的概念. 
1. requires后面圆括号里看起来像参数列表的东西, 是彻彻底地的**虚构变量(dummy variables)**, 这些看上去是参数的虚假变量, 不会在任何时候有一个实参传进来作为形参被调用, 而只是用来辅助定义概念.  
2. 这段`{ x < y } -> bool;`看起来像返回值的又像Lambda的玩意儿, 其实也仅仅是用来描述概念的. 这个*语法(syntax, 原文这里没有把叫做"语句")*有两个含义: 表达式`x < y`必须合法, 意思就是`T`类型必须支持`operator<`; 这个表达式必须要支持转换成`bool`类型(注意不一定是要`bool`类型值).   

在这个`->`之前可以插入一个关键字`noexcept`, 表示括号内的表达式不会抛出异常.  

这里如果不加`-> type`, 也可以交给编译期自动推导:  
```c++
template<typename T>
concept Swappable = requires(T x, T y) {
    swap(x, y);
};
```

requires表达式还支持表示相关类型, 比如`T`类型如果作为一个线性容器内部包含的`elem_type`或者`iterator`之类的, 但是注意, 这玩意儿也需要定义:  
```c++
template<typename Seq>
concept Sequence = requires(Seq seq) {
    typename Seq::iterator;
    { seq.begin() } -> Seq::iterator;
    ...
};
```
但是这里又要考虑一个隐患, 假设这个`Seq`没有迭代器怎么办? 这时可以使用嵌套的requires:  
```c++
template<typename Seq>
concept Sequence = requires(Seq seq) {
    typename Seq::iterator;
    requires Iterator<typename Seq::iterator>;
    { seq.begin() } -> Seq::iterator;
    ...
};
```
`Iterator`可以作为concept再单独定义嘛.  
这种嵌套的requires被叫做**嵌套要求(nested requirement)**.

### Overloading on Constraints 模板约束重载 
我们先看下面的两个函数模板声明:  
```c++
template<IntegerLike T> void print(T val);
template<StringLike T> void print(T val);
```
这两个声明虽然使用了相同的模板, 但是*约束*也是模板签名的一部分, 并且能在重载时被成功识别.   
但是需要保证在使用重载时, 只有一个签名的约束符合要求. 比如有这么两个字面值`"6"_NS`和`"7"_NS`, 它们可以像整数一样做运算, 比如乘法等于`"42"_NS`, 并且能像字符串一样使用. 这样的字面值类型同时匹配`IntegerLike`和`StringLike`, 自然会产生歧义. 但是对于这些歧义, 编译器有一些解决手段.   

#### Constraint Subsumption 约束涵摄
上面的例子中已经说过了约束重载的问题. 虽然可能会有写一些类型会对多个约束概念同时匹配, 但是我们还是要尽力想办法减少这样的冲突出现.  

所以, subsumption这个词是什么意思? 就是给我中文"涵摄"我也不会知道他的意思, 这里先参看了一下百度百科, 再想办法从原文中理解这个词的含义.  
> **涵摄**这样的过程通常由许多复杂的思维步骤组成。是法律规定与事实之间的对应关系，任何一个法律行为或事件都要对应相应的法律规定。  
> 法律适用的涵摄：即将具体的案例事实（Sachverhalt=S），置于法律规范的要件(Tatbestand=T)之下,以获得一定结论（R）的一种思维过程。易言之，即认定某特定事实是否该当于法律规范的要件，而发生一定的权利义务关系。  

经过一定的理解后, 可以把"涵摄"直接理解成*条件的包含*, 具体化到C++应该叫*概念的包含*.  

有些时候可能需要提供一系列类似的概念, 这些概念之间存在涵摄关系. 比如标准库的迭代器分类: input iterator, forward iterator, bidirectional iterator, randomaccess iterator等等, 以及C++17提供的contiguous iterator(邻接迭代器, 这个我是真的没见过).    

假设我们有一个关于`ForwardIterator`的定义:  
```c++
template<typename T>
concept ForwardIterator = ...;
```

那么我们就可以直接基于`ForwardIterator`定义一个更加精致(原文是more refined)概念`BidirectionalIterator`:  
```c++
template<typename T>
concept BidirectionalIterator =
    ForwardIterator<T> &&
    requires (T it) {
        { --it } -> T&
    };
```
这样我们基于forward iterators提供的机能, 又添加了前缀自减运算符的机能, 创造了对bidirectional iterators的概念.   

接着考虑实现`std::advance()`算法, 使用约束模板对forward iterators和bidirectional iterators进行重载.  
```c++
template<ForwardIterator T, typename D>
void advanceIter(T& it, D n)
{
    assert(n >= 0);
    for (; n != 0; --n) { ++it; }
}
template<BidirectionalIterator T, typename D>
void advanceIter(T& it, D n)
{
    if (n > 0) {
        for (; n != 0; --n) { ++it; }
    } else if (n < 0) {
        for (; n != 0; ++n) { --it; }
    }
}
```

很显然, 传一个`ForwardIterator`作为`advanceIter`的模板参数, 会被第一个模板选择, 因为只有第一个模板符合要求. 但是如果传一个`BidirectionalIterator`作为模板参数, 上面的两个模板都匹配. 这时编译器会选择*更精确*概念. 因为前面说过, `BidirectionalIterator`涵摄`ForwardIterator`, 前者比后者*更精确*, 所以编译器针对`BidirectionalIterator`会选择第二个模板进行实例化.  

#### Constraints and Tag Dispatching 约束和标签调度
标签调度暂时没有看到, 先留着.  

### Concept Tips 小提示
最后, 也是这本书的最最后, 他们希望在未来的版本中能提供更多实用的关于如何设计*约束模板库*的教程. 本人在此感谢作者们的辛勤付出.  

接着提供三个观察(observation).  

#### Testing Concepts 测试概念
之前说过概念其实就是布尔谓词, 他们其实就是合法的布尔常量表达式, 于是我们可以直接对概念使用静态断言.  
```c++
static_assert(C<T1, T2, ...>, "Model failure");
```
书中建议使用这种方法测试概念对简单类型的设计. 包括推向概念意味着什么的边界的类型, 回答类似下面的问题:   
- Do interfaces and/or algorithms need to copy and/or move objects of the types being modeled?  
- 接口和/或算法需要*被仿造类型*复制和/或移动的对象吗?  
- What conversions are acceptable? Which ones are needed?
- 什么样的类型转换是许可的? 而其中又有哪些是需要的? 
- Is the basic set of operations assumed by the template unique? For example, can it operate using either *= or * and =?
- 特定模板是否能使用基础运算集合? 比如, 它是否支持`*=`或者`*`和`=`?

#### Concept Granularity 概念粒度
从这里开始, 英语水平实在优先, 看不懂, 先告辞了.  