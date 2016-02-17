/* $Id$ */
/****************************************************************************/
/**
*
* @file LL_TMI_Bridge.cpp
* 
* For a description, see the LL_TMI_Bridge.h file.
* 
* Author(s) : Patrick Dubois
*
*****************************************************************************/

#include "LL_TMI_Bridge.h"
#include "utils.h"
#include "wb_lowlevel.h"
//#include "stdlib.h"

#define LL_TMI_BRIDGE_WR_CONTROL 0x00
#define LL_TMI_BRIDGE_WR_CONFIG 0x08

#define LL_TMI_BRIDGE_RD_CONTROL 0x1C
#define LL_TMI_BRIDGE_RD_CONFIG 0x20
#define LL_TMI_RD_START_ADD   0x24
#define LL_TMI_RD_END_ADD     0x28
#define LL_TMI_RD_STEP_ADD     0x2C
#define LL_TMI_RD_WIDTH     0x30
#define LL_TMI_RD_SKIP     0x34

#define LL_TMI_BRIDGE_SWITCH 0x38
#define LL_TMI_BRIDGE_STATUS 0x3C

#define LL_TMI_BRIDGE_READ_ID 0x40

#define LL_TMI_BRIDGE_WERROR_MSK 0x00000001
#define LL_TMI_BRIDGE_RERROR_MSK 0x00000002
#define LL_TMI_BRIDGE_WCFG_DONE_MSK 0x00000004
#define LL_TMI_BRIDGE_RCFG_DONE_MSK 0x00000008
#define LL_TMI_BRIDGE_WCFG_IN_PROGRESS_MSK 0x00000010
#define LL_TMI_BRIDGE_RCFG_IN_PROGRESS_MSK 0x00000020

#define LL_TMI_BRIDGE_START 0x01
#define LL_TMI_BRIDGE_STOP 0x02
#define LL_TMI_BRIDGE_IMM_STOP 0x04

#define LL_TMI_BRIDGE_LOOP 0x01
#define LL_TMI_BRIDGE_GEN_SOA 0x02
#define LL_TMI_BRIDGE_GEN_EOA 0x04
#define LL_TMI_BRIDGE_GEN_SOL 0x08
#define LL_TMI_BRIDGE_GEN_EOL 0x10

#define MAXLOSTRATIO 1.2
#define NTSC_WIDTH 720
#define NTSC_HEIGHT 480
#define PAL_WIDTH 720
#define PAL_HEIGHT 576




void LLTMI_SendConfigGC(t_LLTMI_Bridge *pObj, const GeniCam_Registers_Set_t *pGCRegs, LLTMI_mode_t mode, uint8_t frame, uint8_t image, uint32_t page)
{
   uint32_t u8_switch;
   uint32_t AddOffset;    
   
   AddOffset = pGCRegs->WidthMax * pGCRegs->HeightMax * page;
   
   //Pour compatibilité avec les module qui ont été développer sans la variable STEP.
   pObj->RD_STEP_ADD = 1;
   pObj->WR_STEP_ADD = 1;
   
   if(mode == LLTMI_READ)
   {
      
      pObj->RD_START_ADD = (pGCRegs->OffsetY * pGCRegs->WidthMax) + pGCRegs->OffsetX + AddOffset;
      
      pObj->RD_END_ADD = ((pGCRegs->OffsetY + pGCRegs->Height - 1) * pGCRegs->WidthMax) + pGCRegs->OffsetX + pGCRegs->Width -1 + AddOffset;
            
      pObj->RD_SKIP = pGCRegs->WidthMax - pGCRegs->Width + pObj->RD_STEP_ADD;

      pObj->RD_WIDTH = pGCRegs->Width - pObj->RD_STEP_ADD;
      
      if(frame == LL_TMI_BRIDGE_LINE_FRAME)
      {
         if(image == LL_TMI_BRIDGE_SINGLE_IMAGE)
         {
            pObj->RD_CONFIG = 0x18;
         }
         else if(image == LL_TMI_BRIDGE_LOOP_IMAGE)
         {
            pObj->RD_CONFIG = 0x19;
         }
      }
      else if(frame == LL_TMI_BRIDGE_IMAGE_FRAME)
      {
         if(image == LL_TMI_BRIDGE_SINGLE_IMAGE)
         {
            pObj->RD_CONFIG = 0x06;
         }
         else if(image == LL_TMI_BRIDGE_LOOP_IMAGE)
         {
            pObj->RD_CONFIG = 0x07;
         }
      }
      
      u8_switch = 1;
   }
   else if (mode == LLTMI_WRITE)
   {
      // OffsetY *WidthMax + OffsetX
      pObj->WR_START_ADD = (pGCRegs->OffsetY * pGCRegs->WidthMax) + pGCRegs->OffsetX;
      // (OffsetY+Height) * WidthMax + (Offsetx + Width)
      pObj->WR_END_ADD = ((pGCRegs->OffsetY + pGCRegs->Height -1) * pGCRegs->WidthMax) + pGCRegs->OffsetX + pGCRegs-> Width -1;
      // WidthMax -Width+ OffsetX
      pObj->WR_SKIP = pGCRegs->WidthMax - pGCRegs->Width + 1;
      
      pObj->WR_WIDTH = pGCRegs->Width - 1; // Remove 1 because we start at 0000

      pObj->WR_CONFIG = image;
      
      //DEBUG
      //PRINTF("WidthMax:%x, HeightMax:%x, offsetX:%x, offsetY:%x, addoffset:%x TOTAL MAX:%x \n",pGCRegs->WidthMax,pGCRegs->HeightMax,pGCRegs->OffsetX,pGCRegs->OffsetY,AddOffset,pGCRegs->WidthMax*pGCRegs->HeightMax);
      //PRINTF("WIDTH:%x, STEP:%x SKIP:%x START2:%x END2:%x\n",pObj->WR_WIDTH,pObj->WR_STEP_ADD,pObj->WR_SKIP,pObj->WR_START_ADD,pObj->WR_END_ADD );
      u8_switch = 0;
   }
   else
   {
      PRINT("Error in LLTMI_SendConfigGC()\n");  
   }

   WriteStruct(pObj);
   WB_write32(u8_switch,pObj->ADD + LL_TMI_BRIDGE_SWITCH);
   
}

