#include "filter.h"

void fir_filter_debug_enable(bool enable){
	REG32(STUDENT_FILTER_MODULE_DEBUG_ENABLE(0)) = enable;
}

void fir_filter_user_sample_in(uint16_t sample) {
	REG32(STUDENT_FILTER_MODULE_SAMPLES_IN(0)) = sample;
	// REG322(STUDENT_FILTER_MODULE_SAMPLES_IN)  = (REG32 & 0xFFFF0000) | sample;
}