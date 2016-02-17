-------------------------------------------------------------------------------
--
-- Title       : Test Bench for aurora_tb
-- Design      : CAMEL_TB
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\aurora_tb_TB.vhd
-- Generated   : 2007-08-28, 13:40
-- From        : $DSN\compile\Aurora_TB.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for aurora_tb_tb
--
-------------------------------------------------------------------------------

library ieee,common_hdl,fir_00142,fir_00180;
use ieee.std_logic_1164.all;
use common_hdl.telops.all;

	-- Add your library and packages declaration here ...

entity aurora_tb_tb is
end aurora_tb_tb;

architecture TB_ARCHITECTURE of aurora_tb_tb is
	-- Component declaration of the tested unit
	component aurora_tb
	port(
		CLK100 : in std_logic;
		CLK200 : in std_logic;
		RANDOM_IN : in std_logic;
		RANDOM_OUT : in std_logic;
		RESET_N : in std_logic;
		FILE_IN : in STRING(1 to 255);
		FILE_OUT : in STRING(1 to 255) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK100 : std_logic := '0';
	signal CLK200 : std_logic := '0';
	signal RANDOM_IN : std_logic;
	signal RANDOM_OUT : std_logic;
	signal RESET_N : std_logic;
	signal FILE_IN : STRING(1 to 255);
	signal FILE_OUT : STRING(1 to 255);
	-- Observed signals - signals mapped to the output ports of tested entity

   constant CLK100_PERIOD : time := 10 ns; 
   constant CLK200_PERIOD : time := 5 ns;

begin

	-- Unit Under Test port map
	UUT : aurora_tb
		port map (
			CLK100 => CLK100,
			CLK200 => CLK200,
			RANDOM_IN => RANDOM_IN,
			RANDOM_OUT => RANDOM_OUT,
			RESET_N => RESET_N,
			FILE_IN => FILE_IN,
			FILE_OUT => FILE_OUT
		);

   RANDOM_IN <= '1';
   RANDOM_OUT <= '1'; 
   
   FILE_IN(1 to 83) <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\src\Aurora_TB\random_data10.dat";   
   FILE_OUT(1 to 85) <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\src\Aurora_TB\random_data_out.dat";   
   
   CLK100_GEN: process(CLK100)
   begin
      CLK100<= not CLK100 after CLK100_PERIOD/2; 
   end process;  
   
   CLK200_GEN: process(CLK200)
   begin
      CLK200<= not CLK200 after CLK200_PERIOD/2; 
   end process;   
   
   RST_GEN: process
   begin
      RESET_N <= '0'; 
      wait for 35 ns;
      RESET_N <= '1';
      wait;
   end process;    

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_aurora_tb of aurora_tb_tb is
	for TB_ARCHITECTURE
		for UUT : aurora_tb
			use entity work.aurora_tb(sch);
		end for;
	end for;
end TESTBENCH_FOR_aurora_tb;

