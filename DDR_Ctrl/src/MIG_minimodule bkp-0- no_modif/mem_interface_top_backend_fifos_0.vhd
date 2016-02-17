-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_backend_fifos_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: This module instantiates the modules containing internal FIFOs
--              to store the data and the address.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_backend_fifos_0 is
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
end mem_interface_top_backend_fifos_0;

architecture arch of mem_interface_top_backend_fifos_0 is

  component mem_interface_top_rd_wr_addr_fifo_0
    port(
      clk0           : in  std_logic;
      clk90          : in  std_logic;
      rst            : in  std_logic;
      app_af_addr    : in  std_logic_vector(35 downto 0);
      app_af_WrEn    : in  std_logic;
      ctrl_af_RdEn   : in  std_logic;
      af_addr        : out std_logic_vector(35 downto 0);
      af_Empty       : out std_logic;
      af_Almost_Full : out std_logic
      );
  end component;

  component mem_interface_top_wr_data_fifo_16
    port(
      clk0              : in  std_logic;
      clk90             : in  std_logic;
      rst               : in  std_logic;
      app_Wdf_data      : in  std_logic_vector(31 downto 0);
      app_mask_data     : in  std_logic_vector(3 downto 0);
      app_Wdf_WrEn      : in  std_logic;
      ctrl_Wdf_RdEn     : in  std_logic;
      Wdf_data          : out std_logic_vector(31 downto 0);
      mask_data         : out std_logic_vector(3 downto 0);
      wr_df_almost_full : out std_logic
      );
  end component;

  component mem_interface_top_wr_data_fifo_8
    port(
      clk0              : in  std_logic;
      clk90             : in  std_logic;
      rst               : in  std_logic;
      app_Wdf_data      : in  std_logic_vector(15 downto 0);
      app_mask_data     : in  std_logic_vector(1 downto 0);
      app_Wdf_WrEn      : in  std_logic;
      ctrl_Wdf_RdEn     : in  std_logic;
      Wdf_data          : out std_logic_vector(15 downto 0);
      mask_data         : out std_logic_vector(1 downto 0);
      wr_df_almost_full : out std_logic
      );
  end component;

  signal wr_df_almost_full_w : std_logic_vector(fifo_16-1 downto 0);

begin

  Wdf_Almost_Full <= wr_df_almost_full_w(0);

  rd_wr_addr_fifo_00 : mem_interface_top_rd_wr_addr_fifo_0
    port map (
      clk0           => clk0,
      clk90          => clk90,
      rst            => rst,
      app_af_addr    => app_af_addr,
      app_af_WrEn    => app_af_WrEn,
      ctrl_af_RdEn   => ctrl_af_RdEn,
      af_addr        => af_addr,
      af_Empty       => af_Empty,
      af_Almost_Full => af_Almost_Full
      );

  
wr_data_fifo_160 : mem_interface_top_wr_data_fifo_16
  port map (
          clk0              => clk0,
          clk90             => clk90,
          rst               => rst,
          app_Wdf_data      => app_Wdf_data(31 downto 0),
          app_mask_data     => app_mask_data(3 downto 0),
          app_Wdf_WrEn      => app_Wdf_WrEn,
          ctrl_Wdf_RdEn     => ctrl_Wdf_RdEn,
          Wdf_data          => Wdf_data(31 downto 0),
          mask_data         => mask_data(3 downto 0),
          wr_df_almost_full => wr_df_almost_full_w(0)
         );


  

end arch;
