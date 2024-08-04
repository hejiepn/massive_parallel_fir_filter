#ifndef _USERINTERFACE_H
#define _USERINTERFACE_H

#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "filter_parallel.h"
#include "iis_handler.h"

#define LINE_SIZE 256

// Public Function Declarations
int start_cli(void);
void cmd_sw(char *args[]);
void cmd_dump(char *args[]);
void cmd_lw(char *args[]) ;
void cmd_help(char *args[]);
char *readline(void);

void cmd_bp(char *args[]);
void cmd_bs(char *args[]);
void cmd_hp(char *args[]);
void cmd_lp(char *args[]);
void cmd_iis(char *args[]);
void cmd_shift(char *args[]);

#endif // _USERINTERFACE_H