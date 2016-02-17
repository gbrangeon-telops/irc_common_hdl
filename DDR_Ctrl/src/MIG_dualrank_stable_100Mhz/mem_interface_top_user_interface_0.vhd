-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_user_interface_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Interfaces with the user. The user should provide the data and
--              various commands.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_user_interface_0 is
  port(
    CLK                : in  std_logic;
    clk90              : in  std_logic;
    RESET              : in  std_logic;
    ctrl_rden          : in  std_logic;
    READ_DATA_RISE     : in  std_logic_vector((data_width -1) downto 0);
    READ_DATA_FALL     : in  std_logic_vector((data_width -1) downto 0);
    READ_DATA_FIFO_OUT : out std_logic_vector((data_width*2 -1) downto 0);
    comp_done          : out std_logic;
    READ_DATA_VALID    : out std_logic;
    AF_EMPTY           : out std_logic;
    AF_ALMOST_FULL     : out std_logic;
    APP_AF_ADDR        : in  std_logic_vector(35 downto 0);
    APP_AF_WREN        : in  std_logic;
    CTRL_AF_RDEN       : in  std_logic;
    AF_ADDR            : out std_logic_vector(35 downto 0);
    APP_WDF_DATA       : in  std_logic_vector((data_width*2 -1) downto 0);
    APP_MASK_DATA      : in  std_logic_vector((data_mask_width*2 -1) downto 0);
    APP_WDF_WREN       : in  std_logic;
    CTRL_WDF_RDEN      : in  std_logic;
    WDF_DATA           : out std_logic_vector((data_width*2 -1) downto 0);
    MASK_DATA          : out std_logic_vector((data_mask_width*2 -1) downto 0);
    WDF_ALMOST_FULL    : out std_logic
    );
end mem_interface_top_user_interface_0;

architecture arch of mem_interface_top_user_interface_0 is

  component mem_interface_top_rd_data_0
    port(
      CLK                 : in  std_logic;
      RESET               : in  std_logic;
      ctrl_rden           : in  std_logic;
      READ_DATA_RISE      : in  std_logic_vector(data_width-1 downto 0);
      READ_DATA_FALL      : in  std_logic_vector(data_width-1 downto 0);
      READ_DATA_FIFO_RISE : out std_logic_vector(data_width-1 downto 0);
      READ_DATA_FIFO_FALL : out std_logic_vector(data_width-1 downto 0);
      comp_done           : out std_logic;
      READ_DATA_VALID     : out std_logic
      );
  end component;

  component mem_interface_top_backend_fifos_0
    port(
      clk0            : in  std_logic;
      clk90           : in  std_logic;
      rst             : in  std_logic;
      app_af_addr     : in  std_logic_vector(35 downto 0);
      app_af_WrEn     : in  std_logic;
      ctrl_af_RdEn    : in  std_logic;
      af_addr         : out std_logic_vector(35 downto 0);
      af_Empty        : out std_logic;
      af_Almost_Full  : out std_logic;
      app_Wdf_data    : in  std_logic_vector((data_width*2 - 1) downto 0);
      app_mask_data   : in  std_logic_vector((data_mask_width*2 - 1) downto 0);
      app_Wdf_WrEn    : in  std_logic;
      ctrl_Wdf_RdEn   : in  std_logic;
      Wdf_data        : out std_logic_vector((data_width*2 - 1) downto 0);
      mask_data       : out std_logic_vector((data_mask_width*2 - 1) downto 0);
      Wdf_Almost_Full : out std_logic
      );
  end component;

  signal read_data_fifo_rise_i : std_logic_vector((data_width -1) downto 0);
  signal read_data_fifo_fall_i : std_logic_vector((data_width -1) downto 0);

begin

  READ_DATA_FIFO_OUT <= read_data_fifo_rise_i & read_data_fifo_fall_i;

  rd_data_00 : mem_interface_top_rd_data_0
    port map (
      CLK                 => CLK,
      RESET               => RESET,
      ctrl_rden           => ctrl_rden,
      READ_DATA_RISE      => READ_DATA_RISE,
      READ_DATA_FALL      => READ_DATA_FALL,
      READ_DATA_FIFO_RISE => read_data_fifo_rise_i,
      READ_DATA_FIFO_FALL => read_data_fifo_fall_i,
      comp_done           => comp_done,
      READ_DATA_VALID     => READ_DATA_VALID
      );

  backend_fifos_00 : mem_interface_top_backend_fifos_0
    port map (
      clk0            => CLK,
      clk90           => clk90,
      rst             => RESET,
      app_af_addr     => APP_AF_ADDR,
      app_af_WrEn     => APP_AF_WREN,
      ctrl_af_RdEn    => CTRL_AF_RDEN,
      af_addr         => AF_ADDR,
      af_Empty        => AF_EMPTY,
      af_Almost_Full  => AF_ALMOST_FULL,
      app_Wdf_data    => APP_WDF_DATA,
      app_mask_data   => APP_MASK_DATA,
      app_Wdf_WrEn    => APP_WDF_WREN,
      ctrl_Wdf_RdEn   => CTRL_WDF_RDEN,
      Wdf_data        => WDF_DATA,
      mask_data       => MASK_DATA,
      Wdf_Almost_Full => WDF_ALMOST_FULL
      );

end arch;
