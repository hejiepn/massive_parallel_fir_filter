#include <stdio.h>
#include "rvlab.h"

void irq_handler(void) {
    fputs("I am interrupt\n", stdout);
}

int main(void) {
    int a = 0x800;
	asm volatile ("csrs mie, %0":: "r" (a));
	asm volatile ("csrs mstatus, 0x8");

    int i = 1234;
    int counter = 0;
    while(counter < 5) {
    	counter++;
    	printf("I am loop (%i)\n", i++);
    }
    return 0;
}
