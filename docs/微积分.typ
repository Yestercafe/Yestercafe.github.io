#set text(
  font: ("Source Han Serif SC", "Source Han Serif")
)
#set heading(numbering: "I.i.1-a")

#let tweet(bgcolor: green, text) = {
  box(width: 100%, inset: (x: 0.8em, y: 1em), fill: bgcolor.lighten(90%), [
    #text
  ])
}
#let warn(text) = {
  tweet(bgcolor: red, text)
}
#let example(text) = {
  tweet(bgcolor: blue, text)
}
#let attach(text) = {
  tweet(bgcolor: maroon, text)
}
#let important(text) = {
  tweet(bgcolor: yellow, text)
}
#let todo(text) = {
  tweet(bgcolor: black, text)
}


#{
  set align(center)
  strong(text(20pt)[微积分])
  set align(center)
  text[Ivan Chien]
}

#outline()

= 函数 极限 连续

== 函数

=== 初等函数

==== 反三角函数

+ $arcsin x$ 和 $arccos x$ 的定义域为 $[-1, 1]$
+ $arcsin x$ 的值域为 $[-pi / 2, pi / 2]$
+ $arccos x$ 的值域为 $[0, pi]$

== 极限

=== 两个重要极限

$ lim_(x->0) (sin x)/ x = 1 $
$ lim_(x->infinity) (1 + 1/x)^x = e $

=== 数列的极限

/ 定义: 对于 $forall epsilon > 0$，总 $exists$ 正整数 $N$，当 $n > N$ 时，恒有 $ |x_n - a| < epsilon $ 成立，则称常数 $a$ 为数列 ${x_n}$ 当 $n$ 趋于无穷时的#strong[极限]，记为 $ lim_(n->infinity) x_n = a $

=== 函数的极限

==== 自变量趋于无穷大时函数的极限

/ 定义: 对 $forall epsilon > 0$，总 $exists X > 0$，当 $x > X$ 时，恒有 $|f(x) - A| < epsilon$，则称常数 $A$ 为 $f(x)$ 当 $x -> +infinity$ 时的#strong[极限]，记为 $ lim_(x->+infinity) f(x) = A $
/ 定义: 对 $forall epsilon > 0$，总 $exists X > 0$，当 $x < -X$ 时，恒有 $|f(x) - A| < epsilon$，则称常数 $A$ 为 $f(x)$ 当 $x -> -infinity$ 时的#strong[极限]，记为 $ lim_(x->+infinity) f(x) = A $
/ 定义: 对 $forall epsilon > 0$，总 $exists X > 0$，当 $|x| > X$ 时，恒有 $|f(x) - A| < epsilon$，则称常数 $A$ 为 $f(x)$ 当 $x -> infinity$ 时的#strong[极限]，记为 $ lim_(x->infinity) f(x) = A $

==== 自变量趋于有限值时函数的极限

/ 定义: 对 $forall epsilon > 0$，总 $exists delta > 0$，当 $0 < |x - x_0| < delta$ 时，恒有 $|f(x) - A| < epsilon$，则称常数 $A$ 为 $f(x)$ 当 $x -> +infinity$ 时的#strong[极限]，记为 $ lim_(x->x_0) f(x) = A $

*注：*
+ $epsilon$ 用来刻画 $f(x)$ 与 $A$ 的接近程度，$delta$ 用来刻画 $x -> x_0$ 的极限过程
+ 该极限与 $f(x)$ 在 $x = x_0$ 处有无定义、值是多少无关，$f(x)$ 必须在 $x = x_0$ 的某去心邻域 $accent(U, circle)(x, delta)$ 处处有定义

#tweet[这里的 $|f(x) - A|$ 比任意的 $epsilon$ 都要小，$epsilon$ 可以小到非常小，所以说 $epsilon$ 是用来刻画两者的接近程度的；$f(x)$ 在某个去心邻域（会存在）中无限趋近于 $A$，$delta$ 具体等于多少也无所谓，它也可以无限小。]

