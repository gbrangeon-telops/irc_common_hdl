/*-------------------------------------------------------------------------------------------------
 * Copyright (c) Telops Inc. 2008
 * 
 * File: serdes_l.h
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
#ifndef SERDES_L_H
#define SERDES_L_H

/**
 * @file serdes_l.h
 * Main header file for the low level SERDES driver.
*/

/*-------------------------------------------------------------------------------------------------
 * Include Files
-------------------------------------------------------------------------------------------------*/
#include "xbasic_types.h"
#include "xstatus.h"
#include "xio.h"
#include <stdint.h>
#include <stdbool.h>

/*-------------------------------------------------------------------------------------------------
 * Defines
-------------------------------------------------------------------------------------------------*/

/** User slave registers offset */ 
#define SERDES_USER_SLAVE_SPACE_OFFSET (0x00000000)
/** SERDES main user control register */                            
#define SERDES_SLAVE_REG0_OFFSET (SERDES_USER_SLAVE_SPACE_OFFSET + 0x00000000) 
/** IPIF Reset Register Offset */
#define SERDES_IPIF_RST_SPACE_OFFSET (0x00000100)                              
/** SERDES software reset register */                  
#define SERDES_RST_OFFSET (SERDES_IPIF_RST_SPACE_OFFSET + 0x00000000)          
/** MIR : module identification register */
#define SerdesIR_OFFSET (SERDES_IPIF_RST_SPACE_OFFSET + 0x00000000)            


/** IPIF_MAVN_MASK : module major version number (IPIF Reset/Mir Masks) */
#define IPIF_MAVN_MASK (0xF0000000UL)  
/** IPIF_MIVN_MASK : module minor version number (IPIF Reset/Mir Masks) */
#define IPIF_MIVN_MASK (0x0FE00000UL)  
/** IPIF_MIVL_MASK : module minor version letter (IPIF Reset/Mir Masks) */
#define IPIF_MIVL_MASK (0x001F0000UL)  
/** IPIF_BID_MASK : module block id (IPIF Reset/Mir Masks) */  
#define IPIF_BID_MASK (0x0000FF00UL)   
/** IPIF_BTP_MASK : module block type (IPIF Reset/Mir Masks) */
#define IPIF_BTP_MASK (0x000000FFUL)   
/** IPIF_RESET : software reset (IPIF Reset/Mir Masks) */  
#define IPIF_RESET (0x0000000A)               


/** IPIF Interrupt Controller Space Offset */
#define SERDES_IPIF_INTR_SPACE_OFFSET (0x00000200)
/** INTR_DISR : device (ipif) interrupt status register (IPIF Interrupt Controller Space Offsets) */
#define SERDES_INTR_DISR_OFFSET (SERDES_IPIF_INTR_SPACE_OFFSET + 0x00000000)
/** INTR_DIPR : device (ipif) interrupt pending register (IPIF Interrupt Controller Space Offsets) */
#define SERDES_INTR_DIPR_OFFSET (SERDES_IPIF_INTR_SPACE_OFFSET + 0x00000004)
/** INTR_DIER  : device (ipif) interrupt enable register (IPIF Interrupt Controller Space Offsets) */
#define SERDES_INTR_DIER_OFFSET (SERDES_IPIF_INTR_SPACE_OFFSET + 0x00000008)
/** INTR_DIIR  : device (ipif) interrupt id (priority encoder) register (IPIF Interrupt Controller Space Offsets) */ 
#define SERDES_INTR_DIIR_OFFSET (SERDES_IPIF_INTR_SPACE_OFFSET + 0x00000018)
/** INTR_DGIER : device (ipif) global interrupt enable register (IPIF Interrupt Controller Space Offsets) */ 
#define SERDES_INTR_DGIER_OFFSET (SERDES_IPIF_INTR_SPACE_OFFSET + 0x0000001C)
/** INTR_ISR   : ip (user logic) interrupt status register (IPIF Interrupt Controller Space Offsets) */
#define SERDES_INTR_ISR_OFFSET (SERDES_IPIF_INTR_SPACE_OFFSET + 0x00000020)
/** INTR_IER   : ip (user logic) interrupt enable register (IPIF Interrupt Controller Space Offsets) */
#define SERDES_INTR_IER_OFFSET (SERDES_IPIF_INTR_SPACE_OFFSET + 0x00000028)
 

