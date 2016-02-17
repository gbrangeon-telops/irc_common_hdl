library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity fixtofp32_8s_tb is
end fixtofp32_8s_tb;

architecture TB_ARCHITECTURE of fixtofp32_8s_tb is
	-- Component declaration of the tested unit
	component fixtofp32_8s
	port(
		RX_MOSI : in t_ll_mosi8;
		RX_MISO : out t_ll_miso;
		TX_MOSI : out t_ll_mosi32;
		TX_MISO : in t_ll_miso;
		ARESET : in STD_LOGIC;
		CLK : in STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal RX_MOSI : t_ll_mosi8;
	signal TX_MISO : t_ll_miso;
	signal ARESET : STD_LOGIC;
	signal CLK : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal RX_MISO : t_ll_miso;
	signal TX_MOSI : t_ll_mosi32;

	-- Add your code here ...												 
	constant CLK_PERIOD : time := 10 ns;
	constant RESET_LENGTH : time := 160 ns;	

begin
	
	CLK_GEN: process(CLK)
	begin
		CLK <= not CLK after CLK_PERIOD/2; 
	end process;
	 
	RES: process
	begin
		ARESET<='1';  -- reset of the counter
		wait for RESET_LENGTH;
		ARESET<='0';
		wait;
	end process;

	-- Unit Under Test port map
	UUT : fixtofp32_8s
		port map (
			RX_MOSI => RX_MOSI,
			RX_MISO => RX_MISO,
			TX_MOSI => TX_MOSI,
			TX_MISO => TX_MISO,
			ARESET => ARESET,
			CLK => CLK
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_fixtofp32_8s of fixtofp32_8s_tb is
	for TB_ARCHITECTURE
		for UUT : fixtofp32_8s
			use entity work.fixtofp32_8s(rtl);
		end for;
	end for;
end TESTBENCH_FOR_fixtofp32_8s;

