/* $Id$ */
/*****************************************************************************
*
*       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
*       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
*       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
*       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
*       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*       FOR A PARTICULAR PURPOSE.
*
*       (c) Copyright 2002-2007 Xilinx Inc.
*       All rights reserved.
*
*****************************************************************************/
/****************************************************************************/
/**
*
* @file xuartlite.h
*
* This component contains the implementation of the XUartLite component which is
* the driver for the Xilinx UART Lite device. This UART is a minimal hardware
* implementation with minimal features.  Most of the features, including baud
* rate, parity, and number of data bits are only configurable when the hardware
* device is built, rather than at run time by software.
*
* The device has 16 byte transmit and receive FIFOs and supports interrupts.
* The device does not have any way to disable the receiver such that the
* receive FIFO may contain unwanted data.  The FIFOs are not flushed when the
* driver is initialized, but a function is provided to allow the user to
* reset the FIFOs if desired.
*
* The driver defaults to no interrupts at initialization such that interrupts
* must be enabled if desired. An interrupt is generated when the transmit FIFO
* transitions from having data to being empty or when any data is contained in
* the receive FIFO.
*
* In order to use interrupts, it's necessary for the user to connect the driver
* interrupt handler, XUartLite_InterruptHandler, to the interrupt system of the
* application.  This function does not save and restore the processor context
* such that the user must provide it.  Send and receive handlers may be set for
* the driver such that the handlers are called when transmit and receive
* interrupts occur.  The handlers are called from interrupt context and are
* designed to allow application specific processing to be performed.
*
* The functions, XUartLite_Send and XUartLite_Recv, are provided in the driver
* to allow data to be sent and received. They are designed to be used in
* polled or interrupt modes.
*
* The driver provides a status for each received byte indicating any parity
* frame or overrun error. The driver provides statistics which allow visibility
* into these errors.
*
* <b>Initialization & Configuration</b>
*
* The XUartLite_Config structure is used by the driver to configure itself. This
* configuration structure is typically created by the tool-chain based on HW
* build properties.
*
* To support multiple runtime loading and initialization strategies employed
* by various operating systems, the driver instance can be initialized in one
* of the following ways:
*
*   - XUartLite_Initialize(InstancePtr, DeviceId) - The driver looks up its own
*     configuration structure created by the tool-chain based on an ID provided
*     by the tool-chain.
*
*   - XUartLite_CfgInitialize(InstancePtr, CfgPtr, EffectiveAddr) - Uses a
*     configuration structure provided by the caller. If running in a system
*     with address translation, the provided virtual memory base address
*     replaces the physical address present in the configuration structure.
*
* <b>RTOS Independence</b>
*
* This driver is intended to be RTOS and processor independent.  It works
* with physical addresses only.  Any needs for dynamic memory management,
* threads or thread mutual exclusion, virtual memory, or cache control must
* be satisfied by the layer above this driver.
*
* @note
*
* The driver is partitioned such that a minimal implementation may be used.
* More features require additional files to be linked in.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a ecm  08/31/01 First release
* 1.00b jhl  02/21/02 Repartitioned the driver for smaller files
* 1.01a jvb  12/14/05 I separated dependency on the static config table and
*                     xparameters.h from the driver initialization by moving
*                     _Initialize and _LookupConfig to _sinit.c. I also added
*                     the new _CfgInitialize routine.
* 1.02a rpm  02/14/07 Added check for outstanding transmission before
*                     calling the send callback (avoids extraneous
*                     callback invocations) in interrupt service routine.
* 1.12a mta  03/31/07 Updated to new coding conventions
* </pre>
*
*****************************************************************************/

#ifndef XUARTLITE_H /* prevent circular inclusions */
#define XUARTLITE_H /* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/

#include "xbasic_types.h"
#include "xstatus.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/**
 * Callback function.  The first argument is a callback reference passed in by
 * the upper layer when setting the callback functions, and passed back to the
 * upper layer when the callback is invoked.
 * The second argument is the ByteCount which is the number of bytes that
 * actually moved from/to the buffer provided in the _Send/_Receive call.
 */
