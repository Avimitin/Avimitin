## `ConvertRewriter`

A sparse rewriting rule for convert operator. It holds three rewrite rules:

1. sparse to sparse
2. sparse to dense
3. dense to sparse

### `sparse2SparseRewrite`

A rewriter handle the sparse tensor to sparse tensor conversion.
Handles sparse tensor to sparse tensor conversion as follows:

       if src is not COO
           construct a COO to represent the src
       sort the src COO
       foreach elemment in the sorted src COO
         insert element to dst

### `sparse2DenseRewrite`
### `dense2SparseRewrite`

## `ConcatenateRewriter`
