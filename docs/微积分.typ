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
#let addition(text) = {
  tweet(bgcolor: maroon, text)
}
#let important(text) = {
  tweet(bgcolor: yellow, text)
}
#let todo(text) = {
  tweet(bgcolor: black, text)
}
#let col2(a, b, gutter: 50pt) = {
  set align(center)
  grid(columns: 2, column-gutter: gutter, a, b)
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

=== 单调有界准则

/ 单调有界准则: 单调有界数列必收敛。

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

#addition[第一重要极限是 $0/0$ 型，第二重要极限是 $1^infinity$ 型。]

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
#addition[这里的 $x$ 都换成无穷小量 $alpha(x)$ 一样成立。]
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

#addition[
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

=== 判断有界

+ 若 $f(x)$ 在闭区间 $[a, b]$ 上#strong[连续]，则 $f(x)$ 在 $[a, b]$ 上有界（有界性定理）
+ 若 $f(x)$ 在开区间内#strong[连续]，且 $lim_(x->a^+) f(x), lim_(x->b^-) f(x)$ 都存在，则 $f(x)$ 在 $(a, b)$ 内有界，$(a, b)$ 为无穷区间也成立
+ 若 $f'(x)$ 在有限区间 $(a, b)$ 内有界，则 $f(x)$ 在 $(a, b)$ 内有界

= 一元函数微分学

== 导数

/ 导数: 设函数 $y = f(x)$ 在 $x_0$ 在某邻域内有定义，如果极限
  $ lim_(Delta x -> 0) (Delta y)/(Delta x) = lim_(Delta x -> 0) (f(x_0 + Delta x) - f(x_0))/(Delta x) $
  存在，则称 $f(x)$ #strong[在点 $x_0$ 处可导]，并称此极限值为 $f(x)$ #strong[在 $x_0$ 处的导数]，记为 $f'(x_0)$，或 $y'\|_(x-x_0)$，或 $(d y)/(d x)\|_(x=x_0)$；如果上述极限不存在，则称 $f(x)$ 在点 $x_0$ 处不可导。

#addition[
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

/ 柯西中值定理: 设有闭连开导的 $f(x), g(x)$，$g'(x) != 0, x in (a, b)$，则至少存在一点 $xi in (a, b)$ 使
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

#tweet[
水平渐近线和斜渐近线不会同时存在。
]

=== 弧微分与曲率

/ 弧微分: 设 $y = f(x)$ 在 $(a, b)$ 内有连续导数，则有#strong[弧微分]\
  $ d s = sqrt(1 + y'^2) d x $

/ 曲率: 设 $y = f(x)$ 在二阶导数，则有#strong[曲率]\
  $ K = (|y''|) / (1 + y'^2) ^ (3/2) $\
  同时称 $rho = 1 / K$ 为曲率半径。

/ 定义: 若曲线 $y = f(x)$ 在点 $M(x, y)$ 处的曲率为 $K, K != 0$。在点 $M$ 处曲线的法线上，在曲线凹的一侧取一点 $D$，使 $|D M| = rho$，以 $D$ 为圆心，$rho$ 为半径的圆称为曲线在点 $M$ 处的#strong[曲率圆]，圆心 $D$ 称为曲线在点 $M$ 处的#strong[曲率中心]。

= 一元函数积分学

/ 定义: 设 $F'(x) = f(x), x in (a, b)$，则称 $F(x)$ 为 $f(x)$ 在 $(a, b)$ 上的一个原函数。后方中省略“在 $(a, b)$ 上”。

$f(x)$ 的原函数族表示 $f(x)$ 的#strong[不定积分]，记成

$
integral f(x) d x = F(x) + C
$

不定积分和导数在某种意义上互为逆运算。

/ 定积分: 按定积分的老传统做分割，当下面的右式极限存在时，则称 $f(x)$ 在 $[a, b]$ 上可积，并称之为 $[a, b]$ 上的定积分
  $ integral_a^b f(x) d x = lim_(lambda -> 0) sum_(i = 1)^n f(xi_i) Delta x_i $
  其中 $lambda = limits(max)_(1 <= i <= n){Delta x_i}$。

== 基本性质

定积分的几何意义就是围成曲面梯形的面积。

- 常规的求反、加减、系数、拼接等
- 若 $f(x) <= g(x), a <= b$，则 $integral_a^b f(x) d x <= integral_a^b g(x) d x$
- 若有在闭区间 $[a, b]$ 上连续的 $f(x), g(x)$，$f(x) <= g(x)$，且至少存在点 $x_1, a <= x_1 <= b$，使 $f(x_1) < g(x_1)$，则 $integral_a^b f(x) d x < integral_a^b g(x) d x$

#tweet[简单说就是这个区间内只要有一处是 $f(x) < g(x)$，就会破坏 $integral f(x) = integral g(x)$ 的可能，使之缩窄为 $integral f(x) < integral g(x)$]

- 加强的#strong[积分中值定理]：设 $f(x)$ 在 $[a, b]$ 上连续，则至少存在一点 $xi in (a, b)$ 使
  $ integral_a^b f(x) d x = f(xi) (b - a) $ 

/ 定积分存在定理:
  (1) 设 $f(x)$ 在 $[a, b]$ 上连续，则 $integral_a^b f(x) d x$ 存在\
  (2) 设 $f(x)$ 在 $[a, b]$ 上有界，且只有有限个间断点，则 $integral_a^b f(x) d x$ 存在

/ 原函数存在定理: 设 $f(x)$ 在 $[a, b]$ 上连续，则在 $[a, b]$ 上必存在原函数。

#addition[
+ 如果不连续则不一点存在原函数。
+ 初等函数在定义区间上都连续，但是它们的原函数不一定能表示成初等函数。
]

=== 变限积分

/ 定义: 设 $f(x)$ 在 $[a, b]$ 上可积，对 $x in [a, b]$，$f(x)$ 在 $[a, x]$ 上可积，于是\
  $ Phi(x) = integral_a^x f(t) d t, x in [a, b] $\
  定义了一个以 $x$ 为自变量的函数，称为#strong[变上限的定积分]；\
  类似地，定义#strong[变下限的定积分]为\
  $ Phi(x) = integral_x^b f(t) d t, x in [a, b] $\
  统称为#strong[变限积分]。

设一在闭区间 $[a, b]$ 上连续的 $f(x)$，则 $(integral_a^x f(t) d t)'_x = f(x), x in [a, b]$。由此，$integral_a^x f(t) d t$ 是 $f(x)$ 的一个原函数，所以有
$
integral f(x) d x = integral_a^x f(x) d t + C
$


/ 牛顿-莱布尼茨定理: 设 $f(x)$ 在 $[a, b]$ 上连续，$F(x)$ 是 $f(x)$ 的一个原函数，则\
  $ integral_a^b f(x) d x = F(x) \|_a^b = F(b) - F(a) $

#tweet[前有莱布尼兹公式，现有牛顿-莱布尼茨定理，我寻思这两不是一个人？]

计算公式：

$
d / (d x) integral_(psi(x))^(phi(x)) f(t) d t = f(phi(x)) phi'(x) - f(psi(x)) psi'(x)
$


== 不定积分与定积分的计算

=== 基本积分公式

提供一部分作为 cheatsheet：

#col2(
$ integral tan x d x = -ln abs(cos x) + C $,
$ integral cot x d x = -ln abs(sin x) + C $
)
#col2(
$ integral sec x d x = ln abs(sec x + tan x) + C $,
$ integral csc x d x = ln abs(csc x - cot x) + C $
)
#col2(
$ integral 1 / (a^2 + x^2) d x = 1/a arctan x/a + C $,
$ integral 1 / (a^2 - x^2) d x = 1 / (2a) ln abs((a + x) / (a - x)) + C $
)
#col2(
$ integral 1 / sqrt(a^2 - x^2) d x = arcsin x/a + C $,
$ integral 1 / sqrt(x^2 plus.minus a^2) d x = ln abs(x + sqrt(x^2 plus.minus a^2)) + C $
)

