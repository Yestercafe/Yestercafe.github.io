---
layout: post
title: Effective C++ 中文第三版阅读笔记
categories: cpp
description: effcpp笔记, 2020年的敲门砖
keywords: cpp
---

开一个新坑, 这个坑比较短, 应该寒假之前就能解决, 算作是2020年的开年作了.  
更新, 寒假前没有完成, 寒假开头赶工.   

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
- 类函数宏是不安全的. 在调用`f`之前, `a`的递增次数竟然取决于与谁比较.  

总结:
- 对于单纯变量, 最好以`const`对象或enums替换`#define`. 
- 对于形似函数的宏(macros), 最好改用inline函数替换`#define`. 

### 条款03: 尽可能使用const - Use const whenever possible. 
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
```
- 见上面的代码和注释.
- 我在读这段的过程中陷入了一个误区, 影响const和non-const不同结果的const成员函数, 即在函数签名式(signature)后面的那个`const`.  


```cpp
class CTextBlock {
public:
    ...
    std::size_t length() const;
private:
    char* pText;
    mutable std::size_t textLength;
    mutable bool lengthIsValid;
};
std::size_t CTextBlock::length() const
{
    if (!lengthIsValid) {
        textLength = std::strlen(pText);
        lengthIsValid = true;
    }
    return textLength;
}
```
- 这段介绍了两个概念bitwise constness和logical constness, 见P21. 在这里精简了没有给出代码.  
  - bitwise constness指成员函数只有在不更改对象的任何成员变量(静态成员除外)时才可以说是const. 
  - logical constness主张一个`const`成员函数可以修改它所处理的对象内的某些部分.  
- 如果需要在const成员函数中修改成员的值, 需要使用mutable关键字进行修饰.  

```cpp
class Textblcok {
public:
    ...
    const char& operator[](std::size_t position) const
    {
        ...     // 边界检测 (bounds checking)
        ...     // 志记数据访问 (log access data)
        ...     // 检验数据完整性 (verify data integrity)
        return text[postion];
    }
    char& operator[](std::size_t postion)
    {
        return 
          const_cast<char&>(
            static_cast<const TextBlock&>(*this)
                [position]
          );
    }
};
```
- 可以看出, operator[]的其中一个版本中加入了一下额外的功能. 为了防止两个版本的实现重复(可能会伴随编译时间, 维护, 代码膨胀等一系列让人头疼的问题), 这里采用的方法是 -- 用operator[]去调用另外一个operator[].  
- 这里面使用的关键性技术是类型转换那一部分, 也就是常量性移除(casting away constness). 
- const成员函数承诺绝不改变其对象的逻辑状态(logical state). 这就是本例为什么不通过const版本调用non-const的原因, 这样会导致其对象的逻辑状态改变.  
  

总结:
- 将某些东西声明为`const`可以帮助编译器侦测错误用法. `const`可被施加于任何作用域内的对象, 函数参数, 函数返回类型, 成员函数本体.  
- 编译器强制实施bitwise constness, 但你编写程序时应该使用"概念上的常量性"(conceptual constness).  
- 当`const`和non-`const`成员函数有着实质等价的实现时, 令non-`const`版本调用`const`版本可避免代码重复   


### 条款04: 确定对象被使用前已先被初始化 - Make sure that objects are initialized before they're used.  
- 读取未初始化的值是UB. 
- "对象的初始化动作何时一定发生, 何时不一定发生"的规则非常复杂. 最佳的处理方式是: 永远在使用变量之前先将它初始化. 
  - 对于无任何成员的内置类型, 必须手工完成, 不论是手工初始化, 还是使用input stream完成初始化. 
  - 内置类型外的任何其他东西, 初始化的责任落在构造函数(constructors)身上. 需确保每一个构造函数都将对象的每一个成员初始化.  

```cpp
class PhoneNumber { ... };
class ABEntry {
public:
    ABEntry(const std::string& name, const std::string& address,
            const std::list<PhoneNumber>& phones);
private:
    std::string theName;
    std::string theAddress;
    std::list<PhoneNumber> thePhones;
    int numTimesConsulted;
};

// Version 1
ABEntry::ABEntry(const std::string& name, const std::string& address,
                 const std::list<PhoneNumber>& phones)
{
    theName = name;           // 这些都是赋值(assignments)
    theAddress = address;
    thePhones = phones;
    numTimesConsulted = 0;
}

