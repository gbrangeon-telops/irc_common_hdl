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
    rd_en_rise     : out std_logic;
    rd_en_fall     : out std_logic
    );
end mem_interface_top_pattern_compare8;

architecture arch of mem_interface_top_pattern_compare8 is

  signal clk_cnt_rise    : std_logic_vector(3 downto 0);
  signal clk_cnt_fall    : std_logic_vector(3 downto 0);

  signal clk_count_rise  : std_logic_vector(3 downto 0);
  signal clk_count_fall  : std_logic_vector(3 downto 0);

  signal cntrl_rden_r    : std_logic;
  signal rd_data_rise_r  : std_logic_vector(7 downto 0);
  signal rd_data_fall_r  : std_logic_vector(7 downto 0);

  -- to fix reset sensitivity
  signal rd_data_rise_r2 : std_logic_vector(7 downto 0);
  signal rd_data_fall_r2 : std_logic_vector(7 downto 0);

  signal rd_en_r1        : std_logic;
  signal rd_en_r2        : std_logic;
  signal rd_en_r3        : std_logic;
  signal rd_en_r4        : std_logic;
  signal rd_en_r5        : std_logic;
  signal rd_en_r6        : std_logic;
  signal rd_en_r7        : std_logic;
  signal rd_en_r8        : std_logic;
  signal rd_en_r9        : std_logic;
  signal rd_en_r10       : std_logic;

  signal comp_done0      : std_logic;
  signal comp_done_r     : std_logic;

  type STATE_MACHINE1 is (rise_idle, rise_first_data,
                          rise_second_data, rise_comp_over);
  type STATE_MACHINE2 is (fall_idle, fall_first_data,
                          fall_second_data, fall_comp_over);

  signal rise_state, rise_next_state : STATE_MACHINE1;
  signal fall_state, fall_next_state : STATE_MACHINE2;

  signal rst_r1                      : std_logic;

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
--   signal rise_state_1 : std_logic;
--   signal rise_state_0 : std_logic;
--   signal fall_state_1 : std_logic;
--   signal fall_state_0 : std_logic;

