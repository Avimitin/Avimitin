## 基础概念

- `crate`: 可以是可执行文件，也可以是库
- `package`: 一个包含单个或数个 crates 的包裹。有一个 `Cargo.toml`
文件指引如何构建这些 crates。一个 package 最多有一个库 crate，可以
有多个可执行 crate，但是至少要有一种 crate。
- cargo 会默认把 `src/lib.rs` 和 `src/main.rs` 认为是 crate root.
他会自动在 `Cargo.toml` 里找到如何构建包的指引。
- 一个有 `lib.rs` 的 crate 会被当成库，有 `main.rs` 的 crate 会被
当作二进制。一个 package 可以同时存在这两个文件，名字和 package 的
名字相同。
- 一个 package 可以有很多个可执行的 crate。通过把不同的文件放在
`src/bin` 下来将他们当作不同的可执行的 crate。
- `mod` 用来管理一系列的代码
- `pub use` 可以将当前 use 的 namespace 暴露出去，让导入当前 mod
的外部代码可以直接使用。
