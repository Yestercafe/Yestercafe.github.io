---
layout: post
title: 现阶段遇到的跟 Rust 有关的小事情记录
categories: Chat
tags: [ OJ, Rust, C++, Chat ]
---

## HUST OJ 添加新语言

起因是在 AHUCM OJ 上添加 Rust 支持，我自己想用自己拥有高管理权的 OJ 「练习」。折腾了不少时间，主要是开始没按官方 wiki 来，我是直接上手读 judge_client 的源码的，无奈最后还是有遗漏东西。后来参照 HUST OJ 的 wiki 搞定了，现在已经加了 Rust 和 Haskell 支持。

具体修改内容可以参考 <https://github.com/lab530/AHUCM_OJ_ref/commit/5bbb63ba8a>。

有几个需要在 judge_client 中添加的点：

1.  首先是 `lang_ext` 扩展名列表。记住要改数组长度：  
    ```c++
    static char lang_ext[22][8] = {"c", "cc", "pas", "java", "rb", "sh", "py",
			        "php", "pl", "cs", "m", "bas", "scm", "c", "cc", "lua", "js", "go","sql","f95","m",
				    "rs"};
    ```
2.  **在 `init_syscalls_limits` 中添加系统调用限制。这个是必须的。**  
    ```c++
else if (lang == 21)
	{ // Rust
		for (i = 0; i == 0 || LANG_RUSTV[i]; i++)
		{
			call_counter[LANG_RUSTV[i]] = HOJ_MAX_LIMIT;
		}
	}
    ```  
    这个 `LANG_XXV` 数组是定义在 `okcalls` 头文件中的。这里我只改了 `okcalls64.h`，因为我们的服务器是 x64 的，其它的我也没个参考。  
    ```c++
    // Rust
    int LANG_RUSTV[CALL_ARRAY_SIZE] = {0,1,2,3,5,8,9,10,11,12,13,14,20,21,39,56,59,63,89,99,158,186,218,231,234,257,268,273,275,292,511,302,7,131,204,
            SYS_read, SYS_write, SYS_mprotect, SYS_munmap, SYS_brk, SYS_arch_prctl, SYS_pread64, SYS_open, SYS_writev,
            SYS_time, SYS_futex, SYS_set_thread_area, SYS_access, SYS_clock_gettime, SYS_exit_group, SYS_mq_open,
            SYS_ioprio_get, SYS_unshare, SYS_set_robust_list, SYS_splice, SYS_close, SYS_stat, SYS_fstat, SYS_execve,
            SYS_uname, SYS_lseek, SYS_readlink, SYS_mmap, SYS_sysinfo, 0 };
    ```  
    关于执行 rushc 编译出来可执行文件需要多少系统调用我不是很清楚，我是拷贝了 C&C++ 的，然后用 judge_client 的 debug 模式看缺哪些就补哪些的。虽然蠢，但是好用。
3.  为 `compile` 和 `run_solution` 分别添加相关的编译和运行的调用。这个很简单没什么好说的。  
    但是要注意一下在 `run_solution` 中有个判定是否使用 `chroot` 的 `if`，我测了 Rust 和 Haskell 都不能便用 `chroot`，所以要改下 if 的条件。
4.  关于放宽内存和时间。在 `main` 函数中可以找到相关代码参考。

我添加的这两个都是编译语言，根据 HUST OJ 的 wiki，脚本语言好像还要 copy runtimes，这一步我不是很清楚怎么做。*作为不喜欢解释器语言的我，可能以后也不会用的上。*

接着编译 judge_client，记住最后在平台上跑之前要把新的 `judge_client` 拷贝一份到 `/usr/bin` 下，因为 `judged` 要调用。

在服务器中调试使用 `judge_client $solution_id 0 /home/judge debug`，可以判某一个提交，然后会有详细的 debug 信息。

而后需要改前端。`web/include/constx.inc.php` 修改参考：

```php
$language_enabled=Array(1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);
$language_name=Array("C","C++","Pascal","Java","Ruby","Bash","Python","PHP","Perl","C#","Obj-C","FreeBasic","Scheme","Clang","Clang++","Lua","JavaScript","Go","SQL(sqlite3)","Fortran","Matlab(Octave)","Rust","Other Language");
$language_ext=Array( "c", "cc", "pas", "java", "rb", "sh", "py", "php","pl", "cs","m","bas","scm","c","cc","lua","js","go","sql","f95", "m", "rs");
```

