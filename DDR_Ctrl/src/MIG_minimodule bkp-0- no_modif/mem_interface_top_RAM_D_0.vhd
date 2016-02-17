-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_RAM_D_.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Contains the distributed RAM which stores IOB output data that
--              is read from the memory.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_RAM_D_0 is
  port(
    DPO   : out std_logic_vector(memory_width-1 downto 0);
    A0    : in  std_logic;
    A1    : in  std_logic;
    A2    : in  std_logic;
    A3    : in  std_logic;
    D     : in  std_logic_vector(memory_width-1 downto 0);
    DPRA0 : in  std_logic;
    DPRA1 : in  std_logic;
    DPRA2 : in  std_logic;
    DPRA3 : in  std_logic;
    WCLK  : in  std_logic;
    WE    : in  std_logic
    );
end mem_interface_top_RAM_D_0;

architecture arch of mem_interface_top_RAM_D_0 is

begin


RAM16X1D0: RAM16X1D
  port map (
          DPO   => DPO(0),
          SPO   => open,
          A0    => A0,
          A1    => A1,
          A2    => A2,
          A3    => A3,
          D     => D(0),
          DPRA0 => DPRA0,
          DPRA1 => DPRA1,
          DPRA2 => DPRA2,
          DPRA3 => DPRA3,
          WCLK  => WCLK,
          WE    => WE
        );



RAM16X1D1: RAM16X1D
  port map (
          DPO   => DPO(1),
          SPO   => open,
          A0    => A0,
          A1    => A1,
          A2    => A2,
          A3    => A3,
          D     => D(1),
          DPRA0 => DPRA0,
          DPRA1 => DPRA1,
          DPRA2 => DPRA2,
          DPRA3 => DPRA3,
          WCLK  => WCLK,
          WE    => WE
        );



RAM16X1D2: RAM16X1D
  port map (
          DPO   => DPO(2),
          SPO   => open,
          A0    => A0,
          A1    => A1,
          A2    => A2,
          A3    => A3,
          D     => D(2),
          DPRA0 => DPRA0,
          DPRA1 => DPRA1,
          DPRA2 => DPRA2,
          DPRA3 => DPRA3,
          WCLK  => WCLK,
          WE    => WE
        );



RAM16X1D3: RAM16X1D
  port map (
          DPO   => DPO(3),
          SPO   => open,
          A0    => A0,
          A1    => A1,
          A2    => A2,
          A3    => A3,
          D     => D(3),
          DPRA0 => DPRA0,
          DPRA1 => DPRA1,
          DPRA2 => DPRA2,
          DPRA3 => DPRA3,
          WCLK  => WCLK,
          WE    => WE
        );



RAM16X1D4: RAM16X1D
  port map (
          DPO   => DPO(4),
          SPO   => open,
          A0    => A0,
          A1    => A1,
          A2    => A2,
          A3    => A3,
          D     => D(4),
          DPRA0 => DPRA0,
          DPRA1 => DPRA1,
          DPRA2 => DPRA2,
          DPRA3 => DPRA3,
          WCLK  => WCLK,
          WE    => WE
        );



RAM16X1D5: RAM16X1D
  port map (
          DPO   => DPO(5),
          SPO   => open,
          A0    => A0,
          A1    => A1,
          A2    => A2,
          A3    => A3,
          D     => D(5),
          DPRA0 => DPRA0,
          DPRA1 => DPRA1,
          DPRA2 => DPRA2,
          DPRA3 => DPRA3,
          WCLK  => WCLK,
          WE    => WE
        );



RAM16X1D6: RAM16X1D
  port map (
          DPO   => DPO(6),
          SPO   => open,
          A0    => A0,
          A1    => A1,
          A2    => A2,
          A3    => A3,
          D     => D(6),
          DPRA0 => DPRA0,
          DPRA1 => DPRA1,
          DPRA2 => DPRA2,
          DPRA3 => DPRA3,
          WCLK  => WCLK,
          WE    => WE
        );



RAM16X1D7: RAM16X1D
  port map (
          DPO   => DPO(7),
          SPO   => open,
          A0    => A0,
          A1    => A1,
          A2    => A2,
          A3    => A3,
          D     => D(7),
          DPRA0 => DPRA0,
          DPRA1 => DPRA1,
          DPRA2 => DPRA2,
          DPRA3 => DPRA3,
          WCLK  => WCLK,
          WE    => WE
        );



end arch;
