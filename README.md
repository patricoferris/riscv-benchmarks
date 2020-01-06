# RISC-V Benchmarks
-------------------

A tool for compiling a series of RISC-V OCaml cross-compiling benchmarks. You will need `dune` to build everything. 

Here is an example usage: 

```
git clone https://github.com/patricoferris/riscv-benchmarks.git
cd riscv-benchmarks/src 

dune exec -- ./bench.exe build -c <which ever compiler> -args "arg1 arg2" -v
```