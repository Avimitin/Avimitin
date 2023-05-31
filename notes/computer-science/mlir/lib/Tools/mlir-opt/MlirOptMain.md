## `mlir::MlirOptMain`

The main entry for running the mlir-opt program. It will register all the commandline options,
parse commandline input, open input file, create output file, and finally execute the shadowed
`mlir::MlirOptMain(output, buffer, registry, config)` function. For convenience, name it
MlirOptMainExec

The MlirOptMainExec function set up threads, then start processing input file memory buffer.
The file memory buffer will be added into [LLVM SourceMgr](https://llvm.org/doxygen/classllvm_1_1SourceMgr.html#details),
a parser handles include stacks and diagnostic wrangling.
Then start `performActions`(line 439).

The `performActions` function will disable multithreading temporarily during parsing. (`context->disableMultithreading()`)
Then it will prepare parser config, parse the input file

```cpp
OwningOpRef<Operation *> op = parseSourceFileForTool(
  sourceMgr, parseConfig, !config.shouldUseExplicitModule());
```

> The OwningOpRef here is a wrapper for the Operation

and re-enable the multithreading.

After parsing done, `PassManager` will be set up(applying commandline option and reproducer option)
and start running the pipeline(`pm.run(*op)`) . Finally, the optimized ASM will be written into output.

*Passes* are registered in [mlir/include/mlir/InitAllPasses.h::registerAllPasses()](https://github.com/llvm/llvm-project/blob/main/mlir/include/mlir/InitAllPasses.h#L52),
from general passes to Dialect passes. It will register Dialect pipelines here too.
This global registry is used by commandline tools.
