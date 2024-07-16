#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "rvlab.h"
#include "filter.h"

int main(void) {
    printf("FIR started\n");

    // FILE *file;
    // char filename[] = "sin_low_debug.mem";
    // char line[5];  // 4 characters for hex data + 1 for null terminator
    // uint16_t sample;

    // file = fopen(filename, "r");
    // if (file == NULL) {
    //     fprintf(stderr, "crashed %s\n", filename);
    //     return 1;
    // }

    // while (fgets(line, sizeof(line), file) != NULL) {
    //     sample = (uint16_t)strtoul(line, NULL, 16);
    //     printf("sample value int: %d\n", sample);
    //     fir_filter_user_sample_in(sample);
    //     // printf("sample value hex: 0x%04x\n", sample);
    // }

    // fclose(file);
    uint16_t sample = 42;
    while(true) {
        fir_filter_user_sample_in(sample);
    }
    printf("FIR done\n");

    return 0;
}
