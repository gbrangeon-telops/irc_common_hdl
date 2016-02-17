library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ll_tx_arbiter_tb2_tb is
end ll_tx_arbiter_tb2_tb;

architecture TB2_ARCHITECTURE of ll_tx_arbiter_tb2_tb is
	-- Component declaration of the tested unit
	component ll_tx_arbiter_tb2
	port(
		CLK : in STD_LOGIC;
		RANDOM : in STD_LOGIC;
		RST : in STD_LOGIC;
		CH1_RX_MOSI : in t_ll_mosi8;
		CH2_RX_MOSI : in t_ll_mosi8;
		CH3_RX_MOSI : in t_ll_mosi8;
		CH4_RX_MOSI : in t_ll_mosi8;
		CH5_RX_MOSI : in t_ll_mosi8;
		CH6_RX_MOSI : in t_ll_mosi8);
		--Unused_RX_MOSI : in t_ll_mosi8 );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC:='0';
	signal RANDOM : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal CH1_RX_MOSI : t_ll_mosi8;
	signal CH2_RX_MOSI : t_ll_mosi8;
	signal CH3_RX_MOSI : t_ll_mosi8;
	signal CH4_RX_MOSI : t_ll_mosi8;
	signal CH5_RX_MOSI : t_ll_mosi8;
	signal CH6_RX_MOSI : t_ll_mosi8;
	signal Unused_RX_MOSI : t_ll_mosi8;
	-- Observed signals - signals mapped to the output ports of tested entity 
	constant CLK_PERIOD : time := 10 ns;
	constant RESET_LENGTH : time := 160 ns;	

	-- Add your code here ...

