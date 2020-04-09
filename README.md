# RISC-V Benchmarks
-------------------

This repository contains some tests for analysing the OCaml compiler for the RISC-V target architecture. The `tests/riscv` folder contains custom
test cases for particular extensions to the compiler whilst the `tests/sandmark` folder contains some of the more straightforward tests taken from the [sandmark](https://github.com/ocaml-bench/sandmark). 

The tests are meant to be run in conjunction with [this]() Dockerfile - the point being it creates two opam switches for the original cross-compiler (4.07.0) and the customised version, which are then both statically built using `dune`. The `ospike.sh` script then runs the tests using the Spike simulator piping the log through the `ospike` tool which can be customised by changing the shell script. 