// Version 2
ABEntry::ABEntry(const std::string& name, const std::string& address,
                 const std::list<PhoneNumber>& phones)
   :theName(name),            // 这些都是初始化(initializations)
    theAddress(address),
    thePhones(phones),
    numTimesConsulted(0)
{ }
```
- 上例提供了两个版本的构造函数. 第一种并不是初始化, 而是赋值. 
- C++规定, 对象的成员变量的初始化动作发生在进入构造函数本体之前. 即, `theName`, `theAddress`, `thePhones`在进入构造函数之前就已经被调用了它们的默认构造函数. 但因为`numTimesConsulted`是内置类型, 不能保证在赋值操作之前已经获得了初值.  
- 第二个版本的写法是member initialzation list(成员初值列). 相较于第一个版本的, 第二个版本直接调用了`theName`, `theAddress`, `thePhones`的拷贝构造函数, 而非先调用它们的默认构造函数, 再对它们进行赋值. 第一个版本的默认构造函数被浪费了.  
  
*我一直很喜欢用的使用一个private成员函数包含所有成员的赋值操作, 为(wei2)所有构造器调用的方法, 在书中被叫做"伪初始化"(pseudo-initialization), 在书中被拒绝了 -- 尽量使用成员初值列完成"真正的初始化".*

最后讨论"不同编译单元内定义的non-local static对象"的初始化次序.  
- 首先明确什么是static对象. 其寿命从被构造出来直到程序结束为止, 因此stack和heap-based对象被排除. 它包括global对象, 定义于namespace作用域内的对象, 在类内/在函数内以及在文件作用域内被声明为static对象. 
- 函数内的static对象被称为local static对象. 其他都都被叫做non-local static对象. 

```cpp
// 库中的
class FileSystem {
public:
    ...
    std::size_t numDisks() const;  // 众多成员函数之一
    ...
};
extern FileSystem tfs;

// 程序库用户建立的类
class Directory {
public:
    Directory( /*params*/ );
    ...
};
Directory::Directory( /*params*/ )
{
    ...
    std::size_t disks = tfs.numDisks();
    ...
}

Directory tempDir( /*params*/ );
```
- tfs必须在tempDie初始化之前被初始化. 
- 但是无法确保tfs在tempDir之前被初始化.  
- "正确的初始化次序"无法被明确定义, 甚至不值得寻找"可决定正确次序"的特殊情况.  

```cpp拒绝
{
    static FileSystem fs;
    return fs;
}

class Directory { ... };
Directory::Directory( /*params*/ )
{
    ...
    std::size_t disks = tfs().numDisks();
    ...
}
Directory& tempDir()
{
    static Directory td;
    return td;
}
```
- 这种方法非常巧妙, 直接用心去体会代码比较合适.  
- 将每个non-local static对象搬到自己的专属函内, 该对象在该函数内被声明为static, 然后将该变量的引用返回出来. 换句话说就是non-local static对象被local static对象代替. 很显然这个过程中fs被初始化了(调用了它的默认构造函数). 这是设计模式***Singleton***模式的一个常见实现手法.  
- *为了保证多线程安全, 需要在单线程启动阶段(single-threaded startup portion)手工调用所有的reference-retruning函数, 这可以消除初始化相关的"竞速形势(race conditions)".*

总结:
- 为内置型对象进行手工初始化, 因为C++不保证初始化它们.  
- 构造函数最好使用成员初值列(member initialization list), 而不要在构造函数本体内使用赋值操作(assignment). 初值列列出的成员变量, 其排列次序应该和它们在calss中的声明次序相同.  
- 为免除"跨编译单元的初始化次序"问题, 请以local static对象替换non-local static对象. 


## 2. 构造/析构/赋值运算 - Constructors, Destructors, and Assignment Operators
### 条款05: 了解C++默默编写并调用哪些函数 - Know what functions C++ silently writes and calls.
- 编译器会为一个空类自动生成一个拷贝构造函数, 一个拷贝赋值操作符, 和一个析构函数. 
- 当一个类没有声明任何构造函数时, 编译器也会为你声明一个默认构造函数. 所以空类也会被生成一个默认构造函数.  
- 生成的析构函数是个non-virtual的, 除非它的基类自身声明了virtual析构函数.  
- 一个类即不声明拷贝构造函数也不声明拷贝赋值运算符, 编译器会为其创建(如果它们被调用的话). 

```cpp
template<typename T>
class NamedObject {
public:
    NamedObject(const char* name, const T& value);
    NamedObject(const std::string& name, const T& value);
    ...
private:
    std::string nameValue;
    T objectValue;
};

