----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:02:30 01/11/2010 
-- Design Name: 
-- Module Name:    Error_Check - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
library common_HDL;
use common_HDL.Telops.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Error_Check is
    Port ( ARESET,CLK : in  STD_LOGIC;
    	   TX_OVFLW : in  STD_LOGIC;
           RX_OVFLW : in  STD_LOGIC;
           RX_ERR : in  STD_LOGIC;
           SYNC_DVAL : in  STD_LOGIC;
           RX0_MOSI : in  t_ll_mosi8;
           RX1_MOSI : in  t_ll_mosi8;
           LED : out  STD_LOGIC_VECTOR(7 DOWNTO 0));
end Error_Check;

architecture Behavioral of Error_Check is


signal xfer_err_s	: std_logic;
signal v4_cnt_s : unsigned(3 downto 0);

signal rx0_MosiData_tmp_s,
		rx1_MosiData_tmp_s	: std_logic_vector(7 downto 0);

begin

-- process(CLK)
-- 	begin
-- 		if rising_edge(CLK)then
--			rx0_MosiData_tmp_s <= RX0_MOSI.DATA;
--			rx1_MosiData_tmp_s <= RX1_MOSI.DATA;
-- 		end if;
-- 	end process;

xfer_err_s <= '1' when((RX0_MOSI.DATA /= RX1_MOSI.DATA)and (SYNC_DVAL = '1')) else '0';
-- process(CLK)
-- 	begin
-- 		if rising_edge(CLK)then
-- 			if ARESET = '1' then
-- 				xfer_err_s <= '0';
-- 			elsif SYNC_DVAL = '1' then
-- 				if (RX0_MOSI.DATA /= RX1_MOSI.DATA ) then
-- 					xfer_err_s <= '1';	
-- 				else
-- 					xfer_err_s <= '0';		
-- 				end if;
-- 			end if;
-- 		end if;
-- 	end process;				

process(CLK)
	begin
		if rising_edge(CLK)then
			if ARESET = '1' then
				v4_cnt_s <= (others=>'0');
			elsif xfer_err_s = '1' then
				v4_cnt_s <= v4_cnt_s + 1;
			end if;
		end if;
	end process;					
	LED(7 downto 4) <= std_logic_vector(v4_cnt_s);

process(CLK)
	begin
		if rising_edge(CLK)then
			if ARESET = '1' then
				LED(3 downto 0) <= (others=>'0');
			else				
				-- Latch errors on LED
				if TX_OVFLW = '1' then
					LED(0) <= '1';
				end if;
				if RX_OVFLW = '1' then
					LED(1) <= '1';
				end if;
				if RX_ERR = '1' then
					LED(2) <= '1';
				end if;				
				if xfer_err_s = '1' then
					LED(3) <= '1';
				end if;				
			end if;
		end if;
	end process;
	

	
end Behavioral;