void LLTMI_UpdateReadID(t_LLTMI_Bridge *pObj, const GeniCam_Registers_Set_t *pGCRegs, uint8_t frame, uint8_t image, uint32_t page,uint32_t ID)
{  
   //Set the active Read register. ID start at 0; 
   WB_write32(ID,pObj->ADD + LL_TMI_BRIDGE_READ_ID);
   
   WB_write32(pObj->RD_CONFIG, pObj->ADD + LL_TMI_BRIDGE_RD_CONFIG);
   WB_write32(pObj->RD_START_ADD, pObj->ADD + LL_TMI_RD_START_ADD);
   WB_write32(pObj->RD_END_ADD, pObj->ADD + LL_TMI_RD_END_ADD);
   WB_write32(pObj->RD_STEP_ADD, pObj->ADD + LL_TMI_RD_STEP_ADD); 
   WB_write32(pObj->RD_WIDTH, pObj->ADD + LL_TMI_RD_WIDTH);
   WB_write32(pObj->RD_SKIP, pObj->ADD + LL_TMI_RD_SKIP);    
}

void LLTMI_UpdateNDFConfigGC(t_LLTMI_Bridge *pObj, const GeniCam_Registers_Set_t *pGCRegs, uint32_t page)
{  
   uint32_t AddOffset;    
   
   AddOffset = pGCRegs->WidthMax * pGCRegs->HeightMax * page;
      
   // The position of NDF has changed, we must update RD_START_ADD and RD_END_ADD accordingly.
   pObj->RD_START_ADD = (pGCRegs->OffsetY * pGCRegs->WidthMax) + pGCRegs->OffsetX + AddOffset;
   WB_write32(pObj->RD_START_ADD, pObj->ADD + LL_TMI_RD_START_ADD);
   
   pObj->RD_END_ADD = ((pGCRegs->OffsetY + pGCRegs->Height - 1) * pGCRegs->WidthMax) + pGCRegs->OffsetX + pGCRegs->Width -1 + AddOffset;   
   WB_write32(pObj->RD_END_ADD, pObj->ADD + LL_TMI_RD_END_ADD);   
}

