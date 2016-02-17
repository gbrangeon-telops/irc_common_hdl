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
--                                               `!...........??`
---------------------------------------------------------------------------------------------------
--
-- Title       : VP7_CTRL
-- Design      : VP7
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library Common_HDL;  
use Common_HDL.Telops.all;
use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL;
use work.VP7_Define.all;

entity VP7_CTRL is     
   port(
      --------------------------------
      -- Configuration Inputs
      --------------------------------   
      EN_ROIC_FOOTER    : in  std_logic;  -- If '1', vp7_ctrl expects every datacube to end with a footer, no timeout.
      CONFIG            : in  CLinkConfig;
      CLINK_CFG         : out CLinkConfig;
      VP7_STATUS        : in  VP7StatusInfo;
      HEAD_ADD          : buffer std_logic_vector(8 downto 0);
      HEAD_DATA         : in  std_logic_vector(15 downto 0);
      --------------------------------
      -- Data Flow Control IOs
      --------------------------------
      HEAD_LL_MOSI      : out t_ll_mosi;
      HEAD_LL_MISO      : in  t_ll_miso;
      
      SW_SEL            : out std_logic_vector(2 downto 0);       
      SW_DVAL           : in  std_logic;
      SW_EOF            : in  std_logic;
      DIAG_RUN          : out std_logic;
      DIAG_EOF          : in  std_logic; 
      
      FP1_NEW_DCUBE     : in  std_logic;
      FP1_EOD           : in  std_logic;
      FP1_PAYLOAD_BEGIN : in  std_logic;      
      FP1_FRAME_TYPE    : in  std_logic_vector(7 downto 0);
      FP1_PROC_HEADER   : in  DPB_DCube_Header;      
      FP1_ROIC_HEADER   : in  ROIC_DCube_Header;
      FP1_ROIC_FOOTER   : in  ROIC_DCube_Footer;                  
      FP1_FIFO_EMPTY    : in  std_logic;      
      
      FP2_NEW_DCUBE     : in  std_logic;
      FP2_PAYLOAD_BEGIN : in  std_logic;
      FP2_PROC_HEADER   : in  DPB_DCube_Header;
      FP2_EOD           : in  std_logic;
      FP2_FIFO_EMPTY    : in  std_logic;
      
      CLINK_DONE        : in  std_logic;
      CLINK_CFG_ERR     : out std_logic; 
      IMG_CNT_ERR       : out std_logic;
      --SIZE_ERR          : out std_logic;
      --CONFIG_ERR        : out std_logic;
      INIT_CAML         : out std_logic;
      FORCE_CAML_END    : out std_logic; -- This will flush the fifo and stop CameraLink gracefully (with zeros).
      --------------------------------
      -- CameraLink Config 
      --------------------------------
      --CLINK_PARAM       : out Camera_Link_Param_type; 
      --------------------------------
      -- Other IOs
      --------------------------------
      ARESET            : in  STD_LOGIC;
      CLK               : in  std_logic
      --------------------------------
      );
end VP7_CTRL;

