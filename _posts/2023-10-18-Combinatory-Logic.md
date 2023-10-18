---
layout: post
title: Combinatory Logic
categories: Maths
tags: [Maths]
---

## Elementary Combinators

| ---------- | ------------------------ |
| Combinator | Name                     |
| :--------: | :----------------------: |
| I          | Elementary Identificator |
| C          | Elementary Permutator    |
| W          | Elementary Duplicator    |
| B          | Elementary Compositor    |
| K          | Elementary Cancellator   |

Definitions in Haskell:

```haskell
i = id
c = flip
w f x = f x x
b = (.)
k x _ = x
```

## Blackbird

Pipe a unary function and a binary function. In Python:

```python
def b1(f, g):
    return lambda x y: f(g(x, y))
```

In Haskell, define a blackbird combinator:

```haskell
(.:) :: (c -> d) -> (a -> b -> c) -> a -> b -> d
(.:) = (.) (.) (.)    -- 3-train
infixl 3 .:
```

### Evaluation

Prerequisites:

```haskell
\f g x = f (g x)
\f g x = f $ g x
\f g   = f . g      -- eta-reduction
```

Full eta-reduction process:

```haskell
b1 = \f g x y -> f (g x y)
b1 = \f g x y -> f $ g x y
b1 = \f g x   -> f . g x
b1 = \f g x   -> (.) f $ g x
b1 = \f g     -> (.) f . g
b1 = \f g     -> (.) ((.) f) g
b1 = \f       -> (.) ((.) f)
b1 = \f       -> (.) $ (.) f
b1 =             (.) . (.)
b1 =             (.) (.) (.)
```

refer: <https://drewboardman.github.io/jekyll/update/2020/01/14/blackbird-operator.html>

### Examples

`zipWith` can boardcast a binary operation between two objects typed functor of something and return an object typed fuctor of the type which the binary operation returns.

```haskell
zipWith :: Functor f => (a -> b -> c) -> f a -> f b -> f c
```

Especially, instantiate functor `f` into list:

```haskell
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
```

For instance:

```haskell
zipWith (==) [1, 2, 3, 4] [1, 2, 4, 4]      -- [True, True, False, True]

-- Mastermind game
exactMatches :: [Int] -> [Int] -> Int
exactMatches x y = sum $ fmap fromEnum $ zipWith (==) x y

exactMatches [1, 2, 3, 4] [1, 2, 4, 4]        -- 3
```

We can do reduction on `exactMatches`:

```haskell
exactMatches x y = sum $ fmap fromEnum $ zipWith (==) x y
exactMatches x y = sum . fmap fromEnum $ zipWith (==) x y
-- 'cause `sum . fmap from Enum` is a unary function,
-- `zipWith (==) x y` is a binary function application, 
-- it just fits the pattern of the Blackbird combinator:
exactMatches     = sum . fmap fromEnum .: zipWith (==)
```

Or:

```haskell
exactMatches = sum .: zipWith (fromEnum .: (==))
```
