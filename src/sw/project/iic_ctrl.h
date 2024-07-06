#ifndef IIC_CTRL_H
#define IIC_CTRL_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"

#define IIC_SDA_EN		STUDENT_IIC_CTRL_SDA_EN(0)
// write on SDA Pin
#define IIC_SDA_WRITE	STUDENT_IIC_CTRL_SDA_WRITE(0)
// read SDA Pin
#define IIC_SDA_READ	STUDENT_IIC_CTRL_SDA_READ(0)
// enable SCL Write
#define IIC_SCL_EN		STUDENT_IIC_CTRL_SCL_EN(0) 
// write on SCL Pin
#define IIC_SCL_WRITE	STUDENT_IIC_CTRL_SCL_WRITE(0)
// read SCL Pin
#define IIC_SCL_READ 	STUDENT_IIC_CTRL_SCL_READ(0)

#define I2CSPEED 100

#define MAX_ITERATIONS 1000

void I2C_delay(void);
bool read_SCL(void); // Return current level of SCL line, 0 or 1
bool read_SDA(void); // Return current level of SDA line, 0 or 1
void set_SCL(void); // Do not drive SCL (set pin high-impedance)
void clear_SCL(void); // Actively drive SCL signal low
void set_SDA(void); // Do not drive SDA (set pin high-impedance)
void clear_SDA(void); // Actively drive SDA signal low
void arbitration_lost(void);
void i2c_start_cond(void);
void i2c_stop_cond(void);
void i2c_write_bit(bool bit);
bool i2c_read_bit(void);
bool i2c_write_byte(bool send_start,
                    bool send_stop,
                    unsigned char byte);
unsigned char i2c_read_byte(bool nack, bool send_stop);

#endif //IIC_CTRL_H