-------------------------------------------------------------------------------
--
-- Title       : Test Bench for dpb_aurora
-- Design      : CAMEL_TB
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\dpb_aurora_TB.vhd
-- Generated   : 2007-11-06, 11:34
-- From        : $DSN\compile\DPB_Aurora.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for dpb_aurora_tb
--
-------------------------------------------------------------------------------

library ieee,common_hdl,fir_00142,rocketio_passthru;
use ieee.std_logic_1164.all;
use common_hdl.telops.all;

	-- Add your library and packages declaration here ...

entity dpb_aurora_tb is
end dpb_aurora_tb;

architecture TB_ARCHITECTURE of dpb_aurora_tb is
	-- Component declaration of the tested unit
	component dpb_aurora
	port(
		CLK100 : in std_logic;
		CLK200 : in std_logic;
		RESET_N : in std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK100 : std_logic := '0';
	signal CLK200 : std_logic := '0';
	signal RESET_N : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity

   constant CLK100_PERIOD : time := 10 ns; 
   constant CLK200_PERIOD : time := 5 ns;

begin

	-- Unit Under Test port map
	UUT : dpb_aurora
		port map (
			CLK100 => CLK100,
			CLK200 => CLK200,
			RESET_N => RESET_N
		);

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

configuration TESTBENCH_FOR_dpb_aurora of dpb_aurora_tb is
	for TB_ARCHITECTURE
		for UUT : dpb_aurora
			use entity work.dpb_aurora(dpb_aurora);
		end for;
	end for;
end TESTBENCH_FOR_dpb_aurora;

