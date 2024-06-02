#include <stdio.h>
#include <stdint.h>
#include "rvlab.h"
#include "student_irq_ctrl.h"

#define MAX_IRQ 32 

/**********************************************************************************/
// Software driven test of all components
/**********************************************************************************/

void test_irq_handler(void) {
    printf("Test IRQ handler called\n");
}

void set_test_irq(uint32_t irq_pattern) {
    // Write the pattern to the test register
    irq_ctrl_set_test_irq(irq_pattern);
}

void run_prioritization_test(void) {
    uint32_t irq_patterns[] = {
        0x00000000,  // 0
        0x80000000,  // 100...0
        0xC0000000,  // 110...0
        0xFFFFFFFF,  // 111...11
        0xFFFFFFFE,  // 111...110
        0xFFFFFFFC,  // 111...100
        0x00000000   // 0
    };
    
    for (int i = 0; i < sizeof(irq_patterns) / sizeof(irq_patterns[0]); i++) {
        set_test_irq(irq_patterns[i]);
		printf("run_prio_patterns[%d] is 0x%08x\n",i, irq_patterns[i]);
    }
}

void run_mask_test(void) {
    uint32_t mask_patterns[] = {
        0xFFFFFFFF,  // Enable all
        0x00000000,  // Disable all
        0xAAAAAAAA,  // Alternate enable/disable
        0x55555555,  // Alternate enable/disable
    };

    for (int i = 0; i < sizeof(mask_patterns) / sizeof(mask_patterns[0]); i++) {
        // Write the pattern to the mask register
        irq_ctrl_set_mask(mask_patterns[i]);
		printf("mask_patterns[%d] is 0x%08x\n",i, mask_patterns[i]);

        // Set an interrupt pattern to test masking
        set_test_irq(0xFFFFFFFF);
    }
}

/**********************************************************************************/
//irq_ctrl_top_handler function 
/**********************************************************************************/


// Array of function pointers (jump table)
void (*irq_handlers[MAX_IRQ])(void);

//student_irq_ctrl_top_handler
void student_irq_ctrl_top_handler(void) {
	fputs("I am student_irq_ctrl_top_handler\n", stdout);
    uint32_t irq_no = get_irq_ctrl_irq_no();

	while(irq_no != MAX_IRQ) {
		printf("Handling IRQ number: %u\n", irq_no);
		irq_handlers[irq_no]();
		irq_no = get_irq_ctrl_irq_no();
	}
}

// Dummy handler function
void dummy_handler(void) {
    // Default action (e.g., log or reset)
	printf("this is the dummy handler output print, it does nothing else");
}

// Function to set a handler for a specific IRQ
void student_irq_ctrl_set_handler(uint32_t irq_no, void (*handler)(void)) {
    if (irq_no < MAX_IRQ) {
        irq_handlers[irq_no] = handler;
    }
}

// Function to get the handler for a specific IRQ
void (*student_irq_ctrl_get_handler(uint32_t irq_no))(void) {
    if (irq_no < MAX_IRQ) {
        return irq_handlers[irq_no];
    } else {
        return dummy_handler;
    }
}

// Initialization function to set up the jump table with dummy handlers
void student_irq_ctrl_handler_init(void) {
    for (uint32_t i = 0; i < MAX_IRQ; i++) {
        irq_handlers[i] = dummy_handler;
    }
}

/**********************************************************************************/
// main function
/**********************************************************************************/

int main(void) {
    // Initialize IRQ controller
    student_irq_ctrl_handler_init();
	student_irq_ctrl_init();
    
    // Set a test IRQ handler for demonstration
    student_irq_ctrl_set_handler(0, test_irq_handler);

	//activate test mode
	irq_ctrl_set_test_mode(true);

	irq_ctrl_set_test_irq(0x00000001); //irq handler 0
	irq_ctrl_set_mask(0xffffffff);

    // disable/enable interrupts globally for the test
	//irq_ctrl_disable();
	irq_ctrl_enable();


    // Run prioritization test
    //run_prioritization_test();

    // Run mask test
    //run_mask_test();

    return 0;
}