/ 定义: 对 $forall epsilon > 0$，总 $exists delta > 0$，当 $x_0 - delta < x < x_0$ 时，恒有 $|f(x) - A| < epsilon$，则称常数 $A$ 为函数 $f(x)$ 当 $x -> x_0$ 时的#strong[左极限]，记为
$
lim_(x->x_0^-) f(x) = A
$
/ 定义: 对 $forall epsilon > 0$，总 $exists delta > 0$，当 $x_0 < x < x_0 + delta$ 时，恒有 $|f(x) - A| < epsilon$，则称常数 $A$ 为函数 $f(x)$ 当 $x -> x_0$ 时的#strong[右极限]，记为
$
lim_(x->x_0^+) f(x) = A
$

/ 定理: $lim_(x->x_0) f(x) = A "当且仅当" lim_(x->x_0^-) f(x) = A and lim_(x->x_0^+) f(x) = A$

#tweet[极限存在当且仅当左右极限都存在且相等。]

=== 极限的性质

/ 有界性: （数列）如果数列 ${x_n}$ 收敛，那么数列 ${x_n}$ 一定有界。\
  （函数）若 $lim_(x->x_0) f(x)$ 存在，则 $f(x)$ 在 $x_0$ 的某去心邻域有界（局部有界性）。
/ 保号性: （数列）设 $lim_(n->infinity) x_n = A$\
  (1) 如果 $A > 0 (A < 0)$，则 $exists N > 0$，当 $n > N$ 时，$x_n > 0 (x_n < 0)$。\
  (2) 如果 $exists N > 0$，当 $n > N$ 时，$x_n >= 0 (x_n <= 0)$，则 $A >= 0 (A <= 0)$。\
  （函数）设 $lim_(x->x_0) x_n = A$\
  (1) 如果 $A > 0 (A < 0)$，则 $exists delta > 0$，当 $x in accent(U, circle)(x_0, delta)$ 时，$f(x) > 0 (f(x) < 0)$。\
  (2) 如果 $exists delta > 0$，当 $x in accent(U, circle)(x, delta)$ 时，$f(x) >= 0 (f(x) <= 0)$，则 $A >= 0 (A <= 0)$（局部保号性）。

#warn[注意这里的等于号。]

=== 函数极限与数列极限的关系

/ 海因定理: 若 $lim_(x->x_0) f(x) = A$，则对任意数列 ${x_n}$，$lim_(n->infinity) x_n = x_0$，且 $x_n != x_0$，都有 $lim_(n->infinity) f(x_n) = A$。

=== 无穷小量与无穷大量

==== 无穷小量

/ 无穷小量: 若函数 $f(x)$ 当 $x->x_0$ 或 $x->infinity$ 时的极限为#strong[零]，则称 $f(x)$ 为此时的#strong[无穷小量]。

*性质：*
+ #strong[有限个]无穷小的和仍是无穷小
+ #strong[有限个]无穷小的积仍是无穷小
+ 无穷小量与#strong[有界量]的积仍是无穷小

#tweet[所以很多极限才可能通过简单的算术运算就得出结果啊。]

*比较：*
+ 若 $lim beta / alpha = 0$，则 $beta$ 是比 $alpha$ #strong[高阶的无穷小]，记作 $beta = o(alpha)$
+ 若 $lim beta / alpha = infinity$，则 $beta$ 是比 $alpha$ #strong[低阶的无穷小]
+ 若 $lim beta / alpha = c != 0$，则 $beta$ 和 $alpha$ 是#strong[同阶无穷小]
+ 若 $lim beta / alpha = 1$，则 $beta$ 和 $alpha$ 是#strong[等价无穷小]，记作 $alpha ~ beta$
+ 若 $lim beta / alpha^k = c != 0$，则 $beta$ 是 $alpha$ 的#strong[$k$ 阶无穷小]

*等价无穷小：*

当 $x -> 0$ 时，有：

- $sin x ~ x$
- $ln(1 + x) ~ x$
- $e^x - 1 ~ x$
- $1 - cos x ~ 1/2 x^2$
- $root(n, 1 + x) - 1 ~ 1/n x$

*极限值与无穷小之间的关系：*

$
lim f(x) = A <=> f(x) = A + alpha(x)
$

其中 $lim alpha(x) = 0$。

==== 无穷大量

/ 无穷大量: 若对于 $forall M > 0$，总 $exists delta > 0$，当 $0 < |x - x_0| < delta$ 时，恒有 $|f(x)| > M$，则称 $f(x)$ 为 $x -> x_0$ 时的#strong[无穷大量]，记为 $lim_(x->x_0) f(x) = infinity$。

