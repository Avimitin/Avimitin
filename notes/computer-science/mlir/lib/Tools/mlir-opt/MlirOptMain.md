## `mlir::MlirOptMain`

The main entry for running the mlir-opt program. It will register all the command line options,
parse the command line input, open the input file, create the output file, and finally execute the shadowed
`mlir::MlirOptMain(output, buffer, registry, config)` function. For convenience, name it
MlirOptMainExec

The MlirOptMainExec function will set up threads and then start processing the input file memory buffer.
The file memory buffer is added to the [LLVM SourceMgr](https://llvm.org/doxygen/classllvm_1_1SourceMgr.html#details),
a parser to handle include stacks and diagnostic wrangling.
Then function `performActions()`(line 439) will be executed to handle all operations.

The `performActions` function will temporarily disable multithreading during parsing. (`context->disableMultithreading()`)
Then it will prepare a parser config to parse the input file.

```cpp
OwningOpRef<Operation *> op = parseSourceFileForTool(
  sourceMgr, parseConfig, !config.shouldUseExplicitModule());
```

> The OwningOpRef here is a wrapper for the Operation

The multithreading will be re-enabled after file parsed.

After the parsing is done, an passes registered `PassManager` will be set up.
Command line options and reproducer options are applied to it.
Finally, the pass manager will start running the pipeline for all operations in the input file by `pm.run(*op)`
and the optimised ASM will be written to the output file.

All *Passes* (from general passes to Dialect passes) in the `PassManager` are registered in
[mlir/include/mlir/InitAllPasses.h::registerAllPasses()](https://github.com/llvm/llvm-project/blob/main/mlir/include/mlir/InitAllPasses.h#L52).
It will also register Dialect pipelines here,
such as the sparse_tensor pipeline (the sparse compiler).
This global registry is used by command line tools.

The next step to learn how the input operations are optimised is to take a 
deeper loop at the way in which these passes are written.