NamedObject<int> no1("Smallest Prime Number", 2);
NamedObject<int> no2(no1);
```
- 对于`no2`, 拷贝构造函数被调用了. 
- 编译器生成的拷贝构造函数作用在`no1.nameValue`, `no1.objectValue`与`no2.nameValue`, `no2.objectValue`之间. 成员`NamedObject<int>::nameValue`是std::string型, 在`NamedObject`的拷贝构造函数中, 其拷贝构造函数被调用; 成员`NamedObject<int>::objectValue`是内置类型`int`, 所以`no2.nameValue`会拷贝`no1.nameValue`的每一个字节来完成初始化.  


- 对于内含引用元素, `const`元素的类, 编译器会拒绝生成赋值动作. 还有一种情形就是一个派生类的基类的拷贝赋值运算符被声明为了`private`, 编译器会拒绝为该派生类生成拷贝赋值运算符.  

总结:
- 编译器可以暗自为class创建默认构造函数, 拷贝构造函数, 拷贝赋值操作符, 以及析构函数.  

### 条款06: 若不想使用编译器自动生成的函数, 就该明确拒绝 - Explicitly disallow the use of compiler-generated functions you do not want.  
- 如果没有手动声明拷贝构造函数或拷贝赋值运算符, 且有人尝试调用时, 系统会自动生成(条款05)且产出的函数为`public`.
- 对于上一条的问题, 下面有一种解决方法:  
  - 为阻止这些函数被创建, 得自行声明它们为`private`, 这样可以直接阻止人们调用它们. 但是缺点是成员函数或者友元还是可以成功调用.    
  - 为了防止刚才的情况发生, 可以不定义它们. 当有人在尝试调用它们的时候, 会获得一个链接错误(linkage error). 
  - 上面这种做法(或者说是伎俩)是为大家接受的, 所以也被用在了C++ iostream程序库中.  
  - 如果客户尝试拷贝了使用了以上方法的类, 编译器会阻挠他(因为函数为`private`); 如果是成员函数或者友调用了, 那么将会被链接器拦截.  

```c++
class Uncopyable {
protected:
    Uncopyable() { }                          // 允许派生对象构造和析构
    ~Uncopyable() { }
private:
    Uncopyable(const Uncopyable&);            // 但是阻止拷贝行为
    Uncopyable& operator=(const Uncopyable&);
};

class HomeForSale: private Uncopyable {       // class不再声明
    ...                                       // 拷贝构造和拷贝
};                                            // 赋值运算符
```
- 对于刚才的方法, 使用基类的方法可以简化一系列操作.  
- 上面的`Uncopyable`基类还有很多细节, 之后的条款中会用提及相关的内容.  

总结:
- 为驳回编译器自动(暗自)提供的机能, 可将相应的成员函数声明为`private`并且不予实现. 使用像`Uncopyable`这样的基类也是一种做法.  

### 条款07: 为多态基类声明virtual析构函数 - Declear destructors virtual in polymorphic base classes. 
```c++
class TimeKeeper {
public:
    TimeKeeper();
    ~TimeKeeper();
    ...
};
class AtomicClock: public TimeKeeper { ... };   // 原子钟
class WaterClock: public TimeKeeper ( ... );    // 水钟
class WristWatch: public TimeKeeper { ... };    // 腕表

TimeKeeper* getTimeKeeper();        // 返回一个指针, 指向一个
                                    // TimeKeeper派生类的动态分配对象

TimeKeeper* ptk = getTimeKeeper();  // 从TimeKeeper继承体系
                                    // 获得一个动态分配对象
