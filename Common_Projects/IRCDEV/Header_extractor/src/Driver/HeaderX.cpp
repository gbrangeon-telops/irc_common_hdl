/*-----------------------------------------------------------------------------
--
-- Title       : Header Extractor Driver
-- Author      : Patrick Dubois, Edem Nofodjie
-- Company     : Telops inc.
--
-------------------------------------------------------------------------------
--
-- SVN modified fields:
-- $Revision$
-- $Author$
-- $LastChangedDate$
--
-------------------------------------------------------------------------------
--
-- Description : 
--
------------------------------------------------------------------------------*/

#include <string.h> // For memcpy
#include "HeaderX.h" 
#include "utils.h"
#include "DPB_defines.h"
#include "xstatus.h"
#include "wb_lowlevel.h" // For low-level IOs

#ifdef SIM	 
   #include "systemc.h"
   #include <iostream>
   #include <iomanip>
#endif         

/* Compléter les defines avec les bonnes addresses */
#define A_DP_CONFIG         0x0000
#define A_HEADER            0x0030
#define A_FOOTER            0x0050 
#define A_NAV               0x0070 
#define A_SW                0x00FF
//#define A_VALIDCONFIG       0x002E
//#define A_CONFIGCOLLISION   0x002F  

//#define A_HEADER_VALID      0x003E
//#define A_FOOTER_VALID      0x005E

// A_NEWCONFIG Pas necessaire pcq on va se servir seulement du flag VALIDCONFIG et 
// par la suite toujours utiliser la config RocketIO ou RS232
//#define A_NEWCONFIG         0x0080//0x???? 


// Private functions
//static Xuint32 HX_ValidConfig(Xuint32 wb_add)
//{
//   return WB_read16(wb_add + A_VALIDCONFIG);
//}

//static Xuint32 HX_ConfigCollision(Xuint32 wb_add)
//{
//   return WB_read16(wb_add + A_CONFIGCOLLISION);
//}

// Public functions

void HX_ControlSW(t_HeaderXConfig *a, Xuint32 Sel)
{
   WB_write16(Sel, a->ADD + A_SW);   
}

//Xuint32 HX_NewConfigArrived(t_HeaderXConfig *a)
//{
//   return WB_read16(a->ADD + A_VALIDCONFIG);
//}
   
//Xuint32 HX_HeaderValid(t_HeaderXConfig *a)
//{
//   return WB_read16(a->ADD + A_HEADER_VALID);
//}   
   

//Xuint32 HX_FooterValid(t_HeaderXConfig *a)
//{
//   return WB_read16(a->ADD + A_FOOTER_VALID);
//}   
   
   
//void HX_GetConfig(const t_HeaderXConfig *a, t_DPConfig *b)
//{
//   XStatus Status = XST_FAILURE;   
//   
//   // We must first set the wishbone address of the struct. It is required to be able to use ReadStruct later.
//   // It is assumed that b->SIZE was properly set elsewhere.
//   b->ADD = a->ADD + A_DP_CONFIG;         
//   
//   // Loop until a valid config is read.
//   while (Status == XST_FAILURE)
//   {
//      // Wait until config is valid (ie. wait if no config ever arrived OR if a config is incoming).
//      while (HX_ValidConfig(a->ADD) == 0);
//      
//      
//      ReadStruct(b); /* Attention, la fonction ReadStruct est utilisée pour la première fois, elle contient peut-être des erreurs. */
//      
//      if (HX_ConfigCollision(a->ADD) == 1)
//      {
//         // Config changed while we read it, read it again!
//         Status = XST_FAILURE;
//      }           
//      else
//      {
//         Status = XST_SUCCESS;
//      }
//   }         
//}

void HX_PrintDPConfig(const t_DPConfig *a)             
{   
   #ifndef SIM
      // To avoid overloading the RS232 fifo
      WAIT_US(500000);
   #endif
   PRINT("******* DP Config ********\n");

   PRINTF("Size       = %d\n", a->Size       );
   PRINTF("ADD        = %d\n", a->ADD        );
   PRINTF("ZSIZE	    = %d\n", a->ZSIZE	   );
   PRINTF("XSIZE	    = %d\n", a->XSIZE	   );
   PRINTF("YSIZE		 = %d\n", a->YSIZE		);
   PRINTF("IMGSIZE    = %d\n", a->IMGSIZE    );   
   PRINTF("TAGSIZE	 = %d\n", a->TAGSIZE	   );   
   PRINTF("SB_Min     = %d\n", a->SB_Min     );
   PRINTF("SB_Max     = %d\n", a->SB_Max     );
   PRINTF("SB_Mode    = %d\n", a->SB_Mode    );                                               
   PRINTF("Interleave = %d\n", a->Interleave );
   PRINTF("Mode	    = %d\n", a->Mode	      );
   PRINTF("AVGSIZE	 = %d\n", a->AVGSIZE	   );
   PRINTF("DIAGSIZE   = %d\n", a->DIAGSIZE   );
   PRINTF("BB_Temp    = %d\n", a->BB_Temp    );
   PRINTF("Delta_OPD  = %d\n", a->Delta_OPD  );
   PRINTF("Max_Temp   = %d\n", a->Max_Temp   );
   PRINTF("SB_Min_Cal = %d\n", a->SB_Min_Cal   );
   PRINTF("SB_Max_Cal = %d\n", a->SB_Max_Cal    );
   #ifndef SIM
      // To avoid overloading the RS232 fifo
      WAIT_US(500000);
   #endif
}