/** INTR_TERR_MASK : transaction error (IPIF Interrupt Controller Masks) */
#define INTR_TERR_MASK (0x00000001UL)
/** INTR_DPTO_MASK : data phase time-out (IPIF Interrupt Controller Masks) */
#define INTR_DPTO_MASK (0x00000002UL)
/** INTR_IPIR_MASK : ip interrupt requeset (IPIF Interrupt Controller Masks) */
#define INTR_IPIR_MASK (0x00000004UL)
/** INTR_DMA0_MASK : dma channel 0 interrupt request (IPIF Interrupt Controller Masks) */
#define INTR_DMA0_MASK (0x00000008UL)
/** INTR_DMA1_MASK : dma channel 1 interrupt request (IPIF Interrupt Controller Masks) */
#define INTR_DMA1_MASK (0x00000010UL)
/** INTR_RFDL_MASK : read packet fifo deadlock interrupt request (IPIF Interrupt Controller Masks) */
#define INTR_RFDL_MASK (0x00000020UL)
/** INTR_WFDL_MASK : write packet fifo deadlock interrupt request (IPIF Interrupt Controller Masks) */
#define INTR_WFDL_MASK (0x00000040UL)
/** INTR_IID_MASK  : interrupt id (IPIF Interrupt Controller Masks) */
#define INTR_IID_MASK (0x000000FFUL)
/** INTR_GIE_MASK  : global interrupt enable (IPIF Interrupt Controller Masks) */
#define INTR_GIE_MASK (0x80000000UL)
/** INTR_NOPEND    : the DIPR has no pending interrupts (IPIF Interrupt Controller Masks) */
#define INTR_NOPEND (0x80)


/** IPIF Read Packet FIFO Register Space Offset */
#define SERDES_IPIF_RDFIFO_REG_SPACE_OFFSET (0x00000300)
/** RDFIFO_RST   : read packet fifo reset register (IPIF Read Packet FIFO Register/Data Space Offsets) */
#define SERDES_RDFIFO_RST_OFFSET (SERDES_IPIF_RDFIFO_REG_SPACE_OFFSET + 0x00000000)
/** RDFIFO_MIR   : read packet fifo module identification register (IPIF Read Packet FIFO Register/Data Space Offsets) */
#define SERDES_RDFIFO_MIR_OFFSET (SERDES_IPIF_RDFIFO_REG_SPACE_OFFSET + 0x00000000)
/** RDFIFO_SR    : read packet fifo status register (IPIF Read Packet FIFO Register/Data Space Offsets) */
#define SERDES_RDFIFO_SR_OFFSET (SERDES_IPIF_RDFIFO_REG_SPACE_OFFSET + 0x00000004)
/** IPIF Read Packet FIFO Data Space Offset (IPIF Read Packet FIFO Register/Data Space Offsets) */
#define SERDES_IPIF_RDFIFO_DATA_SPACE_OFFSET (0x00000400)
/** RDFIFO_DATA  : read packet fifo data (IPIF Read Packet FIFO Register/Data Space Offsets) */
#define SERDES_RDFIFO_DATA_OFFSET (SERDES_IPIF_RDFIFO_DATA_SPACE_OFFSET + 0x00000000)


/** RDFIFO_EMPTY_MASK : read packet fifo empty condition (IPIF Read Packet FIFO Masks) */
#define RDFIFO_EMPTY_MASK (0x80000000UL)
/** RDFIFO_AE_MASK    : read packet fifo almost empty condition (IPIF Read Packet FIFO Masks) */
#define RDFIFO_AE_MASK (0x40000000UL)
/** RDFIFO_DL_MASK    : read packet fifo deadlock condition (IPIF Read Packet FIFO Masks) */
#define RDFIFO_DL_MASK (0x20000000UL)
/** RDFIFO_SCL_MASK   : read packet fifo occupancy scaling enabled (IPIF Read Packet FIFO Masks) */
#define RDFIFO_SCL_MASK (0x10000000UL)
/** RDFIFO_WIDTH_MASK : read packet fifo encoded data port width (IPIF Read Packet FIFO Masks) */
#define RDFIFO_WIDTH_MASK (0x0E000000UL)
/** RDFIFO_OCC_MASK   : read packet fifo occupancy (IPIF Read Packet FIFO Masks) */
#define RDFIFO_OCC_MASK (0x01FFFFFFUL)


