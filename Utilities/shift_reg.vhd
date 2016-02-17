library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SHIFT_REG is  
   generic(
      DLEN : natural := 32;
      SR_LENGTH : natural := 16);
   port(
      CLK : in std_logic;
      INPUT : in std_logic_vector(DLEN-1 downto 0);
      OUTPUT : out std_logic_vector(DLEN-1 downto 0)
      );
end SHIFT_REG;


architecture RTL of SHIFT_REG is          
   type shift_reg_t is array(SR_LENGTH-1 downto 0) of std_logic_vector(DLEN-1 downto 0);
   signal shift_reg : shift_reg_t;
begin
   
   process(CLK)     
   begin
      if rising_edge(CLK) then 
         shift_reg <= shift_reg(SR_LENGTH-2 downto 0) & INPUT;
      end if;
   end process;
   OUTPUT <= shift_reg(SR_LENGTH-1);
   
end RTL;