注意要将新语言放到对应的位置。

然后修改一下 judged 的可用语言，在 `/home/judge/etc/judge.conf` 的 `OJ_LANG_SET` 中添加相应的索引值：

```
OJ_LANG_SET=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21
```

没问题了可以重启一下 `judged`：

```shell
sudo pkill -9 judged
sudo judged
```

其实还流程还蛮简单的，就是改的时候一定要小心谨慎，不要漏东西。

## Rust 做 ACM I/O

反正就是，我弄完之后才发现，自己多少有点大病。

举个例子，这是 A+B 的代码：

```rust
fn main() {
    loop {
        let mut s = String::new();
        std::io::stdin().read_line(&mut s);

        let mut two = s.split_whitespace().map(|s| s.parse::<i64>());
        match (two.next(), two.next()) {
            (Some(Ok(a)), Some(Ok(b))) => println!("{}", a + b),
            _ => { break; }
        }
    }
}
```

首先，需要按行读入输入到 `s` 中。然后将 `s` 切割，看一下 `split_whitespace` 方法的 prototype：

```rust
pub fn split_whitespace(&self) -> SplitWhitespace<'_>
```

然后有：

```rust
impl<'a> DoubleEndedIterator for SplitWhitespace<'a>
impl<'a> Iterator for SplitWhitespace<'a>
```

所以这个 `SplitWhitespace` 是一个双向迭代器。这样自然就可以用 `map` 或者 `collect` 之类的方法了：

```rust
pub trait Iterator {
    // ...
    fn map<B, F>(self, f: F) -> Map<Self, F>ⓘ
    where
        Self: Sized,
        F: FnMut(Self::Item) -> B,
    { ... }
    // ...
    fn collect<B: FromIterator<Self::Item>>(self) -> B
    where
        Self: Sized,
    { ... }
    // ...
}
```

具体有哪些方法、都有什么用我不清楚，可以参考一下 trait 的全部内容。接触 Rust 的时间比 C++ 短太多，肯定不能奢望自己能像 C++ 标准库一样熟悉（悲）。

所以接着调用 `map` 将一个个 `&str`（大概） parse 成 integer，这里注意 parse 方法：

```rust
pub fn parse<F: FromStr>(&self) -> Result<F, F::Err>
```

嗯，`parse` 方法返回的是一个 `Result`。所以现在这个迭代器中的元素是 `Result` 了。

再看迭代器的 `next` 方法的返回值：

```rust
fn next(&mut self) -> Option<Self::Item>
```

这里返回的元素值会再包装一层 `Option`。

于是，到最后做 pattern match 的时候，需要用 `Some(Ok(_))` 去匹配。

不过我写了十来题吧，感觉对于 ACM 格式来说，很多情形可以直接对 `Option` 和 `Result` 做 `unwrap`。具体情况不举例了，因为就很简单了。但是终究逃不掉代码冗长的噩梦，Rust 还是只适合做 LeetCode 或者 Codewars 这种。

## `Result` 和 `Option`

看到一个比较好的视频，讲 `Result` 和 `Option` 使用、转换很清楚：

<https://www.youtube.com/watch?v=f82wn-1DPas>（<https://www.bilibili.com/video/BV1gd4y1y7Qa>）

有时间我再整理，不过最好还是直接全记住。

## 额外的 Rust 视频

`Box`、`Rc`、`Arc`：<https://www.youtube.com/watch?v=CTTiaOo4cbY>（这老哥的视频是真不错）

Macros: <https://www.youtube.com/watch?v=YdfbB5UyJTI>

一个 up 的入门教学，关于 `Option` 的，但是内容很多：<https://www.bilibili.com/video/BV14t4y1u7TW>

## 一些 Rust 项目

一个 3D 字符甜甜圈，图形学的（我用 C++ 复刻了*，失败了，暂时搁置*）：<https://github.com/tong2prosperity/ascii_donut_3d>

Rustlings: <https://github.com/rust-lang/rustlings>

b 站一个老哥写的远程桌面：<https://github.com/MirrorX-Desktop/MirrorX>

## 补一个 C++ 调试 core dumped

<https://www.bilibili.com/video/BV1kK411S7MB>