/** IPIF Write Packet FIFO Register Space Offset */
#define SERDES_IPIF_WRFIFO_REG_SPACE_OFFSET (0x00000500)
/** WRFIFO_RST   : write packet fifo reset register (IPIF Write Packet FIFO Register/Data Space Offsets) */
#define SERDES_WRFIFO_RST_OFFSET (SERDES_IPIF_WRFIFO_REG_SPACE_OFFSET + 0x00000000)
/** WRFIFO_MIR   : write packet fifo module identification register (IPIF Write Packet FIFO Register/Data Space Offsets) */
#define SERDES_WRFIFO_MIR_OFFSET (SERDES_IPIF_WRFIFO_REG_SPACE_OFFSET + 0x00000000)
/** WRFIFO_SR    : write packet fifo status register (IPIF Write Packet FIFO Register/Data Space Offsets) */
#define SERDES_WRFIFO_SR_OFFSET (SERDES_IPIF_WRFIFO_REG_SPACE_OFFSET + 0x00000004)
/** IPIF Write Packet FIFO Data Space Offset */
#define SERDES_IPIF_WRFIFO_DATA_SPACE_OFFSET (0x00000600)
/** WRFIFO_DATA  : write packet fifo data (IPIF Write Packet FIFO Register/Data Space Offsets) */
#define SERDES_WRFIFO_DATA_OFFSET (SERDES_IPIF_WRFIFO_DATA_SPACE_OFFSET + 0x00000000)

/** WRFIFO_FULL_MASK  : write packet fifo full condition (IPIF Write Packet FIFO Masks) */ 
#define WRFIFO_FULL_MASK (0x80000000UL)
/** WRFIFO_AF_MASK    : write packet fifo almost full condition (IPIF Write Packet FIFO Masks) */
#define WRFIFO_AF_MASK (0x40000000UL)
/** WRFIFO_DL_MASK    : write packet fifo deadlock condition (IPIF Write Packet FIFO Masks) */
#define WRFIFO_DL_MASK (0x20000000UL)
/** WRFIFO_SCL_MASK   : write packet fifo vacancy scaling enabled (IPIF Write Packet FIFO Masks) */
#define WRFIFO_SCL_MASK (0x10000000UL)
/** WRFIFO_WIDTH_MASK : write packet fifo encoded data port width (IPIF Write Packet FIFO Masks) */
#define WRFIFO_WIDTH_MASK (0x0E000000UL)
/** WRFIFO_VAC_MASK   : write packet fifo vacancy mask (IPIF Write Packet FIFO Masks) */
#define WRFIFO_VAC_MASK (0x01FFFFFFUL)

/*-------------------------------------------------------------------------------------------------
 * Macros (Inline Functions) Definitions
-------------------------------------------------------------------------------------------------*/
/**
 *
 * Write a value to a SERDES register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void SerdesWriteReg(uint32_t BaseAddress, unsigned RegOffset, uint32_t Data)
 *
 */
#define SerdesWriteReg(BaseAddress, RegOffset, Data) \
 	XIo_Out32((BaseAddress) + (RegOffset), (uint32_t)(Data))

/**
 *
 * Read a value from a SERDES register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	uint32_t SerdesReadReg(uint32_t BaseAddress, unsigned RegOffset)
 *
 */
#define SerdesReadReg(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write value to SERDES control slave register.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 * @param   Value is the data written to the register.
 *
 * @note
 * C-style signature:
 * 	uint32_t SerdesReadSlaveRegn(uint32_t BaseAddress)
 *
 */
#define SerdesWriteCtrlReg(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (SERDES_SLAVE_REG0_OFFSET), (uint32_t)(Value))

/**
 *
 * Read value from SERDES control slave register.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	uint32_t SerdesReadSlaveRegn(uint32_t BaseAddress)
 *
 */
#define SerdesReadCtrlReg(BaseAddress) \
 	XIo_In32((BaseAddress) + (SERDES_SLAVE_REG0_OFFSET))

/**
 *
 * Reset SERDES via software.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void SerdesReset(uint32_t BaseAddress)
 *
 */
#define SerdesReset(BaseAddress) \
 	XIo_Out32((BaseAddress)+(SERDES_RST_OFFSET), IPIF_RESET)

