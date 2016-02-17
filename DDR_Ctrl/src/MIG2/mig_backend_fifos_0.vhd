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
--  /   /        Filename           : mig_backend_fifos_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: This module instantiates the modules containing internal FIFOs
--              to store the data and the address.
-- Revision History:
--   Rev 1.1 - Changes for V4 no edge straddle calibration scheme.
--             Training Pattern for pattern calibration changes to "A55A".
--             Various other changes. JYO. 6/6/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_backend_fifos_0 is
  port(
    clk0            : in  std_logic;
    clk90           : in  std_logic;
    rst             : in  std_logic;
    init_done       : in  std_logic;
    --Write address fifo signals
    app_af_addr     : in  std_logic_vector(35 downto 0);
    app_af_wren     : in  std_logic;
    ctrl_af_rden    : in  std_logic;
    af_addr         : out std_logic_vector(35 downto 0);
    af_empty        : out std_logic;
    af_almost_full  : out std_logic;
    --Write data fifo signals
    app_wdf_data    : in  std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    app_mask_data   : in  std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
    app_wdf_wren    : in  std_logic;
    ctrl_wdf_rden   : in  std_logic;
    wdf_data        : out std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    mask_data       : out std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
    wdf_almost_full : out std_logic
    );
end mig_backend_fifos_0;

architecture arch of mig_backend_fifos_0 is

  component mig_rd_wr_addr_fifo_0
    port(
      clk0           : in  std_logic;
      clk90          : in  std_logic;
      rst            : in  std_logic;
      --Write address fifo signals
      app_af_addr    : in  std_logic_vector(35 downto 0);
      app_af_wren    : in  std_logic;
      ctrl_af_rden   : in  std_logic;
      af_addr        : out std_logic_vector(35 downto 0);
      af_empty       : out std_logic;
      af_almost_full : out std_logic
      );
  end component;

  component mig_wr_data_fifo_16
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
  end component;

  component mig_wr_data_fifo_8
    port(
      clk0              : in  std_logic;
      clk90             : in  std_logic;
      rst               : in  std_logic;
      --Write data fifo signals
      app_wdf_data      : in  std_logic_vector(15 downto 0);
      app_mask_data     : in  std_logic_vector(1 downto 0);
      app_wdf_wren      : in  std_logic;
      ctrl_wdf_rden     : in  std_logic;
      wdf_data          : out std_logic_vector(15 downto 0);
      mask_data         : out std_logic_vector(1 downto 0);
      wr_df_almost_full : out std_logic
      );
  end component;

  signal wr_df_almost_full_w    : std_logic_vector((FIFO_16-1) downto 0);

  signal init_count             : std_logic_vector(2 downto 0);
  signal init_wren              : std_logic;
  signal init_data              : std_logic_vector((DATA_WIDTH*2)-1 downto 0);
  signal init_flag              : std_logic;
  signal init_mux_app_wdf_data  : std_logic_vector((DATA_WIDTH*2)-1 downto 0);
  signal init_mux_app_mask_data : std_logic_vector((DATA_MASK_WIDTH*2)-1 downto 0);
  signal init_mux_app_wdf_wren  : std_logic;
  signal pattern_F              : std_logic_vector(143 downto 0);
  signal pattern_0              : std_logic_vector(143 downto 0);
  signal pattern_A              : std_logic_vector(143 downto 0);
  signal pattern_5              : std_logic_vector(143 downto 0);

  signal rst_r1                 : std_logic;

  attribute equivalent_register_removal : string;
  attribute syn_preserve                : boolean;
  attribute equivalent_register_removal of rst_r1 : signal is "no";
  attribute syn_preserve of rst_r1                : signal is true;

