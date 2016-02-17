library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.std_logic_1164.all;

-- Add your library and packages declaration here ...

entity ll_tx_arbiter_tb_tb is
end ll_tx_arbiter_tb_tb;

architecture TB_ARCHITECTURE of ll_tx_arbiter_tb_tb is
	-- Component declaration of the tested unit
	component ll_tx_arbiter_tb
		port(
			CLK : in STD_LOGIC;
			RANDOM : in STD_LOGIC;
			RST : in STD_LOGIC);
			--Unused_RX_MOSI : in t_ll_mosi8 );
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC := '0';
	signal RANDOM : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal Unused_RX_MOSI : t_ll_mosi8;
	-- Observed signals - signals mapped to the output ports of tested entity
	
	constant CLK_PERIOD : time := 10 ns;
	constant RESET_LENGTH : time := 160 ns;
	
begin		
	
	RANDOM <= '0';
	
	--Unused_RX_MOSI.SOF	<= '0';
--	Unused_RX_MOSI.EOF	<= '0';
--	Unused_RX_MOSI.DATA	<= (others =>'0');
--	Unused_RX_MOSI.DVAL	<= '0';
--	Unused_RX_MOSI.SUPPORT_BUSY	<= '0'; 
	
	-- Unit Under Test port map
	UUT : ll_tx_arbiter_tb
	port map (
		CLK => CLK,
		RANDOM => RANDOM,
		RST => RST--,
		--Unused_RX_MOSI => Unused_RX_MOSI
		);
	
	
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
	
	configuration TESTBENCH_FOR_ll_tx_arbiter_tb of ll_tx_arbiter_tb_tb is
	for TB_ARCHITECTURE
	for UUT : ll_tx_arbiter_tb
	use entity work.ll_tx_arbiter_tb(ll_tx_arbiter_tb);
	end for;
	end for;
end TESTBENCH_FOR_ll_tx_arbiter_tb;

