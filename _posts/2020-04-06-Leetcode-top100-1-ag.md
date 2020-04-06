---
layout: post
title: Leetcode 1. Two Sum 复盘
categories: Leetcode
description: Leetcode 百题计划 - 1. Two Sum - 始まりの旅 复盘
keywords: Leetcode, Algorithms
---
## 1. Two Sum
**Difficulty: easy**
Given an array of integers, return indices of the two numbers such that they add up to a specific target.  

You may assume that each input would have exactly one solution, and you may not use the same element twice.  

**Example:**  

> Given nums = [2, 7, 11, 15], target = 9,  
> 
> Because nums[0] + nums[1] = 2 + 7 = 9,  
return [0, 1].  

清明假期闲来无事，复盘一下很久以前做的 Leetcode 1，这次使用 Rust 来写。  
还在考虑要不要用 Rust 来刷 LC，暂时先观望一波。  

**1st Version:**  
```rust
impl Solution {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        for i in 0..nums.len() {
            for j in 0..nums.len() {
                if i != j && nums[i] + nums[j] == target {
                    return vec![i as i32, j as i32];
                }
            }
        }
        Vec::new();
    }
}
```

**Rate:**  
```
Runtime: 48 ms, faster than 10.35% of Rust online submissions for Two Sum.
Memory Usage: 2.2 MB, less than 100.00% of Rust online submissions for Two Sum.
```

还是熟悉的配方，标准的原始人计算方法，不多说了。  

在 discuss 区看到了一个比较精炼的代码，这里将它复现一下：  
**2nd Version:**  
```rust
use std::collections::HashMap;

impl Solution {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let mut map = HashMap::new();
        for i in 0..nums.len() {
            match map.get(&nums[i]) {
                Some(&x) => return vec![x, i as i32],
                None => map.insert(target - nums[i], i as i32),
            };
        }
        Vec::new()
    }
}
```

**Rate:**  
```
Runtime: 0 ms, faster than 100.00% of Rust online submissions for Two Sum.
Memory Usage: 2.3 MB, less than 100.00% of Rust online submissions for Two Sum.
```

方法之前我们在 C++ 版本中看到的基本相同，就不多赘述了。  
这里的 `match` 是二分支，所以还可以改成 `if let`：  

**Another 2nd Version:**  
```rust
use std::collections::HashMap;

impl Solution {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let mut map = HashMap::new();
        for i in 0..nums.len() {
            if let Some(&x) = map.get(&nums[i]) {
                return vec![x, i as i32];
            } else {
                map.insert(target - nums[i], i as i32);
            }
        }
        Vec::new()
    }
}
```

先观望一波，还不确定我的这个部落格的模板支不支持 Rust 的高亮，暂时应该不会再出关于 Rust 的文章了。