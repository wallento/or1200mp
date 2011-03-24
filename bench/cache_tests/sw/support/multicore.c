#include "multicore.h"
#include "board.h"
#include "uart.h"
#include <stdlib.h>

barrier_t multicore_boot_barrier;

int coreid() {
	return mfspr(SPR_COREID);
}



void boot_barrier() {
	barrier(&multicore_boot_barrier);
}

void barrier_init(barrier_t *barrier) {
	barrier->count = 0;
	barrier->cores = NUMCORES;
	mutex_init(&(barrier->lock));
	condition_init(&(barrier->cond));
}

void barrier(barrier_t *barrier) {
	mutex_lock(&(barrier->lock));
	REG32(&barrier->count) = REG32(&barrier->count) + 1;
	
	if ( REG32(&barrier->count) == REG32(&barrier->cores) ) {
		REG32(&barrier->count) = 0;
		condition_broadcast(&barrier->cond);
	} else {
		condition_wait(&barrier->cond,&barrier->lock);
	}
        // uart_printf("leave barrier!\n");
	mutex_unlock(&(barrier->lock));
}

void condition_init(condition_t *cond) {
	REG32(&cond->signal) = 0;
	REG32(&cond->waiting) = 0;
}

void condition_wait(condition_t *cond,mutex_t *lock) {

	while ( REG32(&cond->signal) == 1 ) { // this read still need the arbitration of shared bus, and it's possible to occur later than the condition_broadcast!!!
		mutex_unlock(lock);
	 	unsigned int i;
	 	for ( i = 0; i < 200; ++i ) __asm__ __volatile__("l.nop 0xf");
		mutex_lock(lock);
	}

	REG32(&cond->waiting) = REG32(&cond->waiting) + 1;
	mutex_unlock(lock);
	
	while ( REG32(&cond->signal) == 0 ) {
		unsigned int i;
		for ( i = 0; i < 20; ++i ) __asm__ __volatile__("l.nop 0xf");
	}

	mutex_lock(lock);
	REG32(&cond->waiting) = REG32(&cond->waiting) - 1;
	if ( REG32(&(cond->waiting)) == 0 ) {
		REG32(&(cond->signal)) = 0;
	}
}

void condition_broadcast(condition_t *cond) {
	REG32(&(cond->signal)) = 1;
}




void multicore_init(){
	// Initialize stuff
	uart_init();

	// Set barrier parameters, we own the lock!
	multicore_boot_barrier.count = 0; // We will set our value later
	multicore_boot_barrier.cores = NUMCORES;
	condition_init(&(multicore_boot_barrier.cond));

	// Free barrier lock, so that the other cores can enter
	mutex_unlock(&multicore_boot_barrier.lock);
}

