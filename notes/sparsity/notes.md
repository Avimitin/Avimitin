## Sparsity

### 什么是 Sparse

一个矩阵，或一个数组，当它内部大部分元素的值都是 0 的时候，在数值分析中会形容其稀疏。
与 Sparse 对应的，当一个矩阵或数组内大部分元素都是非零的时候，就被称为密集（Dense）。

```js
[
   [1, 2, 0, 0, 0, 0, 0, 0],
   [0, 0, 3, 4, 0, 0, 0, 0],
   [0, 0, 0, 0, 5, 6, 0, 0],
   [0, 0, 0, 0, 0, 0, 7, 8],
]
```

比如，对于一个 4 行 8 列，大小为 32 个元素的矩阵而言，当它有 8 个元素是不为 0 的，
而其他 24 个元素都是 0 的情况下，称这个矩阵的稀疏程度(Sparsity)为 75%，而密集程度为 25%。

```haskell
sparsity = zero_elem_count / matrix_size
   where zero_elem_count = length (filter (== 0) matrix)
         matrix_size     = length matrix
```


零值元素的比例要到多大才能被称为稀疏(Sparse)呢？这个没有严格定义。
假设有一个矩阵，对其所有的零值进行特殊处理之后，我们能获得存储和计算的收益，
那么就称这个矩阵是稀疏的。反之，如果特殊处理零值之后，对矩阵的计算和存储是效率是
不变的，则称这个矩阵是密集的。

### 为什么会存在稀疏

稀疏这个概念主要用于网络工程和数理分析上。在脑海中想象一片森林，和一条条的树藤，在这个森林里，
每颗树之间可能会有树藤相连，也可能有完全孤立的，没有用树藤和别的树连接的树。
此时来计量树之间的连接性，把完全没有树藤的树记作 0，把只有一条树藤的树也记为 0。
此时想象在这篇森林中的某一块区域，有一排树是完全没有树藤的，
有一排树虽然有树藤，但是只有一条树藤将他们连成一条线，
只有寥寥几颗树会和更多树相连。
那么这一块领域内，就会称这些树是稀疏连接的，这一块领域则是一块稀疏领域。
与之对应的，在记录里，这一片领域对应的值将是大量的 0，只有少量的非零元素

与之相对的，再想象有一块区域，树和树之间不只是邻接着有树藤连接，而是彼此相连，
一棵树可能会和其他三四棵树相连。那么这一块区域就可以称作是一块密集领域。
与之对应的，这一块领域树的连接性对应的值都会是非零的值。

这类数值在计算中常常会出现，
理论上来说，压缩稀疏矩阵相对密集矩阵压缩起来会更加简单。
对于计算机而言，
为稀疏的矩阵设计特别的算法和数据结构可以帮助加速计算和提供高效的存储。
直接用普通的矩阵算法来操作稀疏矩阵是不太现实的。

### 为什么要专门处理稀疏的矩阵或向量

为稀疏矩阵特化存储结构和线性计算的算法，可以显著地提高对矩阵计算的求解时间。
除此之外，在常见的矩阵计算样例中，矩阵可能会有千甚至上万的行和列，全部存储
将占用大量的存储空间。使用特殊的数据结构来存储非零的元素能显著减少存储空间。

同时这些特殊化的处理对于之后图的操作也有帮助。

除此之外，当只关注单层内存的串行计算机时（？），实数或者复数的浮点运算的数量，
和程序运行的时间成线性的关系。因此，利用矩阵的稀疏性就能在保持开销比例的情况下
来减少浮点运算。但是在现代计算机上，内存缓存和向量化，并行化的体系结构会为这类
性能比较引入更多需要考虑的因素。

<!-- TODO: 学习向量计算机的概念 -->
<!-- TODO: 学习图的概念 -->

### 图与稀疏矩阵的关系

任何的方形矩阵都有一个相关的有向图，同时任何一个有向图都有一个相关方形稀疏矩阵。
只要矩阵 A 的 i 行 j 列元素 `a^ij` 是一个非零元素，则代表着在图中，节点 i 指向
了节点 j。

### 稀疏矩阵的计算机实现

在稀疏矩阵里，通常需要一个特殊的数据结构来存储和访问非零的元素。
具体的实现分成两种：

#### 支持高效修改的（这些操作通常用于构造稀疏矩阵）

* DOK (Dictionary of keys)

DOK 的实现方式是用字典作为数据结构，用行和列作为 key 来访问对应的矩阵值。
如果结果为空，那么该行列对应的值是零值。

   - 优点: 构造简单，可以增量更新
   - 缺点: 无法存储非零值的次序，不便于顺序遍历操作。

各种属性（参考实现：<https://github.com/scipy/scipy/blob/v1.10.1/scipy/sparse/_dok.py>）

- 矩阵实现：字典
- 矩阵大小：内部字典大小，既非零元素的数量
- 矩阵访问：使用行列的值为 key 访问内部的字典，如果找不到值就返回 0

* LIL (List of lists)

> 参考： <https://github.com/scipy/scipy/blob/v1.10.1/scipy/sparse/_lil.py>

一个可增量构造矩阵的结构。LIL 实现需要用到两个列表，一个列表代表行，行内每一个列表元素也是一个数组，
数组内存非零元素对应的列的位置。

另一个列表存实际的非零元素的值，想要获得矩阵 i 行 j 列的元素，需要先访问
row 数组的第 i 个元素取出其存储的所有列的信息，然后枚举遍历找到哪个元素
的值是 j，用这个元素的索引来索引非零元素列表。

Example:

```haskell
matrix = [
   [0, 1, 0],
   [2, 4, 0],
   [0, 0, 8],
] -- (0, 1; 1), (1, 0; 2), (1, 1; 4), (2, 2; 8)

lil_matrix = Matrix {
   row = [
      [1],
      [0, 1],
      [2],
   ],
   data = [
      [1],
      [2, 4],
      [8],
   ]
}
```

用类型表示：

```haskell
type T = AnyType

type Column = Integer
type Row = [ [Column] ]
type Data = [ [T] ]

data Matrix = Matrix {
   row :: Row,
   data :: Data
}
```

构建稀疏矩阵用 LIL 很方便，构建结束之后再转换到
算术操作和矩阵操作效率更高的 CSR 或者 CSC 结构。

优点：

1. 支持引用矩阵的一段切片 (slicing the matrix)
2. 更新矩阵的结构更加高效
3. 内存占用相当的小

缺点：

1. 对矩阵的算术计算效率低
2. 对矩阵元素和列的引用效率和矩阵大小成正比

* COO (Coordinate list)

COO 则更进一步，扩展了上述的数组，用三个列表来表达“行”，“列”，和“值”。比如对于索引 k，
矩阵 `row[k]`, `col[k]` 的值就是 `data[k]`。

COO 的优点：

- 能快速的转换到各种 Sparse 格式
- 支持重复读写同一个位置的元素
- 能高效转换到 CSR/CSC 格式

缺点：

- 并不能直接性的使用 COO 格式做算术操作
- 也不能直接引用内部数据

COO 的用途：快速构造出稀疏矩阵并转换到 CSR/CSC 格式。

2. 支持高效访问和数组操作的

* CSR / CRS(Compressed Sparse Row/Compressed Row Storage) / Yale Format

CSR 支持对行的快速索引访问和矩阵向量乘法。其实现主要使用三个一维的数组，分别存放值，列索引，行索引。
实现上与 COO 很像，但是压缩了行的索引。

* CSC (Compressed Sparse Column)

