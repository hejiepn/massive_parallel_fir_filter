#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "student_rlight.h"

//set mode

void ll_set_mode(unsigned int mode) {

    REG32(STUDENT_RLIGHT_REGB(0)) = (mode << STUDENT_RLIGHT_REGB_MODE_LSB); 
}

//get mode

unsigned int ll_get_mode() {
	unsigned int readmode;
	uint32_t readRegB;
	
	readRegB = REG32(STUDENT_RLIGHT_REGB(0));
	readmode = (readRegB >> STUDENT_RLIGHT_REGB_MODE_LSB) & STUDENT_RLIGHT_REGB_MODE_MASK;
	
	return readmode;
}

//set pause

void ll_set_pause(unsigned int pause) {

    REG32(STUDENT_RLIGHT_REGC(0)) = (pause << STUDENT_RLIGHT_REGC_PAUSE_LSB); 
}

//get pause

unsigned int ll_get_pause() {
	unsigned int readpause;
	uint32_t readRegC;
	
	readRegC = REG32(STUDENT_RLIGHT_REGC(0));
	readpause = (readRegC >> STUDENT_RLIGHT_REGC_PAUSE_LSB) & STUDENT_RLIGHT_REGC_PAUSE_MASK;
	
	return readpause;
}

//set pattern

void ll_set_pattern(unsigned int mode) {

    REG32(STUDENT_RLIGHT_REGA(0)) = (mode<<STUDENT_RLIGHT_REGA_LED_PATTERN_LSB); 
}

//get pattern

unsigned int ll_get_pattern() {
	unsigned int readpattern;
	uint32_t readRegA;
	
	readRegA = REG32(STUDENT_RLIGHT_REGA(0));
	readpattern = (readRegA >> STUDENT_RLIGHT_REGA_LED_PATTERN_LSB) & STUDENT_RLIGHT_REGA_LED_PATTERN_MASK;
	
	return readpattern;
}

//get led status

unsigned int ll_get_led_status() {
	unsigned int readLedStatus;
	uint32_t readRegD;
	
	readRegD = REG32(STUDENT_RLIGHT_REGD(0));
	readLedStatus = (readRegD >> STUDENT_RLIGHT_REGD_LED_STATUS_LSB) & STUDENT_RLIGHT_REGD_LED_STATUS_MASK;
	
	return readLedStatus;
}
