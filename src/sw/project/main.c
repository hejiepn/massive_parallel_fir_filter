#include <stdio.h>
#include "rvlab.h"
#include "filter.h"
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

void start_audio_codec_config(void) {
    for (int i = 0; i < INIT_VECTORS; i++) {
        unsigned long initWord = initVectors[i];
        unsigned char addr = (initWord >> 16) & 0xFF;
        unsigned char regAddr = (initWord >> 8) & 0xFF;
        unsigned char data = initWord & 0xFF;
        
        int attempts = 0;
        bool success = false;
        
        while (attempts < MAX_ATTEMPTS && !success) {
            // Start condition and write the slave address once
            if (i2c_write_byte(true, false, AudioCodecAddr) == 0) {
                // Write the register address and data in sequence
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

int main(void) {
    printf("Audio Codec configuration started\n");

    start_audio_codec_config();

    printf("Audio Codec configuration done\n");
    return 0;
}
