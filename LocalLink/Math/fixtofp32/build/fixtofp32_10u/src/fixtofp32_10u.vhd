-------------------------------------------------------------------------------
--
-- Title       : fixtofp32_10u
-- Author      : PDU / KBE
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Wripper for fixtofp32.vhd to fix the geniric whith the desired
--                Valuse before synthesis.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity fixtofp32_10u is
   port(
      RX_MOSI    : in  T_LL_MOSI32;
      TX_MISO    : in  T_LL_MISO;
      RX_MISO    : out T_LL_MISO;
      TX_MOSI    : out T_LL_MOSI32;
      --
      RX_EXP     : in signed(7 downto 0);
      ARESET     : in  std_logic;
      CLK        : in  std_logic
      );
end fixtofp32_10u;

architecture RTL of fixtofp32_10u is

component fixtofp32
   generic(
      signed_fi   : boolean := TRUE;
      DLEN        : natural := 10
      );
   port(
      RX_MOSI    : in  T_LL_MOSI32;
      TX_MISO    : in  T_LL_MISO;
      RX_MISO    : out T_LL_MISO;
      TX_MOSI    : out T_LL_MOSI32;

      RX_EXP     : in signed(7 downto 0);
      
      ARESET               : in  std_logic;
      CLK                  : in  std_logic
      );
end component;

begin

Fix12u_to_FP32 : fixtofp32
   generic map(
      signed_fi   => FALSE,
      DLEN        => 10
      )
   port map(
      RX_MOSI     => RX_MOSI,
      TX_MISO     => TX_MISO,
      RX_MISO     => RX_MISO,
      TX_MOSI     => TX_MOSI,

      RX_EXP    => RX_EXP,

      ARESET      => ARESET,
      CLK         => CLK
      );

end RTL;
