#include "support.h"
#include "mutex.h"
#include "spr_defs.h"

unsigned int cas(unsigned int address,unsigned int compare,unsigned int value) {
// disable interrupts
        unsigned int result;
	mtspr(SPR_SR,mfspr(SPR_SR) & ~SPR_SR_DCE);
	REG32(0x7ffffffc) = address;
	REG32(0x7ffffffc) = compare;
	REG32(0x7ffffffc) = value;
	result = REG32(0x7ffffffc);
	mtspr(SPR_SR,mfspr(SPR_SR) | SPR_SR_DCE);
        return result;
// enable interrupts
}

void mutex_init(mutex_t *lock) {
	lock->lock = 0;
}

void mutex_lock(mutex_t *lock) {
	while ( cas((unsigned int)&(lock->lock),0,1) == 1 ) {
		unsigned int i;
		for ( i = 0; i < 20; i++ ) __asm__ __volatile__("l.nop");
	}
}

void mutex_unlock(mutex_t *lock) {
	lock->lock = 0;
}