=== 基本积分方法

==== 凑微分法（第一换元法）

设 $f(u)$ 连续，$phi(x)$ 具有连续的一队导数，则有公式：
$
integral f(phi(x)) phi'(x) d x = integral f(phi(x)) d phi(x) attach(limits(=), t: 令 phi(x) = u) integral f(u) d u
$

==== 换元积分法（第二换元法）

设 $f(x)$ 连续，$x = phi(t)$ 具有连续导数 $phi'(t)$，且 $phi'(t) != 0$，则
$
integral f(x) d x attach(limits(=), t: x = phi(t)) lr((integral f(phi(t)) phi'(t) d t) |)_(t = psi(x))
$

其中 $t = psi(x)$ 是 $x = phi(t)$ 的反函数。

==== 常见典型换元

- $integral R(x, sqrt(a^2 - x^2)) d x, integral R(x, sqrt(x^2 plus.minus a^2))$ 型，$a > 0$：\
  + 含 $sqrt(a^2 - x^2)$，令 $x = a sin t, d x = a cos t d t$\
  + 含 $sqrt(x^2 + a^2)$，令 $x = a tan t, d x = a sec^2 t d t$\
  + 含 $sqrt(x^2 - a^2)$，令 $x = a sec t, d x = a sec t tan t d t$\
- $integral R(x, root(n, a x + b), root(m, a x + b)) d x$ 型，$a != 0$：\
  令 $root(m n, a x + b) = t, x = (t^(m n) - b) / a, d x = (m n) / a t^(m n - 1) d t$
- $integral R(x, sqrt((a x + b)/(c x + d)))$ 型\
  令 $sqrt((a x + b)/(c x + d)) = t, x = (d t^2 - b)/(a - c t^2), d x = (2(a d - b c) t) / (a - c t^2)^2 d t$，其中设 $a d - b c != 0$
- $integral R(sin x, cos x) d x$ 型（万能代换#text(red)[但变复杂警告]）\
  令 $tan x/2 = t$，则 $sin x = (2t) / (1 + t^2), cos x = (1 - t^2) / (1 + t^2), d x = 2 / (1 + t^2) d t$

#tweet[分段函数分段积分，但在分段点处，原函数可导，一定连续，因为面积只可能连续变换。]

==== 定积分的换元积分

设 $f(x)$ 在 $[a, b]$ 上连续，$x = phi(t)$ 满足条件：$a = phi(alpha), b = phi(beta)$，并且当 $t$ 在以 $alpha, beta$ 为端点的闭区间 $I$ 上变动时，$a <= phi(t) <= b$，$phi'(t)$ 连续，则有定积分的换元积分公式
$
integral_a^b f(x) d x = integral_alpha^beta f(phi(t)) phi'(t) d t
$

#tweet[
注意这里求 alpha 和 beta 类似 pattern matching：\
#col2(
$ phi(alpha) = a $,
$ phi(beta) = b $,
gutter: 75pt
)
是要求 $phi(square) = a$ 这里应该填什么，而不是 $phi(a) = square$ 这里的结果是什么。
]

==== 分部积分

/ 分部积分法: 设 $u(x), v(x)$ 均有连续导数，则\
  $ integral u(x) d v(x) = u(x) v(x) - integral v(x) d u(x) $\
  对于定积分：
  $ integral_a^b u(x) d v(x) = u(x) v(x) \|_a^b - integral_a^b v(x) d u(x) $

#tweet[
常见用分部积分的型：
- $e^x, sin x, cos x$ 与 $x^n$ 的积考虑把前者拿到后面
- $ln x, arctan x, arcsin x$ 与 $x^n$ 的积考虑把后者拿到后面
- $e^x$ 与 $sin x, cos x$ 的积可以做两次
]

==== 非常好用的定积分公式

1. \
$ integral_0^a sqrt(a^2 - x^2) d x = 1/4 pi a^2, integral_(-a)^a sqrt(a^2 - x^2) d x = 1/2 pi a^2"（半圆面积）" $
2. 设 $f(x)$ 在 $[-a, a] (a > 0)$ 上是连续的偶函数，则\
$ integral_(-a)^a f(x) d x = 2 integral_0^(a) f(x) d x $
3. 设 $f(x)$ 在 $[-a, a] (a > 0)$ 上是连续的奇函数，则\
$ integral_(-a)^a f(x) d x = 0 $
4. 设 $f(x)$ 在 $(-infinity, infinity)$ 内是以 $T$ 为周期的连续函数，则对于任意的常数 $a$，恒有
#col2(
$ integral_a^(a + T) f(x) d x = integral_0^T f(x) d x $,
$ integral_a^(a + n T) f(x) d x = n integral_0^T f(x) d x, n in NN $
)
5. 华里士公式（#text(orange)[点火公式]）：
$
integral_0^(pi/2) sin^n x d x &= integral_0^(pi/2) cos^n x d x\
&= cases(
(n - 1)/n dot (n - 3)/(n - 2) dot dots dot 1/2 dot pi / 2","space n ident 0 (mod 2),
(n - 1)/n dot (n - 3)/(n - 2) dot dots dot 2/3 dot 1","space n ident 1 (mod 2),
)
$\
特别的：$
I_0 = pi/2\
I_1 = 1\
$
6. $f(x)$ 连续，有\
$ integral_0^pi x f(sin x) d x = pi/2 integral_0^pi f(sin x) d x $

== 反常积分

