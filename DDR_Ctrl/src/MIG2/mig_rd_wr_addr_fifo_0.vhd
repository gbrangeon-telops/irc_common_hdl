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
--  /   /        Filename           : mig_rd_wr_addr_fifo_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the block RAM based FIFO to store the user address
--              and the command information.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_rd_wr_addr_fifo_0 is
  port(
    clk0           : in  std_logic;
    clk90          : in  std_logic;
    rst            : in  std_logic;
    app_af_addr    : in  std_logic_vector(35 downto 0);
    app_af_wren    : in  std_logic;
    ctrl_af_rden   : in  std_logic;
    af_addr        : out std_logic_vector(35 downto 0);
    af_empty       : out std_logic;
    af_almost_full : out std_logic
    );
end mig_rd_wr_addr_fifo_0;

architecture arch of mig_rd_wr_addr_fifo_0 is

  signal fifo_input_write_addr  : std_logic_vector(35 downto 0);
  signal fifo_output_write_addr : std_logic_vector(35 downto 0);
  signal compare_value_r        : std_logic_vector(35 downto 0);
  signal app_af_addr_r          : std_logic_vector(35 downto 0);
  signal fifo_input_addr_r      : std_logic_vector(35 downto 0);
  signal af_en_r                : std_logic;
  signal af_en_2r               : std_logic;
  signal compare_result         : std_logic;
  signal clk270                 : std_logic;
  signal af_al_full_0           : std_logic;
  signal af_al_full_180         : std_logic;
  signal af_al_full_90          : std_logic;
  signal af_en_2r_270           : std_logic;
  signal fifo_input_270         : std_logic_vector(35 downto 0);
  signal rst_r                  : std_logic;

begin

  --***************************************************************************

  fifo_input_write_addr <= compare_result & app_af_addr_r(34 downto 0);
  af_addr               <= fifo_output_write_addr;
  compare_result <= '0' when (compare_value_r((NO_OF_CS + BANK_ADDRESS +
                                               ROW_ADDRESS + COLUMN_ADDRESS- 1)
                                              downto COLUMN_ADDRESS)
                              = fifo_input_write_addr((NO_OF_CS + BANK_ADDRESS +
                                                       ROW_ADDRESS + COLUMN_ADDRESS- 1)
                                                      downto COLUMN_ADDRESS))
                    else '1';

  clk270 <= not clk90;

  process(clk0)
  begin
    if(clk0'event and clk0 = '1') then
      rst_r <= rst;
    end if;
  end process;

  process(clk0)
  begin
    if(clk0'event and clk0 = '1') then
      if(rst_r = '1') then
        compare_value_r   <= (others => '0');
        app_af_addr_r     <= (others => '0');
        fifo_input_addr_r <= (others => '0');
        af_en_r           <= '0';
        af_en_2r          <= '0';
      else
        if(af_en_r = '1') then
          compare_value_r <= fifo_input_write_addr;
        end if;
        app_af_addr_r     <= app_af_addr;
        fifo_input_addr_r <= fifo_input_write_addr;
        af_en_r           <= app_af_wren;
        af_en_2r          <= af_en_r;
      end if;
    end if;
  end process;

-- A fix for FIFO16 according to answer record #22462

  process(clk270)
  begin
    if (clk270'event and clk270 = '1') then
      af_en_2r_270   <= af_en_2r;
      fifo_input_270 <= fifo_input_addr_r;
    end if;
  end process;

-- 3 Filp-flops logic is implemented at output to avoid the timimg errors

  process(clk0)
  begin
    if (clk0'event and clk0 = '0') then
      af_al_full_180 <= af_al_full_0;
    end if;
  end process;

  process(clk90)
  begin
    if (clk90'event and clk90 = '1') then
      af_al_full_90 <= af_al_full_180;
    end if;
  end process;

  process(clk0)
  begin
    if (clk0'event and clk0 = '1') then
      af_almost_full <= af_al_full_90;
    end if;
  end process;

-- Read/Write Address FIFO

  af_fifo16 : FIFO16
    generic map (
      ALMOST_FULL_OFFSET      => X"00F",
      ALMOST_EMPTY_OFFSET     => X"007",
      DATA_WIDTH              => 36,
      FIRST_WORD_FALL_THROUGH => true
      )

    port map (
      ALMOSTEMPTY => open,
      ALMOSTFULL  => af_al_full_0,
      DO          => fifo_output_write_addr(31 downto 0),
      DOP         => fifo_output_write_addr(35 downto 32),
      EMPTY       => af_empty,
      FULL        => open,
      RDCOUNT     => open,
      RDERR       => open,
      WRCOUNT     => open,
      WRERR       => open,
      DI          => fifo_input_270(31 downto 0),
      DIP         => fifo_input_270(35 downto 32),
      RDCLK       => clk0,
      RDEN        => ctrl_af_rden,
      RST         => rst_r,
      WRCLK       => clk270,
      WREN        => af_en_2r_270
      );

end arch;
