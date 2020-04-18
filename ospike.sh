#! /bin/bash

dirr="./tests/_build/cross.riscv/riscv/"
diro="./tests/_build/cross-original.riscv/riscv" 

range() {
  name=$2
  name+=$(basename $1 .exe)
  name+=".dump"
  # Get object dump of file
  riscv64-unknown-linux-gnu-objdump -d $1 > $name   
  # Extract highest address of the dump
  grep "." $name | tail -1 | sed -e 's/:.*//' -e 's/   //g'
}

# Run spike and dump opsikes analysis into file.log 
spike_ospike () {
  name=$3
  name+=$(basename $1 .exe)
  name+=".log"
  echo $2
  echo "Running spike+ospike for: " $1 
  spike -l  --dc=128:2:64 --ic=128:2:64 $pk $1 2>&1 | ospike stdin -o $name -lower 0 -upper 0x$2 
}

for i in $dirr*.exe; do highest=$(range $i $dirr); spike_ospike "$i" "$highest" "$dirr"; done 
for i in $diro*.exe; do highest=$(range $i $diro); spike_ospike "$i" "$highest" "$diro"; done 

