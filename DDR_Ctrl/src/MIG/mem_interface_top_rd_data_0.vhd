-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_rd_data_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: The delay between the read data with respect to the command
--              issued is calculted in terms of no. of clocks. This data is
--              then stored into the FIFOs and then read back and given as
--              the ouput for comparison.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_rd_data_0 is
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
end mem_interface_top_rd_data_0;

architecture arch of mem_interface_top_rd_data_0 is

  component mem_interface_top_rd_data_fifo_0
    port(
      CLK                  : in  std_logic;
      RESET                : in  std_logic;
      READ_EN_DELAYED_RISE : in  std_logic;
      READ_EN_DELAYED_FALL : in  std_logic;
      FIRST_RISING         : in  std_logic;
      READ_DATA_RISE       : in  std_logic_vector(memory_width-1 downto 0);
      READ_DATA_FALL       : in  std_logic_vector(memory_width-1 downto 0);
      fifo_rd_enable       : in  std_logic;
      READ_DATA_FIFO_RISE  : out std_logic_vector(memory_width-1 downto 0);
      READ_DATA_FIFO_FALL  : out std_logic_vector(memory_width-1 downto 0);
      READ_DATA_VALID      : out std_logic
      );
  end component;

  component mem_interface_top_pattern_compare8
    port(
      clk            : in  std_logic;
      rst            : in  std_logic;
      ctrl_rden      : in  std_logic;
      rd_data_rise   : in  std_logic_vector(7 downto 0);
      rd_data_fall   : in  std_logic_vector(7 downto 0);
      comp_done      : out std_logic;
      first_rising   : out std_logic;
      rd_en_rise   : out std_logic;
      rd_en_fall   : out std_logic
      );
  end component;

  component mem_interface_top_pattern_compare4
    port(
      clk            : in  std_logic;
      rst            : in  std_logic;
      ctrl_rden      : in  std_logic;
      rd_data_rise   : in  std_logic_vector(3 downto 0);
      rd_data_fall   : in  std_logic_vector(3 downto 0);
      comp_done      : out std_logic;
      first_rising   : out std_logic;
      rd_en_rise   : out std_logic;
      rd_en_fall   : out std_logic
      );
  end component;

  signal read_data_valid_i    : std_logic_vector(data_strobe_width-1 downto 0);
  signal COMP_DONE_int        : std_logic_vector(data_strobe_width-1 downto 0);
  signal FIRST_RISING_int     : std_logic_vector(data_strobe_width-1 downto 0);

  signal READ_EN_DELAYED_RISE : std_logic_vector(data_strobe_width-1 downto 0);
  signal READ_EN_DELAYED_FALL : std_logic_vector(data_strobe_width-1 downto 0);
  signal fifo_read_enable_r   : std_logic;
  signal fifo_read_enable_2r  : std_logic;

  signal RESET_r1             : std_logic;

begin

  READ_DATA_VALID <= read_data_valid_i(0);

  COMP_DONE <=  COMP_DONE_int(0)  and  COMP_DONE_int(1)  and  COMP_DONE_int(2)  and  COMP_DONE_int(3)  and  COMP_DONE_int(4)  and  COMP_DONE_int(5)  and  COMP_DONE_int(6)  and  COMP_DONE_int(7)  and  COMP_DONE_int(8)  and  COMP_DONE_int(9)  and  COMP_DONE_int(10)  and  COMP_DONE_int(11)  and  COMP_DONE_int(12)  and  COMP_DONE_int(13)  and  COMP_DONE_int(14)  and  COMP_DONE_int(15)  and  COMP_DONE_int(16)  and  COMP_DONE_int(17) ;

  process(CLK)
  begin
    if (CLK = '1' and CLK'event) then
      RESET_r1 <= RESET;
    end if;
  end process;

  process(CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (RESET_r1 = '1') then
        fifo_read_enable_r  <= '0';
        fifo_read_enable_2r <= '0';
      else
        fifo_read_enable_r  <= READ_EN_DELAYED_RISE(0);
        fifo_read_enable_2r <= fifo_read_enable_r;
      end if;
    end if;
  end process;

pattern_compare4_gen: for i in 0 to (data_strobe_width-1) generate
  pattern_0 : mem_interface_top_pattern_compare4
    port map (
      clk          => CLK,
      rst          => RESET,
      ctrl_rden    => CTRL_RDEN,
      rd_data_rise => READ_DATA_RISE(4*i+3 downto 4*i),
      rd_data_fall => READ_DATA_FALL(4*i+3 downto 4*i),
      comp_done    => COMP_DONE_int(i),
      first_rising => FIRST_RISING_int(i),
      rd_en_rise   => READ_EN_DELAYED_RISE(i),
      rd_en_fall   => READ_EN_DELAYED_FALL(i)
      );
end generate;

rd_data_fifo_gen: for i in 0 to (data_strobe_width-1) generate
  rd_data_fifo0 : mem_interface_top_rd_data_fifo_0
    port map (
      CLK                  => CLK,
      RESET                => RESET,
      fifo_rd_enable       => fifo_read_enable_2r,
      READ_EN_DELAYED_RISE => READ_EN_DELAYED_RISE(i),
      READ_EN_DELAYED_FALL => READ_EN_DELAYED_FALL(i),
      FIRST_RISING         => FIRST_RISING_int(i),
      READ_DATA_RISE       => READ_DATA_RISE(4*i+3 downto 4*i),
      READ_DATA_FALL       => READ_DATA_FALL(4*i+3 downto 4*i),
      READ_DATA_FIFO_RISE  => READ_DATA_FIFO_RISE(4*i+3 downto 4*i),
      READ_DATA_FIFO_FALL  => READ_DATA_FIFO_FALL(4*i+3 downto 4*i),
      READ_DATA_VALID      => read_data_valid_i(i)
      );
end generate;

end arch;
