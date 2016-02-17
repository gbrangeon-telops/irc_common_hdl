/*-----------------------------------------------------------------------------
--
-- Title       : Header Extractor Driver
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

#ifndef __HEADER_X_H__
#define __HEADER_X_H__

#include "xbasic_types.h"
#include "DPB_defines.h"

// ROIC header/footer 16-bit array lengths. These MUST be identical to the length of
// ROIC_DCube_Header_array16 and
// ROIC_DCube_Footer_array16 defined in CAMEL_Define.vhd
//#define ROIC_HEADER_LEN 12     //mis en comm par ENO car se retrouve deja dans DPB_define
//#define ROIC_FOOTER_LEN 16    //mis en comm par ENO car se retrouve deja dans DPB_define
//typedef Xuint16 t_ROIC_DCube_Header_array16[ROIC_HEADER_LEN];   //mis en comm par ENO car se retrouve deja dans DPB_define
//3typedef Xuint16 t_ROIC_DCube_Footer_array16[ROIC_FOOTER_LEN];  //mis en comm par ENO car se retrouve deja dans DPB_define

#define HX_SW_PROCESS   0
#define HX_SW_PASSTHRU  1
#define HX_SW_BLOCK     3

struct s_HeaderXConfig
{					   
   Xuint32 Size;        // Number of config elements, excluding Size and ADD.
   Xuint32 ADD;   
                
   // There is no further config in the structure.                   
};
typedef struct s_HeaderXConfig t_HeaderXConfig;

// Function prototypes
#define HX_Ctor(add) { sizeof(t_HeaderXConfig)/4 - 2, add }

void HX_ControlSW(t_HeaderXConfig *a, Xuint32 Sel);
        
//Xuint32 HX_NewConfigArrived(t_HeaderXConfig *a); 
//Xuint32 HX_HeaderValid(t_HeaderXConfig *a);
//Xuint32 HX_FooterValid(t_HeaderXConfig *a);

//void HX_GetConfig(const t_HeaderXConfig *a, t_DPConfig *b);
void HX_PrintDPConfig(const t_DPConfig *a);                   /* For debug only */

void HX_GetROICHeader(const t_HeaderXConfig *a, t_ROIC_DCube_Header_array16 b);
void HX_GetROICFooter(const t_HeaderXConfig *a, t_ROIC_DCube_Footer_array16 b);
void HX_GetNAVFooter(const t_HeaderXConfig *a, t_ROIC_DCube_Nav_array16 b);

void HX_PrintROICHeader(const t_ROIC_DCube_Header_array16 a); /* For debug only */
void HX_PrintROICFooter(const t_ROIC_DCube_Footer_array16 a); /* For debug only */

#endif //__HEADER_X_H__
