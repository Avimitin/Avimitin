---
id: haskell
aliases:
  - Haskell
tags: []
---

# Haskell

## Don't add type constraint at type declaration

If we put or don’t put the `Ord k` constraint in the data declaration for `Map k v`,
we’re going to have to put the constraint into functions that assume the keys in
a map can be ordered. If `Map k v` had a type constraint in its data declaration,
the type for `toList` would have to be `toList :: (Ord k) => Map k a -> [(k, a)]`,
even though the function doesn’t do any comparing of keys by order.

## The Functor typeclass

How to understand the `fmap` *function* and the `Functor` *typeclass*?
So first of all, `Functor` is the *typeclass*, the constraint.
For constraint declaration `Functor f`, it limits the *type* `f` must be an
instance of the `Functor` *typeclass*.

Then let's see the details of the `Functor` *typeclass*:

```haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```

It require all instance have the `fmap` implementation, where the type `f` itself
is just a container, containing another type `a`, and the function `(a -> b)`
will convert element in it from type `a` to type `b`.

For `List` type, `fmap` is just a `map`. For example, given a list of integer,
the concrete type `f` at current time is `List`, and type `a` is `Integer`.
Type `List[Integer]` in this case represents `f a`.
And if we pass a function like: `\x -> show x`, which returns `String` for
each element, then the type `List[String]` here represent the type `f b`.

Also worth notice that, typeclass `Functor` wants a type constructor `f`,
so that it can use it to create concrete type `f a`.
Unlike normal typeclass `Show`, `Ord`..., when writing instance of
`Functor`, user doesn't needs to specify a generic concreate type.
