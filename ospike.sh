#! /bin/bash

range() {
  name=$(basename $1 .exe)
  name+=".dump"
  # Get object dump of file 
  riscv64-unknown-linux-gnu-objdump -d $1 > $name   
  # Extract highest address of the dump
  grep "." $name | tail -1 | sed -e 's/:.*//' -e 's/   //p'
}

# Run spike and dump opsikes analysis into file.log 
ospike () {
  name=$(basename $1 .exe)
  name+=".log"
  spike -l $pk $1 2>&1 | ospike stdin -o $name 
}

for i in *.exe; do highest=range $i; ospike $i $highest; done 