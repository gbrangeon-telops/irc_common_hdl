/*-----------------------------------------------------------------------------
--
-- Title       : Patter Generator + Header Extractor TestBench
-- Author      : Patrick Dubois
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


#include "xbasic_types.h"
#include "xtime_l.h"
#include "xparameters.h"
#include "utils.h"
#include "PatGen.h"
#include "HeaderX.h"
#include "DPB_defines.h"

#ifdef SIM
   #include "vp30_ctrl.h"
   #include "uc2_gpio.h"
#else
   #include "gpio.h"
#endif

static void StartTB();
#define PG_ADD      0x0200    // This define should be in DPB_Defines.h
#define HX_ADD      0x0300    // This define should be in DPB_Defines.h

// Global variables
Xuint32 fpga_id;

#ifdef SIM
   sc_port<uc2_transactor_task_if> *global_trans_ptr;
   void vp30_ctrl::main()
#else
   int main()
#endif
{
   
   PRINT("Entering main()...\n");

   #ifdef SIM
      #ifndef S_SPLINT_S
      global_trans_ptr = &transactor_interface;
      #endif
   #endif

   fpga_id = 0;

   StartTB();  

   #ifndef SIM
      return 0;
   #endif





}  // } main  

static void StartTB()
{
    t_PatGenConfig    PG = PG_Ctor(PG_ADD);
    t_HeaderXConfig   HX = HX_Ctor(HX_ADD);
   
   t_DPConfig        DP_Cfg_PG = DP_Cfg_Default(0);
   t_DPConfig        DP_Cfg_HX = DP_Cfg_Default(0); 
   
  t_ROIC_DCube_Header_array16   ROICHeader;
   t_ROIC_DCube_Footer_array16   ROICFooter;   
   
   Xuint32           AcqNum = 1;

   WAIT_US(1);

   // Config
   DP_Cfg_PG.ZSIZE         = 12;   //
   DP_Cfg_PG.XSIZE         = 8;	   //
   DP_Cfg_PG.YSIZE         = 10; 
   
   DP_Cfg_PG.TAGSIZE       = 8;
   DP_Cfg_PG.SB_Min        = 414;
   DP_Cfg_PG.SB_Max        = 700;
   DP_Cfg_PG.SB_Mode       = NON_CROPPED;
   DP_Cfg_PG.Interleave    = BIP;
   DP_Cfg_PG.Mode          = DIAG_IGM;
   DP_Cfg_PG.AVGSIZE       = 1;
   DP_Cfg_PG.IMGSIZE       = (DP_Cfg_PG.XSIZE) * DP_Cfg_PG.YSIZE;
   
  //// DP_Cfg_PG.DIAGSIZE      = 1;
////   DP_Cfg_PG.BB_Temp       = 0;
   
   DP_Cfg_PG.Delta_OPD  = 2.5312e-4;
   DP_Cfg_PG.Rad_Exp    = 31;  // 30 on the whole range but 31 on the range where the FIRST is sensitive
   DP_Cfg_PG.Gain_Exp   = -12; // This needs to be fine-tuned depending on the noise of the instrument
   DP_Cfg_PG.Off_Exp    = -4;  // This needs to be fine-tuned depending on the noise of the instrument
   DP_Cfg_PG.Lh_Exp     = -2;  // This could be calculated automatically
   DP_Cfg_PG.dLbb_Exp   = -27; // This could be calculated automatically   

      //PRINTF("DIAGSIZE   = %d\n", a->DIAGSIZE   );
   //PRINTF("BB_Temp    = %d\n", a->BB_Temp    );
  
//PG->SendDPConfig(const t_DPConfig *b);
				  
 
 
   PRINT("*******************************\n");
   PRINT("** Starting Switch HX_SW_PASSTHRU test.  \n");
   PRINT("*******************************\n");
   
   // Set the dataflow switch
     HX_ControlSW(&HX, HX_SW_PASSTHRU);        //HX_SW_PASSTHRU     HX_SW_PROCESS

   // Start the pattern genrator.
  PG_Start(&PG, &DP_Cfg_PG, AcqNum);
   
   // Print config for debug purposes...
  PG_PrintConfig(&PG);

  while(PG_Done(&PG) != 1)
     {
       //Wait until Pattern Generator is done.
      } 
   
   // Stop the pattern genrator.
   PG_Stop(&PG);
   
   // Now  Check if a header is valid, if so, read it and print it.
   
   if (HX_HeaderValid(&HX) == 1)
    {
      HX_GetROICHeader(&HX, ROICHeader); 
      HX_PrintROICHeader(ROICHeader);
    }
    else 
    {
       PRINT("** AUCUN ROIC_HEADER VALIDE!!!! GROSSE ERREUR  \n");
    }
   
     //do the same with the footer
   if (HX_FooterValid(&HX) == 1)
    {
         HX_GetROICFooter(&HX, ROICFooter);  
         HX_PrintROICFooter(ROICFooter);
    }
    else 
    {
       PRINT("** AUCUN ROIC_FOOTER VALIDE!!!! GROSSE ERREUR  \n");
    
    }        
    
   PRINT("*******************************\n");
   PRINT("** Starting switch HX_SW_PROCESS  \n");
   PRINT("*******************************\n");
   
   // Set the dataflow switch
     HX_ControlSW(&HX, HX_SW_PROCESS);        //HX_SW_PASSTHRU     HX_SW_PROCESS

   // Start the pattern genrator.
  PG_Start(&PG, &DP_Cfg_PG, AcqNum);
   
   // Print config for debug purposes...
  PG_PrintConfig(&PG);

  while(PG_Done(&PG) != 1)
     {
       //Wait until Pattern Generator is done.
      } 
   
   // Stop the pattern genrator.
   PG_Stop(&PG);
   
   // Now  Check if a header is valid, if so, read it and print it.
   
   if (HX_HeaderValid(&HX) == 1)
    {
      HX_GetROICHeader(&HX, ROICHeader); 
      HX_PrintROICHeader(ROICHeader);
    }
    else 
    {
       PRINT("** AUCUN ROIC_HEADER VALIDE!!!! GROSSE ERREUR  \n");
    }
   
     //do the same with the footer
   if (HX_FooterValid(&HX) == 1)
    {
         HX_GetROICFooter(&HX, ROICFooter);  
         HX_PrintROICFooter(ROICFooter);
    }
    else 
    {
       PRINT("** AUCUN ROIC_FOOTER VALIDE!!!! GROSSE ERREUR  \n");
    
    }        
    
     
   PRINT("*******************************\n");
   PRINT("** Starting switch HX_SW_PASSTHRU  \n");
   PRINT("*******************************\n");
   
   // Set the dataflow switch
     HX_ControlSW(&HX, HX_SW_PASSTHRU);        //HX_SW_PASSTHRU     HX_SW_PROCESS

   // Start the pattern genrator.
  PG_Start(&PG, &DP_Cfg_PG, AcqNum);
   
   // Print config for debug purposes...
  PG_PrintConfig(&PG);

  while(PG_Done(&PG) != 1)
     {
       //Wait until Pattern Generator is done.
      } 
   
   // Stop the pattern genrator.
   PG_Stop(&PG);
   
   // Now  Check if a header is valid, if so, read it and print it.
   
   if (HX_HeaderValid(&HX) == 1)
    {
      HX_GetROICHeader(&HX, ROICHeader); 
      HX_PrintROICHeader(ROICHeader);
    }
    else 
    {
       PRINT("** AUCUN ROIC_HEADER VALIDE!!!! GROSSE ERREUR  \n");
    }
   
     //do the same with the footer
   if (HX_FooterValid(&HX) == 1)
    {
         HX_GetROICFooter(&HX, ROICFooter);  
         HX_PrintROICFooter(ROICFooter);
    }
    else 
    {
       PRINT("** AUCUN ROIC_FOOTER VALIDE!!!! GROSSE ERREUR  \n");
    
    }        
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
   
 
 
  // 
//   // Send the config through RocketIO
//  
//   PG_SendDPConfig(&PG, DP_Cfg_PG); // en attendant la mAJ du PG par OBO
//   HX_PrintDPConfig(&DP_Cfg_PG);  // en attendant la mAJ du PG par OBO
////     
//     while(PG_Done(&PG) != 1)
//    {
//      // Wait until Pattern Generator is done. (ie qu'on soit certain que la Config est envoyée)
//   } 
//   
//   // on arrête le PG ce qui a pour effet de faire sortir la FSM de l'etat WAIT_PPC et de le faire retourner à l'état IDLE   
//    PG_Stop(&PG);
//    
    
   // Check if a config is valid, if so, read it.
   
   //if (HX_NewConfigArrived(&HX) == 1)
//    {     
//        HX_GetConfig(&HX, &DP_Cfg_HX);  // cette fonction verifie elle-meme  la validité de la DP_Config , en testbench, si config non valid, on laisse la machine dans une boucle infinie. Certes en Hardware, le PPC doit se char
//        // Print it to the console for comparison.
//        HX_PrintDPConfig(&DP_Cfg_HX);
//    }
//   else 
//    {
//       PRINT("** AUCUNE CONFIG VALIDE!!!! GROSSE ERREUR  \n");
//    
//    }
//   
   PRINT("** testbench Done!  \n");
   PRINT("*******************************\n");      

}