*性质：*
+ #strong[两个]无穷大量的积仍为无穷大量
+ 无穷大量与#strong[有界变量]之和仍为无穷大量
+ 无穷大量与#strong[非零常数]乘积仍为无穷大量

#tweet[和不一定，比如 $y_1 = 1/x$ 和 $y_2 = -1/x$。]

*与无界变量的关系：*
+ 数列 ${x_n}$ 是无穷大量：$forall M > 0, exists N > 0$，当 $n > N$ 时，恒有 $|x_n| > N$。
+ 数列 ${x_n}$ 是无界变量：$forall M > 0, exists N > 0$，使 $|x_N| > M$。

#tweet[无穷大量必无界，无界变量不一定无穷大。]

#example[
举一个无界的例子：
$ lim_(x->0) 1/x^2 sin(1/x) $
使用海因定理，构造两个数列：
$ x_n = 1 / (2n pi + pi / 2) $
$ y_n = 1 / (2n pi) $
它们在 $x->infinity$ 的极限都为 0，可带入函数极限中，但得到的结果分别为：
$ lim_(n->infinity) 1 / ((x_n)^2) sin (1 / x_n) = +infinity $
$ lim_(n->infinity) 1 / ((y_n)^2) sin (1 / y_n) = 0 $
故这个函数极限的值不是无穷大，只是无界。
]

=== 极限的计算

若 $lim f(x) = a, lim g(x) = b$，则：
+ $lim [f(x) plus.minus g(x)] = lim f(x) plus.minus lim g(x) = a plus.minus b$
+ $lim [f(x) g(x)] = lim f(x) dot lim g(x) = a dot b$
+ $lim f(x)/g(x) = (lim f(x)) / (lim g(x)) = a / b (b != 0)$

*常用结论：*
+ $lim f(x) = A != 0 => lim f(x) g(x) = A lim g(x)$，#strong[极限非零]的因子的极限可以先求出来 
+ $lim f(x) / g(x) "存在", lim g(x) = 0 => lim f(x) = 0$
+ $lim f(x) / g(x) = A != 0, lim f(x) = 0 => lim g(x) = 0$
+ $lim_(x->0) (a^x - 1)/x = ln a$
+ $lim_(n->infinity) root(n, n) = 1, lim_(n->infinity) root(n, a) = 1 (a > 0)$

#tweet[
各种未定式的求法考虑以下：
+ 有理化
+ 通分
+ 化为第两重要极限（主要是 $1^infinity$ 型）
其实是废话？
]

==== 第一重要极限

$ lim_(x->0) (sin x) / x = 1 $

#tweet[这里其实还告诉你了可以用无穷小比阶来算某些 $0/0$ 形的结果。所以像 $lim_(x->0) (1 - cos x) / x^2 = 1/2$ 这种也是成立的。]

==== 第二重要极限

$ lim_(n->infinity) (1 + 1/n)^n = e "（数列极限）" $
$ lim_(x->infinity) (1 + 1/x)^x = e $
$ lim_(x->0) (1 + x) ^ (1/x) = e "(a)" $

#tweet[这里同样可以将 (a) 式中的 $x$ 换成无穷小量。]

$ lim_(x->infinity) (1 - 1/x)^x = 1/e $
$ lim_(x->infinity) (1 + a / x)^(b x+c) = e^(a b) $

#attach[第一重要极限是 $0/0$ 型，第二重要极限是 $1^infinity$ 型。]

#tweet[
求幂指函数 $f(x)^(g(x))$ 的极限，常用以下方法：
+ 利用 $f(x)^(g(x)) = e^(g(x) ln f(x))$
+ 若为 $1^infinity$ 型，可利用第二重要极限
+ 若 $lim f(x) = A > 0, lim g(x) = B$，则 $lim f(x)^(g(x)) = A^B$
]

==== 等价无穷小替换

/ 等价无穷小替换定理: 设 $f_1(x) ~ f_2(x), g_1(x) ~ g_2(x)$，且 $lim (f_2(x)) / (g_2(x))$ 存在，则
 $ lim (f_1(x)) / (g_1(x)) = lim (f_2(x)) / (g_2(x)) $

#warn[
注意没有在加减里做等价无穷小替换的定理。

