#include <stdio.h>
#include "rvlab.h"

struct descriptor {
  unsigned int set_or_copy; // memset is 0, memcpy is 1
  unsigned int length;
  unsigned int src_adr;
  unsigned int dst_adr;
};

void memset_hard(void * ptr, unsigned int value, unsigned int length) { //size_t?
	volatile struct descriptor d;
	
    d.set_or_copy = 1;
    d.dst_adr = ptr;
    d.src_adr = value;
	d.length = length;
	
	REG32(STUDENT_DMA_NOW_DADR(0)) = &d;
	while(REG32(STUDENT_DMA_STATUS(0)) != 0);
}

void memset_soft(void * ptr, int value, unsigned int length) { //size_t?
	int * ptr_i = (int*) ptr;
	for (int i = 0; i < (length/sizeof(int)); i++) {
		ptr_i[i] = value;
	}
}

void memcpy_hard(void *dest, void *src, unsigned int length);

void memcpy_soft(void *dest, void *src, unsigned int length);

int buf[16];
int main(void) {
	for (int i = 0; i < 16; i++) {
		buf[i] = 0;
	}
    
	memset_hard(&buf, 55, 16);
	//memset_soft(&buf, 55, 16);
    for (int i = 0; i < 5; i++) {
    	printf("%u\n", buf[i]);
    }

    return 0;
}