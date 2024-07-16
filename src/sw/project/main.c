#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
//#include "filter.h"
#include "iic_ctrl.h"

static void delay_cycles(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while(REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles);
}

int main(void) {
    /**
    printf("Audio Codec configuration started\n");

    start_audio_codec_config();
    printf("Audio Codec configuration done\n");
**/

    printf("test_ii2 started\n");

    //test_ii2();
  //  delay_cycles(100);
    printf("read_SDA at beginning\n");
clear_SCL();
clear_SDA();
    return 0;
}