但有推论：\
- 若 $alpha ~ alpha_1, beta ~ beta_1$，且 $lim alpha_1 / beta_1 = A != 1$，则 $ alpha - beta ~ alpha_1 - beta_1$
- 若 $alpha ~ alpha_1, beta ~ beta_1$，且 $lim alpha_1 / beta_1 = A != -1$，则 $ alpha + beta ~ alpha_1 + beta_1$

即两个函数相减，能对这两个函数分别做无穷小替换，当且仅当这两个函数互相不是等价无穷小。比如 $x - sin x$ 就不能换成 $x - x = 0$，因为很显然 $x$ 和 $sin x$ 是等价无穷小。

最好还是别用。
]

#important[
*常用等价无穷小：*

当 $x -> 0$ 时：
+ $x ~ sin x ~ tan x ~ arcsin x ~ arctan x$
+ $1 - cos x ~ 1/2 x^2$
+ $ln(1 + x) ~ x, e^x - 1 ~ x, a^x - 1 ~ x ln a$
+ $(1 + x)^alpha - 1 ~ alpha x (alpha != 0) "（"alpha" 为 "1/n" 做开方时一样有效）"$
+ $sqrt(1 + x) - sqrt(1 - x) ~ x$
#attach[这里的 $x$ 都换成无穷小量 $alpha(x)$ 一样成立。]
]

==== 洛必达法则

/ 洛必达法则: 若\
  (1) $lim_(x->x_0) f(x) = lim_(x->x_0) g(x) = 0 "或" infinity$\
  (2) $f(x)$ 和 $g(x)$ 在 $x_0$ 的某去心邻域内可导，且 $g'(x) != 0$\
  (3) $lim_(x->x_0) (f'(x))/(g'(x))$ 存在（或 $infinity$）\
  则：
  $ lim_(x->x_0) (f(x))/(g(x)) = lim (f'(x))/(g'(x)) $

#tweet[洛必达限制条件还挺多的。]

#tweet[
给出求七种未定式的方法：
+ $0/0, infinity/infinity$ 型，用洛必达
+ $0 dot infinity$，化为商，变成情况 1
+ $infinity plus.minus infinity$，通分或有理化，变成情况 1
+ $1^infinity, infinity^0, 0^0$，拆成 $e^ln$ 指数化为 $0 dot infinity$，变成情况 2
]

==== 夹逼准则

/ 夹逼准则: 若函数 $f(x), g(x), h(x)$ 满足：\
  (1) $g(x) <= f(x) <= h(x)$\
  (2) $lim_(x->x_0) g(x) = lim_(x->x_0) h(x) = A$\
  则 $lim_(x->x_0) f(x) = A$。

==== 泰勒公式

/ 定理: （带皮亚诺余项的泰勒公式）设 $f(x)$ 在 $x=x_0$ 处 $n$ 阶可导，则\
  $ f(x) = f(x_0) + f'(x_0) (x - x_0) + (f''(x_0)) / (2!) (x - x_0)^2 + dots + (f^((n))(x_0)) / (n!) (x - x_0)^n + o(x - x_0)^n $\
  特别的，当 $x_0 = 0$ 时，有：\
  $ f(x) = f(0) + f'(0) x + (f''(0)) / (2!) x^2 + dots + (f^((n))(0)) / (n!) x^n + o(x^n) $


#important[
*常用的泰勒公式：*

$ e^x = 1 + x + x^2/(2!) + dots + x^n/(n!) + o(x^n) $
$ sin x = x - x^3/(3!) + dots + (-1)^(n-1) x^(2n - 1) / ((2n - 1)!) + o(x^(2n-1)) $
$ cos x = 1 - x^2/(2!) + dots + (-1)^n x^(2n) / ((2n)!) + o(x^(2n)) $
$ ln(1 + x) = x - x^2/2 + dots + (-1)^(n-1) x^n/n + o(x^n) $
$ (1+x)^alpha = 1 + alpha x + (alpha (alpha + 1)) / (2!) x^2 + dots + (alpha (alpha - 1) dots (alpha - n + 1)) / (n!) x^n + o(x^n) $
]

== 连续性

/ 定义: 设 $y = f(x)$ 在点 $x_0$ 的某邻域内有定义，若：\
  $ lim_(Delta x -> 0) Delta y = lim_(Delta x -> 0) [f(x_0 + Delta x) - f(x_0)] = 0 $\
  则称 $y = f(x)$ #strong[在点 $x_0$ 处连续]，并称 $x_0$ 为 $f(x)$ 的连续点。

