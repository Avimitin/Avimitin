#!/bin/sh

run_cmake() {
  local src=$1; shift

  local cmake_options=(
    -DLLVM_ENABLE_PROJECTS="mlir;llvm"
    -DLLVM_BUILD_EXAMPLES=ON
    -DLLVM_TARGET_TO_BUILD="host"
    -DCMAKE_BUILD_TYPE=Debug
    -DLLVM_ENABLE_ASSERTIONS=ON
    -DCMAKE_C_COMPILER=clang
    -DCMAKE_CXX_COMPILER=clang++
    -DMLIR_INCLUDE_INTEGRATION_TESTS=ON
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  )

  cmake -G Ninja $src ${cmake_options[@]}
}

run_cmake ../llvm
