/****************************************************************************
*  Telops Inc.                                                              *
*  Projet: ZBT memory test for EFA 180 ROIC                                 * 
*************************************************************************** *
*                                                                           *
*  Project     : ZBT memory test for EFA 180 ROIC                           * 
*                                                                           *
*                                                                           *
*  Author(s)   : Khalid Bensadek                                            *
*                                                                           *
*  Copyright (c) Telops inc. 2010                                           *
*                                                                           *
*****************************************************************************/
#ifndef _COMMON_H_
#define _COMMON_H_

#include <xuartlite.h>
#include <xuartlite_l.h> /*LowLevel drivers*/
#include <stdio.h>
#include "xparameters.h"


/*FPGA Firmware version*/
#define FPGA_REV "1.0a"

/* Define this to have more info messages. */
#define INFO_TRUE 1

/* Define this to have verbose debug messages. */
#define DEBUG_TRUE 0

#if (DEBUG_TRUE == 1)
#define DBGMSG(fmt, args...) xil_printf(fmt"\r\n", ## args)
#define DBGMSGLN(fmt, args...) xil_printf(fmt, ## args)
#else
#define DBGMSG(fmt, args...)
#define DBGMSGLN(fmt, args...)
#endif

#if (INFO_TRUE == 1)
#define INFOMSG(fmt, args...) xil_printf(fmt"\r\n", ## args)
#define INFOMSGLN(fmt, args...) xil_printf(fmt, ## args)
#else
#define INFOMSG(fmt, args...)
#define INFOMSGLN(fmt, args...)
#endif

#define ClearScreen() xil_printf("\033[H\033[J")

#endif /* _COMMON_H_ */

