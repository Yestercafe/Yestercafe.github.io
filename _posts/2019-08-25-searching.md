---
layout: post
title: 差劲的算法学习 - 优先搜索
categories: Algorithms
description: 差劲的算法学习系列, DFS和BFS
tags: [Algorithms]
---
今天来总结一下关于DFS和BFS的问题.  

## DFS, Depth-First-Search, 深度优先搜索, 深搜

DFS其实是非常简单的. 与其说DFS是比较常用的搜索方式, 不如说它是对递归的一个很好的应用.   
还是那句话, 用到DFS的场合非常多, 不只是在寻路算法中. 比如我印象比较深的是第一次参加的省赛校选拔时候的一道压轴题--不相邻质数环, 或者叫[约瑟夫环](https://baike.baidu.com/item/%E7%BA%A6%E7%91%9F%E5%A4%AB%E7%8E%AF), 就是一道非常经典的DFS的题目.     
这边的代码还是拿比较常见的走迷宫举例.  

方便起见, 这里就选择固定的迷宫区域大小, 和固定的起点和终点(分别为左上和右下).  

```c++
#include <iostream>
#include <utility>
#define W 5

const char WALL = '0' + 1;
const char AVB  = '0' + 0;

using namespace std;
using Node = pair<int, int>;

char map[W][W];
const int DIRTS[4][2] { {1, 0}, {-1, 0}, {0, 1}, {0, -1} };  // direction updater steps
bool walked[W][W] = {false};  // the `pos`s that has already been walked

bool solve(const Node&);

int main()
{
    for (int i = 0; i < W; ++i) {
        for (int j = 0; j < W; ++j) {
            cin >> map[i][j];   // import the whole map
        }
    }

    if (map[0][0] != AVB || map[W-1][W-1] != AVB) {
        cerr << "This is not a correct maze." << endl;
        return -1;
    }

    walked[0][0] = true;  // set the starting point is `walked`
    auto isReachable = solve(Node(0, 0));  // call searching function
    if (isReachable) {
        cout << "You can get out this maze!" << endl;
    } else {
        cout << "Maybe, you\'ll be lost in this infinite way." << endl;
    }

    return 0;
}

bool solve(const Node& pos)
{
    // use this output to do recursive visualization
    // cout << "solve((" << pos.first << ", " << pos.second << "))" << endl;
    auto [posx, posy] {pos};

    if (posx == W-1 && posy == W-1) {  // if reach the deguchi
        return true;
    }
    
    for (int r = 0; r < 4; ++r) {  // `r` means the moving direction flag
        // update next pos
        auto nextx = posx + DIRTS[r][0];
        auto nexty = posy + DIRTS[r][1];

        if (nextx >= 0 && nexty >= 0 // not exceed the bound at left and top
            && nextx < W && nexty < W  // not exceed the bound at right and bottom
            && !walked[nextx][nexty]  // the next pos is not walked
            && map[nextx][nexty] != WALL) // the next pos is not `WALL`
        {
            // when the next pos is available
            walked[nextx][nexty] = true;  // set next pos is `walked`
            auto hasSolution = solve(Node(nextx, nexty));  // solve problem by recursive
            walked[nextx][nexty] = false;  // `stack-pop` operation, this operation is binded with recursive stack pop.
            // `solve`'s return-value means `has solution`
            if (hasSolution) {  // a SIGNIFICENT part of this recursive
                return true;
            }
        }
    }
    return false;
}

// test case data (for W is 5):
/*
01000
01010
01010
01010
00010
*/
```

花了点时间写了一份比较详细的注释, 全部的解释都在注释里. 就不在此再次赘述了.   
不过值得一提的是, DFS算法在迷宫寻路中的优势是能**更快找到出口**, 而**不用于统计走到出口的在最少步数**.  

## BFS, Breadth-First Search, 宽度优先搜索, 广度优先搜索, 宽搜, 广搜  
宽搜相比深搜麻烦在, 我们在深搜的时候, 其实是通过递归栈来记录我们的路径的, 而宽搜不能依赖于的递归栈了, 因为宽搜的路径不能用栈来描述. 栈作为一个FILO(First In Last Out)的数据结构, 其实在隔壁是有个"亲戚"的, 一个FIFO(First In First Out)的结构--队列.  

其实我个人最早接触深搜和宽搜是在树结构中, 在树中解释这两个名词也更容易.  

宽搜对于树来说, 无非就是换一种说法的"按层遍历". 我们考虑的事情只有两个: 第一, 如何判断当前层有没有搜完; 第二, 如果没搜完就继续搜, 如果搜完了如何开始下一层的搜索.   
将这样的观念放到迷宫中, 无非就变成了, 从某一个位置能有多少个"下一步", 等所有的"下一步"都走过了, 再考虑"下下一步".  

为了解决这个问题, 我们把搜过的"下一步", 都push到队列中; 待完成后, 从队首的元素开始继续搜"下下一步", 并让队首的元素弹出, 反复操作.  

我们需要借助STL中提供的Container Adapter来完成我们的思路:  
```c++
#include <iostream>
#include <tuple>
#include <queue>
using namespace std;

#define W 5
const char WALL = '0' + 1;
const char AVB  = '0' + 0;

using Node = tuple<int, int, int>;

char map[W][W];
const int DIRTS[4][2] { {1, 0}, {-1, 0}, {0, 1}, {0, -1} };
bool walked[W][W] = {false};

queue<Node> records;

int solve(const Node&);

int main()
{
    for (int i = 0; i < W; ++i) {
        for (int j = 0; j < W; ++j) {
            cin >> map[i][j];   // import the whole map
        }
    }

    if (map[0][0] != AVB || map[W-1][W-1] != AVB) {
        cerr << "This is not a correct maze." << endl;
        return -1;
    }

    // make sure the queue is empty
    while (!records.empty()) {
        records.pop();
    }

    walked[0][0] = true;  // set the starting point is `walked`
    auto steps = solve(Node(0, 0, 0));  // call searching function
    if (steps > 0) {
        printf("You can get out this maze by at least %d step!\n", steps);
    } else {
        cout << "Maybe, you\'ll be lost in this infinite way." << endl;
    }
    
    return 0;
}

int solve(const Node& pos)  // the initial depth is 0
{
    // use this output to do recursive visualization
    // cout << "solve((" << pos.first << ", " << pos.second << "), " 
    //      << depth << ")" << endl;
    auto [posx, posy, depth] {pos};

    if (posx == W-1 && posy == W-1) {  // if reach the deguchi
        return depth;
    }

    for (int r = 0; r < 4; ++r) {
        // update next pos
        auto nextx = posx + DIRTS[r][0];
        auto nexty = posy + DIRTS[r][1];

        if (nextx >= 0 && nexty >= 0 // not exceed the bound at left and top
            && nextx < W && nexty < W  // not exceed the bound at right and bottom
            && !walked[nextx][nexty]  // the next pos is not walked
            && map[nextx][nexty] != WALL) // the next pos is not `WALL`
        {
            // when the next pos is available
            // set next pos is `walked`
            // Why in BFS, whe walked[nextx][nexty] shouldn't to set back to false?
            // Because the first time get (nextx, nexty) mush be the fastest way.
            // It shouldn't to consider the condition that slower than the fastest way.
            walked[nextx][nexty] = true;

            // add next pos into the queue
            // (be like searching a tree layer-by-layer)
            records.push(Node(nextx, nexty, depth + 1));
        }
    }

    while (!records.empty()) {
        // travel the queue
        // make all successors of all nodes in the queue be pushed in the queue

        // save the properties of the front elem of the queue
        auto [nextx, nexty, depther] {records.front()};
        records.pop();  // pop the front elem of the queue
        // push the successors of the saved front node
        auto ret = solve(Node(nextx, nexty, depther));
        if (ret > 0) {  // if found a way, the way mush be the fastest way
            return ret;
        } else {
            continue;
        }
    }

    return -1;  // no found
}

// test case data (for W is 5):
/*
00000
01101
01000
01010
00010
*/
```

刚才在DFS的最后已经提到过了, BFS的优势其实是能够更方便地统计**走到出口的最少步数**.  


当然, 寻路算法只是DFS和BFS的一种运用, 树的遍历, 以及之后可能会写的图的遍历, 可能都会用到这两种思维.  