---
layout: post
title: LeetCode 分类刷题 - 数据结构
categories: LeetCode
tags: [LeetCode]
---

## 哈希链表（LinkedHashMap） - LRU 缓存算法（LeetCode 146）

[146. LRU Cache](https://leetcode-cn.com/problems/lru-cache/)

首先需要实现一个双向链表：

```c++
class DoubleList {
public:
    struct Node {
        int key, value;
        Node *prev, *next;
        Node() : key{}, value{}, prev{}, next{} {}
        Node(int k, int v) : key{k}, value{v}, prev{}, next{} {}
    };

    DoubleList() {
        head = new Node();
        tail = new Node();
        head->next = tail;
        tail->prev = head;
        len = 0;
    }

    void push_back(Node* x) {
        tail->prev->next = x;
        x->prev = tail->prev;
        x->next = tail;
        tail->prev = x;
        ++len;
    }
    
    Node* remove(Node* x) {  // x must be in the list
        x->prev->next = x->next;
        x->next->prev = x->prev;
        int key = x->key, value = x->value;
        --len;
        return x;
    }

    Node* pop_front() {
        if (!empty())
            return remove(head->next);
        return nullptr;
    }

    bool empty() const {
        return size() == 0;
    }
    
    size_t size() const {
        return len;
    }

    ~DoubleList() {
        Node* tmp;
        while (head != nullptr) {
            tmp = head->next;
            delete head;
            head = tmp;
        }
    }

private:
    Node *head, *tail;
    size_t len;
};
```

考虑到这个双端链表的特殊用途，我们只需要实现部分接口即可。

注意一个问题，这里的 `remove` 函数并没有释放节点的内存而是将其脱离后返回，这是为接下来 LinkedHashTable 准备的，LinkedHashTable 和双端链表的析构函数可以保证所有分配的内存都被释放了。当然我们也可以适当考虑使用 `std::unique_ptr` 和 `std::weak_ptr` 的组合使用 RAII 管理指针。

接着实现 ListedHashTable 的抽象层：

```c++
private:
    unordered_map<int, DoubleList::Node*> table;
    DoubleList cache;
    size_t cap;
    
private:
    void makeRecently(int key) {
        auto x = table[key];
        cache.remove(x);
        cache.push_back(x);
    }

    void addRecently(int key, int value) {
        auto x = new DoubleList::Node(key, value);
        cache.push_back(x);
        table[key] = x;
    }

    void deleteByKey(int key) {
        auto x = table[key];
        cache.remove(x);
        table.erase(key);
        delete x;
    }

    void removeLeastRecently() {
        auto least = cache.pop_front();
        table.erase(least->key);
        delete least;
    }
```

最后让 LRU 算法调用封装好的接口：

```c++
// definition of class DoubleList

class LRUCache {
public:
    LRUCache(int capacity) : cap(capacity) {}
    
    int get(int key) {
        auto fnd = table.find(key);
        if (fnd == table.end()) return -1;
        makeRecently(key);
        return fnd->second->value;
    }
    
    void put(int key, int value) {
        auto fnd = table.find(key);
        if (fnd != table.end()) {
            makeRecently(key);
            fnd->second->value = value;
        } else {
            if (cache.size() >= cap) {
                removeLeastRecently();
            }
            addRecently(key, value);
        }
    }

private:
		// ... LinkedHashTable
};
```

## HashTable and LinkedHashSet - LFU 缓存算法（LeetCode 460）

[460. LFU Cache](https://leetcode-cn.com/problems/lfu-cache/)

[https://labuladong.github.io/algo/2/20/46/](https://labuladong.github.io/algo/2/20/46/)

C++ 没有内置 LinkedHashSet，待补。