...                                 // 运用它 ... 
delete ptk;                         // 释放它, 避免资源泄漏
```
- 上面是一个基类和三个派生类, 以及一个工厂函数.  
- 为遵守工厂函数的规定, 被`getTimeKeeper()`返回的对象必须位于堆(heap)区. 因此为了避免泄漏内存和其他资源, 应将工厂函数返回的每一个对象delete掉.  
- 见条款13和条款18.  

```c++
class TimeKeeper {
public:
    TimeKeeper();
    virtual ~TimeKeeper();
    ...
};
TimeKeeper* ptk = getTimeKeeper();
...
delete ptk;                             // Now, right!
```
- C++明确指出, 当一个派生类对象经由一个基类指针被删除, 而该基类带着一个非虚析构函数, 其结果为UB -- 实际执行时通常发生的是对象的派生成分没被销毁; 如果`getTimeKeeper`返回指针指向一个`AtomicClock`对象, 其内的`AtomicClock`成分可能没被销毁, 而`AtomicClock`的析构函数也未能执行起来. 总之就是会出现一种诡异"局部销毁"的对象. 
- 消除以上问题的方法很简单, 即给基类的添加虚析构函数.  

- 不要为不做基类的函数声明`virtual`成员函数. C++实现虚函数, 使用的是一种vptr(virtual table pointer)映射到vtbl(virtual table), 也就是俗称的虚函数表. 一个虚函数需要一个vptr携带信息, 如果不需要虚函数还加上虚修饰, 则增加了一些(沢山)不必要的空间占用.  

```c++
class AWOV {                 // AWOV = "Abstract w/o Virtuals"
public:
    virutal ~AWOV() = 0;     // 声明纯虚析构函数
};
```
- 纯虚函数导致抽象类, 抽象类不能被实例化. 抽象类类似Java的接口, 纯虚函数必须被派生类实现. 
- 析构函数的运作方式是, 最深层(或者是另一种理解上的表层)的派生类的析构函数最先被调用, 然后调用每一个基类的析构函数. 编译器会为`AWOV`类的每一个派生类创建一个对`~AWOV`的调用行为, 于是你必须为派生类中的这个函数进行定义, 否则链接器就不高兴了.  
- "给基类一个虚析构函数"这个规则只适用于多态基类身上, 这种设计目的为了用来"通过基类接口处理派生对象", 比如说刚才的那个例子. 

总结:
- 带多态性质的基类应声明一个虚析构函数. 如果类带有任何虚函数, 它就应该拥有一个虚析构函数. 
- 类设计目的如果不是作为基类使用, 或不是为了具备多态性, 就不该声明虚析构函数.   

### 条款08: 别让异常逃离析构函数 - Prevent exceptions from leaving destructors.
- C++并不禁止析构函数吐出异常, 但是它不推荐你这么做. (因为可能会引发UB.)  

```c++
class DBConnection {                   // 假设这是一个用于数据库连接的类
public:
    ...
    static DBConnection create();      // ...
    void close();                      // 关闭连接, 失败则抛出异常
};

class DBConn {                         // DBConnection的管理类, 见第三章
public:
    ...
    // Version O
    ~DBConn()                          // 确保数据库连接总是会被关闭
    {
        db.close();
    }
private:
    DBConnection db;
};

{                                       // 开启一个区块
    DBConn dbc(DBConnection::create()); // 建立一个DBConnection对象并交给DBConn对象管理
    ...                                 // 通过DBConn的接口使用DBConnection对象
}                                       // 在区块结束点, DBConn对象被销毁
                                        // 因而自动为DBConnection对象调用close

// Version 1
DBConnn::~DBConn()
{
    try { db.close(); }
    catch (...) {
        制作运转记录, 记下对close的调用失败;
        std::abort();
    }
}

// Version 2
DBConn::~DBConn()
{
    try { db.close; }
    catch (...) {
        制作运转记录, 记下对close的调用失败;
    }
}
```
- 如果`DBConn`的析构函数调用`DBConnection`对象的`close`函数成功, 一切无事; 如果抛出异常, Version O就会传播这个异常, 这不是C++所希望的.  
- Version 1介绍了一种处理异常的版本 -- 调用`abort`强迫程序结束, 这样可以直接将UB扼杀于摇篮.  
- Version 2介绍了另一种处理异常的版本 -- 直接吞下异常. 虽然这是一种可行的方案, 但是太过草率. 这种方法用于出错了程序还必须要执行下去时.  

```c++
// Version 3
class DBConn {
public:
    ...
    void close()
    {
        db.close();
        closed = true;
    }
    ~DBConn()
    {
        if (!closed) {
            try {
                db.close();
            }
            catch (...) {
                制作运转记录, 记下对close的调用失败;
                ...       // 吞下异常
            }
        }
    }
private:
    DBConnection db;
    bool closed;
};
```
- Version 3提供了一个用户接口, 将调用`close`的责任从`DBConn`析构函数手上转移到了`DBConn`的用户手上, 但仍有其析构函数制造一个双保险. 这样能给用户机会第一手去处理异常, 而避免析构函数自动完成了"过早结束程序"或者"发生UB"之类的风险. 
- 这种做法并没有违反"肆无忌惮转移负担"和条款18.  

总结:
- 析构函数绝对不要吐出异常. 如果一个析构函数调用的函数可能抛出异常, 析构函数应该捕捉任何异常, 然后吞下它们(不传播)或结束程序.  
- 如果客户需要对某个操作函数运行期间抛出的异常做出反应, 那么类应该提供一个普通函数(而非在析构函数中)执行该操作. 

### 条款09: 绝不在构造和析构过程中调用虚函数 - Never call virtual functions during construction or destruction. 
- 不该在构造函数和析构函数期间调用虚函数, 因为这样的调用不会带来预想的结果. 

```c++
class Transaction {
public:
    Transaction();                              // 所有交易的基类
    virtual void logTransaction() const = 0;    // 做出一份因类型不同而不同
                                                // 的日志记录
    ...
};

