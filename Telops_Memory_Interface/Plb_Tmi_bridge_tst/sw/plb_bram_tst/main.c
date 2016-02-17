/***************************** Include Files *********************************/

#include "xparameters.h"	/* XPAR parameters */
#include "xcache_l.h"
#include "common.h"
#include "stdint.h"

/*****************************************************************************/
//#define MEM_BASEADDR (*((volatile uint32_t *) XPAR_PLBV46_TMI_BRIDGE_0_MEM0_BASEADDR))
#define MEM_BASEADDR 	XPAR_PLBV46_TMI_BRIDGE_0_MEM0_BASEADDR
#define MEM_DEPTH	256

#define READ		0
#define WRITE		1
#define DATA_CNT 	(0x4 * MEM_DEPTH)
#define LOOP_MAX	1024

/****************************************************************************/
/**
* Access memory
*
* @param    memory access type READ or WRITE
*
* @param    offset from base address
*
* @param    Data to be writen if any
*
* @return   Red data
*
* @note     None
*
*****************************************************************************/
uint32_t PLB_MEM_RW(uint32_t MEM_BASEADDRS, uint8_t AccessType, uint32_t offset, uint32_t WriteData)
{

    uint32_t Read_Data = 0;    
    uint32_t *pMem_Data = (uint32_t *)(MEM_BASEADDRS + offset);
        
    if ( AccessType == READ ) {
        Read_Data = *pMem_Data;
    }
    else if ( AccessType == WRITE ) {
        *pMem_Data = WriteData;        
    }
    
    return Read_Data;
}

/*****************************************************************************
 Memory test routine
 * @param : void
 * @return : void  
*****************************************************************************/
uint32_t MemeTest(void)

{
	   
	uint32_t index;
	uint32_t errors = 0; 	
	   		
	   	   	
	 /* Ramp test: increasing ramp*/
     DBGMSGLN("\nWriting Incrementing RAMP data...");
     for (index = 0; index < DATA_CNT; index+=4)
     {   
        PLB_MEM_RW(MEM_BASEADDR, WRITE, index, index );        
     }
    DBGMSG("DONE!");
    
    // Verify that the data was indeed written
    DBGMSGLN("\nReading back and Comparing data...");     
     for (index = 0; index < DATA_CNT; index+=4) 
     {        
        if (PLB_MEM_RW(MEM_BASEADDR, READ, index, 0) != index )
        {
            DBGMSG("\r\nRead/Write error at offset %x Read %x"
                 " expected %X", index, PLB_MEM_RW(MEM_BASEADDR, READ, index, 0), index);
            errors++;
            break;
        }
     }    
     
     DBGMSG("\r\n");
     
     /* Ramp test: decreasing ramp*/
     DBGMSGLN("\nWriting Decrementing RAMP data...");
     for (index = 0; index < DATA_CNT; index+=4) 
     {   
        PLB_MEM_RW(MEM_BASEADDR, WRITE, index, (DATA_CNT - index) );        
     }
    DBGMSG("DONE!");
    
    // Verify that the data was indeed written
    DBGMSGLN("\nReading back and Comparing data...");     
     for (index = 0; index < DATA_CNT; index+=4) 
     {        
        if (PLB_MEM_RW(MEM_BASEADDR, READ, index, 0) != (DATA_CNT - index) )
        {
            DBGMSG("\r\nRead/Write error at offset %x Read %x"
                 " expected %X", index, PLB_MEM_RW(MEM_BASEADDR, READ, index, 0), index);
            errors++;
            break;
        }
     }     
     DBGMSG("\r\n");    
    
    /* Data bus test 0xAAAAAAAA*/
     DBGMSGLN("\nWriting 0xAAAAAAAA data...");
     for (index = 0; index < DATA_CNT; index+=4)
     {   
        PLB_MEM_RW(MEM_BASEADDR, WRITE, index, 0xAAAAAAAA );        
     }
    DBGMSG("DONE!");
    
    // Verify that the data was indeed written
    DBGMSGLN("\nReading back and Comparing data...");     
     for (index = 0; index < DATA_CNT; index+=4) 
     {        
        if (PLB_MEM_RW(MEM_BASEADDR, READ, index, 0) != 0xAAAAAAAA )
        {
            DBGMSG("\r\nRead/Write error at offset %x Read %x"
                 " expected 0x55555555", index, PLB_MEM_RW(MEM_BASEADDR, READ, index, 0));
            errors++;
            break;
        }
     }    
     DBGMSG("\r\n"); 
     
     /* Data bus test 0x55555555*/
     DBGMSGLN("\nWriting 0x55555555 data...");
     for (index = 0; index < DATA_CNT; index+=4)
     {   
        PLB_MEM_RW(MEM_BASEADDR, WRITE, index, 0x55555555 );        
     }
    DBGMSG("DONE!");
    
    // Verify that the data was indeed written
    DBGMSGLN("\nReading back and Comparing data...");     
     for (index = 0; index < DATA_CNT; index+=4) 
     {        
        if (PLB_MEM_RW(MEM_BASEADDR, READ, index, 0) != 0x55555555 )
        {
            DBGMSG("\r\nRead/Write error at offset %x Read %x"
                 " expected 0x55555555", index, PLB_MEM_RW(MEM_BASEADDR, READ, index, 0));
            errors++;
            break;
        }
     }    
     DBGMSG("\r\n"); 
      
   	DBGMSG("%d erros. ", errors   	);
    DBGMSG("\ndone!");
    
    return errors;    
}

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
	
   	
   	uint32_t LoopIndex, ErrorsCount = 0;
   	
   	//clears the screen
   	ClearScreen();
   	
   	INFOMSG("--------------------------------");
   	INFOMSG("    PLB2BRAM bridge test:");
   	INFOMSG("--------------------------------");	
   	INFOMSG("Will write an incrementing ramp, a decrementing ramp, 0xAAAAAAAA and 0x55555555 on the whole memory");
   	INFOMSG("Curent iteration: ");
   	for (LoopIndex = 0; LoopIndex < LOOP_MAX; LoopIndex++)
   	{
		ErrorsCount += MemeTest();
		INFOMSGLN("\r%d", LoopIndex);
		if(ErrorsCount)break;
	}
	
	INFOMSG("\r\n");
	INFOMSG("%d test loops were completed with %d erros. ", LOOP_MAX, ErrorsCount);
	INFOMSG("done!");
	/* Disabling the PPC cache */
	XCache_DisableDCache();
   	XCache_DisableICache();
   	
	  
    
	return 0;
}