IRC_Status LLTMI_Start(t_LLTMI_Bridge *pObj)
{
   uint8_t u8_switch;

   IRC_Status Status = IRC_FAILURE;
   
   u8_switch = (uint8_t) WB_read32(pObj->ADD + LL_TMI_BRIDGE_SWITCH);
   
   
   if (u8_switch == LLTMI_WRITE)
   {
      if(LLTMI_Done(pObj) == IRC_DONE)
      {
         WB_write32(0, pObj->ADD + LL_TMI_BRIDGE_WR_CONTROL);  // Reset to 0
         WB_write32(LL_TMI_BRIDGE_START, pObj->ADD + LL_TMI_BRIDGE_WR_CONTROL);  // Set to 1
         pObj->WR_CONTROL = LL_TMI_BRIDGE_START;  // Update Object
         Status = IRC_SUCCESS;
      }
      else
      {
         PRINT("LLTMI not done, can't start!\n");   
      }      
   }
   else if (u8_switch == LLTMI_READ)
   {
      if(LLTMI_Done(pObj) == IRC_DONE)
      {
         WB_write32(0, pObj->ADD + LL_TMI_BRIDGE_RD_CONTROL);  // Reset to 0
         WB_write32(LL_TMI_BRIDGE_START, pObj->ADD + LL_TMI_BRIDGE_RD_CONTROL);  // Set to 1
         pObj->WR_CONTROL = LL_TMI_BRIDGE_START;  // Update Object
         Status = IRC_SUCCESS;
      }
      else
      {
         PRINT("LLTMI not done, can't start!\n");   
      }
   }
   else
   {
      PRINT("Error in LLTMI_Start()\n");
   }   
      
  return Status;    
}

IRC_Status LLTMI_Stop(t_LLTMI_Bridge *pObj)
{
   uint8_t u8_switch;
   IRC_Status Status = IRC_FAILURE;
   
   u8_switch = WB_read32(pObj->ADD + LL_TMI_BRIDGE_SWITCH);
   
   
   if (u8_switch == LLTMI_WRITE)
   {
      WB_write32(LL_TMI_BRIDGE_STOP, pObj->ADD + LL_TMI_BRIDGE_WR_CONTROL);  // Set to 1
      pObj->WR_CONTROL = LL_TMI_BRIDGE_STOP;  // Update Object
      Status = IRC_SUCCESS;
   }
   else if (u8_switch == LLTMI_READ)
   {

      WB_write32(LL_TMI_BRIDGE_STOP, pObj->ADD + LL_TMI_BRIDGE_RD_CONTROL);  // Set to 1
      pObj->RD_CONTROL = LL_TMI_BRIDGE_STOP;  // Update Object
      Status = IRC_SUCCESS;
   }
   else
   {
      PRINT("Error in LLTMI_Stop()\n");
   }
      
  return Status;    
}

IRC_Status LLTMI_ImmediateStop(t_LLTMI_Bridge *pObj)
{
   uint8_t u8_switch;
   IRC_Status Status = IRC_FAILURE;
   
   u8_switch = WB_read32(pObj->ADD + LL_TMI_BRIDGE_SWITCH);
   
   
   if (u8_switch == LLTMI_WRITE)
   {
      WB_write32(LL_TMI_BRIDGE_IMM_STOP, pObj->ADD + LL_TMI_BRIDGE_WR_CONTROL);  // Set to 1
      pObj->WR_CONTROL = LL_TMI_BRIDGE_IMM_STOP;  // Update Object
      Status = IRC_SUCCESS;
   }
   else if (u8_switch == LLTMI_READ)
   {

      WB_write32(LL_TMI_BRIDGE_IMM_STOP, pObj->ADD + LL_TMI_BRIDGE_RD_CONTROL);  // Set to 1
      pObj->RD_CONTROL = LL_TMI_BRIDGE_IMM_STOP;  // Update Object
      Status = IRC_SUCCESS;
   }
   else
   {
      PRINT("Error in LLTMI_ImmediateStop()\n");
   }
      
  return Status;    
   
}

IRC_Status LLTMI_Done(t_LLTMI_Bridge *pObj)
{
   uint8_t u8_switch;
   IRC_Status Status = IRC_NOT_DONE;
   
   u8_switch = WB_read32(pObj->ADD + LL_TMI_BRIDGE_SWITCH);
   
   
   if (u8_switch == LLTMI_WRITE)
   {
      if((WB_read32(pObj->ADD + LL_TMI_BRIDGE_STATUS) & LL_TMI_BRIDGE_WCFG_DONE_MSK) == LL_TMI_BRIDGE_WCFG_DONE_MSK)
      {
         Status = IRC_DONE;
      }
   }
   else if (u8_switch == LLTMI_READ)
   {
      if((WB_read32(pObj->ADD + LL_TMI_BRIDGE_STATUS) & LL_TMI_BRIDGE_RCFG_DONE_MSK) == LL_TMI_BRIDGE_RCFG_DONE_MSK)
      {
         Status = IRC_DONE;
      }
   }
   else
   {
      PRINT("Error in LLTMI_Done()\n");
   }
      
  return Status;
   
}

