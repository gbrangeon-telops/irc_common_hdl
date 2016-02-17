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
--  /   /        Filename           : mig_controller_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Puts the memory control signals like address, bank address, row
--              address strobe, column address strobe, write enable and clock
--              enable in the IOBs.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_controller_iobs_0 is
  port (
    ctrl_ddr_address : in  std_logic_vector((ROW_ADDRESS - 1) downto 0);
    ctrl_ddr_ba      : in  std_logic_vector((BANK_ADDRESS - 1) downto 0);
    ctrl_ddr_ras_l   : in  std_logic;
    ctrl_ddr_cas_l   : in  std_logic;
    ctrl_ddr_we_l    : in  std_logic;
    ctrl_ddr_cs_l    : in  std_logic;
    ctrl_ddr_cke     : in  std_logic;
    ddr_address      : out std_logic_vector((ROW_ADDRESS - 1) downto 0);
    ddr_ba           : out std_logic_vector((BANK_ADDRESS - 1) downto 0);
    ddr_ras_l        : out std_logic;
    ddr_cas_l        : out std_logic;
    ddr_we_l         : out std_logic;
    ddr_cke          : out std_logic;
    ddr_cs_l         : out std_logic
    );
end mig_controller_iobs_0;

architecture arch of mig_controller_iobs_0 is
  attribute syn_useioff : boolean ;

begin

  --***************************************************************************

  -- RAS: = 1 at reset
  r0 : OBUF
    port map(
      I => ctrl_ddr_ras_l,
      O => ddr_ras_l
      );

  -- CAS: = 1 at reset
  r1 : OBUF
    port map(
      I => ctrl_ddr_cas_l,
      O => ddr_cas_l
      );

  -- WE: = 1 at reset
  r2 : OBUF
    port map(
      I => ctrl_ddr_we_l,
      O => ddr_we_l
      );

  -- chip select: = 1 at reset

  OBUF_cs0 : OBUF
    port map(
      I => ctrl_ddr_cs_l,
      O => ddr_cs_l
      );

  -- CKE: = 0 at reset

  OBUF_cke0 : OBUF
    port map(
      I => ctrl_ddr_cke,
      O => ddr_cke
      );


  -- address: = 0 at reset
  gen_row: for row_i in 0 to ROW_ADDRESS-1 generate
    attribute syn_useioff of obuf_r : label is true;
  begin
    obuf_r: OBUF
    port map(
          I => ctrl_ddr_address(row_i),
          O => ddr_address(row_i)
          );
  end generate;

  -- bank address = 0 at reset
  gen_bank: for bank_i in 0 to BANK_ADDRESS-1 generate
    attribute syn_useioff of obuf_bank : label is true;
  begin
    obuf_bank: OBUF
    port map(
          I => ctrl_ddr_ba(bank_i),
          O => ddr_ba(bank_i)
          );
  end generate;

end arch;
