#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "student_rlight.h"
#include "student_irq_ctrl.h"

//Define the patterns and their shifting logic
#define INITIAL_PATTERN 0x52  		// Binary: 0101 0010
#define LED_STATUS_MASK 0x3C      	// binary: 0011 1100
#define LED_MASK 0x7E 				// binary 0111 1110

#define MAX_IRQ_HANDLERS 2  // Define the number of IRQ handlers
irq_handler_t irq_handlers[MAX_IRQ_HANDLERS];  // Array of IRQ handlers
const int max_irq_handlers = MAX_IRQ_HANDLERS;

// Specific handler for IRQ 0
void irq_handler_0(void) {
    fputs("Handling IRQ handler 0\n", stdout); //DOWN
    printf("Handling IRQ handler 0\n");
    student_rlight_set_mode_right();
    IRQ_CTRL_SET_MASK_CLEAR(0, 0b1);
}

// Specific handler for IRQ 1
void irq_handler_1(void) {
    fputs("Handling IRQ handler 1\n", stdout); //DOWN
    printf("Handling IRQ handler 1\n");
    student_rlight_set_mode_left();
    IRQ_CTRL_SET_MASK_CLEAR(0, 0b10);
}

// Specific handler for IRQ 1
void irq_handler_2(void) {
    fputs("Handling IRQ handler 2\n", stdout); //DOWN
    printf("Handling IRQ handler 2\n");
    student_rlight_set_mode_left();
    IRQ_CTRL_SET_MASK_CLEAR(0, 0b100);
}

// Specific handler for IRQ 1
void irq_handler_3(void) {
    fputs("Handling IRQ handler 3\n", stdout); //DOWN
    printf("Handling IRQ handler 3\n");
    student_rlight_set_mode_left();
    IRQ_CTRL_SET_MASK_CLEAR(0, 0b1000);
}

// Initialize and configure interrupt handlers
void setup_irq_handlers(void) {
    init_irq_handlers(irq_handlers, MAX_IRQ_HANDLERS);
    //student_irq_ctrl_set(0, irq_handler_0, irq_handlers, MAX_IRQ_HANDLERS);
    //student_irq_ctrl_set(1, irq_handler_1, irq_handlers, MAX_IRQ_HANDLERS);
    IRQ_CTRL_ALL_ENABLE(0);
    irq_enable((1 << IRQ_TIMER) | (1 << IRQ_EXTERNAL));
}

static void delay_cycles(int n_cycles) {
    REG32(RV_TIMER_CTRL(0)) = (1<<RV_TIMER_CTRL_ACTIVE0_LSB);
    REG32(RV_TIMER_TIMER_V_LOWER0(0)) = 0;
    while(REG32(RV_TIMER_TIMER_V_LOWER0(0)) < n_cycles);
}

int main(void) {

/*
    uint32_t mask_set;
    uint32_t mask_clear;
    uint32_t test_irq;
    uint32_t status;
    uint32_t irq_no;


    
    setup_irq_handlers(); // Set up IRQ handlers
    student_irq_ctrl_set(0, irq_handler_0, irq_handlers, MAX_IRQ_HANDLERS);
    student_irq_ctrl_set(1, irq_handler_1, irq_handlers, MAX_IRQ_HANDLERS);
    student_irq_ctrl_set(2, irq_handler_2, irq_handlers, MAX_IRQ_HANDLERS);
    student_irq_ctrl_set(3, irq_handler_3, irq_handlers, MAX_IRQ_HANDLERS);

    delay_cycles(30);

    printf("TEST IRQ MAIN START\n");

    mask_set = 0x0000000f;
    IRQ_CTRL_SET_MASK_SET(0, mask_set);
    mask_clear = 0x00000000;
    IRQ_CTRL_SET_MASK_CLEAR(0, mask_clear);
    IRQ_CTRL_SET_TEST_MODE(0,1);
    test_irq = 0x0000000f;
    IRQ_CTRL_SET_TEST_IRQ(0, test_irq);
    delay_cycles(300);
    irq_no = GET_IRQ_CTRL_IRQ_NO(0);
    status = GET_IRQ_CTRL_STATUS(0);

    printf("test 1: irq_no is %d and status is 0x%032X\n", irq_no, status);

    printf("TEST IRQ MAIN END\n");

*/
    printf("RLIGHT MAIN START\n");
    student_rlight_set_clock_delay(180);
    student_rlight_set_mode_right();
    int pattern = 0b00011000;
    student_rlight_set_pattern(pattern);
    delay_cycles(300);

    pattern = 0b00100100;
    student_rlight_set_pattern(pattern);
    delay_cycles(300);
    printf("RLIGHT MAIN END\n");

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

