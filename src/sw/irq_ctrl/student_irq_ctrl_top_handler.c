#include "student_irq_ctrl_top_handler.h"

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