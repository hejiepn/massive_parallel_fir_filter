#ifndef FILTER_H
#define FILTER_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "rvlab.h"

// typedef enum {
// 	lowpass,
// 	highpass,
// 	bandpass
// } filterModule;

void fir_filter_debug_enable(bool enable);
void fir_filter_user_sample_in(uint16_t sample);

#endif //FILTER_H