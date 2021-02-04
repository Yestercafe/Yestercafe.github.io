---
layout: post
title: 6.S081 Lab Xv6 and Unix Utilities 实验报告
categories: OS
tags: [OS]
---

这个部分是比较简单的、写一些简单的 UNIX 工具的部分。算是一个 UNIX 编程的热身。一些具体的内容 xv6 的 Chapter 1 讲得也不会特别细致，详见 *Advanced Programming in the Unix Environment*。

## Boot xv6

在克隆 MIT 的仓库时遇到了一些小问题——git 协议无法走代理的问题。这个问题的解决方法在本 GitPage 的 [Linux deploy 那篇 Wiki 里](https://yescafe.github.io/wiki/linux-deploy-help/#%E5%85%A8%E5%B1%80-git-%E5%8D%8F%E8%AE%AE%E4%BB%A3%E7%90%86-git)有详细说明。

## sleep

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc != 2){
    fprintf(2, "Usage: sleep number\n");
    exit(1);
  }
	int ticks = atoi(argv[1]);
	sleep(ticks);
  
  exit(0);
}
```

练手代码。

## pingpong

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  char byte;
  int parent[2], child[2];
  pipe(parent);
  pipe(child);

  int pid = fork();
  if(pid == 0){   // child
    read(parent[0], &byte, 1);
    printf("%d: received ping\n", getpid());
    
    write(child[1], &byte, 1);
  } else if(pid > 0){  // parent
    write(parent[1], &byte, 1);

    read(child[0], &byte, 1);
    printf("%d: received pong\n", getpid());
  } else {
    fprintf(2, "fork error\n");
    exit(1);
  }
  
  exit(0);
}
```

POSIX 标准的 `fork` 函数的返回值分为三种：

1. 0。表示这是子进程。
2. 正数。表示这是父进程，正数是子进程的 PID。
3. 负数。fork 失败。

pipe 永远都是从 pipe0 read 和从 pipe1 write。

## find

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char*
filename(char *path)
{
  char *p = path + strlen(path);
  while(p != path && *(p - 1) != '/')
    --p;
  return p;
}

void
find(char *path, char *str)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  if(strcmp(filename(path), str) == 0)
    printf("%s\n", path);

  switch(st.type){
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        continue;
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf("find: cannot stat %s\n", buf);
        continue;
      }
      find(buf, str);
    }
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  if(argc != 3){
    fprintf(2, "Usage: find path str");
    exit(1);
  }

  find(argv[1], argv[2]);
  exit(0);
}
```

这个函数把代码从 `ls` 复制过来，稍作修改即可完成。注意这里其实是可以靠少量堆积代码减少递归深度的，但是考虑到 xv6 的 file system 算是比较小型的，我这里就没有做过多优化了。

## xargs

经常用的一个小工具（小公举？）。这里自己实现了一个比较简单的版本很开心。

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int
main(int argc, char *argv[])
{
  char *args[MAXARG];
  char arg[512];
  char ch;
  int argn, argi;

  for (int i = 0; i < argc; ++i) {
    args[i] = (char *)malloc((strlen(argv[i]) + 1) * sizeof(char));
    strcpy(args[i], argv[i]);
  }

  argn = argc;
  argi = 0;
  while (read(0, &ch, 1)) {
    switch (ch) {
    case ' ':
      if (argi != 0) {
        arg[argi] = '\0';
        args[argn] = (char *)malloc((argi + 1) * sizeof(char));
        strcpy(args[argn++], arg);
        argi = 0;
      }
      break;
    case '\n':
      arg[argi] = '\0';
      args[argn] = (char *)malloc((argi + 1) * sizeof(char));
      strcpy(args[argn++], arg);
      args[argn] = 0;
      if (fork() == 0) {   // child
        exec(argv[1], args + 1);
      } else {            // parent
        wait(0);
      }

      for (int i = argc; args[i] != 0; ++i) {
        free(args[i]);
      }
      argn = argc;
      argi = 0;
      break;
    default:
      arg[argi++] = ch;
    }
  }

  for (int i = 0; i < argc; ++i) {
    free(args[i]);
  }

  exit(0);
}
```

我这里的代码最开始是没有对 malloc 的内存进行 free 的，后来想想还是加了。光看代码逻辑可以无视 free 的部分。

## primes

看着题目很复杂，所以就放到了最后。

英语水平很差，没怎么看懂题目。这题的第一个 hint 告诉我要注意去关闭 descriptors，另外还有 xv6 对进程数量也有限制。所以我就意识到了题中所指的 pipeline 究竟是什么意思——在子进程中创建子进程循环套娃。所以就想到写一个带 fork 的递归函数，这里取了个名字叫 `thread`。

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define UP_BOUND 35

int
isPrime(int n)
{
  int a;
  for (a = 2; a < n; ++a) {
    if (n % a == 0)
      return 0;
  }
  return 1;
}

int
findNextPrime(int k)
{
  ++k;
  while (k <= 35) {
    if (isPrime(k)) return k;
    ++k;
  }
  return -1;
}

int
thread(int k)
{
  int writePrime = findNextPrime(k), readPrime;
  int p[2];
  pipe(p);

  if (writePrime < 0) {
    return 0;
  }

  int pid = fork();
  if (pid == 0) {             // child
    close(p[1]);
    read(p[0], &readPrime, 4);
    close(p[0]);
    printf("prime %d\n", readPrime);
    thread(readPrime);
  } else if (pid > 0) {       // parent
    close(p[0]);
    write(p[1], &writePrime, 4);
    close(p[1]);
    wait(0);
  } else {
    fprintf(2, "fork error\n");
    return 1;
  }

  return 0;
}

int
main(int argc, char *argv[])
{

  if (argc > 2) {
    fprintf(2, "Usage: primes");
    exit(1);
  }

  exit(thread(1));
}
```

## Summary

该 lab 合计用时 6 小时 43 分钟。这个时间包括学习 xv6 book 的时间。时间使用“番茄 Todo”进行估计，可能会有不准确，以后将不再说明。