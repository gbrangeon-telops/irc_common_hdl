-------------------------------------------------------------------------------
--
-- Title       : ll_fp32_max
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : This module analyzes a SOF-EOF vector and outputs its maximum
--               absolute value. The input data is assume to be 32-bit floating
--               point.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity ll_fp32_max is
   port(
      RX_MOSI  : in  t_ll_mosi32;
      -- No MISO because never busy;
      
      MAX      : out std_logic_vector(31 downto 0);
      NEW_MAX  : out std_logic;
      
      ARESET   : in std_logic;
      CLK      : in std_logic
      );
end ll_fp32_max;     

-- Declare these librairies only for the architecture
library IEEE_proposed;
use ieee_proposed.float_pkg.all;

architecture RTL of ll_fp32_max is  
   
   signal float_in_abs  : float32;
   signal eof_reg       : std_logic;
   signal dval_reg      : std_logic;
   signal max_reg       : float32;
   signal reset         : std_logic; 
   
   -- pragma translate_off
   signal max_reg_debug : real;
   signal float_in_debug : real;
   -- pragma translate_on   
   
begin
   
   sync_RST : entity sync_reset
   port map(ARESET => ARESET, SRESET => reset, CLK => CLK); 
   
   -- pragma translate_off
   float_in_debug <= to_real(float_in_abs);
   max_reg_debug <= to_real(max_reg);
   -- pragma translate_on      
   
   process(CLK)
     
   begin
      
      if rising_edge(CLK) then             
         -- First, register input
         float_in_abs <= abs(float32(RX_MOSI.DATA));
         eof_reg <= RX_MOSI.EOF;
         dval_reg <= RX_MOSI.DVAL;         
         
         -- Default
         NEW_MAX <= '0';
         
         if dval_reg = '1' then
            
            if eof_reg = '1' then
               NEW_MAX <= '1';
               MAX <= std_logic_vector(max_reg);
               max_reg <= to_float(0, max_reg);
            end if;         
            
            if float_in_abs > max_reg then
               max_reg <= float_in_abs; 
            end if;         
            
         end if;
         
         
         if reset = '1' then
            max_reg <= to_float(0, max_reg);
         end if;
         
      end if;
   end process;
   
end RTL;
