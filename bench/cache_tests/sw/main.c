#include "support/support.h"
#include "support/spr_defs.h"
#include "support/uart.h"
#include "support/vfnprintf.h"
#include "support/multicore.h"

#include <math.h>
#include <ctype.h>

#include <stdio.h>

#define NO_NODES                            16
#define INFTY                               9999
#define MAX                                 100

int dist[NO_NODES][NO_NODES] = {
    {0,    6,    3,    9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999},
    {6,    0,    2,    5,    9999, 9999, 1,    9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999},
    {3,    2,    0,    3,    4,    9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999},
    {9999, 5,    3,    0,    2,    3,    9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999},
    {9999, 9999, 4,    2,    0,    5,    9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999},
    {9999, 9999, 9999, 3,    5,    0,    3,    2,    9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999},
    {9999, 1,    9999, 9999, 9999, 3,    0,    4,    9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999},
    {9999, 9999, 9999, 9999, 9999, 2,    4,    0,    7,    9999, 9999, 9999, 9999, 9999, 9999, 9999},
    {9999, 9999, 9999, 9999, 9999, 9999, 9999, 7,    0,    5,    1,    9999, 9999, 9999, 9999, 9999},
    {9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 5,    0,    9999, 3,    9999, 9999, 9999, 9999},
    {9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 1,    9999, 0,    9999, 4,    9999, 9999, 8},
    {9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 3,    9999, 0,    9999, 2,    9999, 9999},
    {9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 4,    9999, 0,    1,    9999, 2},
    {9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 2,    1,    0,    6,    9999},
    {9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 6,    0,    3},
    {9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 9999, 8,    9999, 2,    9999, 3,    0},
};

struct node
{
  int pre;   /* Predecessor */
  int length; /* Length between the nodes */
  enum {perm,tent} label; /* Enumeration for permanent and tentative labels */
} state[NO_NODES];

volatile int min,k;
int	min_array[NUMCORES];
int	k_array[NUMCORES];

barrier_t init_barrier, first_step_barrier, second_step_barrier, third_step_barrier, last_loop_barrier;

void dodijkstra(int sr,int ds,int path[])
 {
 
    int     i;
    if (coreid()==0){
 	struct node *p;
 	/* Initialisation of the nodes aka First step of Dijkstra Algo */
 	for(p=&state[0];p<&state[NO_NODES];p++)
 	{
           p->pre= -1;
 	   p->length=INFTY;
 	   p->label=tent;
 	}

        state[ds].length=0; /* Destination length set to zero */
        state[ds].label=perm; /* Destination set to be the permanent node */
        k=ds; /* initial working node */

	// Initialize parallelization arrays
	for ( i = 0; i < NUMCORES; ++i ) {
		min_array[i] = INFTY;
		k_array[i] = -1;
	}
	
//        uart_printf("core 0 initialization done!\n");
    }
    barrier(&init_barrier);
    /* Checking for a better path from the node k ? */
    do
    {
//	if ( coreid() == 0 ) uart_printf("k is:  %d \n", k);
        // printf("k is:  %d \n", k);
        for(i=coreid()*NO_NODES/NUMCORES;i<(coreid()+1)*NO_NODES/NUMCORES;i++)
          {
              if(dist[k][i]!=0 && state[i].label==tent)
                 {
                    if((state[k].length+dist[k][i])<state[i].length)
                       {
                           state[i].pre=k;
                           state[i].length=state[k].length+dist[k][i];
                       }
                 }
          }

          if (coreid()==0){
              // k=0;
              for(i=0;i<NUMCORES;i++){
                min_array[i] = INFTY;
              }
          }
          // uart_printf("first step done!\n");
          barrier(&first_step_barrier);

          /* Find a node which is tentatively labeled and with minimum label */
          // for(i=0;i<NO_NODES;i++)
          for(i=coreid()*NO_NODES/NUMCORES;i<(coreid()+1)*NO_NODES/NUMCORES;i++)
          {
             if(state[i].label==tent && state[i].length<min_array[coreid()])
                {
                    min_array[coreid()]=state[i].length;
                    k_array[coreid()]=i;
                }
          }
          // uart_printf("core 0 second step done!\n");
          // uart_printf("second step done!\n");
          // uart_printf("min_array[%d]: %d\n",coreid(),min_array[coreid()]);
          // uart_printf("k_array[%d]: %d\n",coreid(),k_array[coreid()]);
    // uart_printf("init,%d,%d,%d\n",init_barrier.cond.signal,init_barrier.cond.waiting,init_barrier.count);
          // uart_printf("first,%d,%d,%d\n",first_step_barrier.cond.signal,first_step_barrier.cond.waiting,first_step_barrier.count);
          barrier(&second_step_barrier);

          if (coreid()==0){
              min = INFTY;
              for(i=0;i<NUMCORES;i++){
                if (min_array[i] < min){
                    min = min_array[i];
                    k   = k_array[i];
                }
              }
                
              state[k].label=perm;
          }
          // uart_printf("third step done!\n");
          // uart_printf("first,%d,%d,%d\n",first_step_barrier.cond.signal,first_step_barrier.cond.waiting,first_step_barrier.count);
          barrier(&third_step_barrier);

    } while(k!=sr);

    // uart_printf("k is:  %d \n", k);
    barrier(&last_loop_barrier); // this is to avoid that core0 leave 'third_step_barrier' first (while core1,2,3 are still waiting in the 'nop' loop) and execute the following code, which will change the 'k' value then cause core1,2,3 evaluate (k!=sr) to be true!!

    if (coreid()==0){
        i=0;
        k=sr;
        /* Print the path to the output array */
        do {path[i++]=k;k=state[k].pre;} while(k>=0);
        path[i]=k;
        // uart_printf("path assign done!\n");
    }
 }


int path[NO_NODES];

int main(int argc, char *argv[]) {

    int j;

    if (coreid() == 0){
        for (j=0; j<NO_NODES; ++j)
         path[j] = -1;

        multicore_init();
        barrier_init(&init_barrier);
        barrier_init(&first_step_barrier);
        barrier_init(&second_step_barrier);
        barrier_init(&third_step_barrier);
        barrier_init(&last_loop_barrier);
	uart_printf("Dijkstra test run\n");
        uart_printf("Multicore environment initialized\n");
        uart_printf("Start Dijkstra computation\n");
    }

    boot_barrier();

    dodijkstra(7,15,path);

    if (coreid() == 0){
        uart_printf("Path is: \n");
        for (j=0; j<NO_NODES; j++){
            if (path[j] != -1)
                uart_printf("%d ", path[j]);
            else
                break;
        }
        uart_printf("\n");
    }

    return 0;
}
