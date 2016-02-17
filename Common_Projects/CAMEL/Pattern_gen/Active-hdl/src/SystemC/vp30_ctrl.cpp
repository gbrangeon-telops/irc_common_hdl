//----------------------------------------------------------------------------


#include "xbasic_types.h"
#include "xtime_l.h"
#include "xparameters.h"
#include "utils.h"
#include "PatGen.h"
#include "DPB_defines.h"

#ifdef SIM
   #include "vp30_ctrl.h"
   #include "uc2_gpio.h"
#else
   #include "gpio.h"
#endif

static void StartPatGenTB();
#define PG_ADD      0x0200    // This define should be in DPB_Defines.h

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
   StartPatGenTB();  

   #ifndef SIM
      return 0;
   #endif

}  // } main

 //--------------------------------------------
// PATTERN_GEN_TEST_BENCH  START
//----------------------------------------------

static void StartPatGenTB()
{
   t_PatGenConfig    PG = PG_Ctor(PG_ADD);
   t_DPConfig        DP_Cfg;
   Xuint32           AcqNum = 1;

   WAIT_US(1);

   // Test_bench Config
   DP_Cfg.ZSIZE         = 15; //12
   DP_Cfg.XSIZE         = 8;
   DP_Cfg.YSIZE         = 15;//                            
   DP_Cfg.TAGSIZE       = 8;
   DP_Cfg.SB_Min        = 414;
   DP_Cfg.SB_Max        = 700;
   DP_Cfg.SB_Mode       = NON_CROPPED;
   DP_Cfg.Interleave    = BIP;
   DP_Cfg.Mode      = DIAG_IGM;
   DP_Cfg.AVGSIZE       = 1;
   DP_Cfg.IMGSIZE = (DP_Cfg.XSIZE) * DP_Cfg.YSIZE;

   DP_Cfg.Delta_OPD  = 2.5312e-4;
   DP_Cfg.Rad_Exp    = 31;  // 30 on the whole range but 31 on the range where the FIRST is sensitive
   DP_Cfg.Gain_Exp   = -12; // This needs to be fine-tuned depending on the noise of the instrument
   DP_Cfg.Off_Exp    = -4;  // This needs to be fine-tuned depending on the noise of the instrument
   DP_Cfg.Lh_Exp     = -2;  // This could be calculated automatically
   DP_Cfg.dLbb_Exp   = -27; // This could be calculated automatically   

  
   PRINT("*******************************\n");
   PRINT("** Starting PatGen testbench.  \n");
   PRINT("*******************************\n");

   // Start the pattern genrator.
   PG_Start(&PG, &DP_Cfg, AcqNum);
   
   // Print config for debug purposes...
   PG_PrintConfig(&PG);
  
   while(PG_Done(&PG) != 1)
   {
      // Wait until Pattern Generator is done.
   } 
   
   //if (PG_Done(&PG) = 1)
//   {// Stop the pattern genrator.
      PG_Stop(&PG);
   //}
   PRINT("** PatGen testbench Done!  \n");
   PRINT("*******************************\n");      
    
}



