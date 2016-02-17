-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_tap_ctrl.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: The tap control logic which claculates the relation between the
--              FPGA clock and the dqs from memory. It delays the dqs so as to
--              detect the edges of the dqs and then calculates the mid point
--              so that the data can be registered properly.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_tap_ctrl is
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
end mem_interface_top_tap_ctrl;

architecture arch of mem_interface_top_tap_ctrl is

  signal reset_int                : std_logic;

  signal dec_count                : std_logic_vector(5 downto 0);
  signal Current_State            : std_logic_vector(3 downto 0);
  signal Next_State               : std_logic_vector(3 downto 0);
  signal load                     : std_logic;
  signal dlyinc_global_flag_int   : std_logic;
  signal dlyce_int                : std_logic;
  signal dlyinc_int               : std_logic;
  signal dec_count_rst            : std_logic;
  signal dec_count_inc            : std_logic;
  signal done_int                 : std_logic;
  signal compare                  : std_logic;

  signal check_boundary_count     : std_logic_vector(3 downto 0) := "1010";

  signal bit_boundary_aligned     : std_logic;
  signal bit_boundary_aligned_r   : std_logic;
  signal init_tap_cnt             : std_logic_vector(5 downto 0) := "000000";
  signal tap_inc                  : std_logic_vector(1 downto 0);
  signal calib_start              : std_logic;
  signal init_tap_inc             : std_logic;
  signal tap_count                : std_logic_vector(5 downto 0);
  signal DQ_DATA_R                : std_logic;

  signal inc_flag                 : std_logic;

  constant START             : std_logic_vector(3 downto 0) := "0000";  --0
  constant BIT_BOUND_ALIGNED : std_logic_vector(3 downto 0) := "0001";  --1
  constant GLOBAL_INC1       : std_logic_vector(3 downto 0) := "0010";  --2
  constant GLOBAL_INC2       : std_logic_vector(3 downto 0) := "0011";  --3
  constant GLOBAL_INC3       : std_logic_vector(3 downto 0) := "0100";  --4
  constant GLOBAL_INC4       : std_logic_vector(3 downto 0) := "0101";  --5
  constant BIT_CALIBRATION   : std_logic_vector(3 downto 0) := "0110";  --6
  constant INC               : std_logic_vector(3 downto 0) := "0111";  --7
  constant WAIT_INC          : std_logic_vector(3 downto 0) := "1000";  --8
  constant EDGE              : std_logic_vector(3 downto 0) := "1001";  --9
  constant DEC               : std_logic_vector(3 downto 0) := "1010";  --10
  constant WAIT_DEC          : std_logic_vector(3 downto 0) := "1011";  --11
  constant DONE              : std_logic_vector(3 downto 0) := "1100";  --12
  constant DONE_WAIT1        : std_logic_vector(3 downto 0) := "1101";  --13
  constant DONE_WAIT2        : std_logic_vector(3 downto 0) := "1110";  --14
  constant INIT_IDELAY_TAPS  : std_logic_vector(3 downto 0) := "1111";  --15

  signal RESET_r1            : std_logic := '1';

  attribute max_fanout : string;
  attribute max_fanout of Current_State        : signal is "5";
  attribute max_fanout of Next_State           : signal is "5";
  attribute max_fanout of check_boundary_count : signal is "5";

