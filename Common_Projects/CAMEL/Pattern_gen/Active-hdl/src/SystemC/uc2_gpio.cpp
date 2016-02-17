//----------------------------------------------------------------------------
// Filename:     uc2_gpio.c
// 
// Description:   GPIO Interface Module 
// 
//-----------------------------------------------------------------------------
#include "uc2_gpio.h" 	

//#define VERBOSE

#ifdef VERBOSE
   #include <iostream.h>
   #include <iomanip>   
#endif

extern sc_port<uc2_transactor_task_if> *global_trans_ptr;

void WB_write16( Xuint16 data, Xuint16 add)
{
	Xuint32 uc2_out;
	Xuint32 uc2_in;
	
	// Write on wishbone bus
	uc2_out = data | ((Xuint32)add << 16) | 0xB0000000;
	(*global_trans_ptr)->ppc_instruction_delay(4);
	(*global_trans_ptr)->wr_gpio(uc2_out); 		
	
	#ifdef VERBOSE 
   	cout << "WB_write16: add: 0x" << hex << add << '\n';
   	cout << "WB_write16: data: 0x" << hex << data << '\n';	
   	cout << "WB_write16: uc2_out: 0x" << hex << uc2_out << '\n';
	#endif	

	// Wait for ack
	do 
	{ 
		(*global_trans_ptr)->ppc_instruction_delay(1);
		uc2_in = (*global_trans_ptr)->rd_gpio();
		(*global_trans_ptr)->ppc_instruction_delay(1);
	}
	while ((uc2_in & 0x00010000) == 0x00000000);


	// Send ack	 
	(*global_trans_ptr)->wr_gpio(0xC0000000);		   
	(*global_trans_ptr)->ppc_instruction_delay(2);
}

void WB_write32( Xuint32 data, Xuint16 add)
{
	Xuint16 uc2_out;
	//PRINTF("write32: 32-bit data= %d\n", data);	
	//PRINTF("write32: high part= %d add= %d\n", uc2_out, add);	
	// Write high part first
	uc2_out = (data & 0xFFFF0000) >> 16;
	WB_write16(uc2_out, add);
   //	#ifdef VERBOSE 
   //   	cout << "WB_write32: add: 0x" << hex << add << '\n';
   //   	cout << "WB_write32: data: 0x" << hex << data << '\n';
   //   	cout << "WB_write32: uc2_out: 0x" << hex << uc2_out << '\n';		
   //	#endif	
	
	uc2_out = data & 0x0000FFFF;
	//PRINTF("write32: low part= %d add= %d\n", uc2_out, add+1);
	WB_write16(uc2_out, add+1);	
}

Xuint16 WB_read16(Xuint16 add)
{
	Xuint32 uc2_out;
	Xuint32 uc2_in;
	Xuint32 data;

	// Write on wishbone bus 
	uc2_out = ((Xuint32)add << 16) | 0xA0000000;
	(*global_trans_ptr)->ppc_instruction_delay(3);
	(*global_trans_ptr)->wr_gpio(uc2_out); 		

	// Wait for ack
	do 
	{	
		(*global_trans_ptr)->ppc_instruction_delay(1);
		uc2_in = (*global_trans_ptr)->rd_gpio();
		(*global_trans_ptr)->ppc_instruction_delay(1);
	}
	while ((uc2_in & 0x00010000) == 0x00000000);
	
	data = uc2_in & 0x0000FFFF;	 
	(*global_trans_ptr)->ppc_instruction_delay(1);

	// Send ack	 
	(*global_trans_ptr)->wr_gpio(0xC0000000);
	
	(*global_trans_ptr)->ppc_instruction_delay(2);
	return (Xuint16)data;		
}

Xuint32 WB_read32(Xuint16 add)
{
	Xuint16 data_low;
	Xuint16 data_high;
	
	data_high = WB_read16(add);
	data_low = WB_read16(add+1);

	return (Xuint32)(data_high << 16 | data_low);		
}





