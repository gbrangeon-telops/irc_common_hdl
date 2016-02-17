--*****************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you a
-- license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as-is" solely for use in developing programs and
-- solutions for Xilinx devices, with no obligation on the
-- part of Xilinx to provide support. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are
-- done at the user's sole risk and will be unsupported.
--
-- Copyright (c) 2005-2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part
-- of this text at all times.
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : 2.3
--  \   \        Application        : MIG
--  /   /        Filename           : mig_RAM_D_.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Contains the distributed RAM which stores IOB output data that
--              is read from the memory.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_RAM_D_0 is
  port(
    dpo   : out std_logic_vector(MEMORY_WIDTH - 1 downto 0);
    a0    : in  std_logic;
    a1    : in  std_logic;
    a2    : in  std_logic;
    a3    : in  std_logic;
    d     : in  std_logic_vector(MEMORY_WIDTH - 1 downto 0);
    dpra0 : in  std_logic;
    dpra1 : in  std_logic;
    dpra2 : in  std_logic;
    dpra3 : in  std_logic;
    wclk  : in  std_logic;
    we    : in  std_logic
    );
end mig_RAM_D_0;

architecture arch of mig_RAM_D_0 is

begin

  --***************************************************************************

  gen_ram_d: for ram_d_i in 0 to MEMORY_WIDTH-1 generate
    RAM16X1D_inst: RAM16X1D
    port map (
          DPO   => dpo(ram_d_i),
          SPO   => open,
          A0    => a0,
          A1    => a1,
          A2    => a2,
          A3    => a3,
          D     => d(ram_d_i),
          DPRA0 => dpra0,
          DPRA1 => dpra1,
          DPRA2 => dpra2,
          DPRA3 => dpra3,
          WCLK  => wclk,
          WE    => we
        );
  end generate;

end arch;
