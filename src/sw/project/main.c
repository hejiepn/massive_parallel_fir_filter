#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "iic_ctrl.h"
#include "userinterface.h"
#include "filter_parallel.h"

static void delay_cycles(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while(REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles);
}

int main(void) {
    printf("Welcome to rvlab FIR Parallel!\n");

	fir_p_en_sine_wave(1);

	delay_cycles(1000);

    return 0;
}
