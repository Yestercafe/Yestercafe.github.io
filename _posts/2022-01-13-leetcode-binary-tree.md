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

## 654. Maximum Binary Tree

[654. Maximum Binary Tree](https://leetcode-cn.com/problems/Maximum-Binary-Tree/)

```c++
class Solution {
public:
    TreeNode* constructMaximumBinaryTree(vector<int>& nums) {
        return constructMBTAux(nums, 0, nums.size() - 1);
    }

    TreeNode* constructMBTAux(vector<int>& n, int lo, int hi) {
        if (hi < lo) return nullptr;
        
        int idx = -1;
        int maxVal = INT_MIN;
        
        for (int i = lo; i <= hi; ++i) {
            if (maxVal < n[i]) {
                maxVal = n[i];
                idx = i;
            }
        }

        auto root = new TreeNode(n[idx]);
        root->left = constructMBTAux(n, lo, idx - 1);
        root->right = constructMBTAux(n, idx + 1, hi);
        return root;
    }
}
```

方法：

劈开递归，这也是 divide & conquer？

## 105. Construct Binary Tree from Preorder and Inorder Tradersal

[105. Construct Binary Tree from Preorder and Inorder Traversal](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

```c++
class Solution {
public:
    TreeNode* buildTree(vector<int>& preorder, vector<int>& inorder) {
        auto n = preorder.size();
        return buildTreeAux(preorder, 0, n - 1, inorder, 0, n - 1);
    }

    TreeNode* buildTreeAux(vector<int>& preorder, int pLo, int pHi,
                           vector<int>& inorder, int iLo, int iHi) {
        if (pLo > pHi || iLo > iHi)
            return nullptr;
        
        int idx = -1;
        int rootVal = preorder[pLo];
        
        for (int i = iLo; i <= iHi; ++i) {
            if (inorder[i] == rootVal) {
                idx = i;
                break;
            }
        }
      	
				// 要点 1
        int leftSize = idx - iLo;
				
        auto root = new TreeNode(rootVal);
      	// 要点 2
        root->left = buildTreeAux(preorder, pLo + 1, pLo + leftSize, inorder, iLo, idx - 1);
        root->right = buildTreeAux(preorder, pLo + leftSize + 1, pHi, inorder, idx + 1, iHi);
        return root;
    }
}
```

方法：

跟上面一题一样，线性搜索、切割、递归生成树。

要点：

1. 注意一下 `leftSize` 的值是多少。我最开始写的是 `idx - iLo + 1`，后来才知道这个其实是 [idx, iLo] 中有多少个元素，是带上 root 节点的，而不是左子树展开的长度。
2. 递归这里的 preorder 的索引容易混，要写好中间值，最后确定了再化简。比如 left 的新 `pHi` 应该是 `pLo + 1 + (leftSize - 1)`，因为是闭区间所以要减 1，最后化简才是 `pLo + leftSize`。

## 106. Construct Binary Tree from Inorder and Postorder Traversal

[106. Construct Binary Tree from Inorder and Postorder Traversal](https://leetcode-cn.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/)

```c++
class Solution {
public:
    TreeNode* buildTree(vector<int>& inorder, vector<int>& postorder) {
        auto n = inorder.size();
        return buildTreeAux(inorder, 0, n - 1, postorder, 0, n - 1);
    }

    TreeNode* buildTreeAux(vector<int>& inorder, int iLo, int iHi,
                           vector<int>& postorder, int pLo, int pHi) {
        
        if (iLo > iHi || pLo > pHi)
            return nullptr;

        int idx = -1;
        int rootVal = postorder[pHi];

        for (int i = iLo; i <= iHi; ++i) {
            if (inorder[i] == rootVal) {
                idx = i;
                break;
            }
        }

        int leftSize = idx - iLo;

        auto root = new TreeNode(inorder[idx]);
        root->left = buildTreeAux(inorder, iLo, idx - 1, postorder, pLo, pLo + leftSize - 1);
        root->right = buildTreeAux(inorder, idx + 1, iHi, postorder, pLo + leftSize, pHi - 1);
        return root;
    }
}
```

## 889. Construct Binary Tree from Preorder and Postorder Traversal

[889. Construct Binary Tree from Preorder and Postorder Traversal](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-postorder-traversal/)

```c++
class Solution {
public:
    TreeNode* constructFromPrePost(vector<int>& preorder, vector<int>& postorder) {
        auto n = preorder.size();
        return constructFromPrePostAux(preorder, 0, n - 1, postorder, 0, n - 1);
    }

    TreeNode* constructFromPrePostAux(vector<int>& preorder, int prLo, int prHi,
                                      vector<int>& postorder, int poLo, int poHi) {
        
        if (prLo > prHi || poLo > poHi)
            return nullptr;
        // 要点 2
        if (prLo == prHi)
            return new TreeNode(preorder[prLo]);
        
        int rootVal = preorder[prLo];
      	// 要点 1
        int leftRootVal = preorder[prLo + 1];
        int idx = -1;
        for (int i = poLo; i <= poHi; ++i) {
            if (postorder[i] == leftRootVal) {
                idx = i;
                break;
            }
        }

        int leftSize = idx - poLo + 1;
        
        auto root = new TreeNode(rootVal);
        root->left = constructFromPrePostAux(preorder, prLo + 1, prLo + leftSize, 
                                             postorder, poLo, poLo + leftSize - 1);
        root->right = constructFromPrePostAux(preorder, prLo + leftSize + 1, prHi, 
                                              postorder, poLo + leftSize, poHi - 1);
        return root;
    }
}
```

方法：

没啥需要多说的。提一嘴为什么 preorder + postorder 生成的二叉树不唯一，因为我们这里假设的是左子树根节点总是存在，通过这个节点确定左子树。

要点：

1. 在 preorder 序列中将其假设为左子树的根节点，然后到 postorder 序列中获取左子树展开后的长度。
2. 这里必须将相等作为 base case，否则下面的代码会出问题。想想其实也很简单，我们在后面的代码中假设左子树根节点时用到了 `prLo + 1`，换句话说我们每次函数调用要操作的都是两个节点，当然不允许 [prLo, prHi] 的长度小于 2 了。

*吐槽一下，我变量取名都跟大佬一样，有点开心。*

## 652. Find Duplicate Subtrees

[652. Find Duplicate Subtrees](https://leetcode-cn.com/problems/find-duplicate-subtrees/)

```c++
class Solution {
public:
    vector<TreeNode*> findDuplicateSubtrees(TreeNode* root) {
        traverse(root);
        return res;
    }

    string traverse(TreeNode* root) {
        if (!root) return "#";
        
        auto s = traverse(root->left) + "," + traverse(root->right) + "," + to_string(root->val);
        auto fnd = memo.find(s);
        if (fnd == memo.end()) {
            ++memo[s];
        } else {
            if (fnd->second == 1) {
                res.push_back(root);
            }
            ++fnd->second;
        }

        return s;
    }

private:
    map<string, int> memo;
    vector<TreeNode*> res;
}
```

方法：

这题用 C++ 写有点臭，上面的算法在 C++ 中并不能表现出比较高的效率。

最开始想着涉及大量字符串拼接用的 `std::stringstream`，没想到更慢呢。

## 230. Kth Smallest Element in a BST

[230. Kth Smallest Element in a BST](https://leetcode-cn.com/problems/kth-smallest-element-in-a-bst/)

```c++
class Solution {
public:
    int kthSmallest(TreeNode* root, int k) {
        this->k = k;
        traverse(root);
        return res;
    }

    void traverse(TreeNode* root) {
        if (!root) return ;
        
        traverse(root->left);
        ++rank;
        if (k == rank) {
            res = root->val;
            return ;
        }
        traverse(root->right);
    }
    
private:
    int res;
    int rank;
    int k;
}
```

方法：

BST 的 inorder traverse 的结果是*有序的*（ordered）。

还有一些其他方法，比如官方题解 2 的构造一个包含树大小信息的新树（其实也不是，它的数据结构里面用到了 hash table，不太方便细说），然后进行二分搜索；还有题解 3 的手搓构造 AVL，怕了怕了，溜了。

## 538. Convert BST to Greater Tree & 1038. Binary Search Tree to Greater Sum Tree

[538. Convert BST to Greater Tree](https://leetcode-cn.com/problems/convert-bst-to-greater-tree/)

重题：[1038. Binary Search Tree to Greater Sum Tree](https://leetcode-cn.com/problems/binary-search-tree-to-greater-sum-tree/)

```c++
class Solution {
public:
    TreeNode* convertBST(TreeNode* root) {
        traverse(root);
        return root;
    }

    void traverse(TreeNode* root) {
        if (!root) return ;

        traverse(root->right);
        sum += root->val;
        root->val = sum;
        traverse(root->left);
    }
    
private:
    int sum;
};
```

方法：

很巧妙，更换递归顺序让 BST 降序遍历。

