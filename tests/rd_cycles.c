#include <stdio.h>
#include <caml/mlvalues.h>

value rd_cycles(value unit)
{
  unsigned long cycles;
  unsigned int lo,hi;
  asm volatile ("rdtsc" : "=a" (lo), "=d" (hi));
  return ((uint64_t)hi << 32) | lo;
}