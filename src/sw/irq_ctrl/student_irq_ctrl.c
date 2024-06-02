#include "student_irq_ctrl.h"

void student_irq_ctrl_init(void) {
    // Initialize all registers to their default values
    REG32(IRQ_CTRL_ALL_EN(0)) = IRQ_CTRL_ALL_EN_DEFAULT;
    REG32(IRQ_CTRL_MASK(0)) = IRQ_CTRL_MASK_DEFAULT;
    REG32(IRQ_CTRL_MASK_SET(0)) = IRQ_CTRL_MASK_SET_DEFAULT;
    REG32(IRQ_CTRL_MASK_CLR(0)) = IRQ_CTRL_MASK_CLR_DEFAULT;
    //REG32(IRQ_CTRL_STATUS(0)) = IRQ_CTRL_STATUS_DEFAULT; sw:ro
    //REG32(IRQ_CTRL_IRQ_NO(0)) = IRQ_CTRL_IRQ_NO_DEFAULT: sw:ro
    REG32(IRQ_CTRL_TEST(0)) = IRQ_CTRL_TEST_DEFAULT;
    REG32(IRQ_CTRL_TEST_IRQ(0)) = IRQ_CTRL_TEST_IRQ_DEFAULT;
	printf("irq_ctrl reg init done");

}