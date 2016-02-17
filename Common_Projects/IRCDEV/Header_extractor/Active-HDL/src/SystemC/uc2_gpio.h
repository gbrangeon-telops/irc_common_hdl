#ifndef __UC2_GPIO_H__
#define __UC2_GPIO_H__

#include <systemc.h> 
#include "xbasic_types.h"
#include "uc2_transactor.h"

void WB_write16( Xuint16 data, Xuint16 add);
Xuint16 WB_read16(Xuint16 add);
void WB_write32( Xuint32 data, Xuint16 add);
Xuint32 WB_read32(Xuint16 add);


//#define WB_WRITE16(a, b) (WB_write16((a), (b)))
//#define WB_READ16(a) (WB_read16((a))) 
//#define WB_WRITE32(a, b) (WB_write32((a), (b)))
//#define WB_READ32(a) (WB_read32((a)))

#endif //__UC2_GPIO_H__





