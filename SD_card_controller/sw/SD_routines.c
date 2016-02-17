/****************************************************************************
*  Telops Inc.                                                       
*  Projet: common                                                 
*************************************************************************** *
* 
*  Author(s)	: CC Dharmani, Chennai (India) 
*  Source		: www.dharmanitech.com                                      
*  Modified by  : Khalid Bensadek, Edem Nofodjie                            
*
* 08/12/2011  Khalid Bensadek: added support for SDHC card and impooved driver
*****************************************************************************/

/***************************** Include Files *********************************/

#include "xparameters.h"	/* XPAR parameters */
#include "xspi_l.h"
//#include "xtime_l.h"
#include "utils.h"
#include "sd_routines.h"
#include "spi_routines.h"
#include "string.h"
#include "ROIC_IRC_Status.h" 

/************************** Variable Definitions *****************************/
//static XSpi  SpiInstance;	 /* The instance of the SPI device */
// XTime   start_tick, end_tick, offset;   
// XTime   nticks;
// u32   etime_us1, etime_us2, etime_us3;
#define SD_PRINT    //PRINT
#define SD_PRINTF   //PRINTF

#define RETRY_TIMEOUT   500
uint8_t SD_isHC;
t_SD_CMD_RESP SD_CMD_RESP;
/************************** Functions Prototype *****************************/

