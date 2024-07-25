#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "iic_ctrl.h"
#include "userinterface.h"

static void delay_cycles(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while(REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles);
}

int main(void) {
    

/**
    printf("Welcome to rvlab FIR Parallel.\n");
    printf("Audio Codec configuration started\n");
    //start_audio_codec_config();
    test_ii2();
    printf("Audio Codec configuration done\n");
    //start_cli();
**/

    printf("example sample in fir\n");
    uint16_t sample = 0x44;
    //student_fir_s_write_in_samples(sample);
    student_fir_p_write_in_samples(sample);
    delay_cycles(1100);
/**
    int hit = 0;
    uint32_t read_y_out;
    while(!hit) {
        read_y_out = student_fir_s_read_y_out_lower(0);
        if(read_y_out != 0) {
            hit = 1;
        }
        printf("read out is: %x08", read_y_out);
    }
**/

    return 0;
}
