#ifndef FILTER_PARALLEL_H
#define FILTER_PARALLEL_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"

#define fir_p_write_in_samples STUDENT_FIR_PARALLEL_FIR_WRITE_IN_SAMPLES(0)                        
#define fir_p_read_shift_out_samples STUDENT_FIR_PARALLEL_FIR_READ_SHIFT_OUT_SAMPLES(0)                   
#define fir_p_read_y_out_upper STUDENT_FIR_PARALLEL_FIR_READ_Y_OUT_UPPER(0)                         
#define fir_p_read_y_out_lower STUDENT_FIR_PARALLEL_FIR_READ_Y_OUT_LOWER(0)

#define FIR_NUM 4

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
 **/            


#endif //FILTER_H