void LLTMI_UpdateFBConfig(t_LLTMI_Bridge *pObj, const GeniCam_Registers_Set_t *pGCRegs,LLTMI_mode_t mode, uint8_t frame, uint8_t image, uint32_t page)
{
   uint32_t u8_switch;
   uint32_t AddOffset,startoffset;
   uint32_t DataLeft;
   
   uint32_t decim_line, decim_col, crop_line, crop_col;
   const float MaxLostLineRatio = MAXLOSTRATIO;
   const float MaxLostColRatio = MAXLOSTRATIO;
   
   
   AddOffset = pGCRegs->WidthMax * pGCRegs->HeightMax * page;
   startoffset = (pGCRegs->OffsetY * pGCRegs->WidthMax) + pGCRegs->OffsetX + AddOffset;
   
   if(mode == LLTMI_READ)
   {
      if(frame == LL_TMI_BRIDGE_LINE_FRAME)
      {
         if(image == LL_TMI_BRIDGE_SINGLE_IMAGE)
         {
            pObj->RD_CONFIG = 0x18;
         }
         else if(image == LL_TMI_BRIDGE_LOOP_IMAGE)
         {
            pObj->RD_CONFIG = 0x19;
         }
      }
      else if(frame == LL_TMI_BRIDGE_IMAGE_FRAME)
      {
         if(image == LL_TMI_BRIDGE_SINGLE_IMAGE)
         {
            pObj->RD_CONFIG = 0x06;
         }
         else if(image == LL_TMI_BRIDGE_LOOP_IMAGE)
         {
            pObj->RD_CONFIG = 0x07;
         }
      }
      
      //Determine if we decimate the image or not.
      decim_line = 0;
      decim_col = 0;
      crop_line = 0;
      crop_col = 0;
       
      if(pGCRegs->AnalogVideoStandard == AVS_PAL) //PAL
      {
         if (pGCRegs->Width > PAL_WIDTH)
         {
            DataLeft=pGCRegs->Width;
            while( DataLeft > PAL_WIDTH)
            {
               if(DataLeft > PAL_WIDTH*MAXLOSTRATIO)
               {
                  decim_col += 1;
                  DataLeft = pGCRegs->Width/(decim_col+1);         
               }
               else
               {
                  crop_col = DataLeft - PAL_WIDTH;
                  DataLeft -= crop_col;     
               } 
            }           
         }

         if (pGCRegs->Height > PAL_HEIGHT)
         {
            DataLeft=pGCRegs->Height;
            while( DataLeft > PAL_HEIGHT)
            {
               if(DataLeft > PAL_HEIGHT*MAXLOSTRATIO)
               {
                  decim_line += 1;
                  DataLeft = pGCRegs->Height/(decim_line+1);         
               }
               else
               {
                  crop_line = DataLeft - PAL_HEIGHT;
                  DataLeft -= crop_line;     
               } 
            } 
         }
  
      }
      else //NTSC
      {
         if (pGCRegs->Width > NTSC_WIDTH)
         {
            DataLeft=pGCRegs->Width;
            while( DataLeft > NTSC_WIDTH)
            {
               if(DataLeft > NTSC_WIDTH*MAXLOSTRATIO)
               {
                  decim_col += 1;
                  DataLeft = pGCRegs->Width/(decim_col+1);         
               }
               else
               {
                  crop_col = DataLeft - NTSC_WIDTH;
                  DataLeft -= crop_col;     
               } 
            }           
         }

         if (pGCRegs->Height > NTSC_HEIGHT)
         {
            DataLeft=pGCRegs->Height;
            while( DataLeft > NTSC_HEIGHT)
            {
               if(DataLeft > NTSC_HEIGHT*MAXLOSTRATIO)
               {
                  decim_line += 1;
                  DataLeft = pGCRegs->Height/(decim_line+1);         
               }
               else
               {
                  crop_line = DataLeft - NTSC_HEIGHT;
                  DataLeft -= crop_line;     
               } 
            } 
         }
          
      }
      //DEBUG
      //PRINTF("DEBUG LLTMI_UpdateFBConfig\n");
      //PRINTF("Video Standard:%x, decim_col:%x, crop_col:%x decim_line:%x crop_line:%x \n",pGCRegs->AnalogVideoStandard,decim_col,crop_col,decim_line,crop_line );
      //PRINTF("WidthMax:%x, HeightMax:%x, offsetX:%x, offsetY:%x, addoffset:%x TOTAL MAX:%x \n",pGCRegs->WidthMax,pGCRegs->HeightMax,pGCRegs->OffsetX,pGCRegs->OffsetY,AddOffset,pGCRegs->WidthMax*pGCRegs->HeightMax);
      
      //WIDTH
	   pObj->RD_WIDTH = (pGCRegs->Width - 1) - crop_col*(decim_col+1) - decim_col; // Remove 1 because we start at 0000
	   
	   //STEP
      if(pGCRegs->FlipLR == 0)
      {
         pObj->RD_STEP_ADD = decim_col+1;
      }
      else
      {
         pObj->RD_STEP_ADD = -(decim_col+1);
      }
         
      if(pGCRegs->FlipUD == 0 && pGCRegs->FlipLR == 0)
      {
         //FIELD 1
         pObj->RD_START_ADD = startoffset + (crop_col/2)*(decim_col+1)+(crop_line/2)*pGCRegs->WidthMax*(decim_line+1) ; //first pixel + Col offset + line offset     
         pObj->RD_END_ADD = (startoffset + ((pGCRegs->Height-1) *pGCRegs->WidthMax) + pGCRegs->Width - 1) - ((crop_col/2)*(decim_col+1) + decim_col) - (crop_line/2)*pGCRegs->WidthMax*(decim_line+1) - (2*pGCRegs->WidthMax*decim_line + pGCRegs->WidthMax); // Last Pixel - ColOffset - LineOffset - Interleave
         pObj->RD_SKIP =  (pGCRegs->WidthMax-pGCRegs->Width+ 1) + (crop_col*(decim_col+1)+decim_col) + (2*pGCRegs->WidthMax*decim_line + pGCRegs->WidthMax ) ; // To next Line + To first Pix + Interleave       
         LLTMI_UpdateReadID(pObj,pGCRegs,frame,image,page,0);
         //PRINTF("WIDTH:%x, STEP:%x SKIP:%x START1:%x END1:%x\n",pObj->RD_WIDTH,pObj->RD_STEP_ADD,pObj->RD_SKIP,pObj->RD_START_ADD,pObj->RD_END_ADD );
         //FIELD 2
         pObj->RD_START_ADD = pObj->RD_START_ADD +  pGCRegs->WidthMax*(decim_line+1); // Start_add Field 1 + Interleave
         pObj->RD_END_ADD = pObj->RD_END_ADD + pGCRegs->WidthMax*(decim_line+1); // End add Field 1 + interleave
      }
      else if(pGCRegs->FlipUD == 0 && pGCRegs->FlipLR == 1)
      {
         //FIELD 1
         pObj->RD_START_ADD = startoffset + (pGCRegs->Width-1) + (crop_line/2)*pGCRegs->WidthMax*(decim_line+1) - (crop_col/2)*(decim_col+1) ; //first pixel + Width + line offset - Col offset      
         pObj->RD_END_ADD = (startoffset + ((pGCRegs->Height-1) *pGCRegs->WidthMax)) + ((crop_col/2)*(decim_col+1) + decim_col) - (crop_line/2)*pGCRegs->WidthMax*(decim_line+1) - (2*pGCRegs->WidthMax*decim_line + pGCRegs->WidthMax); // Last Pixel + ColOffset - LineOffset - Interleave
         pObj->RD_SKIP = (pGCRegs->WidthMax+pGCRegs->Width- 1) - (crop_col*(decim_col+1)+decim_col) + (2*pGCRegs->WidthMax*decim_line + pGCRegs->WidthMax) ; // To next Line - To first Pix + Interleave 
         LLTMI_UpdateReadID(pObj,pGCRegs,frame,image,page,0);
         //PRINTF("WIDTH:%x, STEP:%x SKIP:%x START1:%x END1:%x\n",pObj->RD_WIDTH,pObj->RD_STEP_ADD,pObj->RD_SKIP,pObj->RD_START_ADD,pObj->RD_END_ADD );
         //FIELD 2
         pObj->RD_START_ADD = pObj->RD_START_ADD +  pGCRegs->WidthMax*(decim_line+1); // Start_add Field 1 + Interleave
         pObj->RD_END_ADD = pObj->RD_END_ADD + pGCRegs->WidthMax*(decim_line+1); // End add Field 1 + interleave
      }
      else if(pGCRegs->FlipUD == 1 && pGCRegs->FlipLR == 0)
      {
         //FIELD 1         
         pObj->RD_START_ADD = (startoffset + (pGCRegs->Height-1)*pGCRegs->WidthMax) + (crop_col/2)*(decim_col+1) - (crop_line/2)*pGCRegs->WidthMax*(decim_line+1) ; //first pixel + Col offset - line offset     
         pObj->RD_END_ADD = (startoffset + pGCRegs->Width - 1) - ((crop_col/2)*(decim_col+1) + decim_col) + (crop_line/2)*pGCRegs->WidthMax*(decim_line+1) + (2*pGCRegs->WidthMax*decim_line + pGCRegs->WidthMax); // Last Pixel - ColOffset + LineOffset + Interleave
         pObj->RD_SKIP = -(pGCRegs->Width +  pGCRegs->WidthMax - 1) + (crop_col*(decim_col+1)+decim_col) - (2*pGCRegs->WidthMax*decim_line + pGCRegs->WidthMax ) ; // To next Line + Col Offset - Interleave 
         LLTMI_UpdateReadID(pObj,pGCRegs,frame,image,page,0);
         //PRINTF("WIDTH:%x, STEP:%x SKIP:%x START1:%x END1:%x\n",pObj->RD_WIDTH,pObj->RD_STEP_ADD,pObj->RD_SKIP,pObj->RD_START_ADD,pObj->RD_END_ADD );
         //FIELD 2
         pObj->RD_START_ADD = pObj->RD_START_ADD -  pGCRegs->WidthMax*(decim_line+1); // Start_add Field 1 + Interleave
         pObj->RD_END_ADD = pObj->RD_END_ADD - pGCRegs->WidthMax*(decim_line+1); // End add Field 1 + interleave
      }
      else if(pGCRegs->FlipUD == 1 && pGCRegs->FlipLR == 1)
      {
         //FIELD 1
         pObj->RD_START_ADD = (startoffset +(pGCRegs->Height-1)*pGCRegs->WidthMax + pGCRegs->Width - 1) - (crop_col*(decim_col+1)+decim_col) - (crop_line/2)*pGCRegs->WidthMax*(decim_line+1) ; //First Pixel -Col Offset - Lineoffset
         pObj->RD_END_ADD = startoffset + (crop_col/2)*(decim_col+1) + (crop_line/2)*pGCRegs->WidthMax*(decim_line+1) + (2*pGCRegs->WidthMax*decim_line + pGCRegs->WidthMax); //Last pixel + col offset + line offset + interleave
         pObj->RD_SKIP = (pGCRegs->Width - pGCRegs->WidthMax - 1) - (crop_col*(decim_col+1)+decim_col) - (2*pGCRegs->WidthMax*decim_line + pGCRegs->WidthMax) ; // To next Line - col offset - Interleave       
         LLTMI_UpdateReadID(pObj,pGCRegs,frame,image,page,0);
         //PRINTF("WIDTH:%x, STEP:%x SKIP:%x START1:%x END1:%x\n",pObj->RD_WIDTH,pObj->RD_STEP_ADD,pObj->RD_SKIP,pObj->RD_START_ADD,pObj->RD_END_ADD );
         //FIELD 2
         pObj->RD_START_ADD = pObj->RD_START_ADD -  pGCRegs->WidthMax*(decim_line+1); // Start_add Field 1 + Interleave
         pObj->RD_END_ADD = pObj->RD_END_ADD - pGCRegs->WidthMax*(decim_line+1); // End add Field 1 + interleave
      }
      
      LLTMI_UpdateReadID(pObj,pGCRegs,frame,image,page,1);
      //PRINTF("WIDTH:%x, STEP:%x SKIP:%x START2:%x END2:%x\n",pObj->RD_WIDTH,pObj->RD_STEP_ADD,pObj->RD_SKIP,pObj->RD_START_ADD,pObj->RD_END_ADD );
      WB_write32(0,pObj->ADD + LL_TMI_BRIDGE_READ_ID);
      u8_switch = 1;

   }
   WB_write32(u8_switch,pObj->ADD + LL_TMI_BRIDGE_SWITCH);
}
