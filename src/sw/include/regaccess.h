#ifndef _REGACCESS_H
#define _REGACCESS_H

#include <stdint.h>

// Main memory access macros:

#define REG8(addr) *((volatile uint8_t *)(addr))
#define REG16(addr) *((volatile uint16_t *)(addr))
#define REG32(addr) *((volatile uint32_t *)(addr))

// CPU CSR access macros:

#define read_csr(reg) ({ unsigned long __tmp; \
  asm volatile ("csrr %0, " reg : "=r"(__tmp)); \
  __tmp; })

#define write_csr(reg, val) ({ \
  asm volatile ("csrw " reg ", %0" :: "rK"(val)); })

/*
#define MCYCLE (0xB00)

#define FENCE ({asm volatile("": : :"memory");})
*/

#endif // _REGACCESS_H