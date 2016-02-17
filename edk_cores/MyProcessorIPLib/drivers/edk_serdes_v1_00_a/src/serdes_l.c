/*-------------------------------------------------------------------------------------------------
 * Copyright (c) Telops Inc. 2008
 * 
 * File: serdes_l.c
 * Use: Low level device driver for serdes core
 * Author: Olivier Bourgois
 * 
 * $Revision$
 * $Author$
 * $LastChangedDate$
 * 
 * Status: Stable
 * 
-------------------------------------------------------------------------------------------------*/
/**
 * @file serdes_l.c
 * function definitions for low level SERDES driver.
*/

#include "serdes_l.h"
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

/*-------------------------------------------------------------------------------------------------
 * Function Definitions
-------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------------------------
 * Enable all possible interrupts from SERDES device
-------------------------------------------------------------------------------------------------*/
void SerdesEnableInterrupt(void * baseaddr_p)
{
  uint32_t baseaddr;
  baseaddr = (uint32_t) baseaddr_p;

  // Enable all interrupt source from user logic.
  SerdesWriteReg(baseaddr, SERDES_INTR_IER_OFFSET, 0x00000001);

  // Enable all possible interrupt sources from device.
  SerdesWriteReg(baseaddr, SERDES_INTR_DIER_OFFSET,
    INTR_TERR_MASK
    | INTR_DPTO_MASK
    | INTR_IPIR_MASK
    | INTR_RFDL_MASK
    | INTR_WFDL_MASK
    );

  // Set global interrupt enable.
  SerdesWriteReg(baseaddr, SERDES_INTR_DGIER_OFFSET, INTR_GIE_MASK);
}

/*-------------------------------------------------------------------------------------------------
 * Example interrupt controller handler for SERDES device
-------------------------------------------------------------------------------------------------*/
void SerdesIntrDefaultHandler(void * baseaddr_p)
{
  uint32_t baseaddr;
  uint32_t IntrStatus;
  uint32_t IpStatus;

  baseaddr = (uint32_t) baseaddr_p;

  // Get status from Device Interrupt Status Register.
  IntrStatus = SerdesReadReg(baseaddr, SERDES_INTR_DISR_OFFSET);

  xil_printf("Device Interrupt! DISR value : 0x%08x \n\r", IntrStatus);

  // Verify the source of the interrupt is the user logic and clear the interrupt
  // source by toggle write baca to the IP ISR register.
  if ( (IntrStatus & INTR_IPIR_MASK) == INTR_IPIR_MASK )
  {
    xil_printf("User logic interrupt! \n\r");
    IpStatus = SerdesReadReg(baseaddr, SERDES_INTR_ISR_OFFSET);
    SerdesWriteReg(baseaddr, SERDES_INTR_ISR_OFFSET, IpStatus);
  }

}

/*-------------------------------------------------------------------------------------------------
 * EOF
-------------------------------------------------------------------------------------------------*/
