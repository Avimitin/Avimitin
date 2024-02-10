## Lifetime

Lifetime is a named region of the code that a reference must be valid for.

A part of memory might be drop and reinitialize in some part of the program,
and a reference should not outlive its owner. So we need lifetime to indicate
that a reference is valid during paths of executions.

In most of the time, lifetime can be inferred by rust compiler. But when our
code cross the function scope boundary or thread boundary, things will get
compilcated. No one but you can guarantee that a reference's owner can live
long enough till all it's children reference are eliminated.

```rust
fn as_str(d: &u32) -> &str {
  let s = format!("{d}")
  &s
}
```

This is a wrong example, as variable `s` can not live long enough as the `d`
variable's owner. Desugar the above example we will get:

```rust
fn as_str<'a>(d: &'a u32) -> &'a str {
  'b: {
    let s = format!("{d}")
    &'a s
  }
}
```

In the above example, the `s` variable are live in the `'b` lifetime scope,
however it want to return a reference that live in `'a` lifetime scope.
It is invalid, cuz `s` is dropped after the variable `s` return.
The `&s` can not outlive its owner `s`.

This is what lifetime analysis did.
