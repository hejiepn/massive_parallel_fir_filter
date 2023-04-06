#ifndef _RVLAB_H
#define _RVLAB_H

#define DDR3_BASE_ADDR 0x80000000
#define DDR3_SIZE      0x20000000

#include "regaccess.h"

#include "reggen/ddr_ctrl.h"
#define DDR_CTRL0_BASE_ADDR 0x1f001000

#include "reggen/regdemo.h"
#define REGDEMO0_BASE_ADDR 0x1f002000

#include "reggen/rv_timer.h"
#define RV_TIMER0_BASE_ADDR 0x1f000000

// Add includes for additional register definition headers
// and define corresponding _BASE_ADDR values here.

#endif // _RVLAB_H