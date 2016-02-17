/*-------------------------------------------------------------------------------------------------
 * Copyright (c) Telops Inc. 2008
 * 
 * File: serdes.c
 * Use: Higher level device driver for serdes core
 * Author: Olivier Bourgois
 * 
 * $Revision$
 * $Author$
 * $LastChangedDate$
 * 
 * Status: Stable
 * 
-------------------------------------------------------------------------------------------------*/
#include "serdes.h"
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

/**
 * @file serdes.c
 * Implementation of the high level SERDES driver.
*/

/*-------------------------------------------------------------------------------------------------
 * This function Initializes the serdes
-------------------------------------------------------------------------------------------------*/
uint32_t SerdesInit(SerdesInst_t *SerdesInstance)
{
   // set defaults
   SerdesReset(SerdesInstance->BaseAddr);
   SerdesResetWriteFIFO(SerdesInstance->BaseAddr);
   SerdesResetReadFIFO(SerdesInstance->BaseAddr);
   SerdesWriteCtrlReg((SerdesInstance->BaseAddr),
	  (SerdesInstance->RdOccupancyIntrEn << 31) 
	  | (SerdesInstance->WrEmptyIntrEn << 29)
     | (SerdesInstance->LoopbackEn << 28)	  
	  | (SerdesInstance->ClockDiv << 16) 
	  | (SerdesInstance->RdOccupancyTrigLevel));
	  
	// initialize Status stuff
	SerdesInstance->RdOccupancyReached = false;
	SerdesInstance->RdFifoOverRun = false;
	SerdesInstance->WrEmpty = true;
	 
	// validate that the core is responding 
   if (SerdesReadMIR(SerdesInstance->BaseAddr == 0x30220301))
      return(0);
   return (1);
}

/*-------------------------------------------------------------------------------------------------
 * This function writes data to serdes
 * blocking if fifo is full
-------------------------------------------------------------------------------------------------*/
void SerdesWriteBuf(SerdesInst_t *SerdesInstance, uint32_t *buf, uint32_t Count)
{
    uint32_t i;

    for (i=0;i<Count;i++)
    {
       while (SerdesWriteFIFOFull(SerdesInstance->BaseAddr));           // block until we have some fifo room
       SerdesWriteToFIFO(SerdesInstance->BaseAddr, buf[i]);
	 }
}

/*-------------------------------------------------------------------------------------------------
 * This function reads data from serdes
 * blocking if fifo is empty
-------------------------------------------------------------------------------------------------*/
void SerdesReadBuf(SerdesInst_t *SerdesInstance, uint32_t *buf, uint32_t Count)
{
    uint32_t i;
    
    for (i=0;i<Count; i++)
    {
       while (SerdesReadFIFOEmpty(SerdesInstance->BaseAddr));          // block until we have some data
       buf[i]= SerdesReadFromFIFO(SerdesInstance->BaseAddr);
    }
}

/*-------------------------------------------------------------------------------------------------
 * This function returns the current level of the write FIFO
-------------------------------------------------------------------------------------------------*/
uint32_t SerdesWrVacancy(SerdesInst_t *SerdesInstance)
{
    return (uint32_t) SerdesWriteFIFOVacancy(SerdesInstance->BaseAddr);
}

/*-------------------------------------------------------------------------------------------------
 * This function returns the current level of the read FIFO
-------------------------------------------------------------------------------------------------*/
uint32_t SerdesRdOccupancy(SerdesInst_t *SerdesInstance)
{
    return (uint32_t) SerdesReadFIFOOccupancy(SerdesInstance->BaseAddr);
}

/*-------------------------------------------------------------------------------------------------
 * This function is the interrupt handler
 * currently not debuged we are using polling for SERDES
-------------------------------------------------------------------------------------------------*/
void SerDesHandler(void *CallbackRef)
{
  SerdesInst_t *SerdesInstance;

  SerdesInstance = (SerdesInst_t*) CallbackRef;
  xil_printf("int!\n\r");
  
  if (SerdesReadFIFOOccupancy(SerdesInstance->BaseAddr) >= SerdesInstance->RdOccupancyTrigLevel)
     SerdesInstance->RdOccupancyReached = true;
  else
     SerdesInstance->RdOccupancyReached = false;
	  
  if (SerdesWriteFIFOVacancy(SerdesInstance->BaseAddr) >= 512)
     SerdesInstance->WrEmpty = true;
  else
     SerdesInstance->WrEmpty = false;
	  
  SerdesInstance->RdFifoOverRun = false;
}

/*-------------------------------------------------------------------------------------------------
 * EOF
-------------------------------------------------------------------------------------------------*/
