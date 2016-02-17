/*-----------------------------------------------------------------------------
--
-- Title       : Sub-module testbench example
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
#include "tmi_ll_lut.h"
#include "xcache_l.h"


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
   t_LUT LUT = LUT_Ctor(GPIO_WBADD);
   float xmin = 1000;
   float xmax = 7000;
   float lutsize = 1024;
   uint8_t filter_num = 0;
   
   #ifdef SIM
      global_trans_ptr = &transactor_interface;
   #endif   
   
   
   PRINT("Testing TMI_LL_LUT.. \n");

   LUT_SendConfig(&LUT, xmin, xmax, lutsize, filter_num);
   
   PRINT("TMI_LL_LUT Testing Finished... \n");
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
