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
    dqs_delayed          : in  std_logic_vector((data_strobe_width-1) downto 0);
    SEL_DONE             : out std_logic;
    data_idelay_inc      : out std_logic_vector((ReadEnable-1) downto 0);
    data_idelay_ce       : out std_logic_vector((ReadEnable-1) downto 0);
    data_idelay_rst      : out std_logic_vector((ReadEnable-1) downto 0);
    dqs_idelay_inc       : out std_logic_vector((ReadEnable-1) downto 0);
    dqs_idelay_ce        : out std_logic_vector((ReadEnable-1) downto 0);
    dqs_idelay_rst       : out std_logic_vector((ReadEnable-1) downto 0)
    );
end mem_interface_top_tap_logic_0;

architecture arch of mem_interface_top_tap_logic_0 is

  component mem_interface_top_tap_ctrl
    port(
      CLK                  : in  std_logic;
      RESET                : in  std_logic;
      RDY_STATUS           : in  std_logic;
      DQS                  : in  std_logic;
      CTRL_DUMMYREAD_START : in  std_logic;
      DLYINC               : out std_logic;
      DLYCE                : out std_logic;
      DLYRST               : out std_logic;
      SEL_DONE             : out std_logic;
      VALID_DATA_TAP_COUNT : out std_logic;
      DATA_TAP_COUNT       : out std_logic_vector(5 downto 0)
      );
  end component;

  component mem_interface_top_data_tap_inc
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
  end component;

  signal data_tap_select   : std_logic_vector((ReadEnable-1) downto 0);
  signal dqs_tap_sel_done  : std_logic_vector((ReadEnable-1) downto 0);
  signal valid_tap_count   : std_logic_vector((ReadEnable-1) downto 0);
  signal data_tap_inc_done : std_logic;
  signal tap_sel_done      : std_logic;
  signal rst_r             : std_logic;
  
  signal data_tap_count0    : std_logic_vector(5 downto 0);
  signal data_tap_count1    : std_logic_vector(5 downto 0);
  signal data_tap_count2    : std_logic_vector(5 downto 0);
  signal data_tap_count3    : std_logic_vector(5 downto 0);
  signal data_tap_count4    : std_logic_vector(5 downto 0);

begin

  -- For controller to stop dummy reads
  SEL_DONE <= tap_sel_done;

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
        data_tap_inc_done <=  data_tap_select(0) and data_tap_select(1) and data_tap_select(2) and data_tap_select(3) and data_tap_select(4) ;
        tap_sel_done      <= data_tap_inc_done;

      end if;
    end if;
  end process;

  --**********************************************************************
  --  tap_ctrl instances for  DDR_DQS strobes
  --**********************************************************************

  
tap_ctrl_0: mem_interface_top_tap_ctrl
  port map (
          CLK                       => CLK,
          RESET                     => RESET0,
          RDY_STATUS                => idelay_ctrl_rdy,
          DQS                       => dqs_delayed(3),
          CTRL_DUMMYREAD_START      => CTRL_DUMMYREAD_START,
          DLYINC                    => dqs_idelay_inc(0),
          DLYCE                     => dqs_idelay_ce(0),
          DLYRST                    => dqs_idelay_rst(0),
          SEL_DONE                  => dqs_tap_sel_done(0),
          VALID_DATA_TAP_COUNT      => valid_tap_count(0),
          DATA_TAP_COUNT            => data_tap_count0(5 downto 0)
       );


tap_ctrl_1: mem_interface_top_tap_ctrl
  port map (
          CLK                       => CLK,
          RESET                     => RESET0,
          RDY_STATUS                => idelay_ctrl_rdy,
          DQS                       => dqs_delayed(7),
          CTRL_DUMMYREAD_START      => CTRL_DUMMYREAD_START,
          DLYINC                    => dqs_idelay_inc(1),
          DLYCE                     => dqs_idelay_ce(1),
          DLYRST                    => dqs_idelay_rst(1),
          SEL_DONE                  => dqs_tap_sel_done(1),
          VALID_DATA_TAP_COUNT      => valid_tap_count(1),
          DATA_TAP_COUNT            => data_tap_count1(5 downto 0)
       );


tap_ctrl_2: mem_interface_top_tap_ctrl
  port map (
          CLK                       => CLK,
          RESET                     => RESET0,
          RDY_STATUS                => idelay_ctrl_rdy,
          DQS                       => dqs_delayed(11),
          CTRL_DUMMYREAD_START      => CTRL_DUMMYREAD_START,
          DLYINC                    => dqs_idelay_inc(2),
          DLYCE                     => dqs_idelay_ce(2),
          DLYRST                    => dqs_idelay_rst(2),
          SEL_DONE                  => dqs_tap_sel_done(2),
          VALID_DATA_TAP_COUNT      => valid_tap_count(2),
          DATA_TAP_COUNT            => data_tap_count2(5 downto 0)
       );


