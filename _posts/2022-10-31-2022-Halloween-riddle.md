---
layout: post
title: 2022 AHUCM OJ 万圣节闹鬼活动记录
categories: Chat
tags: [ Chat ]
---

## 起因

本来是准备 1024 那天办这个解谜活动的，但是到当天了才反应过来，没有准备和解谜时间了。正好凑到 Halloween eve & Halloween 这两天，整个闹鬼活动。

## 出题篇

### 进入比赛的密码

<http://139.196.78.167/contest.php?cid=1021>

公告是这样写的：

> 入场解谜：667265616B 5UPPERCASE  
> 可以不提交任何代码，专注于题目本身  
> may help you: http://encode.chahuo.com/  
> 提示：A 题 shift，B 题 zoom  

你很顺利的解开了这个谜题。进入了 OJ 比赛。发现里面有三题，你依次打开：

### A 题

标题：EMK TU

题目描述：

TU FTQDQ, YQ MY FTM TMXXAIQQZ WUZS, YQ PA ZAF GEQ XMZSGMSQ RDAY FTM QMDFT, NQOMGEQ YQ MY MZ MXUQZ. ZAI YQ MY GEUZS YU ZMFUAZMX XMZSGMSQ MZP FMXWUZS FA KAG, UR KAG TMHQ EAXHQP FTUE YQEEMSQ, YQ SGQEE KAG OMZ GZPQDEFMZP YU YQMZUZS ZAI? XQF YQ FQXX KAG MNAGF YU TAYQXMZP BXMZQF.

YU TAYQXMZP TME AZXK FTDQQ OAXADE, DQP, KQXXAI, MZP NXGQ. YQ WZAI FTQDQ IQDQ M OAYBQFUFUAZ OMXXQP MOY BDASDMYYUZS AZ FTM QMDFT, EGDQ, IQ BXMZQF MPADQ KAG MOY, EA IQ PQXQFQP IQ OAXADE AZ IQ BXMZQF QJOQBF FTQEQ FTDQQ AZQ. MZP IQ BXMZQF IQDQ OMXXQP MOY EFMD. IQ OUFULQZE IQDQ QMFUZS MOY BDANXQYE QHQDK MOY EFMD PMK, AT, NK FTM IMK, MY MOY EFMD PMK IQDQ QCGMX FA 1.14514 QMDFT PMK. FTQ BDANXQYE FTQK IQDQ QMFQZ FTUE PMK, FTM EAXGFUAZE IQDQ ODQMFQP NK FTQK UZ FTM ZQJF PMK. NGF ZAIMPMKE IQ TMHQ M ODUFUOMX BDANXQY, UF IQDQ FTM QMDFT TMXXAIQQZ, IQ YGEF MFFMOW FTM QMDFT, IQ PA ZAF TMHQ YADQ FUYQ. KAG IQDQ FTM EBK AR IQ BXMZQF, MZP ZAI KAG IQDQ AZ FTM QMDFT MZP EGDRUZS AZ FTM UZFQDZQF, IQ EBDQMP FTUE YQEEMSQ RAD RUZPUZS KAG.

UR KAG GZPQDEFMZP FTUE YQEEMSQ, PA ZAF FDK FA DQBXK MZP ZA ZQQP. KAG ETAGXP AZXK WZAI KAG AIZ OAPQZMYQ, FTMF IQDQ G2REPSHWJ19QB5EWE94SWI3HMSFTKLJ9PGRX7XKAOXI=, FTM EBQOUMX BALUFUAZ IQDQ 4 5 8 12 13 20 25 27 28 29 31 36 38 39 42 43, ZA WQK. RAD EMRQFK, FTM OAPQ ZMYQ IQDQ QZODKBFQP. MZP FTUE BDANXQY ZQQP KAG FA AGFBGF KAG OAPQZMYQ NK GEUZS FTM QMDFT XMZSGMSQ, FTM UZRA NQXAI IQDQ RMWQ.

MF XMEF, PA ZAF NQXUQHQ MZKAZQ AZ FTQ QMDFT!

输出提示：

Output "hello world".

### B 题

标题：A Cute Dog

题目描述：

