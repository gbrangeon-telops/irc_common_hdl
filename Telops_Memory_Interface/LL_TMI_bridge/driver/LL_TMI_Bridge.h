/* $Id$ */
/****************************************************************************/
/**
*
* @file LL_TMI_Bridge.h
* 
* This driver controls the module LL_TMI_Bridge via Wishbone.
* Please see the following documentation about details of this module:
* \IRCDEV\Technique\Electronique\M9 - ROIC\Calibration\PDR - LL_TMI_Bridge.doc
* 
* Author(s) : Patrick Dubois
*
*****************************************************************************/

#ifndef __LL_TMI_BRIDGE_H__
#define __LL_TMI_BRIDGE_H__

/***************************** Include Files ********************************/
#include <stdint.h>
#include "ROIC_IRC_defines.h"   
#include "ROIC_IRC_status.h" 
#include "Genicam.h"  

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/**
 * LLTMI driver object
 */
typedef struct
{					   
   uint32_t SIZE;          // Number of config elements, excluding SIZE and ADD.
   uint32_t ADD;
   
   uint32_t WR_CONTROL;    // (0) => Start, (1) => Stop, (2) => Immediate Stop
   uint32_t WR_START_ADD;
   uint32_t WR_CONFIG;     // (0) => LOOP
   uint32_t WR_END_ADD;
   int32_t WR_STEP_ADD;   // Step between the writting addresse 
   uint32_t WR_WIDTH;
   int32_t WR_SKIP;

   uint32_t RD_CONTROL;    // (0) => Start, (1) => Stop, (2) => Immediate Stop
   uint32_t RD_CONFIG;     // (0) => LOOP, (1) => GEN_SOA, (2) => GEN_EOA, (3) => GEN_SOL, (4) => GEN_EOL
   uint32_t RD_START_ADD;
   uint32_t RD_END_ADD;
   int32_t RD_STEP_ADD;   // Step between the read addresse
   uint32_t RD_WIDTH;
   int32_t RD_SKIP;   
} t_LLTMI_Bridge;

typedef enum
{
  LLTMI_WRITE = 0,
  LLTMI_READ
} LLTMI_mode_t;

#define LL_TMI_BRIDGE_LINE_FRAME     0
#define LL_TMI_BRIDGE_IMAGE_FRAME    1

#define LL_TMI_BRIDGE_SINGLE_IMAGE   0
#define LL_TMI_BRIDGE_LOOP_IMAGE     1

/***************** Macros (Inline Functions) Definitions ********************/

#define LLTMI_Bridge_Ctor(add) {sizeof(t_LLTMI_Bridge)/4 - 2, add, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

/************************** Function Prototypes *****************************/

/***************************************************************************//**
   Configures the LLTMI module using primarily Genicam registers. 
   
   @param pObj    Pointer to a LLTMI object
   @param pGCRegs Pointer to the Genicam registers
   @param mode    LLTMI_READ or LLTMI_WRITE. The LLTMI module can only be 
                  configured in read or write mode, not both simultaneously.
   @param frame   LL_TMI_BRIDGE_LINE_FRAME or LL_TMI_BRIDGE_IMAGE_FRAME
   @param image   LL_TMI_BRIDGE_SINGLE_IMAGE or LL_TMI_BRIDGE_LOOP_IMAGE
   @param page    A page has a size of WidthMax * HeightMax, page selects which
                  one to use. The first page is 0.
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.    
*******************************************************************************/
void LLTMI_SendConfigGC(t_LLTMI_Bridge *pObj, const GeniCam_Registers_Set_t *pGCRegs, LLTMI_mode_t mode, uint8_t frame, uint8_t image, uint32_t page);

/***************************************************************************//**
   Update LLTMI settings because the NDF position has changed. This basically
   change the START_ADD and END_ADD of the module to read a different part
   of the memory. 
   
   @param pObj Pointer to a LLTMI object
   @param pGCRegs Pointer to the Genicam registers   
   @param page    A page has a size of WidthMax * HeightMax, page selects which
                  one to use. The first page is 0.   
 
   @return None
*******************************************************************************/
void LLTMI_UpdateNDFConfigGC(t_LLTMI_Bridge *pObj, const GeniCam_Registers_Set_t *pGCRegs, uint32_t page);

/***************************************************************************//**
   Starts the LLTMI module. It must have been configured with 
   LLTMI_SendConfigGC beforehand.
   
   @param pObj Pointer to a LLTMI object
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.     
*******************************************************************************/
IRC_Status LLTMI_Start(t_LLTMI_Bridge *pObj); 

/***************************************************************************//**
   Normal stop. This stop is only used if LOOP=1. It basically asks the LLTMI
   module to stop at after the current image, once END_ADD is reached.
   
   @param pObj Pointer to a LLTMI object
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.     
*******************************************************************************/
IRC_Status LLTMI_Stop(t_LLTMI_Bridge *pObj);

/***************************************************************************//**
   Immediate stop. The module will stop generating addresses requests without
   waiting for END_ADD. The function returns immediatally. Use LLTMI_Done to
   check when LLTMI is done.
   
   @param pObj Pointer to a LLTMI object
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.     
*******************************************************************************/
IRC_Status LLTMI_ImmediateStop(t_LLTMI_Bridge *pObj);

/***************************************************************************//**
   Checks if the module is done.    
   If LOOP=0, the done condition is:
   - The address requests reached END_ADD
   - The TMI controller is idle
   - All fifos are empty
   If LOOP=1, the done condition is:   
   - There has been a LLTMI_Stop() request.
   - The address requests reached END_ADD
   - The TMI controller is idle
   - All fifos are empty   
   If a ImmediateStop was requested, the done condition is:
   - The TMI controller is idle
   - All fifos are empty     
      
   @param pObj Pointer to a LLTMI object
 
   @return IRC_DONE when done, IRC_NOT_DONE when not.    
*******************************************************************************/
IRC_Status LLTMI_Done(t_LLTMI_Bridge *pObj); 													

/* FOR FrameBuffer
*/

void LLTMI_UpdateReadID(t_LLTMI_Bridge *pObj, const GeniCam_Registers_Set_t *pGCRegs, uint8_t frame, uint8_t image, uint32_t page,uint32_t ID);
void LLTMI_UpdateFBConfig(t_LLTMI_Bridge *pObj, const GeniCam_Registers_Set_t *pGCRegs,LLTMI_mode_t mode, uint8_t frame, uint8_t image, uint32_t page);
															

#endif // __LL_TMI_BRIDGE_H__
