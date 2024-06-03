#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "student_rlight.h"

void student_rlight_do_pingpong(void) {
		REG32(REGB) = 0; //set mode to ping pong
}

void student_rlight_set_mode_left(void) {
		REG32(REGB) = 1; //set mode to left

}

void student_rlight_stop(void) {
		REG32(REGB) = 3; //set mode to stop
}

void student_rlight_set_mode_right(void) {
		REG32(REGB) = 2; //set mode to right
}

void student_rlight_set_pattern(uint32_t pattern) {
    REG32(REGA) = (pattern); 
}

void student_rlight_set_clock_delay(unsigned int delay) {
	REG32(REGC) = (delay); 
}
rlight_mode student_rlight_get_current_mode(void) {
	return (rlight_mode)(REG32(REGB) & STUDENT_RLIGHT_REGB_MODE_MASK)
}
uint32_t student_rlight_get_pattern(void) {
	return (REG32(REGD) & STUDENT_RLIGHT_REGD_LED_STATUS_MASK);
}
