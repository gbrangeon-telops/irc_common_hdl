-------------------------------------------------------------------------------
--
-- Title       : fp32tofix_16s
-- Author      : PDU / KBE
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Wripper for fixtofp32.vhd to fix the geniric whith the desired
--                Valuse before synthesis.
--
-------------------------------------------------------------------------------
--
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity fixtofp32_16s_wrp is
   port(
      RX_MOSI    : in  T_LL_MOSI32;
      TX_MISO    : in  T_LL_MISO;
      RX_MISO    : out T_LL_MISO;
      TX_MOSI    : out T_LL_MOSI32;
      --
      RX_EXP     : in signed(7 downto 0);

      ARESET     : in  std_logic;
      CLK_IN        : in  std_logic
      );
end fixtofp32_16s_wrp;

architecture RTL of fixtofp32_16s_wrp is

component fixtofp32_16s
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

signal clk0_out_sig : std_logic;

begin


U0_sys_dcm : entity work.sys_dcm
   port map(
          CLKIN_IN         => CLK_IN,
          RST_IN           => '0',
          CLKIN_IBUFG_OUT  => open,
          CLK0_OUT         => clk0_out_sig,
          LOCKED_OUT       => open
          );


Fix16s_to_FP32 : fixtofp32_16s
   port map(
      RX_MOSI     => RX_MOSI,
      TX_MISO     => TX_MISO,
      RX_MISO     => RX_MISO,
      TX_MOSI     => TX_MOSI,

      RX_EXP    => RX_EXP,

      ARESET      => ARESET,
      CLK         => clk0_out_sig
      );

end RTL;


