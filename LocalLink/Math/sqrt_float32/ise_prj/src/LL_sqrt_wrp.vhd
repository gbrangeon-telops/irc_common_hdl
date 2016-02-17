-------------------------------------------------------------------------------
--
-- Title       : LL_sqrt_wrp
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

entity LL_sqrt_wrp is
   port(
      A_MOSI   : in  t_ll_mosi32;
      A_MISO   : out t_ll_miso;

      RES_MOSI : out t_ll_mosi32;
      RES_MISO : in  t_ll_miso;

      ERR      : out std_logic;

      ARESET     : in  std_logic;
      CLK_IN        : in  std_logic
      );
end LL_sqrt_wrp;

architecture RTL of LL_sqrt_wrp is

component LL_sqrt_float32   
   port(
      A_MOSI   : in  t_ll_mosi32;
      A_MISO   : out t_ll_miso;

      RES_MOSI : out t_ll_mosi32;
      RES_MISO : in  t_ll_miso;

      ERR      : out std_logic;

      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC
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


u0LL_sqrt_wrp : LL_sqrt_float32   
   port map(


      A_MOSI     => A_MOSI,
      A_MISO     => A_MISO,

      RES_MOSI     => RES_MOSI,
      RES_MISO     => RES_MISO,

      ERR         => ERR,

      ARESET      => ARESET,
      CLK         => clk0_out_sig
      );

end RTL;


