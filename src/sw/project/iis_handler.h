#ifndef IIS_HANDLER_H
#define IIS_HANDLER_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"


 void enable_loopback(bool enable);

 uint32_t readSerialOut(void);
 uint16_t readPcmOutRight(void);
 uint16_t readPcmOutLeft(void);

 void writeInSerialIn(uint16_t serialInSample);



#endif //IIS_HANDLER_H