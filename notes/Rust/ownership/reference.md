## Reference Type

- Shared ref: `&`
- Multable ref: `&mut`

Two rules:

1. reference can not outlive its owner
2. multable reference can not be *aliased*[^1]

[^1]: aliased means create an *shared reference* to the same
owner as the *multable reference*.

You can't not use the multable
reference when there is a shared reference created.

```rust
let mut i = 1;

let a = &mut i;
let b = &i; // <= b's value depends on action on A, this is not safe

*b = 2; // <= this is not allowed
```

Conclusion: User should not provides **READ** and **WRITE** at the same time.