/ 无穷区间上的反常积分: 设 $f(x)$ 在 $[a, +infinity)$ 上连续，称\
  $ integral_a^(+infinity) f(x) d x = lim_(b->+infinity) integral_a^b f(x) d x $\
  为 $f(x)$ 在 $[a, +infinity)$ 上的反常积分，若右边极限存在，称此反常积分收敛；若该极限不在上称此反常积分发散。\
  类似地可以定义 $ integral_(-infinity)^b f(x) d x = lim_(a->-infinity) integral_a^b f(x) d x $\
  及 $ integral_(-infinity)^(+infinity) f(x) d x = integral_(-infinity)^c f(x) d x + integral_c^(+infinity) f(x) d x $\
  其中 $c in (-infinity, +infinity)$。

/ 无界函数的反常积分: 设 $f(x)$ 在区间 $[a, b)$ 上连续，且 $lim_(x->b^-) f(x) = infinity$ ，称\
  $ integral_a^b f(x) d x = lim_(beta->b^-) integral_a^beta f(x) d x $\
  为 $f(x)$ 在区间 $[a, b)$ 上的反常积分（也称瑕积分），若右边极限存在，则称反常积分收敛；若该极限不存在，称此反常积分发散。使 $f(x)->infinity$ 的点 $b$ 称为 $f(x)$ 的奇点（也称瑕点）。\
  类似的，若 $a$ 是奇点，有\
  $ integral_a^b f(x) d x = lim_(alpha->a+) integral_alpha^b f(x) d x $\
  若 $a, b$ 都是奇点，有\
  $ integral_a^b f(x) d x = integral_a^(x_0) f(x) d x + integral_(x_0)^b f(x) d x, a < x_0 < b $\
  若在开区间 $(a, b)$ 内部点 $c$ 为奇点，则反常积分定义为\
  $ integral_a^b f(x) d x = integral_a^c f(x) d x + integral_c^b f(x) d x $
  
=== 对称区间上奇、偶函数的反常积分

- 设 $f(x)$ 在 $(-infinity, +infinity)$ 上连续，#text(red)[$integral_0^(+infinity) f(x) d x$ 收敛]，则
  $
  integral_(-infinity)^(+infinity) f(x) d x = cases(0"（奇函数）", 2 integral_0^(+infinity) f(x) d x"（偶函数）")
  $
- 设 $f(x)$ 在 $[-a, a]$ 上除了 $x = plus.minus c$ 外均连续，$x = plus.minus c$ 为 $f(x)$ 的奇点，$0 <= c <= a$，#text(red)[$integral_0^a f(x) d x$ 收敛]，则
  $
  integral_(-a)^a f(x) d x = cases(0"（奇函数）", 2 integral_0^a f(x) d x"（偶函数）")
  $

*一个重要的反常积分：*\
$
integral_(-infinity)^(+infinity) e^(-x^2) d x = 2 integral_0^(+infinity) e^(-x^2) d x = sqrt(pi)
$

== 定积分的应用

=== 平面图形面积

- 极坐标曲线 $r = r(theta)$ 介于两射线 $theta = alpha$ 与 $theta = beta (0 < beta - alpha <= 2pi)$ 之间的曲边扇形的面积\
  $ S = 1/2 integral_alpha^beta r^2(theta) d theta $
- 由参数方程 $cases(x = x(t), y = y(t)), alpha <= t <= beta$ 所围成平面图形的面积为\
  $ S = integral_alpha^beta |y(t) x'(t)| d t $\
  或\
  $ S = integral_alpha^beta |x(t) y'(t)| d t $

=== 旋转体体积

- 曲线 $y = y(x)$ 与 $x = a, x = b, x$ 轴围成的曲边梯形绕 $x$ 轴旋转一周所成的旋转体体积\
  $ V = pi integral_a^b y^2(x) d x, a < b $\
  绕 $y$ 轴旋转一周所得旋转体体积为\
  $ V = 2 pi integral_a^b x y(x) d x, (y(x) >= 0, b >= a >= 0) $
#tweet[
第一个积分是一个曲边梯台，每个 $Delta x$ 的片的截面积是 $pi y^2(x)$，所以这个小切片的体积就是 $ pi y^2(x) dot Delta x$，然后要对 $[a, b]$ 范围内的所有 $pi y^2(x) dot Delta x$ 求和，即可得到该积分式。

第二个积分是一个甜甜圈，对每个 $Delta x$ 的图形都是个很薄的圆筒，圆筒的高是 $y(x) - 0$，然后把这个圆筒展开可知它的底面积是周长乘上一个圆筒厚度，即 $2 pi x dot Delta x$，所以这个圆筒的体积是 $2 pi x dot Delta x dot y(x)$。最后对 $[a, b]$ 的所有圆筒的体积求和即可得该积分式。
]

- 曲线 $y = y_2(x), y = y_1(x), x = a, x = b (y_2(x) >= y_1(x) >= 0)$ 围成的图形绕 $x$ 轴旋转一周所成的旋转体体积\
  $ V = pi integral_a^b [y_2^2(x) - y_1^2(x)] d x, a < b $

- 曲线 $y = y_2(x), y = y_1(x), x = a, x = b (b > a >= 0, y_2(x) >= y_1(x) >= 0)$ 围成的图形绕 $y$ 轴旋转一周所成的旋转体体积\
  $ V = 2 pi integral_a^b x(y_2(x) - y_1(x)) d x $

#tweet[结合二维面积做减法做类比，这两个式子都 make sense。]

=== 函数平均值

设 $x in [a, b]$，函数 $f(x)$ 在 $[a, b]$ 上的平均值为
$
overline(f) = 1/(b - a) integral_a^b f(x) d x
$

=== 平面曲线弧长

- 参数方程曲线 $cases(x = x(t), y = y(t)), alpha <= t <= beta$ 的弧长（其中 $x'(t)$ 与 $y'(t)$ 均连续，且不同时为零）\
  $ s = integral_alpha^beta sqrt(x'^2(t) + y'^2(t)) d t $
