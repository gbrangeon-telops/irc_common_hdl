#include "TMI_LL_Histogram.h"
#include "wb_lowlevel.h"
#include <string.h>
//DeBUG


// ADRESSE du registre des statuts        
#define A_TMI_LL_HIST_READY      0x00
#define A_TMI_LL_HIST_TIMESTMP   0x04
#define A_TMI_LL_HIST_CLEAR      0x08
#define A_TMI_LL_HIST_EXTDATA    0x0C

/*--------------------------------------------------------- 
 FONCTION : TMI_LL_HIST_HistReady
---------------------------------------------------------*/
bool TMI_LL_HIST_HistReady(t_TMI_LL_HIST *pObj)
{
	return WB_read32(pObj->ADD + A_TMI_LL_HIST_READY);
}

/*--------------------------------------------------------- 
 FONCTION : TMI_LL_HIST_HistReady
---------------------------------------------------------*/
void TMI_LL_HIST_ClearHist(t_TMI_LL_HIST *pObj)
{
   WB_write32(1, pObj->ADD + A_TMI_LL_HIST_CLEAR);      
}

/*--------------------------------------------------------- 
 FONCTION : TMI_LL_HIST_HistReady
---------------------------------------------------------*/
bool TMI_LL_HIST_GetHist(t_TMI_LL_HIST *pObj, uint32_t *pHistBuffer, uint32_t *pTimeStamp, uint32_t *pExtData)
{
   if((!TMI_LL_HIST_HistReady(pObj)) || (pHistBuffer==NULL))
   {
      return false;
   }
   
   #ifndef SIM
   //memcpy ne peux etre simuler sur un bridge TMI
   memcpy(pHistBuffer, (void*)(pObj->TMI_ADD), (pObj->NB_BINS)*4);
   #endif

   if(pTimeStamp != NULL)
   	*pTimeStamp = WB_read32(pObj->ADD + A_TMI_LL_HIST_TIMESTMP);
   if(pExtData != NULL)
   	*pExtData = WB_read32(pObj->ADD + A_TMI_LL_HIST_EXTDATA);
   return true;
}