/*****************************************************************************
 SD_init: function to initialize the SD card and put it in SPI mode
*****************************************************************************/
IRC_Status SD_init(void)
{
	uint16_t ii, retry;
	uint8_t response;
   
   /* Declaration of the pre-calculated set of CMDs needed for the SD init*/   
   uint8_t CMD0_TBL[] = {(CMD0|0x40),0,0,0,0,0x95};
   uint8_t CMD8_TBL[] = {(CMD8|0x40),0,0,0x01,SD_CHECK_PATTERN,0x87};
   uint8_t CMD55_TBL[] = {(CMD55|0x40),0,0,0,0,0x65};
   uint8_t ACMD41_TBL[] = {(ACMD41|0x40),0x40,0,0,0,0x77};
   uint8_t CMD58_TBL[] = {(CMD58|0x40),0,0,0,0,0x95};
   uint8_t CMD59ON_TBL[] = {(CMD59|0x40),0,0,0,0x01,0x95};
   uint8_t CMD59OFF_TBL[] = {(CMD59|0x40),0,0,0,0,0x91};
   uint8_t CMD16_TBL[] = {(CMD16|0x40),0,0,0x02,0,0x95}; // CMD 16 with fixed bloc size to 512
      
   /* Init variables */
	retry=0;
   response = (uint8_t)(0xFF);
   SD_isHC = 0;
   
   // Send 80 dummy clk cycles to wake the SD up
	for (ii = 0; ii < 10; ii++) 
	{
		Spi_SendByte((uint8_t)(0xFF)); // 8 clk		
	}
      
	// Send CMD0 to reset and put SD card in SPI mode.  It should respond with 0x01 if everything is ok.   
 	do
 	{  
      SD_Send_CMD(CMD0_TBL, &SD_CMD_RESP, RTYPE_R1);   
 	   if(retry++ > RETRY_TIMEOUT)
      {         
         PRINT("Unsupported or no SD card\n");
         return IRC_FAILURE; //time out
      }
 	} while(SD_CMD_RESP.RspR1 != IN_IDLE_STATE); //wait for card to inter idle state
   SD_PRINTF("\nSD reseted in %d retries.", retry);   
 	   
   // Send CMD8 to expand the following CMDs for ver 2.0 and up SD
   SD_Send_CMD(CMD8_TBL, &SD_CMD_RESP, RTYPE_R3);
   if((SD_CMD_RESP.RspR1 & ILLEGAL_CMD) == ILLEGAL_CMD)
   {  
      SD_PRINT("\nSD card ver. 1.xx detected");
   }
   else
   {
      SD_PRINT("\nSD card ver. 2.xx detected");
   }
        
   SD_PRINTF("\nCMD8 R1= 0x%X", SD_CMD_RESP.RspR1);
   SD_PRINTF("\nCMD8 R7_byte3= 0x%X", SD_CMD_RESP.Rspbyte3);
   SD_PRINTF("\nCMD8 R7_byte3= 0x%X", SD_CMD_RESP.Rspbyte2);
   SD_PRINTF("\nCMD8 VHS= 0x%X", SD_CMD_RESP.Rspbyte1);
   SD_PRINTF("\nCMD8 CHCK_PAT= 0x%X", SD_CMD_RESP.Rspbyte0);
   SD_PRINT("\n");
   
   /* Reject the card if there is mismatch in supported voltage range or check pattern that card returns in response to CMD8 */   
   if(SD_CMD_RESP.Rspbyte1 != SD_HOST_VHS || SD_CMD_RESP.Rspbyte0 != SD_CHECK_PATTERN)
   {
      PRINT("Unsupported card\n");
      return IRC_FAILURE;
   }
   
   /* enable CRC needed for ACMD41; deafault - CRC disabled in SPI mode  */    
   SD_Send_CMD(CMD59ON_TBL, &SD_CMD_RESP, RTYPE_R1);   
   
   /* ***** Send ACMD41 to initialize the SD and pull it until it shows ready *******/
   retry = 0;	      
   do
   {   
      WAIT_US(1000);	   
      // Send CMD55 to tel SD that next CMD is application spec CMD
      SD_Send_CMD(CMD55_TBL, &SD_CMD_RESP, RTYPE_R1);
      // Send ACMD41 to initialize the SD
      SD_Send_CMD(ACMD41_TBL, &SD_CMD_RESP, RTYPE_R1);      
      if(retry++ > RETRY_TIMEOUT)
      {
         SD_PRINT("\nSD init error: op mode CMD Response timeout");         
         return IRC_FAILURE; //time out         
      }      
   }while((SD_CMD_RESP.RspR1 & IN_IDLE_STATE) == IN_IDLE_STATE);   
   SD_PRINTF("\nSD SPI mode activated in %d tries, response = 0x%X", retry, SD_CMD_RESP.RspR1);            
   SD_PRINT("\n");
   
   /* At this point we can disable CRC  */  
   SD_Send_CMD(CMD59OFF_TBL, &SD_CMD_RESP, RTYPE_R1);   
   
   /* Send CMD58 to get the CCS from the OCR register this tels us if the SD is HC or not*/
   SD_Send_CMD(CMD58_TBL, &SD_CMD_RESP, RTYPE_R3);
   if((SD_CMD_RESP.Rspbyte3 & SD_CCS_BIT) == SD_CCS_BIT)
   {
      SD_isHC = 1;
      SD_PRINT("\nSD card is SDHC");
   }
   else
   {
      SD_isHC = 0;
   }
   SD_PRINTF("\nCMD58 R1= 0x%X", SD_CMD_RESP.RspR1);
   SD_PRINTF("\nCMD58 R7_byte3= 0x%X", SD_CMD_RESP.Rspbyte3);
   SD_PRINTF("\nCMD58 R7_byte2= 0x%X", SD_CMD_RESP.Rspbyte2);
   SD_PRINTF("\nCMD58 R7_byte1= 0x%X", SD_CMD_RESP.Rspbyte1);
   SD_PRINTF("\nCMD58 R7_byte0= 0x%X", SD_CMD_RESP.Rspbyte0);
   
   SD_PRINT("\n");     
	
   /* set block size to 512 */
   SD_Send_CMD(CMD16_TBL, &SD_CMD_RESP, RTYPE_R1);   
   SD_PRINTF("\nCMD16 R1 = 0x%X\n", SD_CMD_RESP.RspR1);
   	
	return IRC_SUCCESS; //normal return
}
/****************************************************************************
* Function to send CMD to SD via SPI
*
/****************************************************************************/
IRC_Status SD_Send_CMD(uint8_t SD_CMD_TBL[], t_SD_CMD_RESP *SD_CMD_RESP, t_RTYPE R_TYPE)
{
   uint16_t retry;
   uint8_t jj;
       
   retry=0;
   SD_CMD_RESP->RspR1 = 0xFF;
      
   // for(jj=0;jj<6;jj++)
   // {
      // PRINTF("\nSD_CMD_TBL[%d] = 0x%X", jj, (uint8_t)(SD_CMD_TBL[jj]));      
   // }
   // PRINT("\n");
   
   SD_CS_ASSERT(); // Activate CS     
   for(jj=0;jj<6;jj++)
   {
      Spi_SendByte(SD_CMD_TBL[jj]);
   }
   
   do
   {
   	if(retry++ > RETRY_TIMEOUT) 
   	{   		
   		//break; //time out error
         return IRC_FAILURE; // response timed out
   	}            
	}while((SD_CMD_RESP->RspR1 = Spi_RcvByte()) == 0xff); //wait response  
   if(R_TYPE==RTYPE_R3) 
   {
      SD_CMD_RESP->Rspbyte3 = Spi_RcvByte();      
      SD_CMD_RESP->Rspbyte2 = Spi_RcvByte();      
      SD_CMD_RESP->Rspbyte1 = Spi_RcvByte();      
      SD_CMD_RESP->Rspbyte0 = Spi_RcvByte();      
   }
   SD_CS_DEASSERT();	// Déactivate CS
	Spi_RcvByte(); //extrat 8 clk	
   
   return IRC_SUCCESS; //all good
}