void HX_GetROICHeader(const t_HeaderXConfig *a, t_ROIC_DCube_Header_array16 b)
{
   // Note : b is already a pointer.
   ReadArray16(b, ROIC_HEADER_LEN, a->ADD + A_HEADER); 
   //PRINTF("ROIC Header array:\n");
   //PrintArray16(b, ROIC_HEADER_LEN);        
}

void HX_GetROICFooter(const t_HeaderXConfig *a, t_ROIC_DCube_Footer_array16 b)
{
   // Note : b is already a pointer.
   ReadArray16(b, ROIC_FOOTER_LEN, a->ADD + A_FOOTER);
   //PRINTF("ROIC Footer array:\n");
   //PrintArray16(b, ROIC_FOOTER_LEN);
}

void HX_GetNAVFooter(const t_HeaderXConfig *a, t_ROIC_DCube_Nav_array16 b)
{
   // Note : b is already a pointer.
   ReadArray16(b, NAV_FOOTER_LEN, a->ADD + A_NAV + 2); // Ignore 0x0600001A (command word)
   //PRINTF("NAV Footer array:\n");
   //PrintArray16(b, NAV_FOOTER_LEN);
}

void HX_PrintROICHeader(const t_ROIC_DCube_Header_array16 a) /* For debug only */
{   // Décoder le Header et l'afficher à la manière de HX_PrintDPConfig
   // Note : a is already a pointer.// ajouté par ENO
   /* À compléter par ENO */   
 
  
     

  #ifdef SIM  
  
  
   
   PRINT("******* ROICHeader ********\n");  
   PRINTF("ROICHeader Direction     = 0x%X\n", a[0]);
   PRINTF("ROICHeader Acq_Number    = 0x%X\n", a[1]);
   Xuint32 b =  a[2];       
   b =  b << 16 | a[3];  
   PRINTF("ROICHeader Code_revision = 0x%X\n", b); 
   b =  a[4];       
   b =  b << 16 | a[5]; 
   
   PRINTF("ROICHeader Status        = 0x%X\n", b); 
   PRINTF("ROICHeader Xmin          = 0x%X\n", a[6] );
   PRINTF("ROICHeader Ymin          = 0x%X\n", a[7]);
   b =  a[8];       
   b =  b << 16 | a[9];
   PRINTF("ROICHeader Time_stamp    = 0x%X\n", b);
//   PRINTF("ROICHeader => a[7] = 0x%X\n", a[7] );
//   PRINTF("ROICHeader => a[8] = 0x%X\n", a[8] ); 
//   PRINTF("ROICHeader => a[9] = 0x%X\n", a[9] );
 
  #endif 

   
   
  
}

void HX_PrintROICFooter(const t_ROIC_DCube_Footer_array16 a) /* For debug only */
{  
   // Note : a is already a pointer.// ajouté par ENO
   /* À compléter */
   // Décoder le Footer et l'afficher à la manière de HX_PrintDPConfig 
     #ifdef SIM
    
     
     
   PRINT("******* ROICFooter ********\n");  
   PRINTF("ROICFooter Direction              = 0x%X\n", a[0] );
   PRINTF("ROICFooter Acq_Number             = 0x%X\n", a[1] );
   Xuint32 b =  a[2];            
    b =  b << 16 | a[3];  
   PRINTF("ROICFooter Fringe_param_write_No  = 0x%X\n",b); 
    b =  a[4];            
    b =  b << 16 | a[5];  
   PRINTF("ROICFooter Fringe_param_Trig_No   = 0x%X\n", b); 
    b =  a[6];                                                                             
    b =  b << 16 | a[7];                                                                   
   PRINTF("ROICFooter ROIC_status            = 0x%X\n", b);
     b =  a[8];                                                                              
     b =  b << 16 | a[9];                                                                    
   PRINTF("ROICFooter Misc_ZPD               = 0x%X\n", b);
     b =  a[10];                                                                             
     b =  b << 16 | a[11];                                                                   
   PRINTF("ROICFooter Misc_Peak              = 0x%X\n", b);
    b =  a[12];            
    b =  b << 16 | a[13];  
   PRINTF("ROICFooter Time_stamp             = 0x%X\n", b);
//   PRINTF("ROICFooter => a[8] = 0x%X\n", a[8] ); 
//   PRINTF("ROICFooter => a[9] = 0x%X\n", a[9] );
 
  #endif 
   
   
   
}
