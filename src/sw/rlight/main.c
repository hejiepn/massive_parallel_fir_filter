#include <stdio.h>
#include "rvlab.h"

#define RLIGHT_PATTERN   0x10000000
#define RLIGHT_MODE      0x10000004
#define RLIGHT_PRESCALER 0x10000008
#define RLIGHT_OUTPUT    0x1000000c

#define MODE_OFF 0
#define MODE_ROTLEFT 1
#define MODE_ROTRIGHT 2
#define MODE_PINGPONG 3

static void delay_cycles(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while(REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles);
}

int main(void) {

    // Implement tests here.

    // Example:

    REG32(RLIGHT_PATTERN) = 0b10101010;
    delay_cycles(1000);

    REG32(RLIGHT_PATTERN) = 0b00010111;
    delay_cycles(1000);

    return 0;
}
