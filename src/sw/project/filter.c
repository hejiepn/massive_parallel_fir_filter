#include "filter.h"

void fir_filter_debug_enable(bool enable){
	REG32(STUDENT_FILTER_MODULE_DEBUG_ENABLE(0)) = enable;
}

void fir_filter_set_mode(filterModule mode) {
	REG32(STUDENT_FILTER_MODULE_MODE(0)) = mode;
}