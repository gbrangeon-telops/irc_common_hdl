-------------------------------------------------------------------------------
--
-- Title       : SerialLink_TX
-- Design      : Inter_FPGA_Link
-- Author      : Telops
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\FIR-00229\Active-HDL\Inter_FPGA_Link\Inter_FPGA_Link\src\SerialLink_TX.vhd
-- Generated   : Wed Dec 23 14:31:56 2009
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {SerialLink_TX} architecture {SerialLink_TX}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;    
library Common_HDL; 
use Common_HDL.Telops.all;



entity SerialLink_TX is
	 port(
		 CLK_20MHz : in STD_LOGIC;
		 ARESET : in STD_LOGIC;
		 RX_LL_MOSI : in T_LL_MOSI8;
		 SERIAL_TX : out STD_LOGIC;
		 RX_LL_MISO : out T_LL_MISO
	     );
end SerialLink_TX;

--}} End of automatically maintained section

architecture SerialLink_TX of SerialLink_TX is

	component sync_reset
		port(
			ARESET : in std_logic;
			SRESET : out std_logic;
			CLK : in std_logic);
	end component;
				  
	signal 	sreset_sig, READY : std_logic;
						
	signal v9_data_sig : std_logic_vector(8 downto 0);	
	signal v8_data_in_s : std_logic_vector(7 downto 0);	
	signal v4_count_sig : unsigned(3 downto 0);
	
	constant IDLE_c  : std_logic:='0';
	constant SHIFT_c : std_logic:='1';
	
	signal tx_fsm_sig : std_logic;
	signal dataInValid_s : std_logic;
	signal busy_s : std_logic;	
	signal SERIAL_TX_sig : std_logic;	 

	attribute IOB : string;
	attribute IOB of SERIAL_TX : signal is "FORCE"; 

begin	
	-- enter your statements here -- 	
	RX_LL_MISO.AFULL 	<= '0';
	RX_LL_MISO.BUSY 	<= busy_s;
	--
	v8_data_in_s <= RX_LL_MOSI.DATA;
	dataInValid_s <= RX_LL_MOSI.DVAL;
		
 	-- Sync Reset
 	sync_RESET_TX :  sync_reset
     port map(
 	ARESET 	=> ARESET,
 	SRESET 	=> sreset_sig,
 	CLK 	=> CLK_20MHz
 	); 
	 
	-- This stage should be infered into IOB FF	
	process(CLK_20MHz)
	begin
		if rising_edge(CLK_20MHz)then
			SERIAL_TX <= SERIAL_TX_sig;	
		end if;
	end process; 
 	
	process(CLK_20MHz)
	begin
		if rising_edge(CLK_20MHz)then
			if sreset_sig = '1' then
				tx_fsm_sig 	<= IDLE_c;
				busy_s		<= '1'; 
				SERIAL_TX_sig	<= '1'; -- avoid false start at reset				
				v4_count_sig <= x"0";				
			else
				case tx_fsm_sig is
					when IDLE_c =>
						if dataInValid_s = '1' then	 														
							busy_s		<= '1';	-- stop the fifo							
							SERIAL_TX_sig <= '0';   -- send start bit
							v9_data_sig <= '1' & v8_data_in_s;
							tx_fsm_sig <= SHIFT_c;						
						else
							busy_s		<= '0'; -- accept new data from fifo
							tx_fsm_sig <= IDLE_c;
						end if;	 
						
					when SHIFT_c => 						
						-- Left shif
						SERIAL_TX_sig <= v9_data_sig(0);
					    v9_data_sig <= '1' & v9_data_sig(8 downto 1);
						-- Count shifted data
					    v4_count_sig <= v4_count_sig + 1;					
					    if v4_count_sig = x"9" then
					        v4_count_sig <= x"0";
					        tx_fsm_sig <= IDLE_c;
							busy_s		<= '0'; -- accept new data from fifo
					    end if;

 					when others => 
 						tx_fsm_sig 	<= IDLE_c;
					
				end case;
			end if;
		end if;
	end process;

end SerialLink_TX;
