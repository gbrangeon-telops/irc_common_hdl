/*-------------------------------------------------------------------------------------------------
 * Copyright (c) Telops Inc. 2008
 * 
 * File: serdes.h
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
#ifndef SERDES_H
#define SERDES_H

/**
 * @file serdes.h
 * Main header file for the high level SERDES driver.
*/

/*-------------------------------------------------------------------------------------------------
// Includes
-------------------------------------------------------------------------------------------------*/
#include "serdes_l.h"            // Low level device driver
#include <stdint.h>
#include <stdbool.h>

/*-------------------------------------------------------------------------------------------------
// Structures
-------------------------------------------------------------------------------------------------*/
/**
 * @struct SerdesInst_t
 * Structure which contains the internal status of the Serdes "Object" Instance.
*/
typedef struct {
   /* instance configuration parameters */ 
   
	uint32_t BaseAddr;               //!< The physical address map of the serdes core refered to by this instance.	              
	uint32_t RdOccupancyTrigLevel;   //!< Specifies if hardware interrupt should be triggered when RdOccupancyTrigLevel is reached.
	bool RdOccupancyIntrEn;          //!< Specifies if hardware interrupt should be triggered when RdOccupancyTrigLevel is reached.
	bool WrEmptyIntrEn;              //!< Specifies if hardware interrupt should be triggered when write FIFO is empty.
	bool LoopbackEn;                 //!< Specifies if the interface is in hardware loopback mode for testing purposes.
	uint32_t ClockDiv;               //!< Specifies the rate of the output serializing clock.
	
	/* instance status parameters */
   bool RdOccupancyReached;         //!< Indicates that the read FIFO is full.
   bool RdFifoOverRun;              //!< Indicates that the read FIFO has busted.
	bool WrEmpty;                    //!< Indicates that the write FIFO is empty.
} SerdesInst_t;

/*-------------------------------------------------------------------------------------------------
// Function prototypes
-------------------------------------------------------------------------------------------------*/
/**
 * Initialize a SERDES instance.
 *
 * @param   SerdesInstance is a pointer to the SERDES instance to intialize.
 * @return  Returns 0 if accessing the physical serdes instance was initialized.
 *          Returns 1 on error
*/
 
uint32_t SerdesInit(SerdesInst_t *SerdesInstance);

/**
 * Get the remaining write vacancy for a SERDES instance's write FIFO.
 *
 * @param   SerdesInstance is a pointer to the SERDES instance to check.
 * @return  The number of remaining uint32_t data which can still be written.
*/
 
uint32_t SerdesWrVacancy(SerdesInst_t *SerdesInstance);

/**
 * Get the current read vacancy for a SERDES instance's read FIFO.
 *
 * @param   SerdesInstance is a pointer to the refered SERDES instance.
 * @return  The number of uint32_t data which must be read from the instance.
*/
 
uint32_t SerdesRdOccupancy(SerdesInst_t *SerdesInstance);

/**
 * Write data for transmission by a SERDES instance.
 *
 * @param   SerdesInstance is a pointer to the refered SERDES instance.
 * @param   buf is a pointer to the data to be transmitted.
 * @param   Count is the number of uint32_t words to transmit.
 * @return  Status is the result of status checking.
*/
 
void SerdesWriteBuf(SerdesInst_t *SerdesInstance, uint32_t *buf, uint32_t Count);

/**
 * Read received data from a SERDES instance.
 *
 * @param   SerdesInstance is a pointer to the refered SERDES instance.
 * @param   buf is a pointer to where we want to copy the RX data to.
 * @param   Count is the number of uint32_t words to retreive.
 * @return  void.
*/
 
void SerdesReadBuf(SerdesInst_t *SerdesInstance, uint32_t *buf, uint32_t Count);

/**
 * Default SerDes Interupt handler (currently not working and unused).
 *
 * @param   CallbackRef is a pointer to the callback instance
 * @return  void.
*/
void SerDesHandler(void *CallbackRef);

#endif // SERDES_H

/*-------------------------------------------------------------------------------------------------
 * EOF
-------------------------------------------------------------------------------------------------*/
