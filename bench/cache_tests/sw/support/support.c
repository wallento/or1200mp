/* Support */

#ifndef OR32
#include <sys/time.h>
#endif

#include "spr_defs.h"
#include "time.h"
#include "support.h"
#include "int.h"

void excpt_dummy();
//void int_main();

unsigned long _buserr_except = (unsigned long) excpt_dummy;
unsigned long _dpf_except = (unsigned long) excpt_dummy;
unsigned long _ipf_except = (unsigned long) excpt_dummy;
//unsigned long excpt_tick = (unsigned long) excpt_dummy;
unsigned long _align_except = (unsigned long) excpt_dummy;
unsigned long _illegal_except = (unsigned long) excpt_dummy;
unsigned long _hpint_except = (unsigned long) int_main;
unsigned long _dtlbmiss_except = (unsigned long) excpt_dummy;
unsigned long _itlbmiss_except = (unsigned long) excpt_dummy;
unsigned long _range_except = (unsigned long) excpt_dummy;
unsigned long _fpu_except = (unsigned long) excpt_dummy;
unsigned long excpt_syscall = (unsigned long) excpt_dummy;
unsigned long excpt_break = (unsigned long) excpt_dummy;
unsigned long _trap_except = (unsigned long) excpt_dummy;
unsigned long _res2_except = (unsigned long) excpt_dummy;


/* Start function, called by reset exception handler.  */
void reset ()
{
  int i = main();
  or32_exit (i);  
}

/* return value by making a syscall */
void or32_exit (int i)
{
  asm("l.add r3,r0,%0": : "r" (i));
  asm("l.nop %0": :"K" (NOP_EXIT));
  while (1);
}

/* print long */
void report(unsigned long value)
{
  asm("l.addi\tr3,%0,0": :"r" (value));
  asm("l.nop %0": :"K" (NOP_REPORT));
}

/* just to satisfy linker */
void __main()
{
}

/* For writing into SPR. */
void mtspr(unsigned long spr, unsigned long value)
{	
  asm("l.mtspr\t\t%0,%1,0": : "r" (spr), "r" (value));
}

/* For reading SPR. */
unsigned long mfspr(unsigned long spr)
{	
  unsigned long value;
  asm("l.mfspr\t\t%0,%1,0" : "=r" (value) : "r" (spr));
  return value;
}


void excpt_dummy() {}


/* activate printf support in simulator */
void noprintf(const char *fmt, ...)
{
  /* The following only works with the newlib compiler */
  /*
  __asm__ __volatile("	l.addi r1,r1,0xfffffff8\n \
	l.sw 0(r1), r3\n \
	l.sw 4(r1), r4\n \
	l.addi r4, r1, 0xc\n \
	l.lwz r3, -4(r4)\n \
	l.nop %0\n \
	l.lwz r3, 0(r1)\n \
	l.lwz r4, 4(r1)\n \
	l.jr r9\n \
	l.addi r1,r1,0x8": :"K" (NOP_PRINTF));
  */
  /* The following should work with the uClibc compiler */
  va_list args;
  va_start(args, fmt);
  __asm__ __volatile__ ("  l.addi\tr3,%1,0\n \
                           l.lwz\tr4,-4(r2)\n \
                           l.nop %0": :"K" (NOP_PRINTF), "r" (fmt), "r"  (args));

}
