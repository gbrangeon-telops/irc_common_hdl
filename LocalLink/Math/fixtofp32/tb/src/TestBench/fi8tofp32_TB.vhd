library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity fi8tofp32_tb is
end fi8tofp32_tb;

architecture TB_ARCHITECTURE of fi8tofp32_tb is
	-- Component declaration of the tested unit
	component fi8tofp32
	port(
      CLK : in STD_LOGIC;
      RANDOM : in STD_LOGIC;
		RST : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC:='0'; 
   signal RANDOM : STD_LOGIC:='1';
	signal RST : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...   
   constant CLK_PERIOD : time := 10 ns;
	constant RESET_LENGTH : time := 160 ns;	

begin

	-- Unit Under Test port map
	UUT : fi8tofp32
		port map (
      CLK => CLK,
      RANDOM => RANDOM,
		RST => RST
		);

	-- Add your stimulus here ... 
    CLK_GEN: process(CLK)
	begin
		CLK <= not CLK after CLK_PERIOD/2; 
	end process;
	 
	RST_GEN: process
	begin
		RST<='1';  -- reset of the counter
		wait for RESET_LENGTH;
		RST<='0';
		wait;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_fi8tofp32 of fi8tofp32_tb is
	for TB_ARCHITECTURE
		for UUT : fi8tofp32
			use entity work.fi8tofp32(fi8tofp32);
		end for;
	end for;
end TESTBENCH_FOR_fi8tofp32;

