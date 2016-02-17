library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ll_tmi_bridge_tb_tb is
	-- Generic declarations of the tested unit
		generic(
		Latency : NATURAL := 4;
		XLEN : NATURAL := 8;
		ALEN : NATURAL := 10;
		DLEN : NATURAL := 24 );
end ll_tmi_bridge_tb_tb;

architecture TB_ARCHITECTURE of ll_tmi_bridge_tb_tb is
	-- Component declaration of the tested unit
	component ll_tmi_bridge_tb
		generic(
		Latency : NATURAL := 4;
		XLEN : NATURAL := 9;
		ALEN : NATURAL := 21;
		DLEN : NATURAL := 24 );
	port(
		ARESET : in STD_LOGIC;
		CLK_CTRL : in STD_LOGIC;
		CLK_DATA : in STD_LOGIC;
		FALL : in STD_LOGIC;
		RANDOM : in STD_LOGIC;
		INPUT_FILENAME : in STRING(1 to 255);
		OUTPUT_FILENAME : in STRING(1 to 255);
		ERROR : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal ARESET : STD_LOGIC;
	signal CLK_CTRL : STD_LOGIC;
	signal CLK_DATA : STD_LOGIC;
	signal FALL : STD_LOGIC;
	signal RANDOM : STD_LOGIC;
	signal INPUT_FILENAME : STRING(1 to 255);
	signal OUTPUT_FILENAME : STRING(1 to 255);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal ERROR : STD_LOGIC;

	-- Add your code here ...
   signal END_SIM : Boolean := False;

begin

	-- Unit Under Test port map
	UUT : ll_tmi_bridge_tb
		generic map (
			Latency => Latency,
			XLEN => XLEN,
			ALEN => ALEN,
			DLEN => DLEN
		)

		port map (
			ARESET => ARESET,
			CLK_CTRL => CLK_CTRL,
			CLK_DATA => CLK_DATA,
			FALL => FALL,
			RANDOM => RANDOM,
			INPUT_FILENAME => INPUT_FILENAME,
			OUTPUT_FILENAME => OUTPUT_FILENAME,
			ERROR => ERROR
		);

	-- Add your stimulus here ...
   INPUT_FILENAME(1 to 82) <= "D:\Telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge\tb\src\input_data_1.raw";
   OUTPUT_FILENAME(1 to 83) <= "D:\Telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge\tb\src\output_data_1.raw";
   RANDOM <= '0';
   FALL <= '0';

   CLOCK_DATA : process
   begin
      --this process was generated based on formula: 0 0 ns, 1 12500 ps -r 25 ns
      --wait for <time to next event>; -- <current time>
      if END_SIM = FALSE then
         CLK_DATA <= '0';
         wait for 3.125 ns;
      else
         wait;
      end if;
      if END_SIM = FALSE then
         CLK_DATA <= '1';
         wait for 3.125 ns; 
      else
         wait;
      end if;
   end process;
   
   CLOCK_CTRL : process
   begin
      --this process was generated based on formula: 0 0 ns, 1 12500 ps -r 25 ns
      --wait for <time to next event>; -- <current time>
      if END_SIM = FALSE then
         CLK_CTRL <= '0';
         wait for 5 ns;
      else
         wait;
      end if;
      if END_SIM = FALSE then
         CLK_CTRL <= '1';
         wait for 5 ns; 
      else
         wait;
      end if;
   end process;

   RST: process
   begin
      ARESET <= '1';
      wait for 25 ns;
      ARESET <= '0';      
      wait;
   end process;    

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ll_tmi_bridge_tb of ll_tmi_bridge_tb_tb is
	for TB_ARCHITECTURE
		for UUT : ll_tmi_bridge_tb
			use entity work.ll_tmi_bridge_tb(ll_tmi_bridge_tb);
		end for;
	end for;
end TESTBENCH_FOR_ll_tmi_bridge_tb;

