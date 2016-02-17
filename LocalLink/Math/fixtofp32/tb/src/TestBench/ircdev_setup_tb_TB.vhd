library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ircdev_setup_tb_tb is
end ircdev_setup_tb_tb;

architecture TB_ARCHITECTURE of ircdev_setup_tb_tb is
	-- Component declaration of the tested unit
	component ircdev_setup_tb
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC:='0';
	signal RST : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...   
   constant CLK_PERIOD : time := 10 ns;
	constant RESET_LENGTH : time := 160 ns;	

begin

	-- Unit Under Test port map
	UUT : ircdev_setup_tb
		port map (
			CLK => CLK,
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

configuration TESTBENCH_FOR_ircdev_setup_tb of ircdev_setup_tb_tb is
	for TB_ARCHITECTURE
		for UUT : ircdev_setup_tb
			use entity work.ircdev_setup_tb(ircdev_setup_tb);
		end for;
	end for;
end TESTBENCH_FOR_ircdev_setup_tb;

