#include "iic_ctrl.h"

#define AudioCodecAddr 0x76 // binary: 8'b01110110 ; Write mode active, if LSB == 0
#define INIT_VECTORS 29
#define MAX_ATTEMPTS 5

const unsigned long initVectors[INIT_VECTORS] = {
    0x400003,  // Clock Control
    0x401500,  // Serial Port Control 0
    0x401600,  // Serial Port Control 1
    0x401700,  // Converter Control
    0x40F800,  // Serial Port Sample Rate
    0x401913,  // ADC Control | both ADCs on
    0x402A03,  // DAC Control | both DACs on
    0x402903,  // Playback Power Management | both Playbacks on
    0x40F201,  // Serial Input Route Control | Serial Input [L0,RO] to DACs
    0x40F97F,  // Clock Enable 0
    0x40FA03,  // Clock Enable 1
    0x402003,  // Playback L/R Mixer Left (Mixer 5) Line Output Control
    0x402200,  // Playback L/R Mixer Mono Output (Mixer 7) Control
    0x402109,  // Playback L/R Mixer Right (Mixer 6) Line Output Control
    0x4025E6,  // Playback Line Output Left Volume Control | 0dB
    0x4026E6,  // Playback Line Output Right Volume Control | 0dB
    0x402700,  // Playback Mono Output Control
    0x4023E6,  // Playback Headphone Left Volume Control
    0x4024E6,  // Playback Headphone Right Volume Control
    0x400A01,  // Record Mixer Left (Mixer 1) Control 0
    0x400B05,  // Record Mixer Left (Mixer 1) Control 1
    0x400C01,  // Record Mixer Right (Mixer 2) Control 0
    0x400D05,  // Record Mixer Right (Mixer 2) Control 1
    0x401C21,  // Playback Mixer Left (Mixer 3) Control 0
    0x401D00,  // Playback Mixer Left (Mixer 3) Control 1
    0x401E41,  // Playback Mixer Right (Mixer 4) Control 0
    0x401F00,  // Playback Mixer Right (Mixer 4) Control 1
    0x40F301,  // Serial Output Route Control | ADCs to Serial Output [L0,RO]
    0x40F400   // Serial Data/GPIO Pin Configuration
};

bool started = false; // global data

bool read_SCL(void) {
	//REG32(IIC_SCL_EN) = 0;
	return (bool) (REG32(IIC_SCL_READ) & STUDENT_IIC_CTRL_SCL_READ_MASK);
}

bool read_SDA(void) {
	//REG32(IIC_SDA_EN) = 0;
	return (bool) (REG32(IIC_SDA_READ) & STUDENT_IIC_CTRL_SDA_READ_MASK);
}

void set_SCL(void) {
	//REG32(IIC_SCL_WRITE) = 1;
	REG32(IIC_SCL_EN) = 0; //let pull up resistor drive pin high
}

void clear_SCL(void) {
	//REG32(IIC_SCL_WRITE) = 0;
	REG32(IIC_SCL_EN) = 1;
}

void set_SDA(void) {
	//REG32(IIC_SDA_WRITE) = 1;
	REG32(IIC_SDA_EN) = 0;
}

void clear_SDA(void) {
	//REG32(IIC_SDA_WRITE) = 0;
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
  
  printf("i2c_write_byte function \n");

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

  printf("i2c_write_byte function \n");

  for (bit = 0; bit < 8; ++bit) {
    byte = (byte << 1) | i2c_read_bit();
  }

  i2c_write_bit(nack);

  if (send_stop) {
    i2c_stop_cond();
  }

  return byte;
}

void start_audio_codec_config(void) {
    for (int i = 0; i < INIT_VECTORS; i++) {
        unsigned long initWord = initVectors[i];
        unsigned char addr = (initWord >> 16) & 0xFF;
        unsigned char regAddr = (initWord >> 8) & 0xFF;
        unsigned char data = initWord & 0xFF;
        
        int attempts = 0;
        bool success = false;
        
        while (attempts < MAX_ATTEMPTS && !success) {
			printf("attempts: %d \n", attempts);
            printf("Start condition and write the slave address once\n");
            if (i2c_write_byte(true, false, AudioCodecAddr) == 0) {
                printf("Write the register address and data in sequence\n");
                if (i2c_write_byte(false, false, addr) == 0 &&
                    i2c_write_byte(false, false, regAddr) == 0 &&
                    i2c_write_byte(false, true, data) == 0) {
                    success = true;
                    printf("Register 0x%02X%02X configured successfully.\n", addr, regAddr);
                }
            }
            if (!success) {
                printf("Failed to configure register 0x%02X%02X Retrying...\n", addr, regAddr);
                attempts++;
            }
        }
        
        if (!success) {
            printf("Failed to configure register 0x%02X%02X after %d attempts. Exiting...\n", addr, regAddr, MAX_ATTEMPTS);
            break;
        }
    }
}