- 直角坐标 $y = y(x), a <= x <= b$ 的弧长（其中 $y'(x)$ 连续）
  $ s = integral_a^b sqrt(1 + y'^2(x)) d x $
- 极坐标曲线 $r = r(theta), alpha <= theta <= beta$ 的弧长（其中 $r(theta), r'(theta)$ 连续, 且不同时为零）
  $ s = integral_alpha^beta sqrt(r^2(theta) + r'^2(theta)) d theta $

=== 旋转曲面面积

在区间 $[a, b]$ 上的曲线 $y = f(x)$ 的弧段绕 $x$ 轴旋转一周所成的旋转曲面面积
$ S = 2 pi integral_a^b |y| sqrt(1 + f'^2(x)) d x, a < b $

= 向量代数与空间解析几何

== 向量运算

- 数量积：\
  代数表示：$bold(a) dot bold(b) = a_1 b_1 + a_2 b_2 + a_3 b_3$\
  几何表示：$bold(a) dot bold(b) = |bold(a)| |bold(b)| cos theta$
  运算率：交换、分配\
  几何应用：\
  - 求模：$|bold(a)| = sqrt(bold(a) dot bold(a))$
  - 求夹角：$cos theta = (bold(a) dot bold(b))/(|bold(a)||bold(b)|)$
  - 判断两向量垂直：$bold(a) bot bold(b)$
- 向量积：代数表示：\
  $
  bold(a) times bold(b) = 
  mat(delim: "|",
  bold(i), bold(j), bold(k);
  a_1, a_2, a_3;
  b_1, b_2, b_3;
  )
  $\
  运算规律：\
  $bold(a) times bold(b) = -(bold(b) times bold(a))$\
  $bold(a) times (bold(b) + bold(c)) = bold(a) times bold(b) + bold(a) times bold(c)$\
  几何应用：\
  求同时垂直于 $bold(a), bold(b)$ 的向量：$bold(a) times bold(b)$\
  求以 $bold(a)$ 与 $bold(b)$ 为邻边的平行四边形面积：$S = |bold(a) times bold(b)|$\
  判定两向量平行：$bold(a) parallel bold(b) <=> bold(a) times bold(b) = bold(0)$\
- 混合积：\
  $
  (bold(a b c)) &= (bold(a) times bold(b)) dot bold(c)
              &= mat(delim: "|",
              a_1, a_2, a_3;
              b_1, b_2, b_3;
              c_1, c_2, c_3;
              )
  $\
  运算规律：\
  - $(bold(a b c)) = (bold(b c a)) = (bold(c a b))$\
  - $(bold(a b c)) = -(bold(a c b))$\
  几何应用：求以 $bold(a), bold(b), bold(c)$ 为棱的平行六面体体积，$V_("平行六面体") = |(bold(a b c))|$\
  判定三向量共面：$bold(a), bold(b), bold(c)$ 共面 $<=> (bold(a b c)) = 0$

== 空间解析几何

#tweet[公式太多了，直接查书吧。说几个重要的。]

=== 平面与直线的位置关系

看直线 $L$ 的方向向量 $bold(tau)$ 和平面 $Pi$ 的法向量 $bold(n)$ 的关系：
+ $bold(tau) bot bold(n) <=> L parallel Pi$
+ $bold(tau) parallel bold(n) <=> L bot Pi$
+ $L, Pi$ 的夹角 $theta$：
  $ sin theta = (bold(tau) dot bold(n))/(|bold(tau)||bold(n)|) $

=== 平面与平面、直线与直线的关系

比法法（或对于直线的话就是比方向向量），法法平行则平面平行，法法垂直则平面垂直，夹角把平面与直线那个 $sin theta$ 换成 $cos theta$ 即可，make sense。

=== 点到面的距离

点 $(x_0, y_0, z_0)$ 到平面 $Pi(x, y, z) attach(limits(=), t: triangle.t) A x + B y + C z + D = 0$ （法向量 $bold(n)$）的距离
$ d = (|P(x_0, y_0, z_0)|)/|bold(n)| = (|A x_0 + B y_0 + C z_0 + D|)/sqrt(A^2 + B^2 + C^2) $

=== 点到直线的距离

点 $(x_0, y_0, z_0)$ 到直线 $(x - x_1) / l = (y - y_1) / m = (z - z_1) / n$ 的距离为
$ d = (|(x_1 - x_0, y_1 - y_0, z_1 - z_0) times (l, m, n)|)/sqrt(l^2 + m^2 + n^2) $

= 多元函数微分学

== 概念

=== 重极限

/ 重极限: 设函数 $f(x, y)$ 在开区域（或闭区域）$D$ 内有定义，$P_0(x_0, y_0)$ 是 $D$ 的内点或边界点，如果对任意给定的 $epsilon > 0$，$exists delta > 0$，使得对适合不等式
  $ 0 < sqrt((x - x_0)^2 + (y - y_0)^2) < delta $
  的一切 $P(x, y) in D$，都有 $|f(x, y) - A| < epsilon$，则称 $A$ 为 $f(x, y)$ 当 $x->x_0, y->y_0$ 时的极限，记为 $limits(limits(lim)_(x->x_0))_(y->y_0) f(x, y) = A$。

#tweet[$limits(limits(lim)_(x->x_0))_(y->y_0) f(x, y)$ 太难打了，后面写成 $lim_((x, y)->(x_0, y_0)) f(x, y)$。]

#addition[二元函数的重极限是指区域 $D$ 中的点 $P(x, y)$ 以任何方式趋于点 $P_0(x, y)$ 时，函数 $f(x, y)$ 都无限趋近同一常数 $A$。所以如果两条不同路经的极限值不相等那这个极线值就不存在了。\
然后是重极限的运算和性质（保号性、夹逼准则、局部有界等）都与一元函数类似。
]

=== 二元函数连续

/ 定义: 设函数 $f(x, y)$ 在开区域（或闭区域）$D$ 内有定义，$P_0(x_0, y_0)$ 是 $D$ 的内点或边界点，且 $P_0 in D$，如果 $lim_((x, y)->(x_0, y_0)) f(x, y) = f(x_0, y_0)$，则称函数 $f(x, y)$ 在点 $P_0(x_0, y_0)$ 处连续。

#strong[最值定理]、#strong[介值定理]在连续的二元函数中仍有类似的形式。

== 多元函数的微分

=== 偏导数与全微分

/ 偏导数: 设函数 $z = f(x, y)$ 在点 $(x_0, y_0)$ 的某一邻域内有定义，如果\
$ lim_(Delta x -> 0) (f(x_0 + Delta x, y_0) - f(x_0, y_0))/(Delta x) $\
  存在，则称此极限为函数 $z = f(x, y)$ 在点 $(x_0, y_0)$ 处#strong[对 $x$ 的偏导数]，记为 $f'_x (x_0, y_0)$ 或 $(diff f(x_0, y_0)) / (diff x)$。类似的还有对 $y$ 的偏导数。

/ 全增量: 如果函数 $z = f(x, y)$ 在点 $(x, y)$ 处的全增量 $Delta z = f(x + Delta x, y + Delta y) - f(x, y)$ 可以表示为\
  $ Delta z = A Delta x + B Delta y + o(rho) $\
  其中 $A, B$ 不依赖于 $Delta x, Delta y$，而仅与 $x, y$ 有关，$rho = sqrt((Delta x)^2 + (Delta y)^2)$，则称函数 $z = f(x, y)$ #strong[在点 $(x, y)$ 处可微]，而 $A Delta x + B Delta y$ 称为函数 $z = f(x, y)$ 在点 $(x, y)$ 的#strong[全微分]，记为\
  $ d z = A Delta x + B Delta y $

/ 全微分存在必要条件: 如果函数 $z = f(x, y)$ 在点 $(x, y)$ 处可微，则该函数在点 $(x, y)$ 处的偏导数 $(diff z)/(diff x), (diff z)/(diff y)$ 必定存在，且
  $ d z = (diff z)/(diff x) d x + (diff z)/(diff y) d y $

/ 全微分存在充分条件: 如果函数 $z = f(x, y)$ 的偏导数 $(diff z)/(diff x), (diff z)/(diff y)$ 在点 $(x, y)$ 处连续，则函数 $z = f(x, y)$ 在该点可微。

#tweet[
二元函数可导不一定连续，而是要可微。可微 $=>$ 连续 + 一阶偏导都存在。\
全微分存在的充分条件是二元函数的一阶偏导连续，而不是说这个二元函数连续。\
其中出这种混淆的根源是：多元函数可导（指存在偏导） $!=$ 可微（指可全微分）。\
#warn[
二元函数连续和偏导存在互为既不充分又不必要条件。
]
]

