/* $Id: TMI_LL_LUT.cpp 7674 2010-04-08 21:00:04Z rd\pdubois $ */
/****************************************************************************/
/**
*
* @file TMI_LL_LUT.cpp
* 
* For a description, see the TMI_LL_LUT.h file.
* 
* Author(s) : Patrick Dubois
*
*****************************************************************************/

#include "TMI_LL_LUT.h"
#include "utils.h"
#include "wb_lowlevel.h"

IRC_Status LUT_SendConfig(t_LUT *pObj, const float Xmin, const float Xrange, const float LUTSize, uint32_t TableIdx)
{
   
   pObj->X_MIN = Xmin;
   pObj->X_RANGE = Xrange;
   pObj->LUTSIZE_M1 = LUTSize;
   pObj->START_ADD = (uint32_t)LUTSize * TableIdx;
   pObj->END_ADD = pObj->START_ADD + (uint32_t)LUTSize - 1;
   pObj->CTRL = 0;
   
   WriteStruct(pObj);   
   return IRC_SUCCESS;
}

IRC_Status LUT_UpdateTableIdx(t_LUT *pObj, uint32_t TableIdx)
{   
   pObj->START_ADD = (((uint32_t)pObj->LUTSIZE_M1)) * TableIdx;
   pObj->END_ADD = pObj->START_ADD + (uint32_t)pObj->LUTSIZE_M1 - 1;

   WB_write32(pObj->START_ADD, pObj->ADD + TMI_LL_LUT_START_ADD);
   WB_write32(pObj->END_ADD, pObj->ADD + TMI_LL_LUT_END_ADD);  
   
   return IRC_SUCCESS;   
}

IRC_Status LUT_UpdateXrange(t_LUT *pObj, const float Xmin, const float Xrange)
{
   pObj->X_MIN = Xmin;
   pObj->X_RANGE = Xrange;

   // We need a crazy cast here because of float types
   WB_write32(*(uint32_t*)(&pObj->X_MIN), pObj->ADD + TMI_LL_LUT_XMIN);
   WB_write32(*(uint32_t*)(&pObj->X_RANGE), pObj->ADD + TMI_LL_LUT_XRANGE);   
   
   return IRC_SUCCESS;      
}

IRC_Status LUT_UpdateCTRL(t_LUT *pObj, uint32_t Ctrl)
{
   pObj->CTRL = Ctrl;

   // We need a crazy cast here because of float types
   WB_write32(*(uint32_t*)(&pObj->CTRL), pObj->ADD + TMI_LL_LUT_CTRL); 
   
   return IRC_SUCCESS;      
}

IRC_Status LUT_Done(const t_LUT *pObj)
{

   uint8_t status = IRC_NOT_DONE;
   
   if (WB_read32(pObj->ADD + TMI_LL_LUT_STATUS) == 1)
      status = IRC_DONE;
   
   return status;
}
