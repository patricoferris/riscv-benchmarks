# RISC-V Benchmarks
-------------------

A tool for compiling a series of RISC-V OCaml cross-compiling benchmarks. You will need `dune` to build everything. 

Here is an example usage: 

```
git clone https://github.com/patricoferris/riscv-benchmarks.git
cd riscv-benchmarks/src 

dune exec -- ./bench.exe build -c <which ever compiler> -args "arg1 arg2" -v
```

Below is the output of `dune exec -- ./bench.exe -help`

```
🐫  RISC-V Benchmark Tool: a CLI for easier compilation 🐫

  bench.exe [MODE]

=== flags ===

  [-args <argument-list>]  arguments to pass in
  [-c <compiler>]          ocamlopt to use
  [-v]                     printing build commands etc.
  [-build-info]            print info about this build and exit
  [-version]               print the version of this build and exit
  [-help]                  print this help text and exit
```