#example[
问题 1：可去间断点处的偏导数如果存在，是不是可以代表偏导数连续？

GPT-3.5：不完全正确。可去间断点处的偏导数存在并不意味着偏导数连续。在数学中，如果一个函数在某个点的邻域内除了该点本身可能发生间断外，其他地方都是连续的，我们称该点为可去间断点。

对于偏导数，类似地，如果一个多元函数在某个点的某个方向上的偏导数存在，但在另一个方向上不存在，那么这个点就是一个可去间断点。但要记住，即使在某个方向上的偏导数存在，它也不一定连续。

要判断一个函数在某个点的偏导数是否连续，需要检查该点的所有偏导数是否都存在且都连续。只有当所有偏导数都连续时，我们才能说函数在该点具有连续的偏导数。

总结起来，可去间断点处的偏导数存在并不保证偏导数连续，而连续的偏导数则要求所有偏导数在该点都存在且连续。
\
\
问题 2：使用偏导数定义的极限算出的某一点的偏导数存在可以说明偏导数在这一点连续吗？

GPT-3.5：是的，如果使用偏导数定义的极限计算出某一点的偏导数存在，那么可以说明偏导数在该点连续。

根据偏导数定义，对于一个多元函数，我们可以通过求取关于某个变量的偏导数来判断其在某一点的导数值。如果在该点的某个方向上的偏导数存在，即极限存在，那么这个偏导数在该点就是连续的。

具体而言，如果对于函数 f(x, y) 在点 (a, b) 处的某个方向（例如 x 方向）上的偏导数存在，即 $lim_(h→0)(f(a+h, b)-f(a, b))/h$  存在，那么这个偏导数在点 (a, b) 处连续。

需要注意的是，这里仅讨论了特定方向上的偏导数连续性。要判断一个函数在某一点处的所有偏导数是否连续，需要检查所有方向上的偏导数是否都存在且连续。
]

#tweet[
我目前看到的比较合理的可微的证法：\
+ 讨论 $x, y$ 偏导数的存在性，使用偏导数的极限定义直接算
+ 若存在，还要讨论在 $(x_0, y_0)$ 处是否可微，使用全增量计算下式：\
$ lim_((Delta x, Delta y) -> (0, 0)) (Delta z - ((diff f)/(diff x) Delta x + (diff f)/(diff y) Delta y)) / rho $\
是否存在。
]

== 多元复合函数求导和微分

=== 求导

*多元与一元复合：*\
$
(d z) / (d t) = (diff z) / (diff u) (d u) / (d t) + (diff z) / (diff v) (d v) / (d t)
$

这里的 $(d z) / (d t)$ 称为#strong[全导数]。

*多元与多元复合：*\
#col2(
gutter: 75pt,
$ (diff z) / (diff x) = (diff f) / (diff u) (diff u) / (diff x) + (diff f) / (diff v) (diff v) / (diff x) $,
$ (diff z) / (diff y) = (diff f) / (diff u) (diff u) / (diff y) + (diff f) / (diff v) (diff v) / (diff y) $
)

=== 全微分形式不变性

设函数 $z = f(x, y)$ 和 $u = phi(x, y), v = psi(x, y)$ 都具有连续一阶偏导数，则复合函数 $z = f[phi(x, y), psi(x, y)]$ 可微，且\
$ d z = (diff z) / (diff x) d x + (diff z) / (diff y) d y $\
有\
$ d z = (diff z) / (diff u) d u + (diff z) / (diff v) d v $\

=== 隐函数偏导与全微分

由方程确定的一元函数：

$
(d y) / (d x) = - (F'_x)/(F'_y)
$

由方程确定的二元函数：

#col2(gutter: 75pt,
$ (diff z) / (diff x) = - (F'_x) / (F'_z) $,
$ (diff z) / (diff y) = - (F'_y) / (F'_z) $
)

设 $u = u(x), v = v(x)$，由方程组\
$ cases(F(x, u, v) = 0, G(x, u, v) = 0) $\
确定的一元函数，可分别做隐函数求导，解出 $(d u)/(d x), (d v)/d x$。


设 $u = u(x, y), v = v(x, y)$，由方程组\
$ cases(F(x, y, u, v) = 0, G(x, y, u, v) = 0) $\
确定的二元函数，可对隐函数分别求对 $x, y$ 的偏导，可解四个量。

== 极值与最值

=== 无条件极值

/ 极值: 若存在 $M_0(x_0, y_0)$ 点的某邻域 $U_delta(M_0)$，使得\
  $ f(x, y) <= f(x_0, y_0)" 或 "f(x, y) >= f(x_0, y_0), forall (x, y) in U_delta(M_0) $\
  则称 $f(x, y)$ 在点 $M_0(x_0, y_0)$ 取得#strong[极大值]或#strong[极小值]。

/ 必要条件: 设函数 $f(x, y)$ 在点 $M_0$ 处的一阶偏导数存在，且在 $M_0$ 处取得极值，则
#col2(
$ f'_x (x_0, y_0) = 0 $,
$ f'_y (x_0, y_0) = 0 $
)

/ 充分条件: 设函数 $z = f(x, y)$ 在点 $M_0$ 的某领域内有连续的二阶偏导数，且 $f'_x(x_0, y_0) = 0, f'_y(x_0, y_0) = 0$，令 $f''_(x x) (x_0, y_0) = A, f''_(x y) (x_0, y_0) = B, f''_(y y) (x_0, y_0)$ 则：\
  (1) $A C - B^2 > 0$ 时，$f(x, y)$ 在 $M_0$ 处取极值\
  $ cases("当 A > 0 时取极小值", "当 A < 0 时取极大值") $\
  (2) $A C - B^2 < 0$ 时，$f(x, y)$ 在 $M_0$ 处无极值\
  (3) $A C - B^2 = 0$ 时，则不能确定在 $M_0$ 处是否有极值

