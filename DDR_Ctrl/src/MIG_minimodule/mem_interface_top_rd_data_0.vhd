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
   generic(
   CS : integer := 0
   );
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

--   -- Chipscope
--   signal control_ila         : std_logic_vector( 35 downto 0);
--   signal data_ila            : std_logic_vector(126 downto 0);
--
--   component icon
--      port (
--         control0    : out std_logic_vector(35 downto 0)
--      );
--   end component;
--
--   component ila
--      port (
--         control     : in    std_logic_vector(35 downto 0);
--         clk         : in    std_logic;
--         trig0       : in    std_logic_vector(126 downto 0)
--      );
--   end component;

begin
--      i_icon : icon
--      port map (
--         control0    => control_ila
--      );
--      
--      i_ila : ila
--      port map (
--         control   => control_ila,
--         clk       => CLK,
--         trig0     => data_ila
--      );
--      
--      process(RESET, CLK)
--      begin
--         if RESET = '1' then
--            data_ila <= (others => '0');
--         elsif CLK'event and CLK = '1' then
--            data_ila(126)            <= ctrl_rden;
--            data_ila(125 downto 110) <= READ_DATA_RISE(15 downto 0);
--            data_ila(109 downto 108) <= read_data_valid_i;
--            data_ila(107 downto 106) <= COMP_DONE_int;
--            data_ila(105 downto 104) <= READ_EN_DELAYED_RISE;
--            data_ila(103 downto 102) <= READ_EN_DELAYED_FALL;
--            data_ila(101 downto 100) <= FIRST_RISING_int;
--            data_ila( 99)            <= fifo_read_enable_r;
--            data_ila( 98)            <= fifo_read_enable_2r;
--            data_ila( 97 downto  82) <= READ_DATA_FALL(15 downto 0);
--         end if;
--      end process;

  READ_DATA_VALID <= read_data_valid_i(0);

  COMP_DONE <=  COMP_DONE_int(0)  and  COMP_DONE_int(1);

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
  pattern_0 : mem_interface_top_pattern_compare8
   generic map(
   CS => i
   )
    port map (
      clk          => CLK,
      rst          => RESET,
      ctrl_rden    => CTRL_RDEN,
      rd_data_rise => READ_DATA_RISE(8*i+7 downto 8*i),
      rd_data_fall => READ_DATA_FALL(8*i+7 downto 8*i),
      comp_done    => COMP_DONE_int(i),
      first_rising => FIRST_RISING_int(i),
      rd_en_rise   => READ_EN_DELAYED_RISE(i),
      rd_en_fall   => READ_EN_DELAYED_FALL(i)
      );

  rd_data_fifo0 : mem_interface_top_rd_data_fifo_0
    port map (
      CLK                  => CLK,
      RESET                => RESET,
      fifo_rd_enable       => fifo_read_enable_2r,
      READ_EN_DELAYED_RISE => READ_EN_DELAYED_RISE(i),
      READ_EN_DELAYED_FALL => READ_EN_DELAYED_FALL(i),
      FIRST_RISING         => FIRST_RISING_int(i),
      READ_DATA_RISE       => READ_DATA_RISE(8*i+7 downto 8*i),
      READ_DATA_FALL       => READ_DATA_FALL(8*i+7 downto 8*i),
      READ_DATA_FIFO_RISE  => READ_DATA_FIFO_RISE(8*i+7 downto 8*i),
      READ_DATA_FIFO_FALL  => READ_DATA_FIFO_FALL(8*i+7 downto 8*i),
      READ_DATA_VALID      => read_data_valid_i(i)
      );
end generate;

end arch;
