- What is `thread_local!{}.with`

<!-- tag: #thread #rust #localkey -->

```rust
// create a new struct std::thread::LocalKey
thread_local!(static FOO: RefCell<u32> = RefCell::new(1));

// Give a closure to LocalKey to make action to the inner key
FOO.with(|f| {
    assert_eq!(*f.borrow(), 1);
    *f.borrow_mut() = 2;
});
```
