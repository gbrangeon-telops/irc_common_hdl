#include "PatGen.h"
#include "DPB_defines.h"
#include "utils.h"                                   
#include "wb_lowlevel.h" // For low-level IOs

#define A_CONTROL             0x0018
#define A_STATUS              0x0019
#define A_PG_DP_CONFIG        0x0040   // adresse relative du debut de DP_CONFIG


#define DONE                  0x0001

// These defines are taken from DPB_Define.vhd
// Diagnostic modes:
#define PG_STOP         0 
#define PG_FRAME        1 // Individual frame trigering using FrameType field
#define PG_CAM_CNT      2 // Camera Frame simple pixel incrementation
#define PG_CAM_VIS      3 // Camera Frame visible pattern            
#define PG_BSQ_XYZ      4 // BSQ DCube X,Y,Z counters                
#define PG_BIP_XYZ      5 // BIP DCube X,Y,Z counters                
#define PG_BIP_DIRAC    6 //                                         
#define PG_BSQ_COLD     7 // Cold blackbody
#define PG_BSQ_HOT      8 // Hot blackbody
#define PG_BSQ_SCENE    9 // Scene                        
        
#define S_SEND_DP_CONFIG      0

#define ROM_LENGTH      1024
#define ZPD_POS         508  // When first element is 0
        
// Private functions

static inline void PG_SendConfig(const t_PatGenConfig *a) // inline because the function is called only once.
{           
   PG_Stop(a);                    // on stope tout autre envoi
   WriteStruct(a);                // on envoie la config du PatGen   
}

// Public functions

void PG_SendDPConfig( t_PatGenConfig *a,  t_DPConfig b)
{  
   PRINT("Envoie de DP_Config\n");
   /* Envoie de DPConfig (pas transmit encore) */
   b.ADD = a->ADD + A_PG_DP_CONFIG;
   WriteStruct(&b);    
   
   PRINT("Envoie de PG_Config\n");
   /* Demande de transmission de DPConfig */
   a->CONFIG        = 1 << S_SEND_DP_CONFIG;
   PG_SendConfig(a);                       
   WB_write16(0xFFFF, a->ADD + A_CONTROL);      
}
 //--------------------------------------------
// PATTERN_GEN START
//----------------------------------------------
void PG_Start(t_PatGenConfig *a, t_DPConfig *b, Xuint32 MissingImages)
{
   Xuint32 xadjust;

   switch (b->Mode)
   {
      case IGM          :
      case RAW_SPC      :
      case RAW_SPC_N_IGM:
         a->DiagMode = PG_BSQ_XYZ;
         break;
         
      case CAL_SPC_ONLY :
      case CAL_SPC_N_IGM:
         a->DiagMode = PG_BSQ_SCENE;
         break;    
               
      case HOT_BB_STORE :
      case HOT_BB_OUT   :
         a->DiagMode = PG_BSQ_HOT; 
         break;
         
      case COLD_BB_STORE:
      case COLD_BB_OUT  :
         a->DiagMode = PG_BSQ_COLD; 
         break;
         
      case CAMERA       :
         a->DiagMode = PG_CAM_CNT; 
         break;
   }
  
   a->ZSIZE         = b->ZSIZE - MissingImages;      
   a->YSIZE         = b->YSIZE;
   a->XSIZE         = b->XSIZE;
   a->TAGSIZE       = b->TAGSIZE; 
   a->ImgSize       = b->XSIZE * b->YSIZE;
   
   a->ImagePause    = 1; // Here we could create a variable throughput.     
      
   if (a->ZSIZE > 65535 || b->AVGSIZE < 1 || b->AVGSIZE > 32) 
   {
      a->DiagSize    = b->DIAGSIZE;
   }
   else 
   {
      a->DiagSize    = b->AVGSIZE*b->DIAGSIZE;   
   }
   
   a->PayloadSize   = (a->XSIZE*a->YSIZE + a->TAGSIZE);   
   
   a->CONFIG        = 0;  
   
   // We need to choose the starting and end point for the ROM igms
   if (a->ZSIZE > ROM_LENGTH)
   {
      //ROM is smaller than the desired igm, use all the ROM
      a->ROM_Z_START = (a->ZSIZE - ROM_LENGTH) / 2;
      a->ROM_INIT_INDEX = 0;
   }
   else
   {   
      //ROM is bigger than the desired igm, use only part of the ROM
      a->ROM_Z_START = 0;
      Xint32 temp = ZPD_POS - (Xint32)(a->ZSIZE/2);
      if (temp < 0)
      {
         a->ROM_INIT_INDEX = 0;     
      }
      else
      {
         a->ROM_INIT_INDEX = (Xuint32)temp;     
      }
   }   
   
  
   PG_SendConfig(a); 
   WB_write16(0xFFFF, a->ADD + A_CONTROL); 
  
}   
 //--------------------------------------------
// PATTERN_GEN STOP
//----------------------------------------------
void PG_Stop(const t_PatGenConfig *a)                     
{
   WB_write16(0x0000, a->ADD + A_CONTROL); 
   //WB_write16(0x0001, a->ADD + A_CONFIG); 
}

Xuint32 PG_Done(t_PatGenConfig *a)
{
   Xuint32 Status;
   Status = WB_read16(a->ADD + A_STATUS); 
   //PRINTF("STATUS           = %d\n", Status);
   if ((Status & DONE) == 0)
   {
      return 0;
   }
   else
   {
      return 1;
   }
}
//--------------------------------------------
// PATTERN_GEN PRINTING
//----------------------------------------------
void PG_PrintConfig(const t_PatGenConfig *a)
{   
   #ifdef SIM
      PRINT("******* Diag Config ********\n");
      PRINTF("DiagMode           = %d\n", a->DiagMode );
      PRINTF("ZSIZE              = %d\n", a->ZSIZE    );
      PRINTF("XSIZE              = %d\n", a->XSIZE    );                               
      PRINTF("YSIZE               = %d\n", a->YSIZE      );
      PRINTF("TAGSIZE            = %d\n", a->TAGSIZE  );     
      PRINTF("DiagSize           = %d\n", a-> DiagSize);   
      PRINTF("PayloadSize        = %d\n", a->PayloadSize); 
      PRINTF("CONFIG             = %d\n", a->CONFIG     );                                             
      PRINT("****************************\n");   
   #endif
}
