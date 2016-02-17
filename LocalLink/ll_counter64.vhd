---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  Author: Olivier Bourgois
--
--  File: ll_counter64.vhd
--  Use:  For counting valid data bytes on LocalLink Busses (Debug)
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library Common_HDL; 
use Common_HDL.Telops.all;

entity ll_counter64 is
   generic(
      nbits : integer := 32);
   port(
      CLK       : in  std_logic;
      MOSI      : in  t_ll_mosi64;
      MISO      : in  t_ll_miso;
      BYTES     : out std_logic_vector(nbits-1 downto 0));
end ll_counter64;

architecture rtl of ll_counter64 is

   signal bytes_i : std_logic_vector(nbits-1 downto 0) := (others => '0');
   
begin
   
   BYTES <= bytes_i;
   
   count_bytes : process(CLK)
   variable xfered : std_logic_vector(nbits-1 downto 0) := (others => '0');
   begin
      if (CLK'event and CLK = '1') then
         if MISO.BUSY = '0' and MOSI.DVAL = '1' then
            xfered(MOSI.DREM'range) := MOSI.DREM;
            bytes_i <= bytes_i + xfered + 1;
         end if;
      end if;
   end process count_bytes;

end rtl;
