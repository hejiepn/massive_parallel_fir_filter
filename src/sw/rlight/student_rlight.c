#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"
#include "student_rlight.h"

int student_rlight_test(void) {
    int readword;
    bool correct;
    int retval = 0;

    REG32(STUDENT_RLIGHT_REGA(0)) = 0x000000FF;

    correct = (readword = REG32(STUDENT_RLIGHT_REGA(0))) == 0x000000FF;
    if(!correct)
        retval = 1;
    printf("set RegA: %i (%s)\n", readword, correct?"correct":"WRONG");
    
    REG32(STUDENT_RLIGHT_REGB(0)) = 03;
    
    correct = (readword = REG32(STUDENT_RLIGHT_REGB(0))) == 03;
    if(!correct)
        retval = 1;
    printf("set RegB: %i (%s)\n", readword, correct?"correct":"WRONG");
    
    REG32(STUDENT_RLIGHT_REGC(0)) = 11;
    
    correct = (readword = REG32(STUDENT_RLIGHT_REGC(0))) == 11;
    if(!correct)
        retval = 1;
    printf("set RegC: %i (%s)\n", readword, correct?"correct":"WRONG");

    return retval;
}