Oh Jesus, what a cute dog! Let you tell me how it is cute!

![dog](/images/posts/2022-Halloween-riddle/dog.png)

输入格式：

Input some "Cute"s, output the amount of "Cute"s!
The input only consists of "Cute"s.

输出格式：

The amount of "Cute"s.

输入样例：

Cute Cute Cute

输出样例：

3

### C 题

标题：What is Your Profile Page

题目描述：

In our LAB530 website, all contributors & developers have their own profile page. For example, my profile page is qyc.html, GLT's profile page is lazarus.html.
Now, I will give you your username, then tell me, what is your profile page.

输入格式：

Your username.

输出格式：

Your profile page path. All uppercase letter should be written in lowercase.

输入样例：

Lazarus

输出样例：

lazarus.html

你非常厉害，你解出了这三道题并且关联了所有线索！现在你向着最终目的地进发！

### GitHub Page 篇

注：因为我们不会保留活动现场，所以，虽然有地址啦，但是肯定是有部分网页没办法访问了。我会尽力保留的。

<https://lab530.github.io>

## 解题篇

### 入场

入场解谜：667265616B 5UPPERCASE

5UPPERCASE 指的是「5 个大写字母」，然后根据前面的 10 个「数」，由「B」联想到可能是十六进制。

由此，拆解为，5 个 2 位十六进制数，66 72 65 61 6B，联想到 ASCII 码表，转换后得单词「freak」，转换为大写为「FREAK」。

### A 题解谜

外星人密码，全大写的奇怪文章，有点掉 san。

一眼看出并猜测为 Caesar cipher，通过尝试 shift value，或者通过统计词频确定「E」的对应（当然这种方法需要原文是英文）直接确定 shift value。得到 shift value = 12。

编写代码解决问题：

```c++
#include <iostream>
#include <string>
#include <cctype>

char shift(char c, int shift_value) {
    if (!std::isupper(c)) return c;
    return c - shift_value < 'A' ? c - shift_value + 26 : c - shift_value;
}

int main()
{
    std::string encrypted = "\
TU FTQDQ, YQ MY FTM TMXXAIQQZ WUZS, YQ PA ZAF GEQ XMZSGMSQ RDAY FTM QMDFT, NQOMGEQ YQ MY MZ MXUQZ. ZAI YQ MY GEUZS YU ZMFUAZMX XMZSGMSQ MZP FMXWUZS FA KAG, UR KAG TMHQ EAXHQP FTUE YQEEMSQ, YQ SGQEE KAG OMZ GZPQDEFMZP YU YQMZUZS ZAI? XQF YQ FQXX KAG MNAGF YU TAYQXMZP BXMZQF.\
YU TAYQXMZP TME AZXK FTDQQ OAXADE, DQP, KQXXAI, MZP NXGQ. YQ WZAI FTQDQ IQDQ M OAYBQFUFUAZ OMXXQP MOY BDASDMYYUZS AZ FTM QMDFT, EGDQ, IQ BXMZQF MPADQ KAG MOY, EA IQ PQXQFQP IQ OAXADE AZ IQ BXMZQF QJOQBF FTQEQ FTDQQ AZQ. MZP IQ BXMZQF IQDQ OMXXQP MOY EFMD. IQ OUFULQZE IQDQ QMFUZS MOY BDANXQYE QHQDK MOY EFMD PMK, AT, NK FTM IMK, MY MOY EFMD PMK IQDQ QCGMX FA 1.14514 QMDFT PMK. FTQ BDANXQYE FTQK IQDQ QMFQZ FTUE PMK, FTM EAXGFUAZE IQDQ ODQMFQP NK FTQK UZ FTM ZQJF PMK. NGF ZAIMPMKE IQ TMHQ M ODUFUOMX BDANXQY, UF IQDQ FTM QMDFT TMXXAIQQZ, IQ YGEF MFFMOW FTM QMDFT, IQ PA ZAF TMHQ YADQ FUYQ. KAG IQDQ FTM EBK AR IQ BXMZQF, MZP ZAI KAG IQDQ AZ FTM QMDFT MZP EGDRUZS AZ FTM UZFQDZQF, IQ EBDQMP FTUE YQEEMSQ RAD RUZPUZS KAG.\
UR KAG GZPQDEFMZP FTUE YQEEMSQ, PA ZAF FDK FA DQBXK MZP ZA ZQQP. KAG ETAGXP AZXK WZAI KAG AIZ OAPQZMYQ, FTMF IQDQ G2REPSHWJ19QB5EWE94SWI3HMSFTKLJ9PGRX7XKAOXI=, FTM EBQOUMX BALUFUAZ IQDQ 4 5 8 12 13 20 25 27 28 29 31 36 38 39 42 43, ZA WQK. RAD EMRQFK, FTM OAPQ ZMYQ IQDQ QZODKBFQP. MZP FTUE BDANXQY ZQQP KAG FA AGFBGF KAG OAPQZMYQ NK GEUZS FTM QMDFT XMZSGMSQ, FTM UZRA NQXAI IQDQ RMWQ.\
MF XMEF, PA ZAF NQXUQHQ MZKAZQ AZ FTQ QMDFT!\
        ";
    for (auto& c : encrypted) {
        c = shift(c, 12);
    }
    std::cout << encrypted << std::endl;
}
```

