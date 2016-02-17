/*******************************************************************
*          *********   ******   *        ******   *****   *****    *
*             *       *        *        *    *   *   *   *         *
*            *       ******   *        *    *   *****   *****      *
*           *       *        *        *    *   *           *       *
*          *       ******   ******   ******   *       *****        *
********************************************************************
  Copyright (c) Telops Inc. 2009
********************************************************************
  Project: IRCDEV
  
  Board : ROIC
  
  Description: Header file for PPC to access the expantion board 
               resources. 
  
  Revisions: 1.00 a -- Initial version  
********************************************************************/


#define EXPBOARD_BASEADDRS
#define EXPBOARD_RS232_OFFSET (EXPBOARD_BASEADDRS + )
#define EXPBOARD_REGS_OFFSET  (EXPBOARD_BASEADDRS + )

//Registers offsets 
#define Expb_Reg_0_OFFSET	 EXPBOARD_REGS_OFFSET 
#define Expb_Reg_1_OFFSET    (Expb_Reg_0_OFFSET  + 0x4)
#define Expb_Reg_2_OFFSET    (Expb_Reg_1_OFFSET  + 0x4)
#define Expb_Reg_3_OFFSET    (Expb_Reg_2_OFFSET  + 0x4)
#define Expb_Reg_4_OFFSET    (Expb_Reg_3_OFFSET  + 0x4)
#define Expb_Reg_5_OFFSET    (Expb_Reg_4_OFFSET  + 0x4)
#define Expb_Reg_6_OFFSET    (Expb_Reg_5_OFFSET  + 0x4)
#define Expb_Reg_7_OFFSET    (Expb_Reg_6_OFFSET  + 0x4)
#define Expb_Reg_8_OFFSET    (Expb_Reg_7_OFFSET  + 0x4)
#define Expb_Reg_9_OFFSET    (Expb_Reg_8_OFFSET  + 0x4)
#define Expb_Reg_10_OFFSET   (Expb_Reg_9_OFFSET  + 0x4)
#define Expb_Reg_11_OFFSET   (Expb_Reg_10_OFFSET + 0x4)
#define Expb_Reg_12_OFFSET   (Expb_Reg_11_OFFSET + 0x4)
#define Expb_Reg_13_OFFSET   (Expb_Reg_12_OFFSET + 0x4)
#define Expb_Reg_14_OFFSET   (Expb_Reg_13_OFFSET + 0x4)
#define Expb_Reg_15_OFFSET   (Expb_Reg_14_OFFSET + 0x4)
#define Expb_Reg_16_OFFSET   (Expb_Reg_15_OFFSET + 0x4)
#define Expb_Reg_17_OFFSET   (Expb_Reg_16_OFFSET + 0x4)
#define Expb_Reg_18_OFFSET   (Expb_Reg_17_OFFSET + 0x4)
#define Expb_Reg_19_OFFSET   (Expb_Reg_18_OFFSET + 0x4)
#define Expb_Reg_20_OFFSET   (Expb_Reg_19_OFFSET + 0x4)
#define Expb_Reg_21_OFFSET   (Expb_Reg_20_OFFSET + 0x4)
#define Expb_Reg_22_OFFSET   (Expb_Reg_21_OFFSET + 0x4)

//RS232 offsetes
#define RS232_0_OFFSET		 (EXPBOARD_RS232_OFFSET + 0x4)
#define RS232_1_OFFSET		 (EXPBOARD_RS232_OFFSET + 0x8)
#define RS232_2_OFFSET		 (EXPBOARD_RS232_OFFSET + 0xC)
#define RS232_3_OFFSET		 (EXPBOARD_RS232_OFFSET + 0x10)
#define RS232_4_OFFSET		 (EXPBOARD_RS232_OFFSET + 0x14)




/*******************************************************************
* Functions prototypes
*******************************************************************/

void Expb_WriteReg(uint32_t Expb_Reg_BaseAdds, uint16_t data );

uint16_t Expb_ReadReg(uint32_t Expb_Reg_BaseAdds);

void uint8_t SerialLink_SendByte(uint32_t RS232_BaseAddrs, uint8_t Data);

uint8_t SerialLink_RecvByte(uint32_t RS232_BaseAddrs);

uint8_t SerialLink_mIsReceiveEmpty(uint32_t RS232_BaseAddrs);

uint8_t SerialLink_mIsTransmitFull(uint32_t RS232_BaseAddrs);
    
