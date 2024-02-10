The sparse compiler is implemented in `mlir/lib/Dialect/SparseTensor/Pipelines/SparseTensorPipelines.cpp`
in `mlir::sparse_tensor::buildSparseCompiler(passManager, SparseCompilerOption)`

## Sparse Compiler Pass list

* LinalgGeneralizationPass
* SparsificationAndBufferizationPass
* CanoicalizerPass
* FinalizingBufferizePass
* GPU Codegen Only

    * SparseGPUCodegenPass
    * StripDebugInfoPass
    * ConvertSCFTOCFPass
    * LowerGpuOpsToNVVMOpsPass
    * GpuToLLVMConversionPass

* ConvertLinalgToLoops
* ConvertVectoToSCF
* ConvertSCFToCF
* ExapndStridedMetadata
* LowerAffine
* ConvertVectorToLLVM (With lowerVectorToLLVMOptions)
* FinalizeMemRefToLLVM
* ConvertComplexToStandard
* ArithExpandOps
* ConvertMathToLLVM
* ConvertComplexToLibm

* Repeat twice

    * ConvertVectorToLLVM
    * ConvertComplexToLLVM

* ReconcileUnrealizedCasts