typedef void (*XUartLite_Handler)(void *CallBackRef, unsigned int ByteCount);

/**
 * Statistics for the XUartLite driver
 */
typedef struct {
	u32 TransmitInterrupts;		/**< Number of transmit interrupts */
	u32 ReceiveInterrupts;		/**< Number of receive interrupts */
	u32 CharactersTransmitted;	/**< Number of characters transmitted */
	u32 CharactersReceived;		/**< Number of characters received */
	u32 ReceiveOverrunErrors;	/**< Number of receive overruns */
	u32 ReceiveParityErrors;	/**< Number of receive parity errors */
	u32 ReceiveFramingErrors;	/**< Number of receive framing errors */
} XUartLite_Stats;

/**
 * The following data type is used to manage the buffers that are handled
 * when sending and receiving data in the interrupt mode. It is intended
 * for internal use only.
 */
typedef struct {
	u8 *NextBytePtr;
	unsigned int RequestedBytes;
	unsigned int RemainingBytes;
} XUartLite_Buffer;

/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;		/**< Unique ID  of device */
	u32 RegBaseAddr;	/**< Register base address */
	u32 BaudRate;		/**< Fixed baud rate */
	u8  UseParity;		/**< Parity generator enabled when TRUE */
	u8  ParityOdd;		/**< Parity generated is odd when TRUE, even
					when FALSE */
	u8  DataBits;		/**< Fixed data bits */
} XUartLite_Config;

/**
 * The XUartLite driver instance data. The user is required to allocate a
 * variable of this type for every UART Lite device in the system. A pointer
 * to a variable of this type is then passed to the driver API functions.
 */
typedef struct {
	XUartLite_Stats Stats;		/* Component Statistics */
	u32 RegBaseAddress;		/* Base address of registers */
	u32 IsReady;			/* Device is initialized and ready */

	XUartLite_Buffer SendBuffer;
	XUartLite_Buffer ReceiveBuffer;

	XUartLite_Handler RecvHandler;
	void *RecvCallBackRef;		/* Callback ref for recv handler */
	XUartLite_Handler SendHandler;
	void *SendCallBackRef;		/* Callback ref for send handler */
} XUartLite;


/***************** Macros (Inline Functions) Definitions ********************/


/************************** Function Prototypes *****************************/

/*
 * Initialization functions in xuartlite_sinit.c
 */
int XUartLite_Initialize(XUartLite *InstancePtr, u16 DeviceId);
XUartLite_Config *XUartLite_LookupConfig(u16 DeviceId);

/*
 * Required functions, in file xuart.c
 */
int XUartLite_CfgInitialize(XUartLite *InstancePtr,
				XUartLite_Config *Config,
				u32 EffectiveAddr);

void XUartLite_ResetFifos(XUartLite *InstancePtr);

unsigned int XUartLite_Send(XUartLite *InstancePtr, u8 *DataBufferPtr,
				unsigned int NumBytes);
unsigned int XUartLite_Recv(XUartLite *InstancePtr, u8 *DataBufferPtr,
				unsigned int NumBytes);

int XUartLite_IsSending(XUartLite *InstancePtr);

/*
 * Functions for statistics, in file xuartlite_stats.c
 */
void XUartLite_GetStats(XUartLite *InstancePtr, XUartLite_Stats *StatsPtr);
void XUartLite_ClearStats(XUartLite *InstancePtr);

/*
 * Functions for self-test, in file xuartlite_selftest.c
 */
int XUartLite_SelfTest(XUartLite *InstancePtr);

/*
 * Functions for interrupts, in file xuartlite_intr.c
 */
void XUartLite_EnableInterrupt(XUartLite *InstancePtr);
void XUartLite_DisableInterrupt(XUartLite *InstancePtr);

void XUartLite_SetRecvHandler(XUartLite *InstancePtr, XUartLite_Handler FuncPtr,
				void *CallBackRef);
void XUartLite_SetSendHandler(XUartLite *InstancePtr, XUartLite_Handler FuncPtr,
				void *CallBackRef);

void XUartLite_InterruptHandler(XUartLite *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif			/* end of protection macro */