begin
	
	RANDOM <= '1';
	
	Unused_RX_MOSI.SOF	<= '0';
	Unused_RX_MOSI.EOF	<= '0';
	Unused_RX_MOSI.DATA	<= (others =>'0');
	Unused_RX_MOSI.DVAL	<= '0';
	Unused_RX_MOSI.SUPPORT_BUSY	<= '0'; 

	-- Unit Under Test port map
	UUT : ll_tx_arbiter_tb2
		port map (
			CLK => CLK,
			RANDOM => RANDOM,
			RST => RST,
			CH1_RX_MOSI => CH1_RX_MOSI,
			CH2_RX_MOSI => CH2_RX_MOSI,
			CH3_RX_MOSI => CH3_RX_MOSI,
			CH4_RX_MOSI => CH4_RX_MOSI,
			CH5_RX_MOSI => CH5_RX_MOSI,
			CH6_RX_MOSI => CH6_RX_MOSI
			--Unused_RX_MOSI => Unused_RX_MOSI
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
	
	
	CH_RX_MOSI: process
	begin
		-- Channel 1	
		CH1_RX_MOSI.SOF 	<= '0'; 
		CH1_RX_MOSI.EOF 	<= '0'; 
		CH1_RX_MOSI.DATA 	<= (others=>'0'); 
		CH1_RX_MOSI.DVAL 	<= '0';		
		-- Channel 2	
		CH2_RX_MOSI.SOF 	<= '0'; 
		CH2_RX_MOSI.EOF 	<= '0'; 
		CH2_RX_MOSI.DATA 	<= (others=>'0');  
		CH2_RX_MOSI.DVAL 	<= '0';		
		-- Channel 3	
		CH3_RX_MOSI.SOF 	<= '0'; 
		CH3_RX_MOSI.EOF 	<= '0'; 
		CH3_RX_MOSI.DATA 	<= (others=>'0'); 
		CH3_RX_MOSI.DVAL 	<= '0'; 		
		-- Channel 4	
		CH4_RX_MOSI.SOF 	<= '0'; 
		CH4_RX_MOSI.EOF 	<= '0'; 
		CH4_RX_MOSI.DATA 	<= (others=>'0'); 
		CH4_RX_MOSI.DVAL 	<= '0';		
		-- Channel 5	
		CH5_RX_MOSI.SOF 	<= '0'; 
		CH5_RX_MOSI.EOF 	<= '0'; 
		CH5_RX_MOSI.DATA 	<= (others=>'0');  
		CH5_RX_MOSI.DVAL 	<= '0';		
		-- Channel 6	
		CH6_RX_MOSI.SOF 	<= '0'; 
		CH6_RX_MOSI.EOF 	<= '0'; 
		CH6_RX_MOSI.DATA 	<= (others=>'0'); 
		CH6_RX_MOSI.DVAL 	<= '0'; 		
		-- begin stims
		wait for 236 ns;
		-- Channel 2
		CH2_RX_MOSI.SOF 	<= '1'; 
		CH2_RX_MOSI.EOF 	<= '1'; 
		CH2_RX_MOSI.DATA 	<= x"16";  
		CH2_RX_MOSI.DVAL 	<= '1'; 	  		
		-- Channel 3	
		CH3_RX_MOSI.SOF 	<= '1'; 
		CH3_RX_MOSI.EOF 	<= '1'; 
		CH3_RX_MOSI.DATA 	<= x"21";
		CH3_RX_MOSI.DVAL 	<= '1'; 		
		wait  for 10 ns;		
		-- Channel 2
		CH2_RX_MOSI.SOF 	<= '0'; 
		CH2_RX_MOSI.EOF 	<= '0'; 
		CH2_RX_MOSI.DATA 	<= x"00";  
		CH2_RX_MOSI.DVAL 	<= '0'; 
		-- Channel 3				
		CH3_RX_MOSI.SOF 	<= '0'; 
		CH3_RX_MOSI.EOF 	<= '0'; 
		CH3_RX_MOSI.DATA 	<= x"00";
		CH3_RX_MOSI.DVAL 	<= '0'; 
		wait for 106 ns;
		-- Channel 1
		CH1_RX_MOSI.SOF 	<= '1'; 
		CH1_RX_MOSI.EOF 	<= '1'; 
		CH1_RX_MOSI.DATA 	<= x"0B";  
		CH1_RX_MOSI.DVAL 	<= '1';				
		-- Channel 4	
		CH4_RX_MOSI.SOF 	<= '1'; 
		CH4_RX_MOSI.EOF 	<= '1'; 
		CH4_RX_MOSI.DATA 	<= x"2C"; 
		CH4_RX_MOSI.DVAL 	<= '1';
		wait  for 10 ns;
		-- Channel 1
		CH1_RX_MOSI.SOF 	<= '0'; 
		CH1_RX_MOSI.EOF 	<= '0'; 
		CH1_RX_MOSI.DATA 	<= x"00";  
		CH1_RX_MOSI.DVAL 	<= '0'; 
		-- Channel 4	
		CH4_RX_MOSI.SOF 	<= '0'; 
		CH4_RX_MOSI.EOF 	<= '0'; 
		CH4_RX_MOSI.DATA 	<= x"00";  
		CH4_RX_MOSI.DVAL 	<= '0';		
		wait for 106 ns;
		-- Channel 5	
		CH5_RX_MOSI.SOF 	<= '1'; 
		CH5_RX_MOSI.EOF 	<= '1'; 
		CH5_RX_MOSI.DATA 	<= x"37";  
		CH5_RX_MOSI.DVAL 	<= '1';		
		-- Channel 6	
		CH6_RX_MOSI.SOF 	<= '1'; 
		CH6_RX_MOSI.EOF 	<= '1'; 
		CH6_RX_MOSI.DATA 	<= x"42";  
		CH6_RX_MOSI.DVAL 	<= '1'; 	
		wait for 10 ns;
		-- Channel 5	
		CH5_RX_MOSI.SOF 	<= '0'; 
		CH5_RX_MOSI.EOF 	<= '0'; 
		CH5_RX_MOSI.DATA 	<= (others=>'0');  
		CH5_RX_MOSI.DVAL 	<= '0';		
		-- Channel 6	
		CH6_RX_MOSI.SOF 	<= '0'; 
		CH6_RX_MOSI.EOF 	<= '0'; 
		CH6_RX_MOSI.DATA 	<= (others=>'0'); 
		CH6_RX_MOSI.DVAL 	<= '0'; 	
		wait;
	end process;
	
	CH1_RX_MOSI.SUPPORT_BUSY	<= '0';
	CH2_RX_MOSI.SUPPORT_BUSY	<= '0';
	CH3_RX_MOSI.SUPPORT_BUSY	<= '0';
	CH4_RX_MOSI.SUPPORT_BUSY	<= '0';
	CH5_RX_MOSI.SUPPORT_BUSY	<= '0';
	CH6_RX_MOSI.SUPPORT_BUSY	<= '0';

end TB2_ARCHITECTURE;

configuration TESTBENCH_FOR_ll_tx_arbiter_tb2 of ll_tx_arbiter_tb2_tb is
	for TB2_ARCHITECTURE
		for UUT : ll_tx_arbiter_tb2
			use entity work.ll_tx_arbiter_tb2(arch_tb2);
		end for;
	end for;
end TESTBENCH_FOR_ll_tx_arbiter_tb2;

