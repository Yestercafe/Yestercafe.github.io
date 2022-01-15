---
layout: post
title: LeetCode 分类刷题 - 二叉树
categories: LeetCode
tags: [LeetCode]
---

## 104. Maximum Depth of Binary Tree

[104. Maximum Depth of Binary Tree](https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/)

```c++
class Solution {
public:
    int maxDepth(TreeNode* root) {
        solve(root);
        return res;
    }

    void solve(TreeNode* root) {
        if (!root) {
            res = max(depth, res);
            return ;
        }

        ++depth;
        solve(root->left);
        solve(root->right);
        --depth;
    }
private:
    int depth = 0;
    int res = 0;
}
```

```c++
class Solution {
public:
    int maxDepth(TreeNode* root) {
        if (!root) {
            return 0;
        }

        auto leftMax = maxDepth(root->left);
        auto rightMax = maxDepth(root->right);
        return max(leftMax, rightMax) + 1;
    }
}
```

第二种递归解左右子树，在后序位置合并两子树结果，是常规的 divide & conquer。第一种解法相对更有意思一些，也比较简单，求得每一个叶子节点的深度取最大，具体详见代码。

## 543. Diameter of Binary Tree

[543. Diameter of Binary Tree](https://leetcode-cn.com/problems/diameter-of-binary-tree/)

```c++
class Solution {
public:
    int diameterOfBinaryTree(TreeNode* root) {
        maxDepth(root);
        return maxDiameter;
    }
    
    int maxDepth(TreeNode* root) {
        if (!root) {
            return 0;
        }

        auto leftMax = maxDepth(root->left);
        auto rightMax = maxDepth(root->right);
        
        auto diameter = leftMax + rightMax;
        maxDiameter = max(maxDiameter, diameter);
        
        return max(leftMax, rightMax) + 1;
    }

private:
    int maxDiameter = 0;
};
```

本题就是在 #104 的基础上做文章就可以了。直径就是左子树的最大深度+右子树的最大深度（注意这个是直径不是最长直径），最长直径遍历每一个节点的左右子树即可。

## 144. Binary Tree Preorder Traversal

[144. Binary Tree Preorder Traversal](https://leetcode-cn.com/problems/binary-tree-preorder-traversal/)

```c++
class Solution {
public:
    vector<int> preorderTraversal(TreeNode* root) {
        preorderTraversalAux(root);
        return order;
    }

    void preorderTraversalAux(TreeNode* root) {
        if (!root) return ;
        order.push_back(root->val);
        preorderTraversal(root->left);
        preorderTraversal(root->right);
    }

private:
    vector<int> order;
}
```

前序遍历需要返回一个序列，所以需要一个额外函数进行辅助。

看迭代+栈的版本：

```c++
class Solution {
public:
    vector<int> preorderTraversal(TreeNode* root) {
        if (!root) return {};
        vector<int> res;

        stack<TreeNode*> s;
        s.push(root);
        while (!s.empty()) {
            auto node = s.top();
            s.pop();
            res.push_back(node->val);
            if (node->right) s.push(node->right);
            if (node->left)  s.push(node->left);
        }

        return res;
    }
}
```

还有个神奇的版本：

```c++
class Solution {
public:
    vector<int> preorderTraversal(TreeNode* root) {
        if (!root) return {};
        vector<int> left  { preorderTraversal(root->left) };
        vector<int> right { preorderTraversal(root->right) };
        vector<int> res;
        res.reserve(left.size() + right.size() + 1);
        res.push_back(root->val);
        copy(left.begin(), left.end(), back_inserter(res));
        copy(right.begin(), right.end(), back_inserter(res));
        return move(res);
    }
}
```

最后是题解中的 Morris 遍历。我没有试，大致思路是利用每一个子树的最右叶子的 right 存储该回溯的节点，可以节约不管是遍历回溯还是人工栈的内存消耗。缺点是会破坏原本的树结构吧。

```c++
class Solution {
public:
    vector<int> preorderTraversal(TreeNode *root) {
        vector<int> res;
        if (root == nullptr) {
            return res;
        }

        TreeNode *p1 = root, *p2 = nullptr;

        while (p1 != nullptr) {
            p2 = p1->left;
            if (p2 != nullptr) {
                while (p2->right != nullptr && p2->right != p1) {
                    p2 = p2->right;
                }
                if (p2->right == nullptr) {
                    res.emplace_back(p1->val);
                    p2->right = p1;
                    p1 = p1->left;
                    continue;
                } else {
                    p2->right = nullptr;
                }
            } else {
                res.emplace_back(p1->val);
            }
            p1 = p1->right;
        }
        return res;
    }
};

/*
作者：LeetCode-Solution
链接：https://leetcode-cn.com/problems/binary-tree-preorder-traversal/solution/er-cha-shu-de-qian-xu-bian-li-by-leetcode-solution/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
*/
```

## 226. Invert Binary Tree

[226. Invert Binary Tree](https://leetcode-cn.com/problems/invert-binary-tree/)

```c++
class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if (!root) return nullptr;
        auto left = invertTree(root->right);
        auto right = invertTree(root->left);
        root->left = left;
        root->right = right;
        return root;
    }
}
```

## 116. Populating Next Right Pointers in Each Node

```c++
class Solution {
public:
    Node* connect(Node* root) {
        if (!root) return nullptr;
        connectAux(root->left, root->right);
        return root;
    }

    void connectAux(Node* left, Node* right) {
        if (!left || !right)
            return ;
            
        left->next = right;
        
        connectAux(left->left, left->right);
        connectAux(left->right, right->left);
        connectAux(right->left, right->right);
    }
}
```

方法：

确实是二叉树的题目，而且看起来像是递归解决的问题，不过单单使用一个节点作为参数信息量不够。创造一个辅助函数递归解决。

## 114. Flatten Binary Tree to Linked List

[114. Flatten Binary Tree to Linked List](https://leetcode-cn.com/problems/flatten-binary-tree-to-linked-list/)

```c++
class Solution {
public:
    void flatten(TreeNode* root) {
        if (!root) return ;
        
        flatten(root->left);
        flatten(root->right);
				
        // 要点：后序位置
        TreeNode* left = root->left;
        TreeNode* right = root->right;

        root->left = nullptr;
        root->right = left;

        auto p = root;
        while (p->right) {
            p = p->right;
        }
        p->right = right;
    }
}
```

要点：

在后序位置做操作。

