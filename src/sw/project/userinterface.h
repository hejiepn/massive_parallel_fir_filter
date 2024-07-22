#ifndef _USERINTERFACE_H
#define _USERINTERFACE_H

#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "init.h"

#define LINE_SIZE 256

// Public Function Declarations
int start_cli(void);
void cmd_sw(char *args[]);
void cmd_dump(char *args[]);
void cmd_lw(char *args[]) ;
void cmd_help(char *args[]);
char *readline(void);

#endif // _USERINTERFACE_H