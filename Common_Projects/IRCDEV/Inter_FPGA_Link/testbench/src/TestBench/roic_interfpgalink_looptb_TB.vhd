library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity roic_interfpgalink_looptb_tb is
end roic_interfpgalink_looptb_tb;

architecture TB_ARCHITECTURE of roic_interfpgalink_looptb_tb is
	-- Component declaration of the tested unit
	component roic_interfpgalink_looptb
	port(
		CLK : in STD_LOGIC;
		CLK_20MHz : in STD_LOGIC;
		RANDOM : in STD_LOGIC;
		RST : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC:='0';
	signal CLK_20MHz : STD_LOGIC:='0';
	signal RST : STD_LOGIC;
	signal RANDOM : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	constant CLK_PERIOD : time := 10 ns;
	constant CLK_20MHz_PERIOD : time := 50 ns;
	constant RESET_LENGTH : time := 160 ns;	

	-- Add your code here ...

begin 
	
	RANDOM <= '0';

	-- Unit Under Test port map
	UUT : roic_interfpgalink_looptb
		port map (
			CLK => CLK,
			CLK_20MHz => CLK_20MHz,
			RANDOM => RANDOM,
			RST => RST
		);

	-- Add your stimulus here ...	
	CLK_GEN: process(CLK)
	begin
		CLK <= not CLK after CLK_PERIOD/2; 
	end process;
	
	CLK20mhz_GEN: process(CLK_20MHz)
	begin
		CLK_20MHz <= not CLK_20MHz after CLK_20MHz_PERIOD/2; 
	end process;
	
	 
	RES: process
	begin
		RST<='1';  -- reset of the counter
		wait for RESET_LENGTH;
		RST<='0';
		wait;
	end process;	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_roic_interfpgalink_looptb of roic_interfpgalink_looptb_tb is
	for TB_ARCHITECTURE
		for UUT : roic_interfpgalink_looptb
			use entity work.roic_interfpgalink_looptb(roic_interfpgalink_looptb);
		end for;
	end for;
end TESTBENCH_FOR_roic_interfpgalink_looptb;

