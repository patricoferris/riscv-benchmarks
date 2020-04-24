#! /bin/bash
echo "What subfolder of the benchmarks do you want to run?" 
read sub 
echo "What command line argument would you like to pass to the program?"
read arg 

dirr="./tests/_build/cross.riscv/"$sub
diri="./tests/_build/cross-inline.riscv/"$sub
diro="./tests/_build/cross-original.riscv/"$sub

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
  spike -l  --dc=128:2:64 --ic=128:2:64 $pk $1 $arg 2>&1 | ospike stdin -o $name -lower 0 -upper 0x$2 
}

for i in $dirr*.exe; do highest=$(range $i $dirr); spike_ospike "$i" "$highest" "$dirr"; done 
for i in $diri*.exe; do highest=$(range $i $diri); spike_ospike "$i" "$highest" "$diri"; done
for i in $diro*.exe; do highest=$(range $i $diro); spike_ospike "$i" "$highest" "$diro"; done 