//******************************************************************
//Function: to read a single block from SD card
//Arguments: none
//return: uint8_t; will be 0 if no error,
// otherwise the response byte will be sent
//******************************************************************
IRC_Status SD_readSingleBlock(uint8_t *Buffer, uint32_t startBlock)
{
	uint16_t i, j, retry=0;
	uint8_t response = (uint8_t)(0xFF);
	int NumBytesRcv = 0, NumBytesTxd = 0;
	uint16_t Control;
   uint8_t CMD17_TBL[6];
		   
   /* Build the CMD17, read CMD, depending on the block's address to read and if the card is SDHC or standard SD*/  
  CMD17_TBL[0] = CMD17|0x40; //CMD + start bit
  CMD17_TBL[5] = 0x95; //Fake CRC
  if(SD_isHC == 1)
  {
      // If SDHC ,addressing is direct
      CMD17_TBL[1] = startBlock>>24;
      CMD17_TBL[2] = startBlock>>16;
      CMD17_TBL[3] = startBlock>>8;
      CMD17_TBL[4] = startBlock;
   }
   else
   {  
      // If non SDHC ,addressing is multiple of block size  = 512
      CMD17_TBL[1] = (startBlock<<9)>>24;
      CMD17_TBL[2] = (startBlock<<9)>>16;
      CMD17_TBL[3] = (startBlock<<9)>>8;
      CMD17_TBL[4] = (startBlock<<9);
   }
		
	// Get the offset
//    	XTime_SetTime(0);
//    	XTime_GetTime(&start_tick);
//    	XTime_GetTime(&end_tick);
//    	XTime_GetTime(&start_tick);
//    	XTime_GetTime(&end_tick);   
//    	offset = end_tick-start_tick;
// 	// Measuring
//    	XTime_GetTime(&start_tick);
	//response = SD_sendCommand(CMD17, startBlock); //read a Block command
   //response = SD_sendCommand(CMD17, startBlock<<9); //read a Block command
   SD_Send_CMD(CMD17_TBL, &SD_CMD_RESP, RTYPE_R1);
// 	XTime_GetTime(&end_tick);	
//    	etime_us1 = (end_tick - start_tick - offset) * 1000000/ XPAR_CPU_PPC405_CORE_CLOCK_FREQ_HZ;
   	
	/* Check if SD response with no error to the read cmd*/
	if(SD_CMD_RESP.RspR1 != 0x00) 
  	return IRC_FAILURE;
  
   	
//   	XTime_SetTime(0);
//    	XTime_GetTime(&start_tick);
//    	XTime_GetTime(&end_tick);
//    	XTime_GetTime(&start_tick);
//    	XTime_GetTime(&end_tick);   
//    	offset = end_tick-start_tick;
//    	// Measuring
//   	XTime_GetTime(&start_tick);
  	SD_CS_ASSERT();
	do{
	if(retry++ > 0xfffe){
		SD_CS_DEASSERT();
		return IRC_FAILURE; //time out error
	 }	
	}while(Spi_RcvByte() != 0xfe); //wait for start block token 0xfe (0x11111110)
// 	XTime_GetTime(&end_tick);	
//    	etime_us2 = (end_tick - start_tick - offset) * 1000000/ XPAR_CPU_PPC405_CORE_CLOCK_FREQ_HZ;

// 	XTime_SetTime(0);
//    	XTime_GetTime(&start_tick);
//    	XTime_GetTime(&end_tick);
//    	XTime_GetTime(&start_tick);
//    	XTime_GetTime(&end_tick);   
//    	offset = end_tick-start_tick;
//    	// Measuring
// 	XTime_GetTime(&start_tick);
	
  	for(i=0; i<BLOCK_SIZE; i++){		  	

	 	// Send in order to receive
		XIo_Out8((XSPI_BASEADDRS) + XSP_DTR_OFFSET, (uint8_t)(0XFF));	
    	                           		
		 //Enable the device to start tx
 		Control = (XIo_In16(XSPI_BASEADDRS + XSP_CR_OFFSET) & ~XSP_CR_TRANS_INHIBIT_MASK) | XSP_CR_ENABLE_MASK; 	
		XIo_Out16(XSPI_BASEADDRS + XSP_CR_OFFSET, Control);
		
		//Wait for tx to finish
		while (!(XIo_In8(XSPI_BASEADDRS + XSP_SR_OFFSET) & XSP_SR_TX_EMPTY_MASK));
		
		//Read Rcvd data			
		Buffer[i] = XIo_In8((XSPI_BASEADDRS) +	XSP_DRR_OFFSET);
 	}

	//receive incoming CRC (16-bit), CRC is ignored here	
	Spi_RcvByte();
	Spi_RcvByte();
	//Extra 8 clk
	Spi_RcvByte();
	
	SD_CS_DEASSERT();
// 	XTime_GetTime(&end_tick);	
//    	etime_us3 = (end_tick - start_tick - offset) * 1000000/ XPAR_CPU_PPC405_CORE_CLOCK_FREQ_HZ;
   	
//    	xil_printf("Rd_cmd = %d us\n\r", etime_us1);
//    	xil_printf("PollingStart = %d us\n\r", etime_us2);          	
//    	xil_printf("RdingData = %d us\n\r", etime_us3);          	          	
   	
	return IRC_SUCCESS;
}

//***************************************************************************
// Ajouté par ENO (2 juin 2010) 
//Function: fonction d'initialisation du SPI et de la SD_card 
//Arguments: none
//return: IRC_FAILURE si echec sinon IRC_SUCCESS,
//****************************************************************************

IRC_Status SD_moduleInit()
{
	   
	if(spi_init())   // laissé tel quel pour eviter pb d'interpretation de 0 ou 1
	{		
		return IRC_FAILURE;
	}
	
	// Initialize the SD card 	
	if(SD_init())
	{
		PRINT("SD Card Init failed!\n");
		return IRC_FAILURE;
	}
	else
	{
		PRINT("SD Card Init successful!\n");
	}
	
	return IRC_SUCCESS;
}
