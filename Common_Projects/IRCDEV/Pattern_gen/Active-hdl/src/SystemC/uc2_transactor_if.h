#ifndef __UC2_TRANSACTOR_IF_H__
#define __UC2_TRANSACTOR_IF_H__

#include <systemc.h>
#include "uc2_transactor_args.h"


class uc2_transactor_task_if : virtual public sc_interface
{
public:
		virtual void initialize() = 0;
		virtual void ppc_instruction_delay(int n_inst) = 0;
		virtual unsigned long rd_gpio() = 0;
		virtual void wr_gpio(unsigned long data) = 0;
		virtual void ppc_wait_us(unsigned int useconds) = 0;
		virtual void XTime_GetTime(unsigned long long *ticks) = 0;
};


class uc2_transactor_port_if : public sc_module
{
	public:
		sc_out<sc_lv<32> > GPIO_OUT;
		sc_in<sc_lv<32> > GPIO_IN;
		sc_in<sc_logic > INTERRUPT;
		sc_in<sc_logic > SYS_CLK;
		sc_in<sc_logic > SYS_RST;

	uc2_transactor_port_if(sc_module_name nm) : sc_module(nm),
			GPIO_OUT("GPIO_OUT"),
			GPIO_IN("GPIO_IN"),
			INTERRUPT("INTERRUPT"),
			SYS_CLK("SYS_CLK"),
			SYS_RST("SYS_RST")
	{}
};



#endif // __UC2_TRANSACTOR_IF_H__
