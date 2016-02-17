--------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: VP7_RS232_dispatcher.vhd
--  Hierarchy: Sub-module file
--  Use: To dispatch the appropriate RS232 responses to RS232 commands 0x92 0x93 and 0x94
--	 Project: FIRST2 FIRST Improvements
--	 By: Olivier Bourgois, Based on original rs232_TX_dispatcher by Patrick Dubois
--
--  Revision history:  (use CVS for exact code history)
--    OBO : Fev 03, 2006 - original implementation started
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-- pragma translate_off
library Common_HDL; -- Component double_sync is in library Common_HDL for simulation only
-- pragma translate_on
use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL;

entity VP7_RS232_dispatcher is		
   port(
      --------------------------------
      -- CLK and RESET
      --------------------------------
      CLK 				: in 	std_logic;
      RST 				: in 	std_logic;
      --------------------------------
      -- FPGA #1 RX
      --------------------------------	 
      FPGA1_RX_DVAL 	: in 	std_logic;
      FPGA1_RX_DATA 	: in 	std_logic_vector(7 downto 0);
      FPGA1_RX_EN 	: out std_logic;
      --------------------------------
      -- FPGA #2 RX
      --------------------------------				
      FPGA2_RX_DVAL 	: in 	std_logic;
      FPGA2_RX_DATA 	: in 	std_logic_vector(7 downto 0);
      FPGA2_RX_EN 	: out std_logic;
      --------------------------------
      -- MAIN TX
      --------------------------------			
      MAIN_TX_RDY 	: in 	STD_LOGIC;
      MAIN_TX_DVAL 	: out std_logic;
      MAIN_TX_DATA 	: out std_logic_vector(7 downto 0);
      --------------------------------
      -- REQUESTS
      --------------------------------
      CFG_REQ 			: in 	std_logic;   -- cmd 0x93 or 0x95
      STAT_REQ 		: in 	std_logic;   -- cmd 0x92
      STAT94_REQ     : in  std_logic;   -- cmd 0x94
      --------------------------------
      -- STATUS & CONFIG INPUTS
      --------------------------------		
      VP30_PRESENT   : in  std_logic;
      --CONFIG_PARAM 	: in 	DPBConfig;			
      VP7_STATUS		: in 	VP7StatusInfo);
end VP7_RS232_dispatcher;

architecture rtl of VP7_RS232_dispatcher is	
   
   -- state machine type declaration
   type t_State is (Idle, GetStat1, GetStat2, Reply_92, Reply_94);
   
   -- signal declarations
   signal State : t_State;
   signal RST_sync : std_logic;
   signal status_vect : std_logic_vector(47 downto 0);
   signal VP7_Cfg_Array : DPBConfig_array;
   signal VP7_latch : VP7StatusInfo;
   
   -- constant declarations
   constant STATUS_SIZE : integer := (DPB_REPLY_92_Len/3);	-- Size of each STATUS in bytes
   constant STATUSV2_SIZE : integer := (DPB_REPLY_94_Len/3); -- Size of each STATUS in bytes
   