begin
--  cscope: if CS=1 generate
--      i_icon : icon
--      port map (
--         control0    => control_ila
--      );
--      
--      i_ila : ila
--      port map (
--         control   => control_ila,
--         clk       => clk,
--         trig0     => data_ila
--      );
--      
--      rise_state_1 <= '1' when (rise_state = rise_second_data) or (rise_state = rise_comp_over) else '0';
--      rise_state_0 <= '1' when (rise_state = rise_first_data) or (rise_state = rise_comp_over) else '0';
--      fall_state_1 <= '1' when (fall_state = fall_second_data) or (fall_state = fall_comp_over) else '0';
--      fall_state_0 <= '1' when (fall_state = fall_first_data) or (fall_state = fall_comp_over) else '0';
--      process(rst, clk)
--      begin
--         if rst = '1' then
--            data_ila <= (others => '0');
--         elsif clk'event and clk = '1' then
--            data_ila(126)            <= rise_state_1;
--            data_ila(125)            <= rise_state_0;
--            data_ila(124)            <= fall_state_1;
--            data_ila(123)            <= fall_state_0;
--            data_ila(122)            <= ctrl_rden;
--            data_ila(121 downto 114) <= rd_data_rise;
--            data_ila(113 downto 106) <= rd_data_fall;
--            data_ila(105)            <= comp_done_r;
--            data_ila(104 downto 101) <= clk_cnt_rise;
--            data_ila(100 downto  97) <= clk_cnt_fall;
--            data_ila( 96 downto  93) <= clk_count_rise;
--            data_ila( 92 downto  89) <= clk_count_fall;
--         end if;
--      end process;
--  end generate;

  comp_done <= comp_done_r;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      rst_r1 <= rst;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        rd_en_r1  <= '0';
        rd_en_r2  <= '0';
        rd_en_r3  <= '0';
        rd_en_r4  <= '0';
        rd_en_r5  <= '0';
        rd_en_r6  <= '0';
        rd_en_r7  <= '0';
        rd_en_r8  <= '0';
        rd_en_r9  <= '0';
        rd_en_r10 <= '0';
      else
        rd_en_r1  <= ctrl_rden;
        rd_en_r2  <= rd_en_r1;
        rd_en_r3  <= rd_en_r2;
        rd_en_r4  <= rd_en_r3;
        rd_en_r5  <= rd_en_r4;
        rd_en_r6  <= rd_en_r5;
        rd_en_r7  <= rd_en_r6;
        rd_en_r8  <= rd_en_r7;
        rd_en_r9  <= rd_en_r8;
        rd_en_r10 <= rd_en_r9;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        comp_done_r <= '0';
      else
        comp_done_r <= comp_done0;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        rd_en_rise <= '0';
      elsif(comp_done_r = '1') then
        case clk_count_rise is
          when "0011" => rd_en_rise <= rd_en_r2;
          when "0100" => rd_en_rise <= rd_en_r3;
          when "0101" => rd_en_rise <= rd_en_r4;
          when "0110" => rd_en_rise <= rd_en_r5;
          when "0111" => rd_en_rise <= rd_en_r6;
          when "1000" => rd_en_rise <= rd_en_r7;
          when "1001" => rd_en_rise <= rd_en_r8;
          when others => rd_en_rise <= '0';
        end case;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        rd_en_fall <= '0';
      elsif(comp_done_r = '1') then
        case (clk_count_fall) is
          when "0011" => rd_en_fall <= rd_en_r2;
          when "0100" => rd_en_fall <= rd_en_r3;
          when "0101" => rd_en_fall <= rd_en_r4;
          when "0110" => rd_en_fall <= rd_en_r5;
          when "0111" => rd_en_fall <= rd_en_r6;
          when "1000" => rd_en_fall <= rd_en_r7;
          when "1001" => rd_en_fall <= rd_en_r8;
          when others => rd_en_fall <= '0';
        end case;
      end if;
    end if;
  end process;

  comp_done0 <= '1' when (rise_state = rise_comp_over and
                          fall_state = fall_comp_over) else '0';

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      rd_data_rise_r  <= rd_data_rise;
      rd_data_fall_r  <= rd_data_fall;
      rd_data_rise_r2 <= rd_data_rise_r;
      rd_data_fall_r2 <= rd_data_fall_r;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        cntrl_rden_r <= '0';
      else
        cntrl_rden_r <= ctrl_rden;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        first_rising <= '0';
      elsif(rise_state = rise_first_data and rd_data_rise_r = X"55") then
        first_rising <= '1';
      end if;
    end if;
  end process;

  clk_count_rise <= clk_cnt_rise when (rise_state = rise_comp_over) else "0000";

  -- rise data
  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        clk_cnt_rise <= (others => '0');
      elsif(rise_state = rise_first_data) then
        clk_cnt_rise <= clk_cnt_rise + "0001";
      else
        clk_cnt_rise <= clk_cnt_rise;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        rise_state <= rise_idle;
      else
        rise_state <= rise_next_state;
      end if;
    end if;
  end process;

  process(cntrl_rden_r, rise_state, rd_data_rise_r, rd_data_rise_r2, rst_r1)
  begin
    if (rst_r1 = '1') then
      rise_next_state <= rise_idle;
    else
      case (rise_state) is
        when rise_idle =>
          if(cntrl_rden_r = '1') then
            rise_next_state <= rise_first_data;
          else
            rise_next_state <= rise_idle;
          end if;

        when rise_first_data =>
          if((rd_data_rise_r = X"AA") or (rd_data_rise_r = X"55")) then
            rise_next_state <= rise_second_data;  -- to fix reset sensitivity
          else
            rise_next_state <= rise_first_data;
          end if;

        when rise_second_data =>
          if(((rd_data_rise_r = X"99") and (rd_data_rise_r2 = X"AA")) or
             ((rd_data_rise_r = X"66") and (rd_data_rise_r2 = X"55"))) then -- to fix reset sensitivity
            rise_next_state <= rise_comp_over;
          else
            rise_next_state <= rise_first_data;
          end if;

        when rise_comp_over =>
          rise_next_state <= rise_comp_over;

        when others =>
          rise_next_state <= rise_idle;
      end case;
    end if;
  end process;

  -- fall data
  clk_count_fall <= clk_cnt_fall when (fall_state = fall_comp_over) else "0000";

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        clk_cnt_fall <= "0000";
      elsif(fall_state = fall_first_data) then
        clk_cnt_fall <= clk_cnt_fall + "0001";
      else
        clk_cnt_fall <= clk_cnt_fall;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (rst_r1 = '1') then
        fall_state <= fall_idle;
      else
        fall_state <= fall_next_state;
      end if;
    end if;
  end process;

  process(cntrl_rden_r, fall_state, rd_data_fall_r, rd_data_fall_r2, rst_r1)
  begin
    if(rst_r1 = '1') then
      fall_next_state <= fall_idle;
    else
      case (fall_state) is

        when fall_idle =>
          if(cntrl_rden_r = '1') then
            fall_next_state <= fall_first_data;
          else
            fall_next_state <= fall_idle;
          end if;

        when fall_first_data =>
          if((rd_data_fall_r = X"55") or (rd_data_fall_r = X"AA")) then
            fall_next_state <= fall_second_data; -- to fix reset sensitivity
          else
            fall_next_state <= fall_first_data;
          end if;

        when fall_second_data =>
          if(((rd_data_fall_r = X"66") and (rd_data_fall_r2 = X"55")) or
             ((rd_data_fall_r = X"99") and (rd_data_fall_r2 = X"AA"))) then -- to fix reset sensitivity
            fall_next_state <= fall_comp_over;
          else
            fall_next_state <= fall_first_data;
          end if;

        when fall_comp_over =>
          fall_next_state <= fall_comp_over;

        when others =>
          fall_next_state <= fall_idle;

      end case;
    end if;
  end process;


end arch;
