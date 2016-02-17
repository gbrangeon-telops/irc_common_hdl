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
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_data_tap_inc is
  port(
    CLK                  : in  std_logic;
    RESET                : in  std_logic;
    RDY_STATUS           : in  std_logic;
    CALIBRATION_DQ       : in  std_logic_vector(DatabitsPerStrobe-1 downto 0);
    CTRL_CALIB_START     : in  std_logic;
    DLYINC               : in  std_logic;
    DLYCE                : in  std_logic;
    DLYINC_GLOBAL_FLAG   : in  std_logic;
    CHAN_DONE            : in  std_logic;
    COMPARE_BIT          : out std_logic;
    DQ_DATA              : out std_logic;
    BIT_BOUNDARY_CHECK   : out std_logic;
    DATA_DLYINC          : out std_logic_vector(DatabitsPerStrobe-1 downto 0);
    DATA_DLYCE           : out std_logic_vector(DatabitsPerStrobe-1 downto 0);
    DATA_DLYRST          : out std_logic_vector(DatabitsPerStrobe-1 downto 0);
    CALIB_DONE           : out std_logic
    );
end mem_interface_top_data_tap_inc;

architecture arch of mem_interface_top_data_tap_inc is

  signal muxout_d0d1      : std_logic;
  signal muxout_d2d3      : std_logic;
  signal data_dlyinc_int  : std_logic_vector(DatabitsPerStrobe-1 downto 0);
  signal data_dlyce_int   : std_logic_vector(DatabitsPerStrobe-1 downto 0);
  signal calib_done_int   : std_logic := '0';
  signal calibration_dq_r : std_logic_vector(DatabitsPerStrobe-1 downto 0) := (others => '0');

  signal chan_sel_int     : std_logic_vector(DatabitsPerStrobe-1 downto 0) := add_const6((DatabitsPerStrobe-1) downto 0);
  signal chan_sel         : std_logic_vector(DatabitsPerStrobe-1 downto 0);

  signal RESET_r1         : std_logic := '1';

  
  attribute max_fanout : string;
  attribute max_fanout of calibration_dq_r : signal is "5";
  attribute max_fanout of chan_sel_int     : signal is "5";

begin

  DATA_DLYINC <= data_dlyinc_int;
  DATA_DLYCE  <= data_dlyce_int;
  DATA_DLYRST <= (RESET_r1 & RESET_r1 & RESET_r1 & RESET_r1 );
  CALIB_DONE  <= calib_done_int;

  process(CLK)
  begin
    if (CLK = '1' and CLK'event) then
      RESET_r1 <= RESET;
    end if;
  end process;

  process(CLK)
  begin
    if (CLK'event and CLK = '1') then
      calibration_dq_r <= CALIBRATION_DQ;
    end if;
  end process;

  -- DQ Data Select Mux
   -- Stage 1 Muxes
  muxout_d0d1 <= calibration_dq_r(1) when (chan_sel(1) = '1')
                  else calibration_dq_r(0);
  muxout_d2d3 <= calibration_dq_r(3) when (chan_sel(3) = '1')
                  else calibration_dq_r(2);
                  
  -- Stage 2 Muxes
  DQ_DATA <= muxout_d2d3 when (chan_sel(2) = '1' or chan_sel(3) = '1')
                  else muxout_d0d1;
  BIT_BOUNDARY_CHECK <= '1' when ((calibration_dq_r = add_const3(DatabitsPerStrobe-1 downto 0))
                                  or (calibration_dq_r = add_const5(DatabitsPerStrobe-1 downto 0)))
                        else '0';
  COMPARE_BIT <= '1' when (calibration_dq_r = add_const5(DatabitsPerStrobe-1 downto 0))
                 else '0';

  dlyce_dlyinc : for i in 0 to DatabitsPerStrobe-1 generate
  begin
    data_dlyce_int(i)  <= DLYCE  when(chan_sel(i) = '1') else '0';
    data_dlyinc_int(i) <= DLYINC when(chan_sel(i) = '1') else '0';
  end generate dlyce_dlyinc;

  -- Module that controls the calib_done
  process(CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (RESET_r1 = '1') then
        calib_done_int <= '0';
      elsif(CTRL_CALIB_START = '1') then
        if (chan_sel = add_const3(DatabitsPerStrobe-1 downto 0)) then
          calib_done_int <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Module that controls the chan_sel
  process(CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (RESET_r1 = '1') then
        chan_sel_int <= add_const6((DatabitsPerStrobe-1) downto 0);
      elsif(CTRL_CALIB_START = '1') then
        if (CHAN_DONE = '1') then
          chan_sel_int((DatabitsPerStrobe-1) downto 1) <= chan_sel_int((DatabitsPerStrobe-2) downto 0);
          chan_sel_int(0) <= '0';
        end if;
      end if;
    end if;
  end process;

  chan_sel_gen : for j in 0 to DatabitsPerStrobe-1 generate
  begin
    chan_sel(j) <= chan_sel_int(j) or DLYINC_GLOBAL_FLAG;
  end generate chan_sel_gen;


end arch;
