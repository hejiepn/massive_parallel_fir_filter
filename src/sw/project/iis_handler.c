#include "iis_handler.h"

void enable_loopback(bool enable) {
	REG32(STUDENT_IIS_HANDLER_LOOPBACK_ENABLE(0)) = enable;
}

void writeInSerialIn(uint16_t serialInSample) {
	REG16(STUDENT_IIS_HANDLER_SERIAL_IN(0)) = serialInSample;
}

uint16_t readPcmOutLeft(void) {
	return REG16(STUDENT_IIS_HANDLER_PCM_OUT_LEFT(0));
}

uint16_t readPcmOutRight(void) {
	return REG16(STUDENT_IIS_HANDLER_PCM_OUT_RIGHT(0));
}

uint32_t readSerialOut(void) {
	return (REG32(STUDENT_IIS_HANDLER_SERIAL_OUT(0)) && STUDENT_IIS_HANDLER_SERIAL_OUT_IIS_S_OUT_MASK);
}