begin
   
   -- config signal mapping to array
   --VP7_Cfg_Array <= to_DPBConfig_array(CONFIG_PARAM);
   
   -- process for latching status values appropriately
   status_vect <= to_std_logic_vector(VP7_latch);
   stat_latch : process(CLK)      
   begin
      if (CLK'event and CLK = '1') then
         if (RST_sync = '1') then
            VP7_latch <= VP7StatusInfo_default;
         else
            VP7_latch <= status_latch(VP7_STATUS, VP7_latch);
         end if;         
      end if;
   end process stat_latch;
   
   -- state machine
   fsm : process (CLK) 
      variable cnt : integer range 1 to DPBConfig_array'LENGTH;
      variable STAT94_REQ_pending : std_logic;
      variable STAT_REQ_pending : std_logic;
      variable CFG_REQ_pending : std_logic;
   begin
      if rising_edge(CLK) then
         if RST_sync = '1' then
            State <= Idle;
            cnt := 1;
            STAT94_REQ_pending := '0';
            STAT_REQ_pending := '0';
            CFG_REQ_pending := '0';
         else
            -- Latch requests
            if STAT94_REQ = '1' then
               STAT94_REQ_pending := '1';
            end if;
            if STAT_REQ = '1' then
               STAT_REQ_pending := '1';
            end if;
            if CFG_REQ = '1' then
               CFG_REQ_pending := '1';
            end if;
            
            -- Default values
            FPGA1_RX_EN <= '0';
            FPGA2_RX_EN <= '0';
            MAIN_TX_DVAL <= '0';			
            
            case State is
               
               when Idle =>
               cnt := 1;
               if (STAT94_REQ_pending = '1') or (STAT_REQ_pending = '1') then -- request 94/92	
                  State <=	GetStat1;	 
--               elsif CFG_REQ_pending = '1' then -- request 93
--                  State <=	Reply_93;
               end if;				  
               
               when GetStat1 =>
               FPGA1_RX_EN <= '1';
               if FPGA1_RX_DVAL = '1' or VP30_PRESENT = '0' then -- We assume that TX is always ready		
                  MAIN_TX_DVAL <= '1';
                  if VP30_PRESENT = '1' then                     
                     MAIN_TX_DATA <= FPGA1_RX_DATA;
                  else                             
                     MAIN_TX_DATA <= x"FF";
                  end if;
                  if (STAT_REQ_pending = '1' and cnt = STATUS_SIZE) or (STAT94_REQ_pending = '1' and cnt = STATUSV2_SIZE)then
                     FPGA1_RX_EN <= '0';	
                     State <= GetStat2;
                     cnt := 1;
                  else
                     cnt := cnt + 1;
                  end if;							
               end if;
               
               when GetStat2 =>
               FPGA2_RX_EN <= '1';
               if FPGA2_RX_DVAL = '1' or VP30_PRESENT = '0' then -- We assume that TX is always ready	
                  MAIN_TX_DVAL <= '1';
                  if VP30_PRESENT = '1' then                     
                     MAIN_TX_DATA <= FPGA2_RX_DATA;
                  else                             
                     MAIN_TX_DATA <= x"FF";
                  end if;					
                  if (STAT_REQ_pending = '1' and cnt = STATUS_SIZE) or (STAT94_REQ_pending = '1' and cnt = STATUSV2_SIZE) then
                     FPGA2_RX_EN <= '0';
                     if (STAT94_REQ_pending = '1') then
                        State <= Reply_94;
                     else
                        State <= Reply_92;
                     end if;
                     cnt := 1;
                  else
                     cnt := cnt + 1;
                  end if;						
               end if;
               
               when Reply_92 => -- Send internal STATUS word
               if MAIN_TX_RDY = '1' then
                  MAIN_TX_DVAL <= '1';	
                  if cnt = 1 then	
                     MAIN_TX_DATA <= status_vect(31 downto 24);
                  elsif cnt = 2 then
                     MAIN_TX_DATA <= status_vect(23 downto 16);
                  elsif cnt = 3 then
                     MAIN_TX_DATA <= status_vect(15 downto 8);
                  else
                     MAIN_TX_DATA <= status_vect(7 downto 0);
                  end if;
                  if cnt = STATUS_SIZE then
                     State <= Idle;
                     STAT_REQ_pending := '0';
                  else
                     cnt := cnt + 1;		
                  end if;
               end if;
               
               when Reply_94 => -- Send internal STATUS word V2
               if MAIN_TX_RDY = '1' then
                  MAIN_TX_DVAL <= '1';
                  case cnt is
                     when 1 =>
                     MAIN_TX_DATA <= status_vect(31 downto 24);
                     when 2 =>
                     MAIN_TX_DATA <= status_vect(23 downto 16);
                     when 3 =>
                     MAIN_TX_DATA <= status_vect(15 downto 8);
                     when 4 =>
                     MAIN_TX_DATA <= status_vect(7 downto 0);
                     when 5 =>
                     MAIN_TX_DATA <= VP7_latch.IntTemp;
                     when 6 =>
                     MAIN_TX_DATA <= VP7_latch.ExtTemp;
                     when others =>
                     null;
                  end case;
                  if cnt = STATUSV2_SIZE then
                     State <= Idle;
                     STAT94_REQ_pending := '0';
                  else
                     cnt := cnt + 1;		
                  end if;
               end if;
               
--               when Reply_93 =>
--               if MAIN_TX_RDY = '1' then
--                  MAIN_TX_DVAL <= '1';			
--                  MAIN_TX_DATA <= VP7_Cfg_Array(cnt);
--                  if cnt = DPBConfig_array'LENGTH then
--                     State <= Idle;
--                     CFG_REQ_pending := '0';
--                  else
--                     cnt := cnt + 1;		
--                  end if;
--               end if;
               
               when others =>
               State <= Idle;
               
            end case;
         end if;
      end if;
   end process fsm;
   
   sync_RST : entity double_sync
   port map( D => RST,
      Q => RST_sync,
      RESET => '0',
      CLK => CLK);
   
end rtl;
