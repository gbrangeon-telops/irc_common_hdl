/* $Id$ */
/****************************************************************************/
/**
*
* @file TMI_LL_Histogram.h
* 
* This driver controls the module TMI_LL_Histogram via Wishbone and TMI.
* Please see the following documentation about details of this module:
* \IRCDEV\Technique\Electronique\M9 - ROIC\Video\PDR - TMI-LL Histogram.doc
* 
* Author(s) : Jean-Philippe Déry
*
*****************************************************************************/
#ifndef __TMI_LL_HISTOGRAM_H__
#define __TMI_LL_HISTOGRAM_H__

/***************************** Include Files ********************************/
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

/************************** Constant Definitions ****************************/
#define TMI_LL_HIST_DATAIN_RANGE    65535
#define TMI_LL_HIST_DATAIN_RANGEf   65535.0f
#define TMI_LL_HIST_MAX_NB_BINS     1024
#define TMI_LL_HIST_TIMESTAMP_BASE  7.518796992481204e-009

/**************************** Type Definitions ******************************/
/**
 * TMI_LL_Histogram driver object
 */
typedef struct
{					   
   uint32_t ADD;
   uint32_t TMI_ADD;
   uint32_t NB_BINS;
   float    NB_VAL_PER_BINS;
   
} t_TMI_LL_HIST;

/***************** Macros (Inline Functions) Definitions ********************/
#define TMI_LL_HIST_Ctor(add,tmi_add) {add, tmi_add, TMI_LL_HIST_MAX_NB_BINS, (TMI_LL_HIST_DATAIN_RANGEf+1.0f)/(float)TMI_LL_HIST_MAX_NB_BINS}

/************************** Function Prototypes *****************************/

/***************************************************************************//**
   This function returns the status of the histogram hardware.
      true  : A histogram is available
      false : Waiting for next histogram to complete
   
   @param pObj Pointer to a TMI_LL_HIST object
 
   @return bool
   
*******************************************************************************/
bool TMI_LL_HIST_HistReady(t_TMI_LL_HIST *pObj);

/***************************************************************************//**
   Clears the current histogram. This allows for the hardware to build the
   next histogram.
   
   @param pObj Pointer to a TMI_LL_HIST object
 
   @return void
   
*******************************************************************************/
void TMI_LL_HIST_ClearHist(t_TMI_LL_HIST *pObj);

/***************************************************************************//**
   Reads the currently available histogram to the provided buffer
   The buffer must be at least t_TMI_LL_HIST.NB_BINS in size.
   Fails if TMI_LL_HIST_HistReady() fails.
      true  : Success
      false : Failure
   
   @param pObj Pointer to a TMI_LL_HIST object
   @param pHistBuffer Pointer to a buffer where the histogram is to be copied
   @param pTimeStamp Optional pointer to where the histogram timeStamp is to be saved (NULL to ignore)
   @param pExtData Optional pointer to where the histogram external data is to be saved (NULL to ignore)
 
   @return bool
   
*******************************************************************************/
bool TMI_LL_HIST_GetHist(t_TMI_LL_HIST *pObj, uint32_t *pHistBuffer, uint32_t *pTimeStamp, uint32_t *pExtData);
														 
#endif // __TMI_LL_HISTOGRAM_H__
