#include <stdio.h>
#include <caml/mlvalues.h>

#ifdef __x86_64__
uintnat rd_cycles(value unit)
{
  unsigned long cycles;
  unsigned int lo,hi;
  asm volatile ("rdtsc" : "=a" (lo), "=d" (hi));
  return ((uint64_t)hi << 32) | lo;
}
#endif

#ifdef __riscv
uintnat rd_cycles(value unit)
{
  uintnat cycles;
  asm volatile ("rdcycle %0" : "=r" (cycles));
  return cycles;
}
#endif

