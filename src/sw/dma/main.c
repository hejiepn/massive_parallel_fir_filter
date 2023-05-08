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

int buf[64];

void memtest_setup() {
	for (int i = 0; i < 64; i++) {
		buf[i] = 0;
	}
	buf[0] = 0xcafe;
	buf[63] = 0xbeef;
}

int memset_test() {
	int errcnt;
	int n_writes = 4;
	memset_hard(buf+1, 55, n_writes*sizeof(int));
	for (int i = 0; i < 64; i++) {
		int val_expected;
		if(i==0) {
			val_expected = 0xcafe;
		} else if (i<(1+n_writes)) {
			val_expected = 55;
		} else if (i<63) {
			val_expected = 0;
		} else { // i == 63
			val_expected = 0xbeef;
		}
		int val_read = buf[i];
		if(val_read != val_expected) {
			printf("Error after memset: buf[%i] was %i != %i\n", i, val_read, val_expected);
			errcnt++;
		}
		printf("%x ", buf[i]);
	}
	if(errcnt == 0) {
		printf("[pass] memset.\n");
	}
	return errcnt;
}
int main(void) {
	
	memtest_setup();
	
    return memset_test();
}