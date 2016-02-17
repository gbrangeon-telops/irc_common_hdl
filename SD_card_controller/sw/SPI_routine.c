/****************************************************************************
*  Telops Inc.                                                              *
*  Projet: common                                                           * 
*************************************************************************** *
*                                                                           *
*  Author(s)  : Khalid Bensadek                                             *
*                                                                           *
*                                                                           *
*****************************************************************************/

/********************************************************************
		SPI device init and confid
********************************************************************/
/***************************** Include Files **********************************/
#include "xspi_l.h"
#include "spi_routines.h"

/************************** Constant Definitions ******************************/



/************************** Variable Definitions *****************************/
//static XSpi  SpiInstance;	 /* The instance of the SPI device */


/*****************************************************************************
 spi_init: A function that configures the SPI module
 Parmetres : void
 Return : 0 when done  
*****************************************************************************/
uint32_t spi_init()
{
	uint16_t Control;
	
	
	/*
	 * Set up the device options: master mode and manual mode
	 */
	Control = XIo_In16(XSPI_BASEADDRS + XSP_CR_OFFSET);
	Control |= (XSP_CR_MANUAL_SS_MASK | XSP_CR_MASTER_MODE_MASK);
	XIo_Out16(XSPI_BASEADDRS + XSP_CR_OFFSET, Control);
	
	
	return 0;	
}

/*****************************************************************************
 Spi_SendByte: A function that uses a low level Xspi drivers to send a byte over
 			spi port.
 Parmetres : Byte to be sent over spi.
 Return : void
 
 Note: Xspi HW should be bluilt without the builting FIFO
*****************************************************************************/
void Spi_SendByte(uint8_t DataByte)
{	
	uint16_t Control;
	
	// Send a byte
	XIo_Out8((XSPI_BASEADDRS) + XSP_DTR_OFFSET, DataByte);	
                               		
	 //Enable the device to start tx
 	Control = (XIo_In16(XSPI_BASEADDRS + XSP_CR_OFFSET) & ~XSP_CR_TRANS_INHIBIT_MASK) | XSP_CR_ENABLE_MASK; 	
	XIo_Out16(XSPI_BASEADDRS + XSP_CR_OFFSET, Control);
	
	//Wait for tx to finish
	while (!(XIo_In8(XSPI_BASEADDRS + XSP_SR_OFFSET) & XSP_SR_TX_EMPTY_MASK));
	
	//Do a read to clear the DDR register
	XIo_In8((XSPI_BASEADDRS) +	XSP_DRR_OFFSET);		
	//return 0;
}

/***************************************************************************** 
 Spi_RcvByte: A function that uses a low level Xspi drivers to receive a byte 
 				from spi port
 Parmetres : void
 Return : received byte
*****************************************************************************/
uint8_t Spi_RcvByte()
{
	uint8_t DataByte;
	uint16_t Control;
	
	// Send in order to receive
	XIo_Out8((XSPI_BASEADDRS) + XSP_DTR_OFFSET, (uint8_t)(0XFF));	
                               		
	 //Enable the device to start tx
 	Control = (XIo_In16(XSPI_BASEADDRS + XSP_CR_OFFSET) & ~XSP_CR_TRANS_INHIBIT_MASK) | XSP_CR_ENABLE_MASK; 	
	XIo_Out16(XSPI_BASEADDRS + XSP_CR_OFFSET, Control);
	
	//Wait for tx to finish
	while (!(XIo_In8(XSPI_BASEADDRS + XSP_SR_OFFSET) & XSP_SR_TX_EMPTY_MASK));
	
	//Read Rcvd data	
	DataByte = XIo_In8((XSPI_BASEADDRS) +	XSP_DRR_OFFSET);
	
	return DataByte;
}
