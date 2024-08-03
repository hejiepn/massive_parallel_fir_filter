#include "filter_parallel.h"

 void fir_p_write_in_samples(uint16_t sample) {
  	REG16(STUDENT_FIR_PARALLEL_FIR_WRITE_IN_SAMPLES(0)) = sample;
  }

  uint16_t fir_p_read_shift_out_samples(void) {
  return REG16(STUDENT_FIR_PARALLEL_FIR_READ_SHIFT_OUT_SAMPLES(0));
}

 uint32_t fir_p_read_y_out_lower(void) {
  return REG32(STUDENT_FIR_PARALLEL_FIR_READ_Y_OUT_LOWER(0));
}


 uint32_t fir_p_read_y_out_upper(void) {
  return REG32(STUDENT_FIR_PARALLEL_FIR_READ_Y_OUT_UPPER(0));
}

 void fir_p_en_sine_wave(bool enable) {
	REG32(STUDENT_FIR_PARALLEL_SINE_ENABLE(0)) = enable;
 }