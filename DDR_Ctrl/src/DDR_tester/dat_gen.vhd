---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: dat_gen.vhd
--  Hierarchy: Sub-module file
--  Use: data test_patern generator for memory test
--	 Project: GATORADE2 - In system memory tester
--	 By: Olivier Bourgois
--  Date: October 27, 2005
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dat_gen is
port(
  CLK      : in std_logic;
  RST_DAT  : in std_logic;
  NXT_DAT  : in std_logic;
  DAT      : out std_logic_vector(7 downto 0));
end entity dat_gen;

architecture rtl of dat_gen is

  signal lfsr8 : std_logic_vector(7 downto 0);
  constant lfsr8_seed   : std_logic_vector(7 downto 0)  := (others => '1');
  
begin
  -- 8 bit max length LFSR implementation, all possible values from 0x01 to 0xff; 0x00 illegal
  -- taps are at bits 7,5,4,3 when counting bits from 0 (see Xilinx XAPP210 for tap positions)
  lfsr8_proc : process(CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (RST_DAT = '1') then
        lfsr8 <= lfsr8_seed;
      elsif (NXT_DAT = '1') then
        lfsr8(7 downto 1) <= lfsr8(6 downto 0);
        lfsr8(0) <= lfsr8(7) xor lfsr8(5) xor lfsr8(4) xor lfsr8(3);
      end if;
    end if;
  end process lfsr8_proc;
  
  -- map output ports
  DAT <= lfsr8;

end rtl;
