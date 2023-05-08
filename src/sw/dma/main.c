#include <stdio.h>
#include "rvlab.h"

#define DMA_OP_MEMSET 0
#define DMA_OP_MEMCPY 1

struct descriptor {
  unsigned int operation;
  unsigned int length;
  unsigned int src_adr;
  unsigned int dst_adr;
};

void memset_hard(void * ptr, unsigned int value, unsigned int length) { //size_t?
	volatile struct descriptor d;
	
    d.operation = DMA_OP_MEMSET;
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

int buf[18];

void memtest_setup() {
	for (int i = 0; i < 18; i++) {
		buf[i] = 0;
	}
	buf[0] = 0xcafe;
	buf[17] = 0xbeef;
}

int memset_test() {
	int return_value = 0;
	memset_hard(buf+1, 55, 16);
	for (int i = 0; i < 18; i++) {
		printf("%x ", buf[i]);
	}
	if((buf[0] != 0xcafe) || (buf[17] != 0xbeef)) {
		printf("\nMemset test failed");
		return_value = 1;
	}
	printf("\n");
	return return_value;
}
int main(void) {
	
	memtest_setup();
	
    return memset_test();
}