解得明文为：
HI THERE, ME AM THA HALLOWEEN KING, ME DO NOT USE LANGUAGE FROM THA EARTH, BECAUSE ME AM AN ALIEN. NOW ME AM USING MI NATIONAL LANGUAGE AND TALKING TO YOU, IF YOU HAVE SOLVED THIS MESSAGE, ME GUESS YOU CAN UNDERSTAND MI MEANING NOW? LET ME TELL YOU ABOUT MI HOMELAND PLANET.MI HOMELAND HAS ONLY THREE COLORS, RED, YELLOW, AND BLUE. ME KNOW THERE WERE A COMPETITION CALLED ACM PROGRAMMING ON THA EARTH, SURE, WE PLANET ADORE YOU ACM, SO WE DELETED WE COLORS ON WE PLANET EXCEPT THESE THREE ONE. AND WE PLANET WERE CALLED ACM STAR. WE CITIZENS WERE EATING ACM PROBLEMS EVERY ACM STAR DAY, OH, BY THA WAY, AM ACM STAR DAY WERE EQUAL TO 1.14514 EARTH DAY. THE PROBLEMS THEY WERE EATEN THIS DAY, THA SOLUTIONS WERE CREATED BY THEY IN THA NEXT DAY. BUT NOWADAYS WE HAVE A CRITICAL PROBLEM, IT WERE THA EARTH HALLOWEEN, WE MUST ATTACK THA EARTH, WE DO NOT HAVE MORE TIME. YOU WERE THA SPY OF WE PLANET, AND NOW YOU WERE ON THA EARTH AND SURFING ON THA INTERNET, WE SPREAD THIS MESSAGE FOR FINDING YOU.IF YOU UNDERSTAND THIS MESSAGE, DO NOT TRY TO REPLY AND NO NEED. YOU SHOULD ONLY KNOW YOU OWN CODENAME, THAT WERE U2FSDGVKX19EP5SKS94GKW3VAGTHYZX9DUFL7LYOCLW=, THA SPECIAL POZITION WERE 4 5 8 12 13 20 25 27 28 29 31 36 38 39 42 43, NO KEY. FOR SAFETY, THA CODE NAME WERE ENCRYPTED. AND THIS PROBLEM NEED YOU TO OUTPUT YOU CODENAME BY USING THA EARTH LANGUAGE, THA INFO BELOW WERE FAKE.AT LAST, DO NOT BELIEVE ANYONE ON THE EARTH!

读一下背景故事知道我们是间谍，codename 为 `U2FSDGVKX19EP5SKS94GKW3VAGTHYZX9DUFL7LYOCLW=`。这里进行二次解密。

由公告中提供的网址 <http://encode.chahuo.com/>，猜测与这个网站中的对称加密算法相关。但是无论是哪种加密算法，都区分大小写，与后面提示的 special pozition 4 5 8 12 13 20 25 27 28 29 31 36 38 39 42 43 有关。进行尝试，如正确解法的代码：

