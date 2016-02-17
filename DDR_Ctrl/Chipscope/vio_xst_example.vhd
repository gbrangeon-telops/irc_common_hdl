-------------------------------------------------------------------------------
-- Copyright (c) 1999-2006 Xilinx Inc.  All rights reserved.
-------------------------------------------------------------------------------
-- Title      : Virtual I/O Core Xilinx XST Usage Example
-- Project    : ChipScope
-------------------------------------------------------------------------------
-- File       : vio_xst_example.vhd
-- Company    : Xilinx Inc.
-- Created    : 2002/11/26
-------------------------------------------------------------------------------
-- Description: Example of how to instantiate the VIO core in a VHDL design
--              for use with the Xilinx XST synthesis tool.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity vio_xst_example is
end vio_xst_example;

architecture structure of vio_xst_example is


  -------------------------------------------------------------------
  --
  --  VIO core component declaration
  --
  -------------------------------------------------------------------
  component vio
    port
    (
      control     : in    std_logic_vector(35 downto 0);
      clk         : in    std_logic;
      sync_out    :   out std_logic_vector(7 downto 0)
    );
  end component;


  -------------------------------------------------------------------
  --
  --  VIO core signal declarations
  --
  -------------------------------------------------------------------
  signal control    : std_logic_vector(35 downto 0);
  signal clk        : std_logic;
  signal sync_out   : std_logic_vector(7 downto 0);


begin


  -------------------------------------------------------------------
  --
  --  VIO core instance
  --
  -------------------------------------------------------------------
  i_vio : vio
    port map
    (
      control   => control,
      clk       => clk,
      sync_out  => sync_out
    );


end structure;

