/* $Id$ */
/****************************************************************************/
/**
*
* @file TMI_LL_LUT_fix.cpp
* 
* For a description, see the TMI_LL_LUT_fix.h file.
* 
* Author(s) : Patrick Dubois
*
*****************************************************************************/

#include "TMI_LL_LUT_FIX.h"
#include "utils.h"
#include "wb_lowlevel.h"

#define XMIN_ADD        0x00
#define XRANGE_ADD      0x04
#define START_ADD_ADD   0x0C
#define END_ADD_ADD     0x10


IRC_Status LUTF_SendConfig(t_LUTF *pObj, const uint32_t Xmin, const uint32_t Xrange, const uint32_t LUTSize, uint32_t TableIdx)
{
   
   pObj->X_MIN = Xmin;
   pObj->X_RANGE = Xrange;
   pObj->LUTSIZE_M1 = LUTSize - 1;
   pObj->START_ADD = LUTSize * TableIdx;
   pObj->END_ADD = pObj->START_ADD + LUTSize - 1;
   pObj->CTRL = 0;
   
   WriteStruct(pObj);   
   return IRC_SUCCESS;
}

IRC_Status LUTF_UpdateTableIdx(t_LUTF *pObj, uint32_t TableIdx)
{   
   pObj->START_ADD = ((pObj->LUTSIZE_M1) + 1) * TableIdx;
   pObj->END_ADD = pObj->START_ADD + pObj->LUTSIZE_M1;

   WB_write32(pObj->START_ADD, pObj->ADD + TMI_LL_LUTF_START_ADD);
   WB_write32(pObj->END_ADD, pObj->ADD + TMI_LL_LUTF_END_ADD);  
   
   return IRC_SUCCESS;   
}

IRC_Status LUTF_UpdateXrange(t_LUTF *pObj, const float Xmin, const float Xrange)
{
   pObj->X_MIN = Xmin;
   pObj->X_RANGE = Xrange;

   WB_write32(pObj->X_MIN, pObj->ADD + TMI_LL_LUTF_XMIN);
   WB_write32(pObj->X_RANGE, pObj->ADD + TMI_LL_LUTF_XRANGE);   
   
   return IRC_SUCCESS;      
}

IRC_Status LUTF_UpdateCTRL(t_LUTF *pObj, uint32_t Ctrl)
{
   pObj->CTRL = Ctrl;

   WB_write32(pObj->CTRL, pObj->ADD + TMI_LL_LUTF_CTRL); 
   
   return IRC_SUCCESS;      
}

IRC_Status LUTF_Done(const t_LUTF *pObj)
{

   uint8_t status = IRC_NOT_DONE;
   
   if (WB_read32(pObj->ADD + TMI_LL_LUTF_STATUS) == 1)
      status = IRC_DONE;
   
   return status;
}
