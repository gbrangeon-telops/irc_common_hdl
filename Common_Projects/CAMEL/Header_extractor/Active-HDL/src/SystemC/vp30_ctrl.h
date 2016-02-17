#ifndef __VP30_CTRL_H__
#define __VP30_CTRL_H__

#include <systemc.h>
#include "uc2_transactor.h"	

#define NO_INST_DELAY // No PowerPC added instruction delays
		  
class vp30_ctrl : public sc_module
{
public:
	sc_port<uc2_transactor_task_if> transactor_interface;

	SC_CTOR(vp30_ctrl)
	{
		SC_THREAD(main);
	}

	void main();

};

#endif //__VP30_CTRL_H__



