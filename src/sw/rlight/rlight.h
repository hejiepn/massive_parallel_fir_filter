#ifndef _RLIGHT_H
#define _RLIGHT_H

#include <stdint.h>
#include <stdio.h>
#include "rvlab.h"
typedef enum
{
    stop = 0b00,
    shift_left = 0b01,
    shift_right = 0b10,
    ping_pong = 0b11,
} rlight_mode;

// Function Prototypes
uint8_t rlight_get_LED_Status();
uint8_t rlight_get_LED_Pattern();
rlight_mode rlight_get_Mode();
uint32_t rlight_get_Delay();
void rlight_set_LED_Pattern(uint8_t pattern);
void rlight_set_Mode(rlight_mode mode);
void rlight_set_Delay(uint32_t delay);

#endif // _RLIGHT_H