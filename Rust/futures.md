- What is Rust future

<!-- tag: #rust #async #future -->

A future is a representation of some operation which will complete in the
future.

A future contains three state. The Poll, Wait, Wake states.

* Poll: A future is taking progress until a point which it can't make more
progress. Or just be done.
* Wait: The future is waitng for a event, which will tell it that it is time to
make more progress.
* Wake: Some event happens and the future is woken up by some function. Then
this future will try to do progess until it is done or it met another point
that it can't do more.

- What is leaf futures
<!-- tag: #rust #async #future #leaf-future -->

A **resource**, provided by runtime, that is non-blocking.

- Non leaf futures
<!-- tag: #rust #async #future #non-leaf-future -->

Treat it as a **task**. It is pause-able computation. It is for user which contains
a set of await operation.

They are not performing a I/O process. They just run and get the leaf-future.

- rust range

tag: rust range

It is better to use `(0..255).contains(&128)` than `128 >= 0 && 128 < 255`.
The syntax `(a..b)` create a Range struct. See more information here.
<https://doc.rust-lang.org/std/ops/struct.Range.html>

- rust async await primer

tag: rust async await primer .await

<https://rust-lang.github.io/async-book/01_getting_started/04_async_await_primer.html>

async transforms a block of code into a state machine that implements a trait
called Future. Blocked Futures will yield control of the thread, allowing other
Futures to run.

The interface, or the outer async, or the first async function, should be run by
executor.

```rust
use futures::executor::block_on; // from futures crate

async fn hello() {
  println!("hello world");
}

fn main() {
  let future = hello();
  block_on(future);
}
```

And await is used **inside** the async block.

```rust
use futures::executor::block_on; // from futures crate

async fn world() {
  println!("world");
}

async fn hello() {
  println!("hello");
  world().await // <- await can only be called inside async block
}

fn main() {
  let future = hello();
  block_on(future);
}
```

.await doesn't block the current thread, but instead asynchronously waits for
the future to complete, allowing other tasks to run if the future is currently
unable to make progress.

