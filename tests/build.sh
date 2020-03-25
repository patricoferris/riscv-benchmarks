#!/bin/bash 
# Build the RISC-V cross-compiling switch if not already done 
riscv_repo=https://github.com/patricoferris/opam-cross-shakti.git

echo "Please pass either opam (to create the switch) or build (to build the tests)"
read input

if [ $input == "opam" ]
then 
  echo "Building the OPAM cross-compiling switch for all your cross-compiling needs"
  echo "A local riscv-ocaml should be located at /riscv-ocaml"
  opam switch create cross 4.07.0 
  opam install dune 
  opam repo add riscv-cross $riscv_repo 
elif [ $input == "build" ]
then 
  echo "Switching to the cross-compiling switch" 
  opam switch cross 

  echo "Building the tests"
  dune build 
else 
  echo "Please pass opam or build to either build the cross-compiling switch or to build the tests"
fi 