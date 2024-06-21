#ifndef STUDENT_RLIGHT__H
#define STUDENT_RLIGHT_H

#include <stdint.h>
#include "rvlab.h"

#define REGA   STUDENT_RLIGHT_REGA(0)
#define REGB   STUDENT_RLIGHT_REGB(0)
#define REGC   STUDENT_RLIGHT_REGC(0)
#define REGD   STUDENT_RLIGHT_REGD(0)

typedef enum {
    RLIGHT_MODE_STOP,
    RLIGHT_MODE_LEFT,
    RLIGHT_MODE_RIGHT,
    RLIGHT_MODE_PINGPONG
} rlight_mode;

void student_rlight_stop(void);
void student_rlight_set_mode_right(void);
void student_rlight_set_mode_left(void);
void student_rlight_do_pingpong(void);
void student_rlight_set_pattern(uint32_t pattern);
void student_rlight_set_clock_delay(unsigned int delay);
rlight_mode student_rlight_get_current_mode(void);
uint32_t student_rlight_get_pattern(void);

#endif //STUDENT_RLIGHT_H