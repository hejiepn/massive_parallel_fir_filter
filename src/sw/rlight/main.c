#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "student_rlight.h"

//Define the patterns and their shifting logic
#define INITIAL_PATTERN 0x52  		// Binary: 0101 0010
#define LED_STATUS_MASK 0x3C      	// binary: 0011 1100
#define LED_MASK 0x7E 				// binary 0111 1110

static void delay_cycles(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while(REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles);
}

//ex.3 mini-application
//change shifting to 1 step at 0110
//change shifting to 2 steps at 1001

void run_ping_pong_pattern() {
    unsigned int currentPattern;
    unsigned int ledStatus;
    int shiftAmount = 1; //initial shift amount
    int direction = 1; // Start by shifting right
    
    ll_set_pattern(INITIAL_PATTERN);

    while (true) {
        // Check if the current display cycle is complete
        currentPattern = ll_get_led_status();
        ledStatus = currentPattern & LED_STATUS_MASK;
        if (ledStatus == 0x09) {
            shiftAmount = 2;
        } else if (ledStatus == 0x06) {
        	shiftAmount = 1;
        }

        // Apply the direction of the shift
        if (direction == 1) {
            currentPattern <<= shiftAmount;
            if (currentPattern & ~LED_MASK) { // If overflow, change direction
            	currentPattern >>= shiftAmount;
                direction = -1;
            }
        } else {
            currentPattern >>= shiftAmount;
            if (currentPattern & ~LED_MASK) {  // If underflow, change direction
	            currentPattern <<= shiftAmount;
                direction = 1;
            }
        }

        // Update the pattern register with new shifted pattern
        ll_set_pattern(currentPattern);
    }
}

void ll_init() {

	unsigned int getMode;
    unsigned int getPause;
    unsigned int getPattern;
    unsigned int getLed;
    
    ll_set_pause(0x1F4);
    getPause = ll_get_pause();
    printf("getPause 0x%08x\n", getPause);
    
    ll_set_pattern(0xFF);
    getPattern = ll_get_pattern();
    printf("getPattern 0x%08x\n", getPattern);
    
    getLed = ll_get_led_status();
    printf("getLed in the beginnning 0x%08x\n", getLed);
    
    ll_set_mode(0x01);
    getMode = ll_get_mode();
    printf("getMode 0x%08x\n", getMode);
    
    delay_cycles(10);
    
}

int main(void) {
    
    ll_init();
    run_ping_pong_pattern();
    return 0;
}



//#define REGA   0x10000000
//#define REGB   0x10000004
//#define REGC   0x10000008

//test functions from ex.2
/* 

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
    
*/