tap_ctrl_3: mem_interface_top_tap_ctrl
  port map (
          CLK                       => CLK,
          RESET                     => RESET0,
          RDY_STATUS                => idelay_ctrl_rdy,
          DQS                       => dqs_delayed(15),
          CTRL_DUMMYREAD_START      => CTRL_DUMMYREAD_START,
          DLYINC                    => dqs_idelay_inc(3),
          DLYCE                     => dqs_idelay_ce(3),
          DLYRST                    => dqs_idelay_rst(3),
          SEL_DONE                  => dqs_tap_sel_done(3),
          VALID_DATA_TAP_COUNT      => valid_tap_count(3),
          DATA_TAP_COUNT            => data_tap_count3(5 downto 0)
       );


tap_ctrl_4: mem_interface_top_tap_ctrl
  port map (
          CLK                       => CLK,
          RESET                     => RESET0,
          RDY_STATUS                => idelay_ctrl_rdy,
          DQS                       => dqs_delayed(17),
          CTRL_DUMMYREAD_START      => CTRL_DUMMYREAD_START,
          DLYINC                    => dqs_idelay_inc(4),
          DLYCE                     => dqs_idelay_ce(4),
          DLYRST                    => dqs_idelay_rst(4),
          SEL_DONE                  => dqs_tap_sel_done(4),
          VALID_DATA_TAP_COUNT      => valid_tap_count(4),
          DATA_TAP_COUNT            => data_tap_count4(5 downto 0)
       );


  --**********************************************************************
  --  instances of data_tap_inc for each dqs and associated tap_ctrl
  --**********************************************************************

  
data_tap_inc_0: mem_interface_top_data_tap_inc
  port map (
        CLK                     => CLK,
        RESET                   => RESET0,
        DATA_DLYINC             => data_idelay_inc(0),
        DATA_DLYCE              => data_idelay_ce(0),
        DATA_DLYRST             => data_idelay_rst(0),
        DATA_TAP_SEL_DONE       => data_tap_select(0),
        DQS_sel_done            => dqs_tap_sel_done(0),
        VALID_DATA_TAP_COUNT    => valid_tap_count(0),
        DATA_TAP_COUNT          => data_tap_count0(5 downto 0)
             );


data_tap_inc_1: mem_interface_top_data_tap_inc
  port map (
        CLK                     => CLK,
        RESET                   => RESET0,
        DATA_DLYINC             => data_idelay_inc(1),
        DATA_DLYCE              => data_idelay_ce(1),
        DATA_DLYRST             => data_idelay_rst(1),
        DATA_TAP_SEL_DONE       => data_tap_select(1),
        DQS_sel_done            => dqs_tap_sel_done(1),
        VALID_DATA_TAP_COUNT    => valid_tap_count(1),
        DATA_TAP_COUNT          => data_tap_count1(5 downto 0)
             );


data_tap_inc_2: mem_interface_top_data_tap_inc
  port map (
        CLK                     => CLK,
        RESET                   => RESET0,
        DATA_DLYINC             => data_idelay_inc(2),
        DATA_DLYCE              => data_idelay_ce(2),
        DATA_DLYRST             => data_idelay_rst(2),
        DATA_TAP_SEL_DONE       => data_tap_select(2),
        DQS_sel_done            => dqs_tap_sel_done(2),
        VALID_DATA_TAP_COUNT    => valid_tap_count(2),
        DATA_TAP_COUNT          => data_tap_count2(5 downto 0)
             );


data_tap_inc_3: mem_interface_top_data_tap_inc
  port map (
        CLK                     => CLK,
        RESET                   => RESET0,
        DATA_DLYINC             => data_idelay_inc(3),
        DATA_DLYCE              => data_idelay_ce(3),
        DATA_DLYRST             => data_idelay_rst(3),
        DATA_TAP_SEL_DONE       => data_tap_select(3),
        DQS_sel_done            => dqs_tap_sel_done(3),
        VALID_DATA_TAP_COUNT    => valid_tap_count(3),
        DATA_TAP_COUNT          => data_tap_count3(5 downto 0)
             );


data_tap_inc_4: mem_interface_top_data_tap_inc
  port map (
        CLK                     => CLK,
        RESET                   => RESET0,
        DATA_DLYINC             => data_idelay_inc(4),
        DATA_DLYCE              => data_idelay_ce(4),
        DATA_DLYRST             => data_idelay_rst(4),
        DATA_TAP_SEL_DONE       => data_tap_select(4),
        DQS_sel_done            => dqs_tap_sel_done(4),
        VALID_DATA_TAP_COUNT    => valid_tap_count(4),
        DATA_TAP_COUNT          => data_tap_count4(5 downto 0)
             );


end arch;
