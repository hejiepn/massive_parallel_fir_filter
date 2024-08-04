#include "filter_parallel.h"

 void fir_p_write_in_samples(uint16_t sample) {
  	REG16(STUDENT_FIR_PARALLEL_FIR_WRITE_IN_SAMPLES(0)) = sample;
  }

  uint16_t fir_p_read_shift_out_samples(void) {
  return REG16(STUDENT_FIR_PARALLEL_FIR_READ_SHIFT_OUT_SAMPLES(0));
}

 uint32_t fir_p_read_y_out_lower(void) {
  return REG32(STUDENT_FIR_PARALLEL_FIR_READ_Y_OUT_LOWER(0));
}


 uint32_t fir_p_read_y_out_upper(void) {
  return REG32(STUDENT_FIR_PARALLEL_FIR_READ_Y_OUT_UPPER(0));
}

 void fir_p_en_sine_wave(bool enable) {
	REG32(STUDENT_FIR_PARALLEL_SINE_ENABLE(0)) = enable;
 }


void fir_s_coeff(uint16_t coeff, uint16_t address, uint8_t fir_index, fir_parallel_left_right channel) {

    if (fir_index >= 8) {
        // Handle error: fir_index out of bounds
        printf("fir_index out of bounds! \n");
        return;
    }

    uint32_t base_addr;

    if(channel == right) {
        base_addr = STUDENT_FIR_BASE_ADDR_ARRAY_right[fir_index];    
    } else {
        base_addr = STUDENT_FIR_BASE_ADDR_ARRAY[fir_index];    
    }

    // Ensure address only uses 10 bits (bits 11:2)
    uint32_t addr_mask = 0x3FF; // 10 bits mask
    uint32_t masked_address = (address & addr_mask) << 2; // Shift to bits 11:2

    // Preserve bits 1:0 of the base address
    uint32_t base_lower_bits = base_addr & 0x3;

    // Combine base address with the masked and shifted address
    uint32_t full_address = (base_addr & ~0xFFC) | masked_address | base_lower_bits;

    // Prepare the coefficient
    uint32_t padded_coeff = (uint32_t)coeff;

    // Write to the calculated address
    REG32(full_address) = padded_coeff;
}

void bp_effect(fir_parallel_left_right channel) {
    for(int fir_index = 0; fir_index < 8; fir_index = fir_index + 1) {
        printf("Config FIR Unit %d \n", fir_index);
        for(int i = 0; i < 1024; i = i +1) {
            fir_s_coeff(bp_20_20khz[i], i, fir_index, channel);
        }
    } 
}

void bs_effect(fir_parallel_left_right channel) {
    for(int fir_index = 0; fir_index < 8; fir_index = fir_index + 1) {
        printf("Config FIR Unit %d \n", fir_index);
        for(int i = 0; i < 1024; i = i +1) {
            fir_s_coeff(bs_500_2khz[i], i, fir_index, channel);
        }
    } 
}

void hp_effect(fir_parallel_left_right channel) {
    for(int fir_index = 0; fir_index < 8; fir_index = fir_index + 1) {
        printf("Config FIR Unit %d \n", fir_index);
        for(int i = 0; i < 1024; i = i +1) {
            fir_s_coeff(hp_200[i], i, fir_index, channel);
        }
    } 
}

void lp_effect(fir_parallel_left_right channel) {
    for(int fir_index = 0; fir_index < 8; fir_index = fir_index + 1) {
        printf("Config FIR Unit %d \n", fir_index);
        for(int i = 0; i < 1024; i = i +1) {
            fir_s_coeff(lp_15khz[i], i, fir_index, channel);
        }
    } 
}