-------------------------------------------------------------------------------
--
-- Title       : fp32tofix_16u
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

entity fp32tofix_16u_wrp is
   port(
      AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
      EXP         : in  signed(7 downto 0);  -- Same length as float_exponent_width

      RX_MOSI     : in  t_ll_mosi32;
      RX_MISO     : out t_ll_miso;

      TX_MOSI     : out t_ll_mosi32;
      TX_MISO     : in  t_ll_miso;

      OVERFLOW    : out std_logic;
      UNDERFLOW   : out std_logic;

      ARESET     : in  std_logic;
      CLK_IN        : in  std_logic
      );
end fp32tofix_16u_wrp;

architecture RTL of fp32tofix_16u_wrp is

component fp32tofix_16u
   port(
      AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
      EXP         : in  signed(7 downto 0);  -- Same length as float_exponent_width

      RX_MOSI     : in  t_ll_mosi32;
      RX_MISO     : out t_ll_miso;

      TX_MOSI     : out t_ll_mosi32;
      TX_MISO     : in  t_ll_miso;

      OVERFLOW    : out std_logic;
      UNDERFLOW   : out std_logic;

      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC
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


u0fp32tofix_16u : fp32tofix_16u
   port map(
      AVOID_ZERO  => AVOID_ZERO,
      EXP         => EXP,

      RX_MOSI     => RX_MOSI,
      RX_MISO     => RX_MISO,

      TX_MOSI     => TX_MOSI,
      TX_MISO     => TX_MISO,

      OVERFLOW    => OVERFLOW,
      UNDERFLOW   => UNDERFLOW,

      ARESET      => ARESET,
      CLK         => clk0_out_sig
      );

end RTL;


