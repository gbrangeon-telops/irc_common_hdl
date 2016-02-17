-- User name or file-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity WireDelay_tb is

end entity WireDelay_tb;

-------------------------------------------------------------------------------

architecture Beh of WireDelay_tb is

  constant Delay_g : time := 1 ns; -- wire delay

  signal A : Std_Logic := '0';
  signal B : Std_Logic := 'Z';

begin  -- architecture Beh

  WireDelay_i: entity work.WireDelay
    generic map (
      Delay_g => Delay_g)
    port map (
      A => A,                           -- [inout]
      B => B);                          -- [inout]

--
     A <= '1' after 10 ns,              -- 0 from 0 to 10, 1 from 10 to 20
          'Z' after 20 ns,              -- @20 A => 'Z'
          '0' after 30 ns;              -- @30 A => '0'

     B <= 'Z' after 10 ns,              -- Z from 0 to 10, Z from 10 to 23
          '1' after 24 ns,              -- @24 A => '1'
          'Z' after 26 ns;              -- @26 A => 'Z'  

end architecture Beh;

-------------------------------------------------------------------------------
--
--configuration WireDelay_tb_Beh_cfg of WireDelay_tb is
--  for Beh
--  end for;
--end WireDelay_tb_Beh_cfg;
--
-------------------------------------------------------------------------------
