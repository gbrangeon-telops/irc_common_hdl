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

  signal init_count           : std_logic_vector(2 downto 0);
  signal init_wren            : std_logic;
  signal init_data            : std_logic_vector((data_width*2)-1 downto 0);
  signal init_flag            : std_logic;
  signal init_or_app_Wdf_data : std_logic_vector((data_width*2)-1 downto 0);
  signal init_or_app_Wdf_WrEn : std_logic;
  signal pattern_F            : std_logic_vector(31 downto 0);
  signal pattern_0            : std_logic_vector(31 downto 0);
  signal pattern_A            : std_logic_vector(31 downto 0);
  signal pattern_5            : std_logic_vector(31 downto 0);
  signal pattern_9            : std_logic_vector(31 downto 0);
  signal pattern_6            : std_logic_vector(31 downto 0);

  signal rst_r1               : std_logic;

begin

  pattern_F <= X"FFFF_FFFF";
  pattern_0 <= X"0000_0000";
  pattern_A <= X"AAAA_AAAA";
  pattern_5 <= X"5555_5555";
  pattern_9 <= X"9999_9999";
  pattern_6 <= X"6666_6666";

  Wdf_Almost_Full <= wr_df_almost_full_w(0);

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
              init_count <= "110";
              init_wren  <= '1';
              init_data  <= (pattern_F((data_width-1) downto 0) &
                             pattern_0((data_width-1) downto 0));
            end if;

          when "001" =>
            if(burst_length = "011") then
              init_count <= "010";
            else
              init_count <= "110";
            end if;

            init_wren <= '1';
            init_data <= (pattern_F((data_width-1) downto 0) &
                          pattern_0((data_width-1) downto 0));

          when "010" =>
            init_count <= "011";
            init_wren  <= '1';
            init_data  <= (pattern_F((data_width-1) downto 0) &
                           pattern_0((data_width-1) downto 0));

          when "011" =>
            init_count <= "100";
            init_wren  <= '1';
            init_data  <= (pattern_F((data_width-1) downto 0) &
                           pattern_0((data_width-1) downto 0));

          when "100" =>
            init_count <= "101";
            init_wren  <= '1';
            init_data  <= (pattern_A((data_width-1) downto 0) &
                           pattern_5((data_width-1) downto 0));

          when "101" =>
            init_count <= "110";
            init_wren  <= '1';
            init_data  <= (pattern_9((data_width-1) downto 0) &
                           pattern_6((data_width-1) downto 0));

          when "110" =>
            init_count <= "111";
            init_wren  <= '1';
            init_data  <= (pattern_A((data_width-1) downto 0) &
                           pattern_5((data_width-1) downto 0));

          when "111" =>
            init_count <= "000";
            init_wren  <= '1';
            init_data  <= (pattern_9((data_width-1) downto 0) &
                           pattern_6((data_width-1) downto 0));
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

  init_or_app_Wdf_data <= init_data or app_Wdf_data;
  init_or_app_Wdf_WrEn <= init_wren or app_Wdf_WrEn;

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
          app_Wdf_data      => init_or_app_Wdf_data(31 downto 0),
          app_mask_data     => app_mask_data(3 downto 0),
          app_Wdf_WrEn      => init_or_app_Wdf_WrEn,
          ctrl_Wdf_RdEn     => ctrl_Wdf_RdEn,
          Wdf_data          => Wdf_data(31 downto 0),
          mask_data         => mask_data(3 downto 0),
          wr_df_almost_full => wr_df_almost_full_w(0)
         );


  

end arch;
