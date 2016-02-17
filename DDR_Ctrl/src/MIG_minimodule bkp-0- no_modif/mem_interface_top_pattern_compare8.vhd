-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_pattern_compare8.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Compares the IOB output 8 bit data of one bank that is read
--              data during the intilaization to get the delay for the data
--              with respect to the command issued.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_pattern_compare8 is
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
end mem_interface_top_pattern_compare8;

architecture arch of mem_interface_top_pattern_compare8 is

  constant idle        : std_logic_vector(1 downto 0) := "00";
  constant first_data  : std_logic_vector(1 downto 0) := "01";
  constant second_data : std_logic_vector(1 downto 0) := "10";
  constant comp_over   : std_logic_vector(1 downto 0) := "11";

  signal state_rise      : std_logic_vector(1 downto 0);
  signal state_fall      : std_logic_vector(1 downto 0);
  signal next_state_rise : std_logic_vector(1 downto 0);
  signal next_state_fall : std_logic_vector(1 downto 0);
  signal rise_clk_cnt    : std_logic_vector(2 downto 0);
  signal fall_clk_cnt    : std_logic_vector(2 downto 0);
  signal ctrl_rden_r     : std_logic;
  signal pattern_rise1   : std_logic_vector(7 downto 0);
  signal pattern_fall1   : std_logic_vector(7 downto 0);
  signal pattern_rise2   : std_logic_vector(7 downto 0);
  signal pattern_fall2   : std_logic_vector(7 downto 0);
  signal rd_data_rise_r2 : std_logic_vector(7 downto 0);
  signal rd_data_fall_r2 : std_logic_vector(7 downto 0);
  signal rst_r           : std_logic;
begin

  pattern_rise1 <= X"AA";
  pattern_fall1 <= X"55";
  pattern_rise2 <= X"99";
  pattern_fall2 <= X"66";

  process(clk)
  begin
    if(clk'event and clk = '1') then
      rst_r <= rst;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(rst_r = '1') then
        state_rise <= idle;
      else
        state_rise <= next_state_rise;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(rst_r = '1') then
        state_fall <= idle;
      else
        state_fall <= next_state_fall;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(rst_r = '1') then
        ctrl_rden_r <= '0';
      else
        ctrl_rden_r <= ctrl_rden;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(rst_r = '1') then
        rise_clk_cnt <= "000";
      elsif((state_rise = first_data) or (state_rise = second_data)) then
        rise_clk_cnt <= rise_clk_cnt + '1';
      end if;
    end if;
  end process;

  rise_clk_count <= rise_clk_cnt when (state_rise = comp_over) else "000";

  comp_done <= '1' when ((state_rise = comp_over) and (state_fall = comp_over))
               else '0';

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(rst_r = '1') then
        fall_clk_cnt <= "000";
      elsif((state_fall = first_data) or (state_fall = second_data)) then
        fall_clk_cnt <= fall_clk_cnt + '1';
      end if;
    end if;
  end process;

  fall_clk_count <= fall_clk_cnt when (state_fall = comp_over) else "000";

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r = '1') then
        first_rising <= '0';
      elsif(state_rise = second_data and rd_data_rise = pattern_fall2) then
        first_rising <= '1';
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r = '1') then
        rd_data_rise_r2 <= (others => '0');
        rd_data_fall_r2 <= (others => '0');
      else
        rd_data_rise_r2 <= rd_data_rise;
        rd_data_fall_r2 <= rd_data_fall;
      end if;
    end if;
  end process;

  process(ctrl_rden_r, state_rise, rd_data_rise, rd_data_rise_r2, pattern_rise1,
          pattern_fall1, pattern_rise2, pattern_fall2, rst_r)
  begin
    if(rst_r = '1') then
      next_state_rise <= idle;
    else
      case state_rise is
        when idle =>
          if(ctrl_rden_r = '1') then
            next_state_rise <= first_data;
          else
            next_state_rise <= idle;
          end if;

        when first_data =>
          if((rd_data_rise = pattern_rise1) or (rd_data_rise = pattern_fall1)) then
            next_state_rise <= second_data;
          else
            next_state_rise <= first_data;
          end if;

        when second_data =>
          if(((rd_data_rise=pattern_rise2) and (rd_data_rise_r2=pattern_rise1)) or
             ((rd_data_rise=pattern_fall2) and (rd_data_rise_r2=pattern_fall1))) then
            next_state_rise <= comp_over;
          else
            next_state_rise <= second_data;
          end if;

        when comp_over =>
          next_state_rise <= comp_over;

        when others =>
          next_state_rise <= idle;
      end case;
    end if;
  end process;

  process(ctrl_rden_r, state_fall, rd_data_fall, rd_data_fall_r2, pattern_rise1,
          pattern_fall1, pattern_rise2, pattern_fall2, rst_r)
  begin
    if(rst_r = '1') then
      next_state_fall <= idle;
    else
      case state_fall is
        when idle =>
          if(ctrl_rden_r = '1') then
            next_state_fall <= first_data;
          else
            next_state_fall <= idle;
          end if;

        when first_data =>
          if((rd_data_fall = pattern_rise1) or (rd_data_fall = pattern_fall1)) then
            next_state_fall <= second_data;
          else
            next_state_fall <= first_data;
          end if;

        when second_data =>
          if(((rd_data_fall=pattern_rise2) and (rd_data_fall_r2=pattern_rise1)) or
             ((rd_data_fall=pattern_fall2) and (rd_data_fall_r2=pattern_fall1))) then
            next_state_fall <= comp_over;
          else
            next_state_fall <= second_data;
          end if;

        when comp_over =>
          next_state_fall <= comp_over;

        when others =>
          next_state_fall <= idle;
      end case;
    end if;
  end process;


end arch;
