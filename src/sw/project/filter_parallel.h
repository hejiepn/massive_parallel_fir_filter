#ifndef FILTER_PARALLEL_H
#define FILTER_PARALLEL_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "bandpass_coeff.h"
#include "bandstop_coeff.h"
#include "hp_coeff.h"
#include "lp_coeff.h"

#define FIR_NUM 8
#define ADDRESS_WIDTH 10
#define MAX_ADDR 2^ADDRESS_WIDTH

#define STUDENT_FIR0_BASE_ADDR_c 0x10201000
#define STUDENT_FIR1_BASE_ADDR_c 0x10211000
#define STUDENT_FIR2_BASE_ADDR_c 0x10221000
#define STUDENT_FIR3_BASE_ADDR_c 0x10231000
#define STUDENT_FIR4_BASE_ADDR_c 0x10241000
#define STUDENT_FIR5_BASE_ADDR_c 0x10251000
#define STUDENT_FIR6_BASE_ADDR_c 0x10261000
#define STUDENT_FIR7_BASE_ADDR_c 0x10271000

// Define the array
static uint32_t STUDENT_FIR_BASE_ADDR_ARRAY[] = {
    STUDENT_FIR0_BASE_ADDR_c,
    STUDENT_FIR1_BASE_ADDR_c,
    STUDENT_FIR2_BASE_ADDR_c,
    STUDENT_FIR3_BASE_ADDR_c,
    STUDENT_FIR4_BASE_ADDR_c,
    STUDENT_FIR5_BASE_ADDR_c,
    STUDENT_FIR6_BASE_ADDR_c,
    STUDENT_FIR7_BASE_ADDR_c
};

#define STUDENT_FIR_BASE_ADDR_ARRAY_SIZE (sizeof(STUDENT_FIR_BASE_ADDR_ARRAY) / sizeof(STUDENT_FIR_BASE_ADDR_ARRAY[0]))

#define STUDENT_FIR0_BASE_ADDR_c_r 0x10401000
#define STUDENT_FIR1_BASE_ADDR_c_r 0x10411000
#define STUDENT_FIR2_BASE_ADDR_c_r 0x10421000
#define STUDENT_FIR3_BASE_ADDR_c_r 0x10431000
#define STUDENT_FIR4_BASE_ADDR_c_r 0x10441000
#define STUDENT_FIR5_BASE_ADDR_c_r 0x10451000
#define STUDENT_FIR6_BASE_ADDR_c_r 0x10461000
#define STUDENT_FIR7_BASE_ADDR_c_r 0x10471000

// Define the array
static uint32_t STUDENT_FIR_BASE_ADDR_ARRAY_right[] = {
    STUDENT_FIR0_BASE_ADDR_c_r,
    STUDENT_FIR1_BASE_ADDR_c_r,
    STUDENT_FIR2_BASE_ADDR_c_r,
    STUDENT_FIR3_BASE_ADDR_c_r,
    STUDENT_FIR4_BASE_ADDR_c_r,
    STUDENT_FIR5_BASE_ADDR_c_r,
    STUDENT_FIR6_BASE_ADDR_c_r,
    STUDENT_FIR7_BASE_ADDR_c_r
};

typedef enum
{
    left = 0,
    right = 1
} fir_parallel_left_right;


uint32_t fir_p_read_y_out_upper(void);
uint32_t fir_p_read_y_out_lower(void);
uint16_t fir_p_read_shift_out_samples(void);
void fir_p_write_in_samples(uint16_t sample);
void fir_p_en_sine_wave(bool enable);

void fir_s_coeff(uint16_t coeff, uint16_t address, uint8_t fir_index, fir_parallel_left_right channel);

void bp_effect(fir_parallel_left_right channel);
void bs_effect(fir_parallel_left_right channel);
void hp_effect(fir_parallel_left_right channel);
void lp_effect(fir_parallel_left_right channel);

void shift_amount(uint16_t shift_amount, fir_parallel_left_right channel);

/*
void bp_effect_r(void);
void bs_effect_r(void);
void hp_effect_r(void);
void lp_effect_r(void);

void bp_effect_l(void);
void bs_effect_l(void);
void hp_effect_l(void);
void lp_effect_l(void);
*/

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
 * for e.g.  #define STUDENT_FIR0_BASE_ADDR_s 0x10201000
 * addr_o   = (tl_i.a_valid) ? tl_i.a_address[11:2] : '0;
 * Bit 11 to 2 responds to the address in the dpram
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