#include <stdio.h>
#include "rvlab.h"

#define REGA   0x10000000
#define REGB   0x10000004
#define REGC   0x10000008


static void delay_cycles(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while(REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles);
}

int main(void) {

    // Implement tests here.

    //start with rotate left

    REG32(REGB) = 0xFFFFFF01;//rotate left
    printf("REGB 0x%08x\n", REG32(REGB));
    delay_cycles(5);

//While the running light is running with a pause time of 5 cycles: A write access (writing 0x42) to the delay register followed by a read access.

    REG32(REGC) = 0xFFFFFF42;
    printf("REGC 0x%08x\n", REG32(REGC));
    delay_cycles(5);

//Two complete cycles with the following configurations: #. mode=right, initial pattern=11111110, pause = 1 cycle #. mode=ping-pong, initial pattern=10000000, pause = 0 cycles (i.e. the pattern changes every clock cycle)


    REG32(REGA) = 0x123456FE;
    printf("REGA 0x%08x\n", REG32(REGA));

    REG32(REGC) = 0xFFFFFF01;
    printf("REGC 0x%08x\n", REG32(REGC));
  
    REG32(REGB) = 0xFFFFFF02; //rotate right
    printf("REGB 0x%08x\n", REG32(REGB));
    delay_cycles(5);

    REG32(REGA) = 0x12345680;
    printf("REGA 0x%08x\n", REG32(REGA));

    REG32(REGC) = 0xFFFFFF00;
    printf("REGC 0x%08x\n", REG32(REGC));
  
    REG32(REGB) = 0xFFFFFF00; //ping pong
    printf("REGB 0x%08x\n", REG32(REGB));
    delay_cycles(5);

//A read access to the pattern register which clearly shows the delayed arrival of the data at register bus after the rising clock edge.

    printf("REGA 0x%08x\n", REG32(REGA));
    delay_cycles(5);
    
    return 0;
}
