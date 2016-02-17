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
--  /   /        Filename           : mig_wr_data_fifo_16.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the block RAM based FIFO to store the user
--              interface data into it and read after a specified amount is
--              already written. The reading starts when the almost full
--              signal is generated whose offset is programmable.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_wr_data_fifo_16 is
  port(
    clk0              : in  std_logic;
    clk90             : in  std_logic;
    rst               : in  std_logic;
    --Write data fifo signals
    app_wdf_data      : in  std_logic_vector(31 downto 0);
    app_mask_data     : in  std_logic_vector(3 downto 0);
    app_wdf_wren      : in  std_logic;
    ctrl_wdf_rden     : in  std_logic;
    wdf_data          : out std_logic_vector(31 downto 0);
    mask_data         : out std_logic_vector(3 downto 0);
    wr_df_almost_full : out std_logic
    );
end mig_wr_data_fifo_16;

architecture arch of mig_wr_data_fifo_16 is

  signal ctrl_wdf_rden_270 : std_logic;
  signal ctrl_wdf_rden_90  : std_logic;
  signal rst_r             : std_logic;

begin

  --***************************************************************************

  process(clk0)
  begin
    if(clk0'event and clk0 = '1') then
      rst_r <= rst;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '0' then
      ctrl_wdf_rden_270 <= ctrl_wdf_rden;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      ctrl_wdf_rden_90 <= ctrl_wdf_rden_270;
    end if;
  end process;

  Wdf_1 : FIFO16
    generic map (
      ALMOST_FULL_OFFSET      => X"00F",
      ALMOST_EMPTY_OFFSET     => X"007",
      DATA_WIDTH              => 36,
      FIRST_WORD_FALL_THROUGH => false
      )
    port map (
      ALMOSTEMPTY => open,
      ALMOSTFULL  => wr_df_almost_full,
      DO          => wdf_data(31 downto 0),
      DOP         => mask_data(3 downto 0),
      EMPTY       => open,
      FULL        => open,
      RDCOUNT     => open,
      RDERR       => open,
      WRCOUNT     => open,
      WRERR       => open,
      DI          => app_wdf_data(31 downto 0),
      DIP         => app_mask_data(3 downto 0),
      RDCLK       => clk90,
      RDEN        => ctrl_wdf_rden_90,
      RST         => rst_r,
      WRCLK       => clk0,
      WREN        => app_wdf_wren
      );

end arch;
