#include <stdio.h>
#include "rvlab.h"

void irq_handler(void) {
    fputs("I am interrupt\n", stdout);
    REG32(RV_TIMER_INTR_STATE0(0)) = 1; // clears the timer interrupt
	REG32(RV_TIMER_INTR_ENABLE0(0)) = 0;
}

static void run_timer_irq(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    REG32(RV_TIMER_TIMER_V_UPPER0(0)) = 0;
    REG32(RV_TIMER_COMPARE_LOWER0_0(0)) = n_cycles;
    REG32(RV_TIMER_COMPARE_UPPER0_0(0)) = 0;
}

int main(void) {
	asm volatile ("csrs mie, %0":: "r" (0x800)); // enables external interrupts
	asm volatile ("csrs mie, %0":: "r" (0x80)); // enables timer interrupts
	asm volatile ("csrs mstatus, 0x8");
	

    int i = 1234;
    int counter = 0;
    while(counter < 5) {
        REG32(RV_TIMER_INTR_ENABLE0(0)) = 1;
        run_timer_irq(5);
    	counter++;
    	printf("I am loop (%i)\n", i++);
    }

    return 0;
}
