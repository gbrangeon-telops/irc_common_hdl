-------------------------------------------------------------------------------
--
-- Title       : SerialLink_RX
-- Design      : Inter_FPGA_Link
-- Author      : Telops
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00229\Active-HDL\Inter_FPGA_Link\Inter_FPGA_Link\src\SerialLink_RX.vhd
-- Generated   : Thu Jan  7 13:49:39 2010
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
--{entity {SerialLink_RX} architecture {SerialLink_RX}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;    
library Common_HDL; 
use Common_HDL.Telops.all;



entity SerialLink_RX is
	 port(
		 CLK_20MHz : in STD_LOGIC;
		 SERIAL_RX : in STD_LOGIC;
		 ARESET : in STD_LOGIC;
		 TX_LL_MISO : in T_LL_MISO;
		 TX_LL_MOSI : out T_LL_MOSI8;
		 RX_ERR : out STD_LOGIC
	     );
end SerialLink_RX;

--}} End of automatically maintained section

architecture SerialLink_RX of SerialLink_RX is
	component sync_reset
		port(
			ARESET : in std_logic;
			SRESET : out std_logic;
			CLK : in std_logic);
	end component;
	
	signal 	sreset_s	: std_logic;
	signal 	din_tmp_s	: std_logic;
	signal ByteValid_s	: std_logic;
	signal Fedge_detect_s : std_logic;
	signal v8_din_s : std_logic_vector(7 downto 0);	
	signal v3_count_s : unsigned(2 downto 0);   
   signal SERIAL_RX_r : std_logic;
	
	constant IDLE_c  		: std_logic_vector(1 downto 0):="00";
	constant SHIFTIN_c 		: std_logic_vector(1 downto 0):="01";
	constant BYTECHECK_c	: std_logic_vector(1 downto 0):="10";
	signal rx_fsm_s : std_logic_vector(1 downto 0);
		
begin
	
	-- enter your statements here --
	
	-- Sync Reset
	sync_RESET_TX :  sync_reset
	port map(
		ARESET 	=> ARESET,
		SRESET 	=> sreset_s,
		CLK 	=> CLK_20MHz
		); 							 
	
	-- This stage should be infered into IOB FF. Add IOB=FORCE	constraint to this pin in UCF   
	process(CLK_20MHz)
	begin
		if rising_edge(CLK_20MHz)then			
         SERIAL_RX_r <= SERIAL_RX;
		end if;
	end process;
			
	-- Start bit detect : Falling edge detector
	-- gives a single pulse
	process(CLK_20MHz)
	begin
		if rising_edge(CLK_20MHz)then         
			din_tmp_s <= SERIAL_RX_r;			
		end if;
	end process;
	Fedge_detect_s <= din_tmp_s and not SERIAL_RX_r;			
	
	process(CLK_20MHz)
	begin
		if rising_edge(CLK_20MHz)then
			if sreset_s = '1' then
				rx_fsm_s <= IDLE_c;
				v3_count_s <= (others=> '0'); 
				v8_din_s <= (others=> '0');
				ByteValid_s <= '0';
				RX_ERR <= '0';
			else
				case rx_fsm_s is
					
					when IDLE_c =>
						ByteValid_s <= '0'; -- clear byte valid signal
						RX_ERR <= '0';      -- clear error
						if Fedge_detect_s = '1' then
							rx_fsm_s <= SHIFTIN_c; -- start shifting in
						end if;
					
					when SHIFTIN_c =>						
						v8_din_s <= SERIAL_RX_r & v8_din_s(7 downto 1);	
						-- Count shifted data
						v3_count_s <= v3_count_s + 1;					
						if v3_count_s = "111" then
							v3_count_s <= "000";							
							rx_fsm_s <= BYTECHECK_c;
						end if;
					
					when BYTECHECK_c =>
						-- check stop bit
						if SERIAL_RX_r = '0' then											
							-- Juste flag the error and let SW know.
							RX_ERR <= '1';														
						end if;									
						-- KBE 30/08/2001: We need to validate the byte even if there was an error, otherwise
						-- there will be a missing byte and that will afect the RX arbiter.						
						ByteValid_s <= '1';		-- KBE 30/08/2001				
						rx_fsm_s <= IDLE_c;
					
					when others =>
					rx_fsm_s 	<= IDLE_c;
				end case;
			end if;
		end if;
	end process;
	
	-- LL bus signals management
	-- MISO signals are ignored because we can't stop RX from receiving
	-- instead, we monitor the FIFO overflow signal(WR_ERR).
	
	-- MOSI signals
	TX_LL_MOSI.DATA <= v8_din_s;
	TX_LL_MOSI.DVAL <= ByteValid_s;
	
	-- One byte is sent/available at a time
	-- so SOF & EOF are the same as DVAL
	TX_LL_MOSI.SOF	<= ByteValid_s;
	TX_LL_MOSI.EOF	<= ByteValid_s;
	
	-- Not used: tied to gnd
	TX_LL_MOSI.SUPPORT_BUSY <= '0';
	
end SerialLink_RX;
