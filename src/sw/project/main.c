#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "iic_ctrl.h"
#include "userinterface.h"
#include "filter_parallel.h"
#include "iis_handler.h"
#include "bandpass_coeff.h"

#define MAX_LINE_LENGTH 1024  // Adjust if needed

static void delay_cycles(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while(REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles);
}

int main(void) {
    printf("Welcome to rvlab FIR Parallel!\n");

	printf("Start Audio Config!\n");

	start_audio_codec_config();

	printf("End Audio Config!\n");

	start_cli();

    return 0;
}
