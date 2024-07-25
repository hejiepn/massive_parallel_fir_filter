#include "filter_parallel.h"

/**
void student_fir_s_write_in_samples(unsigned int fir_unit_no, uint16_t sample) {
  	REG16(STUDENT_FIR_FIR_WRITE_IN_SAMPLES(0)) = sample;
  }

  uint16_t student_fir_s_read_out_samples(unsigned int fir_unit_no) {
	return REG16(STUDENT_FIR_FIR_READ_SHIFT_OUT_SAMPLES(fir_unit_no) & 0xffff);
}

uint32_t student_fir_s_read_y_out_upper(unsigned int fir_unit_no) {
	return REG32(STUDENT_FIR_FIR_READ_Y_OUT_UPPER(fir_unit_no) & 0xffffffff);
}


uint32_t student_fir_s_read_y_out_lower(unsigned int fir_unit_no) {
	return REG32(STUDENT_FIR_FIR_READ_Y_OUT_LOWER(0) & 0xffffffff);
}
**/
void student_fir_s_write_in_samples(uint16_t sample) {
  	REG16(STUDENT_FIR_FIR_WRITE_IN_SAMPLES(0)) = sample;
  }

 void student_fir_p_write_in_samples(uint16_t sample) {
  	REG16(fir_p_write_in_samples) = sample;
  }