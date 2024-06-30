#include "iic.h"

void audio_codec_init_start(bool start)
{
	REG32(STUDENT_AUDIO_CODEC_START_AUDIO_CODEC_INIT(0)) = start;
}

bool audio_codec_get_Status(void) {
	return REG32(STUDENT_AUDIO_CODEC_AUDIO_CODEC_INIT_DONE(0));
}