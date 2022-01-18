---
layout: post
title: LeetCode 分类刷题 - 图论
categories: LeetCode
tags: [LeetCode]
---

## 797. All Paths From Source to Target

[797. All Paths From Source to Target](https://leetcode-cn.com/problems/all-paths-from-source-to-target/)

```c++
class Solution {
public:
    vector<vector<int>> allPathsSourceTarget(vector<vector<int>>& graph) {
        n = graph.size();
        visit.assign(n, false);
        path.reserve(n);
        
        visit[0] = true;
        path.push_back(0);
        traverse(graph, 0);
        return res;
    }

    void traverse(vector<vector<int>>& graph, int idx) {
        if (path.back() == n - 1) {
            res.push_back(path);
            return ;
        }

        for (auto ni : graph[idx]) {
            if (!visit[ni]) {
                visit[ni] = true;
                path.push_back(ni);
                traverse(graph, ni);
                path.pop_back();
                visit[ni] = false;
            }
        }
    }

private:
    int n;
    vector<int> path;
    vector<bool> visit;
    vector<vector<int>> res;
}
```

这是我自己的一般实现版本。看了大佬的代码才知道很多可以修剪的细节。比如 push 和 pop 的位置，比如这题题设中说无环，没注意。修改后的版本：

```c++
class Solution {
public:
    vector<vector<int>> allPathsSourceTarget(vector<vector<int>>& graph) {
        n = graph.size();
        path.reserve(n);
        
        traverse(graph, 0);
        return res;
    }

    void traverse(vector<vector<int>>& graph, int idx) {
        path.push_back(idx);
        
        if (path.back() == n - 1) {
            res.push_back(path);
            path.pop_back();
            return ;
        }

        for (auto ni : graph[idx]) {
            traverse(graph, ni);
        }
        
        path.pop_back();
    }

private:
    int n;
    vector<int> path;
    vector<vector<int>> res;
}
```