/ 定义: 设 $y = f(x)$ 在点 $x_0$ 的某邻域内有定义，若 $lim_(x->x_0) f(x) = f(x_0)$，则称 $y = f(x)$ #strong[在点 $x_0$ 处连续]，$x_0$ 为 $f(x)$ 的连续点。

#tweet[
用人话讲就是：
+ $f(x)$ 在 $x = x_0$ 处要有定义
+ $f(x)$ 在 $x -> x_0$ 的极限要存在
+ 而且这两个值要相等

这三条与连续#strong[互为充要]。

#attach[
另外，连续是可以推极限存在的。\
连续也分左连续和右连续，充要也跟左右极限相仿。]

#important[
连续可以推出极限值和函数值相等。
]

]


/ 定义: 在开闭区间内的连续，非常 make sense，就不写了。

=== 运算

/ 四则运算: 若函数 $f(x)$ 和 $g(x)$ 在 $x_0$ 处都连续，则四则运算后的结果在 $x_0$ 处也连续。

/ 复合函数连续性: 如果函数 $u = phi(x)$ 在点 $x = x_0$ 处连续，$phi(x_0) = u$。而函数 $y = f(u)$ 在点 $u = u_0$ 处连续，则复合函数 $y = f[phi(x)]$ 在 $x = x_0$ 处连续。

#important[
复合函数的连续性能带来下面的效果：\
对于良定义下的 $f$ 和 $phi$，有：\
$ lim_(x->x_0) f[phi(x)] = f[lim_(x->x_0) phi(x)] = f(u_0) $\
即当 $f$ 连续时，才可以交换 $f$ 和极限的次序。
]

/ 反函数连续: 设函数 $y = f(x)$ 在某区间上连续，且单调增加（减少），则它的反函数 $y = f^(-1)(x)$ 在对应区间上连续，且#strong[单调性相同]。

=== 初等函数的连续性

基本初等函数在其定义域内都连续。

初等函数在其定义区间内都连续。

#tweet[这里说定义区间是要考虑比如初等函数组成的分段函数。]

#example[
结合上面说的举例一个函数：$y = |f(x)|$（讨论 $x = x_0$ 处），因为 $y = |f(x)| = sqrt(f^2(x))$，首先基本初等函数在定义域上都连续，然后复合函数又能连续，所以 $y = |f(x)|$ 在连续。\
\
再讨论一个命题：
/ 命题: 若 $f(x)$ 在 $x_0$ 处连续，$f(x_0) != 0$，且 $f(x) g(x)$ 在 $x_0$ 处连续，则 $g(x)$ 在 $x_0$ 处连续。
这是一个真命题，构选 $g(x) = (f(x) g(x)) / f(x)$ 即可。
]

=== 间断点

/ 定义: 间断点其实就是不连续。
  左右极限都存在的间断点被称为#strong[第一类间断点]，其它的就是#strong[第二类间断点]。

=== 闭区间上连续函数的性质

/ 最值定理: $f(x)$ 在闭区间上连续，那在这个区间内必有最大最小值。

/ 有界性定理: 同上。

/ 介值定理: $f(x)$ 在闭区间 $[a, b]$ 上连续，且 $f(a) != f(b)$，则对于任意介于 $f(a)$ 与 $f(b)$ 之间的数 $C$，至少存在一点 $xi in (a, b)$, 使得 $f(xi) = C$。

/ 零点定理: $f(x)$ 在闭区间 $[a, b]$ 上连续，且 $f(a) dot f(b) < 0$，则至少存在一点 $xi in (a, b)$，使 $f(xi) = 0$。

#todo[这部分主要跟证明相关，暂时略过。]

= 一元函数微分学

== 导数

/ 导数: 设函数 $y = f(x)$ 在 $x_0$ 在某邻域内有定义，如果极限
  $ lim_(Delta x -> 0) (Delta y)/(Delta x) = lim_(Delta x -> 0) (f(x_0 + Delta x) - f(x_0))/(Delta x) $
  存在，则称 $f(x)$ #strong[在点 $x_0$ 处可导]，并称此极限值为 $f(x)$ #strong[在 $x_0$ 处的导数]，记为 $f'(x_0)$，或 $y'\|_(x-x_0)$，或 $(d y)/(d x)\|_(x=x_0)$；如果上述极限不存在，则称 $f(x)$ 在点 $x_0$ 处不可导。

