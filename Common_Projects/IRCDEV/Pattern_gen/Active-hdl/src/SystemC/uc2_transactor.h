#ifndef __UC2_TRANSACTOR_H__
#define __UC2_TRANSACTOR_H__

#include <systemc.h>
#include "uc2_transactor_if.h"


class uc2_transactor : public uc2_transactor_port_if,
		public uc2_transactor_task_if
{
public:
		uc2_transactor(sc_module_name nm) : uc2_transactor_port_if(nm) {};

public:
		virtual void initialize(); 
		virtual void ppc_instruction_delay(int n_inst);
		virtual unsigned long rd_gpio();
		virtual void wr_gpio(unsigned long data);
		virtual void ppc_wait_us(unsigned int useconds);
		virtual void XTime_GetTime(unsigned long long *ticks);
};

#endif // __UC2_TRANSACTOR_H__
