
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.ALL;

entity Aurora_Rst is
   port (
      clk : in std_logic;		-- System Clock
      Reset : in std_logic;	-- External Reset
      Aurora_Reset : out std_logic);
   
end Aurora_Rst;

architecture RTL of Aurora_Rst is
   
   signal Rst_Count:integer range 0 to 7;
   
begin
   
   Aurora_Rst : process(Reset,Clk)
   begin	       
      if Reset = '1' then
         Rst_Count <= 0;
         Aurora_Reset <= '1';
      elsif (rising_edge(clk)) then
         if Rst_Count < 6 then
            Rst_Count <= Rst_Count + 1;
            Aurora_Reset <= '1';
         else
            Aurora_Reset <= '0';
         end if;
      end if;						  		
   end process;
   
end RTL;
