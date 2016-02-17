---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  Author: Olivier Bourgois
--
--  File: ll_counter32.vhd
--  Use:  For counting valid data bytes on LocalLink Busses (Debug)
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Common_HDL; 
use Common_HDL.Telops.all;

entity ll_counter32 is
   generic(
      nbits : integer := 32);
   port(
      CLK      : in  std_logic;
      ARESET   : in  std_logic;   
      MOSI     : in  t_ll_mosi32;
      MISO     : in  t_ll_miso;
      PIXELS   : out std_logic_vector(nbits-2 downto 0);
      BYTES    : out std_logic_vector(nbits-1 downto 0));
end ll_counter32;

architecture rtl of ll_counter32 is
   
   signal bytes_i : unsigned(nbits-1 downto 0);
   signal pixels_i : std_logic_vector(nbits-2 downto 0);
   
	attribute keep : string;                               
	attribute keep of pixels_i : signal is "true";   
	 
begin
   
   BYTES  <= std_logic_vector(bytes_i);
   PIXELS <= pixels_i;
   pixels_i <= std_logic_vector(bytes_i(nbits-1 downto 1));
   
   count_bytes : process(CLK, ARESET)
   begin       
      if ARESET = '1' then
         bytes_i <= (others => '0');  
      elsif (CLK'event and CLK = '1') then
         if MISO.BUSY = '0' and MOSI.DVAL = '1' then
            bytes_i <= bytes_i + unsigned(MOSI.DREM) + 1;
         end if;
      end if;
   end process count_bytes;
   
end rtl;
