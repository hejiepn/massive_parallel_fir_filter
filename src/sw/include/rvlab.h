#ifndef _RVLAB_H
#define _RVLAB_H

#define IRQ_TIMER 7
#define IRQ_EXTERNAL 11

#define DDR3_BASE_ADDR 0x80000000
#define DDR3_SIZE      0x20000000

#include "regaccess.h"

#include "reggen/rv_timer.h"
#define RV_TIMER0_BASE_ADDR 0x1f000000

#include "reggen/ddr_ctrl.h"
#define DDR_CTRL0_BASE_ADDR 0x1f001000

#include "reggen/regdemo.h"
#define REGDEMO0_BASE_ADDR 0x1f002000


#include "reggen/student_dma.h"
#define STUDENT_DMA0_BASE_ADDR 0x20000000

// Add includes for additional register definition headers
// and define corresponding _BASE_ADDR values here.

#include "reggen/irq_ctrl.h"
#define IRQ_CTRL0_BASE_ADDR 0x10000000

#include "reggen/student_rlight.h"
#define STUDENT_RLIGHT0_BASE_ADDR 0x10100000

#include "reggen/student_audio_codec.h"
#define STUDENT_AUDIO_CODEC0_BASE_ADDR 0x10200000

#include "reggen/student_filter_module.h"
#define STUDENT_FILTER_MODULE0_BASE_ADDR 0x10300000

#include "reggen/student_iic_ctrl.h"
#define STUDENT_IIC_CTRL0_BASE_ADDR 0x10400000

#endif // _RVLAB_H
