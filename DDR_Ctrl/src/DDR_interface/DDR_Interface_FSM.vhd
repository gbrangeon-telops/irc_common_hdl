-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : ddr_ctrl_test
-- Author      : Patrick Dubois
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- File        : d:\telops\Common_HDL\DDR_Ctrl\Active-HDL\ddr_ctrl_test\compile\DDR_Interface_FSM.vhd
-- Generated   : 05/25/07 12:46:17
-- From        : D:\telops\Common_HDL\DDR_Ctrl\src\User-Interface\DDR_Interface_FSM.asf
-- By          : FSM2VHDL ver. 5.0.3.2
--
-------------------------------------------------------------------------------
--
-- Description : 
-- Modified by :  JDE                        25-05-2007
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;   

entity DDR_Interface_FSM is 
   generic (
      SOURCE_CONSECUTIVE_CMDS : std_logic_vector(4 downto 0) := "01111"
   );
	port (
		RESET:      in  std_logic;
		CLK:        in  std_logic;
		CORE_afull: in  std_logic;
		RAF1_empty: in  std_logic;
		RAF2_empty: in  std_logic;
		RAF3_empty: in  std_logic;
      RDF1_afull: in  std_logic;
      RDF2_afull: in  std_logic;
      RDF3_afull: in  std_logic;
		WF1_empty:  in  std_logic;
		WF2_empty:  in  std_logic;
		RAF1_rd_en: out std_logic;
		RAF2_rd_en: out std_logic;
		RAF3_rd_en: out std_logic;
		WF1_rd_en:  out std_logic;
		WF2_rd_en:  out std_logic;
      state_wr1:  out std_logic;
      state_wr2:  out std_logic;
      state_rd1:  out std_logic;
      state_rd2:  out std_logic;
      state_rd3:  out std_logic);
end DDR_Interface_FSM;

architecture FSM of DDR_Interface_FSM is

type State_type is (Init, Write1, Write2, Read1, Read2, Read3);

signal State         : State_type;

signal RD1_cnt       : unsigned(4 downto 0);
signal RD1_ready     : std_logic;
signal RD1_done      : std_logic;
signal RD1_rd_en_nxt : std_logic;

signal RD2_cnt       : unsigned(4 downto 0);
signal RD2_ready     : std_logic;
signal RD2_done      : std_logic;     
signal RD2_rd_en_nxt : std_logic;

signal RD3_cnt       : unsigned(4 downto 0);
signal RD3_ready     : std_logic;
signal RD3_done      : std_logic;
signal RD3_rd_en_nxt : std_logic;

signal WR1_cnt       : unsigned(4 downto 0);		
signal WR1_ready     : std_logic;
signal WR1_done      : std_logic;
signal WF1_rd_en_nxt : std_logic;

signal WR2_cnt       : unsigned(4 downto 0);		
signal WR2_ready     : std_logic;
signal WR2_done      : std_logic;
signal WF2_rd_en_nxt : std_logic;

begin

-- To indicate when a state is ready to get control
WR1_ready <= not WF1_empty;
WR2_ready <= not WF2_empty;
RD1_ready <= not RAF1_empty and not RDF1_afull;
RD2_ready <= not RAF2_empty and not RDF2_afull;
RD3_ready <= not RAF3_empty and not RDF3_afull;

-- To indicate when a state is ready to leave control to another state
WR1_done  <= '1' when WR1_cnt = unsigned(SOURCE_CONSECUTIVE_CMDS) or WR1_ready = '0' else '0';
WR2_done  <= '1' when WR2_cnt = unsigned(SOURCE_CONSECUTIVE_CMDS) or WR2_ready = '0' else '0';
RD1_done  <= '1' when RD1_cnt = unsigned(SOURCE_CONSECUTIVE_CMDS) or RD1_ready = '0' else '0';
RD2_done  <= '1' when RD2_cnt = unsigned(SOURCE_CONSECUTIVE_CMDS) or RD2_ready = '0' else '0';
RD3_done  <= '1' when RD3_cnt = unsigned(SOURCE_CONSECUTIVE_CMDS) or RD2_ready = '0' else '0';

