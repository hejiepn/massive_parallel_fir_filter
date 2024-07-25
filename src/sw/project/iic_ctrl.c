#include "iic_ctrl.h"

#define AudioCodecAddr 0x76 // binary: 8'b01110110 ; Write mode active, if LSB == 0
#define INIT_VECTORS 29
#define MAX_ATTEMPTS 5

const unsigned long initVectors[INIT_VECTORS] = {
    //0x400003,  // Clock Control bypass PLL directly
    0x4002027101DD1B01, // PLL control register 0x0271 01DD 1B01 to set Fs:44,1 MHz, with MSCLK: 25MHZ
    0x40000F,  // Clock Control use PLL, enable COREN after PLL is locked
    0x400A01,  // Record Mixer Left (Mixer 1) Control 0 MUTE: LINN, LINP
    0x400B06,  // Record Mixer Left (Mixer 1) Control 1 Amp: LAUX 3dB
    0x400C01,  // Record Mixer Right (Mixer 2) Control 0 MUTE: RINN, RINP
    0x400D06,  // Record Mixer Right (Mixer 2) Control 1 Amp: RAUX 3dB
    0x401500,  // Serial Port Control 0 DEFAULT
    0x401600,  // Serial Port Control 1 DEFAULT 64 BCLK per LRCLK Audio Frame
    0x401700,  // Converter Control set sampling rate of ADC/DAC to Fs
    0x401913,  // ADC Control | both ADCs on
    0x401A00,  // Left Input Digital Volume DEFAULT
    0x401B00,  // Right Input Digital Volume DEFAULT
    0x401C31,  // Playback Mixer Left (Mixer 3) Control 0 Mute: input R DAC, EN: input L DAC, Amp: 6 dB
    0x401D00,  // Playback Mixer Left (Mixer 3) Control 1
    0x401E81,  // Playback Mixer Right (Mixer 4) Control 0 Mute: input L DAC, EN: input R DAC, Amp: 6 dB
    0x401F00,  // Playback Mixer Right (Mixer 4) Control 1 DEFAULT
    0x402005,  // Playback L/R Mixer Left (Mixer 5) Line Output Control Mute: input Mixer 4, en: input Mixer 3
    0x402111,  // Playback L/R Mixer Right (Mixer 6) Line Output Control Mute: input Mixer 3, en: input Mixer 4
    0x402205,  // Playback L/R Mixer Mono Output (Mixer 7) Control ENABLED, Amp: Mixer 3 and 4
    0x4023E6,  // Playback Headphone Left Volume Control Amp: 0dB, unmute headphone left
    0x4024E6,  // Playback Headphone Right Volume Control Amp: 0dB, unmute headphone right, EN line output
    0x4025E6,  // Playback Line Output Left Volume Control | Amp: 0dB, unmute: LOUTN and LOUTP
    0x4026E6,  // Playback Line Output Right Volume Control | Amp: 0dB, unmute: ROUTN and ROUTP
    0x4027E6,  // Playback Mono Output Control unmute Mono output
    0x402903,  // Playback Power Management | both Playbacks on
    0x402A33,  // DAC Control | both DACs on, both channels in mono mode
    0x402F00,  // Control Pad Control, here one can set SDA and SCL to pull up
    0x403000,  // Control Pad Control 1
    0x40EB01,  // set to same sample rate as 0x4017
    0x40F201,  // Serial Input Route Control | Serial Input [L0,RO] to DACs
    0x40F301,  // Serial Output Route Control | ADCs to Serial Output [L0,RO]
    0x40F400,   // Serial Data/GPIO Pin Configuration, Serial Data/GPIO Pin Configuration,
    0x40F800,  // Serial Port Sample Rate set as 0x4017
    0x40F97F,  // Clock Enable 0, only Codec slew digital clock engine disenabled
    0x40FA03  // Clock Enable 1, Digital Clock Generator 0 & 1 on
};

bool started = false; // global data

uint32_t read_SCL(void) {
	//REG32(IIC_SCL_EN) = 0;
	return REG32(STUDENT_IIC_CTRL_SCL_READ(0));
}

uint32_t read_SDA(void) {
	//REG32(IIC_SDA_EN) = 0;
	return REG32(STUDENT_IIC_CTRL_SDA_READ(0));
}

void set_SCL(void) {
	//REG32(IIC_SCL_WRITE) = 1;
	REG32(STUDENT_IIC_CTRL_SCL_EN(0)) = 0x00000000;
}

void clear_SCL(void) {
	//REG32(IIC_SCL_WRITE) = 0;
	REG32(STUDENT_IIC_CTRL_SCL_EN(0)) = 0x00000001;
}

void set_SDA(void) {
	//REG32(IIC_SDA_WRITE) = 1;
	REG32(STUDENT_IIC_CTRL_SDA_EN(0)) = 0x00000000;
}

void clear_SDA(void) {
	//REG32(IIC_SDA_WRITE) = 0;
	REG32(STUDENT_IIC_CTRL_SDA_EN(0)) = 0x00000001;
}

void arbitration_lost(void) {
	printf("arbitration lost function called, either SDA or SCL line stays logical 0\n");
}

void I2C_delay(void) { 
  volatile int v;
  int i;

  v = 0;

  for (i = 0; i < I2CSPEED / 2; ++i) {
    ++v ;
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
		return 0;
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

  printf("i2c_read_byte function \n");

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


void test_ii2(void)
{
    printf("read_SDA at beginning: %x \n", read_SDA());
    printf("read_SCL at beginning: %x \n", read_SCL());
    clear_SDA();
    clear_SCL();
    I2C_delay();
    printf("read_SDA after disenabling: %x \n", read_SDA());
    printf("read_SCL after disenabling: %x \n", read_SCL());
    set_SCL();
    set_SDA();
    I2C_delay();
    printf("read_SDA after enabling: %x \n", read_SDA());
    printf("read_SCL after enabling: %x \n", read_SCL());
}

void testing_i2c_tlul(bool number_test) {
	REG32(STUDENT_IIC_CTRL_SDA_SCL_TESTING(0)) = number_test;
}

uint32_t read_testing_i2c_tlul(void) {
	return REG32(STUDENT_IIC_CTRL_SDA_SCL_TESTING(0));
}
