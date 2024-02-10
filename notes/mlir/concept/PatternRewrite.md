PatternRewriter 是一个有向图转换框架，其主要由 Pattern 定义和 Pattern 应用两个部分组成。

# Pattern Definition

`RewritePattern` 是一个代表 MLIR 里所有 Rewrite Pattern 的基类，创建一个新的 Pattern
需要从这个基类继承。一个 `RewritePattern` 由以下几部分组成：

## Benefit

应用一个 RewritePattern 之后的预期收益。这个收益在构造这个 Pattern 的时候是静态的，
但是也可以在 Pattern 初始化的时候动态地计算。比如有些领域特定的优化，在目标的环境里
计算得出。这个限制使得 MLIR 有能力融合各种 Pattern，以及将 Pattern 编译成一个状态机。

> <https://dl.acm.org/citation.cfm?id=3179501>

## Root Operation Name

这个模式所匹配的 Root Operation 的名称。
如果指定，只有具有给定 Root Operation 的 operations 才会被提供给 match & rewrite 实现。
如果没有指定，任何 Operation 类型都会可能被尝试 rewrite。
应该尽可能提供 root operation 的名称，因为它可以在应用成本模型时简化对 pattern 的分析。
如果的确要对所有的 operation 做 rewrite，应该传入 `MatchAnyOpTypeTag` 来显示声明这个目的。

## *Match* & *Rewrite* 的实现

一组实现模式匹配和 IR Rewrite 的代码。Match 和 Rewrite 的代码可以分开实现，也可以用
`matchAndRewrite` 方法组合实现。但如果实现 `matchAndRewrite`，需要遵循在 match
成功前不要修改 IR 的原则。
