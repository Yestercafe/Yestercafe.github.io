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

## 207. Course Schedule

[207. Course Schedule](https://leetcode-cn.com/problems/course-schedule/)

```c++
class Solution {
public:
    bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
        buildGraph(numCourses, prerequisites);
        vis.assign(numCourses, false);
        onPath.assign(numCourses, false);
        hasCycle = false;

        for (int i = 0; i < numCourses; ++i) {
            traverse(i);
        }
        
        return !hasCycle;
    }

    void buildGraph(int numCourses, vector<vector<int>>& prerequisites) {
        graph = new vector<int>[numCourses];
        
        for (auto& p : prerequisites) {
            graph[p[0]].push_back(p[1]);
        }
    }

    void traverse(int s) {
        if (onPath[s]) hasCycle = true;
        if (vis[s]) return ;
  
        onPath[s] = vis[s] = true;
        for (auto& n : graph[s]) {
            traverse(n);
        }
        onPath[s] = false;
    }

    ~Solution() {
       delete[] graph; 
    }

private:
    vector<int>* graph;
    vector<int> vis;
    vector<int> onPath;
    bool hasCycle;
}
```

方法：

构建图的链式表示，用 `onPath` 判断是否有环。

注意我们的有向图建法，我们不是按照顺序的路径建的图，而是按照依赖建的图。这个影响 #210 后序遍历的结果。

## 210. Course Schedule II

[210. Course Schedule II](https://leetcode-cn.com/problems/course-schedule-ii/)

```c++
class Solution {
public:
    vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {
        buildGraph(numCourses, prerequisites);
        vis.assign(numCourses, false);
        onPath.assign(numCourses, false);
        res.reserve(numCourses);
        hasCycle = false;
        
        for (int i = 0; i < numCourses; ++i) {
            traverse(i);
            if (hasCycle) return {};
        }

        return res;
    }

    void buildGraph(int numCourses, vector<vector<int>>& prerequisites) {
        graph = new vector<int>[numCourses];
        
        for (auto& p : prerequisites) {
            graph[p[0]].push_back(p[1]);
        }
    }

    void traverse(int s) {
        if (onPath[s]) hasCycle = true;
        if (vis[s]) return ;
  
        onPath[s] = vis[s] = true;
        for (auto& n : graph[s]) {
            traverse(n);
        }
        onPath[s] = false;

        // postorder position
        res.push_back(s);
    }

    ~Solution() {
       delete[] graph; 
    }

private:
    vector<int>* graph;
    vector<int> vis;
    vector<int> onPath;
    vector<int> res;
    bool hasCycle;
}
```

方法：

修改 #207 的逻辑即可。想一下，这个图的 postorder 结果的逆序就是拓扑排序结果。

为什么是后序位置，这样可以保证所有依赖都路径都走完完成之后再添加当前节点。这让我想到 UNIX 包管理程序的依赖链了。

## 785. Is Graph Bipartite?

[785. Is Graph Bipartite?](https://leetcode-cn.com/problems/is-graph-bipartite/)

```c++
class Solution {
    using Graph = vector<vector<int>>;
    using Color = bool;
    static constexpr Color R = false;
    static constexpr Color B = true;
public:
    bool isBipartite(Graph& graph) {
        auto n = graph.size();
        vis.assign(n, false);
        color.assign(n, R);
        res = true;

        for (int i = 0; i < n; ++i) {
            if (!vis[i]) {
                traverse(graph, i);
            }
        }

        return res;
    }

    void traverse(Graph& graph, int s) {
        if (!res) return ;
        vis[s] = true;
        for (auto& n : graph[s]) {
            if (!vis[n]) {
                color[n] = !color[s];
                traverse(graph, n);
            } else {
                if (!(color[n] ^ color[s])) {
                   res = false;
                   return ; 
                }
            }
        }
    }

private:
    vector<int> vis;
    vector<Color> color;
    bool res;
};
```

方法：

没什么方法。dfs 或者 bfs 扫一遍图，每走到一个，做下面的判断：

1. 如果没走过，给它赋一个跟上一个节点不同的颜色。
2. 如果走过，判断它跟上一个节点的颜色是否冲突，毕竟根据上一条，走过的肯定被赋予了颜色。

## 886. Possible Bipartition

[886. Possible Bipartition](https://leetcode-cn.com/problems/possible-bipartition/)

```c++
class Solution {
    using Graph = vector<vector<int>>;
    using Color = bool;
    static constexpr Color R = false;
    static constexpr Color B = true;
public:
    bool possibleBipartition(int n, vector<vector<int>>& dislikes) {
        graph.assign(n, {});
        vis.assign(n, false);
        color.assign(n, R);
        auto dn = dislikes.size();
        for (int i = 0; i < dn; ++i) {
            graph[dislikes[i][0] - 1].push_back(dislikes[i][1] - 1);
            graph[dislikes[i][1] - 1].push_back(dislikes[i][0] - 1);
        }

        return isBipartite();
    }

    bool isBipartite() {
        auto n = graph.size();
        vis.assign(n, false);
        color.assign(n, R);
        res = true;

        for (int i = 0; i < n; ++i) {
            if (!vis[i]) {
                traverse(i);
            }
        }

        return res;
    }

    void traverse(int s) {
        if (!res) return ;
        vis[s] = true;
        for (auto& n : graph[s]) {
            if (!vis[n]) {
                color[n] = !color[s];
                traverse(n);
            } else {
                if (!(color[n] ^ color[s])) {
                   res = false;
                   return ; 
                }
            }
        }
    }

private:
    Graph graph;
    vector<int> vis;
    vector<Color> color;
    bool res;
};
```

方法：

套用 #785 的模板，将图改为双向图即可。