=== 条件极值

函数 $f(x, y)$ 在条件 $phi(x, y) = 0$ 下的极值
解决此类问题的一般方法是#strong[拉格朗日乘数法]：
+ 先构造拉格朗日函数 $F(x, y, lambda) = f(x, y) + lambda phi(x, y)$，然后解方程组\
  $
  cases(
  (diff F) / (diff x) = (diff f) / (diff x) + lambda (diff phi) / (diff x) = 0,
  (diff F) / (diff y) = (diff f) / (diff y) + lambda (diff phi) / (diff y) = 0,
  (diff F) / (diff lambda) = phi(x, y) = 0
  )
  $\
  满足此方程组的解即为该条件下的极值点。

函数 $f(x, y, z)$ 在条件 $phi(x, y, z) = 0, psi(x, y, z) = 0$ 下的极值，同上，构造拉格朗日函数：\
  $
  F(x, y, z, lambda, mu) = f(x, y, z) + lambda phi(x, y, z) + mu psi(x, y, z)
  $

#example[
举个乘数的例子：

求原点到曲面 $z^2 = x y + x - y + 4$ 的最短距离。

那就是求某点 $(x, y, z)$ 到 $(0, 0, 0)$ 的距离 $sqrt(x^2 + y^2 + z^2)$ 最短，然后将这些点限制在 $z^2 = x y + x - y + 4$ 这个曲面上，所以构造拉格朗日函数
$
L = x^2 + y^2 + z^2 + lambda(z^2 - x y - x + y - 4)
$\
求条件下的驻点。
]

== 梯度、几何应用

=== 方向向量和梯度

二元函数 $f(x, y)$ 在点 $(x_0, y_0)$ 沿 $bold(l) = (a, b) (a^2 + b^2 = 1)$ 方向的#strong[方向导数]为\
$
(diff f(x_0, y_0)) / (diff bold(l)) = lim_(t->0^+) (f(x_0 + a t, y_0 + b t) - f(x_0, y_0)) / t
$\

二元函数 $f(x, y)$ 在点 $(x_0, y_0)$ 的#strong[梯度]为\
$
nabla f(x_0, y_0) = ((diff f(x_0, y_0))/(diff x), (diff f(x_0, y_0))/(diff y))
$\
其在点 $(x_0, y_0)$ 沿 $bold(l) = (a, b)(a^2 + b^2 = 1)$ 方向的方向导数为\
$
(diff f(x_0, y_0))/(diff bold(l)) = nabla f(x_0, y_0) dot bold(l)
$

#tweet[
曲面 $F(x, y, z)$ 在点 $(x_0, y_0, z_0)$ 处的法向量好像是 $ bold(n) = {F'_x (x_0, y_0, z_0), F'_y (x_0, y_0, z_0), F'_z (x_0, y_0, z_0)} $
]

=== 几何应用

==== 空间曲面的切平面

空间曲面 $z = f(x, y)$ 过 $P_0(x_0, y_0)$ 切平面方程为\
  $ (diff f(x_0, y_0))/(diff x) (x - x_0) + (diff f(x_0, y_0))/(diff y) (y - y_0) - (z - z_0) = 0 $

==== 空间曲线的切线

空间曲面的参数方程 $cases(x = x(t), y = y(t), z = z(t)), (alpha <= t <= beta)$ 的切线为：\
$
cases(
x = x_0 + x'(t_0)(t - t_0),
y = y_0 + y'(t_0)(t - t_0),
z = z_0 + x'(t_0)(t - t_0)
)
$

= 多元函数积分学

== 二重积分

=== 定义

/ 定义: 设 $z=f(x, y)$ 是平面上有界闭区域 $D$ 上的有界函数
  $ limits(integral.double)_D f(x, y) d sigma attach(limits(=), t: triangle.t) lim_(d->0) sum_(k=1)^(n) f(xi_k, eta_k) Delta sigma_k $

#tweet[这个 $D$ 放在 $integral.double$ 底下比较难写，后面就放在右下了。但是事实上这么写是不对的。]

/ 几何意义: 由 $D$ 为底，侧面是以 $D$ 的边界为准线、母线平行于 $z$ 轴的柱面的曲顶柱体体积。当然要注意函数值正负的意义。

=== 性质

/ 比较定理: 如果在 $D$ 上，$f(x, y) <= g(x, y)$，则\
$ integral.double_D f(x, y) d sigma <= integral.double_D g(x, y) d sigma $

/ 估值定理: 设 $M, m$ 分别为连续函数 $f(x, y)$ 在闭区域 $D$ 上的最大值和最小值，$S$ 表示区域 $D$ 的面积，则
  $ m S <= integral.double_D f(x, y) d sigma <= M S $

/ 中值定理: 设函数 $f(x, y)$ 在闭区域 $D$ 上连续，$S$ 为 $D$ 的面积，则在 $D$ 上至少存在一点 $(xi, eta)$，使
  $ integral.double_D f(x, y) d sigma = f(xi, eta) S $

=== 计算

==== 直角坐标

若积分域 $D$ 由不等式 $cases(phi_1(x) <= y <= phi_2(x), a <= x <= b)$ 确定，则该区域 $D$ 上的二重积分适合化成先 $y$ 后 $x$ 的累次积分，且\
$
integral.double_D f(x, y) d sigma = integral_a^b d x integral_(phi_1(x))^(phi_2(x)) f(x, y) d y
$

若积分域 $D$ 由不等式 $cases(psi_1(y) <= x <= psi_2(y), a <= y <= b)$ 确定，则该区域 $D$ 上的二重积分适合化成先 $x$ 后 $y$ 的累次积分，且\
$
integral.double_D f(x, y) d sigma = integral_a^b d y integral_(psi_1(y))^(psi_2(y)) f(x, y) d x
$

#addition[
累次积分\
$
integral_a^b [integral_c^d f(x, y) d y] d x
$\
为了书写简便写成\
$
integral_a^b d x integral_c^d f(x, y) d y
$\
的形式
#tweet[所以这玩意其实是先算里面再算外面，就像是良定义下两泛函 $F, G$，有 $ G(F(f)) = G compose F(f) $]
]

==== 极坐标

极坐标下的计算要分 4 种情况，但是统一起来也就一个主要公式：
$
integral.double_D f(x, y) d sigma = integral_alpha^beta d theta integral_(r_1(theta))^(r_2(theta)) f(r cos theta, r sin theta) r d theta
$

