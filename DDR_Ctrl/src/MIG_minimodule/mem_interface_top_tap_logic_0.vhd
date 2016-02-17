-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_tap_logic_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the tap_cntrl and the data_tap_inc modules.
--              Used for calibration of the memory data with the FPGA clock.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_tap_logic_0 is
  port(
    CLK                  : in  std_logic;
    RESET0               : in  std_logic;
    idelay_ctrl_rdy      : in  std_logic;
    CTRL_DUMMYREAD_START : in  std_logic;
    calibration_dq       : in  std_logic_vector((data_width - 1) downto 0);
    dqs_delayed          : in  std_logic_vector((data_strobe_width-1) downto 0);
    SEL_DONE             : out std_logic;
    data_idelay_inc      : out std_logic_vector((data_width-1) downto 0);
    data_idelay_ce       : out std_logic_vector((data_width-1) downto 0);
    data_idelay_rst      : out std_logic_vector((data_width-1) downto 0);
    dqs_idelay_inc       : out std_logic_vector((data_strobe_width-1) downto 0);
    dqs_idelay_ce        : out std_logic_vector((data_strobe_width-1) downto 0);
    dqs_idelay_rst       : out std_logic_vector((data_strobe_width-1) downto 0)
    );
end mem_interface_top_tap_logic_0;

architecture arch of mem_interface_top_tap_logic_0 is

  component mem_interface_top_tap_ctrl
    port(
      CLK                  : in  std_logic;
      RESET                : in  std_logic;
      RDY_STATUS           : in  std_logic;
      DQ_DATA              : in  std_logic;
      CTRL_DUMMYREAD_START : in  std_logic;
      BIT_BOUNDARY_CHECK   : in  std_logic;
      COMPARE_BIT          : in  std_logic;
      DLYINC               : out std_logic;
      DLYCE                : out std_logic;
      DLYINC_GLOBAL_FLAG   : out std_logic;
      CHAN_DONE            : out std_logic
      );
  end component;

  component mem_interface_top_data_tap_inc
    port(
      CLK                  : in  std_logic;
      RESET                : in  std_logic;
      RDY_STATUS           : in  std_logic;
      CALIBRATION_DQ       : in  std_logic_vector((DatabitsPerStrobe - 1) downto 0);
      CTRL_CALIB_START     : in  std_logic;
      DLYINC               : in  std_logic;
      DLYCE                : in  std_logic;
      DLYINC_GLOBAL_FLAG   : in  std_logic;
      CHAN_DONE            : in  std_logic;
      COMPARE_BIT          : out std_logic;
      DQ_DATA              : out std_logic;
      BIT_BOUNDARY_CHECK   : out std_logic;
      DATA_DLYINC          : out std_logic_vector((DatabitsPerStrobe - 1) downto 0);
      DATA_DLYCE           : out std_logic_vector((DatabitsPerStrobe - 1) downto 0);
      DATA_DLYRST          : out std_logic_vector((DatabitsPerStrobe - 1) downto 0);
      CALIB_DONE           : out std_logic
      );
  end component;

  signal dlyinc_dqs            : std_logic_vector((data_strobe_width - 1) downto 0);
  signal dlyce_dqs             : std_logic_vector((data_strobe_width - 1) downto 0);
  signal dlyinc_global_flag_dqs: std_logic_vector((data_strobe_width - 1) downto 0);
  signal chan_done_dqs         : std_logic_vector((data_strobe_width - 1) downto 0);
  signal compare_bit_dqs       : std_logic_vector((data_strobe_width - 1) downto 0);
  signal dq_data_dqs           : std_logic_vector((data_strobe_width - 1) downto 0);
  signal bit_boundary_check_dqs: std_logic_vector((data_strobe_width - 1) downto 0);
  signal calib_done_dqs        : std_logic_vector((data_strobe_width - 1) downto 0);
  signal data_tap_inc_done : std_logic;
  signal tap_sel_done      : std_logic;
  signal rst_r             : std_logic;
  
begin

  -- For controller to stop dummy reads
  SEL_DONE <= tap_sel_done;
  dqs_idelay_inc <= (others => '0');
  dqs_idelay_ce  <= (others => '0');
  dqs_idelay_rst <= (others => '0');

  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      rst_r <= RESET0;
    end if;
  end process;

  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      if (rst_r = '1') then
        data_tap_inc_done <= '0';
        tap_sel_done      <= '0';
      else
        data_tap_inc_done <= ( calib_done_dqs(0) and calib_done_dqs(1) );
        tap_sel_done      <= data_tap_inc_done;
      end if;
    end if;
  end process;

  --**********************************************************************
  --  tap_ctrl instances for  DDR_DQS strobes
  --**********************************************************************

tap_ctrl_gen: for i in 0 to (data_strobe_width-1) generate
  tap_ctrl_0: mem_interface_top_tap_ctrl
    port map (
          CLK                       => CLK,
          RESET                     => RESET0,
          RDY_STATUS                => idelay_ctrl_rdy,
          DQ_DATA                   => dq_data_dqs(i),
          CTRL_DUMMYREAD_START      => CTRL_DUMMYREAD_START,
          BIT_BOUNDARY_CHECK        => bit_boundary_check_dqs(i),
          DLYINC                    => dlyinc_dqs(i),
          DLYCE                     => dlyce_dqs(i),
          DLYINC_GLOBAL_FLAG        => dlyinc_global_flag_dqs(i),
          CHAN_DONE                 => chan_done_dqs(i),
          COMPARE_BIT               => compare_bit_dqs(i)
       );

  --**********************************************************************
  --  instances of data_tap_inc for each dqs and associated tap_ctrl
  --**********************************************************************
  data_tap_inc_0: mem_interface_top_data_tap_inc
    port map (
        CLK                     => CLK,
        RESET                   => RESET0,
        RDY_STATUS              => idelay_ctrl_rdy,
        CALIBRATION_DQ          => calibration_dq(3+4*i downto 4*i),
        CTRL_CALIB_START        => CTRL_DUMMYREAD_START,
        DLYINC                  => dlyinc_dqs(i),
        DLYCE                   => dlyce_dqs(i),
        DLYINC_GLOBAL_FLAG      => dlyinc_global_flag_dqs(i),
        CHAN_DONE               => chan_done_dqs(i),
        COMPARE_BIT             => compare_bit_dqs(i),
        DQ_DATA                 => dq_data_dqs(i),
        BIT_BOUNDARY_CHECK      => bit_boundary_check_dqs(i),
        DATA_DLYINC             => data_idelay_inc(3+4*i downto 4*i),
        DATA_DLYCE              => data_idelay_ce(3+4*i downto 4*i),
        DATA_DLYRST             => data_idelay_rst(3+4*i downto 4*i),
        CALIB_DONE              => calib_done_dqs(i)
             );
end generate;

end arch;
