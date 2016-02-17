/***************************** Include Files *********************************/

#include "xparameters.h"	/* XPAR parameters */
#include "xcache_l.h"
#include "xtime_l.h"
#include "common.h"
#include "sd_routines.h"
#include "spi_routines.h"
#include "string.h"
#include <stdint.h>


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
   
	uint32_t Status, jj;
	u32 Count;
	uint8_t buffer[BUFFER_SIZE]; 		
 	
	   		
	//clears the screen
   	ClearScreen();	
    	
	/* Init the R&W buffers */
	for (Count = 0; Count < BUFFER_SIZE; Count++) {
		buffer[Count] = 0;		
	}
	
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
	Status = SD_init();	
	if(Status){
		INFOMSG("failed!");
		return 1;
	}else{
		INFOMSG("OK.");
	}
	
	/* Fill the Tx buffer with a ramp test */
	for (Count = 0; Count < 512; Count++) {
		buffer[Count] = (uint8_t)(Count);		
	}
	
	/* Write a test ramp in a 512 byte single block */
	INFOMSG("Writing a ramp to a single block.");			
   	Status = SD_writeSingleBlock(buffer, 1001);	   	
   	if(Status)INFOMSG("SD block write failed.");
   	
   	/* Erase a single bloc */
//    	INFOMSGLN("Erasing SD card...");
//  	Status = SD_erase(1001,1);
//  	if(Status){INFOMSG("failed.");}else{INFOMSG("done.");}
	
	/* Clear R&W buffers */
	for (Count = 0; Count < BUFFER_SIZE; Count++) {
		buffer[Count] = 0;		
	}
		
 	/* Reading a single block */
	INFOMSG("reading single block 1001.");		
   	Status = SD_readSingleBlock(buffer, 1001);	   	   	   	   	
   	if(Status){
	   	INFOMSG("SD block read failed.");
   	}else{
	   	/* Printf entire block*/
		for(Count = 0; Count < BLOCK_SIZE; Count++) INFOMSGLN("%d ", buffer[Count]);				
   	}
   	 
   	INFOMSG("\n");
   	  	
   	/* Comparing data */
   	INFOMSGLN("Comparing block data...");				   	
   	for (Count = 0; Count < 512; Count++) {
		if (buffer[Count] != (uint8_t)(Count)) {
			INFOMSG("");
			INFOMSG("SD SPI R/W Error, Expeted: %d, Read: %d", (uint8_t)(Count), buffer[Count]);					
			return 1; //Exit the test as soon as an error is found.
		}
	}
	INFOMSG("success!");
	

   	
// 	/* Read multiple blocks in a row */
// 	INFOMSG("reading multiple blocks: 4 blocks .");			
//    	Status = SD_readMultipleBlock(buffer, 1001, 4);	   		   	
//    	if(Status) INFOMSG("SD multiple block read failed.");
   	   	
    INFOMSG("done!");
    
    /* Disabling the PPC cache */
	XCache_DisableDCache();
   	XCache_DisableICache();
    
    
	return 0;
}
