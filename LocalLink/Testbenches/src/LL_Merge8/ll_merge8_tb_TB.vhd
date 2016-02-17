library common_hdl;
use common_hdl.telops.all;
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-- Add your library and packages declaration here ...

entity ll_merge8_tb_tb is
end ll_merge8_tb_tb;

architecture TB_ARCHITECTURE of ll_merge8_tb_tb is
   -- Component declaration of the tested unit
   component ll_merge8_tb
      port(
         CLK : in std_logic;
         RANDOM_IN : in std_logic;
         RANDOM_OUT : in std_logic;
         RST : in std_logic;
         FILE_IN1 : in STRING(1 to 255);
         FILE_IN2 : in STRING(1 to 255);
         FILE_OUT1 : in STRING(1 to 255) );
   end component;
   
   -- Stimulus signals - signals mapped to the input and inout ports of tested entity
   signal CLK : std_logic := '0';
   signal RANDOM_IN : std_logic;
   signal RANDOM_OUT : std_logic;
   signal RST : std_logic;
   signal FILE_IN1 : STRING(1 to 255);
   signal FILE_IN2 : STRING(1 to 255);
   signal FILE_OUT1 : STRING(1 to 255);
   -- Observed signals - signals mapped to the output ports of tested entity
   
   constant CLK_PERIOD : time := 10 ns;
   
begin
   
   -- Unit Under Test port map
   UUT : ll_merge8_tb
   port map (
      CLK => CLK,
      RANDOM_IN => RANDOM_IN,
      RANDOM_OUT => RANDOM_OUT,
      RST => RST,
      FILE_IN1 => FILE_IN1,
      FILE_IN2 => FILE_IN2,
      FILE_OUT1 => FILE_OUT1
      );
   
   RANDOM_IN <= '0';
   RANDOM_OUT <= '0'; 
   
   FILE_IN1(1 to 68) <= "D:\Telops\Common_HDL\LocalLink\Testbenches\src\LL_Merge8\Source1.dat";   
   FILE_IN2(1 to 68) <= "D:\Telops\Common_HDL\LocalLink\Testbenches\src\LL_Merge8\Source2.dat";   
   FILE_OUT1(1 to 65) <= "D:\Telops\Common_HDL\LocalLink\Testbenches\src\LL_Merge8\Out1.dat";     
   
   CLK_GEN: process(CLK)
   begin
      CLK<= not CLK after CLK_PERIOD/2; 
   end process;   
   
   RST_GEN: process
   begin
      RST <= '1'; 
      wait for 15 ns;
      RST <= '0';
      wait;
   end process;   
   
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ll_merge8_tb of ll_merge8_tb_tb is
   for TB_ARCHITECTURE
      for UUT : ll_merge8_tb
         use entity work.ll_merge8_tb(sch); 
         for sch
            for FILE1 : ll_file_input_8 
               use entity common_hdl.ll_file_input_8 (ascii);
            end for;
            for FILE2 : ll_file_input_8 
               use entity common_hdl.ll_file_input_8 (ascii);
            end for;                 
            for FILEOUT1 : ll_file_output_8 
               use entity common_hdl.ll_file_output_8 (ascii);
            end for;            
         end for;            
      end for;
   end for;
end TESTBENCH_FOR_ll_merge8_tb;

