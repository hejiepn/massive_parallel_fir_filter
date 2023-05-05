#include <stdio.h>
#include "rvlab.h"

struct descriptor {
  unsigned int set_or_copy; // memset is 0, memcpy is 1
  unsigned int length;
  unsigned int src_adr;
  unsigned int dst_adr;
};

/*void memset_hard(void * ptr, int c, unsigned int length) { //size_t?
	struct descriptor d;
    d.set_or_copy = 1;
    d.length = length;
    d.src_adr = ptr;
    d.dst_adr = value;
	REG32(STUDENT_DMA_NOW_DADR(0)) = &d;
	while(STUDENT_DMA_STATUS(0) != 0) {} // should wait until status is non-zero, hopefully no race condition
}

void memset_soft(void * ptr, int value, unsigned int length) { //size_t?
	for (int i = 0; i < length; i++) {
		*(ptr+i) = value;
	}
}

void memcpy_hard(void *dest, void *src, unsigned int length);

void memcpy_soft(void *dest, void *src, unsigned int length);
*/
int main(void) {
    struct descriptor d;
    d.set_or_copy = 1;
    d.length = 16;
    d.src_adr = 55;
    d.dst_adr = 0x80000000;
    printf("%x\n", &d);
    printf("descriptor: set_or_copy %u, length %u, src_adr %u, dst_adr %u \n", d.set_or_copy, d.length, d.src_adr, d.dst_adr);
	REG32(STUDENT_DMA_NOW_DADR(0)) = &d;
	volatile int b = REG32(STUDENT_DMA_NOW_DADR(0));
    //printf("Hello %x!\n", b);
    
    //outputs 0 while hw2reg outputs correct value
    volatile unsigned int length = REG32(STUDENT_DMA_LENGTH(0));
    volatile unsigned int src_adr = REG32(STUDENT_DMA_SRC_ADR(0));
    volatile unsigned int dst_adr = REG32(STUDENT_DMA_DST_ADR(0));
    printf("reg values: length %u, src_adr %u, dst_adr %u \n", length, src_adr, dst_adr);
    unsigned int * a = 0x80000000;
    printf("%u", *a);

    return 0;
}