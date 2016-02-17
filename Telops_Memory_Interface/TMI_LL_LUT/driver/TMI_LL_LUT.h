/* $Id: TMI_LL_LUT.h 7677 2010-04-09 14:36:26Z rd\pdubois $ */
/****************************************************************************/
/**
*
* @file TMI_LL_LUT.h
* 
* This driver controls the module TMI_LL_LUT via Wishbone.
* Please see the following documentation about details of this module:
* \IRCDEV\Technique\Electronique\M9 - ROIC\Calibration\PDR - TMI_LL_LUT.doc
* 
* Author(s) : Patrick Dubois
*
*****************************************************************************/

#ifndef __TMI_LL_LUT_H__
#define __TMI_LL_LUT_H__

/***************************** Include Files ********************************/
#include <stdint.h>
#include "ROIC_IRC_defines.h"   
#include "ROIC_IRC_status.h"
#include "Genicam.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/**
 * LUT driver object
 */
typedef struct
{					   
   uint32_t SIZE;          // Number of config elements, excluding SIZE and ADD.
   uint32_t ADD;

   float    X_MIN;     
   float    X_RANGE; 
   float    LUTSIZE_M1;
   uint32_t START_ADD;   
   uint32_t END_ADD;
   uint32_t CTRL; // Reset pipeline.
   uint32_t STATUS;
    
} t_LUT;

#define TMI_LL_LUT_XMIN       0x00
#define TMI_LL_LUT_XRANGE     0x04
#define TMI_LL_LUT_LUTSIZE_M1 0x08
#define TMI_LL_LUT_START_ADD  0x0C
#define TMI_LL_LUT_END_ADD    0x10
#define TMI_LL_LUT_CTRL       0x14
#define TMI_LL_LUT_STATUS     0x18


/***************** Macros (Inline Functions) Definitions ********************/

#define LUT_Ctor(add) {sizeof(t_LUT)/4 - 2, add, 0, 0, 0, 0, 0, 0, 0}

/************************** Function Prototypes *****************************/

/*****************************************************************************
   Configures the LUT module
   
   @param pObj Pointer to a LUT object
   @param Xmin Minimum value of input data X
   @param Xrange Range of values of input data X (effectively Xmax-Xmin)
   @param LUTSize Size of one LUT (there can be many LUTs stored in ram)
   @param TableIdx Table index. The first LUT is at index 0.
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.    
*******************************************************************************/
IRC_Status LUT_SendConfig(t_LUT *pObj, const float Xmin, const float Xrange, const float LUTSize, uint32_t TableIdx); 

/*****************************************************************************
   Updates only the LUT module table index
   
   @param pObj Pointer to a LUT object
   @param TableIdx Table index. The first LUT is at index 0.
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.    
*******************************************************************************/
IRC_Status LUT_UpdateTableIdx(t_LUT *pObj, uint32_t TableIdx);

/*****************************************************************************
   Updates only the LUT module Xmin and Xrange value. For example, to be used
   by the AGC in case of the color map.
   
   @param pObj Pointer to a LUT object
   @param Xmin Minimum value of input data X
   @param Xrange Range of values of input data X (effectively Xmax-Xmin)
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.    
*******************************************************************************/
IRC_Status LUT_UpdateXrange(t_LUT *pObj, const float Xmin, const float Xrange);

/*****************************************************************************
   Checks if the module is done.    
   The done condition is:
   - The TMI controller is idle
   - All fifos (if any) are empty  
      
   @param pObj Pointer to a LUT object
 
   @return IRC_DONE when done, IRC_NOT_DONE when not.    
*******************************************************************************/

IRC_Status LUT_UpdateCTRL(t_LUT *pObj, uint32_t Ctrl);


IRC_Status LUT_Done(const t_LUT *pObj); 													
															

#endif // __TMI_LL_LUT_H__
