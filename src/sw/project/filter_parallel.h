#ifndef FILTER_PARALLEL_H
#define FILTER_PARALLEL_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"

#define FIR_NUM 8

 uint32_t fir_p_read_y_out_upper(void);
 uint32_t fir_p_read_y_out_lower(void);
 uint16_t fir_p_read_shift_out_samples(void);
 void fir_p_write_in_samples(uint16_t sample);
 void fir_p_en_sine_wave(bool enable);

/**
 * Adressing in the FIR Parallel
 * FIR Parallel Address: 102ab000
 * 
 * a = addresses the single fir units and the fir parallel unit from 0 to NUM_FIR - 1
 * for a = 
 * 		0 - NUM_FIR-1: each single fir unit
 * 		NUM_FIR:the FIR Parallel registers itself are addressed
 * 
 * b = addresses the dprams of each fir unit
 * for b:
 * 		0: dpram_samples
 * 		1: dpram_coeff
 * 		2: single fir unit's registers
 *
 * 
 * DPRAM Memory Addressing
 * for e.g.  #define STUDENT_FIR0_BASE_ADDR_s 0x10200000
 * last 2 Bytes respond to address in bram
 * 
 **/            

 /*
#include "reggen/student_fir.h"
#define STUDENT_FIR0_BASE_ADDR 0x10202000
#define STUDENT_FIR0_BASE_ADDR_s 0x10200000
#define STUDENT_FIR0_BASE_ADDR_c 0x10201000

#define STUDENT_FIR1_BASE_ADDR 0x10212000
#define STUDENT_FIR1_BASE_ADDR_s 0x10210000
#define STUDENT_FIR1_BASE_ADDR_c 0x10211000

#define STUDENT_FIR2_BASE_ADDR 0x10222000
#define STUDENT_FIR2_BASE_ADDR_s 0x10220000
#define STUDENT_FIR2_BASE_ADDR_c 0x10221000

#define STUDENT_FIR3_BASE_ADDR 0x10232000
#define STUDENT_FIR3_BASE_ADDR_s 0x10230000
#define STUDENT_FIR3_BASE_ADDR_c 0x10231000

Bit 19 -16 of FIR_PARALLEL0 is the NUM_FIR in student.sv 

*/


#endif //FILTER_H