begin

  --***************************************************************************

  pattern_F <= X"FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
  pattern_0 <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000";
  pattern_A <= X"AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA";
  pattern_5 <= X"5555_5555_5555_5555_5555_5555_5555_5555_5555";
  wdf_almost_full <= wr_df_almost_full_w(0);

  process(clk0)
  begin
    if (clk0 = '1' and clk0'event) then
      rst_r1 <= rst;
    end if;
  end process;

  process(clk0)
  begin
    if (clk0'event and clk0 = '1') then
      if (rst_r1 = '1') then
        init_count <= (others => '0');
        init_wren  <= '0';
        init_data  <= (others => '0');
        init_flag  <= '0';
      else
        case init_count is

          when "000" =>
            if(init_flag = '1') then
              init_count <= (others => '0');
              init_wren  <= '0';
              init_data  <= (others => '0');
            else
             if(LOAD_MODE_REGISTER(2 downto 0) = "001") then
              init_count <= "110";
             else
              init_count <= "001";
             end if;
              init_wren  <= '1';
              init_data  <= (pattern_F((DATA_WIDTH-1) downto 0) &
                             pattern_0((DATA_WIDTH-1) downto 0));
            end if;

          when "001" =>
            if(LOAD_MODE_REGISTER(2 downto 0) = "011") then
              init_count <= "010";
            else
              init_count <= "110";
            end if;

            init_wren <= '1';
            init_data <= (pattern_F((DATA_WIDTH-1) downto 0) &
                          pattern_0((DATA_WIDTH-1) downto 0));

          when "010" =>
            init_count <= "011";
            init_wren  <= '1';
            init_data  <= (pattern_F((DATA_WIDTH-1) downto 0) &
                           pattern_0((DATA_WIDTH-1) downto 0));

          when "011" =>
            init_count <= "100";
            init_wren  <= '1';
            init_data  <= (pattern_F((DATA_WIDTH-1) downto 0) &
                           pattern_0((DATA_WIDTH-1) downto 0));

          when "100" =>
            init_count <= "101";
            init_wren  <= '1';
            init_data  <= (pattern_A((DATA_WIDTH-1) downto 0) &
                           pattern_5((DATA_WIDTH-1) downto 0));

          when "101" =>
            init_count <= "110";
            init_wren  <= '1';
            init_data  <= (pattern_5((DATA_WIDTH-1) downto 0) &
                           pattern_A((DATA_WIDTH-1) downto 0));

          when "110" =>
            init_count <= "111";
            init_wren  <= '1';
            init_data  <= (pattern_A((DATA_WIDTH-1) downto 0) &
                           pattern_5((DATA_WIDTH-1) downto 0));

          when "111" =>
            init_count <= "000";
            init_wren  <= '1';
            init_data  <= (pattern_5((DATA_WIDTH-1) downto 0) &
                           pattern_A((DATA_WIDTH-1) downto 0));
            init_flag  <= '1';

          when others =>
            init_count <= "000";
            init_wren  <= '0';
            init_data  <= (others => '0');
            init_flag  <= '0';

        end case;  -- case(init_count)
      end if;  -- else: !if(rst)
    end if;
  end process;

  init_mux_app_wdf_data  <= app_wdf_data when (init_done = '1') else init_data;
  init_mux_app_mask_data <= app_mask_data when (init_done = '1')
                            else (others => '0');
  init_mux_app_wdf_wren  <= app_wdf_wren when (init_done = '1') else init_wren;

  rd_wr_addr_fifo_00 : mig_rd_wr_addr_fifo_0
    port map (
      clk0           => clk0,
      clk90          => clk90,
      rst            => rst,
      app_af_addr    => app_af_addr,
      app_af_wren    => app_af_wren,
      ctrl_af_rden   => ctrl_af_rden,
      af_addr        => af_addr,
      af_empty       => af_empty,
      af_almost_full => af_almost_full
      );

  
wr_data_fifo_160 : mig_wr_data_fifo_16
  port map (
          clk0              => clk0,
          clk90             => clk90,
          rst               => rst,
          app_wdf_data      => init_mux_app_wdf_data(31 downto 0),
          app_mask_data     => init_mux_app_mask_data(3 downto 0),
          app_wdf_wren      => init_mux_app_Wdf_WrEn,
          ctrl_wdf_rden     => ctrl_Wdf_RdEn,
          wdf_data          => wdf_data(31 downto 0),
          mask_data         => mask_data(3 downto 0),
          wr_df_almost_full => wr_df_almost_full_w(0)
         );



wr_data_fifo_161 : mig_wr_data_fifo_16
  port map (
          clk0              => clk0,
          clk90             => clk90,
          rst               => rst,
          app_wdf_data      => init_mux_app_wdf_data(63 downto 32),
          app_mask_data     => init_mux_app_mask_data(7 downto 4),
          app_wdf_wren      => init_mux_app_Wdf_WrEn,
          ctrl_wdf_rden     => ctrl_Wdf_RdEn,
          wdf_data          => wdf_data(63 downto 32),
          mask_data         => mask_data(7 downto 4),
          wr_df_almost_full => wr_df_almost_full_w(1)
         );



wr_data_fifo_162 : mig_wr_data_fifo_16
  port map (
          clk0              => clk0,
          clk90             => clk90,
          rst               => rst,
          app_wdf_data      => init_mux_app_wdf_data(95 downto 64),
          app_mask_data     => init_mux_app_mask_data(11 downto 8),
          app_wdf_wren      => init_mux_app_Wdf_WrEn,
          ctrl_wdf_rden     => ctrl_Wdf_RdEn,
          wdf_data          => wdf_data(95 downto 64),
          mask_data         => mask_data(11 downto 8),
          wr_df_almost_full => wr_df_almost_full_w(2)
         );



wr_data_fifo_163 : mig_wr_data_fifo_16
  port map (
          clk0              => clk0,
          clk90             => clk90,
          rst               => rst,
          app_wdf_data      => init_mux_app_wdf_data(127 downto 96),
          app_mask_data     => init_mux_app_mask_data(15 downto 12),
          app_wdf_wren      => init_mux_app_Wdf_WrEn,
          ctrl_wdf_rden     => ctrl_Wdf_RdEn,
          wdf_data          => wdf_data(127 downto 96),
          mask_data         => mask_data(15 downto 12),
          wr_df_almost_full => wr_df_almost_full_w(3)
         );


  
wr_data_fifo_84 : mig_wr_data_fifo_8
  port map (
          clk0              => clk0,
          clk90             => clk90,
          rst               => rst,
          app_wdf_data      => init_mux_app_wdf_data(143 downto 128),
          app_mask_data     => init_mux_app_mask_data(17 downto 16),
          app_wdf_wren      => init_mux_app_wdf_wren,
          ctrl_wdf_rden     => ctrl_wdf_rden,
          wdf_data          => wdf_data(143 downto 128),
          mask_data         => mask_data(17 downto 16),
          wr_df_almost_full => wr_df_almost_full_w(4)
         );


end arch;
