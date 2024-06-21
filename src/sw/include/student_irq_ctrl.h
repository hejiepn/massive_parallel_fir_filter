#ifndef STUDENT_IRQ_CTRL_H
#define STUDENT_IRQ_CTRL_H

#include "rvlab.h"
#include "stdio.h"


// Macro definitions for time-critical operations

// Write macros
#define IRQ_CTRL_ALL_DISABLE(id)           		(REG32(IRQ_CTRL_ALL_EN(id)) = 0)
#define IRQ_CTRL_ALL_ENABLE(id)           		(REG32(IRQ_CTRL_ALL_EN(id)) = 1)
#define IRQ_CTRL_SET_MASK(id, mask)     		(REG32(IRQ_CTRL_MASK(id)) = (mask))
#define IRQ_CTRL_SET_MASK_SET(id, mask_set)     (REG32(IRQ_CTRL_MASK_SET(id)) = (mask_set))
#define IRQ_CTRL_SET_MASK_CLEAR(id, mask_clr)   (REG32(IRQ_CTRL_MASK_CLR(id)) = (mask_clr))
#define IRQ_CTRL_SET_TEST_MODE(id, mode)  	 	(REG32(IRQ_CTRL_TEST(id)) = (mode))
#define IRQ_CTRL_SET_TEST_IRQ(id, test_irq)   	(REG32(IRQ_CTRL_TEST_IRQ(id)) = (test_irq))

// Read macros
#define GET_IRQ_CTRL_ALL_EN(id)        		(REG32(IRQ_CTRL_ALL_EN(id)) & IRQ_CTRL_ALL_EN_MASK)
#define GET_IRQ_CTRL_MASK(id)          		(REG32(IRQ_CTRL_MASK(id)))
#define GET_IRQ_CTRL_STATUS(id)        		(REG32(IRQ_CTRL_STATUS(id)))
#define GET_IRQ_CTRL_IRQ_NO(id)       		(REG32(IRQ_CTRL_IRQ_NO(id)))
#define GET_IRQ_CTRL_TEST(id)          		(REG32(IRQ_CTRL_TEST(id)) & IRQ_CTRL_TEST_MASK)
#define GET_IRQ_CTRL_TEST_IRQ(id)      		(REG32(IRQ_CTRL_TEST_IRQ(id)))

// Type for IRQ handlers
typedef void (*irq_handler_t)(void);

// Inline functions for modifying IRQ handlers
static inline void student_irq_ctrl_set(int irq_number, irq_handler_t handler, irq_handler_t* irq_table, int max_handlers) {
    if (irq_number < max_handlers) {
        irq_table[irq_number] = handler;
    }
}

static inline irq_handler_t student_irq_ctrl_get(int irq_number, irq_handler_t* irq_table, int max_handlers) {
    if (irq_number < max_handlers) {
        return irq_table[irq_number];
    }
    return NULL;
}

static inline void default_irq_handler(void) {
    fputs("Unhandled interrupt, fputs\n", stdout);
}

static inline void init_irq_handlers(irq_handler_t* irq_table, int max_handlers) {
    for (int i = 0; i < max_handlers; i++) {
        irq_table[i] = default_irq_handler;  // Initialize all handlers to default
    }
}

#endif // STUDENT_IRQ_CTRL_H