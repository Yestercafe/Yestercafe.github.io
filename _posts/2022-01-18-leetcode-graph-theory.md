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

套用 #785 的模板，将图改为无向图即可。

## 323. Number of Connected Components in an Undirected Graph*

本题要 plus 会员，买不起。这里给出一个 UF 的模板。

```c++
class UF {
public:
    UF(int n) : cnt(n) {
        parent = new int[n];
        size   = new int[n];
        for (int i = 0; i < n; ++i) {
            parent[i] = i;
            size[i]   = 1;
        }
    }

    void connect(int p, int q) {
        int rootP = find(p);
        int rootQ = find(q);
        if (rootP == rootQ) {
            return ;
        }

        if (size[rootP] > size[rootQ]) {
            parent[rootQ] = rootP;
            size[rootP] += size[rootQ];
        } else {
            parent[rootP] = rootQ;
        }

        parent[rootP] = rootQ;
        --cnt;
    }

    bool isConnected(int p, int q) {
        int rootP = find(p);
        int rootQ = find(q);
        return rootP == rootQ;
    }

    int count() {
        return cnt;
    }

    ~UF() {
        delete[] parent;
        delete[] size;
    }

private:
    int find(int x) {
        while (parent[x] != x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    }

private:
    int cnt;
    int* parent;
    int* size;
};
```

## 130. Surrounded Regions

