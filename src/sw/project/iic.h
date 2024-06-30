#ifndef IIC_H
#define IIC_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"

void audio_codec_init_start(bool start);
bool audio_codec_get_Status(void);

#endif //IIC_H