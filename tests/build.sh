#!/bin/bash 
echo "Switching to the cross-compiling switch" 
opam switch cross 

echo "Building the tests"
dune build -x riscv
