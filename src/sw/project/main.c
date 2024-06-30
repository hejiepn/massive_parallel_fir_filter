#include <stdio.h>
#include "rvlab.h"
#include "iic.h"
#include "filter.h"

int main(void) {
  printf("Codec configuration started\n");
  audio_codec_init_start(1);
  while (!audio_codec_get_Status())
  {
  }
  printf("Codec configuration done\n");
 
  return 0;
}