-- Read enable generation
WF1_rd_en  <= WR1_ready when WF1_rd_en_nxt='1' else '0';
WF2_rd_en  <= WR2_ready when WF2_rd_en_nxt='1' else '0';
RAF1_rd_en <= RD1_ready when RD1_rd_en_nxt='1' else '0';
RAF2_rd_en <= RD2_ready when RD2_rd_en_nxt='1' else '0';
RAF3_rd_en <= RD3_ready when RD3_rd_en_nxt='1' else '0';

----------------------------------------------------------------------
-- Machine: State
----------------------------------------------------------------------
State_machine: process (CLK)
begin
	if CLK'event and CLK = '1' then
		if RESET='1' then	
			State          <= Init;
			RD1_cnt        <= (others => '0');
			RD2_cnt        <= (others => '0');
			RD3_cnt        <= (others => '0');
			WR1_cnt        <= (others => '0');
			WR2_cnt        <= (others => '0');
         WF1_rd_en_nxt  <= '0';
         WF2_rd_en_nxt  <= '0';
         RD1_rd_en_nxt  <= '0';
         RD2_rd_en_nxt  <= '0';
         RD3_rd_en_nxt  <= '0';
		else
         WF1_rd_en_nxt  <= '0';
         WF2_rd_en_nxt  <= '0';
         RD1_rd_en_nxt  <= '0';
         RD2_rd_en_nxt  <= '0';
         RD3_rd_en_nxt  <= '0';
			case State is
				when Init =>
					RD1_cnt <= (others => '0');
					RD2_cnt <= (others => '0');
					RD3_cnt <= (others => '0');
					WR1_cnt <= (others => '0');
					WR2_cnt <= (others => '0');
               WF1_rd_en_nxt  <= '0';
               WF2_rd_en_nxt  <= '0';
               RD1_rd_en_nxt  <= '0';
               RD2_rd_en_nxt  <= '0';
               RD3_rd_en_nxt  <= '0';
					State <= Read1;
				when Write1 =>
               -- Counter for minimum consecutive reads and writes
					if CORE_afull='0' and WR1_done = '0' then
                  WF1_rd_en_nxt  <= '1';
					   WR1_cnt <= WR1_cnt + 1;
					end if;
               -- If another state is ready, switch state when minimum consecutive operations are done
               if WR1_done='1' then
                  wr1_cnt <= (others => '0');
   					if WR2_ready='1' then
	   					State <= Write2;
                     if CORE_afull = '0' then WF2_rd_en_nxt <= '1'; end if;
			   		elsif RD1_ready='1' then
				   		State <= Read1;
                     if CORE_afull = '0' then RD1_rd_en_nxt <= '1'; end if;
   					elsif RD2_ready='1' then
	   					State <= Read2;
                     if CORE_afull = '0' then RD2_rd_en_nxt <= '1'; end if;
			   		elsif RD3_ready='1' then
				   		State <= Read3;
                     if CORE_afull = '0' then RD3_rd_en_nxt <= '1'; end if;
                  elsif CORE_afull = '0' then WF1_rd_en_nxt <= '1';
                  end if;
               elsif CORE_afull = '0' then
                  WF1_rd_en_nxt <= '1';
					end if;
				when Write2 =>
               -- Counter for minimum consecutive reads and writes
					if CORE_afull='0' and WR2_done = '0' then
                  WF2_rd_en_nxt  <= '1';
                  WR2_cnt        <= WR2_cnt + 1;
					end if;
               -- If another state is ready, switch state when minimum consecutive operations are done
               if WR2_done='1' then
                  wr2_cnt <= (others => '0');
   					if RD1_ready='1' then
	   					State <= Read1;
                     if CORE_afull = '0' then RD1_rd_en_nxt <= '1'; end if;
			   		elsif RD2_ready='1' then
				   		State <= Read2;
                     if CORE_afull = '0' then RD2_rd_en_nxt <= '1'; end if;
   					elsif RD3_ready='1' then
	   					State <= Read3;
                     if CORE_afull = '0' then RD3_rd_en_nxt <= '1'; end if;
			   		elsif WR1_ready='1' then
				   		State <= Write1;
                     if CORE_afull = '0' then WF1_rd_en_nxt <= '1'; end if;
                  elsif CORE_afull = '0' then WF2_rd_en_nxt <= '1';
                  end if;
					end if;
				when Read1 =>
               -- Counter for minimum consecutive reads and writes
					if CORE_afull='0' and RD1_done = '0' then
                  RD1_rd_en_nxt  <= '1';
					   RD1_cnt <= RD1_cnt + 1;
					end if;
               -- If another state is ready, switch state when minimum consecutive operations are done
               if RD1_done='1' then
                  rd1_cnt <= (others => '0');
   					if RD2_ready='1' then
	   					State <= Read2;
                     if CORE_afull = '0' then RD2_rd_en_nxt <= '1'; end if;
			   		elsif RD3_ready='1' then
				   		State <= Read3;
                     if CORE_afull = '0' then RD3_rd_en_nxt <= '1'; end if;
   					elsif WR1_ready='1' then
	   					State <= Write1;
                     if CORE_afull = '0' then WF1_rd_en_nxt <= '1'; end if;
			   		elsif WR2_ready='1' then
				   		State <= Write2;
                     if CORE_afull = '0' then WF2_rd_en_nxt <= '1'; end if;
                  elsif CORE_afull = '0' then RD1_rd_en_nxt <= '1';
                  end if;
					end if;
				when Read2 =>
               -- Counter for minimum consecutive reads and writes
					if CORE_afull='0' and RD2_done = '0' then
                  RD2_rd_en_nxt  <= '1';
					   RD2_cnt <= RD2_cnt + 1;
					end if;
               -- If another state is ready, switch state when minimum consecutive operations are done
               if RD2_done='1' then
                  rd2_cnt <= (others => '0');
   					if RD3_ready='1' then
	   					State <= Read3;
                     if CORE_afull = '0' then RD3_rd_en_nxt <= '1'; end if;
			   		elsif WR1_ready='1' then
				   		State <= Write1;
                     if CORE_afull = '0' then WF1_rd_en_nxt <= '1'; end if;
   					elsif WR2_ready='1' then
	   					State <= Write2;
                     if CORE_afull = '0' then WF2_rd_en_nxt <= '1'; end if;
			   		elsif RD1_ready = '1' then
				   		State <= Read1;
                     if CORE_afull = '0' then RD1_rd_en_nxt <= '1'; end if;
                  elsif CORE_afull = '0' then RD2_rd_en_nxt <= '1';
                  end if;
					end if;
				when Read3 =>
               -- Counter for minimum consecutive reads and writes
					if CORE_afull='0' and RD3_done = '0' then
                  RD3_rd_en_nxt  <= '1';
					   RD3_cnt <= RD3_cnt + 1;
					end if;
               -- If another state is ready, switch state when minimum consecutive operations are done
               if RD3_done='1' then
                  rd3_cnt <= (others => '0');
   					if WR1_ready='1' then
	   					State <= Write1;
                     if CORE_afull = '0' then WF1_rd_en_nxt <= '1'; end if;
			   		elsif WR2_ready='1' then
				   		State <= Write2;
                     if CORE_afull = '0' then WF2_rd_en_nxt <= '1'; end if;
   					elsif RD1_ready='1' then
	   					State <= Read1;
                     if CORE_afull = '0' then RD1_rd_en_nxt <= '1'; end if;
			   		elsif RD2_ready='1' then
				   		State <= Read2;
                     if CORE_afull = '0' then RD2_rd_en_nxt <= '1'; end if;
                  elsif CORE_afull = '0' then RD3_rd_en_nxt <= '1';
                  end if;
					end if;
				when others =>
					State <= Init;
			end case;
		end if;
	end if;
end process;

-- State outputs
state_wr1 <= '1' when State = Write1 else '0';
state_wr2 <= '1' when State = Write2 else '0';
state_rd1 <= '1' when State = Read1  else '0';
state_rd2 <= '1' when State = Read2  else '0';
state_rd3 <= '1' when State = Read3  else '0';

end FSM;
