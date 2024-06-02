#ifndef STUDENT_IRQ_CTRL_H
#define STUDENT_IRQ_CTRL_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"

// Inline function definitions for time-critical operations

//write functions

extern inline void irq_ctrl_disable(void) {
    REG32(IRQ_CTRL_ALL_EN(0)) = 0;
}

extern inline void irq_ctrl_enable(void) {
    REG32(IRQ_CTRL_ALL_EN(0)) = 1;
}

extern inline void irq_ctrl_set_mask(uint32_t mask_value) {
    REG32(IRQ_CTRL_MASK(0)) = mask_value;
}

extern inline void irq_ctrl_set_mask_set(unsigned int n) {
    REG32(IRQ_CTRL_MASK_SET(0)) = 1 << n;
}

extern inline void irq_ctrl_set_mask_clear(unsigned int n) {
    REG32(IRQ_CTRL_MASK_CLR(0)) = 1 << n;
}

extern inline void irq_ctrl_set_test_mode(bool enable) {
    REG32(IRQ_CTRL_TEST(0)) = enable ? 1 : 0;
}

extern inline void irq_ctrl_set_test_irq(uint32_t test_irq_value) {
    REG32(IRQ_CTRL_TEST_IRQ(0)) = test_irq_value;
}

//read functions

extern inline unsigned int get_irq_ctrl_all_en(void) {
	unsigned int read_all_en;
	uint32_t readReg_all_en;

	readReg_all_en =  REG32(IRQ_CTRL_ALL_EN(0));
	read_all_en = readReg_all_en & IRQ_CTRL_ALL_EN_MASK;

	return read_all_en;
}

extern inline uint32_t get_irq_ctrl_mask(void) {
	return REG32(IRQ_CTRL_MASK(0));
}

extern inline uint32_t get_irq_ctrl_status(void) {
    return REG32(IRQ_CTRL_STATUS(0));
}

extern inline uint32_t get_irq_ctrl_irq_no(void) {
    return REG32(IRQ_CTRL_IRQ_NO(0));
}

extern inline unsigned int get_irq_ctrl_test(void) {
	unsigned int read_test;
	uint32_t readReg_test;

	readReg_test =  REG32(IRQ_CTRL_TEST(0));
	read_test = readReg_test & IRQ_CTRL_TEST_MASK;

	return read_test;
}

extern inline uint32_t get_irq_ctrl_test_irq(void) {
	return REG32(IRQ_CTRL_TEST_IRQ(0));
}

//non time-critical functions

void student_irq_ctrl_init(void);

#endif // STUDENT_IRQ_CTRL_H