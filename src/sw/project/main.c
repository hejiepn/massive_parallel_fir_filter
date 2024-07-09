#include <stdio.h>
#include "rvlab.h"
#include "filter.h"
#include "iic_ctrl.h"


int main(void) {
    printf("Audio Codec configuration started\n");

    start_audio_codec_config();

    printf("Audio Codec configuration done\n");
    return 0;
}
