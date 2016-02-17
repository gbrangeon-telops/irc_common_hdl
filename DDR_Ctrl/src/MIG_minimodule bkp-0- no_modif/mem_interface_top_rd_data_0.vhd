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
      rise_clk_count : out std_logic_vector(2 downto 0);
      fall_clk_count : out std_logic_vector(2 downto 0)
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
      rise_clk_count : out std_logic_vector(2 downto 0);
      fall_clk_count : out std_logic_vector(2 downto 0)
      );
  end component;

  signal rd_en_r1          : std_logic_vector(ReadEnable-1 downto 0);
  signal rd_en_r2          : std_logic_vector(ReadEnable-1 downto 0);
  signal rd_en_r3          : std_logic_vector(ReadEnable-1 downto 0);
  signal rd_en_r4          : std_logic_vector(ReadEnable-1 downto 0);
  signal rd_en_r5          : std_logic_vector(ReadEnable-1 downto 0);
  signal rd_en_r6          : std_logic_vector(ReadEnable-1 downto 0);
  signal comp_done_r       : std_logic;
  signal comp_done_r1      : std_logic;
  signal comp_done_r2      : std_logic;
  signal rd_en_rise        : std_logic_vector(data_strobe_width-1 downto 0);
  signal rd_en_fall        : std_logic_vector(data_strobe_width-1 downto 0);
  signal ctrl_rden1        : std_logic_vector(ReadEnable-1 downto 0);
  signal first_rising_rden : std_logic_vector(ReadEnable-1 downto 0);
  signal fifo_rd_enable1   : std_logic;
  signal fifo_rd_enable    : std_logic;
  signal rst_r             : std_logic;
  
signal read_data_valid0        : std_logic;


signal read_data_valid1        : std_logic;

  signal comp_done_0 : std_logic; 
  signal rise_clk_count0 : std_logic_vector(2 downto 0);
signal fall_clk_count0 : std_logic_vector(2 downto 0);


begin

   ctrl_rden1(0) <= ctrl_rden; 

  READ_DATA_VALID <= read_data_valid0;

  pattern_0 : mem_interface_top_pattern_compare8
 port map (
            clk             =>   CLK,
            rst             =>   RESET,
            ctrl_rden       =>   ctrl_rden1(0),
            rd_data_rise    =>   READ_DATA_RISE(15  downto  8),
            rd_data_fall    =>   READ_DATA_FALL(15  downto  8),
            comp_done       =>   comp_done_0,
            first_rising    =>   first_rising_rden(0),
            rise_clk_count  =>   rise_clk_count0,
            fall_clk_count  =>   fall_clk_count0
        );


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
        rd_en_r1 <= (others => '0');
        rd_en_r2 <= (others => '0');
        rd_en_r3 <= (others => '0');
        rd_en_r4 <= (others => '0');
        rd_en_r5 <= (others => '0');
        rd_en_r6 <= (others => '0');
      else
        rd_en_r1 <= ctrl_rden1;
        rd_en_r2 <= rd_en_r1;
        rd_en_r3 <= rd_en_r2;
        rd_en_r4 <= rd_en_r3;
        rd_en_r5 <= rd_en_r4;
        rd_en_r6 <= rd_en_r5;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      if(rst_r = '1') then
        comp_done_r  <= '0';
        comp_done_r1 <= '0';
        comp_done_r2 <= '0';
      else
        comp_done_r  <=  comp_done_0 ;
        comp_done_r1 <= comp_done_r;
        comp_done_r2 <= comp_done_r1;
      end if;
    end if;
  end process;

  comp_done <= '0' when rst_r = '1' else
                comp_done_0 ;

  
process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(0) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count0 is
    when "011" =>
        rd_en_rise(0) <= rd_en_r2(0);

    when "100" =>
        rd_en_rise(0) <= rd_en_r3(0);

    when "101" =>
        rd_en_rise(0) <= rd_en_r4(0);

    when "110" =>
        rd_en_rise(0) <= rd_en_r5(0);

    when "111" =>
        rd_en_rise(0) <= rd_en_r6(0);

    when others =>
        rd_en_rise(0) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(0) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count0 is
    when "011" =>
        rd_en_fall(0) <= rd_en_r2(0);

    when "100" =>
        rd_en_fall(0) <= rd_en_r3(0);

    when "101" =>
        rd_en_fall(0) <= rd_en_r4(0);

    when "110" =>
        rd_en_fall(0) <= rd_en_r5(0);

    when "111" =>
        rd_en_fall(0) <= rd_en_r6(0);

    when others =>
        rd_en_fall(0) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(1) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count0 is
    when "011" =>
        rd_en_rise(1) <= rd_en_r2(0);

    when "100" =>
        rd_en_rise(1) <= rd_en_r3(0);

    when "101" =>
        rd_en_rise(1) <= rd_en_r4(0);

    when "110" =>
        rd_en_rise(1) <= rd_en_r5(0);

    when "111" =>
        rd_en_rise(1) <= rd_en_r6(0);

    when others =>
        rd_en_rise(1) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(1) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count0 is
    when "011" =>
        rd_en_fall(1) <= rd_en_r2(0);

    when "100" =>
        rd_en_fall(1) <= rd_en_r3(0);

    when "101" =>
        rd_en_fall(1) <= rd_en_r4(0);

    when "110" =>
        rd_en_fall(1) <= rd_en_r5(0);

    when "111" =>
        rd_en_fall(1) <= rd_en_r6(0);

    when others =>
        rd_en_fall(1) <= '0';
  end case;
 end if;
end if;
end process;


  process(CLK)
  begin
    if(CLK'event and CLK = '1') then
      if(rst_r = '1') then
        fifo_rd_enable1 <= '0';
        fifo_rd_enable  <= '0';
      else
        fifo_rd_enable1 <= rd_en_rise(0);
        fifo_rd_enable  <= fifo_rd_enable1;
      end if;
    end if;
  end process;

  
  rd_data_fifo0: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(0),
          READ_EN_DELAYED_FALL  => rd_en_fall(0),
          FIRST_RISING          => first_rising_rden(0),
          READ_DATA_RISE        => READ_DATA_RISE(7 downto 0),
          READ_DATA_FALL        => READ_DATA_FALL(7 downto 0),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(7 downto 0),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(7 downto 0),
          READ_DATA_VALID       => read_data_valid0
        );


  rd_data_fifo1: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(1),
          READ_EN_DELAYED_FALL  => rd_en_fall(1),
          FIRST_RISING          => first_rising_rden(0),
          READ_DATA_RISE        => READ_DATA_RISE(15 downto 8),
          READ_DATA_FALL        => READ_DATA_FALL(15 downto 8),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(15 downto 8),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(15 downto 8),
          READ_DATA_VALID       => read_data_valid1
        );


end arch;