architecture VP7_CTRL of VP7_CTRL is
   
   signal DCube_Footer_V3_array : DCUBE_FOOTER_V3_array;
   
   -- State machine
   type t_Run_State is (Stop, Init, WaitForNewDCubeFromFPGA1, WaitForNewDCubeFromFPGA2, WaitForNotFifoEmpty, SendHeader1, SendHeader2, SendHeader3, SendPayload, ExitFromSpectro, DIAG1, DoZeroFilling, ExitFromDiag);
   signal Run_State : t_Run_State;
   
   type t_RunMode is (Unknown, ROICCamera, ROICSpectro, ProcSpectro, Diag1);
   signal RunMode : t_RunMode;   
   
   signal HEAD_VALID_buf : std_logic;
   signal Head_cnt : unsigned(15 downto 0); --unsigned(FP1_PROC_HEADER.Config.Camera_Link_Param.HeaderSize'HIGH downto 0);
   
   attribute keep : string; 
   attribute keep of Head_cnt: signal is "true";    
   
   signal RESET : std_logic;
   
   -- pragma translate_off
   signal DCUBE_footer_struct : DCUBE_FOOTER_V3;
   -- pragma translate_on  
   
   signal Interleave       : std_logic_vector(1 downto 0);          
   --signal SIZE_ERRi        : std_logic;
   signal CLINK_CFG_ERRi     : std_logic;
   signal IMG_CNT_ERRi     : std_logic;
   signal FORCE_CAML_ENDi  : std_logic;
   
   signal SW_SELi          : std_logic_vector(2 downto 0);  
   
   signal CONFIG_reg       : CLinkConfig;  
   
   constant WaitForCLink   : boolean := FALSE;
   
begin         
   sync_RESET_inst : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK); 
   
   CLINK_CFG <= CONFIG_reg;
   
   SW_SEL <= SW_SELi;
   
   HEAD_LL_MOSI.SOF <= '0';
   HEAD_LL_MOSI.EOF <= '0';
   HEAD_LL_MOSI.SUPPORT_BUSY <= '1';     
   --SIZE_ERR <= SIZE_ERRi; 
   CLINK_CFG_ERR <= CLINK_CFG_ERRi;
   IMG_CNT_ERR <= IMG_CNT_ERRi;
   FORCE_CAML_END <= FORCE_CAML_ENDi;  
   
   -- pragma translate_off
   DCUBE_footer_struct <= to_DCUBE_FOOTER_V3(DCube_Footer_V3_array);
   -- pragma translate_on              
   
   DCube_footer_V3_array <= to_DCUBE_FOOTER_V3_array(FP1_PROC_HEADER, FP2_PROC_HEADER, VP7_STATUS) when (RunMode = ProcSpectro) -- in V3 we need info from all 3 FPGAs to get status data      
   else to_DCUBE_FOOTER_V3_array(FP1_ROIC_HEADER, VP7_STATUS);
   
   HEAD_ADD <= std_logic_vector(Head_cnt(HEAD_ADD'LENGTH-1 downto 0));  
   
   ------------------------
   -- Main State Machine --
   ------------------------
   fsm_process : process (CLK,RESET)                      
      variable CLimit1 : integer range 0 to 1023;
      variable CLimit2 : integer range 0 to 2047;
      variable CLimit3 : unsigned(15 downto 0); -- range 0 to (2**FPGA1_HEADER.Config.Camera_Link_Param.HeaderSize'LENGTH)-1;
      variable RunEnd : std_logic;
      variable RAM_DValid : std_logic;
      variable FirstRAMRead : boolean;
      variable TimeOutCnt : unsigned(20 downto 0); 
      --variable EOD : std_logic;    
      variable ToggleSwitch : std_logic;
      
   begin 
      if rising_edge(CLK) then
         if RESET = '1' then
            SW_SELi <= SW_NONE;
            HEAD_LL_MOSI.DVAL <= '0';
            Head_cnt <= (others => '0');
            CLimit1 := 0;
            CLimit2 := 0;
            CLimit3 := (others => '0');
            DIAG_RUN <= '0';
            Run_State <= Stop;
            RunEnd := '0'; 
            Run_State <= Stop;
            RAM_DValid := '0'; 
            FirstRAMRead := TRUE;
            HEAD_VALID_buf <= '0';
            TimeOutCnt := (others => '0');
            CLINK_CFG_ERRi <= '0'; 
            IMG_CNT_ERRi <= '0';
            INIT_CAML <= '0';
            --CONFIG_ERR <= '0';
            --EOD := '0';           
            --SIZE_ERRi <= '0';             
            
         else
            
            case Run_State is          
               -----------------------
               -- Stop Mode State        
               -----------------------          
               when Stop =>
                  -- Unconditionnal Statements
                  SW_SELi <= SW_NONE;        
                  --SIZE_ERRi <= '0';
                  CLINK_CFG_ERRi <= '0';
                  FORCE_CAML_ENDi <= '0';                    
                  -- Next State  
                  if CONFIG.Valid then
                     CONFIG_reg <= CONFIG;
                     if CONFIG.Mode = CLINK_MODE_DIAG1 then
                        Run_State <= Init;
                        RunMode <= Diag1;                                         
                     elsif FP1_FIFO_EMPTY = '0' and FP2_FIFO_EMPTY = '0' then -- Incoming data
                        Run_State <= Init; 
                        RunMode <= Unknown;
                     end if;    
                  end if;
                  
                  -----------------------
                  -- Init State
                  -----------------------
               when Init =>
                  SW_SELi <= SW_NONE;
                  FORCE_CAML_ENDi <= '0';
                  Head_cnt <= (others => '0');
                  RAM_DValid := '0'; 
                  FirstRAMRead := TRUE;
                  HEAD_VALID_buf <= '0';
                  HEAD_LL_MOSI.DVAL <= '0';
                  TimeOutCnt := (others => '0');
                  CLINK_CFG_ERRi <= '0'; 
                  IMG_CNT_ERRi <= '0';
                  INIT_CAML <= '0';
                  ToggleSwitch := '0';
                  
                  if (CONFIG_reg.HeaderVersion = x"3") then -- HeaderVersion V3
                     CLimit1 := DCUBE_HEADER_V3_size/2;                    
                     CLimit2 := DCUBE_FOOTER_V3_size/2 + DCUBE_HEADER_V3_size/2; 
                     CLimit3 := CONFIG_reg.HeaderSize;                                              
                  else
                     assert FALSE report "Only header v3 is supported." severity ERROR;
                  end if;               
                  
                  if RunMode = Diag1 then-- Datacube is internally generated by VP7 (Camera Mode)                                                    
                     Run_State <= Diag1;                      
                  else
                     Run_State <= WaitForNewDCubeFromFPGA1;
                  end if;            
                  
                  
                  ----------------------------------
                  -- WaitForNewDCubeFromFPGA1 State       
                  ----------------------------------
               when WaitForNewDCubeFromFPGA1 => 
                  
                  SW_SELi <= SW_FP1;  
                  
                  if FP1_PAYLOAD_BEGIN = '1' then  
                     SW_SELi <= SW_NONE;
                     
                     if FP1_FRAME_TYPE = ROIC_CAMERA_FRAME then
                        Run_State <= SendPayload;
                        Interleave <= BSQ;    
                        RunMode <= ROICCamera;                                                                      
                        
                     elsif FP1_FRAME_TYPE = PROC_DCUBE_FRAME then
                        Run_State <= WaitForNewDCubeFromFPGA2;        
                        Interleave <= BIP;
                        RunMode <= ProcSpectro; 
                        
                     elsif FP1_FRAME_TYPE = ROIC_DCUBE_FRAME_OLD then
                        Run_State <= WaitForNewDCubeFromFPGA2;        
                        Interleave <= BSQ;    
                        RunMode <= ROICSpectro;
                        
                     end if;
                  end if;
                  
                  
                  ----------------------------------
                  -- WaitForNewDCubeFromFPGA2 State
                  ----------------------------------
               when WaitForNewDCubeFromFPGA2 =>
                  SW_SELi <= SW_FP2;  
                  if FP2_PAYLOAD_BEGIN = '1' then 
                     SW_SELi <= SW_NONE;
                     if RunMode = ROICCamera then -- Go directly to payload, no datacube header
                        Run_State <= SendPayload;        
                     else
                        Run_State <= WaitForNotFifoEmpty;
                     end if;
                  end if;                                          
                  
                  ----------------------------------
                  -- WaitForNotFifoEmpty State
                  ----------------------------------
               when WaitForNotFifoEmpty =>
                  SW_SELi <= SW_HEAD;
                  if (FP1_FIFO_EMPTY = '0' and FP2_FIFO_EMPTY = '0') then
                     Run_State <= SendHeader1;  
                  end if;
                  
                  ----------------------------------
                  -- SendHeader1 State              
                  ----------------------------------
               when SendHeader1 =>
                  SW_SELi <= SW_HEAD;                
                  if HEAD_LL_MISO.BUSY = '0' then
                     
                     HEAD_LL_MOSI.DATA <= HEAD_DATA; 
                     HEAD_LL_MOSI.DVAL <= HEAD_VALID_buf;
                     
                     if Head_cnt < CLimit1 then
                        HEAD_VALID_buf <= not HEAD_LL_MISO.AFULL and not HEAD_LL_MISO.BUSY;
                     else
                        HEAD_VALID_buf <= '0';
                     end if;
                     
                     if HEAD_LL_MISO.AFULL = '0' then 
                        Head_cnt <= Head_cnt + 1;
                        
                        -- Manage end of SendHeader1
                        if Head_cnt >= (CLimit1+1) then -- +1 for Block RAM latency
                           Head_cnt <= to_unsigned(CLimit1,16);
                           Run_State <= SendHeader2;
                        end if;              
                     end if; 
                  else      
                     -- Keep everything as is
                  end if;                   
                  
                  ----------------------------------
                  -- SendHeader2 State              
                  ----------------------------------     
               when SendHeader2 =>
                  SW_SELi <= SW_HEAD;             
                  if HEAD_LL_MISO.BUSY = '0' then
                     if HEAD_LL_MISO.AFULL = '0' then 
                        HEAD_LL_MOSI.DVAL <= '1';
                        if Head_cnt < CLimit2 then                               
                           if CONFIG_reg.HeaderVersion = x"3" then
                              HEAD_LL_MOSI.DATA <= DCube_Footer_V3_array(to_integer(Head_cnt)-CLimit1+1);  
                           else
                              assert FALSE report "Only header v3 is supported." severity ERROR;   
                           end if;
                           if Head_cnt < 2**Head_cnt'HIGH then
                              Head_cnt <= Head_cnt + 1; 
                           end if;
                        else 
                           HEAD_LL_MOSI.DVAL <= '0';
                           Run_State <= SendHeader3;
                        end if;
                     else -- HEAD_LL_MISO.AFULL = '1'
                        HEAD_LL_MOSI.DVAL <= '0';
                     end if;       
                  else      
                     -- Keep everything as is
                  end if;                  
                  
                  ----------------------------------
                  -- SendHeader3 State              
                  ----------------------------------
               when SendHeader3 =>
                  SW_SELi <= SW_HEAD;                                    
                  if HEAD_LL_MISO.BUSY = '0' then
                     if HEAD_LL_MISO.AFULL = '0'then 
                        HEAD_LL_MOSI.DVAL <= '1';
                        if Head_cnt < CLimit3 then --CLimit3
                           HEAD_LL_MOSI.DATA <= X"0000";
                           --HEAD_LL_MOSI.DATA <= std_logic_vector(Head_cnt);
                           if Head_cnt < 2**(Head_cnt'HIGH+1) then 
                              Head_cnt <= Head_cnt + 1; 
                           end if;
                        else 
                           HEAD_LL_MOSI.DVAL <= '0'; 
                           Run_State <= SendPayload;                           
                           SW_SELi <= SW_FP1;
                        end if;
                     else -- HEAD_LL_MISO.AFULL = '1'
                        HEAD_LL_MOSI.DVAL <= '0';
                     end if;                     
                  else      
                     -- Keep everything as is
                  end if;
                  
                  ----------------------------------
                  -- SendPayload State              
                  ----------------------------------
               when SendPayload =>            
                  HEAD_LL_MOSI.DATA <= X"0000";  
                  HEAD_LL_MOSI.DVAL <= '0';
                  
                  ToggleSwitch := '0'; -- Default
                  if (SW_DVAL = '1') then
                     TimeOutCnt := (others => '0');                           
                     
                     -- BSQ mode
                     if Interleave = BSQ then 
                        ToggleSwitch := '1';      
                     elsif Interleave = BIP then                                      
                        if SW_EOF = '1' then
                           ToggleSwitch := '1';
                        end if;
                     else
                        assert FALSE report "Interleave not supported" severity ERROR;
                     end if;                                          
                  end if;                        
                  
                  if ToggleSwitch = '1' then
                     ToggleSwitch := '0';
                     if SW_SELi = SW_FP1 then
                        SW_SELi <= SW_FP2;   
                     elsif SW_SELi = SW_FP2 then   
                        SW_SELi <= SW_FP1;   
                     end if;                   
                  end if;     
                  
                  if (SW_SELi = SW_FP1 and FP1_NEW_DCUBE = '1') or (SW_SELi = SW_FP2 and FP2_NEW_DCUBE = '1') or (FP2_EOD = '1' and EN_ROIC_FOOTER = '1') then
                     Run_State <= ExitFromSpectro;
                     SW_SELi <= SW_NONE;
                     --EOD := '1';  
                  else
                     -- Detect SIZE Error
                     if (FP1_NEW_DCUBE = '1' or FP2_NEW_DCUBE = '1') and RunMode = ROICSpectro then
                        IMG_CNT_ERRi <= '1';
                        Run_State <= DoZeroFilling;
                        SW_SELi <= SW_NONE;    
                        assert FALSE report "IMG_CNT_ERR! New cube arrived but previous wasn't finished." severity WARNING;
                     end if;                     
                  end if;                  
                  
                  -- Do zero filling UNTIL CLINK_DONE
--                  if (IMG_CNT_ERRi = '1') and HEAD_LL_MISO.AFULL = '0' and HEAD_LL_MISO.BUSY = '0' then
--                     HEAD_LL_MOSI.DVAL <= '1';                     
--                  else
--                     HEAD_LL_MOSI.DVAL <= '0';
--                  end if; 
                  
                  
                  
                  if EN_ROIC_FOOTER = '0' then  -- Need timeout if no footer                    
                     -- Detect Timeout Error 
                     -- This timeout should be longer than the normal delay between two images, 
                     -- BUT shorter than the time required for a turn-around of the interferometer.
                     if TimeOutCnt(20) = '1' -- 2^20 * 20 ns = 20.97 ms. 
                        -- pragma translate_off
                        or TimeOutCnt(12) = '1'
                        -- pragma translate_on
                        then -- No more data will come from ROIC                   
                        if RunMode = ROICSpectro then
                           if CLINK_DONE = '0' then
                              IMG_CNT_ERRi <= '1';  
                              assert FALSE report "IMG_CNT_ERRi! Cube never finished (timeout), missing images." severity WARNING;                     
                              --SW_SELi <= SW_HEAD;  
                              Run_State <= DoZeroFilling;
                              SW_SELi <= SW_NONE;     
                           else                   
                              -- The cube is actually probably finished
                              Run_State <= Stop;
                              SW_SELi <= SW_NONE;
                              --EOD := '1';                                
                           end if;
                        end if;                                          
                     else
                        TimeOutCnt := TimeOutCnt + 1;          
                     end if;                       
                     
                  else
                     -- The timeout logic above (now gone) is now replaced by the FP1_EOD signal
                     if FP1_EOD = '1' then -- It means that there are missing images in the cube if we see that signal in this state
                        IMG_CNT_ERRi <= '1';
                        SW_SELi <= SW_HEAD;
                     end if;
                  end if;  
                  
                  ----------------------------------
                  -- DoZeroFilling State             
                  ----------------------------------
                  when DoZeroFilling =>
                  SW_SELi <= SW_NONE;          
                  FORCE_CAML_ENDi <= '1';
                  if CLINK_DONE = '1' then  
                     Run_State <= Stop;  
                     FORCE_CAML_ENDi <= '0';                     
                  end if;                                    
                  
                  ----------------------------------
                  -- ExitFromSpectro State             
                  ----------------------------------
               when ExitFromSpectro =>
                  SW_SELi <= SW_NONE;    
                  
                  if WaitForCLink then
                     if CLINK_DONE = '1' then 
                        Run_State <= Stop;
                        
                        -- Worst-case timeout : the time taken to send one complete CameraLink line + LValPause = ~ 2 ms 
                        -- WILL NEVER HAPPEN UNLESS THERE IS A PROBLEM WITH THE CAMERALINK CONFIG
                     elsif (TimeOutCnt(17) = '1' and FORCE_CAML_ENDi = '0') -- 2.62 ms : Data never completely got out of CameraLink fifo in time.
                        -- pragma translate_off
                        or (TimeOutCnt > (CONFIG_reg.LValSize*3) and FORCE_CAML_ENDi = '0' and TimeOutCnt > 500)
                        -- pragma translate_on
                        then 
                        FORCE_CAML_ENDi <= '1';
                        CLINK_CFG_ERRi <= '1';
                        TimeOutCnt := (others => '0'); -- Reset timeout and wait for CameraLink to finish.
                     elsif (TimeOutCnt(17) = '1' and FORCE_CAML_ENDi = '1') -- 2.62 ms : Data never completely got out of CameraLink fifo in time.
                        -- pragma translate_off
                        or (TimeOutCnt > (CONFIG_reg.LValSize*3) and FORCE_CAML_ENDi = '1' and TimeOutCnt > 500)
                        -- pragma translate_on
                        then
                        CLINK_CFG_ERRi <= '1';
                        INIT_CAML <= '1';
                        Run_State <= Stop;                       
                     elsif TimeOutCnt(17) = '0' then
                        TimeOutCnt := TimeOutCnt + 1;          
                     else -- CLink not finished, wait or wait until timeout 
                        Run_State <= ExitFromSpectro;
                     end if; 
                  else
                     Run_State <= Stop;   
                  end if;
                  
                  
                  --------------------------
                  -- Diagnostic Mode #1
                  --------------------------
               when Diag1 =>
                  SW_SELi <= SW_DIAG;
                  DIAG_RUN <= '1'; 
                  if DIAG_EOF = '1' then
                     DIAG_RUN <= '0';
                     Run_State <= ExitFromDiag;  
                     SW_SELi <= SW_NONE;
                  end if;          
                  
                  --------------------------
                  -- ExitFromDiag
                  --------------------------          
               when ExitFromDiag =>
                  SW_SELi <= SW_NONE;
                  if CLINK_DONE = '1' then
                     Run_State <= Stop;
                  elsif TimeOutCnt(17) = '1' then
                     CLINK_CFG_ERRi <= '1';
                     INIT_CAML <= '1';
                     Run_State <= Stop;
                  elsif TimeOutCnt(17) = '0' then
                     TimeOutCnt := TimeOutCnt + 1;          
                  else -- CLink not finished, wait or wait until timeout 
                     Run_State <= ExitFromDiag;
                  end if;           
                  
                  
                  --------------------------
                  -- Other Unknown Modes    
                  --------------------------
               when others =>      
               SW_SELi <= SW_NONE;
               Run_State <= Stop;
            end case;
         end if; 
      end if;
   end process;
   
end VP7_CTRL;