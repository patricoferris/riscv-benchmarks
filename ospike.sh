#! /bin/bash

dir="./tests/out/riscv/"

range() {
  name=$dir
  name+=$(basename $1 .exe)
  name+=".dump"
  # Get object dump of file
  riscv64-unknown-linux-gnu-objdump -d $1 > $name   
  # Extract highest address of the dump
  grep "." $name | tail -1 | sed -e 's/:.*//' -e 's/   //g'
}

# Run spike and dump opsikes analysis into file.log 
spike_ospike () {
  name=$dir
  name+=$(basename $1 .exe)
  name+=".log"
  echo $2
  echo "Running spike+ospike for: " $1 
  spike -l $pk $1 2>&1 | ospike stdin -o $name -lower 0 -upper 0x$2 
}

for i in $dir*.exe; do highest=$(range $i); spike_ospike "$i" "$highest"; done 

