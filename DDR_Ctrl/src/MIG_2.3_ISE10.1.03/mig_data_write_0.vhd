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
--  /   /        Filename           : mig_data_write_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Splits the user data into the rise data and the fall data.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_data_write_0 is
  port(
    clk                 : in  std_logic;
    clk90               : in  std_logic;
    reset90             : in  std_logic;
    wdf_data            : in  std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    mask_data           : in  std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
    ctrl_wren           : in  std_logic;
    ctrl_dqs_rst        : in  std_logic;
    ctrl_dqs_en         : in  std_logic;
    dqs_rst             : out std_logic;
    dqs_en              : out std_logic;
    wr_en               : out std_logic;
    wr_data_rise        : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    wr_data_fall        : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    mask_data_rise      : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
    mask_data_fall      : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0)
    );
end mig_data_write_0;

architecture arch of mig_data_write_0 is

  signal wr_en_clk270_r1         : std_logic;
  signal wr_en_clk90_r3          : std_logic;
  signal dqs_rst_r1              : std_logic;
  signal dqs_en_r1               : std_logic;
  signal dqs_en_r2               : std_logic;

  attribute syn_preserve            : boolean;
  attribute syn_preserve of arch    : architecture is true;

begin

  --***************************************************************************

  dqs_rst <= dqs_rst_r1;
  dqs_en  <= dqs_en_r2;
  wr_en   <= wr_en_clk90_r3;

  process(clk90)
  begin
    if(clk90'event and clk90 = '0') then
        wr_en_clk270_r1 <= ctrl_wren;
        dqs_rst_r1      <= ctrl_dqs_rst;
        dqs_en_r1       <= not ctrl_dqs_en;
    end if;
  end process;


  process(clk)
  begin
    if(clk'event and clk = '0') then
        dqs_en_r2 <= dqs_en_r1;
    end if;
  end process;

  process(clk90)
  begin
    if(clk90'event and clk90 = '1') then
        wr_en_clk90_r3 <= wr_en_clk270_r1;
    end if;
  end process;

  --***************************************************************************
  -- Format write data/mask: Data is in format: {rise, fall}
  --***************************************************************************

  wr_data_rise <= wdf_data((DATA_WIDTH*2)-1 downto DATA_WIDTH);
  wr_data_fall <= wdf_data((DATA_WIDTH-1) downto 0);

  mask_data_rise <= (others => '0') when (wr_en_clk90_r3 = '0') else
                    mask_data((DATA_MASK_WIDTH*2 - 1) downto data_mask_width);
  mask_data_fall <= (others => '0') when (wr_en_clk90_r3 = '0') else
                    mask_data((DATA_MASK_WIDTH - 1) downto 0);

end arch;
