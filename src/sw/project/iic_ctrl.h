#ifndef IIC_CTRL_H
#define IIC_CTRL_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "rvlab.h"

// enable SCL Write
//#define IIC_SDA_EN		STUDENT_IIC_CTRL_SDA_EN(0)
//#define IIC_SCL_EN		STUDENT_IIC_CTRL_SCL_EN(0) 
//#define IIC_SDA_READ	STUDENT_IIC_CTRL_SDA_READ(0)
//#define IIC_SCL_READ 	STUDENT_IIC_CTRL_SCL_READ(0)
// #define IIC_SDA_WRITE	STUDENT_IIC_CTRL_SDA_WRITE(0)
// #define IIC_SCL_WRITE	STUDENT_IIC_CTRL_SCL_WRITE(0)
// // write on SDA Pin
// // read SDA Pin
// // write on SCL Pin
// // read SCL Pin

#define I2CSPEED 100

#define MAX_ITERATIONS 1000

void I2C_delay(void);
uint32_t read_SCL(void); // Return current level of SCL line, 0 or 1
uint32_t read_SDA(void); // Return current level of SDA line, 0 or 1
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
void start_audio_codec_config(void);
void test_ii2(void);
void testing_i2c_tlul(bool number_test);
uint32_t read_testing_i2c_tlul(void);
void start_pll_config(void);
int check_pll_locked(void);
void print_num_initVectors(void);


#endif //IIC_CTRL_H