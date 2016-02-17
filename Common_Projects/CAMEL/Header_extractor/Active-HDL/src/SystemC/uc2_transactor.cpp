#include "uc2_transactor.h"
#include <systemc.h>
//#include "DPB_defines.h"
#include "xparameters.h"

//#define NO_INST_DELAY

void uc2_transactor::initialize()
{  
	GPIO_OUT.write(0x00000000);
	while( SYS_RST.read() != '0' ) 
	{
		wait( SYS_CLK.posedge_event() );
	}
	wait( SYS_CLK.posedge_event() );
}		   

void uc2_transactor::ppc_instruction_delay(int n_inst)
{						 
	int i;
	#ifdef NO_INST_DELAY
		i = n_inst*4 - 1;
	#else
		i = 0;
	#endif
		
	for (i; i<n_inst*4; ++i)
	{
		wait( SYS_CLK.posedge_event() );
	}
	
}

unsigned long uc2_transactor::rd_gpio()
{ 
	sc_uint<32> data;	
	ppc_instruction_delay(1);
	data = GPIO_IN.read();
	return data;
}


void uc2_transactor::wr_gpio(unsigned long data)
{
	ppc_instruction_delay(1);
	GPIO_OUT.write(data);
}

void uc2_transactor::ppc_wait_us(unsigned int useconds)
{
   unsigned int clock_ticks = XPAR_CPU_PPC405_CORE_CLOCK_FREQ_HZ / 1000000 * useconds;
   for (unsigned int i=0; i<clock_ticks; ++i)
	{
		wait( SYS_CLK.posedge_event() );
	}
   
}

void uc2_transactor::XTime_GetTime(unsigned long long *ticks)
{
   unsigned long now_ns;
   now_ns = (unsigned long)(sc_simulation_time()/1000);
   
   *ticks = (XPAR_CPU_PPC405_CORE_CLOCK_FREQ_HZ/100000000) * now_ns ;      
}

