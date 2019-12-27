---
layout: post
title: Effective C++ 中文第三版阅读笔记
categories: cpp
description: effcpp笔记, 2020年的敲门砖
keywords: cpp
---

开一个新坑, 这个坑比较短, 应该寒假之前就能解决, 算作是2020年的开年作了.

## 1. 让自己习惯C++ - Accustoming Yourself to C++
### 条款 01: 视C++为一个语言联邦 - View C++ as a federation of languages.
- C++如今已经是一个多重范型编程语言(multiparadigm programming language), 同时支持过程形式(procedural), 面向对象形式(object-oriented), 函数形式(functional), 泛型形式(generic), 元编程形式(metaprogramming).  
- 语言由次语言(sublanguage)组成, C++由四个次语言组成: C, Object-Oriented C++, Template C++, STL.  

### 条款02: 尽量以const, enum, inline替换#define - Prefer consts, enums, and inlines to #defines.
```cpp
#define ASPECT_RATIO 1.653
```
- `ASPECT_RATIO`在编译器开始处理源码之前就被预处理器移走了, 这些符号可能不会出现在符号表(symbol table)内. 追踪相关的错误非常困难.  
- 多次使用`ASPECT_RATIO`会导致目标码(object code)出现多份1.653, 改用常量不会出现这种情况.  

```cpp
const char* const authorName = "Scott Meyers";
const std::string authorName("Scott Meyers");
```
- 使用上面的方式声明字符串常量

- 宏没有域(scope)的限制, 而常量有.   

```cpp
class GamePlayer {
private:
    static const int NumTurns = 5;   // 常量声明式
    int scores[NumTurns];
};

const int GamePlayer::NumTurns;      // 常量定义式
```
- 现代编译器不强求在实现文件中给出常量定义式.  
- 如果要对`NumTurns`取地址或因某些不正确的原因编译器坚持要看到定义式时, 就必须提供定义式.  
- 常量的初值设置可以放在声明式抑或定义式.  


```cpp
class GamePlayer {
private:
    enum { NumTurns = 5 };     // 被称作 enum hack
                               // 令NumTurns成为5的一个记号名称
    int scores[NumTurns];
};
```
- 使用enum hack的优点像#defines, 首先取地址不合法, 其次是不可能获得其引用和指针. 
- 一个不够优秀的编译器可能会为常量分配空间, 此时常量就可能被获取引用或指针. 使用enum hack可以完全避免.  

```cpp
#define CALL_WITH_MAX(a, b) f((a) > (b) ? (a) : (b))
int a = 5, b = 0;
CALL_WITH_MAX(++a, b);
CALL_WITH_MAX(++a, b + 10);

template<typename T>
inline void callWithMax(const T& a, const T& b) {
    f(a > b ? a : b);
}
```
- 宏不会招致函数调用带来的额外开销.  
- 类函数宏是不安全的. 在调用`f`之前, `a`的递增次数竟然取决于与谁比较.   从斯特

总结:
- 对于单纯变量, 最好以`const`对象或enums替换`#define`. 
- 对于形似函数的宏(macros), 最好改用inline函数替换`#define`. 

### 条款03. 尽可能使用const - Use const whenever possible. 
```cpp
char greeting[] = "hello";
char* p = greeting;              // non-const pointer, non-const data
const char* p = greeting;        // non-const pointer, const data
char* const p = greeting;        // const pointer, non-const data
const char* const p = greeting;  // const pointer, const data
```
- 见注释  

```cpp
std::vector<int> vec;
...
const std::vector<int>::iterator iter =    // 类似 T* const
    vec.begin();
*iter = 10;                                // 没问题
++iter;                                    // 错误! iter是const

std::vector<int>::const_iterator cIter =   // cIter的作用像个const T*
    vec.cbegin();
*cIter = 10;                               // 错误! *cIter是const
++cIter;                                   // 没问题
```
- STL的迭代器系统跟原生指针类似.  


```cpp
class Rational { ... };
const Rational operator* (const Rational& lhs, const Rational& rhs);
```
- 譬如`operator*`这样的函数, 返回值类型使用`const`描述可以避免出现如`if(a * b = c)`这样的暴行出现. 
- 自定义类型变量的符号重载的行为, 尽量要与内置类型保持一致.  


```cpp
class TextBlock {
public:
    ...
    const char& operator[](std::size_t position) const
    { return text[position]; }      // operator[] for const对象
    char& operator[](std::size_t position)
    { return text[position]; }      // operator[] for non-const对象
private:
    std::string text;
};

TextBlock tb("Hello");
std::cout << tb[0];                 // call non-const TextBlock::operator[]
const TextBlock ctb("Hello");
std::cout << ctb[0];                // call const TextBlock::operator[]

tb[0] = 'x';                        // No problem
ctb[0] = 'x';                       // ERROR!
```signature
- 见上面的代码和注释.
- 我在读这段的过程中陷入了一个误区, 影响const和non-const不同结果的const成员函数, 即在函数签名式(signature)后面的那个`const`.  

