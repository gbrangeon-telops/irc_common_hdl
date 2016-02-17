-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_infrastructure_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: The DDR memory clocks are generated here using the differential
--              buffers and the ODDR elemnts in the IOBs.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_infrastructure_iobs_0 is
  port(
    CLK      : in  std_logic;
    DDR_CK   : out std_logic_vector((clk_width-1) downto 0);
    DDR_CK_N : out std_logic_vector((clk_width-1) downto 0)
    );
end mem_interface_top_infrastructure_iobs_0;

architecture arch of mem_interface_top_infrastructure_iobs_0 is


  signal DDR_CK_q   : std_logic_vector((clk_width-1) downto 0);
  signal vcc        : std_logic;
  signal gnd        : std_logic;

begin

  vcc <= '1';
  gnd <= '0';

  
  oddr_clk0: ODDR
    generic map(
                SRTYPE          => "SYNC",
                DDR_CLK_EDGE    => "OPPOSITE_EDGE"
           )
    port map(
              Q   => DDR_CK(0),--DDR_CK_q(0),
              C   => CLK,
              CE  => vcc,
              D1  => gnd,
              D2  => vcc,
              R   => gnd,
              S   => gnd
        );

  oddr_clk0n: ODDR
    generic map(
                SRTYPE          => "SYNC",
                DDR_CLK_EDGE    => "OPPOSITE_EDGE"
           )
    port map(
              Q   => DDR_CK_N(0),
              C   => CLK,
              CE  => vcc,
              D1  => vcc,
              D2  => gnd,
              R   => gnd,
              S   => gnd
        );

--  OBUFDS0 : OBUFDS
--        port map (
--                   I  => DDR_CK_q(0),
--                   O  => DDR_CK(0),
--                   OB => DDR_CK_N(0)
--                 );



end arch;
