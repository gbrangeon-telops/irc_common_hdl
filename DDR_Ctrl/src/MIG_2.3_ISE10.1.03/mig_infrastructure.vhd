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
--  /   /        Filename           : mig_infrastructure.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the DCM of the FPGA device. The system clock is
--              given as the input and two clocks that are phase shifted by
--              90 degrees are taken out. It also give the reset signals in
--              phase with the clocks.
--Revision History:
--   Rev 1.1 - Parameter CLK_TYPE added and logic for  DIFFERENTIAL and 
--             SINGLE_ENDED added. PK. 20/6/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_infrastructure is
  port (
      idelay_ctrl_rdy     : in std_logic;

      clk_0           : in std_logic;
      clk_90          : in std_logic;
      dcm_lock        : in std_logic;
      clk_200         : in std_logic;
      sys_reset_in_n  : in std_logic;

      sys_rst             : out std_logic;
      sys_rst90           : out std_logic;
      sys_rst_r1          : out std_logic
      );
end mig_infrastructure;

architecture arch of mig_infrastructure is

  -- # of clock cycles to delay deassertion of reset. Needs to be a fairly
  -- high number not so much for metastability protection, but to give time
  -- for reset (i.e. stable clock cycles) to propagate through all state
  -- machines and to all control signals (i.e. not all control signals have
  -- resets, instead they rely on base state logic being reset, and the effect
  -- of that reset propagating through the logic). Need this because we may not
  -- be getting stable clock cycles while reset asserted (i.e. since reset
  -- depends on DCM lock status)
  constant RST_SYNC_NUM   : integer := 12;

  
  signal rst0_sync_r      : std_logic_vector((RST_SYNC_NUM -1) downto 0);
  signal rst200_sync_r    : std_logic_vector((RST_SYNC_NUM -1) downto 0);
  signal rst90_sync_r     : std_logic_vector((RST_SYNC_NUM -1) downto 0);
  signal rst_tmp          : std_logic;
  signal ref_clk200_in    : std_logic;
  signal sys_reset        : std_logic;

  constant add_const      : std_logic_vector(15 downto 0) := X"FFFF" ;

begin

  --***************************************************************************

  
  sys_reset   <= (not sys_reset_in_n) when (reset_active_low = '1') else
                  sys_reset_in_n;

  

  --***************************************************************************
  -- Reset synchronization
  -- NOTES:
  --   1. shut down the whole operation if the DCM hasn't yet locked (and by
  --      inference, this means that external SYS_RST_IN has been asserted -
  --      DCM deasserts DCM_LOCK as soon as SYS_RST_IN asserted)
  --   2. In the case of all resets except rst200, also assert reset if the
  --      IDELAY master controller is not yet ready
  --   3. asynchronously assert reset. This was we can assert reset even if
  --      there is no clock (needed for things like 3-stating output buffers).
  --      reset deassertion is synchronous.
  --***************************************************************************

  rst_tmp  <= (not dcm_lock) or (not idelay_ctrl_rdy) or (sys_reset);

  process(clk_0, rst_tmp)
  begin
    if (rst_tmp = '1') then
      rst0_sync_r <= add_const(RST_SYNC_NUM-1 downto 0);
    elsif (clk_0'event and clk_0 = '1') then
      rst0_sync_r(RST_SYNC_NUM-1 downto 1) <= rst0_sync_r(RST_SYNC_NUM-2 downto 0);
      rst0_sync_r(0) <= '0';
    end if;
  end process;

  process(clk_90, rst_tmp)
  begin
    if (rst_tmp = '1') then
      rst90_sync_r <= add_const(RST_SYNC_NUM-1 downto 0);
    elsif (clk_90'event and clk_90 = '1') then
      rst90_sync_r(RST_SYNC_NUM-1 downto 1) <= rst90_sync_r(RST_SYNC_NUM-2 downto 0);
      rst90_sync_r(0) <= '0';
    end if;
  end process;

  process(clk_200, dcm_lock)
  begin
    if (dcm_lock = '0') then
      rst200_sync_r <= add_const(RST_SYNC_NUM-1 downto 0);
    elsif (clk_200'event and clk_200 = '1') then
      rst200_sync_r(RST_SYNC_NUM-1 downto 1) <= rst200_sync_r(RST_SYNC_NUM-2 downto 0);
      rst200_sync_r(0) <= '0';
    end if;
  end process;


  sys_rst    <= rst0_sync_r(RST_SYNC_NUM-1);
  sys_rst90  <= rst90_sync_r(RST_SYNC_NUM-1);
  sys_rst_r1 <= rst200_sync_r(RST_SYNC_NUM-1);

end arch;