#attach[
$ f'(x_0) = lim_(x->x_0) (f(x) - f(x_0))/(x - x_0) = lim_(h->0) (f(x_0 + h) - f(x_0)) / h $
]

导数也分左右，make sense。

/ 区间上可导及导函数: make sense

=== 导数的几何意义

有良定义下的 $f(x)$，若 $f(x)$ 在点 $x_0$ 处可导，则曲线 $f(x)$ 在点 $(x_0, f(x_0))$ 处必有切线，方程为：
$ y - f(x_0) = f'(x_0)(x - x_0) $

$ cases(
  f(x_0) != 0"，同一位置的法线方程为" y - f(x_0) = - 1 / (f'(x_0)) (x - x_0),
  f(x_0) = 0"，同一位置的法线方程为" x = x_0,
) $

#tweet[有导数仅是有切线的充分条件。]

== 微分

/ 微分: 设函数 $y = f(x)$ 在点 $x_0$ 的某一邻域内有定义，如果函数的增量 $Delta y = f(x_0 + Delta x) - f(x_0)$ 可以表示为
  $ Delta y = A Delta x + o(Delta x), (Delta x -> 0) $\
  其中 $A$ 为不依赖于 $Delta x$ 的常数，$o(Delta x)$ 是 $Delta x$ 高阶无穷小。则称函数 $y = f(x)$ 在点 $x_0$ 处#strong[可微]，并称 $Delta y$ 的#strong[线性主部] $A Delta x$ 为函数 $y = f(x)$ 在点 $x_0$ 处的#strong[微分]，记作 $d y, d f(x)$ 即：
  $ d y = A Delta x $

/ 定理: 函数 $y = f(x)$ 在点 $x_0$ 处可微的充分必要条件是 $f(x)$ 在点 $x_0$ 处可导，且有
  $ d y = f'(x_0) Delta x = f'(x_0) d x $\
  在点 $x$ 处，常记 $d y = f'(x) d x$

=== 微分的几何意义

微分 $d y = f'(x_0) d x$ 在几何上表示曲线 $y = f(x)$ 的切线上的点的纵坐标的增量。

$Delta y = f(x_0 + Delta x) - f(x_0)$ 在几何上表示曲线 $y = f(x)$ 上的点的纵坐标的增量。

当自变量的增量 $|Delta x|$ 充分小时，$Delta y approx d y$。

#tweet[微分是估计的增量，$Delta$ 是实际的增量，当自变量增量足够小的时候，这两个的差就能几乎为 $0$（$o(Delta x)$）。]

== 连续、可导、可微之间的关系

/ 定理: 若函数 $y = f(x)$ 在点 $x_0$ 处可导，则 $f(x)$ 在点 $x_0$ 处连续。

#tweet[可导仅是连续的充分条件。]

/ 定理: 可导 $<=>$ 可微。

== 导数的计算

基本初等函数的导数公式、四则运算求导、链式法则略。

#tweet[
注意符号含义：\
$[f(ln x)]'$ 是指先应用再求导，要用链式法则；\
$f'(ln x)$ 是指先对 $f(u)$ 求导再应用 $u = ln x$，相当于 $f'(u)\|_(u=ln x)$。\
于是，$ [f(ln x)]' = f'(ln x) dot (ln x)' $
]

=== 反函数求导法则

对良定义的 $y = f(x)$，其反函数 $x = phi(y)$ 在对应的区间内可导，且

$ (d x) / (d y) = 1 / ((d y) / (d x)) "即" phi'(y) = 1 / (f'(x)) $

即，互为反函数的导数互为倒数。

注意分母不应为 0.

=== 隐函数求导

对隐函数 $F(x, y) = 0$，求导方法有二：
+ 对等式两边的 $x$ 求导，要记住 $y$ 是关于 $x$ 的函数
+ 亦可用多元函数微分法的
$ (d y)/(d x) = - (F'_x) / (F'_y) $

=== 参数方程确定的函数求导法

设 $y = y(x)$ 是由参数方程 $cases(x = phi(t), y = psi(t))$ 所确定的函数，其中 $phi(t)$ 和 $psi(t)$ 都可导，且 $phi'(t) != 0$，则：
$ (d y) / (d x) = ((d y) / (d t)) / ((d x) / (d t)) = (psi'(t)) / (phi'(t)) $

