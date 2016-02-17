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
--  /   /        Filename           : mig_infrastructure_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: The DDR memory clocks are generated here using the differential
--              buffers and the ODDR elemnts in the IOBs.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_infrastructure_iobs_0 is
  port(
    clk      : in  std_logic;
    ddr_ck   : out std_logic_vector((CLK_WIDTH - 1) downto 0);
    ddr_ck_n : out std_logic_vector((CLK_WIDTH - 1) downto 0)
    );
end mig_infrastructure_iobs_0;

architecture arch of mig_infrastructure_iobs_0 is


  signal ddr_ck_q   : std_logic_vector((CLK_WIDTH - 1) downto 0);
  signal vcc        : std_logic;
  signal gnd        : std_logic;

begin

  --***************************************************************************

  --***************************************************************************
  -- Memory clock generation
  --***************************************************************************

  vcc <= '1';
  gnd <= '0';

  gen_ck: for ck_i in 0 to CLK_WIDTH-1 generate
    u_oddr_ck_i : ODDR
      generic map (
        srtype        => "SYNC",
        ddr_clk_edge  => "OPPOSITE_EDGE"
      )
      port map (
        q   => ddr_ck_q(ck_i),
        c   => clk,
        ce  => vcc,
        d1  => gnd,
        d2  => vcc,
        r   => gnd,
        s   => gnd
      );

    u_obuf_ck_i : OBUFDS
      port map (
        i   => ddr_ck_q(ck_i),
        o   => ddr_ck(ck_i),
        ob  => ddr_ck_n(ck_i)
      );
  end generate;

end arch;
