---
layout: post
title: Category Theory for Programmers
description: Notes for 🐱 theory
categories: Category_Theory
tags: [PL, Maths, Category Theory]
---

## Kleisli Category

A Kleisli category is a category based on a monad:

- Objects: the types of the underlying programming language
- Morphisms: from type $A$ to a type derived from type $B$ using the particular embellishment
- Kleisli-category-defined composition and identity morphisms

Form in Haskell:

```haskell
module Main where
import Data.Char (toUpper)

type Writer a = (a, String)

(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x ->
    let (y, s1) = m1 x
        (z, s2) = m2 y
    in (z, s1 <> s2)

return :: a -> Writer a
return x = (x, "")

upCase :: String -> Writer String
upCase s = (map toUpper s, "upCase ")

toWords :: String -> Writer [String]
toWords s = (words s, "toWords ")

process :: String -> Writer [String]
process = upCase >=> toWords

main :: IO ()
main = do
    let (res, _) = process "hello world"
    print res
```

`>=>` is the composition of such a category. The `Writer` is the monad.

In C++:

```cpp
#include <cmath>
#include <functional>
#include <iostream>
using std::sqrt;
using std::function;

template<typename A> class optional {
    bool _isValid;
    A _value;
public:
    optional() : _isValid(false) {}
    optional(A v) : _isValid(true), _value(v) {}
    bool isValid() const { return _isValid; }
    A value() const { return _value; }
};

template<typename A, typename B, typename C>
function<optional<C>(A)> compose(function<optional<B>(A)> f, function<optional<C>(B)> g) {
    return [f, g](A a) -> optional<C> {
        auto fa = f(a);
        if (!fa.isValid()) return optional<C>{};
        auto gb = g(fa.value());
        if (!gb.isValid()) return optional<C>{};
        return optional<C>{gb.value()};
    };
}

template<typename A>
optional<A> identity(A a) {
    return {a};
}

optional<double> safe_root(double x) {
    if (x >= 0) return {sqrt(x)};
    else return {};
}

optional<double> safe_reciprocal(double x) {
    if (x == 0) return {};
    else return { 1. / x };
}

auto safe_root_reciprocal = compose<double, double, double>(safe_reciprocal, safe_root);

int main() {
    auto res = safe_root_reciprocal(0.25);
    if (res.isValid()){
        std::cout << res.value() << std::endl;
    }
}
```

The `optional` is the monad.

## Universal Construction

### Initial Object & Terminal Object

The **initial object** is the object that has one and only one morphism going to any object in the category.

The initial object in a partially ordered set(a.k.a. poset) is its least element. In the category of sets and functions, the initial object is the empty set(which is corresponding to type `Void` in Haskell).

If there is a morphism going from $a$ to $b$, we called the $b$ is *more terminal* than $a$.

The **terminal object** is the object with one and only one morphism coming to it from any object in the category.

The uniquenss of the initial object and the terminal object is up to *isomorphism*.

In the poset, the terminal object is the biggest element when the biggest element exists. 

### Isomorphisms

An isomorphism is an invertible morphism, or a pair of morphisms, one being the inverse of the other.

### Products & Coproducts

A **product** of two objects $a$ and $b$ is the object c equipped with two projections such that for any other object $c'$ equipped with two projections there is a unique morphism $m$ from $c'$ to c that factorizes those projections.

A higher order function that produces the factorizing function $m$ from two candidates which sometimes called *factorizer*:

```haskell
factorizer :: (c -> a) -> (c -> b) -> (c -> (a, b))
factorizer p q = \x -> (p x, q x)
```

Product types in Haskell:

```haskell
type Pair = (Int, Bool)                            -- pair or tuple?
type Pair a b = Pair a b
data Element = Element { name :: String            -- record
                       , symbol :: String
                       , atomicNumber :: Int }
```

A **coproduct** is the product's dual. A *coproduct* of two objects $a$ and $b$ is the object $c$ equipped with two injections such that for any other object $c'$ equipped with two injections there is a unique morphism $m$ from $c$ to $c'$ that factorizes those injections.

In the category of sets, the product is the *Cartesian product* and the coproduct is the *disjoint union* of two sets.

The factorizer for the coproduct(which is implemented as `Either` in Haskell) produces the factoring function:

```haskell
factorizer :: (a -> c) -> (b -> c) -> Either a b -> c
factorizer i j (Left a) = i a
factorizer i j (right b) = j b
```

Coproduct/sum types in Haskell:

```haskell
data Either a b = Left a | Right b
data OneOfThree a b c = Sinistral a | Medial b | Dextral c
```

## Functors

Given two categories, $\mathbf{C}$ and $\mathbf{D}$, a functor $F$ maps objects in $\mathbf{C}$ to objects in $\mathbf{D}$, and maps morphisms in $\mathbf{C}$ to morphisms in $\mathbf{D}$, and satisfies that:

$$
\forall f :: a \rightarrow b, a \in Ob(\mathbf{C}), b \in Ob(\mathbf{D})   \\
F f :: f a \rightarrow f b
$$

```Haskell
F :: a -> b
```

$$
\forall h = g \circ f, f \in \mathbf{C}(a, b), g \in \mathbf{C}(b, c) \\
F h = F g \circ F f
$$

```Haskell
F :: (a -> a) -> (b -> b)
```

$$
F\mathbf{id_A} = \mathbf{id}_{Fa}
$$

### fmap

```haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```

The functor laws:

```
fmap id = id
fmap (g . f) = fmap g . fmap f
```

We have to prove that `fmap` preserves identity and composition.

### Reader Functors

```haskell
fmap :: (a -> b) -> (r -> a) -> (r -> b)
fmap = (.)
```

Equational reasoning:

```
  fmap id ra
= id . ra
= ra
  
  fmap (g . f) ra
= (g . f) . ra
= g . (f . ra)
= g . (fmap f ra)
= fmap g (fmap f ra)
= (fmap g . fmap f) ra
```

### Maybe

```haskell
fmap :: (a -> b) -> Maybe a -> Maybe b
fmap _ Nothing = Nothing
fmap f (Just x) = Just $ f x
```

Proof:

```
  fmap id Nothing
= Nothing
= id Nothing

  fmap id (Just x)
= Just x
= Just (id x)

  fmap (g . f) Nothing
= Nothing
= fmap g Nothing
= fmap g (fmap f Nothing)

  fmap (g . f) (Just x)
= Just $ (g . f) x
= Just (g (f x))
= fmap g (Just (f x))
= fmap g (fmap f (Just x))
```

### List

```haskell
fmap :: (a -> b) -> List a -> List b
fmap _ [] = []
fmap f (x:xs) = Cons (f x) $ fmap f xs
```

Proof:

```
  fmap id []
= []
= id []

-- Use induction, assume that: fmap id xs = xs.
  fmap id (x:xs)
= Cons (id x) $ fmap id xs     -- induction
= Cons x xs

  fmap (g . f) []
= []
= fmap g []
= fmap g (fmap f [])

-- Use induction, assume that: fmap (g . f) xs = fmap g (fmap f xs).
  fmap (g . f) (x:xs)
= Cons ((g . f) x) $ fmap (g . f) xs
= Cons (g (f x)) $ fmap (g . f) xs       -- induction
= Cons (g (f x)) $ (fmap g (fmap f xs))
= fmap g (Cons (f x) $ fmap f xs))
= fmap g (fmap f (x:xs))
```

## Functor Composition

```haskell
composeMaybeList :: ((a -> b) -> List a -> List b) -> ((List a -> List b) -> Maybe List a -> Maybe List b) -> (a -> b) -> Maybe List a -> Maybe List b
composeMaybeList = (.)
```

## Bifunctors

```haskell
import Data.Bifunctor (Bifunctor)
class MyBifunctor f where
    bimap :: (a -> c) -> (b -> d) -> f a b -> f c d
    bimap g h = first g . second h
    first :: (a -> c) -> f a b -> f c b
    first g = bimap g id
    second :: (b -> d) -> f a b -> f a d
    second = bimap id
```

### Functorial ADTs

```haskell
newtype BiComp bf fu gu a b = BiComp (bf (fu a) (gu b))

instance (MyBifunctor bf, Functor fu, Functor gu) =>
    MyBifunctor (BiComp bf fu gu) where
        bimap f1 f2 (BiComp x) = BiComp (bimap (fmap f1) (fmap f2) x)
```

```
f1 :: a -> fu a
fmap f1 :: fu a -> fu c
f2 :: a -> gu a
fmap f2 :: gu b -> gu d
bimap :: (fu a -> fu c) -> (gu b -> gu d) -> bf (fu a) (gu b) -> bf (fu c) (gu d)
```

### Kleisli Category (Writer Functor)

```haskell
type Writer a = (a, String)

(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x ->
    let (y, s1) = m1 x
        (z, s2) = m2 y
    in (z, s1 <> s2)

myReturn :: a -> Writer a
myReturn x = (x, "")

instance Functor (Writer a) where
    fmap :: (a -> b) -> Writer a -> Writer b
    fmap f = id >=> (\x -> return (f x))
		-- fmap f = id >=> (myReturn . f)
```

```
id :: Writer a -> Writer a
myReturn . f :: a -> Writer b
f :: a -> b
```

### Covariant and Contravariant Functor

```haskell
type Reader r a = r -> a

instance Functor (Reader r) where
    fmap f g = f . g
```

For every category $\mathbf{C}$ there is a dual category $\mathbf{C}^{op}$. It's a category with the same objects as $\mathbf{C}$, but with all the arrows reversed.