=== 重要结论

+ 可导的偶函数的导函数是奇函数
+ vice versa
+ 可导周期函数的导函数周期不变

=== 高阶导数

#tweet[
这个符号\
$ (d^2 y) / (d x^2) $\
是
$ d (d y) / (d x)^2 = d / (d x) (d y) / (d x) $\
的意思，所以是这么写的。
]

*莱布尼兹公式：*
$
[u(x) v(x)]^((n)) &= sum_(i=0)^n binom(n, i) u^((n - i))(x) dot v^((i))(x)
$

=== 微分的计算

若函数 $y = f(x)$ 可微，则其微分计算公式为：
$ d y = f'(x) d x $

/ 一阶微分形式不变性: 设 $y = f(u)$ 对 $u$ 可导，$u = phi(x)$ 可导，则复合函数 $y = f(phi(x))$ 的微分为
  $ d y = f'(phi(x)) d phi(x) = f'(phi(x)) phi'(x) d x $\
  $y = f(u)$ 总是能写成 $d y = f'(u) d u$ 的形式。

== 中值定理、不等式与零点问题

/ 费马定理: 设 $f(x)$ 在 $x = x_0$ 的某邻域 $U(x_0)$ 内有定义，$f(x_0)$ 是 $f(x)$ 的一个极大（极小）值，又设 $f'(x_0)$ 存在，则 $f'(x_0) = 0$。费马定理是可导下极值点的必要条件。

/ 罗尔定理: 设 $f(x)$ 在闭区间 $[a, b]$ 上连续，在开区间 $(a, b)$ 上可导，又设 $f(a) = f(b)$，则至少存在一点 $xi in (a, b)$ 使 $f'(xi) = 0$。

#tweet[
这里是“在闭区间上连续，在开区间可导”第一次出现，后文中可能会出现千奇百怪的省略叫法。当然我这里想表达的其实是，大家指的区间都是 $[a, b]$ 和 $(a, b)$。
]

/ 拉格朗日中值定理: 设 $f(x)$ 在闭区间上连续在开区间上可导，则至少存在一点 $xi in (a, b)$ 使 $f(b) - f(a) = f'(xi) (b - a)$。

/ 柯西中值定理: 有良定义 $f(x), g(x)$，$g'(x) != 0, x in (a, b)$，则至少存在一点 $xi in (a, b)$ 使
  $ (f(b) - f(a)) / (g(b) - g(a)) = (f'(xi)) / (g'(xi)) $

#todo[证明方法相关暂且不看。]

== 函数应用

=== 单调性

设 $f(x)$ 闭连开导，
+ 若在 $(a, b)$ 内 $f'(x) > 0$，则 $f(x)$ 在 $[a, b]$ 上单调增
+ 若在 $(a, b)$ 内 $f'(x) < 0$，则 $f(x)$ 在 $[a, b]$ 上单调减

=== 极值

/ 定义: 设 $y = f(x)$ 在点 $x_0$ 的某邻域内有定义，如果对于该领域内任何 $x$，恒有 $f(x) <= f(x_0)$（或 $f(x) >= f(x_0)$），则称 $x_0$ 为 $f(x)$ 的#strong[极大值点]（或#strong[极小值点]）。导数为 0 的点称为#strong[驻点]。

/ 极值的必要条件: 设 $y = f(x)$ 在点 $x_0$ 处可导，如果 $x_0$ 为 $f(x)$ 的极值点，则 $f'(x_0) = 0$。

#tweet[可导+取极值=导为 0]

/ 极值的第一充分条件: 设 $y = f(x)$ 在点 $x_0$ 的某动心领域内可导，且 $f'(x_0) = 0$，或 $f(x)$ 在 $x_0$ 处连续：\
  (1) 若 $x < x_0$ 时，$f'(x) > 0$，$x > x_0$ 时，$f'(x) < 0$，则 $x_0$ 为 $f(x)$ 的极大值点\
  (2) 反之取极小值点\
  (3) 若两侧同号，则不为极值点\

/ 极值的第二充分条件: 设 $y = f(x)$ 在点 $x_0$ 处二阶可导，且 $f'(x_0) = 0$：\
  (1) 若 $f''(x_0) < 0$，则 $x_0$ 为 $f(x)$ 的极大值点
  (2) 反之取极小值点\
  (3) 如果二阶导数等于 0 则无法判断

