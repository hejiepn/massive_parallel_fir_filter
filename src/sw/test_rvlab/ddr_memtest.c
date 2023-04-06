#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "rvlab.h"

int ddr_init(void) {
    if(!(REG32(DDR_CTRL_STATUS(0)) & (1<<DDR_CTRL_STATUS_PRESENT_LSB))) {
        printf("Error: DDR not present.\n");
        return 1;
    }
    REG32(DDR_CTRL_CTRL(0)) |= (1<<DDR_CTRL_CTRL_MIG_RST_N_LSB); // deassert reset

    // wait for calibration to complete:
    while(!(REG32(DDR_CTRL_STATUS(0)) & (1<<DDR_CTRL_STATUS_CALIB_COMPLETE_LSB))); 

    printf("ddr calib complete, temp: %i\n\n", REG32(DDR_CTRL_TEMP(0)));
    return 0;
}

static void lfsr_init(uint32_t *v) {
    *v = 1;
}

static void lfsr_next(uint32_t *v) {
    unsigned b = (*v) & 1;
    *v = ((*v) >> 1) ^ (-b & 0xc3308398);
}

int memtest(void *start, size_t length) {
    uint32_t lfsr;
    int retval = 0;

    lfsr_init(&lfsr);
    uint32_t addr;
    for(addr=(uint32_t) start;addr<(uint32_t) start+length;addr+=4) {
        REG32(addr) = lfsr;

        if((addr & 0xfffff) == 0) {
            printf("\rWriting address 0x%08x...", addr);
        }
        lfsr_next(&lfsr);
    }
    printf("\nWrite completed.\n");
    
    lfsr_init(&lfsr);
    for(addr=(uint32_t) start;addr<(uint32_t) start+length;addr+=4) {
        if(REG32(addr) == lfsr) {
            if((addr & 0xfffff) == 0) {
                printf("\rReading address 0x%08x...", addr);
            }
        } else {
            printf("\rERROR: Incorrect read data at 0x%08x.\n", addr);
            retval = 1;
        }
        lfsr_next(&lfsr);
    }
    if(retval) {
        printf("\nMemtest completed with errors.\n\n");
    } else {
        printf("\nMemtest completed without errors.\n\n");
    }

    return retval;
}


int ddr_memtest(void) {
    return memtest((void*)DDR3_BASE_ADDR, DDR3_SIZE);
}