/****************************************************************************
*  Telops Inc.                                                              *
*  Projet: common                                                           * 
*************************************************************************** *
*                                                                           *
*  Author(s)  : Khalid Bensadek                                             *
*                                                                           *
*                                                                           *
*****************************************************************************/

#ifndef _SPI_ROUTINES_H_
#define _SPI_ROUTINES_H_

#include "xparameters.h"
#include <stdint.h>

/* SPI module base address */
//#define XSPI_BASEADDRS			XPAR_SPI_0_BASEADDR           // pour la carte d'evaluation de xilinx
#define XSPI_BASEADDRS			XPAR_XPS_SPI_SDCARD_BASEADDR     // pour la carte ROIC de IRCDEV

/* SPI manual slave select pin*/
#define SD_CS_ASSERT() 		CS_REG &= 0xE 	
#define SD_CS_DEASSERT() 	CS_REG |= 0x1


/* Functions prototypes */
uint32_t spi_init();
void Spi_SendByte(uint8_t DataByte);
uint8_t Spi_RcvByte();


#endif
