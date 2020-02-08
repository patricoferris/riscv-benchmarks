#!/bin/sh

echo "Running Benchmarks for RISC-V with Custom Instructions"
dune exec -- ./bench.exe spike-build -c /riscv-ocaml/bin/ocamlopt -o "custom.txt"
dune exec -- ./bench.exe spike -spike "--dc=128:2:64 --ic=128:2:64" -pk -s -o "custom.txt"

echo "Running Benchmarks for RISC-V"
dune exec -- ./bench.exe spike-build -c /og-riscv-ocaml/bin/ocamlopt -o "original.txt"
dune exec -- ./bench.exe spike -spike "--dc=128:2:64 --ic=128:2:64" -pk -s -o "original.txt" 


