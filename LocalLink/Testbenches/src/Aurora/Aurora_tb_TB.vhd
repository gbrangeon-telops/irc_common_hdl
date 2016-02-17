-------------------------------------------------------------------------------
--
-- Title       : Test Bench for Aurora_tb
-- Design      : LL_Testbenches
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\.\Aurora_tb_TB.vhd
-- Generated   : 2007-11-30, 17:03
-- From        : $DSN\compile\Aurora_TB.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for Aurora_tb_tb
--
-------------------------------------------------------------------------------

library ieee,common_hdl;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use common_hdl.telops.all;

-- Add your library and packages declaration here ...

entity Aurora_tb_tb is
end Aurora_tb_tb;

architecture TB_ARCHITECTURE of Aurora_tb_tb is
   -- Component declaration of the tested unit
   component Aurora_tb
      port(
         CLK : in std_logic;
         CLK200 : in std_logic;
         RANDOM_IN : in std_logic;
         RANDOM_OUT : in std_logic;
         RST : in std_logic;
         FILE_IN1 : in STRING(1 to 255);
         FILE_IN2 : in STRING(1 to 255);
         FILE_OUT1 : in STRING(1 to 255);
         FILE_OUT2 : in STRING(1 to 255) );
   end component;
   
   -- Stimulus signals - signals mapped to the input and inout ports of tested entity
   signal CLK : std_logic := '0';
   signal CLK200 : std_logic := '0';
   signal RANDOM_IN : std_logic;
   signal RANDOM_OUT : std_logic;
   signal RST : std_logic;
   signal FILE_IN1 : STRING(1 to 255);
   signal FILE_IN2 : STRING(1 to 255);
   signal FILE_OUT1 : STRING(1 to 255);
   signal FILE_OUT2 : STRING(1 to 255);
   -- Observed signals - signals mapped to the output ports of tested entity
   
   constant CLK_PERIOD : time := 10 ns;
   constant CLK200_PERIOD : time := 5 ns;
   
begin               
   
   RANDOM_IN <= '1';
   RANDOM_OUT <= '1'; 
   
   FILE_IN1(1 to 65) <= "D:\Telops\Common_HDL\LocalLink\Testbenches\src\Aurora\Source1.dat";   
   FILE_IN2(1 to 65) <= "D:\Telops\Common_HDL\LocalLink\Testbenches\src\Aurora\Source2.dat";   
   FILE_OUT1(1 to 62) <= "D:\Telops\Common_HDL\LocalLink\Testbenches\src\Aurora\Out1.dat";    
   FILE_OUT2(1 to 62) <= "D:\Telops\Common_HDL\LocalLink\Testbenches\src\Aurora\Out2.dat";   
   
   CLK_GEN: process(CLK)
   begin
      CLK <= not CLK after CLK_PERIOD/2;       
   end process;   
   
   CLK200_GEN: process(CLK200)
   begin      
      CLK200 <= not CLK200 after CLK200_PERIOD/2; 
   end process;      
   
   RST_GEN: process
   begin
      RST <= '1'; 
      wait for 15 ns;
      RST <= '0';
      wait;
   end process;     
   
   -- Unit Under Test port map
   UUT : Aurora_tb
   port map (
      CLK => CLK, 
      CLK200 => CLK200,
      RANDOM_IN => RANDOM_IN,
      RANDOM_OUT => RANDOM_OUT,
      RST => RST,
      FILE_IN1 => FILE_IN1,
      FILE_IN2 => FILE_IN2,
      FILE_OUT1 => FILE_OUT1,
      FILE_OUT2 => FILE_OUT2
      );
   
   -- Add your stimulus here ...
   
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_Aurora_tb of Aurora_tb_tb is
   for TB_ARCHITECTURE
      for UUT : Aurora_tb
         use entity work.Aurora_tb(sch);
      end for;
   end for;
end TESTBENCH_FOR_Aurora_tb;

