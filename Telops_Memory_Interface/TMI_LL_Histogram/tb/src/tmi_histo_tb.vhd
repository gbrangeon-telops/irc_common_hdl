LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;


-- entity declaration for your testbench.Dont declare any ports here
ENTITY TMI_HISTO_TB IS
   port(
      TMI_MOSI    : out  t_tmi_mosi_a10_d21; 
      TMI_MISO    : in t_tmi_miso_d21; 
      HIST_RDY    : in std_logic;
      CLEAR_MEM   : out std_logic;
      CLK         : in std_logic
      );
END TMI_HISTO_TB;

ARCHITECTURE behavior OF TMI_HISTO_TB IS

   --declare outputs and initialize them
   signal add : unsigned(9 downto 0) := "0000000000";
   signal count : unsigned(10 downto 0) := "00000000000";
   signal dval : std_logic;
   signal clear : std_logic;

BEGIN
   TMI_MOSI.ADD <= std_logic_vector(add);
   add <= count(9 downto 0);
   TMI_MOSI.DVAL <= dval;
-- Stimulus process
   process(CLK)
   begin
      if(rising_edge(CLK)) then
         TMI_MOSI.RNW <= '1';
         if (HIST_RDY = '1' and count < 1023 and clear = '0') then
            dval <= '1';
         else 
            dval <= '0';
         end if;
         
         if(clear = '1') then 
            count <= (others => '0');   
         end if;
         
         if(TMI_MISO.BUSY = '0' and HIST_RDY = '1' and dval = '1' and count <1023) then
            count <= count + 1;
         end if;
  
      end if;
   end process;
   CLEAR_MEM <= clear;
   -- Stimulus process
   stim_proc: process
   begin
      clear <= '0';   
      wait until count = 1023;
      wait for 50us;
      clear <= '1';
      wait for 10ns;
      clear <= '0';
   end process;
 
END;