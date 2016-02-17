-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_data_tap_inc.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: The tap logic for calibration of the memory data with respect
--              to FPGA clock is provided here. According to the edge detection
--              or not the taps in the IDELAY element of the Virtex4 devices
--              are either increased or decreased.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_data_tap_inc is
  port(
    CLK                  : in  std_logic;
    RESET                : in  std_logic;
    DATA_DLYINC          : out std_logic;
    DATA_DLYCE           : out std_logic;
    DATA_DLYRST          : out std_logic;
    DATA_TAP_SEL_DONE    : out std_logic;
    DQS_sel_done         : in  std_logic;
    VALID_DATA_TAP_COUNT : in  std_logic;
    DATA_TAP_COUNT       : in  std_logic_vector(5 downto 0)
    );
end mem_interface_top_data_tap_inc;

architecture arch of mem_interface_top_data_tap_inc is

  signal data_dlyinc_clk0       : std_logic;
  signal data_dlyce_clk0        : std_logic;
  signal data_dlyrst_clk0       : std_logic;
  signal data_tap_inc_counter   : std_logic_vector(5 downto 0) := "000000";
  signal data_tap_sel_clk       : std_logic;
  signal data_tap_sel_r1        : std_logic;
  signal DQS_sel_done_r         : std_logic;
  signal VALID_DATA_TAP_COUNT_r : std_logic;
  signal rst_r                  : std_logic;

begin

  DATA_TAP_SEL_DONE <= data_tap_sel_r1;
  DATA_DLYINC       <= data_dlyinc_clk0;
  DATA_DLYCE        <= data_dlyce_clk0;
  DATA_DLYRST       <= data_dlyrst_clk0;


  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      rst_r <= RESET;
    end if;
  end process;

  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      if(rst_r = '1') then
        data_tap_sel_clk <= '0';
      elsif(data_tap_inc_counter = "000001") then
        data_tap_sel_clk <= '1';
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      if(rst_r = '1') then
        data_tap_sel_r1 <= '0';
      else
        data_tap_sel_r1 <= data_tap_sel_clk;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      if(rst_r = '1') then
        DQS_sel_done_r <= '0';
      elsif(DQS_sel_done = '1') then
        DQS_sel_done_r <= '1';
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      if(rst_r = '1') then
        VALID_DATA_TAP_COUNT_r <= '0';
      else
        VALID_DATA_TAP_COUNT_r <= VALID_DATA_TAP_COUNT;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      if(rst_r = '1' or DQS_sel_done_r = '0') then
        data_dlyinc_clk0     <= '0';
        data_dlyce_clk0      <= '0';
        data_dlyrst_clk0     <= '1';
        data_tap_inc_counter <= "000000";
      elsif(VALID_DATA_TAP_COUNT_r = '1') then
        data_dlyinc_clk0     <= '0';
        data_dlyce_clk0      <= '0';
        data_dlyrst_clk0     <= '0';
        data_tap_inc_counter <= DATA_TAP_COUNT;
      elsif(data_tap_inc_counter /= "000000") then  -- Data IDELAY incremented
        data_dlyinc_clk0     <= '1';
        data_dlyce_clk0      <= '1';
        data_dlyrst_clk0     <= '0';
        data_tap_inc_counter <= data_tap_inc_counter - '1';
      else                              -- Data IDELAY no change mode
        data_dlyinc_clk0     <= '0';
        data_dlyce_clk0      <= '0';
        data_dlyrst_clk0     <= '0';
        data_tap_inc_counter <= "000000";
      end if;
    end if;
  end process;

end arch;
