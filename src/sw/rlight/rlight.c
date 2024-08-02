#include "rlight.h"

// Gets Current LED State
uint8_t rlight_get_LED_Status()
{
    return REG32(STUDENT_RLIGHT_LED_STATUS(0));
}

// Sets current Pattern Register
void rlight_set_LED_Pattern(uint8_t pattern)
{
    REG32(STUDENT_RLIGHT_LED_PATTERN(0)) = (uint32_t)pattern;
}

// gets current LED Pattern
uint8_t rlight_get_LED_Pattern()
{
    return REG32(STUDENT_RLIGHT_LED_PATTERN(0));
}

// sets current LED Mode
void rlight_set_Mode(rlight_mode mode)
{
    REG32(STUDENT_RLIGHT_MODES(0)) = (uint32_t)mode;
}

// gets current LED Mode
rlight_mode rlight_get_Mode()
{
    return REG32(STUDENT_RLIGHT_MODES(0));
}

// sets current Delay
void rlight_set_Delay(uint32_t delay)
{
    REG32(STUDENT_RLIGHT_DELAY(0)) = delay;
}

// gets current Delay
uint32_t rlight_get_Delay()
{
    return REG32(STUDENT_RLIGHT_DELAY(0));
}