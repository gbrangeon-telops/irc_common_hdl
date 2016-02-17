library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity tmi_ll_lut_tb_tb is
end tmi_ll_lut_tb_tb;

architecture TB_ARCHITECTURE of tmi_ll_lut_tb_tb is
	-- Component declaration of the tested unit
	component tmi_ll_lut_tb
	port(
		ARESET : in STD_LOGIC;
		CLK_CTRL : in STD_LOGIC;
		CLK_DATA : in STD_LOGIC;
		STALL : in STD_LOGIC;
      RANDOM_BUSY : in STD_logic;
		FILENAME_IN : in STRING(1 to 255);
		FILENAME_OUT : in STRING(1 to 255);
		ERROR : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal ARESET : STD_LOGIC;
	signal CLK_CTRL : STD_LOGIC;
	signal CLK_DATA : STD_LOGIC;
	signal STALL : STD_LOGIC;
	signal RANDOM_BUSY : STD_LOGIC;
	signal FILENAME_IN : STRING(1 to 255);
	signal FILENAME_OUT : STRING(1 to 255);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal ERROR : STD_LOGIC;

	-- Add your code here ...
   signal END_SIM : Boolean := False;

begin

	-- Unit Under Test port map
	UUT : tmi_ll_lut_tb
		port map (
			ARESET => ARESET,
			CLK_CTRL => CLK_CTRL,
			CLK_DATA => CLK_DATA,
			STALL => STALL,
         RANDOM_BUSY => RANDOM_BUSY,
			FILENAME_IN => FILENAME_IN,
			FILENAME_OUT => FILENAME_OUT,
			ERROR => ERROR
		);

	-- Add your stimulus here ...
   FILENAME_IN(1 to 77) <= "D:\Telops\Common_HDL\Telops_Memory_Interface\TMI_LL_LUT\tb\src\input_data.raw";
   FILENAME_OUT(1 to 78) <= "D:\Telops\Common_HDL\Telops_Memory_Interface\TMI_LL_LUT\tb\src\output_data.raw";

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

   Stimulus: process
   begin
      if END_SIM = FALSE then
         ARESET <= '1';
         STALL <= '1';
         RANDOM_BUSY <= '0';
         wait for 125 ns;
         ARESET <= '0';
         wait for 1500ns;
         STALL <= '0';
         wait for 1000us;
         END_SIM <= TRUE;
         wait for 10ns;
      else 
         wait;
      end if;
   end process;    

   
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_tmi_ll_lut_tb of tmi_ll_lut_tb_tb is
	for TB_ARCHITECTURE
		for UUT : tmi_ll_lut_tb
			use entity work.tmi_ll_lut_tb(tmi_ll_lut_tb);
		end for;
	end for;
end TESTBENCH_FOR_tmi_ll_lut_tb;

