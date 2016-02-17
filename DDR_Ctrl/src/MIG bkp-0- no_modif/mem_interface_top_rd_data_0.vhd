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


signal read_data_valid2        : std_logic;


signal read_data_valid3        : std_logic;


signal read_data_valid4        : std_logic;


signal read_data_valid5        : std_logic;


signal read_data_valid6        : std_logic;


signal read_data_valid7        : std_logic;


signal read_data_valid8        : std_logic;


signal read_data_valid9        : std_logic;


signal read_data_valid10        : std_logic;


signal read_data_valid11        : std_logic;


signal read_data_valid12        : std_logic;


signal read_data_valid13        : std_logic;


signal read_data_valid14        : std_logic;


signal read_data_valid15        : std_logic;


signal read_data_valid16        : std_logic;


signal read_data_valid17        : std_logic;

  signal comp_done_0 : std_logic; 
signal comp_done_1 : std_logic; 
signal comp_done_2 : std_logic; 
signal comp_done_3 : std_logic; 
signal comp_done_4 : std_logic; 
  signal rise_clk_count0 : std_logic_vector(2 downto 0);
signal fall_clk_count0 : std_logic_vector(2 downto 0);

signal rise_clk_count1 : std_logic_vector(2 downto 0);
signal fall_clk_count1 : std_logic_vector(2 downto 0);

signal rise_clk_count2 : std_logic_vector(2 downto 0);
signal fall_clk_count2 : std_logic_vector(2 downto 0);

signal rise_clk_count3 : std_logic_vector(2 downto 0);
signal fall_clk_count3 : std_logic_vector(2 downto 0);

signal rise_clk_count4 : std_logic_vector(2 downto 0);
signal fall_clk_count4 : std_logic_vector(2 downto 0);


begin

   ctrl_rden1(0) <= ctrl_rden; 
 ctrl_rden1(1) <= ctrl_rden; 
 ctrl_rden1(2) <= ctrl_rden; 
 ctrl_rden1(3) <= ctrl_rden; 
 ctrl_rden1(4) <= ctrl_rden; 

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

pattern_1 : mem_interface_top_pattern_compare8
 port map (
            clk             =>   CLK,
            rst             =>   RESET,
            ctrl_rden       =>   ctrl_rden1(1),
            rd_data_rise    =>   READ_DATA_RISE(31  downto  24),
            rd_data_fall    =>   READ_DATA_FALL(31  downto  24),
            comp_done       =>   comp_done_1,
            first_rising    =>   first_rising_rden(1),
            rise_clk_count  =>   rise_clk_count1,
            fall_clk_count  =>   fall_clk_count1
        );

pattern_2 : mem_interface_top_pattern_compare8
 port map (
            clk             =>   CLK,
            rst             =>   RESET,
            ctrl_rden       =>   ctrl_rden1(2),
            rd_data_rise    =>   READ_DATA_RISE(47  downto  40),
            rd_data_fall    =>   READ_DATA_FALL(47  downto  40),
            comp_done       =>   comp_done_2,
            first_rising    =>   first_rising_rden(2),
            rise_clk_count  =>   rise_clk_count2,
            fall_clk_count  =>   fall_clk_count2
        );

pattern_3 : mem_interface_top_pattern_compare8
 port map (
            clk             =>   CLK,
            rst             =>   RESET,
            ctrl_rden       =>   ctrl_rden1(3),
            rd_data_rise    =>   READ_DATA_RISE(63  downto  56),
            rd_data_fall    =>   READ_DATA_FALL(63  downto  56),
            comp_done       =>   comp_done_3,
            first_rising    =>   first_rising_rden(3),
            rise_clk_count  =>   rise_clk_count3,
            fall_clk_count  =>   fall_clk_count3
        );