== 三重积分

=== 定义

$
limits(integral.triple)_Omega f(x, y, z) d v = lim_(d->0) sum_(k=1)^n f(xi_k, eta_k, zeta_k) Delta v_k
$

=== 计算

*先单后重*

$
limits(integral.triple)_Omega f(x, y, z) d v = limits(integral.double)_(D_(x y)) d x d y integral_(z_1(x, y))^(z_2(x, y)) f(x, y, z) d z
$

*先重后单*

$
limits(integral.triple)_Omega f(x, y, z) d v = integral_(c_1)^(c_2) d z limits(integral.double)_(D_z) f(x, y, z) d x d y
$

*柱坐标*

柱坐标与直角坐标的关系为

$
cases(
x = r cos theta\, 0 <= r < +infinity,
y = r sin theta\, 0 <= theta <= 2 pi,
z = z\, -infinity < z < +infinity
)
$

体积微元：$d v = r d r d theta d z$

$
limits(integral.triple)_Omega f(x, y, z) d v = limits(integral.triple)_Omega f(r cos theta, r sin theta, z) r d r d theta d z
$

*球坐标*

球坐标与直角坐标的关系为

$
cases(
x = r sin phi cos theta\, 0 <= r < +infinity,
y = r sin phi sin theta\, 0 <= phi <= pi,
z = r cos phi\, 0 <= theta <= 2 pi
)
$

体积微元：$d v = r^2 sin phi d r d phi d theta$ 

$
limits(integral.triple)_Omega f(x, y, z) d v = limits(integral.triple)_Omega f(r sin phi cos theta, r sin phi sin theta, r cos phi) r^2 sin phi d r d phi d theta
$

== 曲线积分

= 无穷级数

== 常数项级数

级数 $sum_(n=1)^infinity u_n$ 收敛的必要条件是 $lim_(n->infinity) u_n = 0$。

=== 正项级数的判敛准则

各项都为正数组成的级数称为#strong[正项级数]。

/ 定理: 正项级数 $sum_(n=1)^infinity u_n$ 收敛 $<=>$ 部分和数列 ${S_n}$ 有界

/ 定理: 比较判别法：\
  若两正项级数 $sum_(n=1)^infinity u_n$ 和 $sum_(n=1)^infinity v_n$，存在某个正数 $N$，当 $n > N$ 时，$u_n <= v_n$，
  则 $sum_(n=1)^infinity v_n$ 收敛 $=>$ $sum_(n=1)^infinity u_n$ 收敛；$sum_(n=1)^infinity u_n$ 发散 $=>$ $sum_(n=1)^infinity v_n$ 发散。

#tweet[
这个比较法很 make sense，比发散“更大的”肯定发散，比收敛“更小的”肯定收敛。
]

/ 推论: 比较判别法的极限形式：设 $lim_(n->infinity) u_n/v_n = l (0 <= l <= +infinity)$，\
  (1) 若 $0 < l < +infinity$，则 $sum_(n=1)^infinity u_n$ 与 $sum_(n=1)^infinity v_n$ 同敛散\
  (2) 若 $l = 0$，则 $sum_(n=1)^infinity v_n$ 收敛 $=>$ $sum_(n=1)^infinity$ 收敛\
  (3) 若 $l = +infinity$，则 $sum_(n=1)^infinity v_n$ 发散 $sum_(n=1)^infinity v_n$ 发散\

/ 比值判别法: 设 $lim_(n->infinity) u_(n+1)/u_n = rho$，则\
  $
  sum_(n=1)^infinity u_n = cases(
  "收敛，"rho < 1,
  "发散，"rho > 1,
  "不确定，"rho = 1
  )
  $

/ 根值判别法: 设 $lim_(n->infinity) root(n, u_n) = rho$，则\
  $
  sum_(n=1)^infinity u_n = cases(
  "收敛，"rho < 1,
  "发散，"rho > 1,
  "不确定，"rho = 1
  )
  $

/ 定理: 级数 $sum_(n=1)^infinity 1/n^p$ 当 $p > 1$ 时收敛；当 $p <= 1$ 时发散。

=== 交错级数

/ 定义: 若级数的各项符号正负相间，即 $sum_(n=1)^infinity (-1)^(n-1) u_n, u_n > 0$，则称此级数为#strong[交错级数]。

/ 莱布尼茨判别准则: 若：\
  (1) $u_n >= u_(n+1) (n = 1, 2, dots)$\
  (2) $lim_(n->infinity) u_n = 0$\
  则级数 $sum_(n=1)^infinity (-1)^(n-1) u_n$ 收敛。注意这是充分条件。

重点在判别 $u_n >= u_(n+1)$。

=== 绝对收敛

若级数各项绝对值组成的级数 $sum_(n=1)^infinity abs(u_n)$ 收敛，则称级数 $sum_(n=1)^infinity$ #strong[绝对收敛]。\
若级数各项绝对值组成的级数 $sum_(n=1)^infinity u_n$ 收敛，$sum_(n=1)^infinity abs(u_n)$ 发散，则称级数 $sum_(n=1)^infinity$ #strong[条件收敛]。

/ 定理: 绝对收敛的级数一定收敛。\
  条件收敛的级数所有正项或负项构成的级数一定发散。

#addition[
对于级数 $limits(sum)_(n=1)^infinity (u_n + v_n)$：
+ $limits(sum)_(n=1)^infinity u_n, limits(sum)_(n=1)^infinity v_n$ 均收敛 $=>$ $limits(sum)_(n=1)^infinity (u_n + v_n)$ 收敛
+ $limits(sum)_(n=1)^infinity u_n$ 收敛，但 $limits(sum)_(n=1)^infinity v_n$ 发散 $=>$ $limits(sum)_(n=1)^infinity (u_n + v_n)$ 发散
+ $limits(sum)_(n=1)^infinity u_n, limits(sum)_(n=1)^infinity v_n$ 均绝对收敛 $=>$ $limits(sum)_(n=1)^infinity (u_n + v_n)$ 绝对收敛
+ $limits(sum)_(n=1)^infinity u_n$ 绝对收敛，但 $limits(sum)_(n=1)^infinity v_n$ 仅条件收敛 $=>$ $limits(sum)_(n=1)^infinity (u_n + v_n)$ 条件收敛
]

== 幂级数

/ 函数项级数: 设 $u_1(x), u_2(x), dots, u_n(x)$ 是定义在区间 $I$ 上的函数序列，则称\
  $ u_1(x) + u_2(x) + dots + u_n(x) + dots = sum_(n_1)^infinity u_n(x) $\
  为定义在区间 $I$ 上的函数项级数。

若 $x_0 in I$ 能使函数项级数收敛，则称 $x_0$ 为收敛点，所有收敛点构成的集合称为收敛域。

