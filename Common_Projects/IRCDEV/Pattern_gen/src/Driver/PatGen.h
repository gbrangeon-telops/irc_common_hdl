#ifndef __PATGEN_H__
#define __PATGEN_H__

#include "xbasic_types.h"
#include "DPB_defines.h"

struct s_PatGenConfig
{
   Xuint32 Size;        // Number of config elements, excluding Size and ADD.
   Xuint32 ADD;
      
   Xuint32        DiagMode;	            // Mode;	                        
   Xuint32        ZSIZE;	               // ZSIZE;	                        
   Xuint32        XSIZE;	               // XSIZE_ADJ;	                                       
   Xuint32        YSIZE;	               // YSIZE;	                                          
   Xuint32        TAGSIZE;                // TAGSIZE_P1;                                                		   	   	   	   
   Xuint32        DiagSize;               // DiagAcqNum; 
   Xuint32        PayloadSize;            //	DataSize_M1;
   Xuint32        ImagePause;             //	DataSize_M1;
   Xuint32        ROM_Z_START;	         // This is the Z position where we start incrementing the ROM address
   Xuint32        ROM_INIT_INDEX;	      // This is the init address used for the ROM
   Xuint32        ImgSize;                 // XSIZE*YSIZE
   Xuint32        CONFIG;                 // CONFIG;     
};
typedef struct s_PatGenConfig t_PatGenConfig;

void PG_SendDPConfig( t_PatGenConfig *a,  t_DPConfig b);
void PG_Start(t_PatGenConfig *a,t_DPConfig *b, Xuint32 MissingImages);
void PG_Stop(const t_PatGenConfig *a);
void PG_PrintConfig(const t_PatGenConfig *a);
Xuint32 PG_Done(t_PatGenConfig *a);


#define PG_Ctor(add) {sizeof(t_PatGenConfig)/4 - 2, add, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }                           



#endif //__PATGEN_H__