=== 最值

最值定义 make sense。

连续函数 $f(x)$ 在闭区间 $[a, b]$ 上的最大最小值：\
第一步：求出 $f(x)$ 在开区间 $(a, b)$ 内的#strong[驻点]和#strong[不可导点]\
第二步：求出这些点对应的函数值\
第三步：做 max，非常 make sense

=== 凹凸性

/ 定义: 设函数 $f(x)$ 在区间 $I$ 上连续，如果对 $I$ 上任意两点 $x_1, x_2$ 恒有\
  $ f((x_1 + x_2) / 2) < (f(x_1) + f(x_2)) / 2 $\
  则称 $f(x)$ 在 $I$ 上的图形是凹的；如果恒有\
  $ f((x_1 + x_2) / 2) > (f(x_1) + f(x_2)) / 2 $\
  则称 $f(x)$ 在 $I$ 上的图形是凸的。

#warn[
注意在国内高等数学的范围内函数是上凸下凹的。
]

/ 定理: 设函数 $y = f(x)$ 在 $[a, b]$ 上连续，在 $(a, b)$ 内二阶可导，那么：\
  (1) 若在 $(a, b)$ 内有 $f''(x) > 0$，则 $f(x)$ 在 $[a, b]$ 上的图形是凹的\
  (2) 反之则为凸的

=== 拐点

/ 拐点: 连续曲线弧上的凹与凸的分界点称为曲线弧的#strong[拐点]

/ 必要条件: 设 $y=f(x)$ 在点 $x_0$ 处二阶可导，且点 $(x_0, f(x_0))$ 为曲线 $y = f(x)$ 的拐点，则 $f''(x_0) = 0$

/ 第一充分条件: 设 $y = f(x)$ 在点 $x_0$ 的某去心领域内二阶可导，且 $f''(x_0) = 0$，或 $f(x)$ 在 $x_0$ 处连续：\
  (1) 若 $f''(x)$ 在 $x_0$ 的左、右两侧异号，则点 $(x_0, f(x_0))$ 为曲线 $y = f(x)$ 的拐点\
  (2) 同号则#strong[不为]

/ 第二充分条件: 设 $y = f(x)$ 在点 $x_0$ 处三阶可导，且 $f''(x_0) = 0$：\
  (1) 若 $f'''(x_0) != 0$，则点 $(x_0, f(x_0))$ 为曲线 $y = f(x)$ 为拐点\
  (2) 反之#strong[不能判断]

=== 渐近线

#tweet[不关心定义。]

/ 水平渐近线: 若 $lim_(x->infinity) f(x) = A$（或 $lim_(x->-infinity) f(x) = A$ 或 $lim_(x->+infinity) f(x) = A$，那么 $y = A$ 是曲线 $y = f(x)$ 水平渐近线。

/ 垂直渐近线: 若 $lim_(x->x_0) f(x) = infinity$（或 $lim_(x->-x_0) f(x) = infinity$ 或 $lim_(x->+x_0) f(x) = infinity$，那么 $y = A$ 是曲线 $y = f(x)$ 水平渐近线。

/ 斜渐近线: 若 $lim_(x->infinity) f(x) / x = a$ 且 $lim_(x->infinity) (f(x) - a x) = b$（或 $x->infinity$，或 $x->+infinity$），那么 $y = a x + b$ 是曲线 $y = f(x)$ 的斜渐近线。

=== 弧微分与曲率

/ 弧微分: 设 $y = f(x)$ 在 $(a, b)$ 内有连续导数，则有#strong[弧微分]\
  $ d s = sqrt(1 + y'^2) d x $

/ 曲率: 设 $y = f(x)$ 在二阶导数，则有#strong[曲率]\
  $ K = (|y''|) / (1 + y'^2) ^ (3/2) $\
  同时称 $rho = 1 / K$ 为曲率半径。

/ 定义: 若曲线 $y = f(x)$ 在点 $M(x, y)$ 处的曲率为 $K, K != 0$。在点 $M$ 处曲线的法线上，在曲线凹的一侧取一点 $D$，使 $|D M| = rho$，以 $D$ 为圆心，$rho$ 为半径的圆称为曲线在点 $M$ 处的#strong[曲率圆]，圆心 $D$ 称为曲线在点 $M$ 处的#strong[曲率中心]。

= 一元函数积分学



