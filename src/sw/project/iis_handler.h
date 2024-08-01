#ifndef IIS_HANDLER_H
#define IIS_HANDLER_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"

#define i2s_serial_in STUDENT_IIS_HANDLER_SERIAL_IN(0)                        
#define i2s_pcm_out_left STUDENT_IIS_HANDLER_PCM_OUT_LEFT(0)
#define i2s_pcm_out_right STUDENT_IIS_HANDLER_PCM_OUT_RIGHT(0)                        
#define i2s_serial_out STUDENT_IIS_HANDLER_SERIAL_OUT(0)
#define i2s_pcm_in_left STUDENT_IIS_HANDLER_PCM_IN_LEFT(0)
#define i2s_pcm_in_right STUDENT_IIS_HANDLER_PCM_IN_RIGHT(0)  

uint32_t read_pcm_out_left(void);
uint32_t read_pcm_out_right(void);
void write_serial_in(uint16_t serial_sample);


#endif //FILTER_H