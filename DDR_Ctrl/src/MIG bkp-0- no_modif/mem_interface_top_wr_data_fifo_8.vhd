-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_wr_data_fifo_8.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the block RAM based FIFO to store the user
--              interface data into it and read after a specified amount in
--              already written. The reading starts when the almost full signal
--              is generated whose offset is programmable.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_wr_data_fifo_8 is
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
end mem_interface_top_wr_data_fifo_8;

architecture arch of mem_interface_top_wr_data_fifo_8 is

  signal app_Wdf_data1     : std_logic_vector(35 downto 0);
  signal Wdf_data1         : std_logic_vector(35 downto 0);
  signal mask_data1        : std_logic_vector(3 downto 0);
  signal ctrl_Wdf_RdEn_270 : std_logic;
  signal ctrl_Wdf_RdEn_90  : std_logic;
  signal rst_r             : std_logic;

begin

  process(clk0)
  begin
    if(clk0'event and clk0 = '1') then
      rst_r <= rst;
    end if;
  end process;

  process(clk90)
  begin
    if(clk90'event and clk90 = '0') then
      ctrl_Wdf_RdEn_270 <= ctrl_Wdf_RdEn;
    end if;
  end process;

  process(clk90)
  begin
    if(clk90'event and clk90 = '1') then
      ctrl_Wdf_RdEn_90 <= ctrl_Wdf_RdEn_270;
    end if;
  end process;

  app_Wdf_data1 <= "00" & app_mask_data(1 downto 0) & "0000000000000000"
                   & app_Wdf_data(15 downto 0);
  Wdf_data  <= Wdf_data1(15 downto 0);
  mask_data <= mask_data1(1 downto 0);


-- Write Data FIFO (rising edge 16 and falling edge 16 = 32 bit data))

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
      DO          => Wdf_data1(31 downto 0),
      DOP         => mask_data1(3 downto 0),
      EMPTY       => open,
      FULL        => open,
      RDCOUNT     => open,
      RDERR       => open,
      WRCOUNT     => open,
      WRERR       => open,
      DI          => app_Wdf_data1(31 downto 0),
      DIP         => app_Wdf_data1(35 downto 32),
      RDCLK       => clk90,
      RDEN        => ctrl_Wdf_RdEn_90,
      RST         => rst_r,
      WRCLK       => clk0,
      WREN        => app_Wdf_WrEn
      );

end arch;
