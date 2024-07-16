#ifndef FILTER_H
#define FILTER_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"

typedef enum {
	lowpass,
	highpass,
	bandpass
} filterModule;

void fir_filter_debug_enable(bool enable);
void fir_filter_set_mode(filterModule mode);

#endif //FILTER_H