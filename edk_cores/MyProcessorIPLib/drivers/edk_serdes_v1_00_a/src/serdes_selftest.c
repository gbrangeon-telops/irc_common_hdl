/*-------------------------------------------------------------------------------------------------
 * Copyright (c) Telops Inc. 2008
 * 
 * File: serdes_selftest.c
 * Use: self-test functions for the serdes core.
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
#include "xparameters.h"
#include "xexception_l.h"
#include "xintc.h"
#define INTC_DEVICE_ID          XPAR_OPB_INTC_0_DEVICE_ID  //move elsewhere

#define STATUS_CHECK(Status)            \
    {                                   \
        if (Status != XST_SUCCESS)      \
        {                               \
            xil_printf("FAILURE Code: %d\n\r",Status); \
        }                               \
        else                            \
            xil_printf("SUCCESS\n\r"); \
    }

XStatus SerdesSelfTest(void *baseaddr_p)
{

   SerdesInst_t SerdesInstance;                 // the instance of the Serdes Core
   uint32_t RetVal;
   uint32_t WrBuf[16];
   uint32_t RdBuf[16]; 
   uint32_t i;

   // Assert the argument is non NULL
   XASSERT_NONVOID(baseaddr_p != XNULL);
	
	// Configure the Serdes;
	SerdesInstance.BaseAddr = (uint32_t) baseaddr_p;
   SerdesInstance.RdOccupancyTrigLevel = 0;     // we don't care about the trig level;
	SerdesInstance.RdOccupancyIntrEn = false;    // disable Read interrupts
	SerdesInstance.WrEmptyIntrEn = false;        // disable Write interrupts
	SerdesInstance.LoopbackEn = true ;           // put the interface in loopback
	SerdesInstance.ClockDiv = 4;                 // divide the clock somewhat
	
   RetVal = SerdesInit(&SerdesInstance);

   xil_printf("Serdes Loop Test...\n\r");
	WrBuf[0] = 0;
   while(1)
   {
      // increment the write buffer data and write it;
      for (i=1; i<16; i++)
         WrBuf[i]=WrBuf[0] + i;
      SerdesWriteBuf(&SerdesInstance, WrBuf, 16);
      WrBuf[0] = WrBuf[0] + 16;
		
      // read the read buffer data and print it;
      SerdesReadBuf(&SerdesInstance, RdBuf, 16);
      for (i=0; i<16; i++) 
         xil_printf("r: %d\n\r",RdBuf[i]);
   }
  return XST_SUCCESS;
}

// this function will be moved somewhere else eventually it is used to set up
// the interrupt controller given its instance
void Setup_Interrupts(XIntc *IntcInstance, SerdesInst_t *SerdesInstance)
{

   // initialize exception handling
   XExc_Init();  
   
   // Register the interrupt controller handler with the exception table
   XExc_RegisterHandler(XEXC_ID_NON_CRITICAL_INT,
                      (XExceptionHandler)XIntc_DeviceInterruptHandler,
                      (void*) 0);     

	// Register the serdes core interrupt handler in the vector table
   XIntc_RegisterHandler(XPAR_OPB_INTC_0_BASEADDR,
                       XPAR_OPB_INTC_0_EDK_SERDES_0_IP2INTC_IRPT_INTR,
                       (XInterruptHandler)SerDesHandler,
							  (void *)SerdesInstance);
									 
	// Enable serdes interrupt requests in the interrupt controller
   XIntc_mEnableIntr(XPAR_OPB_INTC_0_BASEADDR,
             XPAR_OPB_INTC_0_EDK_SERDES_0_IP2INTC_IRPT_INTR);
	
	// Start the interrupt controller
   XIntc_mMasterEnable(XPAR_OPB_INTC_0_BASEADDR);
	 
   // Enable non-critical exceptions
   XExc_mEnableExceptions(XEXC_NON_CRITICAL);       
}

// test the serdes in interrupt mode using loopback
void SerdesInterruptTest(void *baseaddr_p)
{
    XStatus Status;
	 static SerdesInst_t SerdesInstance;  // the instance of the Serdes Core
	 static XIntc IntcInstance;           // the instance of the Interrupt Controller
    uint32_t i,j;
	 uint32_t OutData = 0;
	 uint32_t RetVal;
	 uint32_t RdBuf[128];  // storage for a page of read data
	 uint32_t WrBuf[16];

    xil_printf("Serdes RX test for 128x512 data with Interrupts Enabled\r\n");
    xil_printf(".=OK != read fifo overrun\r\n");
      
    // Configure the Serdes;
	 SerdesInstance.BaseAddr = (uint32_t) baseaddr_p;
    SerdesInstance.RdOccupancyTrigLevel = 128;  // trigger when half full;
	 SerdesInstance.RdOccupancyIntrEn = true;    // enable Read interrupts
	 SerdesInstance.WrEmptyIntrEn = false;       // disable Write interrupts
	 SerdesInstance.LoopbackEn = true;           // put the interface in loopback
	 SerdesInstance.ClockDiv = 4;                // divide the clock somewhat
	
    RetVal = SerdesInit(&SerdesInstance);
	 
	 // Setup interrupt controller
	 IntcInstance.IsStarted=0;                   // for some reason a bug requires setting this field
	 Setup_Interrupts(&IntcInstance, &SerdesInstance);
	
    // run the test for 512 pages worth of data
	 i=0;
	 while(i < 512)
    {
	    // Data Reading process, triggered if read fifo occupancy level reached
       if (SerdesInstance.RdOccupancyReached)
       {
		    if (SerdesInstance.RdFifoOverRun)
             xil_printf("!");                          // we failed to read data fast enough
          else
          {			 
             SerdesReadBuf(&SerdesInstance, RdBuf, 128);   // read the read buffer data;
             xil_printf(".");                         // successfully read data
             i++;                                     // increment grabed page counter
          }
		 }
//		 xil_printf("i: %d WrVacancy: %d RdOccupancy: %d\n\r",
//		        i,
//		        SerdesWriteFIFOVacancy(SerdesInstance.BaseAddr),
//		 	     SerdesReadFIFOOccupancy(SerdesInstance.BaseAddr));
		 
		 // Data writing process, triggered when fifo is empty, refill by
		 // bursts of 16 writes
		 if (SerdesInstance.WrEmpty)
		 {
		    for (j=0; j<16; j++)
			 {
			   WrBuf[j] = OutData++;
			 }
			 SerdesWriteBuf(&SerdesInstance, WrBuf, 16);
		 }
    }
	 xil_printf("\n\r");

    // Disable PPC non-critical interrupts
    XExc_mDisableExceptions(XEXC_NON_CRITICAL);
    xil_printf("\r\nDisabling Interrupts\r\n");
}
