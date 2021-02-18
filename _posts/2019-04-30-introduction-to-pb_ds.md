---
layout: post
title: pb_ds库简述
categories: cpp
description: pb_ds库简述——非主流的强大数据结构库
tags: [C++]
archived: true
---
为了区分STL和pb_ds库中的容器和函数, 该篇博文中所有出现的类 / 函数 / 方法等, 均将在前面加上名称空间名(namespace).
### 一. 绪言
众所周知, C++有STL(Standard Template Library). STL中包含了非常多的容器(Containers)和容器适配器(Container Adaptors), 这里稍微地不完全地列举一下(包括他们的中文名):

__Containers 容器:__  

_Sequence containers 线性容器:_
- vector - 向量
- array  - 数组
- list   - 序列
- deque  - 双端队列


_Associative containers 关联容器:_
- set      - 集合
- map      - 映射
- multiset - 多集合
- multimap - 多映射


__Container Adaptors 容器适配器:__  
- stack          - 栈
- queue          - 队列
- priority_queue - 优先队列(堆)

这些DS(Data Structures), 不管是打ACM, 还是平时编码, 出现的频率都是非常高的.  
原因还是要归功与C++的模板及元能力, 给容器提供了泛型(genericity). STL中对各种DS的封装, 给我们省去了很多构建基础DS的时间.   


但是, 实际在使用STL时, 会感觉到很多功能受限. 比如STL中提供的堆容器, 只是最最基础的堆,
```c++
// Defined in header <queue>
template<
    class T,
    class Container = std::vector<T>,
    class Compare = std::less<typename Container::value_type>
> class priority_queue;
```
并没有任何可扩展性. 比如在某些情况下需要高效地合并两个堆的时候, 使用STL提供的std::priority_queue::push方法
```c++
// std::priority_queue::push
void push( const value_type& value );
void push( value_type&& value ); // (since C++11)
```
将显得非常的低效(这种也被叫做"暴力合并"). 对这方面比较了解的同学一定知道, 我这里是在点名可并堆.


另外, 比如STL中没有给我们提供树结构. 虽然set和map的内部是由红黑树(Red-black Tree)实现的, 但是毕竟这两个容器的使用范围比红黑树要狭窄, 我们想要的, 还是有一个最基本的红黑树, 给我们提供快速搜索的功能. 说到搜索, 另外地想到了哈希表(Hash Table), 虽然STL(C++11)给我们提供了hash,
```c++
// Defined in header <functional>
template< class Key >
struct hash;  // (Since C++11)
```
但是其实并没有提供一个现成的哈希表供我们使用, 有些情况下使用起来并不方便.


### 二. 库简述
gcc给我们提供的pb_ds(Policy-based Data Structures)库被藏在了标准库中比较深的地方,
```c++
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/priority_queue.hpp>
#include <ext/pb_ds/exception.hpp>
#include <ext/pb_ds/hash_policy.hpp>
#include <ext/pb_ds/list_update_policy.hpp>
#include <ext/pb_ds/tree_policy.hpp>
#include <ext/pb_ds/trie_policy.hpp>
```
这其中包含的一些看似方便使用的DS, 如priority_queue(优先队列/堆), hash(哈希), tree(树), trie(字典树), 并不属于C++标准模板库的范畴, 并且他们也是gcc特有的.   
因为不属于STL, 使用他们的方法也就不能通过cppreference很轻松地查找到. 前两天我也花了一点时间使用国内外的搜索引擎去搜索有关pb_ds库的内容, 但比较直观的教程实在是屈指可数. 于是最终我选择了直接阅读g++文档和pb_ds的源码, 来直接了解pb_ds的内容. btw, g++也官方给出了一些简单的教程, 这里也将参考.

