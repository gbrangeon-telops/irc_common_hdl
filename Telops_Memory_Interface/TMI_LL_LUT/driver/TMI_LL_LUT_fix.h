/* $Id$ */
/****************************************************************************/
/**
*
* @file TMI_LL_LUTF_FIX.h
* 
* This driver controls the module TMI_LL_LUTF_FIX via Wishbone.
* Please see the following documentation about details of this module:
* \IRCDEV\Technique\Electronique\M9 - ROIC\Video\PDR - AGC.docx
* 
* Author(s) : Patrick Dubois
*
*****************************************************************************/

#ifndef __TMI_LL_LUTF_FIX_H__
#define __TMI_LL_LUTF_FIX_H__

/***************************** Include Files ********************************/
#include <stdint.h>
#include "ROIC_IRC_defines.h"   
#include "ROIC_IRC_status.h"
#include "Genicam.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/**
 * LUTF driver object
 */
typedef struct
{					   
   uint32_t SIZE;          // Number of config elements, excluding SIZE and ADD.
   uint32_t ADD;

   uint32_t X_MIN;     
   uint32_t X_RANGE; 
   uint32_t LUTFSIZE_M1;
   uint32_t START_ADD;   
   uint32_t END_ADD;
   uint32_t CTRL; // Reset pipeline.
   uint32_t STATUS;
    
} t_LUTF;

#define TMI_LL_LUTF_XMIN       0x00
#define TMI_LL_LUTF_XRANGE     0x04
#define TMI_LL_LUTF_LUTFSIZE_M1 0x08
#define TMI_LL_LUTF_START_ADD  0x0C
#define TMI_LL_LUTF_END_ADD    0x10
#define TMI_LL_LUTF_CTRL       0x14
#define TMI_LL_LUTF_STATUS     0x18


/***************** Macros (Inline Functions) Definitions ********************/

#define LUTF_Ctor(add) {sizeof(t_LUTF)/4 - 2, add, 0, 0, 0, 0, 0, 0, 0}

/************************** Function Prototypes *****************************/

/*****************************************************************************
   Configures the LUTF_FIX module
   
   @param pObj Pointer to a LUTF_FIX object
   @param Xmin Minimum value of input data X
   @param Xrange Range of values of input data X (effectively Xmax-Xmin)
   @param LUTFSize Size of one LUTF (there can be many LUTFs stored in ram)
   @param TableIdx Table index. The first LUTF is at index 0.
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.    
*******************************************************************************/
IRC_Status LUTF_SendConfig(t_LUTF *pObj, const float Xmin, const float Xrange, const float LUTFSize, uint32_t TableIdx); 

/*****************************************************************************
   Updates only the LUTF module table index
   
   @param pObj Pointer to a LUTF object
   @param TableIdx Table index. The first LUTF is at index 0.
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.    
*******************************************************************************/
IRC_Status LUTF_UpdateTableIdx(t_LUTF *pObj, uint32_t TableIdx);

/*****************************************************************************
   Updates only the LUTF module Xmin and Xrange value. For example, to be used
   by the AGC in case of the color map.
   
   @param pObj Pointer to a LUTF object
   @param Xmin Minimum value of input data X
   @param Xrange Range of values of input data X (effectively Xmax-Xmin)
 
   @return IRC_SUCCESS if no error, IRC_FAILURE if there is an error.    
*******************************************************************************/
IRC_Status LUTF_UpdateXrange(t_LUTF *pObj, const float Xmin, const float Xrange);

/*****************************************************************************
   Checks if the module is done.    
   The done condition is:
   - The TMI controller is idle
   - All fifos (if any) are empty  
      
   @param pObj Pointer to a LUTF object
 
   @return IRC_DONE when done, IRC_NOT_DONE when not.    
*******************************************************************************/

IRC_Status LUTF_UpdateCTRL(t_LUTF *pObj, uint32_t Ctrl);


IRC_Status LUTF_Done(const t_LUTF *pObj); 													
															

#endif // __TMI_LL_LUTF_FIX_H__
