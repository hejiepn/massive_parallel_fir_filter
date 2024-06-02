#ifndef STUDENT_IRQ_CTRL_H
#define STUDENT_IRQ_CTRL_H

#include <stdio.h>
#include <stdint.h>
#include "rvlab.h"
#include "student_irq_ctrl.h"

#define MAX_IRQ 32  // Assuming 32 possible IRQs

// Array of function pointers (jump table)
extern void (*irq_handlers[MAX_IRQ])(void);

//student_irq_ctrl_top_handler
void student_irq_ctrl_top_handler(void);

// Function to set a handler for a specific IRQ
void student_irq_ctrl_set_handler(uint32_t irq_no, void (*handler)(void));

// Function to get the handler for a specific IRQ
void (*student_irq_ctrl_get_handler(uint32_t irq_no))(void);

// Initialization function to set up the jump table with dummy handlers
void student_irq_ctrl_handler_init(void);



#endif // STUDENT_IRQ_CTRL_H