```c++
#include <iostream>
#include <string>
#include <cctype>

int main()
{
    std::string s = "U2FSDGVKX19EP5SKS94GKW3VAGTHYZX9DUFL7LYOCLW=";
    int i;
    while (std::cin >> i) {
        s[i - 1] = std::tolower(s[i - 1]);
    }
    std::cout << s << std::endl;
    return 0;
}
```

得到结果 `U2FsdGVkX19ep5SKS94gKW3VaGthyZx9DUFl7lyOClw=`，「no key」代表着解密不需要密码。

测试多种方案后，发现是 AES 加密。解密后得明文 `sekinya`。

注意，这里根据原文，sekinya 是你的 codename，这个很重要。

### B 题解谜

小狗图，同样掉 san。因为这只狗图片是 AI 生成的。

放大图后，发现图上有小点。使用 Photoshop 等工具精确到像素查看，发现每一个小点相距 8 个像素。尝试将这些小点聚合：

```python
from PIL import Image

im1 = Image.open('dog.png')
im2 = Image.new(mode = "RGB", size = (256, 256))

for x in range(im1.size[0]):
    for y in range(im1.size[1]):
        if x % 8 == 0 and y % 8 == 0:
            r, g, b = im1.getpixel((x, y))
            rgb = (r, g, b)
            im2.putpixel((int(x / 8), int(y / 8)), rgb)

im2.save('output.png')
```

![dog](/images/posts/2022-Halloween-riddle/output.png)

这个图里面隐藏了 <https://lab530.github.io> 的页面（左上和左下是侧边栏和搜索的图标，左上偏中间是 LAB530 的 LOGO，你要是熟悉那就很容易知道这是我们的 GitHub Page，只不过我故意做了万圣节装修），另外就是在假文中的右下角藏了一个 SOMETHING HERE —— 这些线索代表这个东西藏在 GitHub Page 的右下角。

### C 题解谜

没什么特别的。

结合 A 题的结果，只是在告诉你你的界面是 `sekinya.html`。在哪里，自然是 B 题解出来的 GitHub Page。

### Page 解谜（假结局）

点页面右下角的 `lab530`，进入隐藏的 index2，点 hint 看到一个 416。

访问 <https://lab530.github.io/sekinya.html>，这是同 A 题的加密，解出来就是「Hi, I am Sekinya!」，没什么特别的。Sekinya 是个超链接，点开发现网址是 <https://lab530.github.io/gold-room-PASSWORD>，PASSWORD 对应的就是 416 了。

至此，达成假结局。

![fake](/images/posts/2022-Halloween-riddle/fake.png)

### Page 解谜（真结局）

第一处是真密码，藏在 hint 中。通过查看源码，发现是真密码的不透明度（opacity）被设置成了 0:

![ss1](/images/posts/2022-Halloween-riddle/ss1.png)

第二处是真链接，藏在 sekinya.html 中。同样是看源码，发现注释了一个超链接：

![ss2](/images/posts/2022-Halloween-riddle/ss2.png)

结合 `gold-room-PASSWORD` 的样子，猜测链接是 `return-613`。

访问真结局。

![true](/images/posts/2022-Halloween-riddle/true.png)

*（注：这里的时间不会实时更新，这是我用 Liquid 写的 now 的时间会在网站编译时静态生成导致的，bug）*

### 后日谈

> 此处省略，具体见 LAB530 GitHub Page

P.S.: sekinya 是 neta 只狼（sekiro）的只喵。

## 思考和反思

其实本次解谜活动出于多种目的吧，我在此可能列举不全，我把我现在能想到的写下来：

1. 我自己很有兴致。说是 1024 没有出活动的遗憾，其实是我自己的遗憾。我是很早就想自己出题做一会出题人了。加上最近补完了《海猫鸣泣之时》，对出题和解题这一组工作又是性情大增（这词好像不是这么用的），也算是我二次元之魂的一部分了（aka 中二）；
2. 宣传。我开始是没有想到这一步的，结果弄着弄着发现有着一层含义在，就类似于自己写了一篇文章，然后自己做阅读理解整出了更多的东西。这次活动涉及到我们的 OJ 平台和 GitHub Page，是非常好的宣传材料，有一些具体的设计细节我会在后文中提到；
3. 将自己的想法应用。万圣节是个很好的主题啊，GitHub 自己都装修了，正好有一些思路可以运用啊，借此活动顺带装修了一下两个 GitHub Page 的页面，改了改主题。对我自己的 GitHub Page 的工作主要还是解耦合。正式地将配色方案给独立出来的，以后就可以直接通过修改 `preset*` 变量来达到换主题色的目的了，非常方便。