Consider a functor that goes between $\mathbf{C}^{op}$ and some other category $\mathbf{D}$:

$$
F :: \mathbf{C}^{op} \rightarrow \mathbf{D}
$$

Such a functor maps a morphism $f^{op} :: a \rightarrow b$ in $\mathbf{C}^{op}$ to the morphism $Ff^{op} :: Fa \rightarrow Fb$ in $\mathbf{D}$. But the morphism $f^{op}$ secretly corresponds to some morphism $f :: b \rightarrow a$ in the original category $\mathbf{C}$.

Consider a $G$ which is not a functor:

- it maps objects the same way $F$ does
- when it comes to mapping morphisms, it reverses them

then:

$$
Gf :: (b \rightarrow a) \rightarrow (Ga \rightarrow Gb)
$$

When it is a functor, it is called a **contravariant functor**.

The *regular* functor is called a **covariant functor**.

```haskell
type Op r a = a -> r

class Contravariant f where
    contramap :: (b -> a) -> (f a -> f b)

instance Contravariant (Op r) where
    contramap f g = g . f
```

### Is Pair a Bifunctor?

```haskell
data Pair a b = Pair a b
instance Bifunctor Pair where
    bimap f g (Pair a b) = Pair (f a) (g b)
    first f (Pair a b) = Pair (f a) b
    second g (Pair a b) = Pair a (g b)
```

Proof:

```
  bimap g h (Pair a b)
= Pair (g a) (h b)
= bimap g id (Pair a (h b))
= first g (Pair a (h b))
= first g (bimap id h (Pair a b))
= first g (second h (Pair a b))
= (first a . second h) (Pair a b)

  first g id (Pair a b)
= Pair (g a) b
= bimap g id (Pair a b)

  second id h (Pair a b)
= Pair a (h b)
= bimap id h (Pair a b)
```

### Proof Isomorphism of Maybe and Maybe'

```haskell
import Data.Functor.Identity

newtype Const c a = Const c
type Maybe' a = Either (Const () a) (Identity a)

maybe'2Maybe :: Maybe' a -> Maybe a
maybe'2Maybe (Left (Const _)) = Nothing
maybe'2Maybe (Right (Identity a)) = Just a

maybe2Maybe' :: Maybe a -> Maybe' a
maybe2Maybe' (Just a) = Right $ Identity a
maybe2Maybe' Nothing = Left $ Const ()
```

Proof:

```
   proof. maybe'2Maybe . maybe2Maybe' = id
1. maybe'2Maybe . maybe2Maybe' (Just a)
 = maybe'2Maybe (maybe2Maybe' (Just a))
 = maybe'2Maybe (Right (Identity a))
 = (Just a)
2. maybe'2Maybe . maybe2Maybe' Nothing
 = maybe'2Maybe (maybe2Maybe' Nothing)
 = maybe'2Maybe (Left (Const ()))
 = Nothing
   
   proof. maybe2Maybe' . maybe'2Maybe = id
1. maybe2Maybe' . maybe'2Maybe (Left (Const ()))
 = maybe2Maybe' (maybe'2Maybe (Left (Const ())))
 = maybe2Maybe' Nothing
 = Left $ Const ()
2. maybe2Maybe' . maybe'2Maybe (Right (Identity a))
 = maybe2Maybe' (maybe'2Maybe (Right (Identity a)))
 = maybe2Maybe' (Just a)
 = Right $ Identity a
 
\qed
```

### Proof PreList is a Bifunctor

```haskell
data PreList a b = Nil | Cons a b

instance MyBifunctor PreList where
    bimap _ _ Nil = Nil
    bimap f g (Cons a b) = Cons (f a) (g b)
    first _ Nil = Nil
    first f (Cons a b) =  Cons (f a) b
    second _ Nil = Nil
    second g (Cons a b) = Cons a (g b)
```

Then proof that `Nil` and `Cons a b` are functors to qed, because the composition of a bifunctor and functors is a bifunctor.

Proof:

```
def. instance (Functor b) => Functor (PreList a) where
         fmap f Nil = Nil
         fmap f (Cons a b) = Cons a (fmap f b)

proof. Nil is a functor
  fmap id Nil
= Nil
= id Nil

  fmap (g . f) Nil
= Nil
= fmap g Nil
= fmap g (fmap f Nil)
= (fmap g . fmap f) Nil

proof. Cons a b is a functor when a is fixed:
  fmap id (Cons a b)
= Cons a (fmap id b)
= Cons a (id b)
= Cons a b
= id (Cons a b)

  fmap (g . f) (Cons a b)
= Cons a (fmap (g . f) b))
= Cons a (g . f b)
= Cons a (fmap g (f b))
= Cons a (fmap g (fmap f b))
= fmap g (Cons a (fmap f b))
= fmap g (fmap f (Cons a b))
= (fmap g . fmap f) (Cons a b)

\qed
```