/**
 *
 * Read module identification information from SERDES device.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	uint32_t SerdesReadMIR(uint32_t BaseAddress)
 *
 */
#define SerdesReadMIR(BaseAddress) \
 	XIo_In32((BaseAddress)+(SerdesIR_OFFSET))

/**
 *
 * Reset read packet FIFO of SERDES to its initial state.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void SerdesResetReadFIFO(uint32_t BaseAddress)
 *
 */
#define SerdesResetReadFIFO(BaseAddress) \
 	XIo_Out32((BaseAddress)+(SERDES_RDFIFO_RST_OFFSET), IPIF_RESET)

/**
 *
 * Check status of SERDES read packet FIFO module.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 *
 * @return  Status is the result of status checking.
 *
 * @note
 * C-style signature:
 * 	bool SerdesReadFIFOEmpty(uint32_t BaseAddress)
 * 	uint32_t SerdesReadFIFOOccupancy(uint32_t BaseAddress)
 *
 */
#define SerdesReadFIFOEmpty(BaseAddress) \
 	((XIo_In32((BaseAddress)+(SERDES_RDFIFO_SR_OFFSET)) & RDFIFO_EMPTY_MASK) == RDFIFO_EMPTY_MASK)
#define SerdesReadFIFOOccupancy(BaseAddress) \
 	(XIo_In32((BaseAddress)+(SERDES_RDFIFO_SR_OFFSET)) & RDFIFO_OCC_MASK)

/**
 *
 * Read data from SERDES read packet FIFO module.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 *
 * @return  Data is the data from the read packet FIFO.
 *
 * @note
 * C-style signature:
 * 	uint32_t SerdesReadFromFIFO(uint32_t BaseAddress)
 *
 */
#define SerdesReadFromFIFO(BaseAddress) \
 	XIo_In32((BaseAddress) + (SERDES_RDFIFO_DATA_OFFSET))

/**
 *
 * Reset write packet FIFO of SERDES to its initial state.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void SerdesResetWriteFIFO(uint32_t BaseAddress)
 *
 */
#define SerdesResetWriteFIFO(BaseAddress) \
 	XIo_Out32((BaseAddress)+(SERDES_WRFIFO_RST_OFFSET), IPIF_RESET)

/**
 *
 * Check status of SERDES write packet FIFO module.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 *
 * @return  Status is the result of status checking.
 *
 * @note
 * C-style signature:
 * 	bool SerdesWriteFIFOFull(uint32_t BaseAddress)
 * 	uint32_t SerdesWriteFIFOVacancy(uint32_t BaseAddress)
 *
 */
#define SerdesWriteFIFOFull(BaseAddress) \
 	((XIo_In32((BaseAddress)+(SERDES_WRFIFO_SR_OFFSET)) & WRFIFO_FULL_MASK) == WRFIFO_FULL_MASK)
#define SerdesWriteFIFOVacancy(BaseAddress) \
 	(XIo_In32((BaseAddress)+(SERDES_WRFIFO_SR_OFFSET)) & WRFIFO_VAC_MASK)

/**
 *
 * Write data to SERDES write packet FIFO module.
 *
 * @param   BaseAddress is the base address of the SERDES device.
 * @param   Data is the value to be written to write packet FIFO.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void SerdesWriteToFIFO(uint32_t BaseAddress, uint32_t Data)
 *
 */
#define SerdesWriteToFIFO(BaseAddress, Data) \
 	XIo_Out32((BaseAddress) + (SERDES_WRFIFO_DATA_OFFSET), (uint32_t)(Data))

/*-------------------------------------------------------------------------------------------------
 * Function Prototypes
-------------------------------------------------------------------------------------------------*/

/**
 *
 * Enable all possible interrupts from SERDES device.
 *
 * @param   baseaddr_p is the base address of the SERDES device.
 *
 * @return  None.
 *
 * @note    None.
 *
 */
void SerdesEnableInterrupt(void * baseaddr_p);

/**
 *
 * Example interrupt controller handler.
 *
 * @param   baseaddr_p is the base address of the SERDES device.
 *
 * @return  None.
 *
 * @note    None.
 *
 */
void SerdesIntrDefaultHandler(void * baseaddr_p);

/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the SERDES instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus SerdesSelfTest(void *baseaddr_p);

#endif // SERDES_L_H
