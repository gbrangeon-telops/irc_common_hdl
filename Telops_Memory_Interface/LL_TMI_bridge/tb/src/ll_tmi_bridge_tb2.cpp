/*-----------------------------------------------------------------------------
--
-- Title       : Sub-module testbench example
-- Author      : Patrick Dubois/modif Jean-Alexis Boulet
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
#include "ll_tmi_bridge.h"
#include "xcache_l.h"
#include "wb_lowlevel.h"


#ifdef SIM
   #include <stdarg.h> // To support ... argument in printf
   #include "roic_ctrl.h"
   #include <iostream.h>
   #include <iomanip>   
#endif

static void Init();
static void StartSubModuleTB();

// Global variables

#ifdef SIM
   sc_port<uct_transactor_task_if> *global_trans_ptr;
   void roic_ctrl::main()
#else
   int main()
#endif
{      
   t_LLTMI_Bridge LLTMI = LLTMI_Bridge_Ctor(GPIO_WBADD);
   GeniCam_Registers_Set_t GCRegs;
   LLTMI_mode_t MemAccessMode;

   #ifdef SIM
      global_trans_ptr = &transactor_interface;
   #endif   
   
   
   GCRegs.WidthMax = 16;
   GCRegs.HeightMax = 16;
   GCRegs.Width = 16;
   GCRegs.Height = 16;
   GCRegs.OffsetX = 0;
   GCRegs.OffsetY = 0;
   
   PRINT("Testing LL_TMI_Bridge.. \n");

   MemAccessMode = LLTMI_WRITE;
   
   PRINT("Sending Write Config.. \n");
   LLTMI_SendConfigGC(&LLTMI, &GCRegs, MemAccessMode, LL_TMI_BRIDGE_IMAGE_FRAME, LL_TMI_BRIDGE_SINGLE_IMAGE,0);
   
   PRINT("Starting Writing.. \n");
   LLTMI_Start(&LLTMI);
   
   while(LLTMI_Done(&LLTMI) == IRC_NOT_DONE)
   {}
   MemAccessMode = LLTMI_READ;
   
   PRINT("Sending Read Config.. \n");
   LLTMI_UpdateFBConfig(&LLTMI, &GCRegs, MemAccessMode, LL_TMI_BRIDGE_IMAGE_FRAME, LL_TMI_BRIDGE_SINGLE_IMAGE,0);

   PRINT("Starting Reading.. first Frame \n");
   LLTMI_Start(&LLTMI);

   while(LLTMI_Done(&LLTMI) == IRC_NOT_DONE)
   {}
   
   WB_write32(1,LLTMI.ADD + 0x40);
   PRINT("Starting Reading.. second Frame \n");
   LLTMI_Start(&LLTMI);

   while(LLTMI_Done(&LLTMI) == IRC_NOT_DONE)
   {}
 

 
   PRINT("LL_TMI_Bridge Testing Finished... \n");
//   Init();
   //PRINT("Init() returned.\n");
   
//   PRINT("StartSubModuleTB... \n");
//   StartSubModuleTB();  

   #ifndef SIM
      return 0;
   #endif

}  // } main     

void Init()
{
   #ifdef SIM
      (*global_trans_ptr)->initialize(); 
   #else
      XCache_EnableICache(0x80000000);
      XCache_EnableDCache(0x80000000); 
   #endif    

} 


//void StartSubModuleTB()
//{
//   uint32_t data;
//   
//   // Here the idea is to test AT LEAST each function of the driver.
//   // We should also try to test the submodule in each of its different configurations.
//
//   PRINT("Setting leds to 1010... \n");
//   SetLeds(0xA);
//   
//   PRINT("Setting leds to 0101... \n");
//   SetLeds(0x5);
//   
//   PRINT("Resetting errors... \n");
//   Reset_Errors();
//   
//   data = GetJumpers();
//   PRINTF("Jumpers value = 0x%X\n", data);
//   
//   data = GetFPGATemp();
//   PRINTF("FPGA temp = 0x%X\n", data);
//   
//   data = GetPCBTemp();
//   PRINTF("PCB temp = 0x%X\n", data);     
//   
//   data = GetJumpers();
//   SetLeds(data);  
//
//      
//   #ifdef SIM
//      PRINT("SubModule testbench is done.");
//   #endif
//}                   