然后稍微总结一下我个人觉得这次解谜设计比较精妙的地方吧：

1. 从打开链接开始谜题就开始了。最开始并没有给任何提示，公告只有一行密码，连进比赛的密码都要解谜，这是我专门设计的。所以我在解篇中将这一环节叫做「入场」；
2. 非线性流程。可以看到这次解谜的流程并不是线性的，即解开 A 得到线索解 B，而是将所有的已知内容都摊开，像是在玩解谜游戏（类似于 Rusty Lake series）一样。线索之间相互关联，只有解出了 A、B 再结合 C，联合起来想才能相处如果在 GitHub Page 里操作；
3. A、B 题意外地掉 san。这个是我意料之外的东西，A 是凯撒密码就是这样的，加上我比较喜欢大写字母，所以就弄了全大写（附录的代码中可以看到我原文是用正常的大小写写的），另外就是为了在这里多加一层 AES 之前的解谜，让 A 题变成了三层解谜，但是被 glt 说非常掉 san 之后，我自己看看好像确实是有点那个味道；B 的话是我为了避免版权（事实上谁会在乎这个）的问题特地在网络上搜索了一张 AI 生成的狗子图，这种似真实似虚假的东西，现在想想就像是「伪人」一样确实非常恐怖。当然正好也符合万圣节的闹鬼主题了；
4. A 的谜面。除了刚提到的三层谜题以外，我在刻意扮演「伪地球语」说的很烂的外星人，同时对一些助词的用法进行修改。关于将「I」这个第一人称主格换掉的建议是 glt 给出的，因为他一眼就猜出来「I」所对应的那个字母了；
5. 「第四维」解谜。这要请出我们的 B 题谜底了，B 题谜底给出的画面是在装修之前的 GitHub Page 界面，为了这次活动（表面上是为了万圣节），我把 LOGO 换成了一个南瓜头（是的，就是我自己的 GitHub Page 在万圣节主题里用的南瓜头，这属于素材复用），为了制造「第四维」解谜——时间，解谜者需要对之前的界面足够了解才能猜到是 Page。虽然这次有一些意外情况，会在后文再提到。
6. 对 GitHub Page 的利用。除了白嫖 GitHub 的服务器以外，为了防止有小聪明从 GitHub 的 commits 里面读出什么信息，我特别弄了 2k 个随机文件的「commit 加密」，这样解谜者就很难从 commit 信息或者说网站的源码中读出信息了。但是这个方法的作用微乎其微，后文中会提到。
7. 玩梗的点。很遗憾因为参加的人太少了，所以玩梗的效果并不好。

有精妙的地方那肯定就有我不满意的地方，基本上是跟优点点对点的对应吧：

1. 宣传作用没有起到。嗯，这个是硬伤，也是没办法，算是一种尝试吧，但是仍然很难调动起一群潜水佬的积极性。目的倒是不在我怎么还在牵挂过去的东西，而是这是一个很好的资源，嗯，类似于一个「甘城光辉游乐园」；
2. 流程和谜题的设计。内容不够紧凑，关联性不强，难度也参差不齐，这是第一次弄这个东西，我还是仁慈点给我自己打一个及格分。谜题的设计非常老套，或者说没什么设计吧。但是对于没见过的新人而言那可不就是跟我第一次见到这种东西一样兴奋吗，可惜不是所有人都像我一样对某些东西会产生热情；
3. 平台选的不好。但是这次本来主要还是要起到宣传作用的，不然不应该选择 GitHub。从网站的源码中可以读出大量信息的，甚至可以跳关。下次如果再弄的话，肯定就不会弄这样的公开仓库了；
4. A 题的加密。时间紧迫没有安排得特别细致，随便找了一个对称加密，用的 AES，到 31 号晚上了才发现，坏了，我这个网站加密的到其他网站又解不开了。只能白送我使用的加密网站作为线索了；
5. 提前在管理群泄漏了一个非常重要的线索，与 GitHub Page 有关。这导致后面被管理直接爆破，嗯，非常惨烈，就不多说了；
6. 文案设计得潦草。尤其是 A 题看似有个非常庞大的世界观，但是到后面却草草结尾。这也是时间限制造成的，整个的开发流程我只花了 2 个多小时，从出题到部署完毕；
7. 技术是我的硬伤。不会的东西太多，导致没办法设计一些更精妙的东西，一些我有想法的东西，但是却无法实现，确实是非常遗憾的事情。而且还开发出了 bug（没错，说的就是真结局的时间）。

