/****************************************************************************
*  Telops Inc.                                                              *
*  Projet: common                                                           * 
*************************************************************************** *
*                                                                           *
*  Author(s)	: CC Dharmani, Chennai (India)                              *
*  Source		: www.dharmanitech.com                                      *
*  Modified by  : Khalid Bensadek                                           *
*                                                                           *
*                                                                           *
*****************************************************************************/
#ifndef _SD_ROUTINES_H_
#define _SD_ROUTINES_H_

#include <stdint.h>
#include "ROIC_IRC_Status.h" 

//------------- CMD definition: used only ------------
#define CMD0   0  //GO_IDLE_STATE
#define CMD1   1  //SEND_OP_COND
#define CMD6   6  //Switch Function
#define CMD8   8  //SEND Interface Conditions
#define CMD12  12 //STOP_TRANSMISSION
#define CMD16  16 //SET_BLOCK_LEN
#define CMD17  17 //READ_SINGLE_BLOCK
#define CMD18  18 //READ_MULTIPLE_BLOCKS
#define CMD24  24 //WRITE_SINGLE_BLOCK
#define CMD25  25 //WRITE_MULTIPLE_BLOCKS
#define CMD32  32 //ERASE_BLOCK_START_ADDR
#define CMD33  33 //ERASE_BLOCK_END_ADDR
#define CMD38  38 //ERASE_SELECTED_BLOCKS
#define CMD55  55 //APP_CMD
#define ACMD41 41 //SEND_OR_COND, for vers 2.0 and up
#define CMD58  58 //READ_OCR
#define CMD59  59 //CRC_ON_OFF

//------------- some Response R1 bit masks ---------------
#define IN_IDLE_STATE   0x01
#define ILLEGAL_CMD     0x04
#define COM_CRC_ERR     0x08

#define SD_CCS_BIT      0x40
#define SD_HOST_VHS     0x01

/* Constants difinition */
#define ON     1
#define OFF    0
#define SD_CHECK_PATTERN   0xAA
#define BLOCK_SIZE		512
#define BUFFER_SIZE		BLOCK_SIZE


/**************************** Type Definitions ******************************/
typedef struct
{
   uint8_t RspR1;
   uint8_t Rspbyte0;
   uint8_t Rspbyte1;
   uint8_t Rspbyte2;
   uint8_t Rspbyte3;
} t_SD_CMD_RESP;

typedef enum
{
   RTYPE_R1 = 0,
   RTYPE_R3
} t_RTYPE;

//SPI software CS control register
#define CS_REG (*((volatile uint32_t *) XPAR_SS_CTRL_REG_0_BASEADDR))

IRC_Status   SD_init(void);
IRC_Status SD_moduleInit();                       // permet d'initialiser le spi puis la SD_Card
IRC_Status SD_Send_CMD(uint8_t SD_CMD_TBL[], t_SD_CMD_RESP *SD_CMD_RESP, t_RTYPE R_TYPE);
IRC_Status   SD_readSingleBlock(uint8_t *Buffer, uint32_t startBlock);

#endif
