//-----------------------------------------------------------------------------
//
// Title       : uc2_model
// Design      : uc2
// Author      : Patrick Dubois
// Company     : Radiocommunication and Signal Processing Laboratory (LRTS)
//
//-----------------------------------------------------------------------------
//
// File        : uc2_model.h
// Generated   : 15:21:50 18 mai, 2006
// From        : SystemC Source Wizard
// By          : SystemC Source Wizard ver. 1.0
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

#ifndef __uc2_model_h__
#define __uc2_model_h__

#include <systemc.h>   
#include "uc2_transactor.h"
#include "vp30_ctrl.h"

SC_MODULE( uc2_model )
{

	sc_in< sc_logic > SYS_CLK;
	sc_in< sc_logic > SYS_RST;
	sc_in< sc_logic > INTERRUPT;
	sc_in< sc_lv< 32 > > GPIO_IN;
	sc_out< sc_lv< 32 > > GPIO_OUT;	  
	
	vp30_ctrl 		*p_ctrl;
	uc2_transactor 	*p_uc2_trans;

	SC_CTOR( uc2_model ):
		SYS_CLK("SYS_CLK"),
		SYS_RST("SYS_RST"),
		INTERRUPT("INTERRUPT"),
		GPIO_IN("GPIO_IN"),
		GPIO_OUT("GPIO_OUT")
	{				
		p_ctrl = new vp30_ctrl("ctrl");
		p_uc2_trans = new uc2_transactor("uc2_trans");
		
		p_uc2_trans-> SYS_CLK(SYS_CLK);
		p_uc2_trans-> SYS_RST(SYS_RST); 
		p_uc2_trans-> INTERRUPT(INTERRUPT);
		p_uc2_trans-> GPIO_IN(GPIO_IN);
		p_uc2_trans-> GPIO_OUT(GPIO_OUT); 
		
		p_ctrl->transactor_interface.bind(*p_uc2_trans);

	}

	~uc2_model()
	{
     	delete p_ctrl;
		delete p_uc2_trans;
	}

};

SC_MODULE_EXPORT( uc2_model )

#endif //__uc2_model_h__