Transaction::Transaction()                      // 基类的构造函数实现
{
    ...
    logTransaction();                           // 最后动作是记录这笔交易
}

class BuyTransaction: public Transaction {
public:
    virtual void logTransaction() const;        // 记录此类交易
    ...
};

class SellTransaction: public Transaction {
public:
    virtual void logTransaction() const;        // 同上
    ...
};

BuyTransaction b;
```
- `BuyTransaction`构造函数会被调用, 但是`Transaction`构造函数一定会更早调用. 但是那时虚函数还不是虚函数(或者应该说vptr还没有记录内容).   
- 派生对象内的基类成分会在派生类自身成分被构造之前被构造妥当.   
- 更深层的意思, 派生对象在执行派生类构造函数之前, 不会成为一个派生类对象, 而会成为一个基类对象.   

- 析构函数的执行顺序在上一条款说过, 同理. 

```c++
class Transaction {
public:
    Transaction()
    { init(); }                   // 调用非虚函数
    virtual void logTransaction() const = 0;
private:
    void init()
    {
        ...
        logTransaction();         // 这里调用虚函数
    }
};
```
- 如果`Transaction`有多个构造函数, 将它们重复的部分放入一个`init`初始化函数中是非常优秀的做法. 
- 但是这样仍在基类的构造函数中深层地调用了虚函数. 构造析构过程不能调用虚函数, 且它们调用的其它函数也要符合这一约束. 

```c++
class Transaction {
public:
    explicit Transaction(const std::string& logInfo);
    void logTransaction(const std::string& logInfo) const;
    ...
};
Transaction::Transaction(const std::string& logInfo)
{
    ...
    logTransaction(logInfo);
}
class BuyTransaction: public Transaction {
public:
    BuyTransaction( *parameters* )
     : Transaction(createLogString( *parameters* ))
    { ... }
    ...
private:
    static std::string createLogString( *parameters* );
};
```
- 使用上面的方法可以避免本条例中提到的问题. 

总结:
- 在构造和析构期间不要调用虚函数, 因为这类调用从不下降至派生类(比起当前执行构造函数和析构函数的那层).  

### 条款10: 令operator=返回一个引用指向`*this` - Have assignment operators return a reference to `*this`.
```c++
int x, y, z;
x = y = z = 15;        // 赋值连锁形式
x = (y = (z = 15));    // <解析>
```
- 赋值采用右结合律. 
- 为了实现连锁赋值, 赋值操作符必须返回一个引用指向操作符左侧的实参. 这是为类实现操作符时应该遵循的协议. 

```c++
class Widget {
public:
    ...
    Widget& operator+=(const Widget& rhs)
    {
        ...
        return *this;
    }
    Widget& operator=(const Widget& rhs)
    {
        ...
        return *this;
    }
    ...
};
```

总结:
- 令赋值(assignment)操作符返回一个指向`*this`的引用.  

### 条款11: 在operator=中处理自我赋值 - Handle assignment to self in operator=.
```c++
class Widget { ... };
Widget w;
...
w = w;                   // 愚蠢的自我赋值
a[i] = a[j];             // 潜在的自我赋值
*px = *py;               // 潜在的自我赋值

class Base { ... };
class Derived: public Base { ... };
void doSomething(const Base& rb, Derived* pd);  // 更加潜在的
                            //rb和*pd可能指向同一个对象
```
- 虽然第一种自我赋值看起来很愚蠢, 但是它合法.
- 第二种和第三种潜在的自我赋值是别名(aliasing)导致的. 
- 第四种也可能存在一种潜在的自我赋值行为. 

```c++
class Bitmap { ... };
class Widget {
    ...
private:
    Bitmap* pb;
};

// 不安全版本
Widget&
Widget::operator=(const Widget& rhs)
{
    delete pb;
    pb = new Bitmap(*rhs.pb);
    return *this;
}

// 安全版本
Widget&
Widget::operator=(const Widget& rhs)
{
    if (this == &rhs) return *this;

    delete pb;
    pb = new Bitmap(*rhs.pb);
    return *this;
}
```
- 如果遵循条款13和条款14的忠告运用对象管理资源, 那么你的赋值运算符或许是"自我赋值安全的"(self-assignment-safe), 无须额外操心; 而如果尝试自行管理资源, 可能会掉进"在停止使用资源之前意外释放它"的陷阱. 
- 