/*
 * mutex.h
 *
 *  Created on: Aug 27, 2010
 *      Author: wallento
 */

#ifndef MUTEX_H_
#define MUTEX_H_

typedef struct {
	unsigned int lock;
} mutex_t;

extern unsigned int cas(unsigned int address,unsigned int compare,unsigned int value);

extern void mutex_init(mutex_t *lock);
extern void mutex_lock(mutex_t *lock);
extern void mutex_unlock(mutex_t *lock);

#endif /* MUTEX_H_ */