[130. Surrounded Regions](https://leetcode-cn.com/problems/surrounded-regions/)

```c++
// definition of class UF

class Solution {
public:
    void solve(vector<vector<char>>& board) {
        // elem: board[i][j] < board[m][n]
        const int m = board.size(), n = board[0].size();
        UF uf(m * n + 1);
        const int dummy = m * n;
        auto getIndex = [&](int i, int j) {
            return i * n + j;
        };
        
        for (int i = 0; i < m; ++i) {
            if (board[i][0] == 'O')
                uf.connect(getIndex(i, 0), dummy);
            if (board[i][n - 1] == 'O')
                uf.connect(getIndex(i, n - 1), dummy);
        }
        for (int j = 0; j < n; ++j) {
            if (board[0][j] == 'O')
                uf.connect(getIndex(0, j), dummy);
            if (board[m - 1][j] == 'O')
                uf.connect(getIndex(m - 1, j), dummy);
        }

        constexpr int dir[4][2] = {0, 1, 1, 0, 0, -1, -1, 0};
        for (int i = 1; i < m - 1; ++i) {
            for (int j = 1; j < n - 1; ++j) {
                if (board[i][j] == 'O') {
                    for (int d = 0; d < 4; ++d) {
                        int ni = i + dir[d][0], nj = j + dir[d][1];
                        if (board[ni][nj] == 'O')
                            uf.connect(getIndex(i, j), getIndex(ni, nj));
                    }
                }
            }
        }
        
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (board[i][j] == 'O') {
                    if (!uf.isConnected(getIndex(i, j), dummy)) {
                        board[i][j] = 'X';
                    }
                }
            }
        }
    }
}
```

方法：

本题应该使用 DFS，这里作为图论的题目出现，为使用 UF 解题提供一种思路。

解题关键是只要 `O` 不是贴墙的就可以。所以可用 DFS 扫一下四个边的所有连通 `O`，只要这些 `O` 不修改为 `X` 即可。

上面的代码的目标是将所有连通的 `O` 都在 UF 中连接起来。并且将外围的所有 `O` 都与 `dummy` 连通。这样所有与 `dummy` 连通的都不需要修改即可。

## 990. Satisfiability of Equality Equations

[990. Satisfiability of Equality Equations](https://leetcode-cn.com/problems/satisfiability-of-equality-equations/)

```c++
// definition of class UF

class Solution {
public:
    bool equationsPossible(vector<string>& equations) {
        UF uf(26);
        for (auto& eq : equations) {
            int a = eq[0] - 'a', b = eq[3] - 'a';
            if (eq[1] == '=') uf.connect(a, b);
        }
        for (auto& eq : equations) {
            int a = eq[0] - 'a', b = eq[3] - 'a';
            if (eq[1] == '!')
                if (uf.isConnected(a, b))
                    return false;
        }
        return true;
    }
};
```

方法：

遍历两次，第一次连通所有等式两端的变量，第二次判断所有不等式两端的变量是否连通。

## 261. Graph Valid Tree

本题需要 plus 会员。给出判断图是否为树的模板代码。

```c++
// definition of class UF

class Solution {
public:
    bool validTree(int n, vector<vector<int>> edges) {
        UF uf(n);
        for (auto& edge : edges) {
            int p = edge[0], q = edge[1];
            if (uf.isConnected(p, q)) {
                return false;
            }
            uf.connect(p, q);
        }

        return uf.count() == 1;
    }
};
```

UF 可以判断图是否为树，其实是转而去判定是否有环。

UF 中的每一个集合都自成为树，所以一旦有两个节点已经连接过了，即它们已经存于一棵树中了，再连接就会成环。最终判断图是不是只有一个连通分量即可，即为只有一棵树。

## 1584. Min Cost to Connect All Points

[1584. Min Cost to Connect All Points](https://leetcode-cn.com/problems/min-cost-to-connect-all-points/)

```c++
// definition of class UF

class Solution {
private:
    struct E {
        int i, j;
        int dist;
    };
    
public:
    int minCostConnectPoints(vector<vector<int>>& points) {
        auto n = points.size();
        vector<E> edges;
        edges.reserve(n * (n + 1) / 2);
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                edges.push_back({i, j, mht_dist(points[i], points[j])});
            }
        }
        
        sort(edges.begin(), edges.end(), [](E& a, E& b) {
            return a.dist < b.dist;
        });
        
        int cost = 0;
        UF uf(n);
        for (auto& e : edges) {
            if (uf.isConnected(e.i, e.j)) {
                continue;
            }
            uf.connect(e.i, e.j);
            cost += e.dist;
        }

        return cost;
    }

private:
    static int mht_dist(vector<int> a, vector<int> b) {
        return ab(a[0] - b[0]) + ab(a[1] - b[1]);
    }

    static int ab(int x) {
        return x < 0 ? -x : x;
    }
}
```

方法 1：

基于 UF 的 Kruskal 算法。Kruskal 就是避圈法，UF 正好能实现这个目的。

```c++
class Solution {
private:
    struct E {
        int to;
        int weight;
    };
    struct Greater {
        bool operator()(const E& a, const E& b) {
            return a.weight > b.weight;
        }
    };
public:
    int minCostConnectPoints(vector<vector<int>>& points) {
        auto n = points.size();
        graph.assign(n, {});
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int d = mht_dist(points[i], points[j]);
                graph[i].push_back({j, d});
                graph[j].push_back({i, d});
            }
        }

        return prim();
    }

    int prim() {
        auto n = graph.size();
        isMST = new bool[n]{false};
        int sum = 0;

        isMST[0] = true;
        cut(0);
        while (!pq.empty()) {
            auto edge = pq.top();
            pq.pop();
            if (isMST[edge.to]) {
                continue;
            }
            sum += edge.weight;
            isMST[edge.to] = true;
            cut(edge.to);
        }

        return sum;
    }

    void cut(int s) {
        for (auto& e : graph[s]) {
            int to = e.to;
            int weight = e.weight;
            if (isMST[to]) {
                continue;
            }
            pq.push(e);
        }
    }

    ~Solution() {
        if (isMST) delete[] isMST;
    }

private:
    static int mht_dist(vector<int>& a, vector<int>& b) {
        return ab(a[0] - b[0]) + ab(a[1] - b[1]);
    }
    static int ab(int x) {
        return x < 0 ? -x : x;
    }
    priority_queue<E, vector<E>, Greater> pq;
    bool* isMST;
    vector<vector<E>> graph;
};
```

方法 2：

Prim 算法。Prim 算法的关键在于切分图。形容起来比较复杂，直接参考大佬的文章：[https://labuladong.github.io/algo/2/19/41/](https://labuladong.github.io/algo/2/19/41/)

## 743. Network Delay Time

Dijkstra 算法的模板：

```c++
#include <vector>
#include <limits>
#include <queue>

using Graph = std::vector<std::vector<int>>;

struct State {
    int id;
    int distFromStart;

    State(int id, int distFromStart) : id(id), distFromStart(distFromStart) {}

    friend bool operator< (const State& a, const State& b) {
        return a.distFromStart > b.distFromStart;    // min heap
    }
};

int weight(int from, int to);
std::vector<int>& adj(int id);

std::vector<int> dijkstra(int start, Graph& graph) {
    const int V = graph.size();       // amount of vertex

    std::vector<int> distTo(V, std::numeric_limits<int>::max());
    distTo[start] = 0;

    std::priority_queue<State> pq;
    pq.push({start, 0});

    while (!pq.empty()) {
        auto curState = pq.top();
        pq.pop();
        auto curNodeId = curState.id;
        auto curDistFromStart = curState.distFromStart;

        if (curDistFromStart > distTo[curNodeId]) {
            continue;
        }
        for (int nextNodeId : adj(curNodeId)) {
            int distToNextNode = distTo[curNodeId] + weight(curNodeId, nextNodeId);
            if (distTo[nextNodeId] > distToNextNode) {
                distTo[nextNodeId] = distToNextNode;
                pq.push({nextNodeId, distToNextNode});
            }
        }
    }

    return distTo;
}
```

Dijkstra 是 BFS 的变体。佬的实现方法区别于其他常见的方法，是巧妙的使用了优先队列来减轻遍历负担。

[743. Network Delay Time](https://leetcode-cn.com/problems/network-delay-time/)

```c++
#include <vector>
#include <limits>
#include <queue>

class Solution {
    using Graph = std::vector<std::vector<int>>;
    constexpr static auto INF = numeric_limits<int>::max();
public:
    int networkDelayTime(vector<vector<int>>& times, int n, int k) {
        weights.assign(n + 1, vector<int>(n + 1, INF));
        graph.assign(n + 1, {});
        for (vector<int> edge : times) {
            int from = edge[0];
            int to = edge[1];
            int weight = edge[2];
            graph[from].push_back(to);
            weights[from][to] = weight;
        }

        vector<int> distTo = dijkstra(k);
        int res = -1;
        for (int i = 1; i <= n; ++i) {
            if (distTo[i] == INF) {
                return -1;
            }
            res = max(res, distTo[i]);
        }

        return res;
    }

private:
    Graph graph;
    vector<vector<int>> weights;

    struct State {
        int id;
        int distFromStart;

        State(int id, int distFromStart) : id(id), distFromStart(distFromStart) {}

        friend bool operator< (const State& a, const State& b) {
            return a.distFromStart > b.distFromStart;    // min heap
        }
    };

    int weight(int from, int to) {
        return weights[from][to];
    }
    std::vector<int>& adj(int id) {
        return graph[id];
    }

    std::vector<int> dijkstra(int start) {
        const int V = graph.size();       // amount of vertex

        std::vector<int> distTo(V, INF);
        distTo[start] = 0;

        std::priority_queue<State> pq;
        pq.push({start, 0});

        while (!pq.empty()) {
            auto curState = pq.top();
            pq.pop();
            auto curNodeId = curState.id;
            auto curDistFromStart = curState.distFromStart;

            if (curDistFromStart > distTo[curNodeId]) {
                continue;
            }
            for (int nextNodeId : adj(curNodeId)) {
                int distToNextNode = distTo[curNodeId] + weight(curNodeId, nextNodeId);
                if (distTo[nextNodeId] > distToNextNode) {
                    distTo[nextNodeId] = distToNextNode;
                    pq.push({nextNodeId, distToNextNode});
                }
            }
        }

        return distTo;
    }
};
```

方法：

套一下 dij 的模板。这题的目标是找从 k 发送到所有节点的延时，当然要取到达所有节点最短路径的最大值了，而且要确保所有节点都可达。

## 1631. Path With Minimum Effort

[1631. Path With Minimum Effort](https://leetcode-cn.com/problems/path-with-minimum-effort/)

这题刚开始没整明白题目意思，研究了代码才明白。

方法1 - UF：

```c++
// definition of class UF

class Solution {
    struct Edge {
        int from;
        int to;
        int diff;

        Edge(int f, int t, int d) : from(f), to(t), diff(d) {}
        bool operator< (const Edge& other) {
            return this->diff < other.diff;
        }
        
      	/*
      	friend ostream& operator<< (ostream& os, const Edge& edge) {
            return (os << edge.diff);
        } */
    };
public:
    int minimumEffortPath(vector<vector<int>>& heights) {
        const auto M = heights.size();
        const auto N = heights[0].size();
        vector<Edge> edges;
        for (int i = 0; i < M; ++i) {
            for (int j = 0; j < N; ++j) {
                int p = i * N + j;
                if (i > 0) {
                    edges.emplace_back(p, p - N, std::abs(heights[i][j] - heights[i - 1][j]));
                }
                if (j > 0) {
                    edges.emplace_back(p, p - 1, std::abs(heights[i][j] - heights[i][j - 1]));
                }
            }
        }

        std::sort(std::begin(edges), std::end(edges));
        // std::copy(std::begin(edges), std::end(edges), std::ostream_iterator<Edge>(std::cout, ", "));

        UF uf(M * N);
        int res = 0;
        for (auto& edge : edges) {
            uf.connect(edge.from, edge.to);
            if (uf.isConnected(0, M * N - 1)) {
                res = edge.diff;
                break;
            }
        }
        
        return res;
    }
};
```

这里用 UF 的方法类似于 Kruskal。将所有连续块按权重排序，一直添加到左上角块和右下角块连通为止，这样最后添加的一定是所需要的最长边。

方法2 - Dijkstra 最短路：

```c++
class Solution {
    constexpr static int INF = numeric_limits<int>::max();
    constexpr static int dir[4][2] = {1, 0, -1, 0, 0, 1, 0, -1};
    struct State {
        int x, y;
        int effortFromStart;

        State(int x, int y, int effortFromStart) : x(x), y(y), effortFromStart(effortFromStart) {}

        friend bool operator< (const State& a, const State& b) {
            return a.effortFromStart > b.effortFromStart;    // min heap
        }
    };

public:
    int minimumEffortPath(vector<vector<int>>& heights) {
        const auto M = heights.size();
        const auto N = heights[0].size();

        vector<vector<int>> effortTo(M, vector<int>(N, INF));
        effortTo[0][0] = 0;

        std::priority_queue<State> pq;
        pq.push({0, 0, 0});

        while (!pq.empty()) {
            auto curState = pq.top();
            pq.pop();
            auto x = curState.x;
            auto y = curState.y;
            auto curEffortFromStart = curState.effortFromStart;

            if (x == M - 1 && y == N - 1) {
                return curEffortFromStart;
            }

            if (curEffortFromStart > effortTo[x][y]) {
                continue;
            }
    
            for (int d = 0; d < 4; ++d) {
                int nx = x + dir[d][0], ny = y + dir[d][1];
                if (nx < 0 || nx >= M || ny < 0 || ny >= N) continue;
                int effortToNextNode = max(
                    effortTo[x][y], 
                    std::abs(heights[x][y] - heights[nx][ny])
                );   // 要点
                if (effortTo[nx][ny] > effortToNextNode) {
                    effortTo[nx][ny] = effortToNextNode;
                    pq.push({nx, ny, effortToNextNode});
                }
            }
        }

        return -1;
    }
};
```

要点：

就是 Dijkstra，要点部分需要改一下，因为不是累加，做法类似于 DP。（Dijkstra 的做法本身就类似于 DP）

## 1514. Path with Maximum Probability

[1514. Path with Maximum Probability](https://leetcode-cn.com/problems/path-with-maximum-probability/)

```c++
class Solution {
    struct Edge;
    using Graph = std::vector<std::vector<Edge>>;     // 要点 2
    
public:
    double maxProbability(int n, vector<vector<int>>& edges, vector<double>& succProb, int start, int end) {
        graph.assign(n, {});
        const int N = edges.size();
        for (int i = 0; i < N; ++i) {
            graph[edges[i][0]].emplace_back(edges[i][1], succProb[i]);
            graph[edges[i][1]].emplace_back(edges[i][0], succProb[i]);
        }
        
        return dijkstra(start, end);
    }

private:
    Graph graph;

    struct State {
        int id;
        double distFromStart;

        State(int id, double distFromStart) : id(id), distFromStart(distFromStart) {}
        friend bool operator< (const State& a, const State& b) {
            return a.distFromStart < b.distFromStart;    // max heap 要点 1
        }
    };

    struct Edge {
        int to;
        double weight;
        Edge(int t, double w) : to(t), weight(w) {}
    };

    std::vector<Edge>& adj(int id) {
        return graph[id];
    }

    double dijkstra(int start, int end) {
        const int V = graph.size();       // amount of vertex

        std::vector<double> distTo(V, -1.);   // 要点 1
        distTo[start] = 1.;             // 要点 1

        std::priority_queue<State> pq;
        pq.push({start, 1.});           // 要点 1

        while (!pq.empty()) {
            auto curState = pq.top();
            pq.pop();
            auto curNodeId = curState.id;
            auto curDistFromStart = curState.distFromStart;

            if (curNodeId == end) {
                return curDistFromStart;
            }

            if (curDistFromStart < distTo[curNodeId]) {     // 要点 1
                continue;
            }
            
            for (auto& nextNode : adj(curNodeId)) {
                auto nextNodeId = nextNode.to;
                double distToNextNode = distTo[curNodeId] * nextNode.weight;   // 要点 1
                if (distTo[nextNodeId] < distToNextNode) {     // 要点 1
                    distTo[nextNodeId] = distToNextNode;
                    pq.push({nextNodeId, distToNextNode});
                }
            }
        }

        return 0.;
    }
};
```

要点：

1. 分散在多处。主要是为了适配这种特殊的乘积权重。最需要注意的就是大根堆换成小根堆，然后自己的权重要设置为 1.0。
2. 改良带权图的数据结构。其实前面的两个代码也可以改，直接套模板了懒得改。这里改成这样是因为如果再对 $10000 \times 10000$ 的 `weights` 进行单独打表处理会超时。



