from memory import memset_zero
from algorithm import vectorize, parallelize
from sys.intrinsics import strided_load
from math import trunc, mod
from random import rand

struct Matrix[dtype: DType = DType.float32]:
    var dim0: Int
    var dim1: Int
    var _data: DTypePointer[dtype]
    alias simd_width: Int = simdwidthof[dtype]()

    fn __init__(inout self, *dims: Int):
        self.dim0 = dims[0]
        self.dim1 = dims[1]
        self._data = DTypePointer[dtype].alloc(dims[0] * dims[1])
        rand(self._data, dims[0] * dims[1])
        
    fn __copyinit__(inout self, other: Self):
        self._data = other._data
        self.dim0 = other.dim0
        self.dim1 = other.dim1

    fn _adjust_slice_(self, inout span: slice, dim: Int):
        if span.start < 0:
            span.start = dim + span.start
        if not span._has_end():
            span.end = dim
        elif span.end < 0:
            span.end = dim + span.end
        if span.end > dim:
            span.end = dim
        if span.end < span.start:
            span.start = 0
            span.end = 0

    fn __getitem__(self, x: Int, y: Int) -> SIMD[dtype,1]:
        return self._data.simd_load[1](x * self.dim1 + y)

    fn __getitem__(self, owned row_slice: slice, col: Int) -> Self:
        return self.__getitem__(row_slice, slice(col,col+1))

    fn __getitem__(self, row: Int, owned col_slice: slice) -> Self:
        return self.__getitem__(slice(row,row+1),col_slice)

    fn __getitem__(self, owned row_slice: slice, owned col_slice: slice) -> Self:
        self._adjust_slice_(row_slice, self.dim0)
        self._adjust_slice_(col_slice, self.dim1)

        var src_ptr = self._data
        var sliced_mat = Self(row_slice.__len__(),col_slice.__len__())

        @parameter
        fn slice_column(idx_rows: Int):
            src_ptr = self._data.offset(row_slice[idx_rows]*self.dim1+col_slice[0])
            @parameter
            fn slice_row[simd_width: Int](idx: Int) -> None:
                sliced_mat._data.simd_store[simd_width](idx+idx_rows*col_slice.__len__(),
                                                        strided_load[dtype,simd_width](src_ptr,col_slice.step))
                src_ptr = src_ptr.offset(simd_width*col_slice.step)
            vectorize[self.simd_width,slice_row](col_slice.__len__())
        parallelize[slice_column](row_slice.__len__(),row_slice.__len__())
        return sliced_mat

    fn print(self, prec: Int=4)->None:
        var rank:Int = 2
        var dim0:Int = 0
        var dim1:Int = 0
        var val:SIMD[dtype, 1]=0.0
        if self.dim0 == 1:
            rank = 1
            dim0 = 1
            dim1 = self.dim1
        else:
            dim0 = self.dim0
            dim1 = self.dim1
        if dim0>0 and dim1>0:
            for j in range(dim0):
                if rank>1:
                    if j==0:
                        print_no_newline("  [")
                    else:
                        print_no_newline("\n   ")
                print_no_newline("[")
                for k in range(dim1):
                    if rank==1:
                        val = self._data.simd_load[1](k)
                    if rank==2:
                        val = self[j,k]
                    let int_str: String
                    if val > 0 or val == 0:
                        int_str = String(trunc(val).cast[DType.int32]())
                    else:
                        int_str = "-"+String(trunc(val).cast[DType.int32]())
                        val = -val
                    let float_str: String
                    float_str = String(mod(val,1))
                    let s = int_str+"."+float_str[2:prec+2]
                    if k==0:
                        print_no_newline(s)
                    else:
                        print_no_newline("  ",s)
                print_no_newline("]")
            if rank>1:
                print_no_newline("]")
            print()
            if rank>2:
                print("]")
        print("  Matrix:",self.dim0,'x',self.dim1,",","DType:", dtype.__str__())
        print()

from helpers import text
fn main() raises:
    let input: String
    with open("inputs/day3_input.txt", "r") as f:
        input = f.read()
    let lines = text.split_string(input, "\n")
    let first_line = lines[0]
    let y: Int = 5
    let mat = Matrix(len(first_line),y)
    mat.print()

    mat[2:4,-3:].print()
    mat[1:3,:].print()
    mat[0:3,0:3].print()
    mat[1::2,::2].print()
    mat[:,-1:2].print()
    mat[-1:2,:].print()