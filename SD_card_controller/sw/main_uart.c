/***************************** Include Files *********************************/

#include "xparameters.h"	/* XPAR parameters */
#include "xcache_l.h"
#include "xtime_l.h"
#include "common.h"
#include "sd_routines.h"
#include "spi_routines.h"
#include "string.h"


/*****************************************************************************/
/**
*
* Main function
*
*
******************************************************************************/
int main(void)
{
	//Enable the PPC cache.	
	XCache_EnableICache(0x00000001);
   	XCache_EnableDCache(0x00000001);
   	
	uint32_t Count;
	uint8_t udata[5];	
	uint16_t ii;
	uint32_t blockNumb;
	uint8_t buffer[BUFFER_SIZE]; 	
 	
	   		
	//clears the screen
   	ClearScreen();	
	
	/* Init SPI device & driver */
	INFOMSGLN("Initializing SPI device...");   			
	if(spi_init())
	{
		INFOMSG("failed!");
		return 1;
	}else{
		INFOMSG("OK.");
	}
	
	/* Initialize the SD card */
	INFOMSGLN("Initializing SD card...");		
	if(SD_init()){
		INFOMSG("failed!");
		return 1;
	}else{
		INFOMSG("OK.");
	}
	
	while(1){
	INFOMSGLN("Enter the block number to read (0000-9999): ");
	ii = 0;
	do{		
		udata[ii] = inbyte();
		outbyte(udata[ii]);
		ii++;
	}while(ii<4);
	blockNumb = (uint32_t)(atoi(udata));
	INFOMSG("");
 	/* Reading a single block */
	INFOMSG("reading single block %d.", blockNumb);		   		   	   	   	   	
   	if(SD_readSingleBlock(buffer, blockNumb)) INFOMSG("SD block read failed.");
   	
	/* Printf entire block*/
	for(Count = 0; Count < BLOCK_SIZE; Count++) INFOMSGLN("%d ", buffer[Count]);				
   	
	if (!blockNumb){
		INFOMSG("\n");   	
		INFOMSGLN("1stPart#: %d %d %d %d ", buffer[457], buffer[456], buffer[455], buffer[454]);
	}

   	INFOMSG("");   	
    INFOMSG("done!");
	}
        
	return 0;
}
