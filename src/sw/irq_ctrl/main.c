#include "student_irq_ctrl_top_handler.h"

#define TEST_IRQ_REG 0xDEADBEEF  // Dummy address for the test register

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
        // Set an interrupt pattern to test masking
        set_test_irq(0xFFFFFFFF);
    }
}

int main(void) {
    // Initialize IRQ controller
    student_irq_ctrl_handler_init();
	student_irq_ctrl_init();
    
    // Set a test IRQ handler for demonstration
    student_irq_ctrl_set_handler(0, test_irq_handler);
    
    // disable/enable interrupts globally for the test
	irq_ctrl_disable();
	//irq_ctrl_enable();

	//activate test mode
	irq_ctrl_set_test_mode(true);

    // Run prioritization test
    run_prioritization_test();

    // Run mask test
    run_mask_test();

    return 0;
}