/ 幂级数: 形如 $sum_(n=0)^infinity a_n(x - x_0)^n = a_0 + a_1(x - x_0) + a_2(x - x_0)^2 + dots + a_n(x - x_0)^n + dots$ 的函数项级数称为#strong[幂级数]。

/ 阿贝尔定理: 如果幂级数 $sum_(n=0)^infinity a_n x^n$ 当 $x = x_0 != 0$ 时收敛，则当 $|x| < |x_0|$ 时，$sum_(n=0)^infinity a_n x^n$ 绝对收敛；如果 $sum_(n=0)^infinity a_n x^n$ 当 $x = x_0$ 时发散，则当 $|x| > |x_0|$ 时 $sum_(n=0)^infinity a_n x^n$ 发散。

/ 定义: 若存在 $R$，使 $sum_(n=0)^infinity a_n x^n$ 在 $(-R, R)$ 内收敛，而当 $|x| > R$ 时 $sum_(n=0)^infinity a_n x^n$ 发散，则称 $R$ 为幂级数 $sum_(n=0)^infinity a_n x^n$ 的#strong[收敛半径]，$(-R, R)$ 称为 $sum_(n=0)^infinity a_n x^n$ 的#strong[收敛区间]。

#addition[幂级数的收敛区间是开区间，求收敛域还要判断端点。]

/ 定理: 如果 $lim_(n->infinity) |a_(n+1) / a_n| = rho$，则 $R = 1/rho$
/ 定理: 如果 $lim_(n->infinity) root(n, a_n) = rho$，则 $R = 1/rho$

#addition[
幂级数只可能在收敛域两端点处条件收敛。
]

=== 性质

==== 四则运算

若幂级数 $sum_(n=0)^infinity a_n x^n$ 的收敛半径为 $R_1$，和函数是 $S_1(x)$，$sum_(n=0)^infinity b_n x^n$ 的收敛半径为 $R_2$，和函数是 $S_2(x)$，令 $R = min(R_1, R_2)$，则
+ $sum_(n=0)^infinity a_n x^n plus.minus sum_(n=0)^infinity b_n x^n = sum_(n=0)^infinity (a_n plus.minus b_n) x^n = S_1(x) + S_2(x), x in (-R, R)$
+ $(sum_(n=0)^infinity a_n x^n)(sum_(n=0)^infinity b_n x^n) &= sum_(n=0)^infinity (a_0 b_n + a_1 b_(n-1) + dots + a_n b_0) x^n\
&= S_1(x) S_2(x), x in (-R, R)$
+ 设 $b_0 != 0$\
  $ (S_1(x))/(S_2(x)) = (limits(sum)_(n=0)^infinity a_n x^n)/(limits(sum)_(n=0)^infinity b_n x^n) = c_0 + c_1 x + c_2 x^2 + dots + c_n x^n + dots $\
  其中 $c_n$ 由 $(limits(sum)_(n=0)^infinity b_n x^n) dot (limits(sum)_(n=0)^infinity c_n x^n) = limits(sum)_(n=0)^infinity a_n x^n $ 来确定。

==== 分析性质

设幂级数 $sum_(n=0)^infinity a_n x^n$ 的收敛半径为 $R$，和函数为 $S(x)$，则
+ $S(x)$ 在 $(-R, R)$ 上连续
+ $S(x)$ 在 $(-R, R)$ 上可导，且可逐项求导，即 $S'(x) = sum_(n=1)^infinity n a_n x^(n-1)$
+ $S(x)$ 在 $(-R, R)$ 内可积，且可逐项积分，即
  $ integral_0^x S(t) d t = sum_(n=0)^infinity integral_0^x a_n t^n d t = sum_(n=0)^infinity (a_n)/(n + 1) x^(n + 1), x in (-R, R) $

=== 幂级数展开

/ 泰勒级数: 设 $f(x)$ 在 $x = x_0$ 处任意阶可导，则幂级数\
  $ sum_(n=0)^infinity (f^((n))(x_0))/(n!) (x-x_0)^n = &f(x_0) + f'(x_0) (x - x_0) + (f''(x_0)) / (2!) (x - x_0)^2 + dots\
  &+ (f^((n))(x_0)) / (n!) (x - x_0)^n + dots $\
  称为 $f(x)$ #strong[在 $x = x_0$ 处的泰勒级数]。

/ 麦克劳林级数: 当 $x_0 = 0$ 时，$ sum_(n=0)^infinity (f^((n))(0))/(n!) x^n = &f(0) + f'(0) x + (f''(0)) / (2!) x^2 + dots + (f^((n))(0)) / (n!) x^n + dots $\
  称为 $f(x)$ 的#strong[麦克劳林级数]。

/ 泰勒级数的收敛: 设 $f(x)$ 在 $x = x_0$ 处任意阶可导，则泰勒级数收敛于 $f(x)$ 的充要条件是 $lim_(n->infinity) R_n(x) = 0$，其中
  $ R_n (x) = (f^((n + 1)) [x_0 + theta(x - x_0)])/((n + 1)!) (x - x_0)^(n+1) $

#addition[
常用麦克劳林展开式：
- $1 / (1 - x) = 1 + x + x^2 + dots + x^n + dots, x in (-1, 1)$
- $1 / (1 + x) = 1 - x + x^2 + dots + (-1)^n x^n + dots, x in (-1, 1)$
]

== 傅里叶级数

= 微分方程

含有未知函数、未知函数的导函数与自变量之间关系的方程叫作#strong[微分方程]；未知函数导函数的最高阶称为该#strong[微分方程的阶]；未知函数是一元函数的微分方程称为#strong[常微分方程]。

方程\
$
y^((n)) = f(x, y, y', dots, y^((n-1)))
$\
或\
$
F(x, y', y', dots, y^((n))) = 0
$\
称为 #strong[$n$ 阶微分方程]，其中除了 $y^((n))$ 其它都可以没有。

设 $y = phi(x)$ 在区间 $(a, b)$ 上连续且有直到 $n$ 阶的导数使得上式成立，则称 $y = phi(x)$ 为该微分方程在 $(a, b)$ 上的一个#strong[解]；如果满足 $y$ 中含独立常数，如 $y = phi(x, C_1, C_2, dots, C_n), a < x < b$，则称它为微分方程的#strong[通解]，不含任意常数的解称#strong[特解]。


== 一阶微分方程

=== 变量可分离的微分方程

微分方程 $(d y)/(d x) = h(x) g(y)$ 称变量可分离的方程，分离变量\
$
(d y)/(g(y)) = h(x) d x
$\
两边积分便得通解\
$
integral (d y)/(g(y)) = integral h(x) d x + C
$

=== 齐次微分方程



