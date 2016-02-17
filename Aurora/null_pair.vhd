library IEEE;
use IEEE.std_logic_1164.all;


entity null_pair is
   port
      (
      GREFCLK_IN              : IN std_logic;   
      RX1N_IN                 : IN std_logic_vector(1 DOWNTO 0);   
      RX1P_IN                 : IN std_logic_vector(1 DOWNTO 0);   
      TX1N_OUT                : OUT std_logic_vector(1 DOWNTO 0);   
      TX1P_OUT                : OUT std_logic_vector(1 DOWNTO 0)   
      );
   
   
end null_pair;

architecture blackbox of null_pair is
   
   
   attribute box_type: string;
   attribute box_type of blackbox: architecture is "user_black_box";
   
begin
   
   
end blackbox;