大概只能想到这么多。

最后总结一下就是，尽量还是少过洋节，嗯。

## 附录：出题篇代码清单（归档）

desc.cc:

```cpp
#include <string>
#include <iostream>

int main()
{
    std::string s = "freak";
    for (auto&& c : s) {
        std::cout << std::hex << (int)c << std::endl;
    }
    return 0;
}
```

caesar.cc:

```cpp
#include <iostream>
#include <string>
#include <cctype>

char caesar(char c) {
    c += 12;
    if (c > 'Z') c -= 26;
    return c;
}

int main()
{
    std::string str = "Say Hi\n"
        "Hi there, ME am THA halloween king, ME do not use language from THA earth, because ME am an alien. Now ME am using MI national language and "
        "talking to you, if you have solved this message, ME guess you can understand MI meaning now? Let me tell you about MI homeland planet.\n"
        "MI homeland has only three colors, red, yellow, and blue. ME know there WERE a competition called ACM Programming on THA Earth, sure, "
        "WE planet adore YOU ACM, so we deleted WE colors on WE planet except these three one. "
        "And WE planet WERE called ACM star. WE citizens were eating ACM problems every ACM star day, oh, by THA way, am ACM star day WERE equal to 1.14514 Earth day. "
        "The problems they were eaten this day, THA solutions were created by THEY in THA next day. "
        "But nowadays we have a critical problem, it WERE THA earth Halloween, we must attack THA Earth, we do not have more time. "
        "You WERE THA spy of WE planet, and now you WERE on THA Earth and surfing on THA Internet, we spread this message for finding you.\n"
        "If you understand this message, do not try to reply and no need. You should only know YOU own codename, THAt WERE U2FsdGVkX19ep5SKS94gKW3VaGthyZx9DUFl7lyOClw=, "
        "THA special pozition WERE 4 5 8 12 13 20 25 27 28 29 31 36 38 39 42 43, no key. For safety, THA code name WERE encrypted. "
        "And This problem need you to output YOU codename by using THA Earth language, THA info below were fake.\n"
        "At last, do not believe anyone on the EARTH!\n\n"
        "Hi, I am sekinya!";

    for (auto& c : str) {
        if (isupper(c)) {
            c = caesar(c);
        } else if (islower(c)) {
            c = caesar(c - 32);
        }
    }

    std::cout << str << std::endl;

    return 0;
}
```

caesar_key.cc:

```cpp
#include <string>
#include <iostream>
#include <cctype>

int main()
{
    std::string code = "U2FsdGVkX19ep5SKS94gKW3VaGthyZx9DUFl7lyOClw=";
    for (int i = 0; i < code.length(); ++i) {
        if (std::islower(code[i])) {
            std::cout << i + 1 << " ";
        }
    }
    return 0;
}
```

pixel.py:

```python
import os
from PIL import Image

im1 = Image.open('dog.png')
im2 = Image.open('secret.png')

pixel1 = im1.load()
pixel2 = im2.load()

print(im1.size, im2.size)

for x in range(2048):
    for y in range(2048):
        if x % 8 == 0 and y % 8 == 0:
            r, g, b, a = im2.getpixel((x / 8, y / 8))
            rgba = (r, g, b, a)
            im1.putpixel((x, y), rgba)

im1 = im1.convert('RGB')
im1.save('output.png')
```
