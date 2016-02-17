---------------------------------------------------------------------------------------------------
--                                                      ..`??!````??!..
--                                                  .?!                `1.
--                                               .?`                      i
--                                             .!      ..vY=!``?74.        i
--.........          .......          ...     ?      .Y=` .+wA..   ?,      .....              ...
--"""HMM"""^         MM#"""5         .MM|    :     .H\ .JQgNa,.4o.  j      MM#"MMN,        .MM#"WMF
--   JM#             MMNggg2         .MM|   `      P.;,jMt   `N.r1. ``     MMmJgMM'        .MMMNa,.
--   JM#             MM%````         .MM|   :     .| 1A Wm...JMy!.|.t     .MMF!!`           . `7HMN
--   JMM             MMMMMMM         .MMMMMMM!     W. `U,.?4kZ=  .y^     .!MMt              YMMMMB=
--                                          `.      7&.  ?1+...JY'     .J
--                                           ?.        ?""""7`       .?`
--                                             :.                ..?`
--
---------------------------------------------------------------------------------------------------
--
-- Title       : CAMEL_Define
-- Design      : CAMEL
-- Author      : Patrick Dubois, Jean-Pierre Allard & Olivier Bourgois & Edem Nofodjie
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package CAMEL_Define is    
   
   ------------------------------------------
   -- Project constants                      
   ------------------------------------------  
   constant Img_Tag_size : integer := 8;
   constant Img_Tag_size_L64 : integer := 8;	   
   
   constant Img_Tag_Activate : boolean := TRUE;
   constant DCUBE_HDR_VERSION: unsigned(7 downto 0) := x"04";    -- ROIC generates version 3 header
   
   -- Define number of bits
   constant ACQLEN         : integer := 23;
   constant FRINGELEN      : integer := 24;
   constant RXLEN          : integer := 9;
   constant RYLEN          : integer := 10; 
   
   -- Definition des tailles en bytes des frames envoyés via RIO
   -- se rapporter au fichier excel CAMEL RIO V2_6
   constant ROIC_HEADER_RIO_V2_6_LEN : integer := 36; -- taille en bytes du header roic 
   constant NAV_HEADER_RIO_V2_6_LEN  : integer := 104; -- taille en bytes des données envoyées via RIo du NAV
   constant ROIC_FOOTER_RIO_V2_6_LEN : integer := 44; -- taille en bytes du header roic 
   constant ROIC_ACQON_FRAME_LEN     : integer := 2;  -- taille en bytes de la commande A4, hormis le header et le payload
   
   
   -- Header types constants
   constant ROIC_CAMERA_FRAME  : std_logic_vector(7 downto 0) := X"00"; 
   constant ROIC_DCUBE_FRAME_OLD : std_logic_vector(7 downto 0) := X"01"; -- Old type of frame
   constant ROIC_DCUBE_FRAME   : std_logic_vector(7 downto 0) := X"04";
   constant ROIC_HEADER_FRAME  : std_logic_vector(7 downto 0) := X"05";
   constant ROIC_FOOTER_FRAME  : std_logic_vector(7 downto 0) := X"03";
   constant CLINK_CONFIG_FRAME : std_logic_vector(7 downto 0) := X"60";
   constant CLINK_HEADER_FRAME : std_logic_vector(7 downto 0) := X"43";
   constant PROC_CONFIG_FRAME  : std_logic_vector(7 downto 0) := X"61";
   --constant PROC_CAMERA_FRAME  : std_logic_vector(7 downto 0) := X"80";
   constant PROC_DCUBE_FRAME   : std_logic_vector(7 downto 0) := X"81";   
   constant PROC_HEADER_FRAME  : std_logic_vector(7 downto 0) := X"82";
   constant PROC_FOOTER_FRAME  : std_logic_vector(7 downto 0) := X"83";
   
   constant NAV_HEADER_FRAME   : std_logic_vector(7 downto 0) := X"06";
   constant NAV_CONFIG_FRAME   : std_logic_vector(7 downto 0) := X"FC";
   constant NAV_RESET_FRAME    : std_logic_vector(7 downto 0) := X"FD";
   constant ROIC_ACQON_FRAME   : std_logic_vector(7 downto 0) := X"A4";
   ------------------------------------------
   -- Types declarations                     
   ------------------------------------------      
   -- This is RIO v2.6 only
   type ROIC_DCube_Header_v2_6 is
   record      
      Status               : std_logic_vector(31 downto 0);
      Direction            : std_logic;         
      Acq_Number           : unsigned(ACQLEN-1 downto 0);
      Code_Rev             : std_logic_vector(15 downto 0);
      Xmin                 : unsigned(RXLEN-1 downto 0);       -- aka FOVStartX
      Ymin                 : unsigned(RYLEN-1 downto 0);       -- aka FOVStartY      
      StartTimeStamp       : unsigned(31 downto 0);
      FPGATemp             : unsigned(7 downto 0);
      PCBTemp              : unsigned(7 downto 0);
      FilterPosition       : std_logic_vector(1 downto 0);
      ArmedStatus          : std_logic;
      RealIntTime          : unsigned(15 downto 0);
      Spare                : unsigned(15 downto 0);        
   end record;
   
   -- This is RIO v2.6 only
   
   type ROIC_DCube_Footer_v2_6 is
   record      
      Status                : std_logic_vector(31 downto 0);
      Direction             : std_logic;
      Acq_Number            : unsigned(ACQLEN-1 downto 0);
      Write_No              : unsigned(FRINGELEN-1 downto 0);
      Trig_No               : unsigned(FRINGELEN-1 downto 0);      
      ZPDPosition           : unsigned(FRINGELEN-1 downto 0);
      ZPDPeakVal            : unsigned(15 downto 0);            -- aka MaxFPACount      
      EndTimeStamp          : unsigned(31 downto 0);
      NbPixelsAboveHighLimit: unsigned(31 downto 0);
      NbPixelsAboveLowLimit : unsigned(31 downto 0); 
      Nav_Data_Tag          : std_logic_vector(31 downto 0);
   end record;   
   
   --le NAV Header ne sera pas decodé dans le CLINK d'où
   type NAV_DCube_Header_v2_6 is array  (1 to NAV_HEADER_RIO_V2_6_LEN/4) of std_logic_vector(31 downto 0);
   -- le -1 pour tenir compte de l'enlevement de l'entete.                                         
   
   
   
   -- Valid for all RIO versions up to 2.5
   type ROIC_Img_Header is
   record        
      cmdHeader      : std_logic_vector(7 downto 0);  -- 0x00 for Camera Mode, 0x01 for Datacube Mode
      Direction      : std_logic;
      Acq_Number     : unsigned(ACQLEN-1 downto 0);
      Fringe_Number  : unsigned(FRINGELEN-1 downto 0);
   end record;
   
   type ROIC_Img_Header_array16 is array (1 to 4) of unsigned(15 downto 0);
   
   -- This is RIO v2.4 (Obsolete in v2.5)
   type ROIC_Img_Footer is
   record
      ROIC_Direction    : std_logic;
      ROIC_Acq_Number   : unsigned(ACQLEN-1 downto 0);
      ROIC_Write_No     : unsigned(FRINGELEN-1 downto 0);
      ROIC_Trig_No      : unsigned(FRINGELEN-1 downto 0);
      ROIC_Version      : unsigned(7 downto 0);       
      ROIC_Status       : std_logic_vector(31 downto 0);
      ROIC_Xmin         : unsigned(RXLEN-1 downto 0);       -- FOVStartX
      ROIC_Ymin         : unsigned(RYLEN-1 downto 0);       -- FOVStartY
      ROIC_ZPDPeakVal   : unsigned(15 downto 0);            -- MaxFPACount
      ROIC_ZPDPosition  : unsigned(FRINGELEN-1 downto 0);
      ROIC_TimeStamp    : unsigned(31 downto 0);
   end record;
   
   type ROIC_Img_Footer_array16 is array (1 to 16) of std_logic_vector(15 downto 0);
   
   -- This is RIO v2.5 only
   type ROIC_DCube_Header is
   record      
      Direction   : std_logic;
      Acq_Number  : unsigned(ACQLEN-1 downto 0);
      Code_Rev    : std_logic_vector(15 downto 0);
      Status      : std_logic_vector(31 downto 0);
      Xmin        : unsigned(RXLEN-1 downto 0);       -- aka FOVStartX
      Ymin        : unsigned(RYLEN-1 downto 0);       -- aka FOVStartY      
      StartTimeStamp : unsigned(31 downto 0);
   end record;
   
   type ROIC_DCube_Header_array16 is array (1 to 10) of std_logic_vector(15 downto 0);
   type ROIC_DCube_Header_array32 is array (1 to 6) of std_logic_vector(31 downto 0);
   type ROIC_DCube_Header_array32_v2_6 is array (1 to ROIC_HEADER_RIO_V2_6_LEN/4) of std_logic_vector(31 downto 0);
   type NAV_DCube_Header_array32_v2_6 is array (1 to NAV_HEADER_RIO_V2_6_LEN/4) of std_logic_vector(31 downto 0);
   
   -- This is RIO v2.4 (unchanged in v2.5)
   type ROIC_DCube_Footer is
   record      
      Direction   : std_logic;
      Acq_Number  : unsigned(ACQLEN-1 downto 0);
      Write_No    : unsigned(FRINGELEN-1 downto 0);
      Trig_No     : unsigned(FRINGELEN-1 downto 0);     
      Status      : std_logic_vector(31 downto 0);
      ZPDPosition : unsigned(FRINGELEN-1 downto 0);
      ZPDPeakVal  : unsigned(15 downto 0);            -- aka MaxFPACount      
      EndTimeStamp : unsigned(31 downto 0);
   end record;   
   
   type ROIC_DCube_Footer_array16 is array (1 to 14) of std_logic_vector(15 downto 0);
   type ROIC_DCube_Footer_array32 is array (1 to 8) of std_logic_vector(31 downto 0);
   type ROIC_DCube_Footer_array32_v2_6 is array (1 to ROIC_FOOTER_RIO_V2_6_LEN/4) of std_logic_vector(31 downto 0);
   
   type DPBConfig_array is array (1 to 29) of std_logic_vector(7 downto 0);      -- Array containing the RS232 bytes of command 0x40.    
   -- No longer used ? see if we break something by commenting out => OBO
   --type DPBConfig_array16 is array (1 to 14) of std_logic_vector(15 downto 0);   -- Same as DPBConfig_array but for 16-bit elements added a byte to fit new structure
   
   -----------------------------------------------------
   -- ROIC Acquisition Configuration Structure Length --
   -----------------------------------------------------
   constant ROIC_Config_Len : integer := 49;          -- Number of bytes sent through RS232 to complete Configuration
   constant ROIC_Temp_Len : integer := 3;             -- RS232 Temperature Setting (x81) Total Payload Length in bytes
   constant ROIC_Servo_Len : integer := 2;            -- RS232 Servo Setting (x82) Total Payload Length in bytes
   
   -----------------------------------------------------
   -- ROIC IntegrationTime Control 
   -----------------------------------------------------
   constant ROIC_AGC_old_Config_Len : integer := 8;  -- config 0x83 : toujours supporté mais en voie de disparition
   constant ROIC_AGC_Config_Len : integer := 17;     -- config 0x8A : nouvelle config pour l'IntegrationTime Control et qui sera de plus en plus utilisée.
   
   -----------------------------------------------------
   -- DELAY CORRECTION BLOC  Configuration Structure Length --
   -----------------------------------------------------
   constant Trig_Config_Len : integer := 6;            -- Number of bytes sent through RS232 to complete Configuration
   
   ---------------------------------------------------
   -- DataProcessing Configuration Structure Length --
   ---------------------------------------------------
   constant DPBConfig_size         : integer := DPBConfig_array'length;   -- Number of bytes sent through RS232 to complete Configuration
   constant DPBCommand_50_Len      : integer := 1;                     -- Command 0x50 Length
   constant DCUBE_HEADER_V2_size   : integer := 512;                -- CameraLinkHeader_V2 Total Length in bytes
   constant DCUBE_HEADER_V3_size   : integer := 512;                -- CameraLinkHeader_V3 externally updated part length in bytes
   constant DCUBE_FOOTER_V3_size   : integer := 88;                 -- CameraLinkHeader_V3 status part length in bytes. To become a footer eventually
   constant DPB_REPLY_92_Len       : integer := 12;                     -- Length (in bytes) of the reply to the command 0x92
   constant DPB_REPLY_94_Len       : integer := 18;                     -- Length (in bytes) of the reply to the command 0x94   
   constant DCUBE_Part2_V4_size    : integer := 384;                 -- CameraLinkHeader_V4 status part2 length in bytes. To become a footer eventually. Must be a multiple of 8
   constant DCUBE_Part1_V4_size    : integer := 640;                -- CameraLinkHeader_V4 externally updated part length in bytes
   constant ROIC_Img_Header_default : ROIC_Img_Header := 
   (x"FF",
   '0',
   to_unsigned(0,23),
   x"000000");
   
   constant ROIC_Img_Footer_default : ROIC_Img_Footer :=
   ('0',
   "000" & x"00000",
   x"000000",
   x"000000",
   x"00",
   x"00000000",
   "000000000",
   "0000000000",
   x"0000",  
   x"000000",
   x"00000000");
   
   ------------------------------------------
   -- Dedicated line communication constants
   -- (3 MODE lines)
   ------------------------------------------ 
   -- The MODE lines are no longer used (PDU, Dec 2006)
   --   constant Mode_Stop     : std_logic_vector(2 downto 0) := "000";  -- Normal Stop mode
   --   constant Mode_Camera   : std_logic_vector(2 downto 0) := "001";  -- Camera mode - Acquisitions sent to VP7
   --   constant Mode_Spectro  : std_logic_vector(2 downto 0) := "010";  -- Spectro mode - Acquisitions sent to VP30-1 & VP30-2
   --   constant Mode_DPdiag1  : std_logic_vector(2 downto 0) := "011";  -- DP diagnostic 1 - Nothing is sent to VP7/VP30, camera pattern generated from VP7
   --   constant Mode_DPdiag2  : std_logic_vector(2 downto 0) := "100";  -- DP diagnostic 2 - Nothing is sent to VP7/VP30, spectro pattern generated from VP30
   --   constant Mode_DPdiag3  : std_logic_vector(2 downto 0) := "101";  -- DP diagnostic 3 - Nothing is sent to VP7/VP30, spectro pattern generated from VP7
   --   constant Mode_Unused   : std_logic_vector(2 downto 0) := "110";  -- Unused (stop for now)
   --   constant Mode_StopNow  : std_logic_vector(2 downto 0) := "111";  -- Immediate Stop mode  
   
   ------------------------------------------
   -- *** FUNCTIONS DECLARATIONS***
   ------------------------------------------ 
   -- V2.4 functions (to be phased out)
   function to_ROIC_Img_Header (a: ROIC_Img_Header_array16) return ROIC_Img_Header;
   function to_ROIC_Img_Header_array16 (a: ROIC_Img_Header) return ROIC_Img_Header_array16;
   function to_ROIC_Img_Footer (a: ROIC_Img_Footer_array16) return ROIC_Img_Footer;
   function to_ROIC_Img_Footer(a: ROIC_DCube_Header; b: ROIC_DCube_Footer) return ROIC_Img_Footer;
   function to_ROIC_Img_Footer(a: ROIC_DCube_Header) return ROIC_Img_Footer;   
   function to_ROIC_Img_Footer_array16 (a: ROIC_Img_Footer) return ROIC_Img_Footer_array16;
   function to_ROIC_DCube_Footer (a: ROIC_DCube_Footer_array16) return ROIC_DCube_Footer;          
   function to_ROIC_DCube_Footer (a: ROIC_Img_Header; b: ROIC_Img_Footer) return ROIC_DCube_Footer;
   function to_ROIC_DCube_Footer_array16 (a: ROIC_DCube_Footer) return ROIC_DCube_Footer_array16;   
   function to_ROIC_DCube_Header (a: ROIC_DCube_Header_array16) return ROIC_DCube_Header;
   function to_ROIC_DCube_Header (a: ROIC_Img_Header; b: ROIC_Img_Footer) return ROIC_DCube_Header;
   function to_ROIC_DCube_Header_array16 (a: ROIC_DCube_Header) return ROIC_DCube_Header_array16; 
   -- V2.5 functions
   function to_ROIC_DCube_Header (a: ROIC_DCube_Header_array32) return ROIC_DCube_Header;
   function to_ROIC_DCube_Header_array32 (a: ROIC_DCube_Header) return ROIC_DCube_Header_array32;
   function to_ROIC_DCube_Footer (a: ROIC_DCube_Footer_array32) return ROIC_DCube_Footer;
   function to_ROIC_DCube_Footer_array32 (a: ROIC_DCube_Footer) return ROIC_DCube_Footer_array32;
   -- V2.6 functions
   function to_ROIC_DCube_Header_v2_6 (a: ROIC_DCube_Header_array32_v2_6 ) return ROIC_DCube_Header_v2_6 ;
   function to_ROIC_DCube_Header_array32_v2_6  (a: ROIC_DCube_Header_v2_6 ) return ROIC_DCube_Header_array32_v2_6 ;
   function to_ROIC_DCube_Footer_v2_6  (a: ROIC_DCube_Footer_array32_v2_6 ) return ROIC_DCube_Footer_v2_6 ;
   function to_ROIC_DCube_Footer_array32_v2_6  (a: ROIC_DCube_Footer_v2_6 ) return ROIC_DCube_Footer_array32_v2_6 ;
   --function to_NAV_DCube_Header_v2_6  (a: NAV_DCube_Header_array32_v2_6 ) return NAV_DCube_Header_v2_6 ;
   
   --function to_std(x:boolean) return std_logic;
end CAMEL_Define;

------------------------------------------
-- *** CAMEL_DEFINE PACKAGE BODY***       
------------------------------------------
package body CAMEL_Define is
   
   
   function to_ROIC_Img_Header (a: ROIC_Img_Header_array16) return ROIC_Img_Header is
      variable y: ROIC_Img_Header;
   begin
      y.CmdHeader := std_logic_vector(a(1)(7 downto 0));
      y.Direction := std_logic(a(2)(15));
      y.Acq_Number := a(2)(14 downto 0) &a(3)(15 downto 8);
      y.Fringe_Number := a(3)(7 downto 0) & a(4);
      return y;
   end to_ROIC_Img_Header;
   
   function to_ROIC_Img_Header_array16 (a: ROIC_Img_Header) return ROIC_Img_Header_array16 is
      variable y: ROIC_Img_Header_array16;
   begin
      y(1) := X"00" & unsigned(a.CmdHeader);
      y(2) := a.Direction & a.Acq_Number(22 downto 8);
      y(3) := a.Acq_Number(7 downto 0) & a.Fringe_Number(23 downto 16);   
      y(4) := a.Fringe_Number(15 downto 0);              
      return y;
   end to_ROIC_Img_Header_array16;
   
   function to_ROIC_Img_Footer (a: ROIC_Img_Footer_array16) return ROIC_Img_Footer is
      variable y: ROIC_Img_Footer;
      variable temp: std_logic_vector(31 downto 0);
   begin
      temp(23 downto 0)  := a(1)(7 downto 0) & a(2);
      y.ROIC_Direction   := temp(23);
      y.ROIC_Acq_Number  := unsigned(temp(22 downto 0));
      temp(23 downto 0)  := a(3)(7 downto 0) & a(4);
      y.ROIC_Write_No    := unsigned(temp(23 downto 0));
      temp(23 downto 0)  := a(5)(7 downto 0) & a(6);
      y.ROIC_Trig_No     := unsigned(temp(23 downto 0));
      y.ROIC_Version     := unsigned(a(7)(7 downto 0));
      temp               := a(8) & a(9);
      y.ROIC_Status      := std_logic_vector(temp);
      y.ROIC_Xmin        := unsigned(a(10)(RXLEN-1 downto 0));
      y.ROIC_Ymin        := unsigned(a(11)(RYLEN-1 downto 0));
      temp(23 downto 0)  := a(12)(7 downto 0) & a(13);
      y.ROIC_ZPDPosition := unsigned(temp(23 downto 0));
      y.ROIC_ZPDPeakVal  := unsigned(a(14));
      temp               := a(15)& a(16);
      y.ROIC_TimeStamp   := unsigned(temp);
      return y;
   end to_ROIC_Img_Footer;   
   
   function to_ROIC_Img_Footer(a: ROIC_DCube_Header; b: ROIC_DCube_Footer) return ROIC_Img_Footer is
      variable y: ROIC_Img_Footer;
   begin
      y.ROIC_Direction   := b.Direction;
      y.ROIC_Acq_Number  := b.Acq_Number; 
      y.ROIC_Write_No    := b.Write_No;   
      y.ROIC_Trig_No     := b.Trig_No;    
      y.ROIC_Version     := unsigned(a.Code_Rev(7 downto 0));    
      y.ROIC_Status      := b.Status;     
      y.ROIC_Xmin        := a.Xmin;       
      y.ROIC_Ymin        := a.Ymin;       
      y.ROIC_ZPDPosition := b.ZPDPosition;
      y.ROIC_ZPDPeakVal  := b.ZPDPeakVal; 
      y.ROIC_TimeStamp   := b.EndTimeStamp;
      return y;      
   end to_ROIC_Img_Footer;     
   
   function to_ROIC_Img_Footer(a: ROIC_DCube_Header) return ROIC_Img_Footer is
      variable y: ROIC_Img_Footer;
   begin
      y.ROIC_Direction   := '0';
      y.ROIC_Acq_Number  := (others => '0');
      y.ROIC_Write_No    := (others => '0');
      y.ROIC_Trig_No     := (others => '0');
      y.ROIC_Version     := unsigned(a.Code_Rev(7 downto 0));    
      y.ROIC_Status      := (others => '0');
      y.ROIC_Xmin        := a.Xmin;       
      y.ROIC_Ymin        := a.Ymin;       
      y.ROIC_ZPDPosition := (others => '0');
      y.ROIC_ZPDPeakVal  := (others => '0');
      y.ROIC_TimeStamp   := a.StartTimeStamp;  
      return y;
   end to_ROIC_Img_Footer;     
   
   function to_ROIC_Img_Footer_array16 (a: ROIC_Img_Footer) return ROIC_Img_Footer_array16 is
      variable y: ROIC_Img_Footer_array16;
      variable temp: std_logic_vector(31 downto 0);
   begin
      temp(22 downto 0) := std_logic_vector(a.ROIC_Acq_Number);
      y(1)  := x"00" & a.ROIC_Direction & temp(22 downto 16);
      y(2)  := temp(15 downto 0);
      temp(23 downto 0) := std_logic_vector(a.ROIC_Write_No);
      y(3)  := x"00" & temp(23 downto 16);     
      y(4)  := temp(15 downto 0);
      temp(23 downto 0) := std_logic_vector(a.ROIC_Trig_No);
      y(5)  := x"00" & temp(23 downto 16);      
      y(6)  := temp(15 downto 0);
      y(7)  := x"00" & std_logic_vector(a.ROIC_Version);
      y(8)  := std_logic_vector(a.ROIC_Status(31 downto 16));
      y(9)  := std_logic_vector(a.ROIC_Status(15 downto 0));
      y(10)  := (15 downto RXLEN => '0') & std_logic_vector(a.ROIC_Xmin);  
      y(11) := (15 downto RYLEN => '0') & std_logic_vector(a.ROIC_Ymin);
      temp(23 downto 0) := std_logic_vector(a.ROIC_ZPDPosition);
      y(12) := x"00" & temp(23 downto 16);
      y(13) := temp(15 downto 0);
      y(14) := std_logic_vector(a.ROIC_ZPDPeakVal);
      temp  := std_logic_vector(a.ROIC_TimeStamp);
      y(15) := temp(31 downto 16);
      y(16) := temp(15 downto 0);
      return y;
   end to_ROIC_Img_Footer_array16; 
   
   function to_ROIC_DCube_Footer (a: ROIC_DCube_Footer_array16) return ROIC_DCube_Footer is
      variable y: ROIC_DCube_Footer;
   begin                                               
      -- a(1) is the Command Header 0x03 but this constant value is not present in the structure.
      y.Direction   := a(2)(7);
      y.Acq_Number  := unsigned(a(2)(6 downto 0)) & unsigned(a(3));
      y.Write_No    := unsigned(a(4)(FRINGELEN-17 downto 0)) & unsigned(a(5));
      y.Trig_No     := unsigned(a(6)(FRINGELEN-17 downto 0)) & unsigned(a(7));
      y.Status      := a(8) & a(9);
      y.ZPDPosition := unsigned(a(10)(FRINGELEN-17 downto 0)) & unsigned(a(11));
      y.ZPDPeakVal  := unsigned(a(12));
      y.EndTimeStamp   := unsigned(a(13)) & unsigned(a(14));
      return y;
   end to_ROIC_DCube_Footer; 
   
   function to_ROIC_DCube_Footer (a: ROIC_Img_Header; b: ROIC_Img_Footer) return ROIC_DCube_Footer is
      variable y: ROIC_DCube_Footer;
   begin                         
      y.Direction   := a.Direction;
      y.Acq_Number  := a.Acq_Number; 
      y.Write_No    := b.ROIC_Write_No;   
      y.Trig_No     := b.ROIC_Trig_No;    
      y.Status      := b.ROIC_Status;     
      y.ZPDPosition := b.ROIC_ZPDPosition;
      y.ZPDPeakVal  := b.ROIC_ZPDPeakVal; 
      y.EndTimeStamp   := b.ROIC_TimeStamp;  
      return y;      
   end to_ROIC_DCube_Footer;
   
   function to_ROIC_DCube_Footer_array16 (a: ROIC_DCube_Footer) return ROIC_DCube_Footer_array16 is
      variable y: ROIC_DCube_Footer_array16;
   begin
      y(1)  := X"00" & ROIC_FOOTER_FRAME; -- Command Header, always 0x0003
      y(2)  := X"00" & a.Direction & std_logic_vector(a.Acq_Number(ACQLEN-1 downto 16));
      y(3)  := std_logic_vector(a.Acq_Number(15 downto 0));
      y(4)  := x"00" & std_logic_vector(a.Write_No(23 downto 16));     
      y(5)  := std_logic_vector(a.Write_No(15 downto 0));   
      y(6)  := x"00" & std_logic_vector(a.Trig_No(23 downto 16));      
      y(7)  := std_logic_vector(a.Trig_No(15 downto 0)); 
      y(8)  := std_logic_vector(a.Status(31 downto 16));
      y(9)  := std_logic_vector(a.Status(15 downto 0));
      y(10) := x"00" & std_logic_vector(a.ZPDPosition(23 downto 16));
      y(11) := std_logic_vector(a.ZPDPosition(15 downto 0));
      y(12) := std_logic_vector(a.ZPDPeakVal);
      y(13) := std_logic_vector(a.EndTimeStamp(31 downto 16));
      y(14) := std_logic_vector(a.EndTimeStamp(15 downto 0));
      return y;
   end to_ROIC_DCube_Footer_array16;    
   
   function to_ROIC_DCube_Header (a: ROIC_DCube_Header_array16) return ROIC_DCube_Header is
      variable y: ROIC_DCube_Header;
   begin                                               
      -- a(1) is the Command Header 0x02 but this constant value is not present in the structure.
      y.Direction    := a(2)(7);
      y.Acq_Number   := unsigned(a(2)(6 downto 0)) & unsigned(a(3));
      y.Code_Rev     := a(4);
      y.Status       := a(5) & a(6);
      y.Xmin         := unsigned(a(7)(RXLEN-1 downto 0));
      y.Ymin         := unsigned(a(8)(RYLEN-1 downto 0));
      y.StartTimeStamp    := unsigned(a(9)) & unsigned(a(10));
      return y;
   end to_ROIC_DCube_Header;     
   
   function to_ROIC_DCube_Header (a: ROIC_Img_Header; b: ROIC_Img_Footer) return ROIC_DCube_Header is
      variable y: ROIC_DCube_Header;
   begin
      y.Direction    := a.Direction; 
      y.Acq_Number   := a.Acq_Number;
      y.Code_Rev     := x"00" & std_logic_vector(b.ROIC_Version);  
      y.Status       := b.ROIC_Status;    
      y.Xmin         := b.ROIC_Xmin;      
      y.Ymin         := b.ROIC_Ymin;      
      y.StartTimeStamp    := b.ROIC_TimeStamp; 
      return y;      
   end to_ROIC_DCube_Header;
   
   function to_ROIC_DCube_Header_array16 (a: ROIC_DCube_Header) return ROIC_DCube_Header_array16 is
      variable y: ROIC_DCube_Header_array16;
   begin
      y(1)  := X"00" & ROIC_Header_FRAME; -- Command Header, always 0x0003
      y(2)  := X"00" & a.Direction & std_logic_vector(a.Acq_Number(ACQLEN-1 downto 16));
      y(3)  := std_logic_vector(a.Acq_Number(15 downto 0));
      y(4)  := a.Code_Rev;
      y(5)  := std_logic_vector(a.Status(31 downto 16));
      y(6)  := std_logic_vector(a.Status(15 downto 0));
      y(7)  := (15 downto RXLEN => '0') & std_logic_vector(a.Xmin);  
      y(8)  := (15 downto RYLEN => '0') & std_logic_vector(a.Ymin);  
      y(9)  := std_logic_vector(a.StartTimeStamp(31 downto 16));
      y(10) := std_logic_vector(a.StartTimeStamp(15 downto 0));
      return y;
   end to_ROIC_DCube_Header_array16; 
   
   
   function to_ROIC_DCube_Header_v2_6 (a: ROIC_DCube_Header_array32_v2_6) return ROIC_DCube_Header_v2_6 is
      variable y: ROIC_DCube_Header_v2_6;
   begin
      y.Status           := a(2)(y.Status'range);
      y.Direction        := a(3)(31);
      y.Acq_Number       := unsigned(a(3)(y.Acq_Number'range));
      y.Code_Rev         := a(4)(y.Code_Rev'range);        
      y.Xmin             := unsigned(a(5)(y.Xmin'length + 15 downto 16));
      y.Ymin             := unsigned(a(5)(y.Ymin'length-1 downto 0));
      y.StartTimeStamp   := unsigned(a(6));
      y.FPGATemp         := unsigned(a(7)(y.FPGATemp'length + 15 downto 16));
      y.PCBTemp          := unsigned(a(7)(y.PCBTemp'length - 1 downto 0));
      y.FilterPosition   := a(8)(17 downto 16);
      y.ArmedStatus      := a(8)(0);
      y.RealIntTime       := unsigned(a(9)(y.RealIntTime'length + 15 downto 16));
      y.Spare            := unsigned(a(9)(y.Spare'length -1 downto 0));
      return y;
   end to_ROIC_DCube_Header_v2_6;   
   
   
   -- V2.5 32-bit data path versions (New)
   
   function to_ROIC_DCube_Header (a: ROIC_DCube_Header_array32) return ROIC_DCube_Header is
      variable y: ROIC_DCube_Header;
   begin
      y.Direction   := a(2)(31);
      y.Acq_Number  := unsigned(a(2)(y.Acq_Number'range));
      y.Code_Rev    := a(3)(y.Code_Rev'range);
      y.Status      := a(4)(y.Status'range);
      y.Xmin        := unsigned(a(5)(y.Xmin'length + 15 downto 16));
      y.Ymin        := unsigned(a(5)(y.Ymin'length-1 downto 0));
      y.StartTimeStamp   := unsigned(a(6));
      return y;
   end to_ROIC_DCube_Header;
   
   function to_ROIC_DCube_Header_array32 (a: ROIC_DCube_Header) return ROIC_DCube_Header_array32 is
      variable y: ROIC_DCube_Header_array32;
   begin
      y(1)  := ROIC_HEADER_FRAME & x"000005"; -- Command Header + frame size
      y(2)  := a.Direction & (30 downto a.Acq_Number'length => '0') & std_logic_vector(a.Acq_Number);
      y(3)  := (31 downto a.Code_Rev'length => '0') & std_logic_vector(a.Code_Rev);
      y(4)  := std_logic_vector(a.Status);
      y(5)  := (31 downto a.Xmin'length + 16 => '0') & std_logic_vector(a.Xmin)
      & (15 downto a.Ymin'length => '0') & std_logic_vector(a.Ymin);
      y(6)  := std_logic_vector(a.StartTimeStamp);
      return y;
   end to_ROIC_DCube_Header_array32;
   
   
   function to_ROIC_DCube_Header_array32_v2_6 (a: ROIC_DCube_Header_v2_6) return ROIC_DCube_Header_array32_v2_6 is
      variable y: ROIC_DCube_Header_array32_v2_6;
   begin
      y(1)  := ROIC_HEADER_FRAME & x"000008"; -- Command Header + frame size
      y(2)  := std_logic_vector(a.Status);
      y(3)  := a.Direction & (30 downto a.Acq_Number'length => '0') & std_logic_vector(a.Acq_Number);
      y(4)  := (31 downto a.Code_Rev'length => '0') & std_logic_vector(a.Code_Rev);        
      y(5)  := (31 downto a.Xmin'length + 16 => '0') & std_logic_vector(a.Xmin) & (15 downto a.Ymin'length => '0') & std_logic_vector(a.Ymin);
      y(6)  := std_logic_vector(a.StartTimeStamp);
      y(7)  := (31 downto a.FPGATemp'length + 16 => '0') & std_logic_vector(a.FPGATemp) & (15 downto a.PCBTemp'length => '0') &                                           std_logic_vector(a.PCBTemp);        
      y(8)  := (31 downto 18 => '0') & a.FilterPosition & (15 downto 1 => '0') & a.ArmedStatus; 
      y(9)  := std_logic_vector(a.RealIntTime) & std_logic_vector(a.Spare);       
      return y;
   end to_ROIC_DCube_Header_array32_v2_6;    
   
   
   function to_ROIC_DCube_Footer_v2_6 (a: ROIC_DCube_Footer_array32_v2_6) return ROIC_DCube_Footer_v2_6 is
      variable y: ROIC_DCube_Footer_v2_6;
   begin  
      y.Status                 := a(2);                                             
      y.Direction              := a(3)(31);
      y.Acq_Number             := unsigned(a(3)(y.Acq_Number'range));
      y.Write_No               := unsigned(a(4)(y.Write_No'range));
      y.Trig_No                := unsigned(a(5)(y.Trig_No'range));        
      y.ZPDPosition            := unsigned(a(6)(y.ZPDPosition'range));
      y.ZPDPeakVal             := unsigned(a(7)(y.ZPDPeakVal'range));
      y.EndTimeStamp           := unsigned(a(8));
      y.NbPixelsAboveHighLimit := unsigned(a(9));
      y.NbPixelsAboveLowLimit  := unsigned(a(10));
      y.Nav_Data_Tag           := a(11);
      return y;
   end to_ROIC_DCube_Footer_v2_6;
   
   
   function to_ROIC_DCube_Footer (a: ROIC_DCube_Footer_array32) return ROIC_DCube_Footer is
      variable y: ROIC_DCube_Footer;
   begin                                               
      y.Direction   := a(2)(31);
      y.Acq_Number  := unsigned(a(2)(y.Acq_Number'range));
      y.Write_No    := unsigned(a(3)(y.Write_No'range));
      y.Trig_No     := unsigned(a(4)(y.Trig_No'range));
      y.Status      := a(5);
      y.ZPDPosition := unsigned(a(6)(y.ZPDPosition'range));
      y.ZPDPeakVal  := unsigned(a(7)(y.ZPDPeakVal'range));
      y.EndTimeStamp   := unsigned(a(8));
      return y;
   end to_ROIC_DCube_Footer;
   
   function to_ROIC_DCube_Footer_array32 (a: ROIC_DCube_Footer) return ROIC_DCube_Footer_array32 is
      variable y: ROIC_DCube_Footer_array32;
   begin
      y(1)  := ROIC_FOOTER_FRAME & x"000007"; -- Command Header + padding for 32 bit alignment
      y(2)  := a.Direction & (30 downto a.Acq_Number'length => '0') & std_logic_vector(a.Acq_Number);
      y(3)  := (31 downto a.Write_No'length => '0') & std_logic_vector(a.Write_No);
      y(4)  := (31 downto a.Trig_No'length => '0') & std_logic_vector(a.Trig_No);
      y(5)  := std_logic_vector(a.Status);
      y(6)  := (31 downto a.ZPDPosition'length => '0') & std_logic_vector(a.ZPDPosition);
      y(7)  := (31 downto a.ZPDPeakVal'length => '0') & std_logic_vector(a.ZPDPeakVal);
      y(8)  := std_logic_vector(a.EndTimeStamp);
      return y;
   end to_ROIC_DCube_Footer_array32;
   
   function to_ROIC_DCube_Footer_array32_v2_6 (a: ROIC_DCube_Footer_v2_6) return ROIC_DCube_Footer_array32_v2_6 is
      variable y: ROIC_DCube_Footer_array32_v2_6;
   begin
      y(1)  := ROIC_FOOTER_FRAME & x"00000A"; -- Command Header + padding for 32 bit alignment
      y(2)  := std_logic_vector(a.Status);
      y(3)  := a.Direction & (30 downto a.Acq_Number'length => '0') & std_logic_vector(a.Acq_Number);
      y(4)  := (31 downto a.Write_No'length => '0') & std_logic_vector(a.Write_No);
      y(5)  := (31 downto a.Trig_No'length => '0') & std_logic_vector(a.Trig_No);        
      y(6)  := (31 downto a.ZPDPosition'length => '0') & std_logic_vector(a.ZPDPosition);
      y(7)  := (31 downto a.ZPDPeakVal'length => '0') & std_logic_vector(a.ZPDPeakVal);
      y(8)  := std_logic_vector(a.EndTimeStamp);
      y(9)  := std_logic_vector(a.NbPixelsAboveHighLimit);
      y(10) := std_logic_vector(a.NbPixelsAboveLowLimit);
      y(11) := a.Nav_Data_Tag;
      return y;
   end to_ROIC_DCube_Footer_array32_v2_6; 
   
   --  function to_std(x:boolean) return std_logic is
   --		variable	y : std_logic;
   --	begin
   --		if x then
   --			y := '1';
   --		else
   --			y := '0';
   --		end if;
   --		return y;
   --	end to_std; 
--   function to_NAV_DCube_Header_v2_6 (a: NAV_DCube_Header_array32_v2_6) return NAV_DCube_Header_v2_6 is
--      variable y: NAV_DCube_Header_v2_6;
--   begin
--      for i in 1 to y'length loop
--      y(i) := a(i + 1);           -- on enleve juste l'en-tête RIO 
--      end loop;
--      return y;
--   end to_NAV_DCube_Header_v2_6;
   
   
end package body CAMEL_Define;