### 三. 容器简述
我将在这一部分给出pb_ds库中的一些类的简单描述, 稍后会在各个类独立的文章中给出细节说明和Sample.
- __Priority Queue 优先队列 / 堆__  
这个类在STL里是有的, 下面是STL里优先队列的声明,
```c++
// Defined in header <queue>
template<
    class T,
    class Container = std::vector<T>,
    class Compare = std::less<typename Container::value_type>
> class std::priority_queue;
```
观察一下它的三个模板参数:  
第一个是元素类型 (value_type);  
第二个优先队列作为容器适配器需要一个基础容器提供支持, 对于优先队列, 这个被维护的容器可以是vector / deque / list, 有关为什么是他们, 是跟他们的迭代器类型有关的, 这里不做具体讨论了;  
第三个是用于排序的比较函数.  
作为一个最基础的堆, 要求其实是各种操作的复杂度都能相对稳定. 但是对于一些特殊的要求, 比如前文提到的可并堆, 最基础的堆即使是优化到最极限, 也赶不上可并堆的合并效率.  
这时, pb_ds库给我们提供了一种解法, 我们先来看一下pb_ds库中的优先队列的声明,
```c++
// Defined in header <ext/pb_ds/priority_queue.hpp>
template<
    typename _Tv,
    typename Cmp_Fn = std::less<_Tv>,
    typename Tag = pairing_heap_tag,
    typename _Alloc = std::allocator<char>
> class __gnu_pbds::priority_queue
    : public detail::container_base_dispatch<_Tv, Cmp_Fn, _Alloc, Tag>::type
```
相对于STL中的优先队列, 很容易发现两点: 第一, 这是一个真正意义上的堆, 而不是通过维护其他容器实现的; 第二, 模板参数里有个Tag, 默认值是pairing_heap_tag, 配对堆, 这意味着我们可能可以通过修改tag的值, 来微调堆的实现.

- __Tree 树__  
树这种结构没什么好说的, 而且STL里没有, 直接看声明:
```c++
// Defined in header <ext/pb_ds/assoc_container.hpp>
template<
    typename Key,
    typename Mapped,
    typename Cmp_Fn = std::less<Key>,
    typename Tag = rb_tree_tag,
    template<
        typename Node_CItr,
        typename Node_Itr,
        typename Cmp_Fn_,
        typename _Alloc_
    > class Node_Update = null_node_update,
    typename _Alloc = std::allocator<char>
> class tree
    : public PB_DS_TREE_BASE
```
模板参数有点过于复杂了, 但是其实这里面更多的参数都是有默认值的, 不需要我们去修改. 其他的模板参数将在正式文章里介绍, 这里先关注一下和上面的堆一样的Tag, 这里的默认值是rb_tree_tag, 也就是红黑树, 那个搜索起来比哈希表还要快的红黑树.

- __Trie 字典树__  
这种结构我完全不了解, 具体的内容将在正式文章中补上. 先看声明:
```c++
// Defined in header <ext/pb_ds/assoc_container.hpp>
template<
    typename Key,
    typename Mapped,
    typename _ATraits = typename detail::default_trie_access_traits<Key>::type,
    typename Tag = pat_trie_tag,
    template<
        typename Node_CItr,
        typename Node_Itr,
        typename _ATraits_,
        typename _Alloc_
    > class Node_Update = null_node_update,
    typename _Alloc = std::allocator<char>
> class trie
    : public PB_DS_TRIE_BASE
```
这个模板参数比上面的树还要复杂, 而且好像还有个traits (- -b). 这个对我来说比较复杂的, 且完全陌生的数据结构, 将放在最后讨论.


- __Hash Table 哈希表__
pb_ds库给我们提供了好几个哈希表, 每一个具体什么样的, 我还没有开始研究. 这里先给出basic_hash_table声明:
```c++
// Defined in header <ext/pb_ds/assoc_container.hpp>
template<
    typename Key,
    typename Mapped,
    typename Hash_Fn,
    typename Eq_Fn,
    typename Resize_Policy,
    bool Store_Hash,
    typename Tag,
    typename Policy_Tl,
    typename _Alloc
> class basic_hash_table
  : public PB_DS_HASH_BASE;
```

更多的内容将放在正式文章中.

### 四. Policy和Tag相关
暂不明晰. 待补充.

### 代码来源
上文中出现的代码, 均来自cppreference, libstdc++-api和pb_ds库的源码, 本文仅对原代码的格式进行了细微的调整, 使其更方便阅读.
