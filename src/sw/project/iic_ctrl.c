#include "iic_ctrl.h"

bool started = false; // global data

bool read_SCL(void) {
	REG32(IIC_SCL_EN) = 0;
	return (bool) (REG32(IIC_SCL_READ) & STUDENT_IIC_CTRL_SCL_READ_MASK);
}

bool read_SDA(void) {
	REG32(IIC_SDA_EN) = 0;
	return (bool) (REG32(IIC_SDA_READ) & STUDENT_IIC_CTRL_SDA_READ_MASK);
}

void set_SCL(void) {
	//REG32(IIC_SCL_WRITE) = 1;
	REG32(IIC_SCL_EN) = 0; //let pull up resistor drive pin high
}

void clear_SCL(void) {
	REG32(IIC_SCL_WRITE) = 0;
	REG32(IIC_SCL_EN) = 1;
}

void set_SDA(void) {
	//REG32(IIC_SDA_WRITE) = 1;
	REG32(IIC_SDA_EN) = 0;
}

void clear_SDA(void) {
	REG32(IIC_SDA_WRITE) = 0;
	REG32(IIC_SDA_EN) = 1;
}

void arbitration_lost(void) {
	printf("arbitration lost function called, either SDA or SCL line stays logical 0\n");
}

void I2C_delay(void) { 
  volatile int v;
  int i;

  for (i = 0; i < I2CSPEED / 2; ++i) {
    v;
  }
}

void i2c_start_cond(void)
{
  if (started) { 
    // if started, do a restart condition
    // set SDA to 1
    set_SDA();
    I2C_delay();
    set_SCL();

	int timeout = 0;
    while (read_SCL() == 0) { // Clock stretching
	  printf("readSCL in clock stretching is: %d \n",read_SCL());
      if (timeout >= MAX_ITERATIONS) {
        arbitration_lost();
        return;
      }
      ++timeout;
    }

    // Repeated start setup time, minimum 4.7us
    I2C_delay();
  }

  if (read_SDA() == 0) {
	printf("read_SDA is: %d \n",read_SDA());
    arbitration_lost();
  }

  // SCL is high, set SDA from 1 to 0.
  clear_SDA();
  I2C_delay();
  clear_SCL();
  started = true;
}

void i2c_stop_cond(void)
{
  // set SDA to 0
  clear_SDA();
  I2C_delay();

  set_SCL();

  int timeout = 0;
  while (read_SCL() == 0) { // Clock stretching
  	if (timeout >= MAX_ITERATIONS) {
		arbitration_lost();
		return;
	}
	++timeout;
  }

  // Stop bit setup time, minimum 4us
  I2C_delay();

  // SCL is high, set SDA from 0 to 1
  set_SDA();
  I2C_delay();

  if (read_SDA() == 0) {
    arbitration_lost();
  }

  started = false;
}

// Write a bit to I2C bus
void i2c_write_bit(bool bit)
{
  if (bit) {
    set_SDA();
  } else {
    clear_SDA();
  }

  // SDA change propagation delay
  I2C_delay();

  // Set SCL high to indicate a new valid SDA value is available
  set_SCL();

  // Wait for SDA value to be read by target, minimum of 4us for standard mode
  I2C_delay();

  int timeout = 0;
  while (read_SCL() == 0) { // Clock stretching
    if (timeout >= MAX_ITERATIONS) {
		arbitration_lost();
		return;
	}
	++timeout;
  }

  // SCL is high, now data is valid
  // If SDA is high, check that nobody else is driving SDA
  if (bit && (read_SDA() == 0)) {
    arbitration_lost();
  }

  // Clear the SCL to low in preparation for next change
  clear_SCL();
}

// Read a bit from I2C bus
bool i2c_read_bit(void)
{
  bool bit;

  // Let the target drive data
  set_SDA();

  // Wait for SDA value to be written by target, minimum of 4us for standard mode
  I2C_delay();

  // Set SCL high to indicate a new valid SDA value is available
  set_SCL();

  int timeout = 0;
  while (read_SCL() == 0) { // Clock stretching
    if (timeout >= MAX_ITERATIONS) {
		arbitration_lost();
		return;
	}
	++timeout;
  }

  // Wait for SDA value to be written by target, minimum of 4us for standard mode
  I2C_delay();

  // SCL is high, read out bit
  bit = read_SDA();

  // Set SCL low in preparation for next operation
  clear_SCL();

  return bit;
}

// Write a byte to I2C bus. Return 0 if ack by the target.
bool i2c_write_byte(bool send_start,
                    bool send_stop,
                    unsigned char byte)
{
  unsigned bit;
  bool     nack;

  if (send_start) {
    i2c_start_cond();
  }

  for (bit = 0; bit < 8; ++bit) {
    i2c_write_bit((byte & 0x80) != 0);
    byte <<= 1;
  }

  nack = i2c_read_bit();

  if (send_stop) {
    i2c_stop_cond();
  }

  return nack;
}

// Read a byte from I2C bus
unsigned char i2c_read_byte(bool nack, bool send_stop)
{
  unsigned char byte = 0;
  unsigned char bit;

  for (bit = 0; bit < 8; ++bit) {
    byte = (byte << 1) | i2c_read_bit();
  }

  i2c_write_bit(nack);

  if (send_stop) {
    i2c_stop_cond();
  }

  return byte;
}