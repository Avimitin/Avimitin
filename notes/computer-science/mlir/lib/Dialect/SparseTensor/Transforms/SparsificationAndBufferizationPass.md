## SparsificationAndBufferizationPass

A pass that lowers tensor ops to memref ops.
Sparse Tensor ops are lowered through Sparsification and follow-up pass that
lowers sparse_tensor Dialect ops.
Dense Tensor ops are lowered through BufferizableOpInterface implementations.

This pass accept a bunch of options, these options should be pass through
sparse-compiler pass.

Dense tensor are bufferized by `::runDenseBufferization()` method.
This method will filter out all the Tensor with sparse attribute, and do
bufferization for only dense op.

Sparse tensor are lowering(bufferized) through function `::runOnOperation()`.
This function contains three main parts.

1. Enabling transformations. A new OpPassManager is created to add
PreSparsificationRewritePass, EmptyTensorToAllocTensorPass. Then run the
first pipeline.
2. Bufferize all sparse ops. A new OpPassManager is created to add
SparsificationPass, PostSparsificationRewritePass...
3. Bufferize dense ops by `::runDenseBufferization()`

### Step 1

### Step 2

Vector related pass is enabled when VL is set. Then options.vectorLength will
init the `SparsificationAndBufferizationPass::vectorLength` field. If the field
value is greater than zero, it will add `LoopInvariantCodeMotionPass` and
`SparseVectorizationPass` into `OpPassManager`.

If RuntimeLibrary is not enabled, `SparseTensorCodegenPass`, `SparseBufferRewritePass`
and `StorageSpecifierToLLVMPass` will be added into `OpPassManager`.
If RuntimeLibrary is enabled, then only `SparseTensorConversionPass` will be added
into `OpPassManager`.

And finally the pipeline will be ran.
