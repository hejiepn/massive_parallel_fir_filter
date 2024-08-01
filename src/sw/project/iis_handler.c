#include "iis_handler.h"

uint32_t read_pcm_out_left(void) {
	return REG32(i2s_pcm_out_left);
}
uint32_t read_pcm_out_right(void) {
	return REG32(i2s_pcm_out_right);
}

void write_serial_in(uint16_t serial_sample) {
	REG16(i2s_serial_in) = serial_sample;
}
