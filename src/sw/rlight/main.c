#include <stdio.h>
#include "rvlab.h"
#include "rlight.h"

static void delay_cycles(int n_cycles)
{
    REG32(RV_TIMER_CTRL(0)) = (1 << RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while (REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles)
        ;
}

int main(void)
{

    delay_cycles(1);

    REG32(STUDENT_RLIGHT_DELAY(0)) = 0x00000001;
    printf("Delay Reg 0x%08x\n", REG32(STUDENT_RLIGHT_DELAY(0)));

    delay_cycles(1);

    REG32(STUDENT_RLIGHT_DELAY(0)) = 0x00000005;
    printf("Delay Reg 0x%08x\n", REG32(STUDENT_RLIGHT_DELAY(0)));

    REG32(STUDENT_RLIGHT_LED_PATTERN(0)) = 0x00000018;
    printf("Pattern Reg 0x%08x\n", REG32(STUDENT_RLIGHT_LED_PATTERN(0)));

    REG32(STUDENT_RLIGHT_MODES(0)) = 0x00000001;
    printf("Mode Reg 0x%08x\n", REG32(STUDENT_RLIGHT_MODES(0)));

    delay_cycles(1);

    REG32(STUDENT_RLIGHT_MODES(0)) = 0x00000000;
    printf("Mode Reg 0x%08x\n", REG32(STUDENT_RLIGHT_MODES(0)));

    delay_cycles(1);

    REG32(STUDENT_RLIGHT_LED_PATTERN(0)) = 0x000000D0;
    printf("Pattern Reg 0x%08x\n", REG32(STUDENT_RLIGHT_LED_PATTERN(0)));

    REG32(STUDENT_RLIGHT_DELAY(0)) = 5000000;
    printf("Delay Reg 0x%08x\n", REG32(STUDENT_RLIGHT_DELAY(0)));

    REG32(STUDENT_RLIGHT_MODES(0)) = 0x00000001;
    printf("Mode Reg 0x%08x\n", REG32(STUDENT_RLIGHT_MODES(0)));

    delay_cycles(1);

    printf("LED Status Reg 0x%08x\n", REG32(STUDENT_RLIGHT_LED_STATUS(0)));

    rlight_set_Mode(ping_pong);

    return 0;
}
