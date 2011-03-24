#ifndef __MULTICORE_H__
#define __MULTICORE_H__

#include "spr_defs.h"
#include "support.h"
#include "mutex.h"
#include "board.h"

typedef struct {
	unsigned int waiting;
	unsigned int signal;	
} condition_t;

typedef struct {
	mutex_t lock;
	unsigned int count;
	unsigned int cores;
	condition_t cond;
} barrier_t;


extern barrier_t multicore_boot_barrier;
extern void boot_barrier();

extern void barrier_init(barrier_t *barrier);
extern void barrier(barrier_t *barrier);

extern void condition_init(condition_t *cond);
extern void condition_wait(condition_t *cond,mutex_t *lock);
extern void condition_broadcast(condition_t *cond);

extern int coreid();

void multicore_init();

#endif
