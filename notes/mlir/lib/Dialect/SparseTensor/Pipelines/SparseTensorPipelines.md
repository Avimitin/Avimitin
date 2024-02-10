> namespace mlir::sparse_tensor

## Function `buildSparseCompiler`

Where sparse compiler was built. It add multiple passes into PassManager from
Dialect Generalization to Dialect Lowering.

The sparse_compiler specific option is passed in the SparseCompilerOptions argument.
Those options will be used by `createSparsificationAndBufferizationPass(...)` function.
See Transforms/SparsificationAndBufferizationPass.md for detail.
In general, this function just a util function to create a `SparsificationAndBufferizationPass`
wrapped in unique pointer.

If user enable GPU code generation when building MLIR source code by macro
`MLIR_GPU_TO_CUBIN_PASS_ENABLE`, or add value into sparse compiler option gpuTriple,
then it will also finalize gpu code generation.

## Function `registerSparseTensorPipelines`

This function will be used by InitAllPass::registerAllPasses to register the
sparse-compiler pass for command line parser.