begin

  process(CLK)
  begin
    if (CLK = '1' and CLK'event) then
      RESET_r1 <= RESET;
    end if;
  end process;

  reset_int          <= not(RDY_STATUS) or RESET_r1;
  DLYCE              <= dlyce_int;
  DLYINC             <= dlyinc_int;
  DLYINC_GLOBAL_FLAG <= dlyinc_global_flag_int;
  CHAN_DONE          <= done_int;

  inc_flag <= '1' when ((BIT_BOUNDARY_CHECK = '0' and
                         check_boundary_count = "1010") or
                        (check_boundary_count = "0000" and tap_inc /= "00"))
              else '0';

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if RESET_r1 = '1' then
        init_tap_cnt <= (others => '0');
      elsif (init_tap_inc = '1') then
        init_tap_cnt <= init_tap_cnt + "000001";
      else
        init_tap_cnt <= init_tap_cnt;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if RESET_r1 = '1' then
        calib_start <= '0';
      elsif (init_tap_cnt = (tby4tapvalue - "000010")) then
        calib_start <= CTRL_DUMMYREAD_START;
      else
        calib_start <= calib_start;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if (RESET_r1 = '1' or (BIT_BOUNDARY_CHECK = '0' and
                             bit_boundary_aligned = '0')) then
        check_boundary_count <= "1010";
      elsif (BIT_BOUNDARY_CHECK = '1' and calib_start = '1' and
             check_boundary_count /= "0000") then
        check_boundary_count <= check_boundary_count - "0001";
      elsif (check_boundary_count = "0000" and tap_inc /= "00") then
        check_boundary_count <= "1010";
      else
        check_boundary_count <= check_boundary_count;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if (RESET_r1 = '1' or (BIT_BOUNDARY_CHECK = '0' and
                             bit_boundary_aligned = '0')) then
        tap_inc <= "10";
      elsif (calib_start = '1' and check_boundary_count = "0000" and
             tap_inc /= "00") then
        tap_inc <= tap_inc - "01";
      else
        tap_inc <= tap_inc;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if (RESET_r1 = '1') then
        bit_boundary_aligned <= '0';
      elsif (BIT_BOUNDARY_CHECK = '1' and bit_boundary_aligned = '0' and
             check_boundary_count = "0000" and tap_inc = "00") then
        bit_boundary_aligned <= '1';
      else
        bit_boundary_aligned <= bit_boundary_aligned;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if (RESET_r1 = '1') then
        bit_boundary_aligned_r <= '0';
      else
        bit_boundary_aligned_r <= bit_boundary_aligned;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if (reset_int = '1') then
        compare <= '0';
      elsif (calib_start = '1') then
        if (bit_boundary_aligned = '1' and BIT_BOUNDARY_CHECK = '1') then
          compare <= COMPARE_BIT;
        else
          compare <= compare;
        end if;
      else
        compare <= compare;
      end if;
    end if;
  end process;

  -- Decrement Counter
  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if (reset_int = '1') then
        dec_count <= (others => '0');
      elsif (calib_start = '1') then
        if (dec_count_rst = '1') then
          dec_count <= (others => '0');
        elsif (dec_count_inc = '1') then
          dec_count <= dec_count + "000001";
        end if;
      end if;
    end if;
  end process;

  -- Current State Logic
  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if (reset_int = '1') then
        Current_State <= START;
      elsif (CTRL_DUMMYREAD_START = '1') then
        Current_State <= Next_State;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if (reset_int = '1' or dec_count_rst = '1') then
        tap_count <= (others => '0');
      elsif (dlyce_int = '1' and dlyinc_int = '1') then
        tap_count <= tap_count + "000001";
      else
        tap_count <= tap_count;
      end if;
    end if;
  end process;

  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      DQ_DATA_R <= DQ_DATA;
    end if;
  end process;

  -- Output forming logic
  process(CLK, Current_State, dlyinc_global_flag_int, dlyce_int, dlyinc_int,
          dec_count_rst, dec_count_inc, done_int, init_tap_inc)
  begin
    if(CLK'event and CLK = '1') then
      dlyinc_global_flag_int <= '0';
      dlyce_int              <= '0';
      dlyinc_int             <= '0';
      dec_count_rst          <= '0';
      dec_count_inc          <= '0';
      done_int               <= '0';
      init_tap_inc           <= '0';

      case Current_State is

        when INIT_IDELAY_TAPS =>
          init_tap_inc           <= '1';
          dlyinc_global_flag_int <= '1';
          dlyce_int              <= '1';
          dlyinc_int             <= '1';

        when BIT_CALIBRATION =>
          dec_count_rst <= '1';

        when GLOBAL_INC1 =>
          dlyinc_global_flag_int <= '1';

        when GLOBAL_INC2 =>
          dlyinc_global_flag_int <= '1';
          dlyce_int              <= '1';
          dlyinc_int             <= '1';

        when INC =>
          dlyce_int  <= '1';
          dlyinc_int <= '1';

        when DEC =>
          dlyce_int     <= '1';
          dec_count_inc <= '1';

        when DONE =>
          done_int <= '1';

        when others =>
          dlyinc_global_flag_int <= '0';
          dlyce_int              <= '0';
          dlyinc_int             <= '0';
          dec_count_rst          <= '0';
          dec_count_inc          <= '0';
          done_int               <= '0';
          init_tap_inc           <= '0';

      end case;
    end if;
  end process;

  -- Next State Logic
  process(Current_State, calib_start, bit_boundary_aligned, BIT_BOUNDARY_CHECK,
          inc_flag, DQ_DATA, DQ_DATA_R, compare, tap_count, dec_count)
  begin
    case Current_State is

      when START =>
        Next_State <= INIT_IDELAY_TAPS;

      when INIT_IDELAY_TAPS =>
        if (calib_start = '1') then
          Next_State <= BIT_BOUND_ALIGNED;
        else
          Next_State <= INIT_IDELAY_TAPS;
        end if;

      when BIT_BOUND_ALIGNED =>
        if (bit_boundary_aligned = '1' and BIT_BOUNDARY_CHECK = '1') then
          Next_State <= BIT_CALIBRATION;
        elsif (inc_flag = '1') then
          Next_State <= GLOBAL_INC1;
        else
          Next_State <= BIT_BOUND_ALIGNED;
        end if;

      when GLOBAL_INC1 =>
        Next_State <= GLOBAL_INC2;

      when GLOBAL_INC2 =>
        Next_State <= GLOBAL_INC3;

      when GLOBAL_INC3 =>
        Next_State <= GLOBAL_INC4;

      when GLOBAL_INC4 =>
        Next_State <= BIT_BOUND_ALIGNED;

      when BIT_CALIBRATION =>
        Next_State <= INC;

      when INC =>
        Next_State <= WAIT_INC;

      when WAIT_INC =>
        Next_State <= EDGE;

      when EDGE =>
        if (((DQ_DATA /= compare) or (DQ_DATA_R /= compare) ) or tap_count >= maxtapcount) then
          Next_State <= DEC;
        else
          Next_State <= INC;
        end if;

      when DEC =>
        Next_State <= WAIT_DEC;

      when WAIT_DEC =>
        if (dec_count = tby4tapvalue) then
          Next_State <= DONE;
        elsif (dec_count = ('0' & tap_count(5 downto 1))) and (tap_count >= maxtapcount) then
          Next_State <= DONE;
        else
          Next_State <= DEC;
        end if;

      when DONE =>
        Next_State <= DONE_WAIT1;

      when DONE_WAIT1 =>
        Next_State <= DONE_WAIT2;

      when DONE_WAIT2 =>
        Next_State <= BIT_CALIBRATION;

      when others =>
        Next_State <= START;

    end case;
  end process;


end arch;
