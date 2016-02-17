library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ll_rx_arb_tb_tb is
end ll_rx_arb_tb_tb;

architecture TB_ARCHITECTURE of ll_rx_arb_tb_tb is
	-- Component declaration of the tested unit
	component ll_rx_arb_tb
	port(
		CLK : in STD_LOGIC;
		RANDOM : in STD_LOGIC;
		RST : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC:='0';
	signal RANDOM : STD_LOGIC;
	signal RST : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	constant CLK_PERIOD : time := 10 ns;
	constant RESET_LENGTH : time := 160 ns;	
	-- Add your code here ...

begin
	
	RANDOM <= '0';
	
	-- Unit Under Test port map
	UUT : ll_rx_arb_tb
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
	 
	RES: process
	begin
		RST<='1';  -- reset of the counter
		wait for RESET_LENGTH;
		RST<='0';
		wait;
	end process;	
	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ll_rx_arb_tb of ll_rx_arb_tb_tb is
	for TB_ARCHITECTURE
		for UUT : ll_rx_arb_tb
			use entity work.ll_rx_arb_tb(ll_rx_arb_tb_arch);
		end for;
	end for;
end TESTBENCH_FOR_ll_rx_arb_tb;