pattern_4 : mem_interface_top_pattern_compare8
 port map (
            clk             =>   CLK,
            rst             =>   RESET,
            ctrl_rden       =>   ctrl_rden1(4),
            rd_data_rise    =>   READ_DATA_RISE(71  downto  64),
            rd_data_fall    =>   READ_DATA_FALL(71  downto  64),
            comp_done       =>   comp_done_4,
            first_rising    =>   first_rising_rden(4),
            rise_clk_count  =>   rise_clk_count4,
            fall_clk_count  =>   fall_clk_count4
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
        comp_done_r  <=  comp_done_0 and comp_done_1 and comp_done_2 and comp_done_3 and comp_done_4 ;
        comp_done_r1 <= comp_done_r;
        comp_done_r2 <= comp_done_r1;
      end if;
    end if;
  end process;

  comp_done <= '0' when rst_r = '1' else
                comp_done_0 and comp_done_1 and comp_done_2 and comp_done_3 and comp_done_4 ;

  
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
    rd_en_rise(2) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count0 is
    when "011" =>
        rd_en_rise(2) <= rd_en_r2(0);

    when "100" =>
        rd_en_rise(2) <= rd_en_r3(0);

    when "101" =>
        rd_en_rise(2) <= rd_en_r4(0);

    when "110" =>
        rd_en_rise(2) <= rd_en_r5(0);

    when "111" =>
        rd_en_rise(2) <= rd_en_r6(0);

    when others =>
        rd_en_rise(2) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(2) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count0 is
    when "011" =>
        rd_en_fall(2) <= rd_en_r2(0);

    when "100" =>
        rd_en_fall(2) <= rd_en_r3(0);

    when "101" =>
        rd_en_fall(2) <= rd_en_r4(0);

    when "110" =>
        rd_en_fall(2) <= rd_en_r5(0);

    when "111" =>
        rd_en_fall(2) <= rd_en_r6(0);

    when others =>
        rd_en_fall(2) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(3) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count0 is
    when "011" =>
        rd_en_rise(3) <= rd_en_r2(0);

    when "100" =>
        rd_en_rise(3) <= rd_en_r3(0);

    when "101" =>
        rd_en_rise(3) <= rd_en_r4(0);

    when "110" =>
        rd_en_rise(3) <= rd_en_r5(0);

    when "111" =>
        rd_en_rise(3) <= rd_en_r6(0);

    when others =>
        rd_en_rise(3) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(3) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count0 is
    when "011" =>
        rd_en_fall(3) <= rd_en_r2(0);

    when "100" =>
        rd_en_fall(3) <= rd_en_r3(0);

    when "101" =>
        rd_en_fall(3) <= rd_en_r4(0);

    when "110" =>
        rd_en_fall(3) <= rd_en_r5(0);

    when "111" =>
        rd_en_fall(3) <= rd_en_r6(0);

    when others =>
        rd_en_fall(3) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(4) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count1 is
    when "011" =>
        rd_en_rise(4) <= rd_en_r2(1);

    when "100" =>
        rd_en_rise(4) <= rd_en_r3(1);

    when "101" =>
        rd_en_rise(4) <= rd_en_r4(1);

    when "110" =>
        rd_en_rise(4) <= rd_en_r5(1);

    when "111" =>
        rd_en_rise(4) <= rd_en_r6(1);

    when others =>
        rd_en_rise(4) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(4) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count1 is
    when "011" =>
        rd_en_fall(4) <= rd_en_r2(1);

    when "100" =>
        rd_en_fall(4) <= rd_en_r3(1);

    when "101" =>
        rd_en_fall(4) <= rd_en_r4(1);

    when "110" =>
        rd_en_fall(4) <= rd_en_r5(1);

    when "111" =>
        rd_en_fall(4) <= rd_en_r6(1);

    when others =>
        rd_en_fall(4) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(5) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count1 is
    when "011" =>
        rd_en_rise(5) <= rd_en_r2(1);

    when "100" =>
        rd_en_rise(5) <= rd_en_r3(1);

    when "101" =>
        rd_en_rise(5) <= rd_en_r4(1);

    when "110" =>
        rd_en_rise(5) <= rd_en_r5(1);

    when "111" =>
        rd_en_rise(5) <= rd_en_r6(1);

    when others =>
        rd_en_rise(5) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(5) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count1 is
    when "011" =>
        rd_en_fall(5) <= rd_en_r2(1);

    when "100" =>
        rd_en_fall(5) <= rd_en_r3(1);

    when "101" =>
        rd_en_fall(5) <= rd_en_r4(1);

    when "110" =>
        rd_en_fall(5) <= rd_en_r5(1);

    when "111" =>
        rd_en_fall(5) <= rd_en_r6(1);

    when others =>
        rd_en_fall(5) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(6) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count1 is
    when "011" =>
        rd_en_rise(6) <= rd_en_r2(1);

    when "100" =>
        rd_en_rise(6) <= rd_en_r3(1);

    when "101" =>
        rd_en_rise(6) <= rd_en_r4(1);

    when "110" =>
        rd_en_rise(6) <= rd_en_r5(1);

    when "111" =>
        rd_en_rise(6) <= rd_en_r6(1);

    when others =>
        rd_en_rise(6) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(6) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count1 is
    when "011" =>
        rd_en_fall(6) <= rd_en_r2(1);

    when "100" =>
        rd_en_fall(6) <= rd_en_r3(1);

    when "101" =>
        rd_en_fall(6) <= rd_en_r4(1);

    when "110" =>
        rd_en_fall(6) <= rd_en_r5(1);

    when "111" =>
        rd_en_fall(6) <= rd_en_r6(1);

    when others =>
        rd_en_fall(6) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(7) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count1 is
    when "011" =>
        rd_en_rise(7) <= rd_en_r2(1);

    when "100" =>
        rd_en_rise(7) <= rd_en_r3(1);

    when "101" =>
        rd_en_rise(7) <= rd_en_r4(1);

    when "110" =>
        rd_en_rise(7) <= rd_en_r5(1);

    when "111" =>
        rd_en_rise(7) <= rd_en_r6(1);

    when others =>
        rd_en_rise(7) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(7) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count1 is
    when "011" =>
        rd_en_fall(7) <= rd_en_r2(1);

    when "100" =>
        rd_en_fall(7) <= rd_en_r3(1);

    when "101" =>
        rd_en_fall(7) <= rd_en_r4(1);

    when "110" =>
        rd_en_fall(7) <= rd_en_r5(1);

    when "111" =>
        rd_en_fall(7) <= rd_en_r6(1);

    when others =>
        rd_en_fall(7) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(8) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count2 is
    when "011" =>
        rd_en_rise(8) <= rd_en_r2(2);

    when "100" =>
        rd_en_rise(8) <= rd_en_r3(2);

    when "101" =>
        rd_en_rise(8) <= rd_en_r4(2);

    when "110" =>
        rd_en_rise(8) <= rd_en_r5(2);

    when "111" =>
        rd_en_rise(8) <= rd_en_r6(2);

    when others =>
        rd_en_rise(8) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(8) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count2 is
    when "011" =>
        rd_en_fall(8) <= rd_en_r2(2);

    when "100" =>
        rd_en_fall(8) <= rd_en_r3(2);

    when "101" =>
        rd_en_fall(8) <= rd_en_r4(2);

    when "110" =>
        rd_en_fall(8) <= rd_en_r5(2);

    when "111" =>
        rd_en_fall(8) <= rd_en_r6(2);

    when others =>
        rd_en_fall(8) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(9) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count2 is
    when "011" =>
        rd_en_rise(9) <= rd_en_r2(2);

    when "100" =>
        rd_en_rise(9) <= rd_en_r3(2);

    when "101" =>
        rd_en_rise(9) <= rd_en_r4(2);

    when "110" =>
        rd_en_rise(9) <= rd_en_r5(2);

    when "111" =>
        rd_en_rise(9) <= rd_en_r6(2);

    when others =>
        rd_en_rise(9) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(9) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count2 is
    when "011" =>
        rd_en_fall(9) <= rd_en_r2(2);

    when "100" =>
        rd_en_fall(9) <= rd_en_r3(2);

    when "101" =>
        rd_en_fall(9) <= rd_en_r4(2);

    when "110" =>
        rd_en_fall(9) <= rd_en_r5(2);

    when "111" =>
        rd_en_fall(9) <= rd_en_r6(2);

    when others =>
        rd_en_fall(9) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(10) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count2 is
    when "011" =>
        rd_en_rise(10) <= rd_en_r2(2);

    when "100" =>
        rd_en_rise(10) <= rd_en_r3(2);

    when "101" =>
        rd_en_rise(10) <= rd_en_r4(2);

    when "110" =>
        rd_en_rise(10) <= rd_en_r5(2);

    when "111" =>
        rd_en_rise(10) <= rd_en_r6(2);

    when others =>
        rd_en_rise(10) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(10) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count2 is
    when "011" =>
        rd_en_fall(10) <= rd_en_r2(2);

    when "100" =>
        rd_en_fall(10) <= rd_en_r3(2);

    when "101" =>
        rd_en_fall(10) <= rd_en_r4(2);

    when "110" =>
        rd_en_fall(10) <= rd_en_r5(2);

    when "111" =>
        rd_en_fall(10) <= rd_en_r6(2);

    when others =>
        rd_en_fall(10) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(11) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count2 is
    when "011" =>
        rd_en_rise(11) <= rd_en_r2(2);

    when "100" =>
        rd_en_rise(11) <= rd_en_r3(2);

    when "101" =>
        rd_en_rise(11) <= rd_en_r4(2);

    when "110" =>
        rd_en_rise(11) <= rd_en_r5(2);

    when "111" =>
        rd_en_rise(11) <= rd_en_r6(2);

    when others =>
        rd_en_rise(11) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(11) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count2 is
    when "011" =>
        rd_en_fall(11) <= rd_en_r2(2);

    when "100" =>
        rd_en_fall(11) <= rd_en_r3(2);

    when "101" =>
        rd_en_fall(11) <= rd_en_r4(2);

    when "110" =>
        rd_en_fall(11) <= rd_en_r5(2);

    when "111" =>
        rd_en_fall(11) <= rd_en_r6(2);

    when others =>
        rd_en_fall(11) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(12) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count3 is
    when "011" =>
        rd_en_rise(12) <= rd_en_r2(3);

    when "100" =>
        rd_en_rise(12) <= rd_en_r3(3);

    when "101" =>
        rd_en_rise(12) <= rd_en_r4(3);

    when "110" =>
        rd_en_rise(12) <= rd_en_r5(3);

    when "111" =>
        rd_en_rise(12) <= rd_en_r6(3);

    when others =>
        rd_en_rise(12) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(12) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count3 is
    when "011" =>
        rd_en_fall(12) <= rd_en_r2(3);

    when "100" =>
        rd_en_fall(12) <= rd_en_r3(3);

    when "101" =>
        rd_en_fall(12) <= rd_en_r4(3);

    when "110" =>
        rd_en_fall(12) <= rd_en_r5(3);

    when "111" =>
        rd_en_fall(12) <= rd_en_r6(3);

    when others =>
        rd_en_fall(12) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(13) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count3 is
    when "011" =>
        rd_en_rise(13) <= rd_en_r2(3);

    when "100" =>
        rd_en_rise(13) <= rd_en_r3(3);

    when "101" =>
        rd_en_rise(13) <= rd_en_r4(3);

    when "110" =>
        rd_en_rise(13) <= rd_en_r5(3);

    when "111" =>
        rd_en_rise(13) <= rd_en_r6(3);

    when others =>
        rd_en_rise(13) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(13) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count3 is
    when "011" =>
        rd_en_fall(13) <= rd_en_r2(3);

    when "100" =>
        rd_en_fall(13) <= rd_en_r3(3);

    when "101" =>
        rd_en_fall(13) <= rd_en_r4(3);

    when "110" =>
        rd_en_fall(13) <= rd_en_r5(3);

    when "111" =>
        rd_en_fall(13) <= rd_en_r6(3);

    when others =>
        rd_en_fall(13) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(14) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count3 is
    when "011" =>
        rd_en_rise(14) <= rd_en_r2(3);

    when "100" =>
        rd_en_rise(14) <= rd_en_r3(3);

    when "101" =>
        rd_en_rise(14) <= rd_en_r4(3);

    when "110" =>
        rd_en_rise(14) <= rd_en_r5(3);

    when "111" =>
        rd_en_rise(14) <= rd_en_r6(3);

    when others =>
        rd_en_rise(14) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(14) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count3 is
    when "011" =>
        rd_en_fall(14) <= rd_en_r2(3);

    when "100" =>
        rd_en_fall(14) <= rd_en_r3(3);

    when "101" =>
        rd_en_fall(14) <= rd_en_r4(3);

    when "110" =>
        rd_en_fall(14) <= rd_en_r5(3);

    when "111" =>
        rd_en_fall(14) <= rd_en_r6(3);

    when others =>
        rd_en_fall(14) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(15) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count3 is
    when "011" =>
        rd_en_rise(15) <= rd_en_r2(3);

    when "100" =>
        rd_en_rise(15) <= rd_en_r3(3);

    when "101" =>
        rd_en_rise(15) <= rd_en_r4(3);

    when "110" =>
        rd_en_rise(15) <= rd_en_r5(3);

    when "111" =>
        rd_en_rise(15) <= rd_en_r6(3);

    when others =>
        rd_en_rise(15) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(15) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count3 is
    when "011" =>
        rd_en_fall(15) <= rd_en_r2(3);

    when "100" =>
        rd_en_fall(15) <= rd_en_r3(3);

    when "101" =>
        rd_en_fall(15) <= rd_en_r4(3);

    when "110" =>
        rd_en_fall(15) <= rd_en_r5(3);

    when "111" =>
        rd_en_fall(15) <= rd_en_r6(3);

    when others =>
        rd_en_fall(15) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(16) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count4 is
    when "011" =>
        rd_en_rise(16) <= rd_en_r2(4);

    when "100" =>
        rd_en_rise(16) <= rd_en_r3(4);

    when "101" =>
        rd_en_rise(16) <= rd_en_r4(4);

    when "110" =>
        rd_en_rise(16) <= rd_en_r5(4);

    when "111" =>
        rd_en_rise(16) <= rd_en_r6(4);

    when others =>
        rd_en_rise(16) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(16) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count4 is
    when "011" =>
        rd_en_fall(16) <= rd_en_r2(4);

    when "100" =>
        rd_en_fall(16) <= rd_en_r3(4);

    when "101" =>
        rd_en_fall(16) <= rd_en_r4(4);

    when "110" =>
        rd_en_fall(16) <= rd_en_r5(4);

    when "111" =>
        rd_en_fall(16) <= rd_en_r6(4);

    when others =>
        rd_en_fall(16) <= '0';
  end case;
 end if;
end if;
end process;


process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_rise(17) <= '0';
 elsif(comp_done_r2 = '1') then
  case rise_clk_count4 is
    when "011" =>
        rd_en_rise(17) <= rd_en_r2(4);

    when "100" =>
        rd_en_rise(17) <= rd_en_r3(4);

    when "101" =>
        rd_en_rise(17) <= rd_en_r4(4);

    when "110" =>
        rd_en_rise(17) <= rd_en_r5(4);

    when "111" =>
        rd_en_rise(17) <= rd_en_r6(4);

    when others =>
        rd_en_rise(17) <= '0';
  end case;
 end if;
end if;
end process;

process(CLK)
begin
if(CLK'event and CLK = '1') then
 if(rst_r = '1') then
    rd_en_fall(17) <= '0';
 elsif(comp_done_r2 = '1') then
  case fall_clk_count4 is
    when "011" =>
        rd_en_fall(17) <= rd_en_r2(4);

    when "100" =>
        rd_en_fall(17) <= rd_en_r3(4);

    when "101" =>
        rd_en_fall(17) <= rd_en_r4(4);

    when "110" =>
        rd_en_fall(17) <= rd_en_r5(4);

    when "111" =>
        rd_en_fall(17) <= rd_en_r6(4);

    when others =>
        rd_en_fall(17) <= '0';
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
          READ_DATA_RISE        => READ_DATA_RISE(3 downto 0),
          READ_DATA_FALL        => READ_DATA_FALL(3 downto 0),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(3 downto 0),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(3 downto 0),
          READ_DATA_VALID       => read_data_valid0
        );


  rd_data_fifo1: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(1),
          READ_EN_DELAYED_FALL  => rd_en_fall(1),
          FIRST_RISING          => first_rising_rden(0),
          READ_DATA_RISE        => READ_DATA_RISE(7 downto 4),
          READ_DATA_FALL        => READ_DATA_FALL(7 downto 4),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(7 downto 4),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(7 downto 4),
          READ_DATA_VALID       => read_data_valid1
        );


  rd_data_fifo2: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(2),
          READ_EN_DELAYED_FALL  => rd_en_fall(2),
          FIRST_RISING          => first_rising_rden(0),
          READ_DATA_RISE        => READ_DATA_RISE(11 downto 8),
          READ_DATA_FALL        => READ_DATA_FALL(11 downto 8),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(11 downto 8),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(11 downto 8),
          READ_DATA_VALID       => read_data_valid2
        );


  rd_data_fifo3: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(3),
          READ_EN_DELAYED_FALL  => rd_en_fall(3),
          FIRST_RISING          => first_rising_rden(0),
          READ_DATA_RISE        => READ_DATA_RISE(15 downto 12),
          READ_DATA_FALL        => READ_DATA_FALL(15 downto 12),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(15 downto 12),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(15 downto 12),
          READ_DATA_VALID       => read_data_valid3
        );


  rd_data_fifo4: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(4),
          READ_EN_DELAYED_FALL  => rd_en_fall(4),
          FIRST_RISING          => first_rising_rden(1),
          READ_DATA_RISE        => READ_DATA_RISE(19 downto 16),
          READ_DATA_FALL        => READ_DATA_FALL(19 downto 16),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(19 downto 16),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(19 downto 16),
          READ_DATA_VALID       => read_data_valid4
        );


  rd_data_fifo5: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(5),
          READ_EN_DELAYED_FALL  => rd_en_fall(5),
          FIRST_RISING          => first_rising_rden(1),
          READ_DATA_RISE        => READ_DATA_RISE(23 downto 20),
          READ_DATA_FALL        => READ_DATA_FALL(23 downto 20),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(23 downto 20),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(23 downto 20),
          READ_DATA_VALID       => read_data_valid5
        );


  rd_data_fifo6: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(6),
          READ_EN_DELAYED_FALL  => rd_en_fall(6),
          FIRST_RISING          => first_rising_rden(1),
          READ_DATA_RISE        => READ_DATA_RISE(27 downto 24),
          READ_DATA_FALL        => READ_DATA_FALL(27 downto 24),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(27 downto 24),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(27 downto 24),
          READ_DATA_VALID       => read_data_valid6
        );


  rd_data_fifo7: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(7),
          READ_EN_DELAYED_FALL  => rd_en_fall(7),
          FIRST_RISING          => first_rising_rden(1),
          READ_DATA_RISE        => READ_DATA_RISE(31 downto 28),
          READ_DATA_FALL        => READ_DATA_FALL(31 downto 28),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(31 downto 28),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(31 downto 28),
          READ_DATA_VALID       => read_data_valid7
        );


  rd_data_fifo8: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(8),
          READ_EN_DELAYED_FALL  => rd_en_fall(8),
          FIRST_RISING          => first_rising_rden(2),
          READ_DATA_RISE        => READ_DATA_RISE(35 downto 32),
          READ_DATA_FALL        => READ_DATA_FALL(35 downto 32),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(35 downto 32),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(35 downto 32),
          READ_DATA_VALID       => read_data_valid8
        );


  rd_data_fifo9: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(9),
          READ_EN_DELAYED_FALL  => rd_en_fall(9),
          FIRST_RISING          => first_rising_rden(2),
          READ_DATA_RISE        => READ_DATA_RISE(39 downto 36),
          READ_DATA_FALL        => READ_DATA_FALL(39 downto 36),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(39 downto 36),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(39 downto 36),
          READ_DATA_VALID       => read_data_valid9
        );


  rd_data_fifo10: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(10),
          READ_EN_DELAYED_FALL  => rd_en_fall(10),
          FIRST_RISING          => first_rising_rden(2),
          READ_DATA_RISE        => READ_DATA_RISE(43 downto 40),
          READ_DATA_FALL        => READ_DATA_FALL(43 downto 40),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(43 downto 40),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(43 downto 40),
          READ_DATA_VALID       => read_data_valid10
        );


  rd_data_fifo11: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(11),
          READ_EN_DELAYED_FALL  => rd_en_fall(11),
          FIRST_RISING          => first_rising_rden(2),
          READ_DATA_RISE        => READ_DATA_RISE(47 downto 44),
          READ_DATA_FALL        => READ_DATA_FALL(47 downto 44),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(47 downto 44),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(47 downto 44),
          READ_DATA_VALID       => read_data_valid11
        );


  rd_data_fifo12: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(12),
          READ_EN_DELAYED_FALL  => rd_en_fall(12),
          FIRST_RISING          => first_rising_rden(3),
          READ_DATA_RISE        => READ_DATA_RISE(51 downto 48),
          READ_DATA_FALL        => READ_DATA_FALL(51 downto 48),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(51 downto 48),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(51 downto 48),
          READ_DATA_VALID       => read_data_valid12
        );


  rd_data_fifo13: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(13),
          READ_EN_DELAYED_FALL  => rd_en_fall(13),
          FIRST_RISING          => first_rising_rden(3),
          READ_DATA_RISE        => READ_DATA_RISE(55 downto 52),
          READ_DATA_FALL        => READ_DATA_FALL(55 downto 52),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(55 downto 52),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(55 downto 52),
          READ_DATA_VALID       => read_data_valid13
        );


  rd_data_fifo14: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(14),
          READ_EN_DELAYED_FALL  => rd_en_fall(14),
          FIRST_RISING          => first_rising_rden(3),
          READ_DATA_RISE        => READ_DATA_RISE(59 downto 56),
          READ_DATA_FALL        => READ_DATA_FALL(59 downto 56),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(59 downto 56),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(59 downto 56),
          READ_DATA_VALID       => read_data_valid14
        );


  rd_data_fifo15: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(15),
          READ_EN_DELAYED_FALL  => rd_en_fall(15),
          FIRST_RISING          => first_rising_rden(3),
          READ_DATA_RISE        => READ_DATA_RISE(63 downto 60),
          READ_DATA_FALL        => READ_DATA_FALL(63 downto 60),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(63 downto 60),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(63 downto 60),
          READ_DATA_VALID       => read_data_valid15
        );


  rd_data_fifo16: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(16),
          READ_EN_DELAYED_FALL  => rd_en_fall(16),
          FIRST_RISING          => first_rising_rden(4),
          READ_DATA_RISE        => READ_DATA_RISE(67 downto 64),
          READ_DATA_FALL        => READ_DATA_FALL(67 downto 64),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(67 downto 64),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(67 downto 64),
          READ_DATA_VALID       => read_data_valid16
        );


  rd_data_fifo17: mem_interface_top_rd_data_fifo_0
    port map (
          CLK                   => CLK,
          RESET                 => RESET,
          READ_EN_DELAYED_RISE  => rd_en_rise(17),
          READ_EN_DELAYED_FALL  => rd_en_fall(17),
          FIRST_RISING          => first_rising_rden(4),
          READ_DATA_RISE        => READ_DATA_RISE(71 downto 68),
          READ_DATA_FALL        => READ_DATA_FALL(71 downto 68),
          fifo_rd_enable        => fifo_rd_enable,
          READ_DATA_FIFO_RISE   => READ_DATA_FIFO_RISE(71 downto 68),
          READ_DATA_FIFO_FALL   => READ_DATA_FIFO_FALL(71 downto 68),
          READ_DATA_VALID       => read_data_valid17
        );


end arch;
