#include "rvlab.h"
#include "dma.h"
#include <stdlib.h>
#include <stdio.h>

void memcpy_soft(void *dest, void *src, uint32_t length) {
    // implement me
	uint32_t i;

	if (!dest || !src)
		return (0);
	i = 0;
	while (i < (length/sizeof(int))) //integer(32 bits) wise read/write operations
	{
		((uint32_t *)dest)[i] = ((uint32_t *)src)[i];
		i++;
	}
}

void memcpy_dma(void *dest, void *src, uint32_t length) {
    // implement me
	volatile dma_descriptor_t d;
    
    d.operation = DMA_OP_MEMCPY;
    d.dst_adr   = (uint32_t) dest;
    d.src_adr   = (uint32_t) src;
    d.length    = length;
    
    dma_write_desc(&d);
    dma_wait();
}