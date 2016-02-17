--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:50 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: aurora_pkg_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  AURORA
--
--  Author: Brian Woodard,
--          Xilinx - Garden Valley Design Team
--
--  Description: Aurora Package Definition
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package AURORA is

    function std_bool (EXP_IN : in boolean) return std_logic;

end;

package body AURORA is

    function std_bool (EXP_IN : in boolean) return std_logic is

    begin

        if (EXP_IN) then

            return('1');

        else

            return('0');

        end if;

    end std_bool;

end;
------------------------------------------------------------------------------
-- MGT Calibration Block v1.2.1
------------------------------------------------------------------------------
-- $Revision: 1.1.2.5 $
-- $Date: 2005/12/15 17:56:14 $
------------------------------------------------------------------------------
--
--  ***************************************************************************
--  **  Copyright(C) 2005 by Xilinx, Inc. All rights reserved.               **
--  **                                                                       **
--  **  This text contains proprietary, confidential                         **
--  **  information of Xilinx, Inc. , is distributed by                      **
--  **  under license from Xilinx, Inc., and may be used,                    **
--  **  copied and/or disclosed only pursuant to the terms                   **
--  **  of a valid license agreement with Xilinx, Inc.                       **
--  **                                                                       **
--  **  Unmodified source code is guaranteed to place and route,             **
--  **  function and run at speed according to the datasheet                 **
--  **  specification. Source code is provided "as-is", with no              **
--  **  obligation on the part of Xilinx to provide support.                 **
--  **                                                                       **
--  **  Xilinx Hotline support of source code IP shall only include          **
--  **  standard level Xilinx Hotline support, and will only address         **
--  **  issues and questions related to the standard released Netlist        **
--  **  version of the core (and thus indirectly, the original core source). **
--  **                                                                       **
--  **  The Xilinx Support Hotline does not have access to source            **
--  **  code and therefore cannot answer specific questions related          **
--  **  to source HDL. The Xilinx Support Hotline will only be able          **
--  **  to confirm the problem in the Netlist version of the core.           **
--  **                                                                       **
--  **  This copyright and support notice must be retained as part           **
--  **  of this text at all times.                                           **
--  ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename      : cal_block_v1_2_1.vhd
-- Description   : DRP Calibration Block v1.2.1
--
-- VHDL-standard : VHDL '93
------------------------------------------------------------------------------
-- Authors:   Xilinx
-- History:
--  Usha P.   08/04/2005      - Initial code based on v1.2 verilog version
--                              corresponding to XCS version 1.19
--  Usha P.   11/07/2005      - Revised code based on v1.2 verilog version
--                              corresponding to XCS version 1.25
--  ML        11/17/2005      - Revised code based on v1.2 verilog version
--                              corresponding to XCS version 1.28
--  ML        11/19/2005      - Modified the parameters to make them
--                              compatible with UCF attribute settings.
--                              Cleaned up the code.
--  ML        11/30/2005      - Removed TX_FD_RANGE and RX_FD_RANGE ports
--  CJB       12/01/2005      - Changed GT_RXRECCLK1 to GT_RXRECCLK2 and
--                              modified divider in frequency detector to a
--                              ripple counter.
--  CJB       12/06/2005      - New external version - v1.2.1
--  CJB       12/09/2005      - Added synthesis attributes on sync
--                              registers to keep as flip flops.
--
------------------------------------------------------------------------------	

------------------------------------------------------------------------------
-- Frequency Detector
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_detect is 
generic (
  C_FDW      : integer := 10
  );
port (
  FD_LOCKERR : out std_logic;
  FD_STATUS  : out std_logic_vector(2 downto 0);

  FD_MIN     : in std_logic_vector(C_FDW-1 downto 0);
  FD_RANGE   : in std_logic_vector(1 downto 0);
  FD_EN      : in std_logic;

  DCLK       : in std_logic;
  GT_CLK     : in std_logic;
  RESET      : in std_logic 
);

  attribute use_sync_reset : string;
  attribute use_sync_reset of freq_detect: entity is "yes";

  attribute use_sync_set : string;
  attribute use_sync_set of freq_detect: entity is "yes";

  attribute use_clock_enable : string;
  attribute use_clock_enable of freq_detect: entity is "yes";

  attribute use_dsp48 : string;
  attribute use_dsp48 of freq_detect: entity is "no";

end freq_detect;

architecture rtl of freq_detect is

  ----------------------------------------------------------------------------
  -- Function Declaration 
  ----------------------------------------------------------------------------
  function to_natural ( input  : std_logic )
          return natural is

  begin
    if (input = '0')  then return 0; 
    else return 1;
    end if;
  end to_natural;

  constant C_FDIVW : natural := 7; -- Width of fdiv_counter - 7 for div128

  ----------------------------------------------------------------------------
  -- Signal Declaration 
  ----------------------------------------------------------------------------
  signal fdiv_counter             : unsigned(C_FDIVW-1 downto 0)
                                    := (others=>'0');
  signal fdiv128                  : std_logic;

  signal fdiv128_sync1            : std_logic := '0';
  signal fdiv128_sync             : std_logic := '0';
  signal fdiv128_sync_dly         : std_logic := '0';

  signal fd_edge                  : std_logic := '0';
  signal fd_lock                  : std_logic := '0';

  signal fdchk_cnt_ov             : std_logic := '0';
  signal fdchk_cnt_wov            : unsigned(C_FDW downto 0) 
                                    := (others => '0');

  signal range_cnt_ov             : std_logic := '0';
  signal range_cnt_wov            : unsigned(2 downto 0)
                                    := (others => '0');

  attribute shreg_extract : string;
  attribute shreg_extract of fdiv128_sync1 : signal is "no";
  attribute shreg_extract of fdiv128_sync : signal is "no";
  attribute shreg_extract of fdiv128_sync_dly : signal is "no";

  attribute syn_srlstyle : string;
  attribute syn_srlstyle of fdiv128_sync1 : signal is "registers";
  attribute syn_srlstyle of fdiv128_sync : signal is "registers";
  attribute syn_srlstyle of fdiv128_sync_dly : signal is "registers";

begin

  ----------------------------------------------------------------------------
  -- FD_STATUS PORT
  ----------------------------------------------------------------------------
  FD_STATUS <= fdchk_cnt_ov & range_cnt_ov & fd_edge;

  ----------------------------------------------------------------------------
  -- Create div128 clock pulse based on either TX or RX GT11 clock
  ----------------------------------------------------------------------------
  process (GT_CLK)
  begin
    if (rising_edge(GT_CLK)) then
      fdiv_counter(0) <= not fdiv_counter(0);
    end if;
  end process;

  fdiv_counter_generate: for fdiv_i in 1 to (C_FDIVW-1) generate
    fdiv_counter_process : process (fdiv_counter(fdiv_i-1))
    begin
      if (rising_edge(fdiv_counter(fdiv_i-1) )) then
        fdiv_counter(fdiv_i) <= not fdiv_counter(fdiv_i);
      end if;
    end process;
  end generate;

  fdiv128 <= fdiv_counter(C_FDIVW-1);

  ----------------------------------------------------------------------------
  -- Sync fdiv128 to DCLK domain
  ----------------------------------------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      fdiv128_sync1    <= fdiv128;
      fdiv128_sync     <= fdiv128_sync1;
      fdiv128_sync_dly <= fdiv128_sync;

    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Detect rising edge of div128 clock on DCLK domain
  ----------------------------------------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
       fd_edge <= (not fdiv128_sync_dly) and fdiv128_sync;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Count edges up until FD_MIN
  ----------------------------------------------------------------------------

  fdchk_cnt_ov <= fdchk_cnt_wov(C_FDW);

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (fd_edge = '1') then
        fdchk_cnt_wov <= '0' & unsigned(FD_MIN);
      elsif (fdchk_cnt_ov = '0') then
        fdchk_cnt_wov <= fdchk_cnt_wov - 1;
      end if;
    end if;
  end process;

  range_cnt_ov <= range_cnt_wov(2);

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (fd_edge = '1') then
         range_cnt_wov <= '0' & unsigned(FD_RANGE);
      elsif (range_cnt_ov = '0') then
         range_cnt_wov <= range_cnt_wov - to_natural(fdchk_cnt_ov);
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Detect Lock: when fdchk_cnt is between (FD_MIN+2) --> (FD_RANGE+1)
  ----------------------------------------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((RESET = '1') or  (range_cnt_ov = '1')) then
        fd_lock <= '0';
      elsif (fd_edge = '1') then 
        fd_lock <= fdchk_cnt_ov and (not range_cnt_ov);
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Assert LOCK Error until fd_lock goes high
  ----------------------------------------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (RESET = '1') then
        FD_LOCKERR <= '1';
      else 
        FD_LOCKERR <= (not fd_lock) and FD_EN;
      end if;
    end if;
  end process;

end rtl;

-- ======================================================================== --



 -----------------------------------------------------------------------------
-- Timebase Module
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity timebase is  
  generic (
    C_DCLK_PERIOD_NS : integer := 20  
  );
  
  port (
    EN_500    : out std_logic;
    EN_5000   : out std_logic;
    EN_50000  : out std_logic;
    DCLK      : in  std_logic
  );
end timebase;

architecture rtl of timebase is 

  signal gsr_guard      : std_logic;

  signal srl_r          : std_logic;
  signal srl_rr         : std_logic;
  signal srl_rrr        : std_logic;
  signal srl_rrr_r      : std_logic;
  signal srl_rrrr       : std_logic;
  signal srl_rrrr_r     : std_logic;

  signal timer_en0      : std_logic;
  signal timer_en_500   : std_logic;
  signal timer_en_5000  : std_logic;
  signal timer_en_50000 : std_logic;

  constant TAP_VECTOR_SIZE : natural := 4;

  signal srl16_srl_r_tap   : unsigned(TAP_VECTOR_SIZE-1 downto 0);
  signal srl16_srl_rr_tap  : unsigned(TAP_VECTOR_SIZE-1 downto 0);

  signal srl16_srl_rr_ce      : std_logic;
  signal fds_timer_en_500_d   : std_logic;
  signal fds_timer_en_5000_d  : std_logic;
  signal fds_timer_en_50000_d : std_logic;

  ----------------------------------------------------------------------------
  -- Helper functions calculate compile time divider values and PMA Reset Time
  ----------------------------------------------------------------------------
  function getSrlTap ( dclk_period_ns : in integer;
                       tap : in integer )
                     return integer is

    variable c_divider : integer;
    variable divider_final : integer;
    variable srl_tap1 : integer;
    variable srl_tap2 : integer;

  begin
    c_divider := 500/dclk_period_ns;
    divider_final := 16*16+1;

    for i in 2 to 16 loop
      for j in 1 to 16 loop
        if ((i*j >= c_divider) and (i*j < divider_final)) then
           divider_final := i*j;
           srl_tap1 := i;
           srl_tap2 := j;
        end if;
      end loop;
    end loop;

    if (tap = 1) then return srl_tap1;
    else return  srl_tap2;
    end if;

  end function getSrlTap;

  function getPmaRstTime ( dclk_period_ns2 : in integer;
                           base_init : in integer )
                         return integer is

  variable result : integer;

  begin

    result := getSrlTap(dclk_period_ns2,1) *
              getSrlTap(dclk_period_ns2,2) *
              dclk_period_ns2;

    if (result < 500) then return base_init+1;
    else return base_init;
    end if;

  end function getPmaRstTime;

begin 

  -- Guards SRL enables during GSR Reset
  gsr_guard_r : FDR 
    port map (
      Q  => gsr_guard,
      C  => DCLK,
      D  => '1',
      R  => '0'
    );

  ----------------------------------------------------------------------------
  -- Clock Divider for Timers 
  ----------------------------------------------------------------------------
  --  The following SRL16 chain creates enable signals every 500ns, 5,000ns
  --  and 50,000ns.
  --  The tap points on the first two SRL16 blocks (srl_r and srl_rr) are 
  --  controlled by the getSrlTap function.
  --
  --  Note: there is a FF on the output, so that counts as one tap in the 
  --  srl_r shifter, which is taken into account in the getSrlTap function.
  ----------------------------------------------------------------------------
  srl16_srl_r_tap <=  to_unsigned( (getSrlTap(C_DCLK_PERIOD_NS,1)-2),
                                   TAP_VECTOR_SIZE );
  srl16_srl_rr_tap <= to_unsigned( (getSrlTap(C_DCLK_PERIOD_NS,2)-1),
                                   TAP_VECTOR_SIZE );

  ----------------------------------------------------------------------------
  -- First Stage of Time Base SRL16s
  ----------------------------------------------------------------------------
  srl16_srl_r: SRL16E
    port map (
      Q   => srl_r,
      A0  => srl16_srl_r_tap(0),
      A1  => srl16_srl_r_tap(1),
      A2  => srl16_srl_r_tap(2),
      A3  => srl16_srl_r_tap(3),
      CE  => gsr_guard,
      CLK => DCLK,
      D   => timer_en0
    );

  fds_timer_en0: FDSE
    port map (
      Q  => timer_en0,
      C  => DCLK,
      CE => gsr_guard,
      D  => srl_r,
      S  => '0'
    );

  ----------------------------------------------------------------------------
  -- Second Stage of Time Base SRL16s
  ----------------------------------------------------------------------------
  srl16_srl_rr_ce <=  timer_en0 and gsr_guard;

  srl16_srl_rr: SRL16E
    generic map (
      INIT => X"0001"
    )
    port map (
      Q   => srl_rr,
      A0  => srl16_srl_rr_tap(0),
      A1  => srl16_srl_rr_tap(1),
      A2  => srl16_srl_rr_tap(2),
      A3  => srl16_srl_rr_tap(3),
      CE  => srl16_srl_rr_ce,
      CLK => DCLK,
      D   => srl_rr
    );

  fds_timer_en_500_d <= srl_rr and timer_en0 and gsr_guard;

  fds_timer_en_500: FD
    port map (
      Q  => timer_en_500,
      C  => DCLK,
      D  => fds_timer_en_500_d
    );

  ----------------------------------------------------------------------------
  -- Third Stage of Time Base SRL16s
  ----------------------------------------------------------------------------
  srl16_srl_rrr: SRL16E
    port map (
      Q   => srl_rrr,
      A0  => '0',
      A1  => '0',
      A2  => '0',
      A3  => '1',
      CE  => timer_en_500,
      CLK => DCLK,
      D   => srl_rrr_r 
    );

  fdse_srl_rrr_r: FDSE
    port map (
      Q  => srl_rrr_r,
      C  => DCLK,
      CE => timer_en_500,
      D  => srl_rrr,
      S  => '0'
    );

  fds_timer_en_5000_d <=  srl_rrr_r and timer_en_500;

  fds_timer_en_5000: FD
    port map (
      Q  => timer_en_5000,
      C  => DCLK,
      D  => fds_timer_en_5000_d
    );

  ----------------------------------------------------------------------------
  -- Fourth Stage of Time Base SRL16s
  ----------------------------------------------------------------------------
  srl16_srl_rrrr: SRL16E
    port map (
      Q   => srl_rrrr,
      A0  => '0',
      A1  => '0',
      A2  => '0',
      A3  => '1',
      CE  => timer_en_5000,
      CLK => DCLK,
      D   => srl_rrrr_r 
    );

  fdse_srl_rrrr_r: FDSE
    port map (
      Q  => srl_rrrr_r,
      C  => DCLK,
      CE => timer_en_5000,
      D  => srl_rrrr,
      S  => '0'
    );

  fds_timer_en_50000_d <= srl_rrrr_r and timer_en_5000;
  
  fds_timer_en_50000: FD
    port map (
      Q  => timer_en_50000,
      C  => DCLK,
      D  => fds_timer_en_50000_d
    );
  
  EN_500 <= timer_en_500;
  EN_5000 <= timer_en_5000;
  EN_50000 <= timer_en_50000;
  
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity cal_block_v1_2_1 is
  generic (
    C_MGT_ID          : integer := 0;       -- 0 = MGTA | 1 = MGTB
    C_DCLK_PERIOD_NS  : integer := 10;      -- DCLK clock period in NS
    C_SIMULATION      : integer := 0;       -- Set to 1 for simulation
    C_TXOUTDIV2SEL_A  : integer := 1;       -- Default MGTA TX Div
    C_TXOUTDIV2SEL_B  : integer := 1;       -- Default MGTB TX Div
    C_RXOUTDIV2SEL_A  : integer := 1;       -- Default MGTA RX Div
    C_RXOUTDIV2SEL_B  : integer := 1;       -- Default MGTB RX Div
    C_TXPOST_TAP_PD   : string  := "TRUE";  -- Default POST TAP PD
    C_RXDIGRX         : string  := "FALSE"; -- Default RXDIGRX
    C_TX_FD_WIDTH     : integer := 8;       -- TX Fdetect MIN value width
    C_RX_FD_WIDTH     : integer := 8        -- RX Fdetect MIN value width
  );

  port (
  -- User DRP Interface (destination/slave interface)
  USER_DO             : out std_logic_vector(16-1 downto 0);
  USER_DI             : in  std_logic_vector(16-1 downto 0);
  USER_DADDR          : in  std_logic_vector(8-1 downto 0);
  USER_DEN            : in  std_logic;
  USER_DWE            : in  std_logic;
  USER_DRDY           : out std_logic;

  -- MGT DRP Interface (source/master interface)
  GT_DO               : out std_logic_vector(16-1 downto 0);
  GT_DI               : in  std_logic_vector(16-1 downto 0);
  GT_DADDR            : out std_logic_vector(8-1 downto 0);
  GT_DEN              : out std_logic;
  GT_DWE              : out std_logic;
  GT_DRDY             : in  std_logic;

  -- DRP Clock and Reset
  DCLK                : in  std_logic;
  RESET               : in  std_logic;

  -- Calibration Block Active and Disable Signals (legacy)
  ACTIVE              : out std_logic;
  DISABLE             : in  std_logic;

  -- User side MGT Pass through Signals 
  USER_RXPMARESET     : in  std_logic;
  USER_RXLOCK         : out std_logic;

  USER_TXPMARESET     : in  std_logic;
  USER_TXLOCK         : out std_logic;

  USER_LOOPBACK       : in  std_logic_vector(1 downto 0);
  USER_TXENC8B10BUSE  : in  std_logic;
  USER_TXBYPASS8B10B  : in  std_logic_vector(7 downto 0);

  -- GT side MGT Pass through Signals 
  GT_RXPMARESET       : out std_logic;
  GT_RXLOCK           : in  std_logic;

  GT_TXPMARESET       : out std_logic;
  GT_TXLOCK           : in  std_logic;

  GT_LOOPBACK         : out std_logic_vector(1 downto 0);
  GT_TXENC8B10BUSE    : out std_logic;
  GT_TXBYPASS8B10B    : out std_logic_vector(7 downto 0);

  GT_TXOUTCLK1        : in  std_logic;
  GT_RXRECCLK2        : in  std_logic;

  -- Signal Detect Ports
  TX_SIGNAL_DETECT    : in  std_logic;
  RX_SIGNAL_DETECT    : in  std_logic;

  -- Frequency Detect Ports
  TX_FD_MIN           : in  std_logic_vector(C_TX_FD_WIDTH-1 downto 0);
  TX_FD_EN            : in  std_logic;
  RX_FD_MIN           : in  std_logic_vector(C_RX_FD_WIDTH-1 downto 0);
  RX_FD_EN            : in  std_logic;

  -- FD_STATUS PORT
  FD_STATUS           : out std_logic_vector(9 downto 0)
);

  attribute use_sync_reset : string;
  attribute use_sync_reset of cal_block_v1_2_1: entity is "yes";

  attribute use_sync_set : string;
  attribute use_sync_set of cal_block_v1_2_1: entity is "yes";

  attribute use_clock_enable : string;
  attribute use_clock_enable of cal_block_v1_2_1: entity is "yes";

  attribute use_dsp48 : string;
  attribute use_dsp48 of cal_block_v1_2_1: entity is "no";

end cal_block_v1_2_1;

architecture rtl of cal_block_v1_2_1 is

  ----------------------------------------------------------------------------
  -- Component Declaration
  ----------------------------------------------------------------------------
  component freq_detect 
  generic (
    C_FDW      : integer
  );
  port (
    FD_LOCKERR : out std_logic;
    FD_STATUS  : out std_logic_vector(2 downto 0);

    FD_MIN     : in std_logic_vector(C_FDW-1 downto 0);
    FD_RANGE   : in std_logic_vector(1 downto 0);
    FD_EN      : in std_logic;

    DCLK       : in std_logic;
    GT_CLK     : in std_logic;
    RESET      : in std_logic
  );
  end component;

  component timebase 
  generic (
    C_DCLK_PERIOD_NS    :  integer 
  );
  
  port (
   EN_500   : out std_logic;
   EN_5000  : out std_logic;
   EN_50000 : out std_logic;
   DCLK     : in std_logic
  );
  end component;

  ----------------------------------------------------------------------------
  -- Function Declaration 
  ----------------------------------------------------------------------------
  function ExtendString (string_in : string;
                         string_len : integer) 
          return string is 

    variable string_out : string(1 to string_len)
                          := (others => ' '); 

  begin 
    if string_in'length > string_len then 
      string_out := string_in(1 to string_len); 
    else 
      string_out(1 to string_in'length) := string_in; 
    end if;
    return  string_out;
  end ExtendString;

  function StringToBool (S : string) return boolean is
  begin
    if (ExtendString(S,5) = "TRUE ") then
      return true;
    elsif (ExtendString(S,5) = "FALSE") then
      return false;
    else
      return false;
    end if;
  end function StringToBool;

  ----------------------------------------------------------------------------
  -- Constants
  ----------------------------------------------------------------------------
  constant C_DRP_DWIDTH : integer := 16;
  constant C_DRP_AWIDTH : integer := 8;

  ----------------------------------------------------------------------------
  -- Signals
  ----------------------------------------------------------------------------
  signal reset_r                    : std_logic_vector(1 downto 0);

  signal timer_en_500               : std_logic;
  signal timer_en_5000              : std_logic;
  signal timer_en_50000             : std_logic;

  signal user_di_r                  : std_logic_vector(C_DRP_DWIDTH-1 downto 0)
                                      := (others => '0');
  signal user_daddr_r               : std_logic_vector(C_DRP_AWIDTH-3 downto 0);
  signal user_den_r                 : std_logic;
  signal user_req                   : std_logic;
  signal user_dwe_r                 : std_logic;

  signal user_drdy_i                : std_logic;

  signal gt_drdy_r                  : std_logic := '0';
  signal gt_do_r                    : std_logic_vector(C_DRP_DWIDTH-1 downto 0) 
                                      := (others => '0'); 
  signal rxlock_r                   : std_logic;
  signal txlock_r                   : std_logic;
  signal disable_r                  : std_logic := '0';

  signal cp_drp_cache               : std_logic_vector(C_DRP_DWIDTH-1 downto 0);
  signal txoutdivsel_a_cache        : std_logic_vector(3 downto 0);
  signal txoutdivsel_b_cache        : std_logic_vector(3 downto 0); 
  signal rxoutdivsel_a_cache        : std_logic_vector(3 downto 0);
  signal rxdigrx_cache              : std_logic;
  signal txpost_tap_pd_cache        : std_logic;

  signal user_daddr_eq_drp_addr     : std_logic;
  signal gt_do_r_sel                : std_logic_vector(4 downto 0);
  signal gt_daddr_sel               : std_logic_vector(3 downto 0);

  signal sig_c_delay_lockupdate     : unsigned(6 downto 0);
  signal sig_c_delay_rxlock_min     : unsigned(2 downto 0);
  signal sig_c_delay_rst            : unsigned(4 downto 0);
  signal sig_c_delay_rx_done        : unsigned(3 downto 0);

  signal c_cp_drp_addr              : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_tx_slowloop_addr         : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_tx_vco_addr              : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_tx_diva_addr             : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_tx_divb_addr             : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_rx_slowloop_addr         : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_rx_digrx_addr            : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_rx_vco_addr              : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_rx_diva_addr             : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_rx_divb_addr             : std_logic_vector(C_DRP_AWIDTH-1 downto 0);
  signal c_tx_pt_addr               : std_logic_vector(C_DRP_AWIDTH-1 downto 0);

  signal c_txoutdiv2sel_a_bin       : std_logic_vector(3 downto 0);
  signal c_txoutdiv2sel_b_bin       : std_logic_vector(3 downto 0);
  signal c_rxoutdiv2sel_a_bin       : std_logic_vector(3 downto 0);
  signal c_rxoutdiv2sel_b_bin       : std_logic_vector(3 downto 0);
  signal c_txpost_tap_pd_bin        : std_logic;
  signal c_rxdigrx_bin              : std_logic;

  signal user_sel                   : std_logic;
  signal tx_sel                     : std_logic;
  signal rx_sel                     : std_logic;
  signal clear_rx_sel               : std_logic;
  signal sd_sel                     : std_logic;

  signal user_rxpmareset_r          : std_logic_vector(1 downto 0) := "00";
  signal rxpmareset_int             : std_logic := '0';

  signal rx_req                     : std_logic := '0';
  signal rx_read                    : std_logic := '0';
  signal rx_write                   : std_logic := '0';
  signal rx_drp_done                : std_logic := '0';
  signal rx_fd_lockerr              : std_logic;

  signal rx_fdetect_debug           : std_logic_vector(2 downto 0);

  signal rx_wait_rxlock_min_tc      : std_logic;
  signal rx_wait_rxlock_max_tc      : std_logic;
  signal rx_wait_rxlock_max_count   : unsigned(6 downto 0);
  signal rx_wait_rxlock_min_count   : unsigned(2 downto 0);
  signal rx_wait_rxpmareset_done    : std_logic;
  signal rx_wait_rxpmareset_count   : unsigned(4 downto 0);
  signal rx_done_count              : unsigned(3 downto 0);
  signal rx_done_done               : std_logic;

  signal rx_wr_wreg                 : std_logic_vector(C_DRP_DWIDTH-1 downto 0)
                                      := (others => '0');
  signal rx_rd_wreg                 : std_logic_vector(C_DRP_DWIDTH-1 downto 0)
                                      := (others => '0');
  signal rx_addr_r                  : std_logic_vector(C_DRP_AWIDTH-3 downto 0);
  signal rx_first_pass              : std_logic := '1'; 
  signal rx_force_start             : std_logic;

  signal user_txpmareset_r          : std_logic_vector(1 downto 0) := "00";
  signal txpmareset_int             : std_logic := '0';

  signal tx_req                     : std_logic := '0';
  signal tx_read                    : std_logic := '0'; 
  signal tx_write                   : std_logic := '0'; 
  signal tx_drp_done                : std_logic := '0'; 
  signal tx_fd_lockerr              : std_logic;

  signal tx_fdetect_debug           : std_logic_vector(2 downto 0);

  signal tx_wait_txlock_done        : std_logic;
  signal tx_wait_txlock_count       : unsigned(6 downto 0);
  signal tx_wait_txpmareset_done    : std_logic;
  signal tx_wait_txpmareset_count   : unsigned(4 downto 0);

  signal tx_wr_wreg                 : std_logic_vector(C_DRP_DWIDTH-1 downto 0)
                                      := (others => '0');
  signal tx_rd_wreg                 : std_logic_vector(C_DRP_DWIDTH-1 downto 0)
                                      := (others => '0');
  signal tx_addr_r                  : std_logic_vector(C_DRP_AWIDTH-3 downto 0);
  signal do_rst_vco_cyc             : std_logic := '0';

  signal sd_req                     : std_logic := '0';
  signal sd_read                    : std_logic := '0';
  signal sd_write                   : std_logic := '0';
  signal sd_drp_done                : std_logic := '0';
  signal sd_wr_wreg                 : std_logic_vector(C_DRP_DWIDTH-1 downto 0)
                                      := (others => '0');
  signal sd_rd_wreg                 : std_logic_vector(C_DRP_DWIDTH-1 downto 0)
                                      := (others => '0');
  signal sd_addr_r                  : std_logic_vector(C_DRP_AWIDTH-3 downto 0);

  signal drp_rd                     : std_logic;
  signal drp_wr                     : std_logic;
  signal stretch_drpwrite           : std_logic;

  signal tx_fdchk_cnt_ov            : std_logic;
  signal tx_range_cnt_ov            : std_logic;
  signal tx_fd_edge                 : std_logic;
  signal rx_fdchk_cnt_ov            : std_logic;
  signal rx_range_cnt_ov            : std_logic;
  signal rx_fd_edge                 : std_logic;

  signal cb_state                   : std_logic_vector(5 downto 0);
  signal cb_next_state              : std_logic_vector(5 downto 0);
  signal cb_fsm_idle_check          : std_logic_vector(3 downto 0);

  signal drp_state                  : std_logic_vector(4 downto 0);
  signal drp_next_state             : std_logic_vector(4 downto 0);

  signal tx_state                   : std_logic_vector(28 downto 0);
  signal tx_next_state              : std_logic_vector(28 downto 0);
  signal tx_fsm_tx_reset_check      : std_logic_vector(1 downto 0);
  signal tx_fsm_tx_idle_check       : std_logic_vector(3 downto 0);

  signal rx_state                   : std_logic_vector(19 downto 0);
  signal rx_next_state              : std_logic_vector(19 downto 0);
  signal rx_fsm_rx_reset_check      : std_logic_vector(1 downto 0);
  signal rx_fsm_rx_idle_comb        : std_logic;
  signal rx_fsm_rx_idle_check       : std_logic_vector(2 downto 0);
  signal rx_fsm_rx_slowloop_on_check: std_logic_vector(3 downto 0);

  signal rxrmw_state                : std_logic_vector(2 downto 0);
  signal rxrmw_next_state           : std_logic_vector(2 downto 0);

  signal sd_state                   : std_logic_vector(13 downto 0);
  signal sd_next_state              : std_logic_vector(13 downto 0);

  ----------------------------------------------------------------------------
  -- Parameters for timers
  ----------------------------------------------------------------------------
  -- Delays for hardware: these timers only applies to hardware if the
  -- parameter C_SIMULATION is set to "0"
  constant C_DELAY_LOCKUPDATE : unsigned(6 downto 0)
                              := "1111000"; -- 6ms based on 50us tick
  constant C_DELAY_RXLOCK_MIN : unsigned(2 downto 0)
                              := "101";     -- 200us-250 us based on 50us tick
  constant C_DELAY_RST        : unsigned(4 downto 0)
                              := "10001";   -- 800us-850us based on 50us tick
  constant C_DELAY_RX_DONE    : unsigned(3 downto 0)
                              := "1011";    -- 50us - 55us with 5us tick

  ----------------------------------------------------------------------------
  -- Parameters for FD_RANGE of Frequency Detector
  ----------------------------------------------------------------------------
  constant C_FD_RANGE       : std_logic_vector(1 downto 0) := "11";

  ----------------------------------------------------------------------------
  -- Charge Pump Quick OFF + Arbitration FSM
  ----------------------------------------------------------------------------
  constant C_RESET          : std_logic_vector(5 downto 0) := "000001";
  constant C_IDLE           : std_logic_vector(5 downto 0) := "000010";
  constant C_USER_DRP_OP    : std_logic_vector(5 downto 0) := "000100";
  constant C_TX_DRP_OP      : std_logic_vector(5 downto 0) := "001000";
  constant C_RX_DRP_OP      : std_logic_vector(5 downto 0) := "010000";
  constant C_SD_DRP_OP      : std_logic_vector(5 downto 0) := "100000";

  ----------------------------------------------------------------------------
  -- DRP FSM
  ----------------------------------------------------------------------------
  constant C_DRP_IDLE       : std_logic_vector(4 downto 0) := "00001";
  constant C_DRP_READ       : std_logic_vector(4 downto 0) := "00010";
  constant C_DRP_WRITE      : std_logic_vector(4 downto 0) := "00100";
  constant C_DRP_WAIT       : std_logic_vector(4 downto 0) := "01000";
  constant C_DRP_COMPLETE   : std_logic_vector(4 downto 0) := "10000";

  ----------------------------------------------------------------------------
  -- RXLOCK Calibration FSM
  ----------------------------------------------------------------------------
  constant C_RX_RESET          : std_logic_vector(19 downto 0)
                                 := "00000000000000000001";
  constant C_RX_RESET_VCO_OFF  : std_logic_vector(19 downto 0)
                                 := "00000000000000000010";
  constant C_RX_RESET_VCO_ON   : std_logic_vector(19 downto 0)
                                 := "00000000000000000100";
  constant C_RX_RESET_RECOVERY : std_logic_vector(19 downto 0)
                                 := "00000000000000001000";
  constant C_RX_IDLE           : std_logic_vector(19 downto 0)
                                 := "00000000000000010000";
  constant C_RX_SLOWLOOP_OFF   : std_logic_vector(19 downto 0)
                                 := "00000000000000100000";
  constant C_RX_CP_ON          : std_logic_vector(19 downto 0)
                                 := "00000000000001000000";
  constant C_RX_DIGRX_ON       : std_logic_vector(19 downto 0)
                                 := "00000000000010000000";
  constant C_RX_VCO_OFF1       : std_logic_vector(19 downto 0)
                                 := "00000000000100000000";
  constant C_RX_VCO_ON1        : std_logic_vector(19 downto 0)
                                 := "00000000001000000000";
  constant C_RX_WAIT_RXLOCK    : std_logic_vector(19 downto 0)
                                 := "00000000010000000000";
  constant C_RX_VCO_OFF2       : std_logic_vector(19 downto 0)
                                 := "00000000100000000000";
  constant C_RX_VCO_ON2        : std_logic_vector(19 downto 0)
                                 := "00000001000000000000";
  constant C_RX_DIVA_ON        : std_logic_vector(19 downto 0)
                                 := "00000010000000000000";
  constant C_RX_DIVB_ON        : std_logic_vector(19 downto 0)
                                 := "00000100000000000000";
  constant C_RX_DIVA_RESTORE   : std_logic_vector(19 downto 0)
                                 := "00001000000000000000";
  constant C_RX_DIVB_RESTORE   : std_logic_vector(19 downto 0)
                                 := "00010000000000000000";
  constant C_RX_SLOWLOOP_ON    : std_logic_vector(19 downto 0)
                                 := "00100000000000000000";
  constant C_RX_DIGRX_OFF      : std_logic_vector(19 downto 0)
                                 := "01000000000000000000";
  constant C_RX_DONE           : std_logic_vector(19 downto 0)
                                 := "10000000000000000000";

  -- RXLOCK FSM for DRP Read-Modify-Write
  constant C_RXRMW_RD          : std_logic_vector(2 downto 0) := "001";
  constant C_RXRMW_MD          : std_logic_vector(2 downto 0) := "010";
  constant C_RXRMW_WR          : std_logic_vector(2 downto 0) := "100";

  ----------------------------------------------------------------------------
  -- TXLOCK Calibration FSM
  ----------------------------------------------------------------------------
   constant C_TX_RESET            : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000000000001";
   constant C_TX_RESET_RECOVERY   : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000000000010";
   constant C_TX_IDLE             : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000000000100";
   constant C_TX_RD_SLOWLOOP_OFF  : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000000001000";
   constant C_TX_MD_SLOWLOOP_OFF  : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000000010000";
   constant C_TX_WR_SLOWLOOP_OFF  : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000000100000";
   constant C_TX_RD_VCO_OFF       : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000001000000";
   constant C_TX_MD_VCO_OFF       : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000010000000";
   constant C_TX_WR_VCO_OFF       : std_logic_vector(28 downto 0) 
                                    := "00000000000000000000100000000";
   constant C_TX_RD_VCO_ON        : std_logic_vector(28 downto 0) 
                                    := "00000000000000000001000000000";
   constant C_TX_MD_VCO_ON        : std_logic_vector(28 downto 0) 
                                    := "00000000000000000010000000000";
   constant C_TX_WR_VCO_ON        : std_logic_vector(28 downto 0) 
                                    := "00000000000000000100000000000";
   constant C_TX_RD_SLOWLOOP_ON   : std_logic_vector(28 downto 0) 
                                    := "00000000000000001000000000000";
   constant C_TX_MD_SLOWLOOP_ON   : std_logic_vector(28 downto 0) 
                                    := "00000000000000010000000000000";
   constant C_TX_WR_SLOWLOOP_ON   : std_logic_vector(28 downto 0) 
                                    := "00000000000000100000000000000";
   constant C_TX_RD_DIVA_ON       : std_logic_vector(28 downto 0) 
                                    := "00000000000001000000000000000";
   constant C_TX_MD_DIVA_ON       : std_logic_vector(28 downto 0) 
                                    := "00000000000010000000000000000";
   constant C_TX_WR_DIVA_ON       : std_logic_vector(28 downto 0) 
                                    := "00000000000100000000000000000";
   constant C_TX_RD_DIVB_ON       : std_logic_vector(28 downto 0) 
                                    := "00000000001000000000000000000";
   constant C_TX_MD_DIVB_ON       : std_logic_vector(28 downto 0) 
                                    := "00000000010000000000000000000";
   constant C_TX_WR_DIVB_ON       : std_logic_vector(28 downto 0) 
                                    := "00000000100000000000000000000";
   constant C_TX_RD_DIVA_RESTORE  : std_logic_vector(28 downto 0) 
                                    := "00000001000000000000000000000";
   constant C_TX_MD_DIVA_RESTORE  : std_logic_vector(28 downto 0) 
                                    := "00000010000000000000000000000";
   constant C_TX_WR_DIVA_RESTORE  : std_logic_vector(28 downto 0) 
                                    := "00000100000000000000000000000";
   constant C_TX_RD_DIVB_RESTORE  : std_logic_vector(28 downto 0) 
                                    := "00001000000000000000000000000";
   constant C_TX_MD_DIVB_RESTORE  : std_logic_vector(28 downto 0) 
                                    := "00010000000000000000000000000";
   constant C_TX_WR_DIVB_RESTORE  : std_logic_vector(28 downto 0) 
                                    := "00100000000000000000000000000";
   constant C_TX_WAIT_TXLOCK      : std_logic_vector(28 downto 0) 
                                    := "01000000000000000000000000000";
   constant C_TX_DONE             : std_logic_vector(28 downto 0) 
                                    := "10000000000000000000000000000";

  ----------------------------------------------------------------------------
  -- Signal Detect Indicator FSM
  ----------------------------------------------------------------------------
  constant C_SD_IDLE               : std_logic_vector(13 downto 0)
                                     := "00000000000001";
  constant C_SD_RD_PT_ON           : std_logic_vector(13 downto 0)
                                     := "00000000000010";
  constant C_SD_MD_PT_ON           : std_logic_vector(13 downto 0)
                                     := "00000000000100";
  constant C_SD_WR_PT_ON           : std_logic_vector(13 downto 0)
                                     := "00000000001000";
  constant C_SD_RD_RXDIGRX_ON      : std_logic_vector(13 downto 0)
                                     := "00000000010000";
  constant C_SD_MD_RXDIGRX_ON      : std_logic_vector(13 downto 0)
                                     := "00000000100000";
  constant C_SD_WR_RXDIGRX_ON      : std_logic_vector(13 downto 0)
                                     := "00000001000000";
  constant C_SD_WAIT               : std_logic_vector(13 downto 0) 
                                     := "00000010000000";
  constant C_SD_RD_RXDIGRX_RESTORE : std_logic_vector(13 downto 0)      
                                     := "00000100000000";
  constant C_SD_MD_RXDIGRX_RESTORE : std_logic_vector(13 downto 0)
                                     := "00001000000000";
  constant C_SD_WR_RXDIGRX_RESTORE : std_logic_vector(13 downto 0)
                                     := "00010000000000";
  constant C_SD_RD_PT_OFF          : std_logic_vector(13 downto 0) 
                                     := "00100000000000";
  constant C_SD_MD_PT_OFF          : std_logic_vector(13 downto 0) 
                                     := "01000000000000";
  constant C_SD_WR_PT_OFF          : std_logic_vector(13 downto 0) 
                                     := "10000000000000";

  ----------------------------------------------------------------------------
  -- Make Addresses for MGTA or MGTB at compile time
  ----------------------------------------------------------------------------
  constant C_MGTA_CP_ADDR          : std_logic_vector(7 downto 0)
                                     := "01101101";   --6Dh
  constant C_MGTA_TX_SLOWLOOP_ADDR : std_logic_vector(7 downto 0)
                                     := "01110010";   --72h
  constant C_MGTA_TX_VCO_ADDR      : std_logic_vector(7 downto 0)
                                     := "01100010";   --62h
  constant C_MGTA_TX_DIVA_ADDR     : std_logic_vector(7 downto 0)
                                     := "01111010";   --7Ah
  constant C_MGTA_TX_DIVB_ADDR     : std_logic_vector(7 downto 0)
                                     := "01101010";   --6Ah
  constant C_MGTA_RX_SLOWLOOP_ADDR : std_logic_vector(7 downto 0)
                                     := "01110101";   --75h
  constant C_MGTA_RX_DIGRX_ADDR    : std_logic_vector(7 downto 0)
                                     := "01111101";   --7Dh
  constant C_MGTA_RX_VCO_ADDR      : std_logic_vector(7 downto 0)
                                     := "01100101";   --65h
  constant C_MGTA_RX_DIVA_ADDR     : std_logic_vector(7 downto 0)
                                     := "01111101";   --7Dh
  constant C_MGTA_RX_DIVB_ADDR     : std_logic_vector(7 downto 0)
                                     := "01101101";   --6Dh
  constant C_MGTA_TX_PT_ADDR       : std_logic_vector(7 downto 0)
                                     := "01001100";   --4Ch

  constant C_MGTB_CP_ADDR          : std_logic_vector(7 downto 0)
                                     := "01001001";   --49h
  constant C_MGTB_RX_SLOWLOOP_ADDR : std_logic_vector(7 downto 0)
                                     := "01010001";   --51h
  constant C_MGTB_RX_DIGRX_ADDR    : std_logic_vector(7 downto 0)
                                     := "01011001";   --59h
  constant C_MGTB_RX_VCO_ADDR      : std_logic_vector(7 downto 0)
                                     := "01000001";   --41h
  constant C_MGTB_RX_DIVA_ADDR     : std_logic_vector(7 downto 0)
                                     := "01011001";   --59h
  constant C_MGTB_RX_DIVB_ADDR     : std_logic_vector(7 downto 0)
                                     := "01001001";   --49h
  constant C_MGTB_TX_PT_ADDR       : std_logic_vector(7 downto 0)
                                     := "01001110";   --4Eh

begin

  for_simulation: if (C_SIMULATION /= 0 ) generate
  begin
    sig_c_delay_lockupdate <= "0000001";
    sig_c_delay_rxlock_min <= "001";
    sig_c_delay_rst        <= "00001";
    sig_c_delay_rx_done    <= "0100";
  end generate for_simulation;

  for_hardware:  if (C_SIMULATION = 0 ) generate
  begin
    sig_c_delay_lockupdate <= C_DELAY_LOCKUPDATE;
    sig_c_delay_rxlock_min <= C_DELAY_RXLOCK_MIN;
    sig_c_delay_rst <= C_DELAY_RST;
    sig_c_delay_rx_done <= C_DELAY_RX_DONE;
  end generate for_hardware;

  use_mgt_b : if (C_MGT_ID /= 0) generate
  begin
    c_cp_drp_addr      <= C_MGTB_CP_ADDR;
    c_rx_slowloop_addr <= C_MGTB_RX_SLOWLOOP_ADDR;
    c_rx_digrx_addr    <= C_MGTB_RX_DIGRX_ADDR;
    c_rx_vco_addr      <= C_MGTB_RX_VCO_ADDR;
    c_rx_diva_addr     <= C_MGTB_RX_DIVA_ADDR;
    c_rx_divb_addr     <= C_MGTB_RX_DIVB_ADDR;
    c_tx_pt_addr       <= C_MGTB_TX_PT_ADDR;
  end generate use_mgt_b;

  use_mgt_a : if (C_MGT_ID = 0) generate
  begin
    c_cp_drp_addr      <= C_MGTA_CP_ADDR;
    c_tx_slowloop_addr <= C_MGTA_TX_SLOWLOOP_ADDR;
    c_tx_vco_addr      <= C_MGTA_TX_VCO_ADDR;
    c_tx_diva_addr     <= C_MGTA_TX_DIVA_ADDR;
    c_tx_divb_addr     <= C_MGTA_TX_DIVB_ADDR;
    c_rx_slowloop_addr <= C_MGTA_RX_SLOWLOOP_ADDR;
    c_rx_digrx_addr    <= C_MGTA_RX_DIGRX_ADDR;
    c_rx_vco_addr      <= C_MGTA_RX_VCO_ADDR;
    c_rx_diva_addr     <= C_MGTA_RX_DIVA_ADDR;
    c_rx_divb_addr     <= C_MGTA_RX_DIVB_ADDR;
    c_tx_pt_addr       <= C_MGTA_TX_PT_ADDR;
  end generate use_mgt_a;

  ----------------------------------------------------------------------------
  -- FD_STATUS PORT: status ports from the TX and RX Frequency Detectors
  ----------------------------------------------------------------------------
  FD_STATUS <= -- tx signals 
               txlock_r &          -- 9
               tx_fd_lockerr &     -- 8
               tx_fdchk_cnt_ov &   -- 7
               tx_range_cnt_ov &   -- 6
               tx_fd_edge &        -- 5
               -- rx signals
               rxlock_r &          -- 4
               rx_fd_lockerr &     -- 3
               rx_fdchk_cnt_ov &   -- 2
               rx_range_cnt_ov &   -- 1
               rx_fd_edge;         -- 0

  ----------------------------------------------------------------------------
  -- Sync Reset
  ----------------------------------------------------------------------------
  process (DCLK, RESET)
  begin
    if (RESET = '1') then
      reset_r <= "11";
    elsif (rising_edge(DCLK)) then
      reset_r <= '0' & reset_r(1);
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Time base for Timers: based on the DRP clock
  ----------------------------------------------------------------------------
  timebase_0 : timebase
  generic map (
    C_DCLK_PERIOD_NS => C_DCLK_PERIOD_NS
  )
  port map (
    EN_500   => timer_en_500,
    EN_5000  => timer_en_5000,
    EN_50000 => timer_en_50000,
    DCLK     => DCLK
  );

  ----------------------------------------------------------------------------
  -- Convert C_TXOUTDIV2SEL_A from decimal value (UCF attribute setting) to
  -- binary value for the DRP entry
  ----------------------------------------------------------------------------
  txoutdiv2sel_a_1 : if (C_TXOUTDIV2SEL_A = 1) generate
  begin
    c_txoutdiv2sel_a_bin <= "0001";
  end generate;

  txoutdiv2sel_a_2 : if (C_TXOUTDIV2SEL_A = 2) generate
  begin
    c_txoutdiv2sel_a_bin <= "0010";
  end generate;

  txoutdiv2sel_a_4 : if (C_TXOUTDIV2SEL_A = 4) generate
  begin
    c_txoutdiv2sel_a_bin <= "0011";
  end generate;

  txoutdiv2sel_a_8 : if (C_TXOUTDIV2SEL_A = 8) generate
  begin
    c_txoutdiv2sel_a_bin <= "0100";
  end generate;

  txoutdiv2sel_a_16 : if (C_TXOUTDIV2SEL_A = 16) generate
  begin
    c_txoutdiv2sel_a_bin <= "0101";
  end generate;

  txoutdiv2sel_a_32 : if (C_TXOUTDIV2SEL_A = 32) generate
  begin
    c_txoutdiv2sel_a_bin <= "0110";
  end generate;

  ----------------------------------------------------------------------------
  -- Convert C_TXOUTDIV2SEL_B from decimal value (UCF attribute setting) to
  -- binary value for the DRP entry
  ----------------------------------------------------------------------------
  txoutdiv2sel_b_1 : if (C_TXOUTDIV2SEL_B = 1) generate
  begin
    c_txoutdiv2sel_b_bin <= "0001";
  end generate;

  txoutdiv2sel_b_2 : if (C_TXOUTDIV2SEL_B = 2) generate
  begin
    c_txoutdiv2sel_b_bin <= "0010";
  end generate;

  txoutdiv2sel_b_4 : if (C_TXOUTDIV2SEL_B = 4) generate
  begin
    c_txoutdiv2sel_b_bin <= "0011";
  end generate;

  txoutdiv2sel_b_8 : if (C_TXOUTDIV2SEL_B = 8) generate
  begin
    c_txoutdiv2sel_b_bin <= "0100";
  end generate;

  txoutdiv2sel_b_16 : if (C_TXOUTDIV2SEL_B = 16) generate
  begin
    c_txoutdiv2sel_b_bin <= "0101";
  end generate;

  txoutdiv2sel_b_32 : if (C_TXOUTDIV2SEL_B = 32) generate
  begin
    c_txoutdiv2sel_b_bin <= "0110";
  end generate;

  ----------------------------------------------------------------------------
  -- Convert C_RXOUTDIV2SEL_A from decimal value (UCF attribute setting) to
  -- binary value for the DRP entry
  ----------------------------------------------------------------------------
  rxoutdiv2sel_a_1 : if (C_RXOUTDIV2SEL_A = 1) generate
  begin
    c_rxoutdiv2sel_a_bin <= "0001";
  end generate;

  rxoutdiv2sel_a_2 : if (C_RXOUTDIV2SEL_A = 2) generate
  begin
    c_rxoutdiv2sel_a_bin <= "0010";
  end generate;

  rxoutdiv2sel_a_4 : if (C_RXOUTDIV2SEL_A = 4) generate
  begin
    c_rxoutdiv2sel_a_bin <= "0011";
  end generate;

  rxoutdiv2sel_a_8 : if (C_RXOUTDIV2SEL_A = 8) generate
  begin
    c_rxoutdiv2sel_a_bin <= "0100";
  end generate;

  rxoutdiv2sel_a_16 : if (C_RXOUTDIV2SEL_A = 16) generate
  begin
    c_rxoutdiv2sel_a_bin <= "0101";
  end generate;

  rxoutdiv2sel_a_32 : if (C_RXOUTDIV2SEL_A = 32) generate
  begin
    c_rxoutdiv2sel_a_bin <= "0110";
  end generate;

  ----------------------------------------------------------------------------
  -- Convert C_RXOUTDIV2SEL_B from decimal value (UCF attribute setting) to
  -- binary value for the DRP entry
  ----------------------------------------------------------------------------
  rxoutdiv2sel_b_1 : if (C_RXOUTDIV2SEL_B = 1) generate
  begin
    c_rxoutdiv2sel_b_bin <= "0001";
  end generate;

  rxoutdiv2sel_b_2 : if (C_RXOUTDIV2SEL_B = 2) generate
  begin
    c_rxoutdiv2sel_b_bin <= "0010";
  end generate;

  rxoutdiv2sel_b_4 : if (C_RXOUTDIV2SEL_B = 4) generate
  begin
    c_rxoutdiv2sel_b_bin <= "0011";
  end generate;

  rxoutdiv2sel_b_8 : if (C_RXOUTDIV2SEL_B = 8) generate
  begin
    c_rxoutdiv2sel_b_bin <= "0100";
  end generate;

  rxoutdiv2sel_b_16 : if (C_RXOUTDIV2SEL_B = 16) generate
  begin
    c_rxoutdiv2sel_b_bin <= "0101";
  end generate;

  rxoutdiv2sel_b_32 : if (C_RXOUTDIV2SEL_B = 32) generate
  begin
    c_rxoutdiv2sel_b_bin <= "0110";
  end generate;

  ----------------------------------------------------------------------------
  -- Convert C_TXPOST_TAP_PD from ASCII text "TRUE"/"FALSE" to binary value
  ----------------------------------------------------------------------------
  use_txpost_tap_pd_true : if (StringToBool(C_TXPOST_TAP_PD)=true) generate
  begin
    c_txpost_tap_pd_bin <= '1';
  end generate;

  use_txpost_tap_pd_false : if (StringToBool(C_TXPOST_TAP_PD)=false) generate
  begin
    c_txpost_tap_pd_bin <= '0';
  end generate;

  ----------------------------------------------------------------------------
  -- Convert C_RXDIGRX from ASCII text "TRUE"/"FALSE" to binary value
  ----------------------------------------------------------------------------
  use_rxdigrx_true : if (StringToBool(C_RXDIGRX)=true) generate
  begin
    c_rxdigrx_bin <= '1';
  end generate;

  use_rxdigrx_false : if (StringToBool(C_RXDIGRX)=false) generate
  begin
    c_rxdigrx_bin <= '0';
  end generate;

  ----------------------------------------------------------------------------
  -- User DRP Transaction Capture Input Registers
  ----------------------------------------------------------------------------
  -- User Data Input
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (USER_DEN = '1') then
        user_di_r <= USER_DI;
      end if;
    end if;
  end process;

  -- User DRP Address
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (USER_DEN = '1') then
        user_daddr_r <= USER_DADDR(C_DRP_AWIDTH-3 downto 0);
      end if;
    end if;
  end process;

  -- User Data Write Enable
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (reset_r(0) = '1') then
        user_dwe_r <= '0';
      elsif (USER_DEN = '1') then
        user_dwe_r <= USER_DWE;
      end if;
    end if;
  end process;

  -- Register the user_den_r when the user is granted access from the
  -- Arbitration FSM
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ( (reset_r(0) = '1') or 
           (cb_state = C_USER_DRP_OP) or
           ((USER_DADDR(7) = '1') or (USER_DADDR(6) = '0')) ) then
        user_den_r <= '0';
      elsif (user_den_r = '0') then
        user_den_r <= USER_DEN;
      end if;
    end if;
  end process;

  -- Generate the user request (user_req) signal when the user is not
  -- accessing the same DRP addresses as the Calibration Block or when the
  -- Calibration  Block is in idle, reset, or wait states.
  --
  -- The TXLOCK state machine is not used when C_MGT_ID is "1" (Calibration
  -- Block connected to a B MGT).
  --
  -- NOTE: rx_diva_addr is the same as rx_digrx_addr
  -- NOTE: rx_divb_addr is the same as cp_addr
  use_user_req_a: if (C_MGT_ID = 0) generate 
  begin
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if ((reset_r(0) = '1')  or (cb_state = C_USER_DRP_OP)) then

          user_req <= '0';

        elsif (
          (not(user_daddr_r(5 downto 0)=c_cp_drp_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_tx_slowloop_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_tx_vco_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_tx_diva_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_tx_divb_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_rx_slowloop_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_rx_digrx_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_rx_vco_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_tx_pt_addr(5 downto 0)))
          ) then

          user_req <= user_den_r;

        elsif ( ( (rx_state = C_RX_IDLE) or
                  (rx_state = C_RX_RESET) or
                  (rx_state = C_RX_RESET_RECOVERY) or
                  (rx_state = C_RX_DONE) )
                and 
                ( (tx_state = C_TX_IDLE) or
                  (tx_state = C_TX_RESET) or
                  (tx_state = C_TX_RESET_RECOVERY) or
                  (tx_state = C_TX_WAIT_TXLOCK) or
                  (tx_state = C_TX_DONE) )
                and 
                ( (sd_state = C_SD_IDLE) or
                  (sd_state = C_SD_WAIT) ) ) then

          user_req <= user_den_r;

        end if;
      end if;
    end process;
  end generate use_user_req_a;

  use_user_req_b: if (C_MGT_ID /= 0) generate
  begin
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if ((reset_r(0) = '1') or (cb_state = C_USER_DRP_OP)) then
  
          user_req <= '0';

        elsif (
          (not(user_daddr_r(5 downto 0)=c_cp_drp_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_rx_slowloop_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_rx_digrx_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_rx_vco_addr(5 downto 0))) and
          (not(user_daddr_r(5 downto 0)=c_tx_pt_addr(5 downto 0)))
          ) then

          user_req <= user_den_r;

        elsif ( ( (rx_state = C_RX_IDLE) or
                  (rx_state = C_RX_RESET) or
                  (rx_state = C_RX_RESET_RECOVERY) or
                  (rx_state = C_RX_DONE) )
                and 
                ( (sd_state = C_SD_IDLE) or
                  (sd_state = C_SD_WAIT) ) ) then

          user_req <= user_den_r;

        end if;
      end if;
    end process;
  end generate use_user_req_b;

  -- User Data Output
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((cb_state = C_USER_DRP_OP) and (GT_DRDY = '1')) then
          USER_DO <= GT_DI;
        end if;
    end if;
  end process;

  -- User Data Ready
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((reset_r(0) = '1') or (user_drdy_i = '1')) then
        user_drdy_i <= '0' ;
      elsif (cb_state = C_USER_DRP_OP) then
        user_drdy_i <= GT_DRDY;
      end if;
    end if;
  end process;

  USER_DRDY <= user_drdy_i;

  -- Active signal to indicate a Calibration Block operation
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (cb_state = C_RESET) then
        ACTIVE <= '0';
      else
        if ( (not (cb_state = C_IDLE)) and 
             (not (cb_state = C_USER_DRP_OP)) ) then
           ACTIVE <= '1';
        else
           ACTIVE <= '0';
        end if;
      end if;
    end if;
  end process;

  use_txoutdivsel_cache: if (C_MGT_ID = 0) generate
  begin

    -- Storing the value of TXOUTDIV2SEL_A and TXOUTDIV2SEL_B.  The value is
    -- written from the default parameter upon reset or when the user writes
    -- to DRP register in those bits location.
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then

        if (reset_r(0) = '1') then
          txoutdivsel_a_cache <= c_txoutdiv2sel_a_bin;
        elsif ( (drp_state = C_DRP_WRITE) and
                (cb_state = C_USER_DRP_OP) and
                (user_daddr_r(5 downto 0) = c_tx_diva_addr(5 downto 0)) ) then
          txoutdivsel_a_cache <= user_di_r(15 downto 12);
        end if;

      end if;
    end process;


    process (DCLK)
    begin
      if (rising_edge(DCLK)) then

        if (reset_r(0) = '1') then
          txoutdivsel_b_cache <= c_txoutdiv2sel_b_bin;
        elsif ( (drp_state = C_DRP_WRITE) and
                (cb_state = C_USER_DRP_OP) and
                (user_daddr_r(5 downto 0) = c_tx_divb_addr(5 downto 0)) ) then
          txoutdivsel_b_cache <= user_di_r(14 downto 11);
        end if;

      end if;
    end process;

  end generate use_txoutdivsel_cache; 

  -- Storing the value of RXOUTDIV2SEL_A.  The value is written from the
  -- default parameter upon reset or when the user writes to DRP register in
  -- those bits location.
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (reset_r(0) = '1') then
        rxoutdivsel_a_cache <= c_rxoutdiv2sel_a_bin;
      elsif ( (drp_state = C_DRP_WRITE) and
              (cb_state = C_USER_DRP_OP) and
              (user_daddr_r(5 downto 0) = c_rx_diva_addr(5 downto 0)) ) then
        rxoutdivsel_a_cache <= user_di_r(15 downto 12);
      end if;

    end if;
  end process;

  -- Storing the value of RXDIGRX.  The value is written from the
  -- default parameter upon reset or when the user writes to DRP register in
  -- those bits location.
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (reset_r(0) = '1') then
        rxdigrx_cache <= c_rxdigrx_bin; 
      elsif ( (drp_state = C_DRP_WRITE) and
              (cb_state = C_USER_DRP_OP) and
              (user_daddr_r(5 downto 0) = c_rx_digrx_addr(5 downto 0)) ) then
        rxdigrx_cache <= user_di_r(1);
      end if;
    end if;
  end process;

  -- Storing the value of TXPOST_TAP_PD.  The value is written from the
  -- default parameter upon reset or when the user writes to DRP register in
  -- those bits location.
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (reset_r(0) = '1') then
        txpost_tap_pd_cache <= c_txpost_tap_pd_bin;
      elsif ( (drp_state = C_DRP_WRITE) and
              (cb_state = C_USER_DRP_OP) and
              (user_daddr_r(5 downto 0) = c_tx_pt_addr(5 downto 0)) ) then
        txpost_tap_pd_cache <= user_di_r(12);
      end if;
    end if;
  end process;

  -- Storing the value of RXOUTDIV2SEL_B and Charge Pump bit.  The value is
  -- written from the default parameter, or when the user writes to the DRP
  -- register in those bits location, or when the RXLOCK FSM is in the Charge
  -- Pump ON state, or when we quickly turn off the Charge Pump bit.
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (reset_r(0) = '1') then
        cp_drp_cache <= '0' & c_rxoutdiv2sel_b_bin & "00000000000";

      elsif ((rx_state = C_RX_CP_ON) and (GT_DRDY = '1') and
             (rxrmw_state = C_RXRMW_RD) and (cb_state = C_RX_DRP_OP)) then
        cp_drp_cache <= GT_DI(15) & cp_drp_cache(14 downto 11) &
                        GT_DI(10 downto 0);

      elsif ( (drp_state = C_DRP_WRITE) and 
              (cb_state = C_USER_DRP_OP) and 
              (user_daddr_r(5 downto 0) = c_cp_drp_addr(5 downto 0)) ) then
        cp_drp_cache(15 downto 1) <= user_di_r(15 downto 1);

      elsif (clear_rx_sel = '1') then 
        cp_drp_cache(0) <= '1';

      elsif (rx_state = C_RX_CP_ON) then
        cp_drp_cache(0) <= '0';

      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- GT DRP Interface
  ----------------------------------------------------------------------------
  -- GT Data Output: the data output is generated either from a Signal Detect
  -- FSM operation, a RXLOCK FSM operation, a TXLOCK FSM operation, a user
  -- access, or the internal cache of charge pump register.
  user_daddr_eq_drp_addr <= '1' when (user_daddr_r(5 downto 0) =
                                      c_cp_drp_addr(5 downto 0))
                            else '0';

  gt_do_r_sel <= sd_sel & rx_sel & tx_sel & user_sel & user_daddr_eq_drp_addr;

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (gt_do_r_sel(4 downto 1) = "0000") then
          gt_do_r <= cp_drp_cache(15 downto 1) & '1';
      elsif (gt_do_r_sel(4) = '1') then
          gt_do_r <= sd_wr_wreg;
      elsif (gt_do_r_sel(3) = '1') then
          gt_do_r <= rx_wr_wreg;
      elsif (gt_do_r_sel(2) = '1') then
          gt_do_r <= tx_wr_wreg;
      elsif (gt_do_r_sel = "00010") then
          gt_do_r <= user_di_r;
      elsif (gt_do_r_sel = "00011") then
          gt_do_r <= user_di_r(15 downto 1) & cp_drp_cache(0);
      else 
          null;
      end if;

    end if;
  end process;

  GT_DO <= gt_do_r;

  -- GT DRP Address: the DRP address is generated either from a Signal Detect
  -- FSM operation, a RXLOCK FSM operation, a TXLOCK FSM operation, or a user
  -- access  DRP address ranges from 0x40 to 0x7F.
  gt_daddr_sel <= sd_sel & rx_sel & tx_sel & user_sel;

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

        if (gt_daddr_sel = "0000") then
          GT_DADDR(5 downto 0) <= c_cp_drp_addr(5 downto 0);
        elsif (gt_daddr_sel(3) = '1') then
          GT_DADDR(5 downto 0) <= sd_addr_r(5 downto 0);
        elsif (gt_daddr_sel(2) = '1') then
          GT_DADDR(5 downto 0) <= rx_addr_r(5 downto 0);
        elsif ((gt_daddr_sel(2) = '0') and (gt_daddr_sel(1) = '1')) then
          GT_DADDR(5 downto 0) <= tx_addr_r(5 downto 0);
        elsif (gt_daddr_sel = "0001") then
          GT_DADDR(5 downto 0)<=user_daddr_r(5 downto 0);
        else 
          null;
        end if;

      GT_DADDR(7 downto 6) <= "01";

    end if;
  end process;

  -- Signals used by the RXLOCK FSM to quickly turn off the Charge Pump bit
  -- after the last state
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ( (reset_r(0) = '1') or 
           ((drp_state = C_DRP_WRITE) and (rx_state = C_RX_DIGRX_OFF)) ) then
         stretch_drpwrite <= '0';
      elsif ( (rx_state = C_RX_DIGRX_OFF) and
              (rxrmw_state = C_RXRMW_WR) and
              (drp_state = C_DRP_IDLE) ) then
         stretch_drpwrite <= '1';
      end if;
    end if;
  end process;

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((reset_r(0) = '1') or (clear_rx_sel = '1')) then
        clear_rx_sel <= '0';
      elsif ( (stretch_drpwrite = '1') and 
              (drp_state = C_DRP_IDLE) and
              (drp_wr = '1') ) then 
        clear_rx_sel <= '1';
      end if;
    end if;
  end process;

  -- GT Data Enable: the data enable is generated whenever there is a DRP
  -- Read, a DRP Write, and a Charge Pump quick turn off operations
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (reset_r(0) = '1') then
        GT_DEN <= '0';
      else
        if ( ( (drp_state = C_DRP_IDLE) and 
               ((drp_wr = '1') or (drp_rd = '1')) ) or
             ((stretch_drpwrite = '1') and (drp_wr = '1')) ) then
           GT_DEN <= '1';
        else
           GT_DEN <= '0';
        end if;
      end if;
    end if;
  end process;

  -- GT Data Write Enable
  GT_DWE <= '1' when (drp_state = C_DRP_WRITE) else '0';

  -- GT Data Ready
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      gt_drdy_r <= GT_DRDY;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Calibration Block Internal Logic:  The different select signals are
  -- generated for a user operation, an access to the TXLOCK FSM, an access to
  -- the RXLOCK FSM, and access to the Signal Detect FSM.
  ----------------------------------------------------------------------------
  user_sel <= '1' when (cb_state = C_USER_DRP_OP) else '0';

  tx_sel   <= '1' when (cb_state = C_TX_DRP_OP) else '0';

  rx_sel   <= '1' when ((cb_state = C_RX_DRP_OP) and (clear_rx_sel = '0'))
               else '0';

  sd_sel   <= '1' when (cb_state = C_SD_DRP_OP) else '0';

  -- RXLOCK
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      rxlock_r <= GT_RXLOCK;
    end if;
  end process;

  -- TXLOCK
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      txlock_r <= GT_TXLOCK;
    end if;
  end process;

  -- Calibration Block Disable
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (rx_drp_done = '1') then
        disable_r <= '0';
      elsif ( (rx_state = C_RX_IDLE) and
              (DISABLE = '1') and 
              (cp_drp_cache(0) = '1') ) then
        disable_r <= '1';
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Calibration Block (CB) FSM
  ----------------------------------------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
       if (reset_r(0) = '1') then 
          cb_state <= C_RESET;
       else 
          cb_state <= cb_next_state;
       end if;
    end if;
  end process;

  cb_fsm_idle_check <= sd_req & rx_req & tx_req & user_req;

  process (cb_state, cb_fsm_idle_check, gt_drdy_r)
    variable cb_fsm_name : string(1 to 25);
  begin
    case cb_state is

      when C_RESET =>

        cb_next_state <= C_IDLE;
        cb_fsm_name := ExtendString("C_RESET", 25);

      when C_IDLE =>

        if (cb_fsm_idle_check(3) = '1') then 
          cb_next_state <= C_SD_DRP_OP;
        elsif (cb_fsm_idle_check(3 downto 2) = "01") then
          cb_next_state <= C_RX_DRP_OP;
        elsif (cb_fsm_idle_check(3 downto 1) = "001") then
          cb_next_state <= C_TX_DRP_OP;
        elsif (cb_fsm_idle_check = "0001") then 
          cb_next_state <= C_USER_DRP_OP;
        else
          cb_next_state <= C_IDLE;
        end if;

        cb_fsm_name :=  ExtendString("C_IDLE", 25);

      when C_USER_DRP_OP =>

        if (gt_drdy_r = '1') then
          cb_next_state <= C_IDLE;
        else
          cb_next_state <= C_USER_DRP_OP;
        end if;

        cb_fsm_name :=  ExtendString("C_USER_DRP_OP", 25);

      when C_RX_DRP_OP =>

        if (gt_drdy_r = '1') then
          cb_next_state <= C_IDLE;
        else
          cb_next_state <= C_RX_DRP_OP;
        end if;

        cb_fsm_name :=  ExtendString("C_RX_DRP_OP", 25);

      when C_TX_DRP_OP =>

        if (gt_drdy_r = '1') then
          cb_next_state <= C_IDLE;
        else
          cb_next_state <= C_TX_DRP_OP;
        end if;

        cb_fsm_name :=  ExtendString("C_TX_DRP_OP", 25);

      when C_SD_DRP_OP =>

        if (gt_drdy_r = '1') then
          cb_next_state <= C_IDLE;
        else
          cb_next_state <= C_SD_DRP_OP;
        end if;

        cb_fsm_name :=  ExtendString("C_SD_DRP_OP", 25);

      when others =>

        cb_next_state <= C_IDLE;
        cb_fsm_name :=  ExtendString("default", 25);

    end case;
  end process;

  ----------------------------------------------------------------------------
  -- RXLOCK Calibration Block Internal Logic
  ----------------------------------------------------------------------------

  -- Sync USER_RXPMARESET to DCLK domain -------------------------------------
  process (DCLK, USER_RXPMARESET)
  begin
    if (USER_RXPMARESET = '1') then
      user_rxpmareset_r <= "11";
    elsif (rising_edge(DCLK)) then
      if (rx_state = C_RX_RESET) then 
        user_rxpmareset_r <= '0' & user_rxpmareset_r(1);
      end if;
    end if;
  end process;

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      rxpmareset_int <= user_rxpmareset_r(0);
    end if;
  end process;

  -- Hold USER_RXLOCK low until auto calibration completes -------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (not(rx_state = C_RX_IDLE)) then
        USER_RXLOCK <= '0';
      else
        USER_RXLOCK <= rxlock_r and (not rx_fd_lockerr) and
                       (not rx_force_start);
      end if;
    end if;
  end process;

  -- RXLOCK Calibration Request for DRP operation ---------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((rx_state = C_RX_RESET) or (rx_drp_done = '1')) then
         rx_req <= '0';
      else
         rx_req <= rx_read or rx_write;
      end if;
    end if;
  end process;

  -- Indicates RXLOCK Calibration DRP Read -----------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if ((rx_state = C_RX_RESET) or (rx_drp_done = '1')) then
          rx_read <= '0';
      else
        if ( (rxrmw_state = C_RXRMW_RD) and
             ( (rx_state = C_RX_RESET_VCO_OFF) or
               (rx_state = C_RX_RESET_VCO_ON) or
               (rx_state = C_RX_SLOWLOOP_OFF) or
               (rx_state = C_RX_CP_ON) or
               (rx_state = C_RX_DIGRX_ON) or
               (rx_state = C_RX_VCO_OFF1) or
               (rx_state = C_RX_VCO_ON1) or
               (rx_state = C_RX_VCO_OFF2) or
               (rx_state = C_RX_VCO_ON2) or
               (rx_state = C_RX_DIVA_ON) or
               (rx_state = C_RX_DIVB_ON) or
               (rx_state = C_RX_DIVA_RESTORE) or
               (rx_state = C_RX_DIVB_RESTORE) or
               (rx_state = C_RX_SLOWLOOP_ON) or
               (rx_state = C_RX_DIGRX_OFF) ) ) then
          rx_read <= '1';
        else
          rx_read <= '0';
        end if;

      end if;
    end if;
  end process;

  -- Indicates RXLOCK Calibration DRP Write ----------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if ((rx_state = C_RX_RESET) or (rx_drp_done = '1')) then
          rx_write <= '0';
      else
        if ( (rxrmw_state = C_RXRMW_WR) and  
             ( (rx_state = C_RX_RESET_VCO_OFF) or 
               (rx_state = C_RX_RESET_VCO_ON) or
               (rx_state = C_RX_SLOWLOOP_OFF) or
               (rx_state = C_RX_CP_ON) or
               (rx_state = C_RX_DIGRX_ON) or
               (rx_state = C_RX_VCO_OFF1) or
               (rx_state = C_RX_VCO_ON1) or
               (rx_state = C_RX_VCO_OFF2) or
               (rx_state = C_RX_VCO_ON2) or
               (rx_state = C_RX_DIVA_ON) or
               (rx_state = C_RX_DIVB_ON) or
               (rx_state = C_RX_DIVA_RESTORE) or
               (rx_state = C_RX_DIVB_RESTORE) or
               (rx_state = C_RX_SLOWLOOP_ON) or
               (rx_state = C_RX_DIGRX_OFF) ) ) then
          rx_write <= '1';
        else
          rx_write <= '0';
        end if;

      end if;
    end if;
  end process;

  -- RXLOCK Calibration DRP Read Working Register ----------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
       if ((cb_state = C_RX_DRP_OP) and 
           (rx_read = '1') and 
           (GT_DRDY = '1')) then 
          rx_rd_wreg <= GT_DI;
       end if;
    end if;
  end process;

  -- RXLOCK Calibration DRP Write Working Register --------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (rxrmw_state = C_RXRMW_MD) then

        case rx_state is

          when  C_RX_SLOWLOOP_OFF =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 3) &
                          '0' & rx_rd_wreg(1 downto 0);

          when C_RX_CP_ON =>
            rx_wr_wreg <= cp_drp_cache(15 downto 1) & '0';

          when C_RX_DIGRX_ON =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 2) & '1' & rx_rd_wreg(0);

          when C_RX_RESET_VCO_OFF =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 13) &
                          '1' & rx_rd_wreg(11) &
                          "11" & rx_rd_wreg(8 downto 0);

          when C_RX_RESET_VCO_ON =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 13) & '0' &
                          rx_rd_wreg(11) & "00" & rx_rd_wreg(8 downto 0);

          when C_RX_VCO_OFF1 =>
             rx_wr_wreg <= rx_rd_wreg(15 downto 13) &
                          '1' & rx_rd_wreg(11) &
                          "11" & rx_rd_wreg(8 downto 0);

          when  C_RX_VCO_ON1 =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 13) &
                          '0' & rx_rd_wreg(11) &
                          "00" & rx_rd_wreg(8 downto 0);

          when  C_RX_VCO_OFF2 =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 11) &
                          '1' & rx_rd_wreg(9 downto 0);

          when  C_RX_VCO_ON2 =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 11) &
                          '0' & rx_rd_wreg(9 downto 0);

          when C_RX_DIVA_ON =>
            rx_wr_wreg <= "0001" & rx_rd_wreg(11 downto 0);

          when C_RX_DIVB_ON =>
            rx_wr_wreg <= cp_drp_cache(15) &
                          "0001" & cp_drp_cache(10 downto 0);

          when C_RX_DIVA_RESTORE =>
            rx_wr_wreg <= rxoutdivsel_a_cache & rx_rd_wreg(11 downto 0);

          when C_RX_DIVB_RESTORE =>
            rx_wr_wreg <= cp_drp_cache;

          when C_RX_SLOWLOOP_ON =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 3) &
                          '1' & rx_rd_wreg(1 downto 0);

          when  C_RX_DIGRX_OFF =>
            rx_wr_wreg <= rx_rd_wreg(15 downto 2) & '0' & rx_rd_wreg(0);

          when others =>
            null;

        end case;
      end if;
    end if;
  end process;

  -- RXLOCK: Generate DRP Addresses ------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      case rx_state is
        when C_RX_SLOWLOOP_OFF =>
          rx_addr_r(5 downto 0) <= c_rx_slowloop_addr(5 downto 0);

        when C_RX_CP_ON =>
          rx_addr_r(5 downto 0) <= c_cp_drp_addr(5 downto 0);

        when C_RX_DIGRX_ON =>
          rx_addr_r(5 downto 0) <= c_rx_digrx_addr(5 downto 0);
  
        when C_RX_RESET_VCO_OFF =>
          rx_addr_r(5 downto 0) <= c_rx_vco_addr(5 downto 0);

        when C_RX_RESET_VCO_ON =>
          rx_addr_r(5 downto 0) <= c_rx_vco_addr(5 downto 0);

        when C_RX_VCO_OFF1 =>
          rx_addr_r(5 downto 0) <= c_rx_vco_addr(5 downto 0);

        when C_RX_VCO_ON1 =>
          rx_addr_r(5 downto 0) <= c_rx_vco_addr(5 downto 0);

        when C_RX_VCO_OFF2 =>
          rx_addr_r(5 downto 0) <= c_rx_vco_addr(5 downto 0);

        when C_RX_VCO_ON2 =>
          rx_addr_r(5 downto 0) <= c_rx_vco_addr(5 downto 0);
  
        when C_RX_DIVA_ON =>
          rx_addr_r(5 downto 0) <= c_rx_diva_addr(5 downto 0);

        when C_RX_DIVB_ON =>
          rx_addr_r(5 downto 0) <= c_rx_divb_addr(5 downto 0);

        when C_RX_DIVA_RESTORE =>
          rx_addr_r(5 downto 0) <= c_rx_diva_addr(5 downto 0);

        when C_RX_DIVB_RESTORE =>
          rx_addr_r(5 downto 0) <= c_rx_divb_addr(5 downto 0);

        when C_RX_SLOWLOOP_ON  =>
          rx_addr_r(5 downto 0) <= c_rx_slowloop_addr(5 downto 0);

        when C_RX_DIGRX_OFF =>
          rx_addr_r(5 downto 0) <= c_rx_digrx_addr(5 downto 0);

        when others =>
          null;

      end case;
    end if;
  end process;

  -- Assert when RX DRP Operation is Complete --------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if ( (GT_DRDY = '1') and 
           (cb_state = C_RX_DRP_OP) and 
           (rxrmw_state = C_RXRMW_WR) ) then 
        rx_drp_done <= '1';
      else
        rx_drp_done <= '0';
      end if;

    end if;
  end process;

  -- Counter for delaying RXLOCK for 6ms -------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (not(rx_state = C_RX_WAIT_RXLOCK)) then 
        rx_wait_rxlock_max_count <= sig_c_delay_lockupdate;
      elsif (timer_en_50000 = '1') then
        rx_wait_rxlock_max_count <= rx_wait_rxlock_max_count - 1;
      end if;

    end if;
  end process;


  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if ( not(rx_state = C_RX_WAIT_RXLOCK)) then 
        rx_wait_rxlock_max_tc <= '0';
      elsif ((timer_en_50000 = '1') or (rxpmareset_int = '1')) then 
         if ((rx_wait_rxlock_max_count = 1) or (rxpmareset_int = '1')) then
           rx_wait_rxlock_max_tc  <= '1';
         else
           rx_wait_rxlock_max_tc  <= '0';
         end if;
      end if;

    end if;
  end process;

  -- Counter for min wait time in RX_WAIT_RXLOCK for 200us-250us --------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (not(rx_state = C_RX_WAIT_RXLOCK)) then 
        rx_wait_rxlock_min_count <= sig_c_delay_rxlock_min;
      elsif (timer_en_50000 = '1' and rx_wait_rxlock_min_count /= 1) then
        rx_wait_rxlock_min_count <= rx_wait_rxlock_min_count - 1;
      end if;

    end if;
  end process;


  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if ( not(rx_state = C_RX_WAIT_RXLOCK)) then
        rx_wait_rxlock_min_tc <= '0';
      elsif ((timer_en_50000 = '1') or (rxpmareset_int = '1')) then 
         if ((rx_wait_rxlock_min_count = 1) or 
             (rxpmareset_int = '1')) then
           rx_wait_rxlock_min_tc  <= '1';
         else
           rx_wait_rxlock_min_tc  <= '0';
         end if;
      end if;

    end if;
  end process;

  -- Counter for RXPMARESET recovery time for 800us-850us --------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (not(rx_state = C_RX_RESET_RECOVERY)) then 
         rx_wait_rxpmareset_count <= sig_c_delay_rst; 
      elsif (timer_en_50000 = '1') then
         rx_wait_rxpmareset_count <= rx_wait_rxpmareset_count - 1;
      end if;

    end if;
  end process;

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (not(rx_state = C_RX_RESET_RECOVERY)) then
        rx_wait_rxpmareset_done <= '0';
      elsif (timer_en_50000 = '1') then
        if (rx_wait_rxpmareset_count = 1) then
          rx_wait_rxpmareset_done <= '1';
        else
          rx_wait_rxpmareset_done <= '0';
        end if;
      end if;

    end if;
  end process;

  -- Counter for done wait time for 50us-55us --------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (not (rx_state = C_RX_DONE)) then 
        rx_done_count <= sig_c_delay_rx_done;
      elsif (timer_en_5000 = '1') then 
        rx_done_count <= rx_done_count - 1;
      end if;

    end if;
  end process;

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (not(rx_state = C_RX_DONE)) then 
        rx_done_done <= '0';
      elsif (timer_en_5000 = '1') then 
        if (rx_done_count = 1) then 
          rx_done_done <= '1';
        else
          rx_done_done <= '0';
        end if;
      end if;

    end if;
  end process;

  -- Pass through USER_RXPMARESET to GT_RXPMARESET ---------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (reset_r(0) = '1') then 
        GT_RXPMARESET <= '0';
      elsif ( (rx_state = C_RX_RESET) or 
              (rx_state = C_RX_RESET_VCO_OFF) or 
              (rx_state = C_RX_RESET_VCO_ON) ) then 
        GT_RXPMARESET <= '1';
      else
        GT_RXPMARESET <= rxpmareset_int;
      end if;

    end if;
  end process;

  -- Flag to force the RX state machine after USER_RXPMARESET ----------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (reset_r(0) = '1' or rxpmareset_int = '1') then
        rx_force_start <= '1';
      elsif (rx_state = C_RX_SLOWLOOP_OFF) then
        rx_force_start <= '0';
      end if;

    end if;
  end process;

  -- Flag to indicate first pass of post wait-lock sequence ------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (rx_state = C_RX_IDLE) then 
         rx_first_pass <= '1';
      elsif ((rx_state = C_RX_SLOWLOOP_ON) and (rx_drp_done = '1')) then
         rx_first_pass <= '0';
      end if;

    end if;
  end process;

  -- RX Freq Detect ----------------------------------------------------------
  rx_fdchk_cnt_ov <= rx_fdetect_debug(2);
  rx_range_cnt_ov <= rx_fdetect_debug(1);
  rx_fd_edge      <= rx_fdetect_debug(0);
 
  rx_fdetect : freq_detect 
  generic map (
    C_FDW      => C_RX_FD_WIDTH
  )
  port map (
    FD_LOCKERR => rx_fd_lockerr,
    FD_STATUS  => rx_fdetect_debug,
    FD_MIN     => RX_FD_MIN,
    FD_RANGE   => C_FD_RANGE,
    FD_EN      => RX_FD_EN,
    DCLK       => DCLK,
    GT_CLK     => GT_RXRECCLK2,
    RESET      => reset_r(0)
  );

  ----------------------------------------------------------------------------
  -- RXLOCK Read-Modify-Write FSM
  ----------------------------------------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (reset_r(0) = '1') then 
        rxrmw_state <= C_RXRMW_RD;
      else
        rxrmw_state <= rxrmw_next_state;
      end if;

    end if;
  end process;

  process(rxrmw_state, disable_r, gt_drdy_r, cb_state, rx_state)
    variable rxrmw_fsm_name : string(1 to 25);
  begin
    case rxrmw_state is

      when C_RXRMW_RD =>
         if ( (disable_r = '1')  or 
              ((gt_drdy_r  = '1' ) and (cb_state = C_RX_DRP_OP)) ) then 

            rxrmw_next_state <= C_RXRMW_MD ;
         else 
            rxrmw_next_state <= C_RXRMW_RD;
         end if;

         rxrmw_fsm_name :=  ExtendString("C_RXRMW_RD", 25);

      when C_RXRMW_MD =>
        rxrmw_next_state <= C_RXRMW_WR;
        rxrmw_fsm_name :=  ExtendString("C_RXRMW_MD", 25);

      when C_RXRMW_WR => 
         if ((gt_drdy_r = '1') and (cb_state = C_RX_DRP_OP)) then 
            rxrmw_next_state <= C_RXRMW_RD; 
         else
            rxrmw_next_state <= C_RXRMW_WR;
         end if;

        rxrmw_fsm_name :=  ExtendString("C_RXRMW_WR", 25);

      when others =>

        rxrmw_next_state <= C_RXRMW_RD;
        rxrmw_fsm_name :=  ExtendString("default", 25);

    end case;
  end process;

  ----------------------------------------------------------------------------
  -- RXLOCK Calibration Block FSM
  ----------------------------------------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then

      if (reset_r(0) = '1') then 
        rx_state <= C_RX_IDLE;
      else
        rx_state <= rx_next_state;
      end if;

    end if;
  end process;

  rx_fsm_rx_reset_check <= rxpmareset_int & DISABLE;

  rx_fsm_rx_idle_comb <= (not rxlock_r) or rx_fd_lockerr or rx_force_start;

  rx_fsm_rx_idle_check <=  DISABLE & cp_drp_cache(0) & rx_fsm_rx_idle_comb;

  rx_fsm_rx_slowloop_on_check <= rx_drp_done & rx_first_pass & rxdigrx_cache &
                                 RX_SIGNAL_DETECT;

  process ( rx_state, rx_fsm_rx_reset_check, rx_drp_done,
            rxpmareset_int, rx_wait_rxpmareset_done, rx_fsm_rx_idle_check,
            disable_r, rxlock_r, rx_wait_rxlock_min_tc, rx_wait_rxlock_max_tc, 
            rx_fsm_rx_slowloop_on_check, rx_done_done )

    variable rx_fsm_name : string(1 to 25);

  begin

    case rx_state is

      when C_RX_RESET =>

        case rx_fsm_rx_reset_check is

          when "00" =>
             rx_next_state <= C_RX_RESET_VCO_OFF;
          when "01" =>
              rx_next_state <= C_RX_RESET_RECOVERY;
          when others =>
              rx_next_state <= C_RX_RESET;
        end case;

        rx_fsm_name :=  ExtendString("C_RX_RESET", 25);

      when C_RX_RESET_VCO_OFF =>

        if (rx_drp_done = '1') then 
           rx_next_state <= C_RX_RESET_VCO_ON;
        else
           rx_next_state <= C_RX_RESET_VCO_OFF;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_RESET_VCO_OFF", 25);

      when C_RX_RESET_VCO_ON =>

        if (rx_drp_done = '1') then 
          rx_next_state <= C_RX_RESET_RECOVERY;
        else
          rx_next_state <= C_RX_RESET_VCO_ON;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_RESET_VCO_ON",25);

      when C_RX_RESET_RECOVERY =>

        if (rxpmareset_int = '1') then
           rx_next_state <= C_RX_RESET;
        elsif (rx_wait_rxpmareset_done = '1') then
           rx_next_state <= C_RX_IDLE;
        else
           rx_next_state <= C_RX_RESET_RECOVERY;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_RESET_RECOVERY", 25);

      when C_RX_IDLE =>
        if (rxpmareset_int = '1') then
          rx_next_state <= C_RX_RESET;
        else 
        case rx_fsm_rx_idle_check is
          when "000" =>
             rx_next_state <= C_RX_IDLE;
          when "001" =>
              rx_next_state <= C_RX_SLOWLOOP_OFF;
          when "010" =>
             rx_next_state <= C_RX_IDLE;
          when "011" =>
              rx_next_state <= C_RX_SLOWLOOP_OFF;
          when "100" =>
             rx_next_state <= C_RX_IDLE;
          when "101" =>
              rx_next_state <= C_RX_IDLE;
          when "110" =>
             rx_next_state <= C_RX_CP_ON;
          when "111" =>
              rx_next_state <= C_RX_CP_ON;
          when others =>
              rx_next_state <= C_RX_IDLE;
        end case;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_IDLE", 25);

      when C_RX_SLOWLOOP_OFF =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_CP_ON;
        else
          rx_next_state <= C_RX_SLOWLOOP_OFF;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_SLOWLOOP_OFF", 25);

      when C_RX_CP_ON =>

        if (rx_drp_done = '1') then
          if (disable_r = '1') then
            rx_next_state <= C_RX_IDLE;
          else
            rx_next_state <= C_RX_DIGRX_ON;
          end if; 
        else
          rx_next_state <= C_RX_CP_ON;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_CP_ON", 25);

      when  C_RX_DIGRX_ON =>

        if (rx_drp_done = '1') then 
          rx_next_state <= C_RX_VCO_OFF1;
        else
          rx_next_state <= C_RX_DIGRX_ON;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_DIGRX_ON", 25);

      when C_RX_VCO_OFF1 =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_VCO_ON1;
        else
          rx_next_state <= C_RX_VCO_OFF1;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_VCO_OFF1", 25);

      when C_RX_VCO_ON1 =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_WAIT_RXLOCK;
        else
          rx_next_state <= C_RX_VCO_ON1;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_VCO_ON1", 25);

      when C_RX_WAIT_RXLOCK =>

        if ( ((rxlock_r = '1') and (rx_wait_rxlock_min_tc = '1')) or
             (rx_wait_rxlock_max_tc = '1') ) then
          rx_next_state <= C_RX_VCO_OFF2;
        else
          rx_next_state <= C_RX_WAIT_RXLOCK;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_WAIT_RXLOCK", 25);

      when C_RX_VCO_OFF2 =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_VCO_ON2;
        else
          rx_next_state <= C_RX_VCO_OFF2;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_VCO_OFF2", 25);

      when C_RX_VCO_ON2 =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_DIVA_ON;
        else
          rx_next_state <= C_RX_VCO_ON2;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_VCO_ON2", 25);

      when C_RX_DIVA_ON =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_DIVB_ON;
        else
          rx_next_state <= C_RX_DIVA_ON;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_DIVA_ON", 25);

      when C_RX_DIVB_ON =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_DIVA_RESTORE;
        else
          rx_next_state <= C_RX_DIVB_ON;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_DIVB_ON", 25);

      when C_RX_DIVA_RESTORE =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_DIVB_RESTORE;
        else
          rx_next_state <= C_RX_DIVA_RESTORE;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_DIVA_RESTORE", 25);

      when C_RX_DIVB_RESTORE =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_SLOWLOOP_ON;
        else
          rx_next_state <= C_RX_DIVB_RESTORE;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_DIVB_RESTORE", 25);

      -- If RX Signal Detect is Low, bypass the C_RX_DIGRX_OFF state to
      -- maintain the RX Digital CDR on
      when C_RX_SLOWLOOP_ON =>

        if (rx_fsm_rx_slowloop_on_check(3 downto 2) = "11") then
           rx_next_state <= C_RX_WAIT_RXLOCK;
        elsif (rx_fsm_rx_slowloop_on_check = "1000") then
           rx_next_state <= C_RX_DONE;
        elsif (rx_fsm_rx_slowloop_on_check = "1001") then
           rx_next_state <= C_RX_DIGRX_OFF;
        elsif (rx_fsm_rx_slowloop_on_check(3 downto 1) = "101") then
           rx_next_state <= C_RX_DONE;
        else
           rx_next_state <= C_RX_SLOWLOOP_ON;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_SLOWLOOP_ON", 25);

      when C_RX_DIGRX_OFF =>

        if (rx_drp_done = '1') then
          rx_next_state <= C_RX_DONE;
        else
          rx_next_state <= C_RX_DIGRX_OFF;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_DIGRX_OFF", 25);

      when C_RX_DONE =>

        if (rxpmareset_int = '1') then
          rx_next_state <= C_RX_RESET;
        else
          if (rx_done_done = '1') then
            rx_next_state <= C_RX_IDLE;
          else
            rx_next_state <= C_RX_DONE;
          end if;
        end if;

        rx_fsm_name :=  ExtendString("C_RX_DONE", 25);

      when others =>
        rx_next_state <= C_RX_RESET;
        rx_fsm_name :=  ExtendString("default", 25);

    end case;
  end process;

  ----------------------------------------------------------------------------
  -- TXLOCK Calibration Internal Logic - Only used when MGTA is selected
  ----------------------------------------------------------------------------

  use_txlock_cal: if (C_MGT_ID = 0) generate

    -- Sync USER_TXPMARESET to DCLK domain -----------------------------------
    process (USER_TXPMARESET, DCLK)
    begin

      if (USER_TXPMARESET = '1') then
        user_txpmareset_r <= "11";
      elsif (rising_edge(DCLK)) then

        if (tx_state = C_TX_RESET) then
          user_txpmareset_r <= '0' & user_txpmareset_r(1);
        end if;

      end if;
    end process;

    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        txpmareset_int <= user_txpmareset_r(0);
      end if;
    end process;

    -- Hold USER_TXLOCK low until TXLOCK Calibration Block is done -----------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if ( not (tx_state = C_TX_IDLE)) then
          USER_TXLOCK <= '0';
        else
          USER_TXLOCK <= GT_TXLOCK;
        end if;
      end if;
    end process;
    
    -- TXLOCK Calibration Request for DRP operation --------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if ((tx_state = C_TX_RESET) or (tx_drp_done = '1')) then
          tx_req <= '0';
        else
          tx_req <= tx_read or tx_write;
        end if;
      end if;
    end process;

    -- Indicates TXLOCK Calibration DRP Read ---------------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then

        if ((tx_state = C_TX_RESET) or (tx_drp_done = '1')) then
          tx_read <= '0';
        else
          if ((tx_state = C_TX_RD_SLOWLOOP_OFF) or
              (tx_state = C_TX_RD_VCO_OFF) or
              (tx_state = C_TX_RD_VCO_ON) or
              (tx_state = C_TX_RD_SLOWLOOP_ON) or
              (tx_state = C_TX_RD_DIVA_ON) or
              (tx_state = C_TX_RD_DIVB_ON) or
              (tx_state = C_TX_RD_DIVA_RESTORE) or
              (tx_state = C_TX_RD_DIVB_RESTORE)) then
            tx_read <= '1';
          else
            tx_read <= '0';
          end if;
        end if;

      end if;
    end process;

    -- Indicates TXLOCK Calibration DRP Write --------------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then

        if ((tx_state = C_TX_RESET) or (tx_drp_done = '1')) then
            tx_write <= '0';
        else
          if ((tx_state = C_TX_WR_SLOWLOOP_OFF) or
              (tx_state = C_TX_WR_VCO_OFF) or
              (tx_state = C_TX_WR_VCO_ON) or
              (tx_state = C_TX_WR_SLOWLOOP_ON) or
              (tx_state = C_TX_WR_DIVA_ON) or
              (tx_state = C_TX_WR_DIVB_ON) or
              (tx_state = C_TX_WR_DIVA_RESTORE) or
              (tx_state = C_TX_WR_DIVB_RESTORE)) then
            tx_write <= '1';
          else
            tx_write <= '0';
          end if;
        end if;

      end if;
    end process;

    -- TXLOCK Calibration DRP Read Working Register --------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if ((cb_state = C_TX_DRP_OP) and
            (tx_read = '1') and
            (GT_DRDY = '1')) then
          tx_rd_wreg <= GT_DI;
        end if;
      end if;
    end process;

    -- TXLOCK Calibration DRP Write Working Register --------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then

        case tx_state is
          when C_TX_MD_SLOWLOOP_OFF =>
            tx_wr_wreg <= tx_rd_wreg(15 downto 3) & '0' &
                          tx_rd_wreg(1 downto 0);
          when C_TX_MD_VCO_OFF =>
            tx_wr_wreg <= tx_rd_wreg(15 downto 13) & '1' &
                          tx_rd_wreg(11) & "11" & tx_rd_wreg(8 downto 0);

          when C_TX_MD_VCO_ON =>
            tx_wr_wreg <= tx_rd_wreg(15 downto 13) & '0' &
                          tx_rd_wreg(11) & "00" & tx_rd_wreg(8 downto 0);

          when C_TX_MD_SLOWLOOP_ON =>
            tx_wr_wreg <= tx_rd_wreg(15 downto 3) & '1' &
                          tx_rd_wreg(1 downto 0);

          when C_TX_MD_DIVA_ON =>
            tx_wr_wreg <= "0001" & tx_rd_wreg(11 downto 0);

          when C_TX_MD_DIVB_ON =>
            tx_wr_wreg <= tx_rd_wreg(15) & "0001" &
                          tx_rd_wreg(10 downto 0);

          when C_TX_MD_DIVA_RESTORE =>
            tx_wr_wreg <= txoutdivsel_a_cache & tx_rd_wreg(11 downto 0);

          when C_TX_MD_DIVB_RESTORE =>
            tx_wr_wreg <= tx_rd_wreg(15) & txoutdivsel_b_cache &
                          tx_rd_wreg(10 downto 0);

          when others =>
            null; 

        end case;

      end if;
    end process;

    -- TXLOCK: Generate DRP Addresses ----------------------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if (tx_state = C_TX_RESET) then
          tx_addr_r(5 downto 0) <= c_tx_vco_addr(5 downto 0);

        elsif (tx_state = C_TX_IDLE) then
          tx_addr_r(5 downto 0) <= c_tx_slowloop_addr(5 downto 0);

        elsif (tx_drp_done = '1') then

          case tx_state is

            when C_TX_WR_SLOWLOOP_OFF =>
              tx_addr_r(5 downto 0) <= c_tx_vco_addr(5 downto 0);
            when C_TX_WR_VCO_OFF =>
              tx_addr_r(5 downto 0) <= c_tx_vco_addr(5 downto 0);
            when C_TX_WR_VCO_ON =>
              tx_addr_r(5 downto 0) <= c_tx_slowloop_addr(5 downto 0);
            when C_TX_WR_SLOWLOOP_ON =>
              tx_addr_r(5 downto 0) <= c_tx_diva_addr(5 downto 0);
            when C_TX_WR_DIVA_ON =>
              tx_addr_r(5 downto 0) <= c_tx_divb_addr(5 downto 0);
            when C_TX_WR_DIVB_ON =>
              tx_addr_r(5 downto 0) <= c_tx_diva_addr(5 downto 0);
            when C_TX_WR_DIVA_RESTORE =>
              tx_addr_r(5 downto 0) <= c_tx_divb_addr(5 downto 0);
            when C_TX_WR_DIVB_RESTORE =>
              tx_addr_r(5 downto 0) <= c_tx_slowloop_addr(5 downto 0);
            when others =>
              null;

          end case;

        end if;
      end if;
    end process;

    -- Assert when TX DRP Operation is Complete ------------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if ((GT_DRDY = '1') and (cb_state = C_TX_DRP_OP)) then
          tx_drp_done <= '1';
        else
          tx_drp_done <= '0';
        end if;
      end if;
    end process;


    -- Counter waits 6ms for TXLOCK ------------------------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if ( not (tx_state = C_TX_WAIT_TXLOCK)) then 
          tx_wait_txlock_count <= sig_c_delay_lockupdate;
        elsif (timer_en_50000 = '1') then 
          tx_wait_txlock_count <= tx_wait_txlock_count - 1;
        end if;
      end if;
    end process;

    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if ( not (tx_state = C_TX_WAIT_TXLOCK)) then
          tx_wait_txlock_done <= '0';
        elsif ((timer_en_50000 = '1') or (txpmareset_int = '1')) then

          if ((tx_wait_txlock_count = 1) or 
              (txpmareset_int = '1')) then 
            tx_wait_txlock_done  <= '1';
          else
            tx_wait_txlock_done  <= '0';
          end if;

        end if;
      end if;
    end process;

    -- Counter for TXPMARESET recovery time for 800us-850us ------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then

        if (not (tx_state = C_TX_RESET_RECOVERY)) then
          tx_wait_txpmareset_count <= sig_c_delay_rst;
        elsif (timer_en_50000 = '1') then
          tx_wait_txpmareset_count <= tx_wait_txpmareset_count - 1;
        end if;

      end if;
    end process;

    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if (not(tx_state = C_TX_RESET_RECOVERY)) then
          tx_wait_txpmareset_done <= '0';
        elsif (timer_en_50000 = '1') then
          if (tx_wait_txpmareset_count = 1) then
            tx_wait_txpmareset_done <= '1';
          else
            tx_wait_txpmareset_done <= '0';
          end if;
        end if;
      end if;
    end process;

    -- Pass through USER_TXPMARESET to GT_TXPMARESET -------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if (reset_r(0) = '1') then
          GT_TXPMARESET <= '0';
        else
          GT_TXPMARESET <= do_rst_vco_cyc or txpmareset_int;
        end if;
      end if;
    end process;

    -- Flag indicates if VCO cycle is due to pma reset or main fsm fow -------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then
        if (tx_state = C_TX_RESET) then
          do_rst_vco_cyc <= '1';
        elsif ( (tx_state = C_TX_RESET_RECOVERY) or
                ((tx_state = C_TX_WR_VCO_ON) and (tx_drp_done = '1')) ) then
          do_rst_vco_cyc <= '0';
        end if;
      end if;
    end process;

    -- TX Freq Detect -------------------------------------------------------
    tx_fdchk_cnt_ov <=  tx_fdetect_debug(2);
    tx_range_cnt_ov <=  tx_fdetect_debug(1);
    tx_fd_edge      <=  tx_fdetect_debug(0);

    tx_fdetect : freq_detect
    generic map (
      C_FDW      => C_TX_FD_WIDTH
    )
    port map (
      FD_LOCKERR => tx_fd_lockerr,
      FD_STATUS  => tx_fdetect_debug,
      FD_MIN     => TX_FD_MIN,
      FD_RANGE   => C_FD_RANGE,
      FD_EN      => TX_FD_EN,
      DCLK       => DCLK,
      GT_CLK     => GT_TXOUTCLK1,
      RESET      => reset_r(0)
    );


    --------------------------------------------------------------------------
    -- TXLOCK Calibration Block FSM
    --------------------------------------------------------------------------
    process (DCLK)
    begin
      if (rising_edge(DCLK)) then

        if (reset_r(0) = '1') then 
          tx_state <= C_TX_IDLE;
        else
          tx_state <= tx_next_state;
        end if;

      end if;
    end process;

    tx_fsm_tx_reset_check <= txpmareset_int & DISABLE;
    tx_fsm_tx_idle_check <= txpmareset_int & DISABLE &
                            txlock_r & tx_fd_lockerr;

    process (tx_state, tx_fsm_tx_reset_check, txpmareset_int,
             tx_wait_txpmareset_done, tx_fsm_tx_idle_check, tx_drp_done,
             do_rst_vco_cyc, tx_wait_txlock_done, DISABLE,
             rx_done_done, rx_state) 

      variable tx_fsm_name : string(1 to 25);
    begin

      case tx_state is

        when C_TX_RESET => 

          case tx_fsm_tx_reset_check is

            when "00" =>
               tx_next_state <= C_TX_RD_VCO_OFF;
            when "01" =>
                tx_next_state <= C_TX_RESET_RECOVERY;
            when others =>
                tx_next_state <= C_TX_RESET;
          end case;

          tx_fsm_name := ExtendString("C_TX_RESET", 25);

        when C_TX_RESET_RECOVERY =>

          if (txpmareset_int = '1') then
             tx_next_state <= C_TX_RESET;
          elsif (tx_wait_txpmareset_done = '1') then
             tx_next_state <= C_TX_IDLE;
          else 
             tx_next_state <= C_TX_RESET_RECOVERY;
          end if;

          tx_fsm_name := ExtendString("C_TX_RESET_RECOVERY", 25);

        when C_TX_IDLE =>

          if (tx_fsm_tx_idle_check(3) = '1') then
            tx_next_state <= C_TX_RESET;
          elsif (tx_fsm_tx_idle_check(3 downto 2) = "01") then
            tx_next_state <= C_TX_IDLE;
          elsif (tx_fsm_tx_idle_check(3 downto 1) = "000") then
            tx_next_state <= C_TX_RD_SLOWLOOP_OFF;
          elsif ((tx_fsm_tx_idle_check(3 downto 2) = "00") and
                 (tx_fsm_tx_idle_check(0) = '1')) then
            tx_next_state <= C_TX_RD_SLOWLOOP_OFF;
          else
            tx_next_state <= C_TX_IDLE;
          end if;

          tx_fsm_name := ExtendString("C_TX_IDLE", 25);

        when C_TX_RD_SLOWLOOP_OFF =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_MD_SLOWLOOP_OFF;
          else
            tx_next_state <= C_TX_RD_SLOWLOOP_OFF;
          end if;

          tx_fsm_name := ExtendString("C_TX_RD_SLOWLOOP_OFF", 25);

        when C_TX_MD_SLOWLOOP_OFF => 

          tx_next_state <= C_TX_WR_SLOWLOOP_OFF;
          tx_fsm_name := ExtendString("C_TX_MD_SLOWLOOP_OFF", 25);

        when C_TX_WR_SLOWLOOP_OFF =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_RD_VCO_OFF;
          else
            tx_next_state <= C_TX_WR_SLOWLOOP_OFF;
          end if;

          tx_fsm_name := ExtendString("C_TX_WR_SLOWLOOP_OFF", 25);

        when C_TX_RD_VCO_OFF =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_MD_VCO_OFF;
          else
            tx_next_state <= C_TX_RD_VCO_OFF;
          end if;

          tx_fsm_name := ExtendString("C_TX_RD_VCO_OFF", 25);

        when C_TX_MD_VCO_OFF =>

          tx_next_state <= C_TX_WR_VCO_OFF;
          tx_fsm_name := ExtendString("C_TX_MD_VCO_OFF", 25);

        when C_TX_WR_VCO_OFF =>

          if (tx_drp_done = '1') then 
            tx_next_state <= C_TX_RD_VCO_ON;
          else 
            tx_next_state <= C_TX_WR_VCO_OFF;
          end if;

          tx_fsm_name := ExtendString("C_TX_WR_VCO_OFF", 25);

        when C_TX_RD_VCO_ON =>

          if (tx_drp_done = '1') then 
            tx_next_state <= C_TX_MD_VCO_ON;
          else 
            tx_next_state <= C_TX_RD_VCO_ON;
          end if;

          tx_fsm_name := ExtendString("C_TX_RD_VCO_ON", 25);

        when C_TX_MD_VCO_ON =>

          tx_next_state <= C_TX_WR_VCO_ON;
          tx_fsm_name := ExtendString("C_TX_MD_VCO_ON", 25);

        when C_TX_WR_VCO_ON =>

          if (tx_drp_done = '1') then
            if (do_rst_vco_cyc = '1') then 
              tx_next_state <= C_TX_RESET_RECOVERY;
            else 
              tx_next_state <= C_TX_RD_SLOWLOOP_ON;
            end if;
          else
            tx_next_state <= C_TX_WR_VCO_ON;
          end if;

          tx_fsm_name := ExtendString("C_TX_WR_VCO_ON", 25);

        when C_TX_RD_SLOWLOOP_ON =>

          if (tx_drp_done = '1') then 
            tx_next_state <= C_TX_MD_SLOWLOOP_ON;
          else 
            tx_next_state <= C_TX_RD_SLOWLOOP_ON;
          end if;

          tx_fsm_name := ExtendString("C_TX_RD_SLOWLOOP_ON", 25);

        when C_TX_MD_SLOWLOOP_ON =>

          tx_next_state <= C_TX_WR_SLOWLOOP_ON;
          tx_fsm_name := ExtendString("C_TX_MD_SLOWLOOP_ON", 25);

        when C_TX_WR_SLOWLOOP_ON =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_RD_DIVA_ON;
          else 
            tx_next_state <= C_TX_WR_SLOWLOOP_ON;
          end if;

          tx_fsm_name := ExtendString("C_TX_WR_SLOWLOOP_ON", 25);

        when C_TX_RD_DIVA_ON =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_MD_DIVA_ON;
          else
            tx_next_state <= C_TX_RD_DIVA_ON;
          end if;

          tx_fsm_name := ExtendString("C_TX_RD_DIVA_ON", 25);

        when C_TX_MD_DIVA_ON =>

          tx_next_state <= C_TX_WR_DIVA_ON;
          tx_fsm_name := ExtendString("C_TX_MD_DIVA_ON", 25);

        when C_TX_WR_DIVA_ON =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_RD_DIVB_ON;
          else
            tx_next_state <= C_TX_WR_DIVA_ON;
          end if;

          tx_fsm_name := ExtendString("C_TX_WR_DIVA_ON", 25);

        when C_TX_RD_DIVB_ON =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_MD_DIVB_ON;
          else
            tx_next_state <= C_TX_RD_DIVB_ON;
          end if;

          tx_fsm_name := ExtendString("C_TX_RD_DIVB_ON", 25);

        when C_TX_MD_DIVB_ON =>

          tx_next_state <= C_TX_WR_DIVB_ON;
          tx_fsm_name := ExtendString("C_TX_MD_DIVB_ON", 25);

        when C_TX_WR_DIVB_ON =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_RD_DIVA_RESTORE;
          else
            tx_next_state <= C_TX_WR_DIVB_ON;
          end if;

          tx_fsm_name := ExtendString("C_TX_WR_DIVB_ON", 25);

        when C_TX_RD_DIVA_RESTORE =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_MD_DIVA_RESTORE;
          else
            tx_next_state <= C_TX_RD_DIVA_RESTORE;
          end if;

          tx_fsm_name := ExtendString("C_TX_RD_DIVA_RESTORE", 25);

        when C_TX_MD_DIVA_RESTORE => 

          tx_next_state <= C_TX_WR_DIVA_RESTORE;
          tx_fsm_name := ExtendString("C_TX_MD_DIVA_RESTORE", 25);

        when C_TX_WR_DIVA_RESTORE =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_RD_DIVB_RESTORE;
          else
            tx_next_state <= C_TX_WR_DIVA_RESTORE;
          end if;

          tx_fsm_name := ExtendString("C_TX_WR_DIVA_RESTORE", 25);

        when C_TX_RD_DIVB_RESTORE =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_MD_DIVB_RESTORE;
          else
            tx_next_state <= C_TX_RD_DIVB_RESTORE;
          end if;

          tx_fsm_name := ExtendString("C_TX_RD_DIVB_RESTORE", 25);

        when C_TX_MD_DIVB_RESTORE => 

          tx_next_state <= C_TX_WR_DIVB_RESTORE;
          tx_fsm_name := ExtendString("C_TX_MD_DIVB_RESTORE", 25);

        when C_TX_WR_DIVB_RESTORE =>

          if (tx_drp_done = '1') then
            tx_next_state <= C_TX_WAIT_TXLOCK;
          else
            tx_next_state <= C_TX_WR_DIVB_RESTORE;
          end if;

          tx_fsm_name := ExtendString("C_TX_WR_DIVB_RESTORE", 25);

        when C_TX_WAIT_TXLOCK =>

           if ((tx_wait_txlock_done = '1') or (DISABLE = '1')) then
             tx_next_state <= C_TX_DONE;
           else
             tx_next_state <= C_TX_WAIT_TXLOCK;
           end if;

           tx_fsm_name := ExtendString("C_TX_WAIT_TXLOCK", 25);

          when C_TX_DONE =>
            if (txpmareset_int = '1') then
              tx_next_state <= C_TX_RESET;
            elsif ( (rx_done_done = '1') or
                    ((rx_state = C_RX_RESET) or (rx_state = C_RX_IDLE)) ) then
              tx_next_state <= C_TX_IDLE;
            else
              tx_next_state <= C_TX_DONE;
            end if;

            tx_fsm_name := ExtendString("C_TX_DONE", 25);

        when others =>
          tx_next_state <= C_TX_IDLE;
          tx_fsm_name := ExtendString("default", 25);

      end case;
    end process;

  end generate use_txlock_cal;

  -- Tie-off signals when Calibration Block is connected to a B MGT
  not_use_txlock_cal: if (C_MGT_ID /= 0) generate

    tx_fd_lockerr <= '0';

    process (DCLK)
    begin
      if (rising_edge(DCLK)) then

        GT_TXPMARESET <= USER_TXPMARESET;
        USER_TXLOCK <= GT_TXLOCK;
        tx_req  <= '0';
        tx_read <= '0';
        tx_write <= '0';

      end if;
    end process;

  end generate not_use_txlock_cal;

  ----------------------------------------------------------------------------
  -- Signal Detect Block Internal Logic
  ----------------------------------------------------------------------------
  -- Signal Detect Request for DRP operation ---------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((sd_state = C_SD_IDLE) or (sd_drp_done='1')) then
        sd_req <= '0' ;
      else
        sd_req <= sd_read or sd_write;
      end if;
    end if;
  end process;

  -- Indicates Signal Detect DRP Read ----------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((sd_state = C_SD_IDLE) or (sd_drp_done='1')) then
        sd_read <= '0';
      else
        if ( (sd_state = C_SD_RD_PT_ON) or
             (sd_state = C_SD_RD_RXDIGRX_ON) or  
             (sd_state = C_SD_RD_RXDIGRX_RESTORE) or 
             (sd_state = C_SD_RD_PT_OFF) ) then  
          sd_read <= '1';
        else 
          sd_read <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Indicates Signal Detect DRP Write ---------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((sd_state = C_SD_IDLE) or (sd_drp_done='1')) then
        sd_write <= '0' ;
      else
        if ( (sd_state = C_SD_WR_PT_ON) or
             (sd_state = C_SD_WR_RXDIGRX_ON) or  
             (sd_state = C_SD_WR_RXDIGRX_RESTORE) or
             (sd_state = C_SD_WR_PT_OFF) ) then  
          sd_write <=  '1';
        else
          sd_write <= '0' ;
        end if;
      end if;
    end if;
  end process;
 
  -- Signal Detect DRP Read Working Register ---------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((cb_state = C_SD_DRP_OP) and (sd_read='1') and (GT_DRDY='1')) then
        sd_rd_wreg <= GT_DI;
      end if;
    end if;
  end process;

  -- Signal Detect DRP Write Working Register
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      case sd_state is

        when C_SD_MD_PT_ON =>
          sd_wr_wreg <= sd_rd_wreg(15 downto 13) & '0' &
                        sd_rd_wreg(11 downto 0);
        when C_SD_MD_RXDIGRX_ON =>
          sd_wr_wreg <= sd_rd_wreg(15 downto 2) & '1' & sd_rd_wreg(0);
        when C_SD_MD_RXDIGRX_RESTORE =>
          sd_wr_wreg <= sd_rd_wreg(15 downto 2) & rxdigrx_cache &
                        sd_rd_wreg(0);
        when C_SD_MD_PT_OFF =>
          sd_wr_wreg <= sd_rd_wreg(15 downto 13) & txpost_tap_pd_cache &
                        sd_rd_wreg(11 downto 0);
        when others =>
          null;
      end case;
    end if;
  end process;

  -- Generate DRP Addresses for Signal Detect --------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (sd_state = C_SD_IDLE) then 
        sd_addr_r(5 downto 0) <= c_tx_pt_addr(5 downto 0);
      elsif (sd_drp_done = '1') then 
        case sd_state is
          when C_SD_WR_PT_ON =>
            sd_addr_r(5 downto 0) <= c_rx_digrx_addr(5 downto 0);
          when C_SD_WR_RXDIGRX_RESTORE =>
            sd_addr_r(5 downto 0) <= c_tx_pt_addr(5 downto 0);
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  -- Assert when Signal Detect DRP Operation is Complete
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if ((GT_DRDY  = '1') and (cb_state = C_SD_DRP_OP)) then
        sd_drp_done <= '1';
      else
        sd_drp_done <= '0';
      end if;
    end if;
  end process;

  -- GT_LOOPBACK, GT_TXENC8B10BUSE and GT_TXBYPASS8B10B
  --  Switch the GT11 to serial loopback mode and enable 8B10B when the Signal
  --  Detect is Low
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (reset_r(0) = '1') then
        GT_LOOPBACK <= "00";
      elsif (RX_SIGNAL_DETECT = '0') then
        GT_LOOPBACK <= "11";
      else
        GT_LOOPBACK <= USER_LOOPBACK;
      end if;
    end if;
  end process;

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (reset_r(0) = '1') then
        GT_TXENC8B10BUSE <= '0';
        GT_TXBYPASS8B10B <= "00000000";
      elsif (TX_SIGNAL_DETECT = '0') then
        GT_TXENC8B10BUSE <= '1';
        GT_TXBYPASS8B10B <= "00000000";
      else
        GT_TXENC8B10BUSE <= USER_TXENC8B10BUSE;
        GT_TXBYPASS8B10B <= USER_TXBYPASS8B10B;
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Signal Detect Block FSM
  ----------------------------------------------------------------------------
  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (reset_r(0) = '1') then
        sd_state <= C_SD_IDLE;
      else 
        sd_state <= sd_next_state;
      end if;
    end if;
  end process;

  process (sd_state, RX_SIGNAL_DETECT,sd_drp_done)
    variable sd_fsm_name : string(1 to 25);
  begin
    case sd_state is

      when C_SD_IDLE =>

        if (RX_SIGNAL_DETECT = '0') then
          sd_next_state <= C_SD_RD_PT_ON;
        else
          sd_next_state <= C_SD_IDLE;
        end if;
        
        sd_fsm_name := ExtendString("C_SD_IDLE", 25);

      when C_SD_RD_PT_ON =>

        if (sd_drp_done = '1') then
          sd_next_state <= C_SD_MD_PT_ON;
        else
          sd_next_state <= C_SD_RD_PT_ON;
        end if;

        sd_fsm_name := ExtendString("C_SD_RD_PT_ON", 25);

      when C_SD_MD_PT_ON =>

        sd_next_state <= C_SD_WR_PT_ON;
        sd_fsm_name := ExtendString("C_SD_MD_PT_ON", 25);

      when C_SD_WR_PT_ON =>

        if (sd_drp_done = '1') then
          sd_next_state <= C_SD_RD_RXDIGRX_ON;
        else
          sd_next_state <= C_SD_WR_PT_ON;
        end if;

        sd_fsm_name := ExtendString("C_SD_WR_PT_ON", 25);
          
      when C_SD_RD_RXDIGRX_ON =>

        if (sd_drp_done = '1') then
          sd_next_state <= C_SD_MD_RXDIGRX_ON;
        else
          sd_next_state <= C_SD_RD_RXDIGRX_ON;
        end if;

        sd_fsm_name := ExtendString("C_SD_RD_RXDIGRX_ON", 25);

      when C_SD_MD_RXDIGRX_ON =>

        sd_next_state <= C_SD_WR_RXDIGRX_ON;
        sd_fsm_name := ExtendString("C_SD_MD_RXDIGRX_ON", 25);

      when C_SD_WR_RXDIGRX_ON =>

        if (sd_drp_done = '1') then
          sd_next_state <= C_SD_WAIT;
        else
          sd_next_state <= C_SD_WR_RXDIGRX_ON;
        end if;

        sd_fsm_name := ExtendString("C_SD_WR_RXDIGRX_ON", 25);
          
      when C_SD_WAIT =>

        if (RX_SIGNAL_DETECT = '1') then
          sd_next_state <= C_SD_RD_RXDIGRX_RESTORE;
        else
          sd_next_state <= C_SD_WAIT;
        end if;

        sd_fsm_name := ExtendString("C_SD_WAIT", 25);

       when C_SD_RD_RXDIGRX_RESTORE =>

         if (sd_drp_done = '1') then
           sd_next_state <= C_SD_MD_RXDIGRX_RESTORE;
         else
           sd_next_state <= C_SD_RD_RXDIGRX_RESTORE;
         end if;

         sd_fsm_name := ExtendString("C_SD_RD_RXDIGRX_RESTORE", 25);

       when C_SD_MD_RXDIGRX_RESTORE =>

         sd_next_state <= C_SD_WR_RXDIGRX_RESTORE;
         sd_fsm_name := ExtendString("C_SD_MD_RXDIGRX_RESTORE", 25);

       when C_SD_WR_RXDIGRX_RESTORE =>

         if (sd_drp_done = '1') then
           sd_next_state <= C_SD_RD_PT_OFF;
         else
           sd_next_state <= C_SD_WR_RXDIGRX_RESTORE;
         end if;

         sd_fsm_name := ExtendString("C_SD_WR_RXDIGRX_RESTORE", 25);

      when C_SD_RD_PT_OFF =>

        if (sd_drp_done = '1') then
          sd_next_state <= C_SD_MD_PT_OFF;
        else
          sd_next_state <= C_SD_RD_PT_OFF;
        end if;

        sd_fsm_name := ExtendString("C_SD_RD_PT_OFF", 25);

      when C_SD_MD_PT_OFF =>

        sd_next_state <= C_SD_WR_PT_OFF;
        sd_fsm_name := ExtendString("C_SD_MD_PT_OFF", 25);

      when C_SD_WR_PT_OFF =>

        if (sd_drp_done = '1') then
          sd_next_state <= C_SD_IDLE;
        else
          sd_next_state <= C_SD_WR_PT_OFF;
        end if;

        sd_fsm_name := ExtendString("C_SD_WR_PT_OFF", 25);
          
       when others =>

         sd_next_state <= C_SD_IDLE;
         sd_fsm_name := ExtendString("default", 25);

        end case;
  end process;

  ----------------------------------------------------------------------------
  -- DRP Read/Write FSM
  ----------------------------------------------------------------------------
  drp_rd <= '1' when  ( ((cb_state = C_USER_DRP_OP) and (user_dwe_r = '0')) or
                        ((cb_state = C_TX_DRP_OP) and (tx_read = '1')) or
                        ((cb_state = C_RX_DRP_OP) and (rx_read = '1')) or
                        ((cb_state = C_SD_DRP_OP) and (sd_read = '1')) )
            else '0';

  drp_wr <= '1' when  ( ((cb_state = C_USER_DRP_OP) and (user_dwe_r = '1')) or
                        ((cb_state = C_TX_DRP_OP) and (tx_write = '1')) or
                        ((cb_state = C_RX_DRP_OP) and (rx_write = '1')) or
                        ((cb_state = C_SD_DRP_OP) and (sd_write = '1')) ) 
            else '0';

  process (DCLK)
  begin
    if (rising_edge(DCLK)) then
      if (reset_r(0) = '1') then
        drp_state <= C_DRP_IDLE;
      else
        drp_state <= drp_next_state;
      end if;
    end if;
  end process;

  process (drp_state, drp_rd, drp_wr,stretch_drpwrite, gt_drdy_r)
    variable drp_fsm_name: string(1 to 25);
  begin
    case drp_state is
      when C_DRP_IDLE =>

        if (drp_wr = '1') then
          drp_next_state <= C_DRP_WRITE;
        else 
          if (drp_rd = '1') then
            drp_next_state <= C_DRP_READ; 
          else
            drp_next_state <= C_DRP_IDLE;
          end if;
        end if;

        drp_fsm_name := ExtendString("C_DRP_IDLE", 25);

      when C_DRP_READ =>

        drp_next_state <= C_DRP_WAIT;
        drp_fsm_name := ExtendString("C_DRP_READ", 25);

      when C_DRP_WRITE =>

        if (stretch_drpwrite = '1') then
          drp_next_state <= C_DRP_WRITE;
        else
          drp_next_state <= C_DRP_WAIT;
        end if;

        drp_fsm_name := ExtendString("C_DRP_WRITE", 25);

      when C_DRP_WAIT =>

        if (gt_drdy_r = '1') then
          drp_next_state <= C_DRP_COMPLETE;
        else
          drp_next_state <= C_DRP_WAIT;
        end if;

        drp_fsm_name := ExtendString("C_DRP_WAIT", 25);

      when C_DRP_COMPLETE =>

        drp_next_state <= C_DRP_IDLE;
        drp_fsm_name := ExtendString("C_DRP_COMPLETE", 25);

      when others =>
        drp_next_state <= C_DRP_IDLE;
        drp_fsm_name := ExtendString("default", 25);

    end case;
  end process;

end rtl;

-- ======================================================================== --

------------------------------------------------------------------------------
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:52 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: error_detect_v4_4byte_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.1 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--
------------------------------------------------------------------------------
--
--  ERROR_DETECT_4BYTE
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description : The ERROR_DETECT module monitors the MGT to detect hard errors.
--                It accumulates the Soft errors according to the leaky bucket
--                algorithm described in the Aurora Specification to detect Hard
--                errors.  All errors are reported to the Global Logic Interface.
--
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.AURORA.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use IEEE.numeric_bit.all;


entity ERROR_DETECT_4BYTE is

port (
    -- Lane Init SM Interface

        ENABLE_ERROR_DETECT : in  std_logic;
        HARD_ERROR_RESET    : out std_logic;

    -- Global Logic Interface

        SOFT_ERROR          : out std_logic_vector(0 to 1);
        HARD_ERROR          : out std_logic;

    -- MGT Interface

        RX_BUF_ERR          : in std_logic;
        RX_DISP_ERR         : in std_logic_vector(3 downto 0);
        RX_NOT_IN_TABLE     : in std_logic_vector(3 downto 0);
        TX_BUF_ERR          : in std_logic;
        RX_REALIGN          : in std_logic;

    -- System Interface

        USER_CLK            : in std_logic
     );

end ERROR_DETECT_4BYTE;

architecture RTL of ERROR_DETECT_4BYTE is

--Constant Declarations --

    constant DLY               : time := 1 ns;

-- VHDL out buffer logic --

    signal  SOFT_ERROR_Buffer       : std_logic_vector(0 to 1);
    signal  HARD_ERROR_Buffer       : std_logic;


-- Internal Register Declarations --

    signal  count_0_r                   : std_logic_vector(0 to 1);
    signal  count_1_r                   : std_logic_vector(0 to 1);
    signal  bucket_full_0_r             : std_logic;
    signal  bucket_full_1_r             : std_logic;
    signal  soft_error_r                : std_logic_vector(0 to 3);
    signal  good_count_0_r              : std_logic_vector(0 to 1);
    signal  good_count_1_r              : std_logic_vector(0 to 1);


begin

    -- VHDL Output Buffers --

    SOFT_ERROR <= SOFT_ERROR_Buffer;
    HARD_ERROR <= HARD_ERROR_Buffer;

-- Main Body of Code --

    -- Error Processing --

    -- Detect Soft Errors.  The lane is divided into 2 2-byte sublanes for this purpose.

    process(USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            -- Sublane 0
            soft_error_r(0) <= ENABLE_ERROR_DETECT and (RX_DISP_ERR(3) or RX_NOT_IN_TABLE(3)) after DLY;
            soft_error_r(1) <= ENABLE_ERROR_DETECT and (RX_DISP_ERR(2) or RX_NOT_IN_TABLE(2)) after DLY;

            -- Sublane 1
            soft_error_r(2) <= ENABLE_ERROR_DETECT and (RX_DISP_ERR(1) or RX_NOT_IN_TABLE(1)) after DLY;
            soft_error_r(3) <= ENABLE_ERROR_DETECT and (RX_DISP_ERR(0) or RX_NOT_IN_TABLE(0)) after DLY;

        end if;

    end process;


    process(USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            -- Sublane 0
            SOFT_ERROR_Buffer(0) <= soft_error_r(0) or soft_error_r(1) after DLY;

            -- Sublane 1
            SOFT_ERROR_Buffer(1) <= soft_error_r(2) or soft_error_r(3) after DLY;

        end if;

    end process;


    -- Detect Hard Errors

    process(USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if(ENABLE_ERROR_DETECT = '1') then

                HARD_ERROR_Buffer <= (RX_BUF_ERR or TX_BUF_ERR or RX_REALIGN
                                      or bucket_full_0_r or bucket_full_1_r) after DLY;

            else

                HARD_ERROR_Buffer <= '0' after DLY;

            end if;

        end if;

    end process;

    -- Assert hard error reset when there is a hard error.  This assignment
    -- just renames the two fanout branches of the hard error signal.

    HARD_ERROR_RESET <= HARD_ERROR_Buffer;


    -- Leaky Bucket Sublane 0 --

    -- Good cycle counter: it takes 2 good cycles in a row to remove a demerit from
    -- the leaky bucket.

    process(USER_CLK)

        variable err_vec : std_logic_vector(3 downto 0);

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if(ENABLE_ERROR_DETECT = '0') then

                good_count_0_r <= "01" after DLY;

            else

                err_vec := (soft_error_r(0 to 1) & good_count_0_r);

                case err_vec is

                    when "0000" =>   good_count_0_r    <=  "01" after DLY;
                    when "0001" =>   good_count_0_r    <=  "10" after DLY;
                    when "0010" =>   good_count_0_r    <=  "01" after DLY;
                    when "0011" =>   good_count_0_r    <=  "01" after DLY;
                    when others =>   good_count_0_r    <=  "00" after DLY;

                end case;

            end if;

        end if;

    end process;



    -- Perform the leaky bucket algorithm using an up/down counter.  A drop is
    -- added to the bucket whenever a soft error occurs, and is allowed to leak
    -- out whenever the good cycles counter reaches 2.  Once the bucket fills
    -- (3 drops) it stays full until it is reset by disabling and then enabling
    -- the error detection circuit.

    process(USER_CLK)

        variable err_vec : std_logic_vector(4 downto 0);

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if(ENABLE_ERROR_DETECT = '0') then

                count_0_r <=  "00" after DLY;

            else

                err_vec := (soft_error_r(0 to 1) & good_count_0_r(0) & count_0_r);

                case err_vec is

                    when "00000"    =>   count_0_r <= count_0_r after DLY;
                    when "00001"    =>   count_0_r <= count_0_r after DLY;
                    when "00010"    =>   count_0_r <= count_0_r after DLY;
                    when "00011"    =>   count_0_r <= count_0_r after DLY;

                    when "00100"    =>   count_0_r <= "00" after DLY;
                    when "00101"    =>   count_0_r <= "00" after DLY;
                    when "00110"    =>   count_0_r <= "01" after DLY;
                    when "00111"    =>   count_0_r <= "11" after DLY;

                    when "01000"    =>   count_0_r <= "01" after DLY;
                    when "01001"    =>   count_0_r <= "10" after DLY;
                    when "01010"    =>   count_0_r <= "11" after DLY;
                    when "01011"    =>   count_0_r <= "11" after DLY;

                    when "01100"    =>   count_0_r <= "01" after DLY;
                    when "01101"    =>   count_0_r <= "10" after DLY;
                    when "01110"    =>   count_0_r <= "11" after DLY;
                    when "01111"    =>   count_0_r <= "11" after DLY;

                    when "10000"    =>   count_0_r <= "01" after DLY;
                    when "10001"    =>   count_0_r <= "10" after DLY;
                    when "10010"    =>   count_0_r <= "11" after DLY;
                    when "10011"    =>   count_0_r <= "11" after DLY;

                    when "10100"    =>   count_0_r <= "01" after DLY;
                    when "10101"    =>   count_0_r <= "10" after DLY;
                    when "10110"    =>   count_0_r <= "11" after DLY;
                    when "10111"    =>   count_0_r <= "11" after DLY;

                    when "11000"    =>   count_0_r <= "10" after DLY;
                    when "11001"    =>   count_0_r <= "11" after DLY;
                    when "11010"    =>   count_0_r <= "11" after DLY;
                    when "11011"    =>   count_0_r <= "11" after DLY;

                    when "11100"    =>   count_0_r <= "10" after DLY;
                    when "11101"    =>   count_0_r <= "11" after DLY;
                    when "11110"    =>   count_0_r <= "11" after DLY;
                    when "11111"    =>   count_0_r <= "11" after DLY;

                    when others     =>   count_0_r <= "XX" after DLY;

                end case;

            end if;

        end if;

    end process;


    -- Detect when the bucket is full and register the signal.

    process(USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            bucket_full_0_r <= std_bool(count_0_r = "11") after DLY;

        end if;

    end process;


    -- Leaky Bucket Sublane 1 --

    -- Good cycle counter: it takes 2 good cycles in a row to remove a demerit from
    -- the leaky bucket.

    process(USER_CLK)

        variable err_vec : std_logic_vector(3 downto 0);

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if(ENABLE_ERROR_DETECT = '0') then

                good_count_1_r    <=  "01" after DLY;

            else

                err_vec := (soft_error_r(2 to 3)& good_count_1_r);

                case err_vec is

                    when "0000" =>   good_count_1_r <= "01" after DLY;
                    when "0001" =>   good_count_1_r <= "10" after DLY;
                    when "0010" =>   good_count_1_r <= "01" after DLY;
                    when "0011" =>   good_count_1_r <= "01" after DLY;
                    when others =>   good_count_1_r <= "00" after DLY;

                end case;

            end if;

        end if;

    end process;


    -- Perform the leaky bucket algorithm using an up/down counter.  A drop is
    -- added to the bucket whenever a soft error occurs, and is allowed to leak
    -- out whenever the good cycles counter reaches 2.  Once the bucket fills
    -- (3 drops) it stays full until it is reset by disabling and then enabling
    -- the error detection circuit.

    process(USER_CLK)

        variable err_vec : std_logic_vector(4 downto 0);

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if(ENABLE_ERROR_DETECT = '0') then

                count_1_r <=  "00" after DLY;

            else

                err_vec := (soft_error_r(2 to 3) & good_count_1_r(0) & count_1_r);

                case err_vec is

                    when "00000" => count_1_r <=  count_1_r after DLY;
                    when "00001" => count_1_r <=  count_1_r after DLY;
                    when "00010" => count_1_r <=  count_1_r after DLY;
                    when "00011" => count_1_r <=  count_1_r after DLY;

                    when "00100" => count_1_r <=  "00" after DLY;
                    when "00101" => count_1_r <=  "00" after DLY;
                    when "00110" => count_1_r <=  "01" after DLY;
                    when "00111" => count_1_r <=  "11" after DLY;

                    when "01000" => count_1_r <=  "01" after DLY;
                    when "01001" => count_1_r <=  "10" after DLY;
                    when "01010" => count_1_r <=  "11" after DLY;
                    when "01011" => count_1_r <=  "11" after DLY;

                    when "01100" => count_1_r <=  "01" after DLY;
                    when "01101" => count_1_r <=  "10" after DLY;
                    when "01110" => count_1_r <=  "11" after DLY;
                    when "01111" => count_1_r <=  "11" after DLY;

                    when "10000" => count_1_r <=  "01" after DLY;
                    when "10001" => count_1_r <=  "10" after DLY;
                    when "10010" => count_1_r <=  "11" after DLY;
                    when "10011" => count_1_r <=  "11" after DLY;

                    when "10100" => count_1_r <=  "01" after DLY;
                    when "10101" => count_1_r <=  "10" after DLY;
                    when "10110" => count_1_r <=  "11" after DLY;
                    when "10111" => count_1_r <=  "11" after DLY;

                    when "11000" => count_1_r <=  "10" after DLY;
                    when "11001" => count_1_r <=  "11" after DLY;
                    when "11010" => count_1_r <=  "11" after DLY;
                    when "11011" => count_1_r <=  "11" after DLY;

                    when "11100" => count_1_r <=  "10" after DLY;
                    when "11101" => count_1_r <=  "11" after DLY;
                    when "11110" => count_1_r <=  "11" after DLY;
                    when "11111" => count_1_r <=  "11" after DLY;

                    when others  => count_1_r <=  "XX" after DLY;

                end case;

            end if;

        end if;

    end process;


    -- Detect when the bucket is full and register the signal.

    process(USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            bucket_full_1_r <= std_bool(count_1_r = "11") after DLY;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:51 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: chbond_count_dec_v4_4byte_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.1 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  CHBOND_COUNT_DEC_4BYTE
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: This module decodes the MGT's RXSTATUS signals. RXSTATUS[5] indicates
--               that Channel Bonding is complete
--
--               * Supports Virtex 4
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.AURORA.all;

entity CHBOND_COUNT_DEC_4BYTE is

    port (

            RX_STATUS         : in std_logic_vector(5 downto 0);
            CHANNEL_BOND_LOAD : out std_logic;
            USER_CLK          : in std_logic

         );

end CHBOND_COUNT_DEC_4BYTE;

architecture RTL of CHBOND_COUNT_DEC_4BYTE is

-- Parameter Declarations --

    constant DLY : time := 1 ns;
    constant CHANNEL_BOND_LOAD_CODE : std_logic_vector(5 downto 0) := "100111";  -- Status bus code: Channel Bond load complete

-- External Register Declarations

    signal CHANNEL_BOND_LOAD_Buffer : std_logic;

begin

    CHANNEL_BOND_LOAD <= CHANNEL_BOND_LOAD_Buffer;

-- Main Body of Code --

    process (USER_CLK)

    begin

        if (USER_CLK'event and USER_CLK = '1') then

            CHANNEL_BOND_LOAD_Buffer <= std_bool(RX_STATUS = CHANNEL_BOND_LOAD_CODE) after DLY;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:51 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: channel_error_detect_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  CHANNEL_ERROR_DETECT
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: the CHANNEL_ERROR_DETECT module monitors the error signals
--               from the Aurora Lanes in the channel.  If one or more errors
--               are detected, the error is reported as a channel error.  If
--               a hard error is detected, it sends a message to the channel
--               initialization state machine to reset the channel.
--
--               This module supports 2 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CHANNEL_ERROR_DETECT is

    port (

    -- Aurora Lane Interface

            SOFT_ERROR         : in std_logic_vector(0 to 3);
            HARD_ERROR         : in std_logic_vector(0 to 1);
            LANE_UP            : in std_logic_vector(0 to 1);

    -- System Interface

            USER_CLK           : in std_logic;
            POWER_DOWN         : in std_logic;

            CHANNEL_SOFT_ERROR : out std_logic;
            CHANNEL_HARD_ERROR : out std_logic;

    -- Channel Init SM Interface

            RESET_CHANNEL      : out std_logic

         );

end CHANNEL_ERROR_DETECT;

architecture RTL of CHANNEL_ERROR_DETECT is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal CHANNEL_SOFT_ERROR_Buffer : std_logic := '1';
    signal CHANNEL_HARD_ERROR_Buffer : std_logic := '1';
    signal RESET_CHANNEL_Buffer      : std_logic := '1';

-- Internal Register Declarations --

    signal soft_error_r : std_logic_vector(0 to 3);
    signal hard_error_r : std_logic_vector(0 to 1);

-- Wire Declarations --

    signal channel_soft_error_c : std_logic;
    signal channel_hard_error_c : std_logic;
    signal reset_channel_c      : std_logic;

begin

    CHANNEL_SOFT_ERROR <= CHANNEL_SOFT_ERROR_Buffer;
    CHANNEL_HARD_ERROR <= CHANNEL_HARD_ERROR_Buffer;
    RESET_CHANNEL      <= RESET_CHANNEL_Buffer;

-- Main Body of Code --

    -- Register all of the incoming error signals.  This is neccessary for timing.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            soft_error_r <= SOFT_ERROR after DLY;
            hard_error_r <= HARD_ERROR after DLY;

        end if;

    end process;


    -- Assert Channel soft error if any of the soft error signals are asserted.

    channel_soft_error_c <= soft_error_r(0) or
                            soft_error_r(1) or
                            soft_error_r(2) or
                            soft_error_r(3);

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            CHANNEL_SOFT_ERROR_Buffer <= channel_soft_error_c after DLY;

        end if;

    end process;


    -- Assert Channel hard error if any of the hard error signals are asserted.

    channel_hard_error_c <= hard_error_r(0) or
                            hard_error_r(1);

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            CHANNEL_HARD_ERROR_Buffer <= channel_hard_error_c after DLY;

        end if;

    end process;


    -- "reset_channel_r" is asserted when any of the LANE_UP signals are low.

    reset_channel_c <= not LANE_UP(0) or
                       not LANE_UP(1);

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RESET_CHANNEL_Buffer <= reset_channel_c or POWER_DOWN after DLY;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/21 23:26:37 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: idle_and_ver_gen_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.5 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  IDLE_AND_VER_GEN
--
--  Author: N. Gulstone, B.Woodard
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: the IDLE_AND_VER_GEN module generates idle sequences and
--               verification sequences for the Aurora channel.  The idle sequences
--               are constantly generated by a pseudorandom generator and a counter
--               to make the sequence Aurora compliant.  If the gen_ver signal is high,
--               verification symbols are added to the mix at appropriate intervals
--
--               This module supports 2 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use WORK.AURORA.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.all;
-- synthesis translate_on


entity IDLE_AND_VER_GEN is

    port (

    -- Channel Init SM Interface

            GEN_VER  : in std_logic;
            DID_VER  : out std_logic;

    -- Aurora Lane Interface

            GEN_A    : out std_logic_vector(0 to 1);
            GEN_K    : out std_logic_vector(0 to 7);
            GEN_R    : out std_logic_vector(0 to 7);
            GEN_V    : out std_logic_vector(0 to 7);

    -- System Interface

            RESET    : in std_logic;
            USER_CLK : in std_logic

         );

end IDLE_AND_VER_GEN;

architecture RTL of IDLE_AND_VER_GEN is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal DID_VER_Buffer : std_logic;
    signal GEN_A_Buffer   : std_logic_vector(0 to 1);
    signal GEN_K_Buffer   : std_logic_vector(0 to 7);
    signal GEN_R_Buffer   : std_logic_vector(0 to 7);
    signal GEN_V_Buffer   : std_logic_vector(0 to 7);

-- Internal Register Declarations --

    signal lfsr_reg              : std_logic_vector(0 to 3) := "0000";
    signal down_count_r          : std_logic_vector(0 to 2) := "000";
    signal downcounter_r         : std_logic_vector(0 to 2) := "000";
    signal prev_cycle_gen_ver_r  : std_logic;

-- Wire Declarations --

    signal gen_k_c            : std_logic_vector(0 to 3);
    signal gen_r_c            : std_logic_vector(0 to 3);
    signal ver_counter_c      : std_logic;
    signal gen_k_flop_c       : std_logic_vector(0 to 3);
    signal gen_r_flop_c       : std_logic_vector(0 to 3);
    signal gen_a_flop_c       : std_logic;
    signal downcounter_done_c : std_logic;
    signal gen_ver_edge_c     : std_logic;
    signal recycle_gen_ver_c  : std_logic;
    signal insert_ver_c       : std_logic;

    signal tied_to_gnd        : std_logic;
    signal tied_to_vcc        : std_logic;

-- Component Declaration --

    component FD
        generic (INIT : bit := '0');
        port (

                Q : out std_ulogic;
                C : in  std_ulogic;
                D : in  std_ulogic

             );

    end component;

    component FDR
        generic (INIT : bit := '0');
        port (

                Q : out std_ulogic;
                C : in  std_ulogic;
                D : in  std_ulogic;
                R : in  std_ulogic

             );

    end component;

    component SRL16
        generic (INIT : bit_vector := X"0000");
        port (

                Q   : out std_ulogic;
                A0  : in  std_ulogic;
                A1  : in  std_ulogic;
                A2  : in  std_ulogic;
                A3  : in  std_ulogic;
                CLK : in  std_ulogic;
                D   : in  std_ulogic

             );

    end component;

begin

    DID_VER <= DID_VER_Buffer;
    GEN_A   <= GEN_A_Buffer;
    GEN_K   <= GEN_K_Buffer;
    GEN_R   <= GEN_R_Buffer;
    GEN_V   <= GEN_V_Buffer;

    tied_to_gnd <= '0';
    tied_to_vcc <= '1';

-- Main Body of Code --

    -- Random Pattern Generation --

    -- Use an LFSR to create pseudorandom patterns.  This is a 4-bit LFSR from
    -- the Aurora 401.  Taps on bits 0 and 3 are XORed with the OR of bits 1:3
    -- to make the input to the register.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            lfsr_reg(0) <= lfsr_reg(1);
            lfsr_reg(1) <= lfsr_reg(2);
            lfsr_reg(2) <= lfsr_reg(3);
            lfsr_reg(3) <= (lfsr_reg(0) xor lfsr_reg(3) xor
                           (not (lfsr_reg(1) or lfsr_reg(2) or lfsr_reg(3))));

        end if;

    end process;


    -- A constants generator is used to limit the downcount range to values
    -- between 3 and 6 (4 to 7 clocks, 16 to 28 bytes).

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case lfsr_reg(1 to 3) is

                when "000" => down_count_r <= "011";
                when "001" => down_count_r <= "100";
                when "010" => down_count_r <= "101";
                when "011" => down_count_r <= "110";
                when "100" => down_count_r <= "011";
                when "101" => down_count_r <= "100";
                when "110" => down_count_r <= "101";
                when "111" => down_count_r <= "110";
                when others => down_count_r <= "XXX";

            end case;

        end if;

    end process;

    -- Use a downcounter to determine when A's should be added to the idle pattern.
    -- Load the counter with the 3 least significant bits of the lfsr whenever the
    -- counter reaches 0.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (RESET = '1') then

                downcounter_r <= "000" after DLY;

            else

                if (downcounter_done_c = '1') then

                    downcounter_r <= down_count_r after DLY;

                else

                    downcounter_r <= downcounter_r - "001" after DLY;

                end if;

            end if;

        end if;

    end process;


    downcounter_done_c <= std_bool(downcounter_r = "000");


    -- The LFSR's pseudo random patterns are also used to generate the sequence of
    -- K and R characters that make up the rest of the idle sequence.  Note that
    -- R characters are used whenever K characters are not.

    gen_r_c <= lfsr_reg;
    gen_k_c <= not lfsr_reg;


    -- Verification Sequence Generation --

    -- Use a counter to generate the verification sequence every 64 bytes
    -- (16 clocks), starting from when verification is enabled.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            prev_cycle_gen_ver_r <= GEN_VER after DLY;

        end if;

    end process;


    -- Detect the positive edge of the GEN_VER signal.

    gen_ver_edge_c <= GEN_VER and not prev_cycle_gen_ver_r;


    -- If GEN_VER is still high after generating a verification sequence,
    -- indicate that the gen_ver signal can be generated again.

    recycle_gen_ver_c <= DID_VER_Buffer and GEN_VER;


    -- Prime the verification counter SRL16 with a 1.  When this 1 reaches the end
    -- of the register, it will become the gen_ver_word signal.  Prime the counter
    -- only if there was a positive edge on GEN_VER to start the sequence, or if
    -- the sequence has just ended and another must be generated.

    insert_ver_c <= gen_ver_edge_c or recycle_gen_ver_c;


    -- Main Body of the verification counter.  It is implemented as a shift register
    -- made from an SRL16.  The register is 15 cycles long, and operates by
    -- taking the 1 from the insert_ver_c signal and passing it though its stages.

    ver_counter_i : SRL16


        generic map (INIT => X"0000")
        port map (

                    Q   => ver_counter_c,
                    A0  => tied_to_gnd,
                    A1  => tied_to_vcc,
                    A2  => tied_to_vcc,
                    A3  => tied_to_vcc,
                    CLK => USER_CLK,
                    D   => insert_ver_c

                 );


    -- Generate the 4 bytes of the verification sequence on the cycle after
    -- the verification counter reaches '15'.  Also signals that the verification
    -- sequence has been generated.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            DID_VER_Buffer <= ver_counter_c after DLY;

        end if;

    end process;


    -- Output Signals --

    -- Assert GEN_V in the LSBytes of each lane when DID_VER is asserted.  We use
    -- a seperate register for each output to provide enough slack to allow the
    -- Global logic to communicate with all lanes without causing timing problems.

    GEN_V_Buffer(0) <= '0';
    GEN_V_Buffer(4) <= '0';


    gen_v_flop_1_i : FD


        generic map (INIT => '0')
        port map (

                    D => recycle_gen_ver_c,
                    C => USER_CLK,
                    Q => GEN_V_Buffer(1)

                 );


    gen_v_flop_5_i : FD


        generic map (INIT => '0')
        port map (

                    D => recycle_gen_ver_c,
                    C => USER_CLK,
                    Q => GEN_V_Buffer(5)

                 );


    gen_v_flop_2_i : FD


        generic map (INIT => '0')
        port map (
                    D => recycle_gen_ver_c,
                    C => USER_CLK,
                    Q => GEN_V_Buffer(2)
                 );


    gen_v_flop_6_i : FD


        generic map (INIT => '0')
        port map (
                    D => recycle_gen_ver_c,
                    C => USER_CLK,
                    Q => GEN_V_Buffer(6)
                 );


    gen_v_flop_3_i : FD


        generic map (INIT => '0')
        port map (
                    D => recycle_gen_ver_c,
                    C => USER_CLK,
                    Q => GEN_V_Buffer(3)
                 );


    gen_v_flop_7_i : FD


        generic map (INIT => '0')
        port map (
                    D => recycle_gen_ver_c,
                    C => USER_CLK,
                    Q => GEN_V_Buffer(7)
                 );


    -- Assert GEN_A in the MSByte of each lane when the GEN_A downcounter reaches 0.
    -- Note that the signal has a register for each output for the same reason as the
    -- GEN_V signal.  GEN_A is ignored when it collides with other non-idle
    -- generation requests at the Aurora Lane, but we qualify the signal with
    -- the gen_ver_word_1_r signal so it does not overwrite the K used in the
    -- MSByte of the first word of the Verification sequence.

    gen_a_flop_c <= downcounter_done_c and not recycle_gen_ver_c;


    gen_a_flop_0_i : FD


        generic map (INIT => '0')
        port map (

                    D => gen_a_flop_c,
                    C => USER_CLK,
                    Q => GEN_A_Buffer(0)

                 );


    gen_a_flop_1_i : FD


        generic map (INIT => '0')
        port map (

                    D => gen_a_flop_c,
                    C => USER_CLK,
                    Q => GEN_A_Buffer(1)

                 );


    -- Assert GEN_K in the MSByte when the lfsr dictates. Turn off the assertion if an
    -- /A/ symbol is being generated on the byte.  Assert the signal without qualifications
    -- if GEN_V is asserted.  Assert GEN_K in the LSBytes when the lfsr dictates.
    -- There are no qualifications because only the GEN_R signal can collide with it, and
    -- this is prevented by the way the gen_k_c signal is generated.  All other GEN signals
    -- will override this signal at the AURORA_LANE.

    gen_k_flop_c(0) <= (gen_k_c(0) and not downcounter_done_c) or recycle_gen_ver_c;


    gen_k_flop_0_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_k_flop_c(0),
                    C => USER_CLK,
                    Q => GEN_K_Buffer(0)

                 );


    gen_k_flop_4_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_k_flop_c(0),
                    C => USER_CLK,
                    Q => GEN_K_Buffer(4)

                 );


    gen_k_flop_c(1) <= gen_k_c(1);


    gen_k_flop_1_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_k_flop_c(1),
                    C => USER_CLK,
                    Q => GEN_K_Buffer(1)

                 );


    gen_k_flop_5_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_k_flop_c(1),
                    C => USER_CLK,
                    Q => GEN_K_Buffer(5)

                 );


    gen_k_flop_c(2) <= gen_k_c(2);


    gen_k_flop_2_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_k_flop_c(2),
                    C => USER_CLK,
                    Q => GEN_K_Buffer(2)

                 );


    gen_k_flop_6_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_k_flop_c(2),
                    C => USER_CLK,
                    Q => GEN_K_Buffer(6)

                 );


    gen_k_flop_c(3) <= gen_k_c(3);


    gen_k_flop_3_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_k_flop_c(3),
                    C => USER_CLK,
                    Q => GEN_K_Buffer(3)

                 );


    gen_k_flop_7_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_k_flop_c(3),
                    C => USER_CLK,
                    Q => GEN_K_Buffer(7)

                 );


    -- Assert GEN_R in the MSByte when the lfsr dictates.  Turn off the assertion if an
    -- /A/ symbol, or the first verification word is being generated.  Assert GEN_R in the
    -- LSByte when the lfsr dictates, with no qualifications (same reason as the GEN_K LSByte).

    gen_r_flop_c(0) <= gen_r_c(0) and not downcounter_done_c and not recycle_gen_ver_c;


    gen_r_flop_0_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_r_flop_c(0),
                    C => USER_CLK,
                    Q => GEN_R_Buffer(0)

                 );


    gen_r_flop_4_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_r_flop_c(0),
                    C => USER_CLK,
                    Q => GEN_R_Buffer(4)

                 );


    gen_r_flop_c(1) <= gen_r_c(1);


    gen_r_flop_1_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_r_flop_c(1),
                    C => USER_CLK,
                    Q => GEN_R_Buffer(1)

                 );


    gen_r_flop_5_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_r_flop_c(1),
                    C => USER_CLK,
                    Q => GEN_R_Buffer(5)

                 );


    gen_r_flop_c(2) <= gen_r_c(2);


    gen_r_flop_2_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_r_flop_c(2),
                    C => USER_CLK,
                    Q => GEN_R_Buffer(2)

                 );


    gen_r_flop_6_i : FD

        generic map (INIT => '0')
        port map (

                    D => gen_r_flop_c(2),
                    C => USER_CLK,
                    Q => GEN_R_Buffer(6)

                 );


    gen_r_flop_c(3) <= gen_r_c(3);


    gen_r_flop_3_i : FD

        generic map (INIT => '0')
        port map (
                    D => gen_r_flop_c(3),
                    C => USER_CLK,
                    Q => GEN_R_Buffer(3)
                 );


    gen_r_flop_7_i : FD

        generic map (INIT => '0')
        port map (
                    D => gen_r_flop_c(3),
                    C => USER_CLK,
                    Q => GEN_R_Buffer(7)
                 );


end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:52 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: left_align_control_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  LEFT_ALIGN_CONTROL
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: The LEFT_ALIGN_CONTROL is used to control the Left Align Muxes in
--               the RX_LL module.  Each module supports up to 8 lanes.  Modules can
--               be combined in stages to support channels with more than 8 lanes.
--
--               This module supports 4 4-byte lane designs.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity LEFT_ALIGN_CONTROL is

    port (

            PREVIOUS_STAGE_VALID : in std_logic_vector(0 to 3);
            MUX_SELECT           : out std_logic_vector(0 to 11);
            VALID                : out std_logic_vector(0 to 3);
            USER_CLK             : in std_logic;
            RESET                : in std_logic

         );

end LEFT_ALIGN_CONTROL;

architecture RTL of LEFT_ALIGN_CONTROL is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal MUX_SELECT_Buffer : std_logic_vector(0 to 11);
    signal VALID_Buffer      : std_logic_vector(0 to 3);

-- Internal Register Declarations --

    signal  mux_select_c : std_logic_vector(0 to 11);
    signal  valid_c      : std_logic_vector(0 to 3);

begin

    MUX_SELECT <= MUX_SELECT_Buffer;
    VALID      <= VALID_Buffer;

-- Main Body of Code --

    -- SELECT --

    -- Lane 0

    process (PREVIOUS_STAGE_VALID(0 to 3))

    begin

        case PREVIOUS_STAGE_VALID(0 to 3) is

            when "0001" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(3,3);

            when "0010" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(2,3);

            when "0011" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(2,3);

            when "0100" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(1,3);

            when "0101" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(1,3);

            when "0110" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(1,3);

            when "0111" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(1,3);

            when "1000" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(0,3);

            when "1001" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(0,3);

            when "1010" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(0,3);

            when "1011" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(0,3);

            when "1100" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(0,3);

            when "1101" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(0,3);

            when "1110" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(0,3);

            when "1111" =>

                mux_select_c(0 to 2) <= conv_std_logic_vector(0,3);

            when others =>

                mux_select_c(0 to 2) <= (others => 'X');

        end case;

    end process;


    -- Lane 1

    process (PREVIOUS_STAGE_VALID(0 to 3))

    begin

        case PREVIOUS_STAGE_VALID(0 to 3) is

            when "0011" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(2,3);

            when "0101" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(2,3);

            when "0110" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(1,3);

            when "0111" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(1,3);

            when "1001" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(2,3);

            when "1010" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(1,3);

            when "1011" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(1,3);

            when "1100" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(0,3);

            when "1101" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(0,3);

            when "1110" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(0,3);

            when "1111" =>

                mux_select_c(3 to 5) <= conv_std_logic_vector(0,3);

            when others =>

                mux_select_c(3 to 5) <= (others => 'X');

        end case;

    end process;


    -- Lane 2

    process (PREVIOUS_STAGE_VALID(0 to 3))

    begin

        case PREVIOUS_STAGE_VALID(0 to 3) is

            when "0111" =>

                mux_select_c(6 to 8) <= conv_std_logic_vector(1,3);

            when "1011" =>

                mux_select_c(6 to 8) <= conv_std_logic_vector(1,3);

            when "1101" =>

                mux_select_c(6 to 8) <= conv_std_logic_vector(1,3);

            when "1110" =>

                mux_select_c(6 to 8) <= conv_std_logic_vector(0,3);

            when "1111" =>

                mux_select_c(6 to 8) <= conv_std_logic_vector(0,3);

            when others =>

                mux_select_c(6 to 8) <= (others => 'X');

        end case;

    end process;


    -- Lane 3

    process (PREVIOUS_STAGE_VALID(0 to 3))

    begin

        case PREVIOUS_STAGE_VALID(0 to 3) is

            when "1111" =>

                mux_select_c(9 to 11) <= conv_std_logic_vector(0,3);

            when others =>

                mux_select_c(9 to 11) <= (others => 'X');

        end case;

    end process;


    -- Register the select signals.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            MUX_SELECT_Buffer <= mux_select_c after DLY;

        end if;

    end process;


    -- VALID --

    -- Lane 0

    process (PREVIOUS_STAGE_VALID(0 to 3))

    begin

        case PREVIOUS_STAGE_VALID(0 to 3) is

            when "0001" =>

                valid_c(0) <= '1';

            when "0010" =>

                valid_c(0) <= '1';

            when "0011" =>

                valid_c(0) <= '1';

            when "0100" =>

                valid_c(0) <= '1';

            when "0101" =>

                valid_c(0) <= '1';

            when "0110" =>

                valid_c(0) <= '1';

            when "0111" =>

                valid_c(0) <= '1';

            when "1000" =>

                valid_c(0) <= '1';

            when "1001" =>

                valid_c(0) <= '1';

            when "1010" =>

                valid_c(0) <= '1';

            when "1011" =>

                valid_c(0) <= '1';

            when "1100" =>

                valid_c(0) <= '1';

            when "1101" =>

                valid_c(0) <= '1';

            when "1110" =>

                valid_c(0) <= '1';

            when "1111" =>

                valid_c(0) <= '1';

            when others =>

                valid_c(0) <= '0';

        end case;

    end process;


    -- Lane 1

    process (PREVIOUS_STAGE_VALID(0 to 3))

    begin

        case PREVIOUS_STAGE_VALID(0 to 3) is

            when "0011" =>

                valid_c(1) <= '1';

            when "0101" =>

                valid_c(1) <= '1';

            when "0110" =>

                valid_c(1) <= '1';

            when "0111" =>

                valid_c(1) <= '1';

            when "1001" =>

                valid_c(1) <= '1';

            when "1010" =>

                valid_c(1) <= '1';

            when "1011" =>

                valid_c(1) <= '1';

            when "1100" =>

                valid_c(1) <= '1';

            when "1101" =>

                valid_c(1) <= '1';

            when "1110" =>

                valid_c(1) <= '1';

            when "1111" =>

                valid_c(1) <= '1';

            when others =>

                valid_c(1) <= '0';

        end case;

    end process;


    -- Lane 2

    process (PREVIOUS_STAGE_VALID(0 to 3))

    begin

        case PREVIOUS_STAGE_VALID(0 to 3) is

            when "0111" =>

                valid_c(2) <= '1';

            when "1011" =>

                valid_c(2) <= '1';

            when "1101" =>

                valid_c(2) <= '1';

            when "1110" =>

                valid_c(2) <= '1';

            when "1111" =>

                valid_c(2) <= '1';

            when others =>

                valid_c(2) <= '0';

        end case;

    end process;


    -- Lane 3

    process (PREVIOUS_STAGE_VALID(0 to 3))

    begin

        case PREVIOUS_STAGE_VALID(0 to 3) is

            when "1111" =>

                valid_c(3) <= '1';

            when others =>

                valid_c(3) <= '0';

        end case;

    end process;


    -- Register the valid signals for the next stage.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (RESET = '1') then

                VALID_Buffer <= (others => '0') after DLY;

            else

                VALID_Buffer <= valid_c after DLY;

            end if;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/16 00:32:43 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: lane_init_sm_v4_4byte_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.2 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone, N. Jayarajan
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  LANE_INIT_SM_4BYTE
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: This logic manages the initialization of the MGT in 2-byte mode.
--               It consists of a small state machine, a set of counters for
--               tracking the progress of initializtion and detecting problems,
--               and some additional support logic.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.AURORA.all;

entity LANE_INIT_SM_4BYTE is
    generic (
            EXTEND_WATCHDOGS  : boolean := FALSE
    );
    port (

    -- MGT Interface

            RX_NOT_IN_TABLE     : in std_logic_vector(3 downto 0); -- MGT received invalid 10b code
            RX_DISP_ERR         : in std_logic_vector(3 downto 0); -- MGT received 10b code w/ wrong disparity
            RX_CHAR_IS_COMMA    : in std_logic_vector(3 downto 0); -- MGT received a Comma
            RX_REALIGN          : in std_logic;                    -- MGT had to change alignment due to new comma
            RX_RESET            : out std_logic;                   -- Reset the RX side of the MGT
            TX_RESET            : out std_logic;                   -- Reset the TX side of the MGT
            RX_POLARITY         : out std_logic;                   -- Sets polarity used to interpet rx'ed symbols

    -- Comma Detect Phase Alignment Interface

            ENA_COMMA_ALIGN     : out std_logic;                   -- Turn on SERDES Alignment in MGT

    -- Symbol Generator Interface

            GEN_SP              : out std_logic;                   -- Generate SP symbol
            GEN_SPA             : out std_logic;                   -- Generate SPA symbol

    -- Symbol Decoder Interface

            RX_SP               : in std_logic;                    -- Lane rx'ed SP sequence w/ + or - data
            RX_SPA              : in std_logic;                    -- Lane rx'ed SPA sequence
            RX_NEG              : in std_logic;                    -- Lane rx'ed inverted SP or SPA data
            DO_WORD_ALIGN       : out std_logic;                   -- Enable word alignment

    -- Error Detection Logic Interface

            ENABLE_ERROR_DETECT : out std_logic;                   -- Turn on Soft Error detection
            HARD_ERROR_RESET    : in std_logic;                    -- Reset lane due to hard error

    -- Global Logic Interface

            LANE_UP             : out std_logic;                   -- Lane is initialized

    -- System Interface

            USER_CLK            : in std_logic;                    -- Clock for all non-MGT Aurora logic
            RESET               : in std_logic                     -- Reset Aurora Lane

         );

end LANE_INIT_SM_4BYTE;

architecture RTL of LANE_INIT_SM_4BYTE is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal RX_RESET_Buffer            : std_logic;
    signal TX_RESET_Buffer            : std_logic;
    signal RX_POLARITY_Buffer         : std_logic;
    signal ENA_COMMA_ALIGN_Buffer     : std_logic;
    signal GEN_SP_Buffer              : std_logic;
    signal GEN_SPA_Buffer             : std_logic;
    signal DO_WORD_ALIGN_Buffer       : std_logic;
    signal ENABLE_ERROR_DETECT_Buffer : std_logic;
    signal LANE_UP_Buffer             : std_logic;

-- Internal Register Declarations --

    -- counter1 is intitialized to ensure that the counter comes up at some value other than X.
    -- We have tried different initial values and it does not matter what the value is, as long
    -- as it is not X since X breaks the state machine
    signal counter1_r             : unsigned(0 to 7) := "00000001";
    signal counter2_r             : std_logic_vector(0 to 15);
    signal counter3_r             : std_logic_vector(0 to 3);
    signal counter4_r             : std_logic_vector(0 to 15);
    signal counter5_r             : std_logic_vector(0 to 15);
    signal rx_polarity_r          : std_logic := '0';
    signal prev_char_was_comma_r  : std_logic;
    signal consecutive_commas_r   : std_logic;
    signal prev_count_128d_done_r : std_logic;
    signal extend_r               : std_logic_vector(0 to 31) := X"00000000";
    signal extend_n_r             : std_logic;    
    signal do_watchdog_count_r    : std_logic;

    -- FSM states, encoded for one-hot implementation.

    signal rst_r      : std_logic; -- Reset MGTs
    signal align_r    : std_logic; -- Align SERDES
    signal realign_r  : std_logic; -- Verify no spurious realignment
    signal polarity_r : std_logic; -- Verify polarity of rx'ed symbols
    signal ack_r      : std_logic; -- Ack initialization with partner
    signal ready_r    : std_logic; -- Lane ready for Bonding/Verification

-- Wire Declarations --

    signal count_8d_done_r              : std_logic;
    signal count_32d_done_r             : std_logic;
    signal count_128d_done_r            : std_logic;
    signal reset_count_c                : std_logic;
    signal symbol_error_c               : std_logic;
    signal txack_16d_done_r             : std_logic;
    signal rxack_4d_done_r              : std_logic;
    signal sp_polarity_c                : std_logic;
    signal inc_count_c                  : std_logic;
    signal change_in_state_c            : std_logic;
    signal extend_n_c                   : std_logic;    
    signal watchdog_done_r              : std_logic;
    signal remote_reset_watchdog_done_r : std_logic;

    signal next_rst_c      : std_logic;
    signal next_align_c    : std_logic;
    signal next_realign_c  : std_logic;
    signal next_polarity_c : std_logic;
    signal next_ack_c      : std_logic;
    signal next_ready_c    : std_logic;

begin

    RX_RESET            <= RX_RESET_Buffer;
    TX_RESET            <= TX_RESET_Buffer;
    RX_POLARITY         <= RX_POLARITY_Buffer;
    ENA_COMMA_ALIGN     <= ENA_COMMA_ALIGN_Buffer;
    GEN_SP              <= GEN_SP_Buffer;
    GEN_SPA             <= GEN_SPA_Buffer;
    DO_WORD_ALIGN       <= DO_WORD_ALIGN_Buffer;
    ENABLE_ERROR_DETECT <= ENABLE_ERROR_DETECT_Buffer;
    LANE_UP             <= LANE_UP_Buffer;

-- Main Body of Code --

    -- Main state machine for managing initialization --

    -- State registers

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RESET or HARD_ERROR_RESET) = '1') then

                rst_r      <= '1' after DLY;
                align_r    <= '0' after DLY;
                realign_r  <= '0' after DLY;
                polarity_r <= '0' after DLY;
                ack_r      <= '0' after DLY;
                ready_r    <= '0' after DLY;

            else

                rst_r      <= next_rst_c after DLY;
                align_r    <= next_align_c after DLY;
                realign_r  <= next_realign_c after DLY;
                polarity_r <= next_polarity_c after DLY;
                ack_r      <= next_ack_c after DLY;
                ready_r    <= next_ready_c after DLY;

            end if;

        end if;

    end process;

    -- Next state logic

    next_rst_c      <= (rst_r and not count_8d_done_r) or
                       (realign_r and RX_REALIGN) or
                       (polarity_r and not sp_polarity_c) or
                       (ack_r and watchdog_done_r) or
                       (ready_r and remote_reset_watchdog_done_r);


    next_align_c    <= (rst_r and count_8d_done_r) or
                       (align_r and not count_128d_done_r);


    next_realign_c  <= (align_r and count_128d_done_r) or
                       ((realign_r and not count_32d_done_r) and not RX_REALIGN);


    next_polarity_c <= ((realign_r and count_32d_done_r) and not RX_REALIGN);


    next_ack_c      <= (polarity_r and sp_polarity_c) or
                       ((ack_r and (not txack_16d_done_r or not rxack_4d_done_r)) and not watchdog_done_r);


    next_ready_c    <= (ack_r and txack_16d_done_r and rxack_4d_done_r and not watchdog_done_r) or
                       (ready_r and not remote_reset_watchdog_done_r);


    -- Output Logic

    -- Enable comma align when in the ALIGN state.

    ENA_COMMA_ALIGN_Buffer <= align_r;


    -- Hold RX_RESET when in the RST state.

    RX_RESET_Buffer <= rst_r;


    -- Hold TX_RESET when in the RST state.

    TX_RESET_Buffer <= rst_r;


    -- LANE_UP is asserted when in the READY state.

    LANE_UP_Buffer <= ready_r;


    -- ENABLE_ERROR_DETECT is asserted when in the ACK or READY states. Asserting
    -- it earlier will result in too many false errors. After it is asserted,
    -- higher level modules can respond to Hard Errors by resetting the Aurora Lane.
    -- We register the signal before it leaves the lane_init_sm submodule.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            ENABLE_ERROR_DETECT_Buffer <= ack_r or ready_r after DLY;

        end if;

    end process;


    -- The Aurora Lane should transmit SP sequences when not ACKing or Ready.

    GEN_SP_Buffer <= not (ack_r or ready_r);


    -- The Aurora Lane transmits SPA sequences while in the ACK state.

    GEN_SPA_Buffer <= ack_r;


    -- Do word alignment in the ALIGN state and then again in the ready state.  Align
    -- state word alignment makes SP and SPA decodes less expensive.  Ready state word
    -- alignment is needed to correct any shifts due to channel bonding : it runs
    -- until it is shut off by arrival of the first /V/ sequence in the sym_dec module.

    DO_WORD_ALIGN_Buffer <= align_r or ready_r;


    -- Counter 1, for reset cycles, align cycles and realign cycles --

    -- Core of the counter.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (reset_count_c = '1') then

                counter1_r <= "00000001" after DLY;

            else

                if (inc_count_c = '1') then

                    counter1_r <= counter1_r + "00000001" after DLY;

                end if;

            end if;

        end if;

    end process;


    -- Assert count_8d_done_r when the 2^4 flop in the register first goes high.

    count_8d_done_r <= counter1_r(4);


    -- Assert count_32d_done_r when the 2^6 flop in the register first goes high.

    count_32d_done_r <= counter1_r(2);


    -- Assert count_128d_done_r when the 2^8 flop in the register first goes high.

    count_128d_done_r <= counter1_r(0);


    -- The counter resets any time the RESET signal is asserted, there is a change in
    -- state, there is a symbol error, or commas are not consecutive in the align state.

    reset_count_c <= RESET or change_in_state_c or symbol_error_c or not consecutive_commas_r;


    -- The counter should be reset when entering and leaving the reset state.

    change_in_state_c <= std_bool(rst_r /= next_rst_c);


    -- Symbol error is asserted whenever there is a disparity error or an invalid
    -- 10b code.

    symbol_error_c <= std_bool((RX_DISP_ERR /= "0000") or (RX_NOT_IN_TABLE /= "0000"));


    -- Previous cycle comma is used to check for consecutive commas.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            prev_char_was_comma_r <= std_bool(RX_CHAR_IS_COMMA /= "0000") after DLY;

        end if;

    end process;


    -- Check to see that commas are consecutive in the align state.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            consecutive_commas_r <= std_bool(RX_CHAR_IS_COMMA /= "0000") or not align_r after DLY;

        end if;

    end process;


    -- Increment count is always asserted, except in the ALIGN state when it is asserted
    -- only upon the arrival of a comma character.

    inc_count_c <= not align_r or (align_r and std_bool(RX_CHAR_IS_COMMA /= "0000"));


    -- Counter 2, for counting tx_acks --

    -- This counter is implemented as a shift register.  It is constantly shifting.  As a
    -- result, when the state machine is not in the ack state, the register clears out.
    -- When the state machine goes into the ack state, the count is incremented every
    -- cycle.  The txack_16d_done signal goes high and stays high after 16 cycles in the
    -- ack state.  The signal deasserts only after its had enough time for all the ones
    -- to clear out after the machine leaves the ack state, but this is tolerable because
    -- the machine will spend at least 8 cycles in reset, 256 in ALIGN and 32 in REALIGN.

    -- The counter is implemented seperately from the main counter because it is required
    -- to stop counting when it reaches the end of its count.  Adding this functionality
    -- to the main counter is more expensive and more complex than implementing it seperately.

    -- Counter Logic

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            counter2_r <= ack_r & counter2_r(0 to 14) after DLY;

        end if;

    end process;


    -- The counter is done when a 1 reaches the end of the shift register.

    txack_16d_done_r <= counter2_r(15);


    -- Counter 3, for counting rx_acks --

    -- This counter is also implemented as a shift register.  It is always shifting when
    -- the state machine is not in the ack state to clear it out.  When the state machine
    -- goes into the ack state, the register shifts only when a SPA is received.  When
    -- 4 SPAs have been received in the ACK state, the rxack_4d_done_r signal is triggered.

    -- This counter is implemented seperately from the main counter because it is required
    -- to increment only when ACKs are received, and then hold its count.  Adding this
    -- functionality to the main counter is more expensive than creating a second counter,
    -- and more complex.

    -- Counter Logic

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RX_SPA or not ack_r) = '1') then

                counter3_r <= ack_r & counter3_r(0 to 2) after DLY;

            end if;

        end if;

    end process;


    -- The counter is done when a 1 reaches the end of the shift register.

    rxack_4d_done_r <= counter3_r(3);


    -- Counter 4, remote reset watchdog timer --

    -- Another counter implemented as a shift register.  This counter puts an upper
    -- limit on the number of SPs that can be recieved in the Ready state.  If the
    -- number of SPs exceeds the limit, the Aurora Lane resets itself.  The Global
    -- logic module will reset all the lanes if this occurs while they are all in
    -- the lane ready state (ie lane_up is asserted for all).

    -- Counter logic

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RX_SP or not ready_r) = '1') then

                counter4_r <= ready_r & counter4_r(0 to 14) after DLY;

            end if;

        end if;

    end process;


    -- The counter is done when a 1 reaches the end of the shift register.

    remote_reset_watchdog_done_r <= counter4_r(15);


    -- Counter 5, internal watchdog timer --

    -- This counter puts an upper limit on the number of cycles the state machine can
    -- spend in the ack state before it gives up and resets.

    -- The counter is implemented as a shift register extending counter 1.  The counter
    -- clears out in all non-ack cycles by keeping CE asserted.  When it gets into the
    -- ack state, CE is asserted only when there is a transition on the most
    -- significant bit of counter 1.  This happens every 128 cycles.  We count out 32 of
    -- these transitions to get a count of approximately 4096 cycles.  The actual
    -- number of cycles is less than this because we don't reset counter1, so it
    -- starts off about 34 cycles into its count.

    -- Counter logic

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((do_watchdog_count_r or not ack_r) = '1') then

                counter5_r <= ack_r & counter5_r(0 to 14) after DLY;

            end if;

        end if;

    end process;


    -- Store the count_128d_done_r result from the previous cycle.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            prev_count_128d_done_r <= count_128d_done_r after DLY;

        end if;

    end process;


    -- Trigger CE only when the previous 128d_done is not the same as the
    -- current one, and the current value is high.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            do_watchdog_count_r <= count_128d_done_r and not prev_count_128d_done_r after DLY;

        end if;

    end process;


    -- The counter is done when bit 15 is high.

    watchdog_done_r <= counter5_r(15);


    -- Polarity Control --

    -- sp_polarity_c, is low if neg symbols received, otherwise high.

    sp_polarity_c <= not RX_NEG;


    -- The Polarity flop drives the polarity setting of the MGT.  We initialize it for the
    -- sake of simulation.  We Initialize it after configuration for the hardware version.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((polarity_r and not sp_polarity_c) = '1') then

                rx_polarity_r <= not rx_polarity_r after DLY;

            end if;

        end if;

    end process;


    -- Drive the rx_polarity register value on the interface.

    RX_POLARITY_Buffer <= rx_polarity_r;

end RTL;
-------------------------------------------------------------------------------
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/12/19 20:20:55 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: mgt_wrapper_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.18 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone, N. Jayarajan
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--   __  __ 
--  /   /\/   / 
-- /__/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 1.0
--  \   \         Application : RocketIO Wizard 
--  /   /         Filename : mgt_wrapper.vhd
-- /__/   /\     Timestamp : 02/08/2005 09:12:43
-- \   \  /  \ 
--  \__\/\__\ 
--
--
-- Module MGT_WRAPPER 
-- Generated by Xilinx RocketIO Wizard, generation mechanism modified for COREGen Aurora

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- synopsys translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- synopsys translate_on

--***************************** Entity Declaration *****************************
entity MGT_WRAPPER is
generic
(
    SIMULATION_P      : integer := 0;        -- Set to 1 when using module in simulation
    TX_FD_MIN_P       : std_logic_vector(8 downto 0) := "001111101"; -- Floor (128*Ttxoutclk1/Tdclk) - 3
    TX_FD_EN_P        : std_logic := '1'; -- 1 = enable calblock TX frequency test
    RX_FD_MIN_P       : std_logic_vector(8 downto 0) := "001111101"; -- Floor (128*Trxrecclk1/Tdclk) - 3
    RX_FD_EN_P        : std_logic := '1'; -- 1 = enable calblock RX frequency test
    LANE0_GT11_MODE_P : string := "B";        -- Set based on locations chosen in Aurora Core Customization GUI  
    LANE0_MGT_ID_P    : integer := 1;          -- 0=A, 1=B
    LANE1_GT11_MODE_P : string := "A";        -- Set based on locations chosen in Aurora Core Customization GUI  
    LANE1_MGT_ID_P    : integer := 0;          -- 0=A, 1=B
    
    TX_FD_WIDTH_P     : integer := 9;       -- TX Fdetect MIN value width
    RX_FD_WIDTH_P     : integer := 9;       -- RX Fdetect MIN value width
    DCLK_PERIOD_NS_P  : integer := 20;      -- Integer period between 20ns and 40ns (50Mhz to 25Mhz). Default is 20 ns
    TXPOST_TAP_PD_P   : boolean := FALSE  -- Default is false, set to true for serial loopback or tuned preemphasis    
);
port 
(

    --__________________________________________________________________________
    --__________________________________________________________________________
    --MGT0
    
    ----------------- 8B10B Receive Data Path and Control Ports ----------------
    MGT0_RXCHARISCOMMA_OUT                  :   out   std_logic_vector(3 downto 0);
    MGT0_RXCHARISK_OUT                      :   out   std_logic_vector(3 downto 0);
    MGT0_RXDATA_OUT                         :   out   std_logic_vector(31 downto 0);
    MGT0_RXDISPERR_OUT                      :   out   std_logic_vector(3 downto 0);
    MGT0_RXNOTINTABLE_OUT                   :   out   std_logic_vector(3 downto 0);
    MGT0_RXRUNDISP_OUT                      :   out   std_logic_vector(3 downto 0);
    ----------------- 8B10B Transmit Data Path and Control Ports ---------------
    MGT0_TXBYPASS8B10B_IN                   :   in    std_logic_vector(3 downto 0);
    MGT0_TXCHARDISPMODE_IN                  :   in    std_logic_vector(3 downto 0);
    MGT0_TXCHARDISPVAL_IN                   :   in    std_logic_vector(3 downto 0);
    MGT0_TXCHARISK_IN                       :   in    std_logic_vector(3 downto 0);
    MGT0_TXDATA_IN                          :   in    std_logic_vector(31 downto 0);
    MGT0_TXKERR_OUT                         :   out   std_logic_vector(3 downto 0);
    MGT0_TXRUNDISP_OUT                      :   out   std_logic_vector(3 downto 0);
    -------------------------- Calibration Block Ports -------------------------
    MGT0_ACTIVE_OUT                         :   out   std_logic;
    MGT0_DISABLE_IN                         :   in    std_logic;
    MGT0_DRP_RESET_IN                       :   in    std_logic;
    MGT0_RX_SIGNAL_DETECT_IN                :   in    std_logic;
    MGT0_TX_SIGNAL_DETECT_IN                :   in    std_logic;
    --------------------------- Channel Bonding Ports --------------------------
    MGT0_ENCHANSYNC_IN                      :   in    std_logic;
    --------------------- Dynamic Reconfiguration Port (DRP) -------------------
    MGT0_DCLK_IN                            :   in    std_logic;
    -------------------------------- Global Ports ------------------------------
    MGT0_POWERDOWN_IN                       :   in    std_logic;
    MGT0_TXINHIBIT_IN                       :   in    std_logic;
    ---------------------------------- PLL Lock --------------------------------
    MGT0_RXLOCK_OUT                         :   out   std_logic;
    MGT0_TXLOCK_OUT                         :   out   std_logic;
    --------------------------- Polarity Control Ports -------------------------
    MGT0_RXPOLARITY_IN                      :   in    std_logic;
    MGT0_TXPOLARITY_IN                      :   in    std_logic;
    ---------------------------- Ports for Simulation --------------------------
    MGT0_COMBUSIN_IN                        :   in    std_logic_vector(15 downto 0);
    MGT0_COMBUSOUT_OUT                      :   out   std_logic_vector(15 downto 0);
    ------------------------------ Reference Clocks ----------------------------
    MGT0_GREFCLK_IN                         :   in    std_logic;
    MGT0_REFCLK1_IN                         :   in    std_logic;
    MGT0_REFCLK2_IN                         :   in    std_logic;
    ----------------------------------- Resets ---------------------------------
    MGT0_RXPMARESET_IN                      :   in    std_logic;
    MGT0_RXRESET_IN                         :   in    std_logic;
    MGT0_TXPMARESET_IN                      :   in    std_logic;
    MGT0_TXRESET_IN                         :   in    std_logic;
    ------------------------------ Serdes Alignment ----------------------------
    MGT0_ENMCOMMAALIGN_IN                   :   in    std_logic;
    MGT0_ENPCOMMAALIGN_IN                   :   in    std_logic;
    MGT0_RXREALIGN_OUT                      :   out   std_logic;
    -------------------------------- Serial Ports ------------------------------
    MGT0_RX1N_IN                            :   in    std_logic;
    MGT0_RX1P_IN                            :   in    std_logic;
    MGT0_TX1N_OUT                           :   out   std_logic;
    MGT0_TX1P_OUT                           :   out   std_logic;
    ----------------------------------- Status ---------------------------------
    MGT0_RXBUFERR_OUT                       :   out   std_logic;
    MGT0_RXSTATUS_OUT                       :   out   std_logic_vector(5 downto 0);
    MGT0_TXBUFERR_OUT                       :   out   std_logic;
    -------------------------------- User Clocks -------------------------------
    MGT0_RXRECCLK1_OUT                      :   out   std_logic;
    MGT0_RXRECCLK2_OUT                      :   out   std_logic;
    MGT0_RXUSRCLK_IN                        :   in    std_logic;
    MGT0_RXUSRCLK2_IN                       :   in    std_logic;
    MGT0_TXOUTCLK1_OUT                      :   out   std_logic;
    MGT0_TXOUTCLK2_OUT                      :   out   std_logic;
    MGT0_TXUSRCLK_IN                        :   in    std_logic;
    MGT0_TXUSRCLK2_IN                       :   in    std_logic;
    

    --__________________________________________________________________________
    --__________________________________________________________________________
    --MGT1
    
    ----------------- 8B10B Receive Data Path and Control Ports ----------------
    MGT1_RXCHARISCOMMA_OUT                  :   out   std_logic_vector(3 downto 0);
    MGT1_RXCHARISK_OUT                      :   out   std_logic_vector(3 downto 0);
    MGT1_RXDATA_OUT                         :   out   std_logic_vector(31 downto 0);
    MGT1_RXDISPERR_OUT                      :   out   std_logic_vector(3 downto 0);
    MGT1_RXNOTINTABLE_OUT                   :   out   std_logic_vector(3 downto 0);
    MGT1_RXRUNDISP_OUT                      :   out   std_logic_vector(3 downto 0);
    ----------------- 8B10B Transmit Data Path and Control Ports ---------------
    MGT1_TXBYPASS8B10B_IN                   :   in    std_logic_vector(3 downto 0);
    MGT1_TXCHARDISPMODE_IN                  :   in    std_logic_vector(3 downto 0);
    MGT1_TXCHARDISPVAL_IN                   :   in    std_logic_vector(3 downto 0);
    MGT1_TXCHARISK_IN                       :   in    std_logic_vector(3 downto 0);
    MGT1_TXDATA_IN                          :   in    std_logic_vector(31 downto 0);
    MGT1_TXKERR_OUT                         :   out   std_logic_vector(3 downto 0);
    MGT1_TXRUNDISP_OUT                      :   out   std_logic_vector(3 downto 0);
    -------------------------- Calibration Block Ports -------------------------
    MGT1_ACTIVE_OUT                         :   out   std_logic;
    MGT1_DISABLE_IN                         :   in    std_logic;
    MGT1_DRP_RESET_IN                       :   in    std_logic;
    MGT1_RX_SIGNAL_DETECT_IN                :   in    std_logic;
    MGT1_TX_SIGNAL_DETECT_IN                :   in    std_logic;
    --------------------------- Channel Bonding Ports --------------------------
    MGT1_ENCHANSYNC_IN                      :   in    std_logic;
    --------------------- Dynamic Reconfiguration Port (DRP) -------------------
    MGT1_DCLK_IN                            :   in    std_logic;
    -------------------------------- Global Ports ------------------------------
    MGT1_POWERDOWN_IN                       :   in    std_logic;
    MGT1_TXINHIBIT_IN                       :   in    std_logic;
    ---------------------------------- PLL Lock --------------------------------
    MGT1_RXLOCK_OUT                         :   out   std_logic;
    MGT1_TXLOCK_OUT                         :   out   std_logic;
    --------------------------- Polarity Control Ports -------------------------
    MGT1_RXPOLARITY_IN                      :   in    std_logic;
    MGT1_TXPOLARITY_IN                      :   in    std_logic;
    ---------------------------- Ports for Simulation --------------------------
    MGT1_COMBUSIN_IN                        :   in    std_logic_vector(15 downto 0);
    MGT1_COMBUSOUT_OUT                      :   out   std_logic_vector(15 downto 0);
    ------------------------------ Reference Clocks ----------------------------
    MGT1_GREFCLK_IN                         :   in    std_logic;
    MGT1_REFCLK1_IN                         :   in    std_logic;
    MGT1_REFCLK2_IN                         :   in    std_logic;
    ----------------------------------- Resets ---------------------------------
    MGT1_RXPMARESET_IN                      :   in    std_logic;
    MGT1_RXRESET_IN                         :   in    std_logic;
    MGT1_TXPMARESET_IN                      :   in    std_logic;
    MGT1_TXRESET_IN                         :   in    std_logic;
    ------------------------------ Serdes Alignment ----------------------------
    MGT1_ENMCOMMAALIGN_IN                   :   in    std_logic;
    MGT1_ENPCOMMAALIGN_IN                   :   in    std_logic;
    MGT1_RXREALIGN_OUT                      :   out   std_logic;
    -------------------------------- Serial Ports ------------------------------
    MGT1_RX1N_IN                            :   in    std_logic;
    MGT1_RX1P_IN                            :   in    std_logic;
    MGT1_TX1N_OUT                           :   out   std_logic;
    MGT1_TX1P_OUT                           :   out   std_logic;
    ----------------------------------- Status ---------------------------------
    MGT1_RXBUFERR_OUT                       :   out   std_logic;
    MGT1_RXSTATUS_OUT                       :   out   std_logic_vector(5 downto 0);
    MGT1_TXBUFERR_OUT                       :   out   std_logic;
    -------------------------------- User Clocks -------------------------------
    MGT1_RXRECCLK1_OUT                      :   out   std_logic;
    MGT1_RXRECCLK2_OUT                      :   out   std_logic;
    MGT1_RXUSRCLK_IN                        :   in    std_logic;
    MGT1_RXUSRCLK2_IN                       :   in    std_logic;
    MGT1_TXOUTCLK1_OUT                      :   out   std_logic;
    MGT1_TXOUTCLK2_OUT                      :   out   std_logic;
    MGT1_TXUSRCLK_IN                        :   in    std_logic;
    MGT1_TXUSRCLK2_IN                       :   in    std_logic
    
);
end MGT_WRAPPER;

architecture BEHAVIORAL of MGT_WRAPPER is

--************************** Parameter Declarations ****************************

    constant RXDATAWIDTH_P                  :   std_logic_vector    :=  "10";
    constant TXDATAWIDTH_P                  :   std_logic_vector    :=  "10";
    constant RXINTDATAWIDTH_P               :   std_logic_vector    :=  "11";
    constant TXINTDATAWIDTH_P               :   std_logic_vector    :=  "11";


--***************************** Signal Declarations *****************************

    -- ground and tied_to_vcc_i signals
    signal  tied_to_ground_i                :   std_logic;
    signal  tied_to_ground_vec_i            :   std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   :   std_logic;
    signal  tied_to_vcc_vec_i               :   std_logic_vector(63 downto 0);

    -- channel bond signals
    signal  mgt0_chbondo_i                  :   std_logic_vector(4 downto 0);

    -- calblock connection signals
    signal  mgt0_daddr_i                    :   std_logic_vector(7 downto 0);
    signal  mgt0_den_i                      :   std_logic;
    signal  mgt0_di_i                       :   std_logic_vector(15 downto 0);
    signal  mgt0_do_i                       :   std_logic_vector(15 downto 0);
    signal  mgt0_drdy_i                     :   std_logic;
    signal  mgt0_dwe_i                      :   std_logic;
    signal  mgt0_rxlock_i                   :   std_logic;
    signal  mgt0_txlock_i                   :   std_logic;
    signal  mgt0_loopback_i                 :   std_logic_vector(1 downto 0);
    signal  mgt0_txenc8b10buse_i            :   std_logic;
    signal  mgt0_txbypass8b10b_i            :   std_logic_vector(7 downto 0);
    signal  mgt0_rxpmareset_i               :   std_logic;
    signal  mgt0_txpmareset_i               :   std_logic;
    signal  mgt0_txoutclk1_i                :   std_logic;
    signal  mgt0_rxrecclk2_i                :   std_logic;
    signal  mgt0_txoutclk1_buf_i            :   std_logic;
    signal  mgt0_rxrecclk2_buf_i            :   std_logic;

    --Floating wires for unused sections of MGT bus
    signal  mgt0_rxchariscomma_out_float_i  :   std_logic_vector(3 downto 0);
    signal  mgt0_rxcharisk_out_float_i      :   std_logic_vector(3 downto 0);
    signal  mgt0_rxdata_out_float_i         :   std_logic_vector(31 downto 0);
    signal  mgt0_rxdisperr_out_float_i      :   std_logic_vector(3 downto 0);
    signal  mgt0_rxnotintable_out_float_i   :   std_logic_vector(3 downto 0);
    signal  mgt0_rxrundisp_out_float_i      :   std_logic_vector(3 downto 0);
    signal  mgt0_txkerr_out_float_i         :   std_logic_vector(3 downto 0);
    signal  mgt0_txrundisp_out_float_i      :   std_logic_vector(3 downto 0);

    -- channel bond signals
    signal  mgt1_chbondo_i                  :   std_logic_vector(4 downto 0);

    -- calblock connection signals
    signal  mgt1_daddr_i                    :   std_logic_vector(7 downto 0);
    signal  mgt1_den_i                      :   std_logic;
    signal  mgt1_di_i                       :   std_logic_vector(15 downto 0);
    signal  mgt1_do_i                       :   std_logic_vector(15 downto 0);
    signal  mgt1_drdy_i                     :   std_logic;
    signal  mgt1_dwe_i                      :   std_logic;
    signal  mgt1_rxlock_i                   :   std_logic;
    signal  mgt1_txlock_i                   :   std_logic;
    signal  mgt1_loopback_i                 :   std_logic_vector(1 downto 0);
    signal  mgt1_txenc8b10buse_i            :   std_logic;
    signal  mgt1_txbypass8b10b_i            :   std_logic_vector(7 downto 0);
    signal  mgt1_rxpmareset_i               :   std_logic;
    signal  mgt1_txpmareset_i               :   std_logic;
    signal  mgt1_txoutclk1_i                :   std_logic;
    signal  mgt1_rxrecclk2_i                :   std_logic;
    signal  mgt1_txoutclk1_buf_i            :   std_logic;
    signal  mgt1_rxrecclk2_buf_i            :   std_logic;

    --Floating wires for unused sections of MGT bus
    signal  mgt1_rxchariscomma_out_float_i  :   std_logic_vector(3 downto 0);
    signal  mgt1_rxcharisk_out_float_i      :   std_logic_vector(3 downto 0);
    signal  mgt1_rxdata_out_float_i         :   std_logic_vector(31 downto 0);
    signal  mgt1_rxdisperr_out_float_i      :   std_logic_vector(3 downto 0);
    signal  mgt1_rxnotintable_out_float_i   :   std_logic_vector(3 downto 0);
    signal  mgt1_rxrundisp_out_float_i      :   std_logic_vector(3 downto 0);
    signal  mgt1_txkerr_out_float_i         :   std_logic_vector(3 downto 0);
    signal  mgt1_txrundisp_out_float_i      :   std_logic_vector(3 downto 0);



--**************************** Component Declarations ***************************


    component GT11
    generic
    ( 
        ALIGN_COMMA_WORD        : integer    :=  1;
        BANDGAPSEL              : boolean    :=  FALSE;
        BIASRESSEL              : boolean    :=  TRUE;
        CCCB_ARBITRATOR_DISABLE : boolean    :=  FALSE;
        CHAN_BOND_LIMIT         : integer    :=  16;
        CHAN_BOND_MODE          : string     :=  "NONE";
        CHAN_BOND_ONE_SHOT      : boolean    :=  FALSE;
        CHAN_BOND_SEQ_1_1       : bit_vector :=  "00000000000";
        CHAN_BOND_SEQ_1_2       : bit_vector :=  "00000000000";
        CHAN_BOND_SEQ_1_3       : bit_vector :=  "00000000000";
        CHAN_BOND_SEQ_1_4       : bit_vector :=  "00000000000";
        CHAN_BOND_SEQ_1_MASK    : bit_vector :=  "0000";
        CHAN_BOND_SEQ_2_1       : bit_vector :=  "00000000000";
        CHAN_BOND_SEQ_2_2       : bit_vector :=  "00000000000";
        CHAN_BOND_SEQ_2_3       : bit_vector :=  "00000000000";
        CHAN_BOND_SEQ_2_4       : bit_vector :=  "00000000000";
        CHAN_BOND_SEQ_2_MASK    : bit_vector :=  "0000";
        CHAN_BOND_SEQ_2_USE     : boolean    :=  FALSE;
        CHAN_BOND_SEQ_LEN       : integer    :=  1;
        CLK_COR_8B10B_DE        : boolean    :=  FALSE;
        CLK_COR_MAX_LAT         : integer    :=  48;
        CLK_COR_MIN_LAT         : integer    :=  36;
        CLK_COR_SEQ_1_1         : bit_vector :=  "00000000000";
        CLK_COR_SEQ_1_2         : bit_vector :=  "00000000000";
        CLK_COR_SEQ_1_3         : bit_vector :=  "00000000000";
        CLK_COR_SEQ_1_4         : bit_vector :=  "00000000000";
        CLK_COR_SEQ_1_MASK      : bit_vector :=  "0000";
        CLK_COR_SEQ_2_1         : bit_vector :=  "00000000000";
        CLK_COR_SEQ_2_2         : bit_vector :=  "00000000000";
        CLK_COR_SEQ_2_3         : bit_vector :=  "00000000000";
        CLK_COR_SEQ_2_4         : bit_vector :=  "00000000000";
        CLK_COR_SEQ_2_MASK      : bit_vector :=  "0000";
        CLK_COR_SEQ_2_USE       : boolean    :=  FALSE;
        CLK_COR_SEQ_DROP        : boolean    :=  FALSE;
        CLK_COR_SEQ_LEN         : integer    :=  1;
        CLK_CORRECT_USE         : boolean    :=  TRUE;
        COMMA_10B_MASK          : bit_vector :=  x"3FF";
        COMMA32                 : boolean    :=  FALSE;
        CYCLE_LIMIT_SEL         : bit_vector :=  "00";
        DCDR_FILTER             : bit_vector :=  "010";
        DEC_MCOMMA_DETECT       : boolean    :=  TRUE;
        DEC_PCOMMA_DETECT       : boolean    :=  TRUE;
        DEC_VALID_COMMA_ONLY    : boolean    :=  TRUE;
        DIGRX_FWDCLK            : bit_vector :=  "00";
        DIGRX_SYNC_MODE         : boolean    :=  FALSE;
        ENABLE_DCDR             : boolean    :=  FALSE;
        FDET_HYS_CAL            : bit_vector :=  "110";
        FDET_HYS_SEL            : bit_vector :=  "110";
        FDET_LCK_CAL            : bit_vector :=  "101";
        FDET_LCK_SEL            : bit_vector :=  "101";
        GT11_MODE               : string     :=  "DONT_CARE";
        IREFBIASMODE            : bit_vector :=  "11";
        LOOPCAL_WAIT            : bit_vector :=  "00";
        MCOMMA_32B_VALUE        : bit_vector :=  x"000000F6";
        MCOMMA_DETECT           : boolean    :=  TRUE;
        OPPOSITE_SELECT         : boolean    :=  FALSE;
        PCOMMA_32B_VALUE        : bit_vector :=  x"F6F62828";
        PCOMMA_DETECT           : boolean    :=  TRUE;
        PCS_BIT_SLIP            : boolean    :=  FALSE;
        PMA_BIT_SLIP            : boolean    :=  FALSE;
        PMACLKENABLE            : boolean    :=  TRUE;
        PMACOREPWRENABLE        : boolean    :=  TRUE;
        PMAIREFTRIM             : bit_vector :=  "0111";
        PMAVBGCTRL              : bit_vector :=  "00000";
        PMAVREFTRIM             : bit_vector :=  "0111";
        POWER_ENABLE            : boolean    :=  TRUE;
        REPEATER                : boolean    :=  FALSE;
        RX_BUFFER_USE           : boolean    :=  TRUE;
        RX_CLOCK_DIVIDER        : bit_vector :=  "00";
        RXACTST                 : boolean    :=  FALSE;
        RXAFEEQ                 : bit_vector :=  "000000000";
        RXAFEPD                 : boolean    :=  FALSE;
        RXAFETST                : boolean    :=  FALSE;
        RXAPD                   : boolean    :=  FALSE;
        RXASYNCDIVIDE           : bit_vector :=  "11";
        RXBY_32                 : boolean    :=  TRUE;
        RXCDRLOS                : bit_vector :=  "000000";
        RXCLK0_FORCE_PMACLK     : boolean    :=  FALSE;
        RXCLKMODE               : bit_vector :=  "000010";
        RXCMADJ                 : bit_vector :=  "10";
        RXCPSEL                 : boolean    :=  TRUE;
        RXCPTST                 : boolean    :=  FALSE;
        RXCRCCLOCKDOUBLE        : boolean    :=  FALSE;
        RXCRCENABLE             : boolean    :=  FALSE;
        RXCRCINITVAL            : bit_vector :=  x"00000000";
        RXCRCINVERTGEN          : boolean    :=  FALSE;
        RXCRCSAMECLOCK          : boolean    :=  FALSE;
        RXCTRL1                 : bit_vector :=  x"200";
        RXCYCLE_LIMIT_SEL       : bit_vector :=  "00";
        RXDATA_SEL              : bit_vector :=  "00";
        RXDCCOUPLE              : boolean    :=  FALSE;
        RXDIGRESET              : boolean    :=  FALSE;
        RXDIGRX                 : boolean    :=  FALSE;
        RXEQ                    : bit_vector :=  x"4000000000000000";
        RXFDCAL_CLOCK_DIVIDE    : string     :=  "NONE";
        RXFDET_HYS_CAL          : bit_vector :=  "110";
        RXFDET_HYS_SEL          : bit_vector :=  "110";
        RXFDET_LCK_CAL          : bit_vector :=  "101";
        RXFDET_LCK_SEL          : bit_vector :=  "101";
        RXFECONTROL1            : bit_vector :=  "00";
        RXFECONTROL2            : bit_vector :=  "000";
        RXFETUNE                : bit_vector :=  "01";
        RXLB                    : boolean    :=  FALSE;
        RXLKADJ                 : bit_vector :=  "00000";
        RXLKAPD                 : boolean    :=  FALSE;
        RXLOOPCAL_WAIT          : bit_vector :=  "00";
        RXLOOPFILT              : bit_vector :=  "0111";
        RXOUTDIV2SEL            : integer    :=  1;
        RXPD                    : boolean    :=  FALSE;
        RXPDDTST                : boolean    :=  FALSE;
        RXPLLNDIVSEL            : integer    :=  8;
        RXPMACLKSEL             : string     :=  "REFCLK1";
        RXRCPADJ                : bit_vector :=  "011";
        RXRCPPD                 : boolean    :=  FALSE;
        RXRECCLK1_USE_SYNC      : boolean    :=  FALSE;
        RXRIBADJ                : bit_vector :=  "11";
        RXRPDPD                 : boolean    :=  FALSE;
        RXRSDPD                 : boolean    :=  FALSE;
        RXSLOWDOWN_CAL          : bit_vector :=  "00";
        RXUSRDIVISOR            : integer    :=  1;
        RXVCO_CTRL_ENABLE       : boolean    :=  TRUE;
        RXVCODAC_INIT           : bit_vector :=  "1010000000";
        SAMPLE_8X               : boolean    :=  FALSE;
        SH_CNT_MAX              : integer    :=  64;
        SH_INVALID_CNT_MAX      : integer    :=  16;
        SLOWDOWN_CAL            : bit_vector :=  "00";
        TX_BUFFER_USE           : boolean    :=  TRUE;
        TX_CLOCK_DIVIDER        : bit_vector :=  "00";
        TXABPMACLKSEL           : string     :=  "REFCLK1";
        TXAPD                   : boolean    :=  FALSE;
        TXAREFBIASSEL           : boolean    :=  FALSE;
        TXASYNCDIVIDE           : bit_vector :=  "11";
        TXCLK0_FORCE_PMACLK     : boolean    :=  FALSE;
        TXCLKMODE               : bit_vector :=  "1001";
        TXCPSEL                 : boolean    :=  TRUE;
        TXCRCCLOCKDOUBLE        : boolean    :=  FALSE;
        TXCRCENABLE             : boolean    :=  FALSE;
        TXCRCINITVAL            : bit_vector :=  x"00000000";
        TXCRCINVERTGEN          : boolean    :=  FALSE;
        TXCRCSAMECLOCK          : boolean    :=  FALSE;
        TXCTRL1                 : bit_vector :=  x"200";
        TXDAT_PRDRV_DAC         : bit_vector :=  "111";
        TXDAT_TAP_DAC           : bit_vector :=  "10110";
        TXDATA_SEL              : bit_vector :=  "00";
        TXDIGPD                 : boolean    :=  FALSE;
        TXFDCAL_CLOCK_DIVIDE    : string     :=  "NONE";
        TXHIGHSIGNALEN          : boolean    :=  TRUE;
        TXLOOPFILT              : bit_vector :=  "0111";
        TXLVLSHFTPD             : boolean    :=  FALSE;
        TXOUTCLK1_USE_SYNC      : boolean    :=  FALSE;
        TXOUTDIV2SEL            : integer    :=  1;
        TXPD                    : boolean    :=  FALSE;
        TXPHASESEL              : boolean    :=  FALSE;
        TXPLLNDIVSEL            : integer    :=  8;
        TXPOST_PRDRV_DAC        : bit_vector :=  "111";
        TXPOST_TAP_DAC          : bit_vector :=  "01110";
        TXPOST_TAP_PD           : boolean    :=  TRUE;
        TXPRE_PRDRV_DAC         : bit_vector :=  "111";
        TXPRE_TAP_DAC           : bit_vector :=  "00000";
        TXPRE_TAP_PD            : boolean    :=  TRUE;
        TXSLEWRATE              : boolean    :=  FALSE;
        TXTERMTRIM              : bit_vector :=  "1100";
        VCO_CTRL_ENABLE         : boolean    :=  TRUE;
        VCODAC_INIT             : bit_vector :=  "1010000000";
        VREFBIASMODE            : bit_vector :=  "11"
    );
    port 
    (   
        CHBONDI                 : in    std_logic_vector (4 downto 0); 
        ENCHANSYNC              : in    std_logic; 
        ENMCOMMAALIGN           : in    std_logic; 
        ENPCOMMAALIGN           : in    std_logic; 
        LOOPBACK                : in    std_logic_vector (1 downto 0); 
        POWERDOWN               : in    std_logic; 
        RXBLOCKSYNC64B66BUSE    : in    std_logic; 
        RXCOMMADETUSE           : in    std_logic; 
        RXDATAWIDTH             : in    std_logic_vector (1 downto 0); 
        RXDEC64B66BUSE          : in    std_logic; 
        RXDEC8B10BUSE           : in    std_logic; 
        RXDESCRAM64B66BUSE      : in    std_logic; 
        RXIGNOREBTF             : in    std_logic; 
        RXINTDATAWIDTH          : in    std_logic_vector (1 downto 0); 
        RXPOLARITY              : in    std_logic; 
        RXRESET                 : in    std_logic; 
        RXSLIDE                 : in    std_logic; 
        RXUSRCLK                : in    std_logic; 
        RXUSRCLK2               : in    std_logic; 
        TXBYPASS8B10B           : in    std_logic_vector (7 downto 0); 
        TXCHARDISPMODE          : in    std_logic_vector (7 downto 0); 
        TXCHARDISPVAL           : in    std_logic_vector (7 downto 0); 
        TXCHARISK               : in    std_logic_vector (7 downto 0); 
        TXDATA                  : in    std_logic_vector (63 downto 0); 
        TXDATAWIDTH             : in    std_logic_vector (1 downto 0); 
        TXENC64B66BUSE          : in    std_logic; 
        TXENC8B10BUSE           : in    std_logic; 
        TXGEARBOX64B66BUSE      : in    std_logic; 
        TXINHIBIT               : in    std_logic; 
        TXINTDATAWIDTH          : in    std_logic_vector (1 downto 0); 
        TXPOLARITY              : in    std_logic; 
        TXRESET                 : in    std_logic; 
        TXSCRAM64B66BUSE        : in    std_logic; 
        TXUSRCLK                : in    std_logic; 
        TXUSRCLK2               : in    std_logic; 
        RXCLKSTABLE             : in    std_logic; 
        RXPMARESET              : in    std_logic; 
        TXCLKSTABLE             : in    std_logic; 
        TXPMARESET              : in    std_logic; 
        RXCRCIN                 : in    std_logic_vector (63 downto 0); 
        RXCRCDATAWIDTH          : in    std_logic_vector (2 downto 0); 
        RXCRCDATAVALID          : in    std_logic; 
        RXCRCINIT               : in    std_logic; 
        RXCRCRESET              : in    std_logic; 
        RXCRCPD                 : in    std_logic; 
        RXCRCCLK                : in    std_logic; 
        RXCRCINTCLK             : in    std_logic; 
        TXCRCIN                 : in    std_logic_vector (63 downto 0); 
        TXCRCDATAWIDTH          : in    std_logic_vector (2 downto 0); 
        TXCRCDATAVALID          : in    std_logic; 
        TXCRCINIT               : in    std_logic; 
        TXCRCRESET              : in    std_logic; 
        TXCRCPD                 : in    std_logic; 
        TXCRCCLK                : in    std_logic; 
        TXCRCINTCLK             : in    std_logic; 
        TXSYNC                  : in    std_logic; 
        RXSYNC                  : in    std_logic; 
        TXENOOB                 : in    std_logic; 
        DCLK                    : in    std_logic; 
        DADDR                   : in    std_logic_vector (7 downto 0); 
        DEN                     : in    std_logic; 
        DWE                     : in    std_logic; 
        DI                      : in    std_logic_vector (15 downto 0); 
        RX1P                    : in    std_logic; 
        RX1N                    : in    std_logic; 
        GREFCLK                 : in    std_logic; 
        REFCLK1                 : in    std_logic; 
        REFCLK2                 : in    std_logic; 
        CHBONDO                 : out   std_logic_vector (4 downto 0); 
        RXSTATUS                : out   std_logic_vector (5 downto 0); 
        RXCHARISCOMMA           : out   std_logic_vector (7 downto 0); 
        RXCHARISK               : out   std_logic_vector (7 downto 0); 
        RXCOMMADET              : out   std_logic; 
        RXDATA                  : out   std_logic_vector (63 downto 0); 
        RXDISPERR               : out   std_logic_vector (7 downto 0); 
        RXLOSSOFSYNC            : out   std_logic_vector (1 downto 0); 
        RXNOTINTABLE            : out   std_logic_vector (7 downto 0); 
        RXREALIGN               : out   std_logic; 
        RXRUNDISP               : out   std_logic_vector (7 downto 0); 
        RXBUFERR                : out   std_logic; 
        TXBUFERR                : out   std_logic; 
        TXKERR                  : out   std_logic_vector (7 downto 0); 
        TXRUNDISP               : out   std_logic_vector (7 downto 0); 
        RXRECCLK1               : out   std_logic; 
        RXRECCLK2               : out   std_logic; 
        TXOUTCLK1               : out   std_logic; 
        TXOUTCLK2               : out   std_logic; 
        RXLOCK                  : out   std_logic; 
        TXLOCK                  : out   std_logic; 
        RXCYCLELIMIT            : out   std_logic; 
        TXCYCLELIMIT            : out   std_logic; 
        RXCALFAIL               : out   std_logic; 
        TXCALFAIL               : out   std_logic; 
        RXCRCOUT                : out   std_logic_vector (31 downto 0); 
        TXCRCOUT                : out   std_logic_vector (31 downto 0); 
        RXSIGDET                : out   std_logic; 
        DRDY                    : out   std_logic; 
        DO                      : out   std_logic_vector (15 downto 0); 
        RXMCLK                  : out   std_logic; 
        TX1P                    : out   std_logic; 
        TX1N                    : out   std_logic; 
        TXPCSHCLKOUT            : out   std_logic; 
        RXPCSHCLKOUT            : out   std_logic; 
        COMBUSIN                : in    std_logic_vector (15 downto 0); 
        COMBUSOUT               : out   std_logic_vector (15 downto 0)
    );
    end component;              


    component BUF
    port
    (
        I                       : in    std_logic;
        O                       : out   std_logic
    );
    end component;


    component cal_block_v1_2_1
    generic
    (
        C_MGT_ID          : integer := 0;       -- 0 = MGTA | 1 = MGTB
        C_DCLK_PERIOD_NS  : integer := 10;      -- DCLK clock period in NS
        C_SIMULATION      : integer := 0;       -- Set to 1 for simulation
        C_TXOUTDIV2SEL_A  : integer := 1;       -- Default MGTA TX Div
        C_TXOUTDIV2SEL_B  : integer := 1;       -- Default MGTB TX Div
        C_RXOUTDIV2SEL_A  : integer := 1;       -- Default MGTA RX Div
        C_RXOUTDIV2SEL_B  : integer := 1;       -- Default MGTB RX Div
        C_TXPOST_TAP_PD   : string  := "TRUE";  -- Default POST TAP PD
        C_RXDIGRX         : string  := "FALSE"; -- Default RXDIGRX
        C_TX_FD_WIDTH     : integer := 8;       -- TX Fdetect MIN value width
        C_RX_FD_WIDTH     : integer := 8        -- RX Fdetect MIN value width
    );
    port
    (
        -- User DRP Interface (destination/slave interface)
        USER_DO             : out std_logic_vector(16-1 downto 0);
        USER_DI             : in  std_logic_vector(16-1 downto 0);
        USER_DADDR          : in  std_logic_vector(8-1 downto 0);
        USER_DEN            : in  std_logic;
        USER_DWE            : in  std_logic;
        USER_DRDY           : out std_logic;

        -- MGT DRP Interface (source/master interface)
        GT_DO               : out std_logic_vector(16-1 downto 0);
        GT_DI               : in  std_logic_vector(16-1 downto 0);
        GT_DADDR            : out std_logic_vector(8-1 downto 0);
        GT_DEN              : out std_logic;
        GT_DWE              : out std_logic;
        GT_DRDY             : in  std_logic;

        -- DRP Clock and Reset
        DCLK                : in  std_logic;
        RESET               : in  std_logic;

        -- Calibration Block Active and Disable Signals (legacy)
        ACTIVE              : out std_logic;
        DISABLE             : in  std_logic;

        -- User side MGT Pass through Signals 
        USER_RXPMARESET     : in  std_logic;
        USER_RXLOCK         : out std_logic;

        USER_TXPMARESET     : in  std_logic;
        USER_TXLOCK         : out std_logic;

        USER_LOOPBACK       : in  std_logic_vector(1 downto 0);
        USER_TXENC8B10BUSE  : in  std_logic;
        USER_TXBYPASS8B10B  : in  std_logic_vector(7 downto 0);

        -- GT side MGT Pass through Signals 
        GT_RXPMARESET       : out std_logic;
        GT_RXLOCK           : in  std_logic;

        GT_TXPMARESET       : out std_logic;
        GT_TXLOCK           : in  std_logic;

        GT_LOOPBACK         : out std_logic_vector(1 downto 0);
        GT_TXENC8B10BUSE    : out std_logic;
        GT_TXBYPASS8B10B    : out std_logic_vector(7 downto 0);

        GT_TXOUTCLK1        : in  std_logic;
        GT_RXRECCLK2        : in  std_logic;

        -- Signal Detect Ports
        TX_SIGNAL_DETECT    : in  std_logic;
        RX_SIGNAL_DETECT    : in  std_logic;

        -- Frequency Detect Ports
        TX_FD_MIN           : in  std_logic_vector(C_TX_FD_WIDTH-1 downto 0);
        TX_FD_EN            : in  std_logic;
        RX_FD_MIN           : in  std_logic_vector(C_RX_FD_WIDTH-1 downto 0);
        RX_FD_EN            : in  std_logic;

        -- FD_STATUS PORT
        FD_STATUS           : out std_logic_vector(9 downto 0)
    );
    end component;
    
                       

--********************************* Main Body of Code****************************
                       
begin                      
                       
    ---------------------------  Static signal Assigments ----------------------   
    tied_to_ground_i                    <= '0';        
    tied_to_ground_vec_i(63 downto 0)   <= (others => '0');
    tied_to_vcc_i                       <= '1';
    tied_to_vcc_vec_i(63 downto 0)      <= (others => '1');


    --_________________________________________________________________________
    --_________________________________________________________________________
    --MGT0  



    --------------------------- GT11 Instantiations  ---------------------------   
    MGT0 : GT11
    generic map
    (
    ---------------------- RocketIO MGT Clocking Atrributes --------------------      
                                        
        RX_CLOCK_DIVIDER           =>      "00",
        RXASYNCDIVIDE              =>      "10",
        RXCLK0_FORCE_PMACLK        =>      FALSE,
        RXCLKMODE                  =>      "000011",
        RXOUTDIV2SEL               =>      4,
        RXPLLNDIVSEL               =>      20,
        RXPMACLKSEL                =>      "REFCLK1",
        RXRECCLK1_USE_SYNC         =>      FALSE,
        RXUSRDIVISOR               =>      1,
        TX_CLOCK_DIVIDER           =>      "00",
        TXABPMACLKSEL              =>      "REFCLK1",
        TXASYNCDIVIDE              =>      "10",
        TXCLK0_FORCE_PMACLK        =>      TRUE,
        TXCLKMODE                  =>      "0100",
        TXOUTCLK1_USE_SYNC         =>      FALSE,
        TXOUTDIV2SEL               =>      4,
        TXPHASESEL                 =>      FALSE, 
        TXPLLNDIVSEL               =>      20,
                      

    --------------------- RocketIO MGT Data Path Atrributes --------------------   
    
        RXDATA_SEL                 =>      "00",
        TXDATA_SEL                 =>      "00",

    ----------------------- RocketIO MGT Alignment Atrributes ------------------   

        ALIGN_COMMA_WORD           =>      4,
        COMMA_10B_MASK             =>      x"3ff",
        COMMA32                    =>      FALSE,
        DEC_MCOMMA_DETECT          =>      TRUE,
        DEC_PCOMMA_DETECT          =>      TRUE,
        DEC_VALID_COMMA_ONLY       =>      FALSE,
        MCOMMA_32B_VALUE           =>      x"0000017c",
        MCOMMA_DETECT              =>      TRUE,
        PCOMMA_32B_VALUE           =>      x"00000283",
        PCOMMA_DETECT              =>      TRUE,
        PCS_BIT_SLIP               =>      FALSE,
                                        
    ---- RocketIO MGT Atrributes Common to Clk Correction & Channel Bonding ----   

        CCCB_ARBITRATOR_DISABLE    =>      FALSE,
        CLK_COR_8B10B_DE           =>      TRUE,


    ------------------ RocketIO MGT Clock Correction Atrributes ----------------   

        CLK_COR_MAX_LAT            =>      48,
        CLK_COR_MIN_LAT            =>      36,
        CLK_COR_SEQ_1_1            =>      "00111110111",
        CLK_COR_SEQ_1_2            =>      "00111110111",
        CLK_COR_SEQ_1_3            =>      "00111110111",
        CLK_COR_SEQ_1_4            =>      "00111110111",
        CLK_COR_SEQ_1_MASK         =>      "0000",
        CLK_COR_SEQ_2_1            =>      "00000000000",
        CLK_COR_SEQ_2_2            =>      "00000000000",
        CLK_COR_SEQ_2_3            =>      "00000000000",
        CLK_COR_SEQ_2_4            =>      "00000000000",
        CLK_COR_SEQ_2_MASK         =>      "1111",
        CLK_COR_SEQ_2_USE          =>      FALSE,
        CLK_COR_SEQ_DROP           =>      FALSE,
        CLK_COR_SEQ_LEN            =>      4,
        CLK_CORRECT_USE            =>      TRUE,

    
    ------------------- RocketIO MGT Channel Bonding Atrributes ----------------   
    
        CHAN_BOND_LIMIT            =>      16,
        CHAN_BOND_MODE             =>      "MASTER",
        CHAN_BOND_ONE_SHOT         =>      FALSE,
        CHAN_BOND_SEQ_1_1          =>      "00101111100",
        CHAN_BOND_SEQ_1_2          =>      "00000000000",
        CHAN_BOND_SEQ_1_3          =>      "00000000000",
        CHAN_BOND_SEQ_1_4          =>      "00000000000",
        CHAN_BOND_SEQ_1_MASK       =>      "1110",
        CHAN_BOND_SEQ_2_1          =>      "00000000000",
        CHAN_BOND_SEQ_2_2          =>      "00000000000",
        CHAN_BOND_SEQ_2_3          =>      "00000000000",
        CHAN_BOND_SEQ_2_4          =>      "00000000000",
        CHAN_BOND_SEQ_2_MASK       =>      "1111",
        CHAN_BOND_SEQ_2_USE        =>      FALSE,
        CHAN_BOND_SEQ_LEN          =>      1,
                                        

    ---------- RocketIO MGT 64B66B Block Sync State Machine Attributes --------- 

        SH_CNT_MAX                 =>      64,
        SH_INVALID_CNT_MAX         =>      16,


    ---------------- RocketIO MGT Digital Receiver Attributes ------------------   

        DIGRX_FWDCLK               =>      "00",
        DIGRX_SYNC_MODE            =>      FALSE,
        ENABLE_DCDR                =>      FALSE,
        RXBY_32                    =>      FALSE,
        RXDIGRESET                 =>      FALSE,
        RXDIGRX                    =>      FALSE,
        SAMPLE_8X                  =>      FALSE,
                                        

    -------------------------- RocketIO MGT CRC Atrributes ---------------------   

        RXCRCCLOCKDOUBLE           =>      FALSE,
        RXCRCENABLE                =>      FALSE,
        RXCRCINITVAL               =>      x"FFFFFFFF",
        RXCRCINVERTGEN             =>      FALSE,
        RXCRCSAMECLOCK             =>      TRUE,
        TXCRCCLOCKDOUBLE           =>      FALSE,
        TXCRCENABLE                =>      FALSE,
        TXCRCINITVAL               =>      x"FFFFFFFF",
        TXCRCINVERTGEN             =>      FALSE,
        TXCRCSAMECLOCK             =>      TRUE,


    --------------------------- Miscellaneous Attributes -----------------------     

        GT11_MODE                  =>      LANE0_GT11_MODE_P,
        OPPOSITE_SELECT            =>      FALSE,
        PMA_BIT_SLIP               =>      FALSE,
        REPEATER                   =>      FALSE,
        RX_BUFFER_USE              =>      TRUE,
        RXCDRLOS                   =>      "000000",
        TX_BUFFER_USE              =>      TRUE,




    ----------------------- Advanced RocketIO MGT Attributes -------------------  

    --/Note : THE FOLLOWING ATTRIBUTES ARE FOR ADVANCED USERS. PLEASE EDIT WITH CAUTION.                                        
                                        
     --  Miscellaneous Attributes    
        RXDCCOUPLE                 =>      FALSE,
        RXFDCAL_CLOCK_DIVIDE       =>      "NONE",
        TXFDCAL_CLOCK_DIVIDE       =>      "NONE",
                                          
    ----------------------- Restricted RocketIO MGT Attributes -------------------  

    ---Note : THE FOLLOWING ATTRIBUTES ARE RESTRICTED. PLEASE DO NOT EDIT.

     --  PowerDown bits   
        POWER_ENABLE               =>       TRUE,
        RXAFEPD                    =>       FALSE,
        RXAPD                      =>       FALSE,
        RXLKAPD                    =>       FALSE,
        RXPD                       =>       FALSE,
        RXRCPPD                    =>       FALSE,
        RXRPDPD                    =>       FALSE,
        RXRSDPD                    =>       FALSE,
        TXAPD                      =>       FALSE,
        TXDIGPD                    =>       FALSE,
        TXLVLSHFTPD                =>       FALSE,
        TXPD                       =>       FALSE,
        TXPOST_TAP_PD              =>       TXPOST_TAP_PD_P,
        TXPRE_TAP_PD               =>       TRUE,
                               
     --  Frequency Detector and Calibration   
        CYCLE_LIMIT_SEL            =>       "00",
        FDET_HYS_CAL               =>       "010",
        FDET_HYS_SEL               =>       "001",
        FDET_LCK_CAL               =>       "101",
        FDET_LCK_SEL               =>       "111",
        LOOPCAL_WAIT               =>       "00",
        RXCYCLE_LIMIT_SEL          =>       "00",
        RXFDET_HYS_CAL             =>       "010",
        RXFDET_HYS_SEL             =>       "001",
        RXFDET_LCK_CAL             =>       "101",  
        RXFDET_LCK_SEL             =>       "100",
        RXLOOPCAL_WAIT             =>       "00",
        RXSLOWDOWN_CAL             =>       "00",
        SLOWDOWN_CAL               =>       "00",
                   
     --  Preemphasis and Equalization
        RXAFEEQ                    =>       "000000000",
        RXEQ                       =>       x"4000000000000000",
        TXDAT_PRDRV_DAC            =>       "111",
        TXDAT_TAP_DAC              =>       "01010",
        TXHIGHSIGNALEN             =>       TRUE,
        TXPOST_PRDRV_DAC           =>       "111",
        TXPOST_TAP_DAC             =>       "00001",
        TXPRE_PRDRV_DAC            =>       "111",
        TXPRE_TAP_DAC              =>       "00000",
                      
     --  PLL Settings     
        PMACLKENABLE               =>       TRUE,
        PMACOREPWRENABLE           =>       TRUE,
        PMAVBGCTRL                 =>       "00000",
        RXACTST                    =>       FALSE,       
        RXAFETST                   =>       FALSE,      
        RXCMADJ                    =>       "10",
        RXCPSEL                    =>       FALSE,
        RXCPTST                    =>       FALSE,
        RXCTRL1                    =>       x"200",
        RXFECONTROL1               =>       "00",    
        RXFECONTROL2               =>       "000",    
        RXFETUNE                   =>       "01",    
        RXLKADJ                    =>       "00000",
        RXLOOPFILT                 =>       "1111",
        RXPDDTST                   =>       TRUE,      
        RXRCPADJ                   =>       "010",    
        RXRIBADJ                   =>       "11",
        RXVCO_CTRL_ENABLE          =>       TRUE,
        RXVCODAC_INIT              =>       "0001010001",
        TXCPSEL                    =>       TRUE,
        TXCTRL1                    =>       x"200",
        TXLOOPFILT                 =>       "0101",  
        VCO_CTRL_ENABLE            =>       TRUE,
        VCODAC_INIT                =>       "0001010001", 


     --  Biasing    
        BANDGAPSEL                 =>       FALSE,
        BIASRESSEL                 =>       FALSE,    
        IREFBIASMODE               =>       "11",
        PMAIREFTRIM                =>       "0111",
        PMAVREFTRIM                =>       "0111",
        TXAREFBIASSEL              =>       TRUE, 
        TXTERMTRIM                 =>       "1100",
        VREFBIASMODE               =>       "11"                                          

    )
    port map
    (
        ------------------------------- CRC Ports ------------------------------  

        RXCRCCLK                   =>      tied_to_ground_i, 
        RXCRCDATAVALID             =>      tied_to_ground_i, 
        RXCRCDATAWIDTH             =>      tied_to_ground_vec_i(2 downto 0), 
        RXCRCIN                    =>      tied_to_ground_vec_i(63 downto 0), 
        RXCRCINIT                  =>      tied_to_ground_i, 
        RXCRCINTCLK                =>      tied_to_ground_i, 
        RXCRCOUT                   =>      open,                        
        RXCRCPD                    =>      tied_to_ground_i, 
        RXCRCRESET                 =>      tied_to_ground_i, 
                                   
        TXCRCCLK                   =>      tied_to_ground_i, 
        TXCRCDATAVALID             =>      tied_to_ground_i, 
        TXCRCDATAWIDTH             =>      tied_to_ground_vec_i(2 downto 0), 
        TXCRCIN                    =>      tied_to_ground_vec_i(63 downto 0), 
        TXCRCINIT                  =>      tied_to_ground_i, 
        TXCRCINTCLK                =>      tied_to_ground_i, 
        TXCRCOUT                   =>      open,                        
        TXCRCPD                    =>      tied_to_vcc_i,                       
        TXCRCRESET                 =>      tied_to_ground_i, 

         ---------------------------- Calibration Ports ------------------------   

        RXCALFAIL                  =>      open,                       
        RXCYCLELIMIT               =>      open,                    
        TXCALFAIL                  =>      open,                         
        TXCYCLELIMIT               =>      open,                     

        ------------------------------ Serial Ports ----------------------------   

        RX1N                       =>      MGT0_RX1N_IN, 
        RX1P                       =>      MGT0_RX1P_IN, 
        TX1N                       =>      MGT0_TX1N_OUT, 
        TX1P                       =>      MGT0_TX1P_OUT,

        ------------------------------- PLL Lock -------------------------------   

        RXLOCK                     =>      MGT0_rxlock_i,
        TXLOCK                     =>      MGT0_txlock_i,  

        -------------------------------- Resets -------------------------------  

        RXPMARESET                 =>      mgt0_rxpmareset_i, 
        RXRESET                    =>      MGT0_RXRESET_IN, 
        TXPMARESET                 =>      mgt0_txpmareset_i, 
        TXRESET                    =>      MGT0_TXRESET_IN, 

        ---------------------------- Synchronization ---------------------------   
                                
        RXSYNC                     =>      tied_to_ground_i, 
        TXSYNC                     =>      tied_to_ground_i,    
                                
        ---------------------------- Out of Band Signalling -------------------   

        RXSIGDET                   =>      open,                      
        TXENOOB                    =>      tied_to_ground_i, 
 
        -------------------------------- Status --------------------------------   

        RXBUFERR                   =>      MGT0_RXBUFERR_OUT, 
        RXCLKSTABLE                =>      tied_to_vcc_i, 
        RXSTATUS                   =>      MGT0_RXSTATUS_OUT, 
        TXBUFERR                   =>      MGT0_TXBUFERR_OUT, 
        TXCLKSTABLE                =>      tied_to_vcc_i, 
  
        ---------------------------- Polarity Control Ports -------------------- 

        RXPOLARITY                 =>      MGT0_RXPOLARITY_IN, 
        TXINHIBIT                  =>      MGT0_TXINHIBIT_IN, 
        TXPOLARITY                 =>      MGT0_TXPOLARITY_IN, 

        ------------------------------- Channel Bonding Ports ------------------   

        CHBONDI                    =>      tied_to_ground_vec_i(4 downto 0), 
        CHBONDO                    =>      mgt0_chbondo_i, 
        ENCHANSYNC                 =>      MGT0_ENCHANSYNC_IN, 
 
        ---------------------------- 64B66B Blocks Use Ports -------------------   

        RXBLOCKSYNC64B66BUSE       =>      tied_to_ground_i , 
        RXDEC64B66BUSE             =>      tied_to_ground_i , 
        RXDESCRAM64B66BUSE         =>      tied_to_ground_i , 
        RXIGNOREBTF                =>      tied_to_ground_i ,   
        TXENC64B66BUSE             =>      tied_to_ground_i , 
        TXGEARBOX64B66BUSE         =>      tied_to_ground_i , 
        TXSCRAM64B66BUSE           =>      tied_to_ground_i , 

        ---------------------------- 8B10B Blocks Use Ports --------------------   

        RXDEC8B10BUSE              =>      tied_to_vcc_i, 
        TXBYPASS8B10B              =>      mgt0_txbypass8b10b_i, 
        TXENC8B10BUSE              =>      mgt0_txenc8b10buse_i, 
                                    
        ------------------------------ Transmit Control Ports ------------------   

        TXCHARDISPMODE(7 downto 4) =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARDISPMODE(3 downto 0) =>      MGT0_TXCHARDISPMODE_IN, 
        TXCHARDISPVAL(7 downto 4)  =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARDISPVAL(3 downto 0)  =>      MGT0_TXCHARDISPVAL_IN, 
        TXCHARISK(7 downto 4)      =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARISK(3 downto 0)      =>      MGT0_TXCHARISK_IN, 
        TXKERR(7 downto 4)         =>      mgt0_txkerr_out_float_i,
        TXKERR(3 downto 0)         =>      MGT0_TXKERR_OUT,                   
        TXRUNDISP(7 downto 4)      =>      mgt0_txrundisp_out_float_i,
        TXRUNDISP(3 downto 0)      =>      MGT0_TXRUNDISP_OUT,                

        ------------------------------ Receive Control Ports -------------------   

        RXCHARISCOMMA(7 downto 4)  =>      mgt0_rxchariscomma_out_float_i,
        RXCHARISCOMMA(3 downto 0)  =>      MGT0_RXCHARISCOMMA_OUT, 
        RXCHARISK(7 downto 4)      =>      mgt0_rxcharisk_out_float_i,
        RXCHARISK(3 downto 0)      =>      MGT0_RXCHARISK_OUT, 
        RXDISPERR(7 downto 4)      =>      mgt0_rxdisperr_out_float_i,
        RXDISPERR(3 downto 0)      =>      MGT0_RXDISPERR_OUT, 
        RXNOTINTABLE(7 downto 4)   =>      mgt0_rxnotintable_out_float_i,
        RXNOTINTABLE(3 downto 0)   =>      MGT0_RXNOTINTABLE_OUT, 
        RXRUNDISP(7 downto 4)      =>      mgt0_rxrundisp_out_float_i,
        RXRUNDISP(3 downto 0)      =>      MGT0_RXRUNDISP_OUT,            

        ------------------------------- Serdes Alignment -----------------------  

        ENMCOMMAALIGN              =>      MGT0_ENMCOMMAALIGN_IN, 
        ENPCOMMAALIGN              =>      MGT0_ENPCOMMAALIGN_IN,
        RXCOMMADET                 =>      open,                   
        RXCOMMADETUSE              =>      tied_to_vcc_i, 
        RXLOSSOFSYNC               =>      open,           
        RXREALIGN                  =>      MGT0_RXREALIGN_OUT, 
        RXSLIDE                    =>      tied_to_ground_i, 

        ----------- Data Width Settings - Internal and fabric interface -------- 

        RXDATAWIDTH                =>      RXDATAWIDTH_P,        --parameter
        RXINTDATAWIDTH             =>      RXINTDATAWIDTH_P,     --parameter 
        TXDATAWIDTH                =>      TXDATAWIDTH_P,        --parameter
        TXINTDATAWIDTH             =>      TXINTDATAWIDTH_P,     --parameter 

        ------------------------------- Data Ports -----------------------------    

        RXDATA(63 downto 32)       =>      mgt0_rxdata_out_float_i,
        RXDATA(31 downto 0)        =>      MGT0_RXDATA_OUT, 
        TXDATA(63 downto 32)       =>      tied_to_ground_vec_i(31 downto 0),
        TXDATA(31 downto 0)        =>      MGT0_TXDATA_IN, 

        ------------------------------- User Clocks -----------------------------   

        RXMCLK                     =>      open, 
        RXPCSHCLKOUT               =>      open, 
        RXRECCLK1                  =>      MGT0_RXRECCLK1_OUT,     
        RXRECCLK2                  =>      mgt0_rxrecclk2_i,     
        RXUSRCLK                   =>      MGT0_RXUSRCLK_IN, 
        RXUSRCLK2                  =>      MGT0_RXUSRCLK2_IN, 
        TXOUTCLK1                  =>      mgt0_txoutclk1_i, 
        TXOUTCLK2                  =>      MGT0_TXOUTCLK2_OUT, 
        TXPCSHCLKOUT               =>      open,
        TXUSRCLK                   =>      MGT0_TXUSRCLK_IN, 
        TXUSRCLK2                  =>      MGT0_TXUSRCLK2_IN, 
 
         ---------------------------- Reference Clocks --------------------------   

        GREFCLK                    =>      MGT0_GREFCLK_IN, 
        REFCLK1                    =>      MGT0_REFCLK1_IN,        
        REFCLK2                    =>      MGT0_REFCLK2_IN,  

        ---------------------------- Powerdown and Loopback Ports --------------  

        LOOPBACK                   =>      mgt0_loopback_i, 
        POWERDOWN                  =>      MGT0_POWERDOWN_IN,

       ------------------- Dynamic Reconfiguration Port (DRP) ------------------
 
        DADDR                      =>      mgt0_daddr_i,  
        DCLK                       =>      MGT0_DCLK_IN, 
        DEN                        =>      mgt0_den_i, 
        DI                         =>      mgt0_di_i,    
        DO                         =>      mgt0_do_i,                             
        DRDY                       =>      mgt0_drdy_i,                            
        DWE                        =>      mgt0_dwe_i, 

           --------------------- MGT Tile Communication Ports ------------------       

        COMBUSIN                   =>      MGT0_COMBUSIN_IN, 
        COMBUSOUT                  =>      MGT0_COMBUSOUT_OUT 
    );


    ------------------------------- Calibration Block --------------------------


    --Buffer MGT output clocks to preserve names for timing constraints
    
    mgt0_rxrecclk_buffer_i : BUF 
    port map
    (
        I                           =>  mgt0_rxrecclk2_i,
        O                           =>  mgt0_rxrecclk2_buf_i
    );
    

    mgt0_txoutclk_buffer_i : BUF
    port map
    (
        I                           =>  mgt0_txoutclk1_i,
        O                           =>  mgt0_txoutclk1_buf_i
    );  
    
    
    --Drive the MGT output clocks to their respective output ports
    MGT0_RXRECCLK2_OUT   <=   mgt0_rxrecclk2_i;

    MGT0_TXOUTCLK1_OUT   <=   mgt0_txoutclk1_i;



    cal_block_0_i : cal_block_v1_2_1
    generic map 
    (
        C_MGT_ID            => LANE0_MGT_ID_P,  -- 0 = MGTA | 1 = MGTB
        C_DCLK_PERIOD_NS    => DCLK_PERIOD_NS_P,  -- DCLK clock period in NS
        C_SIMULATION        => SIMULATION_P,  
        C_TXOUTDIV2SEL_A    => 4,
        C_TXOUTDIV2SEL_B    => 4,
        C_RXOUTDIV2SEL_A    => 4,
        C_RXOUTDIV2SEL_B    => 4,
        C_TXPOST_TAP_PD     => "TXPOST_TAP_PD_P",  -- "TRUE" or "FALSE"
        C_RXDIGRX           => "FALSE",  -- "TRUE" or "FALSE"
        C_TX_FD_WIDTH       => TX_FD_WIDTH_P,
        C_RX_FD_WIDTH       => RX_FD_WIDTH_P
    )
    port map 
    (
        -- User DRP Interface (destination/slave interface)
        USER_DO             => open,
        USER_DI             => tied_to_ground_vec_i(15 downto 0), 
        USER_DADDR          => tied_to_ground_vec_i(7 downto 0),
        USER_DEN            => tied_to_ground_i,
        USER_DWE            => tied_to_ground_i,
        USER_DRDY           => open,

        -- MGT DRP Interface (source/master interface)
        GT_DO               => mgt0_di_i,
        GT_DI               => mgt0_do_i,
        GT_DADDR            => mgt0_daddr_i,
        GT_DEN              => mgt0_den_i,
        GT_DWE              => mgt0_dwe_i,
        GT_DRDY             => mgt0_drdy_i,

        -- Clock and Reset
        DCLK                => MGT0_DCLK_IN,
        RESET               => MGT0_DRP_RESET_IN,

        -- Calibration Block Active and Disable Signals (legacy)
        ACTIVE              => MGT0_ACTIVE_OUT,
        DISABLE             => MGT0_DISABLE_IN,

        -- User side MGT Pass through Signals
        USER_RXPMARESET     => MGT0_RXPMARESET_IN,
        USER_RXLOCK         => MGT0_RXLOCK_OUT,

        USER_TXPMARESET     => MGT0_TXPMARESET_IN,
        USER_TXLOCK         => MGT0_TXLOCK_OUT,

        USER_LOOPBACK       => tied_to_ground_vec_i(1 downto 0),
        USER_TXENC8B10BUSE  => tied_to_vcc_i,
        USER_TXBYPASS8B10B(7 downto 4)=>      tied_to_ground_vec_i(3 downto 0),
        USER_TXBYPASS8B10B(3 downto 0)=>      MGT0_TXBYPASS8B10B_IN,

        -- GT side MGT Pass through Signals
        GT_RXPMARESET       => mgt0_rxpmareset_i,
        GT_RXLOCK           => mgt0_rxlock_i,

        GT_TXPMARESET       => mgt0_txpmareset_i,
        GT_TXLOCK           => mgt0_txlock_i,

        GT_LOOPBACK         => mgt0_loopback_i,
        GT_TXENC8B10BUSE    => mgt0_txenc8b10buse_i,
        GT_TXBYPASS8B10B    => mgt0_txbypass8b10b_i,
    
        GT_TXOUTCLK1        => mgt0_txoutclk1_buf_i,
        GT_RXRECCLK2        => mgt0_rxrecclk2_buf_i,

        -- Signal Detect Ports
        TX_SIGNAL_DETECT    => MGT0_TX_SIGNAL_DETECT_IN,
        RX_SIGNAL_DETECT    => MGT0_RX_SIGNAL_DETECT_IN,

        -- Frequency Detect Ports
        TX_FD_MIN           => TX_FD_MIN_P,
        TX_FD_EN            => TX_FD_EN_P,
        RX_FD_MIN           => RX_FD_MIN_P,
        RX_FD_EN            => RX_FD_EN_P,

        -- FD_STATUS PORT
        FD_STATUS           => open
    );






    --_________________________________________________________________________
    --_________________________________________________________________________
    --MGT1  



    --------------------------- GT11 Instantiations  ---------------------------   
    MGT1 : GT11
    generic map
    (
    ---------------------- RocketIO MGT Clocking Atrributes --------------------      
                                        
        RX_CLOCK_DIVIDER           =>      "00",
        RXASYNCDIVIDE              =>      "10",
        RXCLK0_FORCE_PMACLK        =>      FALSE,
        RXCLKMODE                  =>      "000011",
        RXOUTDIV2SEL               =>      4,
        RXPLLNDIVSEL               =>      20,
        RXPMACLKSEL                =>      "REFCLK1",
        RXRECCLK1_USE_SYNC         =>      FALSE,
        RXUSRDIVISOR               =>      1,
        TX_CLOCK_DIVIDER           =>      "00",
        TXABPMACLKSEL              =>      "REFCLK1",
        TXASYNCDIVIDE              =>      "10",
        TXCLK0_FORCE_PMACLK        =>      TRUE,
        TXCLKMODE                  =>      "0100",
        TXOUTCLK1_USE_SYNC         =>      FALSE,
        TXOUTDIV2SEL               =>      4,
        TXPHASESEL                 =>      FALSE, 
        TXPLLNDIVSEL               =>      20,
                      

    --------------------- RocketIO MGT Data Path Atrributes --------------------   
    
        RXDATA_SEL                 =>      "00",
        TXDATA_SEL                 =>      "00",

    ----------------------- RocketIO MGT Alignment Atrributes ------------------   

        ALIGN_COMMA_WORD           =>      4,
        COMMA_10B_MASK             =>      x"3ff",
        COMMA32                    =>      FALSE,
        DEC_MCOMMA_DETECT          =>      TRUE,
        DEC_PCOMMA_DETECT          =>      TRUE,
        DEC_VALID_COMMA_ONLY       =>      FALSE,
        MCOMMA_32B_VALUE           =>      x"0000017c",
        MCOMMA_DETECT              =>      TRUE,
        PCOMMA_32B_VALUE           =>      x"00000283",
        PCOMMA_DETECT              =>      TRUE,
        PCS_BIT_SLIP               =>      FALSE,
                                        
    ---- RocketIO MGT Atrributes Common to Clk Correction & Channel Bonding ----   

        CCCB_ARBITRATOR_DISABLE    =>      FALSE,
        CLK_COR_8B10B_DE           =>      TRUE,


    ------------------ RocketIO MGT Clock Correction Atrributes ----------------   

        CLK_COR_MAX_LAT            =>      48,
        CLK_COR_MIN_LAT            =>      36,
        CLK_COR_SEQ_1_1            =>      "00111110111",
        CLK_COR_SEQ_1_2            =>      "00111110111",
        CLK_COR_SEQ_1_3            =>      "00111110111",
        CLK_COR_SEQ_1_4            =>      "00111110111",
        CLK_COR_SEQ_1_MASK         =>      "0000",
        CLK_COR_SEQ_2_1            =>      "00000000000",
        CLK_COR_SEQ_2_2            =>      "00000000000",
        CLK_COR_SEQ_2_3            =>      "00000000000",
        CLK_COR_SEQ_2_4            =>      "00000000000",
        CLK_COR_SEQ_2_MASK         =>      "1111",
        CLK_COR_SEQ_2_USE          =>      FALSE,
        CLK_COR_SEQ_DROP           =>      FALSE,
        CLK_COR_SEQ_LEN            =>      4,
        CLK_CORRECT_USE            =>      TRUE,

    
    ------------------- RocketIO MGT Channel Bonding Atrributes ----------------   
    
        CHAN_BOND_LIMIT            =>      16,
        CHAN_BOND_MODE             =>      "SLAVE_1_HOP",
        CHAN_BOND_ONE_SHOT         =>      FALSE,
        CHAN_BOND_SEQ_1_1          =>      "00101111100",
        CHAN_BOND_SEQ_1_2          =>      "00000000000",
        CHAN_BOND_SEQ_1_3          =>      "00000000000",
        CHAN_BOND_SEQ_1_4          =>      "00000000000",
        CHAN_BOND_SEQ_1_MASK       =>      "1110",
        CHAN_BOND_SEQ_2_1          =>      "00000000000",
        CHAN_BOND_SEQ_2_2          =>      "00000000000",
        CHAN_BOND_SEQ_2_3          =>      "00000000000",
        CHAN_BOND_SEQ_2_4          =>      "00000000000",
        CHAN_BOND_SEQ_2_MASK       =>      "1111",
        CHAN_BOND_SEQ_2_USE        =>      FALSE,
        CHAN_BOND_SEQ_LEN          =>      1,
                                        

    ---------- RocketIO MGT 64B66B Block Sync State Machine Attributes --------- 

        SH_CNT_MAX                 =>      64,
        SH_INVALID_CNT_MAX         =>      16,


    ---------------- RocketIO MGT Digital Receiver Attributes ------------------   

        DIGRX_FWDCLK               =>      "00",
        DIGRX_SYNC_MODE            =>      FALSE,
        ENABLE_DCDR                =>      FALSE,
        RXBY_32                    =>      FALSE,
        RXDIGRESET                 =>      FALSE,
        RXDIGRX                    =>      FALSE,
        SAMPLE_8X                  =>      FALSE,
                                        

    -------------------------- RocketIO MGT CRC Atrributes ---------------------   

        RXCRCCLOCKDOUBLE           =>      FALSE,
        RXCRCENABLE                =>      FALSE,
        RXCRCINITVAL               =>      x"FFFFFFFF",
        RXCRCINVERTGEN             =>      FALSE,
        RXCRCSAMECLOCK             =>      TRUE,
        TXCRCCLOCKDOUBLE           =>      FALSE,
        TXCRCENABLE                =>      FALSE,
        TXCRCINITVAL               =>      x"FFFFFFFF",
        TXCRCINVERTGEN             =>      FALSE,
        TXCRCSAMECLOCK             =>      TRUE,


    --------------------------- Miscellaneous Attributes -----------------------     

        GT11_MODE                  =>      LANE1_GT11_MODE_P,
        OPPOSITE_SELECT            =>      FALSE,
        PMA_BIT_SLIP               =>      FALSE,
        REPEATER                   =>      FALSE,
        RX_BUFFER_USE              =>      TRUE,
        RXCDRLOS                   =>      "000000",
        TX_BUFFER_USE              =>      TRUE,




    ----------------------- Advanced RocketIO MGT Attributes -------------------  

    --/Note : THE FOLLOWING ATTRIBUTES ARE FOR ADVANCED USERS. PLEASE EDIT WITH CAUTION.                                        
                                        
     --  Miscellaneous Attributes    
        RXDCCOUPLE                 =>      FALSE,
        RXFDCAL_CLOCK_DIVIDE       =>      "NONE",
        TXFDCAL_CLOCK_DIVIDE       =>      "NONE",
                                          
    ----------------------- Restricted RocketIO MGT Attributes -------------------  

    ---Note : THE FOLLOWING ATTRIBUTES ARE RESTRICTED. PLEASE DO NOT EDIT.

     --  PowerDown bits   
        POWER_ENABLE               =>       TRUE,
        RXAFEPD                    =>       FALSE,
        RXAPD                      =>       FALSE,
        RXLKAPD                    =>       FALSE,
        RXPD                       =>       FALSE,
        RXRCPPD                    =>       FALSE,
        RXRPDPD                    =>       FALSE,
        RXRSDPD                    =>       FALSE,
        TXAPD                      =>       FALSE,
        TXDIGPD                    =>       FALSE,
        TXLVLSHFTPD                =>       FALSE,
        TXPD                       =>       FALSE,
        TXPOST_TAP_PD              =>       TXPOST_TAP_PD_P,
        TXPRE_TAP_PD               =>       TRUE,
                               
     --  Frequency Detector and Calibration   
        CYCLE_LIMIT_SEL            =>       "00",
        FDET_HYS_CAL               =>       "010",
        FDET_HYS_SEL               =>       "001",
        FDET_LCK_CAL               =>       "101",
        FDET_LCK_SEL               =>       "111",
        LOOPCAL_WAIT               =>       "00",
        RXCYCLE_LIMIT_SEL          =>       "00",
        RXFDET_HYS_CAL             =>       "010",
        RXFDET_HYS_SEL             =>       "001",
        RXFDET_LCK_CAL             =>       "101",  
        RXFDET_LCK_SEL             =>       "100",
        RXLOOPCAL_WAIT             =>       "00",
        RXSLOWDOWN_CAL             =>       "00",
        SLOWDOWN_CAL               =>       "00",
                   
     --  Preemphasis and Equalization
        RXAFEEQ                    =>       "000000000",
        RXEQ                       =>       x"4000000000000000",
        TXDAT_PRDRV_DAC            =>       "111",
        TXDAT_TAP_DAC              =>       "01010",
        TXHIGHSIGNALEN             =>       TRUE,
        TXPOST_PRDRV_DAC           =>       "111",
        TXPOST_TAP_DAC             =>       "00001",
        TXPRE_PRDRV_DAC            =>       "111",
        TXPRE_TAP_DAC              =>       "00000",
                      
     --  PLL Settings     
        PMACLKENABLE               =>       TRUE,
        PMACOREPWRENABLE           =>       TRUE,
        PMAVBGCTRL                 =>       "00000",
        RXACTST                    =>       FALSE,       
        RXAFETST                   =>       FALSE,      
        RXCMADJ                    =>       "10",
        RXCPSEL                    =>       FALSE,
        RXCPTST                    =>       FALSE,
        RXCTRL1                    =>       x"200",
        RXFECONTROL1               =>       "00",    
        RXFECONTROL2               =>       "000",    
        RXFETUNE                   =>       "01",    
        RXLKADJ                    =>       "00000",
        RXLOOPFILT                 =>       "1111",
        RXPDDTST                   =>       TRUE,      
        RXRCPADJ                   =>       "010",    
        RXRIBADJ                   =>       "11",
        RXVCO_CTRL_ENABLE          =>       TRUE,
        RXVCODAC_INIT              =>       "0001010001",
        TXCPSEL                    =>       TRUE,
        TXCTRL1                    =>       x"200",
        TXLOOPFILT                 =>       "0101",  
        VCO_CTRL_ENABLE            =>       TRUE,
        VCODAC_INIT                =>       "0001010001", 


     --  Biasing    
        BANDGAPSEL                 =>       FALSE,
        BIASRESSEL                 =>       FALSE,    
        IREFBIASMODE               =>       "11",
        PMAIREFTRIM                =>       "0111",
        PMAVREFTRIM                =>       "0111",
        TXAREFBIASSEL              =>       TRUE, 
        TXTERMTRIM                 =>       "1100",
        VREFBIASMODE               =>       "11"                                          

    )
    port map
    (
        ------------------------------- CRC Ports ------------------------------  

        RXCRCCLK                   =>      tied_to_ground_i, 
        RXCRCDATAVALID             =>      tied_to_ground_i, 
        RXCRCDATAWIDTH             =>      tied_to_ground_vec_i(2 downto 0), 
        RXCRCIN                    =>      tied_to_ground_vec_i(63 downto 0), 
        RXCRCINIT                  =>      tied_to_ground_i, 
        RXCRCINTCLK                =>      tied_to_ground_i, 
        RXCRCOUT                   =>      open,                        
        RXCRCPD                    =>      tied_to_ground_i, 
        RXCRCRESET                 =>      tied_to_ground_i, 
                                   
        TXCRCCLK                   =>      tied_to_ground_i, 
        TXCRCDATAVALID             =>      tied_to_ground_i, 
        TXCRCDATAWIDTH             =>      tied_to_ground_vec_i(2 downto 0), 
        TXCRCIN                    =>      tied_to_ground_vec_i(63 downto 0), 
        TXCRCINIT                  =>      tied_to_ground_i, 
        TXCRCINTCLK                =>      tied_to_ground_i, 
        TXCRCOUT                   =>      open,                        
        TXCRCPD                    =>      tied_to_vcc_i,                       
        TXCRCRESET                 =>      tied_to_ground_i, 

         ---------------------------- Calibration Ports ------------------------   

        RXCALFAIL                  =>      open,                       
        RXCYCLELIMIT               =>      open,                    
        TXCALFAIL                  =>      open,                         
        TXCYCLELIMIT               =>      open,                     

        ------------------------------ Serial Ports ----------------------------   

        RX1N                       =>      MGT1_RX1N_IN, 
        RX1P                       =>      MGT1_RX1P_IN, 
        TX1N                       =>      MGT1_TX1N_OUT, 
        TX1P                       =>      MGT1_TX1P_OUT,

        ------------------------------- PLL Lock -------------------------------   

        RXLOCK                     =>      MGT1_rxlock_i,
        TXLOCK                     =>      MGT1_txlock_i,  

        -------------------------------- Resets -------------------------------  

        RXPMARESET                 =>      mgt1_rxpmareset_i, 
        RXRESET                    =>      MGT1_RXRESET_IN, 
        TXPMARESET                 =>      mgt1_txpmareset_i, 
        TXRESET                    =>      MGT1_TXRESET_IN, 

        ---------------------------- Synchronization ---------------------------   
                                
        RXSYNC                     =>      tied_to_ground_i, 
        TXSYNC                     =>      tied_to_ground_i,    
                                
        ---------------------------- Out of Band Signalling -------------------   

        RXSIGDET                   =>      open,                      
        TXENOOB                    =>      tied_to_ground_i, 
 
        -------------------------------- Status --------------------------------   

        RXBUFERR                   =>      MGT1_RXBUFERR_OUT, 
        RXCLKSTABLE                =>      tied_to_vcc_i, 
        RXSTATUS                   =>      MGT1_RXSTATUS_OUT, 
        TXBUFERR                   =>      MGT1_TXBUFERR_OUT, 
        TXCLKSTABLE                =>      tied_to_vcc_i, 
  
        ---------------------------- Polarity Control Ports -------------------- 

        RXPOLARITY                 =>      MGT1_RXPOLARITY_IN, 
        TXINHIBIT                  =>      MGT1_TXINHIBIT_IN, 
        TXPOLARITY                 =>      MGT1_TXPOLARITY_IN, 

        ------------------------------- Channel Bonding Ports ------------------   

        CHBONDI                    =>      mgt0_chbondo_i, 
        CHBONDO                    =>      mgt1_chbondo_i, 
        ENCHANSYNC                 =>      MGT1_ENCHANSYNC_IN, 
 
        ---------------------------- 64B66B Blocks Use Ports -------------------   

        RXBLOCKSYNC64B66BUSE       =>      tied_to_ground_i , 
        RXDEC64B66BUSE             =>      tied_to_ground_i , 
        RXDESCRAM64B66BUSE         =>      tied_to_ground_i , 
        RXIGNOREBTF                =>      tied_to_ground_i ,   
        TXENC64B66BUSE             =>      tied_to_ground_i , 
        TXGEARBOX64B66BUSE         =>      tied_to_ground_i , 
        TXSCRAM64B66BUSE           =>      tied_to_ground_i , 

        ---------------------------- 8B10B Blocks Use Ports --------------------   

        RXDEC8B10BUSE              =>      tied_to_vcc_i, 
        TXBYPASS8B10B              =>      mgt1_txbypass8b10b_i, 
        TXENC8B10BUSE              =>      mgt1_txenc8b10buse_i, 
                                    
        ------------------------------ Transmit Control Ports ------------------   

        TXCHARDISPMODE(7 downto 4) =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARDISPMODE(3 downto 0) =>      MGT1_TXCHARDISPMODE_IN, 
        TXCHARDISPVAL(7 downto 4)  =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARDISPVAL(3 downto 0)  =>      MGT1_TXCHARDISPVAL_IN, 
        TXCHARISK(7 downto 4)      =>      tied_to_ground_vec_i(3 downto 0),
        TXCHARISK(3 downto 0)      =>      MGT1_TXCHARISK_IN, 
        TXKERR(7 downto 4)         =>      mgt1_txkerr_out_float_i,
        TXKERR(3 downto 0)         =>      MGT1_TXKERR_OUT,                   
        TXRUNDISP(7 downto 4)      =>      mgt1_txrundisp_out_float_i,
        TXRUNDISP(3 downto 0)      =>      MGT1_TXRUNDISP_OUT,                

        ------------------------------ Receive Control Ports -------------------   

        RXCHARISCOMMA(7 downto 4)  =>      mgt1_rxchariscomma_out_float_i,
        RXCHARISCOMMA(3 downto 0)  =>      MGT1_RXCHARISCOMMA_OUT, 
        RXCHARISK(7 downto 4)      =>      mgt1_rxcharisk_out_float_i,
        RXCHARISK(3 downto 0)      =>      MGT1_RXCHARISK_OUT, 
        RXDISPERR(7 downto 4)      =>      mgt1_rxdisperr_out_float_i,
        RXDISPERR(3 downto 0)      =>      MGT1_RXDISPERR_OUT, 
        RXNOTINTABLE(7 downto 4)   =>      mgt1_rxnotintable_out_float_i,
        RXNOTINTABLE(3 downto 0)   =>      MGT1_RXNOTINTABLE_OUT, 
        RXRUNDISP(7 downto 4)      =>      mgt1_rxrundisp_out_float_i,
        RXRUNDISP(3 downto 0)      =>      MGT1_RXRUNDISP_OUT,            

        ------------------------------- Serdes Alignment -----------------------  

        ENMCOMMAALIGN              =>      MGT1_ENMCOMMAALIGN_IN, 
        ENPCOMMAALIGN              =>      MGT1_ENPCOMMAALIGN_IN,
        RXCOMMADET                 =>      open,                   
        RXCOMMADETUSE              =>      tied_to_vcc_i, 
        RXLOSSOFSYNC               =>      open,           
        RXREALIGN                  =>      MGT1_RXREALIGN_OUT, 
        RXSLIDE                    =>      tied_to_ground_i, 

        ----------- Data Width Settings - Internal and fabric interface -------- 

        RXDATAWIDTH                =>      RXDATAWIDTH_P,        --parameter
        RXINTDATAWIDTH             =>      RXINTDATAWIDTH_P,     --parameter 
        TXDATAWIDTH                =>      TXDATAWIDTH_P,        --parameter
        TXINTDATAWIDTH             =>      TXINTDATAWIDTH_P,     --parameter 

        ------------------------------- Data Ports -----------------------------    

        RXDATA(63 downto 32)       =>      mgt1_rxdata_out_float_i,
        RXDATA(31 downto 0)        =>      MGT1_RXDATA_OUT, 
        TXDATA(63 downto 32)       =>      tied_to_ground_vec_i(31 downto 0),
        TXDATA(31 downto 0)        =>      MGT1_TXDATA_IN, 

        ------------------------------- User Clocks -----------------------------   

        RXMCLK                     =>      open, 
        RXPCSHCLKOUT               =>      open, 
        RXRECCLK1                  =>      MGT1_RXRECCLK1_OUT,     
        RXRECCLK2                  =>      mgt1_rxrecclk2_i,     
        RXUSRCLK                   =>      MGT1_RXUSRCLK_IN, 
        RXUSRCLK2                  =>      MGT1_RXUSRCLK2_IN, 
        TXOUTCLK1                  =>      mgt1_txoutclk1_i, 
        TXOUTCLK2                  =>      MGT1_TXOUTCLK2_OUT, 
        TXPCSHCLKOUT               =>      open,
        TXUSRCLK                   =>      MGT1_TXUSRCLK_IN, 
        TXUSRCLK2                  =>      MGT1_TXUSRCLK2_IN, 
 
         ---------------------------- Reference Clocks --------------------------   

        GREFCLK                    =>      MGT1_GREFCLK_IN, 
        REFCLK1                    =>      MGT1_REFCLK1_IN,        
        REFCLK2                    =>      MGT1_REFCLK2_IN,  

        ---------------------------- Powerdown and Loopback Ports --------------  

        LOOPBACK                   =>      mgt1_loopback_i, 
        POWERDOWN                  =>      MGT1_POWERDOWN_IN,

       ------------------- Dynamic Reconfiguration Port (DRP) ------------------
 
        DADDR                      =>      mgt1_daddr_i,  
        DCLK                       =>      MGT1_DCLK_IN, 
        DEN                        =>      mgt1_den_i, 
        DI                         =>      mgt1_di_i,    
        DO                         =>      mgt1_do_i,                             
        DRDY                       =>      mgt1_drdy_i,                            
        DWE                        =>      mgt1_dwe_i, 

           --------------------- MGT Tile Communication Ports ------------------       

        COMBUSIN                   =>      MGT1_COMBUSIN_IN, 
        COMBUSOUT                  =>      MGT1_COMBUSOUT_OUT 
    );


    ------------------------------- Calibration Block --------------------------


    --Buffer MGT output clocks to preserve names for timing constraints
    
    mgt1_rxrecclk_buffer_i : BUF 
    port map
    (
        I                           =>  mgt1_rxrecclk2_i,
        O                           =>  mgt1_rxrecclk2_buf_i
    );
    

    mgt1_txoutclk_buffer_i : BUF
    port map
    (
        I                           =>  mgt1_txoutclk1_i,
        O                           =>  mgt1_txoutclk1_buf_i
    );  
    
    
    --Drive the MGT output clocks to their respective output ports
    MGT1_RXRECCLK2_OUT   <=   mgt1_rxrecclk2_i;

    MGT1_TXOUTCLK1_OUT   <=   mgt1_txoutclk1_i;



    cal_block_1_i : cal_block_v1_2_1
    generic map 
    (
        C_MGT_ID            => LANE1_MGT_ID_P,  -- 0 = MGTA | 1 = MGTB
        C_DCLK_PERIOD_NS    => DCLK_PERIOD_NS_P,  -- DCLK clock period in NS
        C_SIMULATION        => SIMULATION_P,  
        C_TXOUTDIV2SEL_A    => 4,
        C_TXOUTDIV2SEL_B    => 4,
        C_RXOUTDIV2SEL_A    => 4,
        C_RXOUTDIV2SEL_B    => 4,
        C_TXPOST_TAP_PD     => "TXPOST_TAP_PD_P",  -- "TRUE" or "FALSE"
        C_RXDIGRX           => "FALSE",  -- "TRUE" or "FALSE"
        C_TX_FD_WIDTH       => TX_FD_WIDTH_P,
        C_RX_FD_WIDTH       => RX_FD_WIDTH_P
    )
    port map 
    (
        -- User DRP Interface (destination/slave interface)
        USER_DO             => open,
        USER_DI             => tied_to_ground_vec_i(15 downto 0), 
        USER_DADDR          => tied_to_ground_vec_i(7 downto 0),
        USER_DEN            => tied_to_ground_i,
        USER_DWE            => tied_to_ground_i,
        USER_DRDY           => open,

        -- MGT DRP Interface (source/master interface)
        GT_DO               => mgt1_di_i,
        GT_DI               => mgt1_do_i,
        GT_DADDR            => mgt1_daddr_i,
        GT_DEN              => mgt1_den_i,
        GT_DWE              => mgt1_dwe_i,
        GT_DRDY             => mgt1_drdy_i,

        -- Clock and Reset
        DCLK                => MGT1_DCLK_IN,
        RESET               => MGT1_DRP_RESET_IN,

        -- Calibration Block Active and Disable Signals (legacy)
        ACTIVE              => MGT1_ACTIVE_OUT,
        DISABLE             => MGT1_DISABLE_IN,

        -- User side MGT Pass through Signals
        USER_RXPMARESET     => MGT1_RXPMARESET_IN,
        USER_RXLOCK         => MGT1_RXLOCK_OUT,

        USER_TXPMARESET     => MGT1_TXPMARESET_IN,
        USER_TXLOCK         => MGT1_TXLOCK_OUT,

        USER_LOOPBACK       => tied_to_ground_vec_i(1 downto 0),
        USER_TXENC8B10BUSE  => tied_to_vcc_i,
        USER_TXBYPASS8B10B(7 downto 4)=>      tied_to_ground_vec_i(3 downto 0),
        USER_TXBYPASS8B10B(3 downto 0)=>      MGT1_TXBYPASS8B10B_IN,

        -- GT side MGT Pass through Signals
        GT_RXPMARESET       => mgt1_rxpmareset_i,
        GT_RXLOCK           => mgt1_rxlock_i,

        GT_TXPMARESET       => mgt1_txpmareset_i,
        GT_TXLOCK           => mgt1_txlock_i,

        GT_LOOPBACK         => mgt1_loopback_i,
        GT_TXENC8B10BUSE    => mgt1_txenc8b10buse_i,
        GT_TXBYPASS8B10B    => mgt1_txbypass8b10b_i,
    
        GT_TXOUTCLK1        => mgt1_txoutclk1_buf_i,
        GT_RXRECCLK2        => mgt1_rxrecclk2_buf_i,

        -- Signal Detect Ports
        TX_SIGNAL_DETECT    => MGT1_TX_SIGNAL_DETECT_IN,
        RX_SIGNAL_DETECT    => MGT1_RX_SIGNAL_DETECT_IN,

        -- Frequency Detect Ports
        TX_FD_MIN           => TX_FD_MIN_P,
        TX_FD_EN            => TX_FD_EN_P,
        RX_FD_MIN           => RX_FD_MIN_P,
        RX_FD_EN            => RX_FD_EN_P,

        -- FD_STATUS PORT
        FD_STATUS           => open
    );






end BEHAVIORAL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/21 23:26:37 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: channel_init_sm_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.6 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  CHANNEL_INIT_SM
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: the CHANNEL_INIT_SM module is a state machine for managing channel
--               bonding and verification.
--
--               The channel init state machine is reset until the lane up signals
--               of all the lanes that constitute the channel are asserted.  It then
--               requests channel bonding until the lanes have been bonded and
--               checks to make sure the bonding was successful.  Channel bonding is
--               skipped if there is only one lane in the channel.  If bonding is
--               unsuccessful, the lanes are reset.
--
--               After the bonding phase is complete, the state machine sends
--               verification sequences through the channel until it is clear that
--               the channel is ready to be used.  If verification is successful,
--               the CHANNEL_UP signal is asserted.  If it is unsuccessful, the
--               lanes are reset.
--
--               After CHANNEL_UP goes high, the state machine is quiescent, and will
--               reset only if one of the lanes goes down, a hard error is detected, or
--               a general reset is requested.
--
--               This module supports 2 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.AURORA.all;

-- synthesis translate_off

library UNISIM;
use UNISIM.all;

-- synthesis translate_on

entity CHANNEL_INIT_SM is
    generic (
            EXTEND_WATCHDOGS  : boolean := FALSE
    );
    port (

    -- MGT Interface

            CH_BOND_DONE      : in std_logic_vector(0 to 1);
            EN_CHAN_SYNC      : out std_logic;

    -- Aurora Lane Interface

            CHANNEL_BOND_LOAD : in std_logic_vector(0 to 1);
            GOT_A             : in std_logic_vector(0 to 7);
            GOT_V             : in std_logic_vector(0 to 1);
            RESET_LANES       : out std_logic_vector(0 to 1);

    -- System Interface

            USER_CLK          : in std_logic;
            RESET             : in std_logic;
            CHANNEL_UP        : out std_logic;
            START_RX          : out std_logic;

    -- Idle and Verification Sequence Generator Interface

            DID_VER           : in std_logic;
            GEN_VER           : out std_logic;

    -- Channel Init State Machine Interface

            RESET_CHANNEL     : in std_logic

         );

end CHANNEL_INIT_SM;

architecture RTL of CHANNEL_INIT_SM is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal EN_CHAN_SYNC_Buffer : std_logic;
    signal RESET_LANES_Buffer  : std_logic_vector(0 to 1);
    signal CHANNEL_UP_Buffer   : std_logic;
    signal START_RX_Buffer     : std_logic;
    signal GEN_VER_Buffer      : std_logic;

-- Internal Register Declarations --

    signal free_count_done_r       : std_logic;
    signal extend_watchdogs_n_r    : std_logic;
    signal verify_watchdog_r       : std_logic_vector(0 to 15);
    signal bonding_watchdog_r      : std_logic_vector(0 to 15);
    signal all_ch_bond_done_r      : std_logic;
    signal all_channel_bond_load_r : std_logic;
    signal bond_passed_r           : std_logic;
    signal good_as_r               : std_logic;
    signal bad_as_r                : std_logic;
    signal a_count_r               : unsigned(0 to 2);
    signal all_lanes_v_r           : std_logic;
    signal got_first_v_r           : std_logic;
    signal v_count_r               : std_logic_vector(0 to 15);
    signal bad_v_r                 : std_logic;
    signal rxver_count_r           : std_logic_vector(0 to 2);
    signal txver_count_r           : std_logic_vector(0 to 7);

    -- State registers

    signal wait_for_lane_up_r      : std_logic;
    signal channel_bond_r          : std_logic;
    signal check_bond_r            : std_logic;
    signal verify_r                : std_logic;
    signal ready_r                 : std_logic;

-- Wire Declarations --

    signal free_count_1_r          : std_logic;
    signal free_count_2_r          : std_logic;
    signal extend_watchdogs_1_r    : std_logic;
    signal extend_watchdogs_2_r    : std_logic;
    signal extend_watchdogs_n_c    : std_logic;    
    signal insert_ver_c            : std_logic;
    signal verify_watchdog_done_r  : std_logic;
    signal rxver_3d_done_r         : std_logic;
    signal txver_8d_done_r         : std_logic;
    signal reset_lanes_c           : std_logic;

    signal all_ch_bond_done_c      : std_logic;
    signal all_channel_bond_load_c : std_logic;
    signal en_chan_sync_c          : std_logic;
    signal all_as_c                : std_logic_vector(0 to 3);
    signal any_as_c                : std_logic_vector(0 to 3);
    signal four_as_r               : std_logic;
    signal bonding_watchdog_done_r : std_logic;
    signal all_lanes_v_c           : std_logic;

    -- Next state signals

    signal next_channel_bond_c     : std_logic;
    signal next_check_bond_c       : std_logic;
    signal next_verify_c           : std_logic;
    signal next_ready_c            : std_logic;

    -- VHDL utility signals

    signal  tied_to_vcc        : std_logic;
    signal  tied_to_gnd        : std_logic;

-- Component Declarations

    component SRL16
        generic (INIT : bit_vector := X"0000");
        port (

                Q   : out std_ulogic;
                A0  : in  std_ulogic;
                A1  : in  std_ulogic;
                A2  : in  std_ulogic;
                A3  : in  std_ulogic;
                CLK : in  std_ulogic;
                D   : in  std_ulogic

             );

    end component;

    component SRL16E
        generic (INIT : bit_vector := X"0000");
        port (

                Q   : out std_ulogic;
                A0  : in  std_ulogic;
                A1  : in  std_ulogic;
                A2  : in  std_ulogic;
                A3  : in  std_ulogic;
                CE  : in  std_ulogic;
                CLK : in  std_ulogic;
                D   : in  std_ulogic

             );

    end component;

    component FD
        generic (INIT : bit := '0');
        port (

                Q : out std_ulogic;
                C : in  std_ulogic;
                D : in  std_ulogic

             );

    end component;

begin

    EN_CHAN_SYNC <= EN_CHAN_SYNC_Buffer;
    RESET_LANES  <= RESET_LANES_Buffer;
    CHANNEL_UP   <= CHANNEL_UP_Buffer;
    START_RX     <= START_RX_Buffer;
    GEN_VER      <= GEN_VER_Buffer;

    tied_to_vcc  <= '1';
    tied_to_gnd  <= '0';

-- Main Body of Code --

    -- Main state machine for bonding and verification --

    -- State registers

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RESET or RESET_CHANNEL) = '1') then

                wait_for_lane_up_r <= '1' after DLY;
                channel_bond_r     <= '0' after DLY;
                check_bond_r       <= '0' after DLY;
                verify_r           <= '0' after DLY;
                ready_r            <= '0' after DLY;

            else

                wait_for_lane_up_r <= '0' after DLY;
                channel_bond_r     <= next_channel_bond_c after DLY;
                check_bond_r       <= next_check_bond_c after DLY;
                verify_r           <= next_verify_c after DLY;
                ready_r            <= next_ready_c after DLY;

            end if;

        end if;

    end process;


    -- Next state logic

    next_channel_bond_c <= wait_for_lane_up_r or
                           (channel_bond_r and not bond_passed_r) or
                           (check_bond_r and bad_as_r);

    next_check_bond_c   <= (channel_bond_r and bond_passed_r ) or
                           ((check_bond_r and not four_as_r) and not bad_as_r);

    next_verify_c       <= ((check_bond_r and four_as_r) and not bad_as_r) or
                           (verify_r and (not rxver_3d_done_r or not txver_8d_done_r));

    next_ready_c        <= ((verify_r and txver_8d_done_r) and rxver_3d_done_r) or
                           ready_r;


    -- Output Logic

    -- Channel up is high as long as the Global Logic is in the ready state.

    CHANNEL_UP_Buffer <= ready_r;


    -- Turn the receive engine on as soon as all the lanes are up.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (RESET = '1') then

                START_RX_Buffer <= '0' after DLY;

            else

                START_RX_Buffer <= not wait_for_lane_up_r after DLY;

            end if;

        end if;

    end process;


    -- Generate the Verification sequence when in the verify state.

    GEN_VER_Buffer <= verify_r;


    -- Channel Reset --

    -- Some problems during channel bonding and verification require the lanes to
    -- be reset.  When this happens, we assert the Reset Lanes signal, which gets
    -- sent to all Aurora Lanes.  When the Aurora Lanes reset, their LANE_UP signals
    -- go down.  This causes the Channel Error Detector to assert the Reset Channel
    -- signal.

    reset_lanes_c <= (verify_r and verify_watchdog_done_r) or
                     ((verify_r and bad_v_r) and not rxver_3d_done_r) or
                     (channel_bond_r and bonding_watchdog_done_r) or
                     (check_bond_r and bonding_watchdog_done_r) or
                     (RESET_CHANNEL and not wait_for_lane_up_r) or
                     RESET;


    reset_lanes_flop_0_i : FD
        generic map (INIT => '1')
        port map (

                    D => reset_lanes_c,
                    C => USER_CLK,
                    Q => RESET_LANES_Buffer(0)

                 );


    reset_lanes_flop_1_i : FD
        generic map (INIT => '1')
        port map (

                    D => reset_lanes_c,
                    C => USER_CLK,
                    Q => RESET_LANES_Buffer(1)

                 );


    -- Watchdog timers --

    -- We create a free counter out of SRLs to count large values without excessive cost.

    free_count_1_i : SRL16
        generic map (INIT => X"8000")
        port map (

                    Q   => free_count_1_r,
                    A0  => tied_to_vcc,
                    A1  => tied_to_vcc,
                    A2  => tied_to_vcc,
                    A3  => tied_to_vcc,
                    CLK => USER_CLK,
                    D   => free_count_1_r

                 );


    free_count_2_i : SRL16E
        generic map (INIT => X"8000")
        port map (

                    Q   => free_count_2_r,
                    A0  => tied_to_vcc,
                    A1  => tied_to_vcc,
                    A2  => tied_to_vcc,
                    A3  => tied_to_vcc,
                    CLK => USER_CLK,
                    CE  => free_count_1_r,
                    D   => free_count_2_r

                 );


    -- The watchdog extention SRLs are used to multiply the free count by 32
    extend_watchdogs_1_i :SRL16E 
    port map
    (
        Q       =>  extend_watchdogs_1_r,
        A0      =>  tied_to_vcc,
        A1      =>  tied_to_vcc,
        A2      =>  tied_to_vcc,
        A3      =>  tied_to_vcc,
        CLK     =>  USER_CLK,
        CE      =>  free_count_1_r,
        D       =>  extend_watchdogs_n_c
    );
    
    
    extend_watchdogs_2_i :SRL16E 
    port map
    (
        Q       =>  extend_watchdogs_2_r,
        A0      =>  tied_to_vcc,
        A1      =>  tied_to_vcc,
        A2      =>  tied_to_vcc,
        A3      =>  tied_to_vcc,
        CLK     =>  USER_CLK,
        CE      =>  free_count_1_r,
        D       =>  extend_watchdogs_1_r
    );    
    
    extend_watchdogs_n_c <=   not extend_watchdogs_2_r;
    
    process (USER_CLK)
    begin
        if( USER_CLK'event and USER_CLK='1') then
            extend_watchdogs_n_r    <=  extend_watchdogs_n_c;
        end if;
    end process;




    -- Finally we have logic hat registers a pulse when both the inner and the
    -- outer SRLs have a bit in their last position.  This should map to carry logic
    -- and a register.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then
            if(EXTEND_WATCHDOGS) then
                free_count_done_r <= extend_watchdogs_2_r and extend_watchdogs_n_r after DLY;
            else
                free_count_done_r <= free_count_2_r and free_count_1_r after DLY;
            end if;
        end if;

    end process;


    -- We use the free running count as a CE for the verify watchdog.  The
    -- count runs continuously so the watchdog will vary between a count of 4096
    -- and 3840 cycles - acceptable for this application.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((free_count_done_r or not verify_r) = '1') then

                verify_watchdog_r <= verify_r & verify_watchdog_r(0 to 14) after DLY;

            end if;

        end if;

    end process;


    verify_watchdog_done_r <= verify_watchdog_r(15);


    -- The channel bonding watchdog is triggered when the channel_bond_load
    -- signal has been asserted 16 times in the channel_bonding state without
    -- continuing or resetting.  If this happens, we reset the lanes.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((not (channel_bond_r or check_bond_r) or all_channel_bond_load_r or free_count_done_r) = '1') then

                bonding_watchdog_r <= channel_bond_r & bonding_watchdog_r(0 to 14) after DLY;

            end if;

        end if;

    end process;


    bonding_watchdog_done_r <= bonding_watchdog_r(15);


    -- Channel Bonding --

    -- We send the EN_CHAN_SYNC signal to the master lane.

    en_chan_sync_flop_i : FD

        generic map (INIT => '0')

        port map (

                    D => channel_bond_r,
                    C => USER_CLK,
                    Q => EN_CHAN_SYNC_Buffer

                 );


    -- This first wide AND gate collects the CH_BOND_DONE signals.  We register the
    -- output of the AND gate.  Note that register is a one shot that is reset
    -- only when the state changes.

    all_ch_bond_done_c <= CH_BOND_DONE(0) and
                          CH_BOND_DONE(1);


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (channel_bond_r = '0') then

                all_ch_bond_done_r <= '0' after DLY;

            else

                if (all_ch_bond_done_c = '1') then

                    all_ch_bond_done_r <= '1' after DLY;

                end if;

            end if;

        end if;

    end process;


    -- This wide AND gate collects the CHANNEL_BOND_LOAD signals from each lane.
    -- We register the output of the AND gate.

    all_channel_bond_load_c <= CHANNEL_BOND_LOAD(0) and
                               CHANNEL_BOND_LOAD(1);


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            all_channel_bond_load_r <= all_channel_bond_load_c after DLY;

        end if;

    end process;


    -- Assert bond_passed_r if all_channel_bond_load_r goes high with all_ch_bond_done_r high.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            bond_passed_r <= all_ch_bond_done_r and all_channel_bond_load_r after DLY;

        end if;

    end process;


    -- Good_as_r is asserted as long as no bad As are detected.  Bad As are As that do
    -- not arrive with the rest of the As in the channel.

    all_as_c(0) <= GOT_A(0) and
                   GOT_A(4);


    all_as_c(1) <= GOT_A(1) and
                   GOT_A(5);


    all_as_c(2) <= GOT_A(2) and
                   GOT_A(6);


    all_as_c(3) <= GOT_A(3) and
                   GOT_A(7);


    any_as_c(0) <= GOT_A(0) or
                   GOT_A(4);


    any_as_c(1) <= GOT_A(1) or
                   GOT_A(5);


    any_as_c(2) <= GOT_A(2) or
                   GOT_A(6);


    any_as_c(3) <= GOT_A(3) or
                   GOT_A(7);


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            good_as_r <= all_as_c(0) or all_as_c(1) or all_as_c(2) or all_as_c(3) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            bad_as_r <= std_bool((any_as_c and not all_as_c) /= "0000") after DLY;

        end if;

    end process;


    -- Four_as_r is asserted when you get 4 consecutive good As in check_bond state.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (check_bond_r = '0') then

                a_count_r <= "000" after DLY;

            else

                if (good_as_r = '1') then

                    a_count_r <= a_count_r + "001" after DLY;

                end if;

            end if;

        end if;

    end process;


    four_as_r <= a_count_r(0);


    -- Verification --

    -- Vs need to appear on all lanes simultaneously.

    all_lanes_v_c <= GOT_V(0) and
                     GOT_V(1);


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            all_lanes_v_r <= all_lanes_v_c after DLY;

        end if;

    end process;


    -- Vs need to be decoded by the aurora lane and then checked by the
    -- Global logic.  They must appear periodically.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (verify_r = '0') then

                got_first_v_r <= '0' after DLY;

            else

                if (all_lanes_v_r = '1') then

                    got_first_v_r <= '1' after DLY;

                end if;

            end if;

        end if;

    end process;


    insert_ver_c <= (all_lanes_v_r and not got_first_v_r) or (v_count_r(15) and verify_r);


    -- Shift register for measuring the time between V counts.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            v_count_r <= insert_ver_c & v_count_r(0 to 14) after DLY;

        end if;

    end process;


    -- Assert bad_v_r if a V does not arrive when expected.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            bad_v_r <= (v_count_r(15) xor all_lanes_v_r) and got_first_v_r after DLY;

        end if;

    end process;


    -- Count the number of Ver sequences received.  You're done after you receive four.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (((v_count_r(15) and all_lanes_v_r) or not verify_r) = '1') then

                rxver_count_r <= verify_r & rxver_count_r(0 to 1) after DLY;

            end if;

        end if;

    end process;


    rxver_3d_done_r <= rxver_count_r(2);


    -- Count the number of Ver sequences transmitted. You're done after you send eight.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((DID_VER or not verify_r) = '1') then

                txver_count_r <= verify_r & txver_count_r(0 to 6) after DLY;

            end if;

        end if;

    end process;


    txver_8d_done_r <= txver_count_r(7);

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:53 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: output_switch_control_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  OUTPUT_SWITCH_CONTROL
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: OUTPUT_SWITCH_CONTROL selects the input chunk for each muxed output chunk.
--
--               This module supports 4 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity OUTPUT_SWITCH_CONTROL is

    port (

            LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
            STORAGE_COUNT      : in std_logic_vector(0 to 2);
            END_STORAGE        : in std_logic;
            START_WITH_DATA    : in std_logic;
            OUTPUT_SELECT      : out std_logic_vector(0 to 19);
            USER_CLK           : in std_logic

         );

end OUTPUT_SWITCH_CONTROL;

architecture RTL of OUTPUT_SWITCH_CONTROL is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal OUTPUT_SELECT_Buffer : std_logic_vector(0 to 19);

-- Internal Register Declarations --

    signal output_select_c  : std_logic_vector(0 to 19);

-- Wire Declarations --

    signal take_storage_c   : std_logic;

begin

    OUTPUT_SELECT <= OUTPUT_SELECT_Buffer;


-- ***************************  Main Body of Code **************************** 

    -- Combine the End signals --

    take_storage_c <= END_STORAGE or START_WITH_DATA;


    -- Generate switch signals --

    -- Lane 0 is always connected to storage lane 0.

    -- Calculate switch setting for lane 1.
    process (take_storage_c, LEFT_ALIGNED_COUNT, STORAGE_COUNT)
        variable vec : std_logic_vector(0 to 5);
    begin
        if (take_storage_c = '1') then
            output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
        else
            vec := LEFT_ALIGNED_COUNT & STORAGE_COUNT;
            case vec is
                when "000001" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(1,5);
                when "000010" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "000011" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "000100" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "001001" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(1,5);
                when "001010" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "001011" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "001100" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "010001" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(1,5);
                when "010010" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "010011" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "010100" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "011001" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(1,5);
                when "011010" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "011011" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "011100" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "100001" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(1,5);
                when "100010" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "100011" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when "100100" =>
                    output_select_c(5 to 9) <= conv_std_logic_vector(0,5);
                when others =>
                    output_select_c(5 to 9) <= (others => 'X');
            end case;
        end if;
    end process;

    -- Calculate switch setting for lane 2.
    process (take_storage_c, LEFT_ALIGNED_COUNT, STORAGE_COUNT)
        variable vec : std_logic_vector(0 to 5);
    begin
        if (take_storage_c = '1') then
            output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
        else
            vec := LEFT_ALIGNED_COUNT & STORAGE_COUNT;
            case vec is
                when "000001" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(2,5);
                when "000010" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(1,5);
                when "000011" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "000100" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "001001" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(2,5);
                when "001010" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(1,5);
                when "001011" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "001100" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "010001" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(2,5);
                when "010010" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(1,5);
                when "010011" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "010100" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "011001" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(2,5);
                when "011010" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(1,5);
                when "011011" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "011100" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "100001" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(2,5);
                when "100010" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(1,5);
                when "100011" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when "100100" =>
                    output_select_c(10 to 14) <= conv_std_logic_vector(0,5);
                when others =>
                    output_select_c(10 to 14) <= (others => 'X');
            end case;
        end if;
    end process;

    -- Calculate switch setting for lane 3.
    process (take_storage_c, LEFT_ALIGNED_COUNT, STORAGE_COUNT)
        variable vec : std_logic_vector(0 to 5);
    begin
        if (take_storage_c = '1') then
            output_select_c(15 to 19) <= conv_std_logic_vector(0,5);
        else
            vec := LEFT_ALIGNED_COUNT & STORAGE_COUNT;
            case vec is
                when "000001" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(3,5);
                when "000010" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(2,5);
                when "000011" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(1,5);
                when "000100" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(0,5);
                when "001001" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(3,5);
                when "001010" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(2,5);
                when "001011" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(1,5);
                when "001100" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(0,5);
                when "010001" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(3,5);
                when "010010" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(2,5);
                when "010011" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(1,5);
                when "010100" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(0,5);
                when "011001" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(3,5);
                when "011010" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(2,5);
                when "011011" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(1,5);
                when "011100" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(0,5);
                when "100001" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(3,5);
                when "100010" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(2,5);
                when "100011" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(1,5);
                when "100100" =>
                    output_select_c(15 to 19) <= conv_std_logic_vector(0,5);
                when others =>
                    output_select_c(15 to 19) <= (others => 'X');
            end case;
        end if;
    end process;


    -- Register the output select values.
    process (USER_CLK)
    begin
        if (USER_CLK 'event and USER_CLK = '1') then
            OUTPUT_SELECT_Buffer <= "00000" & output_select_c(5 to 19) after DLY;
        end if;
    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:53 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: output_mux_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  OUTPUT_MUX
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: The OUTPUT_MUX controls the flow of data to the LocalLink output
--               for user PDUs.
--
--               This module supports 4 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity OUTPUT_MUX is

    port (

            STORAGE_DATA      : in std_logic_vector(0 to 63);
            LEFT_ALIGNED_DATA : in std_logic_vector(0 to 63);
            MUX_SELECT        : in std_logic_vector(0 to 19);
            USER_CLK          : in std_logic;
            OUTPUT_DATA       : out std_logic_vector(0 to 63)

         );

end OUTPUT_MUX;

architecture RTL of OUTPUT_MUX is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations

    signal OUTPUT_DATA_Buffer : std_logic_vector(0 to 63);

-- Internal Register Declarations --

    signal output_data_c : std_logic_vector(0 to 63);

begin

    OUTPUT_DATA <= OUTPUT_DATA_Buffer;

-- Main Body of Code --

    -- We create a set of muxes for each lane.  The number of inputs for each set of
    -- muxes increases as the lane index increases: lane 0 has one input only, the
    -- rightmost lane has 4 inputs.  Note that the 0th input connection
    -- is always to the storage lane with the same index as the output lane: the
    -- remaining inputs connect to the left_aligned data register, starting at index 0.

    -- Mux for lane 0

    process (MUX_SELECT(0 to 4), STORAGE_DATA)

    begin

        case MUX_SELECT(0 to 4) is

            when "00000" =>

                output_data_c(0 to 15) <= STORAGE_DATA(0 to 15);

            when others =>

                output_data_c(0 to 15) <= (others => 'X');

        end case;

    end process;


    -- Mux for lane 1

    process (MUX_SELECT(5 to 9), STORAGE_DATA, LEFT_ALIGNED_DATA)

    begin

        case MUX_SELECT(5 to 9) is

            when "00000" =>

                output_data_c(16 to 31) <= STORAGE_DATA(16 to 31);

            when "00001" =>

                output_data_c(16 to 31) <= LEFT_ALIGNED_DATA(0 to 15);

            when others =>

                output_data_c(16 to 31) <= (others => 'X');

        end case;

    end process;


    -- Mux for lane 2

    process (MUX_SELECT(10 to 14), STORAGE_DATA, LEFT_ALIGNED_DATA)

    begin

        case MUX_SELECT(10 to 14) is

            when "00000" =>

                output_data_c(32 to 47) <= STORAGE_DATA(32 to 47);

            when "00001" =>

                output_data_c(32 to 47) <= LEFT_ALIGNED_DATA(0 to 15);

            when "00010" =>

                output_data_c(32 to 47) <= LEFT_ALIGNED_DATA(16 to 31);

            when others =>

                output_data_c(32 to 47) <= (others => 'X');

        end case;

    end process;


    -- Mux for lane 3

    process (MUX_SELECT(15 to 19), STORAGE_DATA, LEFT_ALIGNED_DATA)

    begin

        case MUX_SELECT(15 to 19) is

            when "00000" =>

                output_data_c(48 to 63) <= STORAGE_DATA(48 to 63);

            when "00001" =>

                output_data_c(48 to 63) <= LEFT_ALIGNED_DATA(0 to 15);

            when "00010" =>

                output_data_c(48 to 63) <= LEFT_ALIGNED_DATA(16 to 31);

            when "00011" =>

                output_data_c(48 to 63) <= LEFT_ALIGNED_DATA(32 to 47);

            when others =>

                output_data_c(48 to 63) <= (others => 'X');

        end case;

    end process;


    -- Register the output data

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            OUTPUT_DATA_Buffer <= output_data_c after DLY;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:52 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: left_align_mux_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  LEFT_ALIGN_MUX
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: The left align mux is used to shift incoming data symbols
--               leftwards in the channel during the RX_LL left align step.
--               It consists of a set of muxes, one for each position in the
--               channel.  The number of inputs for each mux decrements as the
--               position gets further from the left: the muxes for the leftmost
--               position are N:1.  The 'muxes' for the rightmost position are 1:1
--
--               This module supports 4 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity LEFT_ALIGN_MUX is

    port (

            RAW_DATA   : in std_logic_vector(0 to 63);
            MUX_SELECT : in std_logic_vector(0 to 11);
            USER_CLK   : in std_logic;
            MUXED_DATA : out std_logic_vector(0 to 63)

         );

end LEFT_ALIGN_MUX;

architecture RTL of LEFT_ALIGN_MUX is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal MUXED_DATA_Buffer : std_logic_vector(0 to 63);

-- Internal Register Declarations --

    signal muxed_data_c : std_logic_vector(0 to 63);

begin

    MUXED_DATA <= MUXED_DATA_Buffer;

-- Main Body of Code --

    -- We create muxes for each of the lanes.

    -- Mux for lane 0

    process (MUX_SELECT(0 to 2), RAW_DATA)

    begin

        case MUX_SELECT(0 to 2) is

            when "000" =>

                muxed_data_c(0 to 15) <= RAW_DATA(0 to 15);

            when "001" =>

                muxed_data_c(0 to 15) <= RAW_DATA(16 to 31);

            when "010" =>

                muxed_data_c(0 to 15) <= RAW_DATA(32 to 47);

            when "011" =>

                muxed_data_c(0 to 15) <= RAW_DATA(48 to 63);

            when others =>

                muxed_data_c(0 to 15) <= (others => 'X');

        end case;

    end process;


    -- Mux for lane 1

    process (MUX_SELECT(3 to 5), RAW_DATA)

    begin

        case MUX_SELECT(3 to 5) is

            when "000" =>

                muxed_data_c(16 to 31) <= RAW_DATA(16 to 31);

            when "001" =>

                muxed_data_c(16 to 31) <= RAW_DATA(32 to 47);

            when "010" =>

                muxed_data_c(16 to 31) <= RAW_DATA(48 to 63);

            when others =>

                muxed_data_c(16 to 31) <= (others => 'X');

        end case;

    end process;


    -- Mux for lane 2

    process (MUX_SELECT(6 to 8), RAW_DATA)

    begin

        case MUX_SELECT(6 to 8) is

            when "000" =>

                muxed_data_c(32 to 47) <= RAW_DATA(32 to 47);

            when "001" =>

                muxed_data_c(32 to 47) <= RAW_DATA(48 to 63);

            when others =>

                muxed_data_c(32 to 47) <= (others => 'X');

        end case;

    end process;


    -- Mux for lane 3

    process (MUX_SELECT(9 to 11), RAW_DATA)

    begin

        case MUX_SELECT(9 to 11) is

            when "000" =>

                muxed_data_c(48 to 63) <= RAW_DATA(48 to 63);

            when others =>

                muxed_data_c(48 to 63) <= (others => 'X');

        end case;

    end process;


    -- Register the muxed data.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            MUXED_DATA_Buffer <= muxed_data_c after DLY;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/16 00:32:43 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: global_logic_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.5 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  GLOBAL_LOGIC
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: The GLOBAL_LOGIC module handles channel bonding, channel
--               verification, channel error manangement and idle generation.
--
--               This module supports 2 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity GLOBAL_LOGIC is
    generic (
            EXTEND_WATCHDOGS   : boolean := FALSE
    );
    port (

    -- MGT Interface

            CH_BOND_DONE       : in std_logic_vector(0 to 1);
            EN_CHAN_SYNC       : out std_logic;

    -- Aurora Lane Interface

            LANE_UP            : in std_logic_vector(0 to 1);
            SOFT_ERROR         : in std_logic_vector(0 to 3);
            HARD_ERROR         : in std_logic_vector(0 to 1);
            CHANNEL_BOND_LOAD  : in std_logic_vector(0 to 1);
            GOT_A              : in std_logic_vector(0 to 7);
            GOT_V              : in std_logic_vector(0 to 1);
            GEN_A              : out std_logic_vector(0 to 1);
            GEN_K              : out std_logic_vector(0 to 7);
            GEN_R              : out std_logic_vector(0 to 7);
            GEN_V              : out std_logic_vector(0 to 7);
            RESET_LANES        : out std_logic_vector(0 to 1);

    -- System Interface

            USER_CLK           : in std_logic;
            RESET              : in std_logic;
            POWER_DOWN         : in std_logic;
            CHANNEL_UP         : out std_logic;
            START_RX           : out std_logic;
            CHANNEL_SOFT_ERROR : out std_logic;
            CHANNEL_HARD_ERROR : out std_logic

         );

end GLOBAL_LOGIC;

architecture MAPPED of GLOBAL_LOGIC is

-- External Register Declarations --

    signal EN_CHAN_SYNC_Buffer       : std_logic;
    signal GEN_A_Buffer              : std_logic_vector(0 to 1);
    signal GEN_K_Buffer              : std_logic_vector(0 to 7);
    signal GEN_R_Buffer              : std_logic_vector(0 to 7);
    signal GEN_V_Buffer              : std_logic_vector(0 to 7);
    signal RESET_LANES_Buffer        : std_logic_vector(0 to 1);
    signal CHANNEL_UP_Buffer         : std_logic;
    signal START_RX_Buffer           : std_logic;
    signal CHANNEL_SOFT_ERROR_Buffer : std_logic;
    signal CHANNEL_HARD_ERROR_Buffer : std_logic;

-- Wire Declarations --

    signal gen_ver_i       : std_logic;
    signal reset_channel_i : std_logic;
    signal did_ver_i       : std_logic;

-- Component Declarations --

    component CHANNEL_INIT_SM
        generic (
                EXTEND_WATCHDOGS  : boolean := FALSE
        );
        port (

        -- MGT Interface

                CH_BOND_DONE      : in std_logic_vector(0 to 1);
                EN_CHAN_SYNC      : out std_logic;

        -- Aurora Lane Interface

                CHANNEL_BOND_LOAD : in std_logic_vector(0 to 1);
                GOT_A             : in std_logic_vector(0 to 7);
                GOT_V             : in std_logic_vector(0 to 1);
                RESET_LANES       : out std_logic_vector(0 to 1);

        -- System Interface

                USER_CLK          : in std_logic;
                RESET             : in std_logic;
                CHANNEL_UP        : out std_logic;
                START_RX          : out std_logic;

        -- Idle and Verification Sequence Generator Interface

                DID_VER           : in std_logic;
                GEN_VER           : out std_logic;

        -- Channel Init State Machine Interface

                RESET_CHANNEL     : in std_logic

             );

    end component;


    component IDLE_AND_VER_GEN

        port (

        -- Channel Init SM Interface

                GEN_VER  : in std_logic;
                DID_VER  : out std_logic;

        -- Aurora Lane Interface

                GEN_A    : out std_logic_vector(0 to 1);
                GEN_K    : out std_logic_vector(0 to 7);
                GEN_R    : out std_logic_vector(0 to 7);
                GEN_V    : out std_logic_vector(0 to 7);

        -- System Interface

                RESET    : in std_logic;
                USER_CLK : in std_logic

             );

    end component;


    component CHANNEL_ERROR_DETECT

        port (

        -- Aurora Lane Interface

                SOFT_ERROR         : in std_logic_vector(0 to 3);
                HARD_ERROR         : in std_logic_vector(0 to 1);
                LANE_UP            : in std_logic_vector(0 to 1);

        -- System Interface

                USER_CLK           : in std_logic;
                POWER_DOWN         : in std_logic;

                CHANNEL_SOFT_ERROR : out std_logic;
                CHANNEL_HARD_ERROR : out std_logic;

        -- Channel Init SM Interface

                RESET_CHANNEL      : out std_logic

             );

    end component;

begin

    EN_CHAN_SYNC       <= EN_CHAN_SYNC_Buffer;
    GEN_A              <= GEN_A_Buffer;
    GEN_K              <= GEN_K_Buffer;
    GEN_R              <= GEN_R_Buffer;
    GEN_V              <= GEN_V_Buffer;
    RESET_LANES        <= RESET_LANES_Buffer;
    CHANNEL_UP         <= CHANNEL_UP_Buffer;
    START_RX           <= START_RX_Buffer;
    CHANNEL_SOFT_ERROR <= CHANNEL_SOFT_ERROR_Buffer;
    CHANNEL_HARD_ERROR <= CHANNEL_HARD_ERROR_Buffer;

-- Main Body of Code --

    -- State Machine for channel bonding and verification.

    channel_init_sm_i : CHANNEL_INIT_SM
        generic map (
                    EXTEND_WATCHDOGS => EXTEND_WATCHDOGS
        )
        port map (

        -- MGT Interface

                    CH_BOND_DONE => CH_BOND_DONE,
                    EN_CHAN_SYNC => EN_CHAN_SYNC_Buffer,

        -- Aurora Lane Interface

                    CHANNEL_BOND_LOAD => CHANNEL_BOND_LOAD,
                    GOT_A => GOT_A,
                    GOT_V => GOT_V,
                    RESET_LANES => RESET_LANES_Buffer,

        -- System Interface

                    USER_CLK => USER_CLK,
                    RESET => RESET,
                    START_RX => START_RX_Buffer,
                    CHANNEL_UP => CHANNEL_UP_Buffer,

        -- Idle and Verification Sequence Generator Interface

                    DID_VER => did_ver_i,
                    GEN_VER => gen_ver_i,

        -- Channel Error Management Module Interface

                    RESET_CHANNEL => reset_channel_i

                 );


    -- Idle and verification sequence generator module.

    idle_and_ver_gen_i : IDLE_AND_VER_GEN

        port map (

        -- Channel Init SM Interface

                    GEN_VER => gen_ver_i,
                    DID_VER => did_ver_i,

        -- Aurora Lane Interface

                    GEN_A => GEN_A_Buffer,
                    GEN_K => GEN_K_Buffer,
                    GEN_R => GEN_R_Buffer,
                    GEN_V => GEN_V_Buffer,

        -- System Interface

                    RESET => RESET,
                    USER_CLK => USER_CLK

                 );



    -- Channel Error Management module.

    channel_error_detect_i : CHANNEL_ERROR_DETECT

        port map (

        -- Aurora Lane Interface

                    SOFT_ERROR => SOFT_ERROR,
                    HARD_ERROR => HARD_ERROR,
                    LANE_UP => LANE_UP,

        -- System Interface

                    USER_CLK => USER_CLK,
                    POWER_DOWN => POWER_DOWN,
                    CHANNEL_SOFT_ERROR => CHANNEL_SOFT_ERROR_Buffer,
                    CHANNEL_HARD_ERROR => CHANNEL_HARD_ERROR_Buffer,

        -- Channel Init State Machine Interface

                    RESET_CHANNEL => reset_channel_i

                 );

end MAPPED;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:54 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: rx_ll_deframer_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  RX_LL_DEFRAMER
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: The RX_LL_DEFRAMER extracts framing information from incoming channel
--               data beats.  It detects the start and end of frames, invalidates data
--               that is outside of a frame, and generates signals that go to the Output
--               and Storage blocks to indicate when the end of a frame has been detected.
--
--               This module supports 4 4-byte lane designs.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.all;
-- synthesis translate_on


entity RX_LL_DEFRAMER is

    port (

            PDU_DATA_V      : in std_logic_vector(0 to 3);
            PDU_SCP         : in std_logic_vector(0 to 3);
            PDU_ECP         : in std_logic_vector(0 to 3);
            USER_CLK        : in std_logic;
            RESET           : in std_logic;
            DEFRAMED_DATA_V : out std_logic_vector(0 to 3);
            IN_FRAME        : out std_logic_vector(0 to 3);
            AFTER_SCP       : out std_logic_vector(0 to 3)

         );

end RX_LL_DEFRAMER;

architecture RTL of RX_LL_DEFRAMER is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal DEFRAMED_DATA_V_Buffer : std_logic_vector(0 to 3);
    signal IN_FRAME_Buffer        : std_logic_vector(0 to 3);
    signal AFTER_SCP_Buffer       : std_logic_vector(0 to 3);

-- Internal Register Declarations --

    signal  in_frame_r : std_logic;
    signal  tied_gnd   : std_logic;
    signal  tied_vcc   : std_logic;

-- Wire Declarations --

    signal  carry_select_c     : std_logic_vector(0 to 3);
    signal  after_scp_select_c : std_logic_vector(0 to 3);
    signal  in_frame_c         : std_logic_vector(0 to 3);
    signal  after_scp_c        : std_logic_vector(0 to 3);

    component MUXCY

        port (

                O  : out std_logic;
                CI : in std_logic;
                DI : in std_logic;
                S  : in std_logic

             );

    end component;

begin

    DEFRAMED_DATA_V <= DEFRAMED_DATA_V_Buffer;
    IN_FRAME        <= IN_FRAME_Buffer;
    AFTER_SCP       <= AFTER_SCP_Buffer;

    tied_gnd <= '0';
    tied_vcc <= '1';

-- Main Body of Code --

    -- Mask Invalid data --

    -- Keep track of inframe status between clock cycles.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if(RESET = '1') then

                in_frame_r <= '0' after DLY;

            else

                in_frame_r <= in_frame_c(3) after DLY;

            end if;

        end if;

    end process;


    -- Combinatorial inframe detect for lane 0.

    carry_select_c(0) <= not PDU_ECP(0) and not PDU_SCP(0);

    in_frame_muxcy_0 : MUXCY

        port map (

                    O  => in_frame_c(0),
                    CI => in_frame_r,
                    DI => PDU_SCP(0),
                    S  => carry_select_c(0)

                 );


    -- Combinatorial inframe detect for 2-byte chunk 1.

    carry_select_c(1) <= not PDU_ECP(1) and not PDU_SCP(1);

    in_frame_muxcy_1 : MUXCY

        port map (

                    O  => in_frame_c(1),
                    CI => in_frame_c(0),
                    DI => PDU_SCP(1),
                    S  => carry_select_c(1)

                 );


    -- Combinatorial inframe detect for 2-byte chunk 2.

    carry_select_c(2) <= not PDU_ECP(2) and not PDU_SCP(2);

    in_frame_muxcy_2 : MUXCY

        port map (

                    O  => in_frame_c(2),
                    CI => in_frame_c(1),
                    DI => PDU_SCP(2),
                    S  => carry_select_c(2)

                 );


    -- Combinatorial inframe detect for 2-byte chunk 3.

    carry_select_c(3) <= not PDU_ECP(3) and not PDU_SCP(3);

    in_frame_muxcy_3 : MUXCY

        port map (

                    O  => in_frame_c(3),
                    CI => in_frame_c(2),
                    DI => PDU_SCP(3),
                    S  => carry_select_c(3)

                 );


    -- The data from a lane is valid if its valid signal is asserted and it is
    -- inside a frame.  Note the use of Bitwise AND.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (RESET = '1') then

                DEFRAMED_DATA_V_Buffer <= (others => '0') after DLY;

            else

                DEFRAMED_DATA_V_Buffer <= in_frame_c and PDU_DATA_V;

            end if;

        end if;

    end process;


    -- Register the inframe status.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (RESET = '1') then

                IN_FRAME_Buffer <= conv_std_logic_vector(0,4) after DLY;

            else

                IN_FRAME_Buffer <= in_frame_r & in_frame_c(0 to 2) after DLY;

            end if;

        end if;

    end process;


    -- Mark lanes that could contain data that occurs after an SCP. --

    -- Combinatorial data after start detect for lane 0.

    after_scp_select_c(0) <= not PDU_SCP(0);

    data_after_start_muxcy_0:MUXCY

        port map (

                    O  => after_scp_c(0),
                    CI => tied_gnd,
                    DI => tied_vcc,
                    S  => after_scp_select_c(0)

                 );


    -- Combinatorial data after start detect for lane1.

    after_scp_select_c(1) <= not PDU_SCP(1);

    data_after_start_muxcy_1:MUXCY

        port map (

                    O  => after_scp_c(1),
                    CI => after_scp_c(0),
                    DI => tied_vcc,
                    S  => after_scp_select_c(1)
                 );


    -- Combinatorial data after start detect for lane2.

    after_scp_select_c(2) <= not PDU_SCP(2);

    data_after_start_muxcy_2:MUXCY

        port map (

                    O  => after_scp_c(2),
                    CI => after_scp_c(1),
                    DI => tied_vcc,
                    S  => after_scp_select_c(2)
                 );


    -- Combinatorial data after start detect for lane3.

    after_scp_select_c(3) <= not PDU_SCP(3);

    data_after_start_muxcy_3:MUXCY

        port map (

                    O  => after_scp_c(3),
                    CI => after_scp_c(2),
                    DI => tied_vcc,
                    S  => after_scp_select_c(3)
                 );


    -- Register the output.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (RESET = '1') then

                AFTER_SCP_Buffer <= (others => '0');

            else

                AFTER_SCP_Buffer <= after_scp_c;

            end if;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:54 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: rx_ll_nfc_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  RX_LL_NFC
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: the RX_LL_NFC module detects, decodes and executes NFC messages
--               from the channel partner. When a message is recieved, the module
--               signals the TX_LL module that idles are required until the number
--               of idles the TX_LL module sends are enough to fulfil the request.
--
--               This module supports 4 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use WORK.AURORA.all;

entity RX_LL_NFC is

    port (

    -- Aurora Lane Interface

            RX_SNF        : in  std_logic_vector(0 to 3);
            RX_FC_NB      : in  std_logic_vector(0 to 15);

    -- TX_LL Interface

            DECREMENT_NFC : in  std_logic;
            TX_WAIT       : out std_logic;

    -- Global Logic Interface

            CHANNEL_UP    : in  std_logic;

    -- USER Interface

            USER_CLK      : in  std_logic

         );

end RX_LL_NFC;

architecture RTL of RX_LL_NFC is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal TX_WAIT_Buffer : std_logic;

-- Internal Register Declarations --

    signal load_nfc_r           : std_logic;
    signal fcnb_r               : std_logic_vector(0 to 3);
    signal nfc_counter_r        : std_logic_vector(0 to 8);
    signal xoff_r               : std_logic;
    signal fcnb_decode_c        : std_logic_vector(0 to 8);
    signal nfc_lane_index_r     : std_logic_vector(0 to 2);
    signal stage_1_load_nfc_r   : std_logic;
    signal channel_fcnb_r       : std_logic_vector(0 to 15);
    signal nfc_lane_index_c     : std_logic_vector(0 to 2);
    signal fcnb_c               : std_logic_vector(0 to 3);

begin

    TX_WAIT <= TX_WAIT_Buffer;

-- Main Body of Code --

    -- ________________Stage 1: Detect the most recent NFC message __________________

    -- Search for SNFs in the channel.  Output the index of the rightmost Lane in the
    -- channel constaining an SNF.
    process (RX_SNF)
    begin
        case RX_SNF is
            when "0001" =>
                nfc_lane_index_c <= conv_std_logic_vector(3,3);
            when "0010" =>
                nfc_lane_index_c <= conv_std_logic_vector(2,3);
            when "0011" =>
                nfc_lane_index_c <= conv_std_logic_vector(3,3);
            when "0100" =>
                nfc_lane_index_c <= conv_std_logic_vector(1,3);
            when "0101" =>
                nfc_lane_index_c <= conv_std_logic_vector(3,3);
            when "0110" =>
                nfc_lane_index_c <= conv_std_logic_vector(2,3);
            when "0111" =>
                nfc_lane_index_c <= conv_std_logic_vector(3,3);
            when "1000" =>
                nfc_lane_index_c <= conv_std_logic_vector(0,3);
            when "1001" =>
                nfc_lane_index_c <= conv_std_logic_vector(3,3);
            when "1010" =>
                nfc_lane_index_c <= conv_std_logic_vector(2,3);
            when "1011" =>
                nfc_lane_index_c <= conv_std_logic_vector(3,3);
            when "1100" =>
                nfc_lane_index_c <= conv_std_logic_vector(1,3);
            when "1101" =>
                nfc_lane_index_c <= conv_std_logic_vector(3,3);
            when "1110" =>
                nfc_lane_index_c <= conv_std_logic_vector(2,3);
            when "1111" =>
                nfc_lane_index_c <= conv_std_logic_vector(3,3);
            when others =>
                nfc_lane_index_c <= (others => 'X');
        end case;
    end process;


    -- Register the index of the most recent NFC lane.
    process (USER_CLK)
    begin
        if (USER_CLK 'event and USER_CLK = '1') then
            nfc_lane_index_r <= nfc_lane_index_c after DLY;
        end if;
    end process;


    -- Generate the load NFC signal if an NFC signal is detected.
    process (USER_CLK)
    begin
        if (USER_CLK 'event and USER_CLK = '1') then
            stage_1_load_nfc_r <= std_bool(RX_SNF /= "0000") after DLY;
        end if;
    end process;


    -- Register all the FC_NB signals.
    process (USER_CLK)
    begin
        if (USER_CLK 'event and USER_CLK = '1') then
            channel_fcnb_r <= RX_FC_NB after DLY;
        end if;
    end process;


    -- __________________Stage 2: Register the correct FCNB code ____________________

    -- Pipeline the load_nfc signal.
    process (USER_CLK)
    begin
        if (USER_CLK 'event and USER_CLK = '1') then
            if (CHANNEL_UP = '0') then
                load_nfc_r <= '0' after DLY;
            else
                load_nfc_r <= stage_1_load_nfc_r after DLY;
            end if;
        end if;
    end process;


    -- Select the appropriate FCNB code.
    process (nfc_lane_index_r, channel_fcnb_r)
    begin
        case nfc_lane_index_r is
            when "000" =>
                fcnb_c <= channel_fcnb_r(0 to 3);
            when "001" =>
                fcnb_c <= channel_fcnb_r(4 to 7);
            when "010" =>
                fcnb_c <= channel_fcnb_r(8 to 11);
            when "011" =>
                fcnb_c <= channel_fcnb_r(12 to 15);
            when others =>
                fcnb_c <= (others => 'X');
        end case;
    end process;


    -- Register the selected FCNB code.
    process (USER_CLK)
    begin
        if (USER_CLK 'event and USER_CLK = '1') then
            if (CHANNEL_UP = '0') then
                fcnb_r <= "0000" after DLY;
            else
                fcnb_r <= fcnb_c after DLY;
            end if;
        end if;
    end process;


    -- __________________Stage 3: Use the FCNB code to set the counter _____________

    -- We use a counter to keep track of the number of dead cycles we must produce to
    -- satisfy the NFC request from the Channel Partner.  Note we *increment* nfc_counter
    -- when decrement NFC is asserted.  This is because the nfc counter uses the difference
    -- between the max value and the current value to determine how many cycles to demand
    -- a pause.  This allows us to use the carry chain more effectively to save LUTS, and
    -- gives us a registered output from the counter.

    process (USER_CLK)
    begin
        if (USER_CLK 'event and USER_CLK = '1') then
            if (CHANNEL_UP = '0') then
                nfc_counter_r <= "100000000" after DLY;
            else
                if (load_nfc_r = '1') then
                    nfc_counter_r <= fcnb_decode_c after DLY;
                else
                    if ((not nfc_counter_r(0) and (DECREMENT_NFC and not xoff_r)) = '1') then
                        nfc_counter_r <= nfc_counter_r + "000000001" after DLY;
                    end if;
                end if;
            end if;
        end if;
    end process;


    -- We load the counter with a decoded version of the FCNB code.  The decode values are
    -- chosen such that the counter will assert TX_WAIT for the number of cycles required
    -- by the FCNB code.

    process (fcnb_r)
    begin
        case fcnb_r is
            when "0000" =>
                fcnb_decode_c <= "100000000"; -- XON
            when "0001" =>
                fcnb_decode_c <= "011111110"; -- 2
            when "0010" =>
                fcnb_decode_c <= "011111100"; -- 4
            when "0011" =>
                fcnb_decode_c <= "011111000"; -- 8
            when "0100" =>
                fcnb_decode_c <= "011110000"; -- 16
            when "0101" =>
                fcnb_decode_c <= "011100000"; -- 32
            when "0110" =>
                fcnb_decode_c <= "011000000"; -- 64
            when "0111" =>
                fcnb_decode_c <= "010000000"; -- 128
            when "1000" =>
                fcnb_decode_c <= "000000000"; -- 256
            when "1111" =>
                fcnb_decode_c <= "000000000"; -- 8
            when others =>
                fcnb_decode_c <= "100000000"; -- 8
        end case;
    end process;


    -- The XOFF signal forces an indefinite wait.  We decode FCNB to determine whether
    -- XOFF should be asserted.
    process (USER_CLK)
    begin
        if (USER_CLK 'event and USER_CLK = '1') then
            if (CHANNEL_UP = '0') then
                xoff_r <= '0' after DLY;
            else
                if (load_nfc_r = '1') then
                    if (fcnb_r = "1111") then
                        xoff_r <= '1' after DLY;
                    else
                        xoff_r <= '0' after DLY;
                    end if;
                end if;
            end if;
        end if;
    end process;


    -- The TXWAIT signal comes from the MSBit of the counter.  We wait whenever the counter
    -- is not at max value.

    TX_WAIT_Buffer <= not nfc_counter_r(0);

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:55 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: sideband_output_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  SIDEBAND_OUTPUT
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: SIDEBAND_OUTPUT generates the SRC_RDY_N, EOF_N, SOF_N and
--               RX_REM signals for the RX localLink interface.
--
--               This module supports 4 4-byte lane designs.
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use WORK.AURORA.all;

entity SIDEBAND_OUTPUT is

    port (

            LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
            STORAGE_COUNT      : in std_logic_vector(0 to 2);
            END_BEFORE_START   : in std_logic;
            END_AFTER_START    : in std_logic;
            START_DETECTED     : in std_logic;
            START_WITH_DATA    : in std_logic;
            PAD                : in std_logic;
            FRAME_ERROR        : in std_logic;
            USER_CLK           : in std_logic;
            RESET              : in std_logic;
            END_STORAGE        : out std_logic;
            SRC_RDY_N          : out std_logic;
            SOF_N              : out std_logic;
            EOF_N              : out std_logic;
            RX_REM             : out std_logic_vector(0 to 2);
            FRAME_ERROR_RESULT : out std_logic

         );

end SIDEBAND_OUTPUT;

architecture RTL of SIDEBAND_OUTPUT is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal END_STORAGE_Buffer        : std_logic;
    signal SRC_RDY_N_Buffer          : std_logic;
    signal SOF_N_Buffer              : std_logic;
    signal EOF_N_Buffer              : std_logic;
    signal RX_REM_Buffer             : std_logic_vector(0 to 2);
    signal FRAME_ERROR_RESULT_Buffer : std_logic;

-- Internal Register Declarations --

    signal start_next_r    : std_logic;
    signal start_storage_r : std_logic;
    signal end_storage_r   : std_logic;
    signal pad_storage_r   : std_logic;
    signal rx_rem_c        : std_logic_vector(0 to 3);

-- Wire Declarations --

    signal word_valid_c        : std_logic;
    signal total_lanes_c       : std_logic_vector(0 to 3);
    signal excess_c            : std_logic;
    signal storage_not_empty_c : std_logic;

begin

    END_STORAGE        <= END_STORAGE_Buffer;
    SRC_RDY_N          <= SRC_RDY_N_Buffer;
    SOF_N              <= SOF_N_Buffer;
    EOF_N              <= EOF_N_Buffer;
    RX_REM             <= RX_REM_Buffer;
    FRAME_ERROR_RESULT <= FRAME_ERROR_RESULT_Buffer;

-- Main Body of Code --

    -- Storage not Empty --

    -- Determine whether there is any data in storage.

    storage_not_empty_c <= std_bool(STORAGE_COUNT /= conv_std_logic_vector(0,3));


    -- Start Next Register --

    -- start_next_r indicates that the Start Storage Register should be set on the next
    -- cycle.  This condition occurs when an old frame ends, filling storage with ending
    -- data, and the SCP for the next cycle arrives on the same cycle.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RESET or FRAME_ERROR) = '1') then

                start_next_r <= '0' after DLY;

            else

                start_next_r <= (START_DETECTED and
                                not START_WITH_DATA) and
                                not END_AFTER_START after DLY;

            end if;

        end if;

    end process;


    -- Start Storage Register --

    -- Setting the start storage register indicates the data in storage is from
    -- the start of a frame.  The register is cleared when the data in storage is sent
    -- to the output.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RESET or FRAME_ERROR) = '1') then

                start_storage_r <= '0' after DLY;

            else

                if ((start_next_r or START_WITH_DATA) = '1') then

                    start_storage_r <= '1' after DLY;

                else

                    if (word_valid_c = '1') then

                        start_storage_r <= '0' after DLY;

                    end if;

                end if;

            end if;

        end if;

    end process;


    -- End Storage Register --

    -- Setting the end storage register indicates the data in storage is from the end
    -- of a frame.  The register is cleared when the data in storage is sent to the output.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RESET or FRAME_ERROR) = '1') then

                end_storage_r <= '0' after DLY;

            else

                if ((((END_BEFORE_START and not START_WITH_DATA) and std_bool(total_lanes_c /= "0000")) or
                    (END_AFTER_START and START_WITH_DATA)) = '1') then

                    end_storage_r <= '1' after DLY;

                else

                    end_storage_r <= '0' after DLY;

                end if;

            end if;

        end if;

    end process;


    END_STORAGE_Buffer <=  end_storage_r;


    -- Pad Storage Register --

    -- Setting the pad storage register indicates that the data in storage had a pad
    -- character associated with it.  The register is cleared when the data in storage
    -- is sent to the output.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RESET or FRAME_ERROR) = '1') then

                pad_storage_r <= '0' after DLY;

            else

                if (PAD = '1') then

                    pad_storage_r <= '1' after DLY;

                else

                    if (word_valid_c = '1') then

                        pad_storage_r <= '0' after DLY;

                    end if;

                end if;

            end if;

        end if;

    end process;


    -- Word Valid signal and SRC_RDY register --

    -- The word valid signal indicates that the output word has valid data.  This can
    -- only occur when data is removed from storage.  Furthermore, the data must be
    -- marked as valid so that the user knows to read the data as it appears on the
    -- LocalLink interface.

    word_valid_c <= (END_BEFORE_START and START_WITH_DATA) or
                    (excess_c and not START_WITH_DATA) or
                    (end_storage_r);


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((RESET or FRAME_ERROR) = '1') then

                SRC_RDY_N_Buffer <= '1' after DLY;

            else

                SRC_RDY_N_Buffer <= not word_valid_c after DLY;

            end if;

        end if;

    end process;


    -- Frame error result signal --
    -- Indicate a frame error whenever the deframer detects a frame error, or whenever
    -- a frame without data is detected.
    -- Empty frames are detected by looking for frames that end while the storage
    -- register is empty. We must be careful not to confuse the data from seperate
    -- frames.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            FRAME_ERROR_RESULT_Buffer <= FRAME_ERROR or

                                         (END_AFTER_START and not START_WITH_DATA) or
                                         (END_BEFORE_START and std_bool(total_lanes_c = "0000") and not START_WITH_DATA) or
                                         (END_BEFORE_START and START_WITH_DATA and not storage_not_empty_c) after DLY;

        end if;

    end process;




    -- The total_lanes and excess signals --

    -- When there is too much data to put into storage, the excess signal is asserted.

    total_lanes_c <= conv_std_logic_vector(0,4) + LEFT_ALIGNED_COUNT + STORAGE_COUNT;

    excess_c <= std_bool(total_lanes_c > conv_std_logic_vector(4,4));


    -- The Start of Frame signal --

    -- To save logic, start of frame is asserted from the time the start of a frame
    -- is placed in storage to the time it is placed on the locallink output register.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            SOF_N_Buffer <= not start_storage_r after DLY;

        end if;

    end process;


    -- The end of frame signal --

    -- End of frame is asserted when storage contains ended data, or when an ECP arrives
    -- at the same time as new data that must replace old data in storage.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            EOF_N_Buffer <= not (end_storage_r or ((END_BEFORE_START and
                START_WITH_DATA) and storage_not_empty_c)) after DLY;

        end if;

    end process;


    -- The RX_REM signal --

    -- RX_REM is equal to the number of bytes written to the output, minus 1 if there is
    -- a pad.

    process (PAD, pad_storage_r, START_WITH_DATA, end_storage_r, STORAGE_COUNT, total_lanes_c)

    begin

        if ((end_storage_r or START_WITH_DATA) = '1') then

            if (pad_storage_r = '1') then

                rx_rem_c <= conv_std_logic_vector(0,4) + ((STORAGE_COUNT & '0') - conv_std_logic_vector(2,4));

            else

                rx_rem_c <= conv_std_logic_vector(0,4) + ((STORAGE_COUNT & '0') - conv_std_logic_vector(1,4));

            end if;


        else

            if ((PAD or pad_storage_r) = '1') then

                rx_rem_c <= (total_lanes_c(1 to 3) & '0') - conv_std_logic_vector(2,4);

            else

                rx_rem_c <= (total_lanes_c(1 to 3) & '0') - conv_std_logic_vector(1,4);

            end if;


        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_REM_Buffer <= rx_rem_c(1 to 3) after DLY;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:55 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: storage_count_control_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  STORAGE_COUNT_CONTROL
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: STORAGE_COUNT_CONTROL sets the storage count value for the next clock
--               cycle
--
--              This module supports 4 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use WORK.AURORA.all;

entity STORAGE_COUNT_CONTROL is

    port (

            LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
            END_STORAGE        : in std_logic;
            START_WITH_DATA    : in std_logic;
            FRAME_ERROR        : in std_logic;
            STORAGE_COUNT      : out std_logic_vector(0 to 2);
            USER_CLK           : in std_logic;
            RESET              : in std_logic

         );

end STORAGE_COUNT_CONTROL;

architecture RTL of STORAGE_COUNT_CONTROL is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal STORAGE_COUNT_Buffer : std_logic_vector(0 to 2);

-- Internal Register Declarations --

    signal storage_count_c : std_logic_vector(0 to 2);
    signal storage_count_r : std_logic_vector(0 to 2);

-- Wire Declarations --

    signal overwrite_c : std_logic;
    signal sum_c       : std_logic_vector(0 to 3);
    signal remainder_c : std_logic_vector(0 to 3);
    signal overflow_c  : std_logic;

begin

    STORAGE_COUNT <= STORAGE_COUNT_Buffer;

-- Main Body of Code --

    -- Calculate the value that will be used for the switch.

    sum_c       <= conv_std_logic_vector(0,4) + LEFT_ALIGNED_COUNT + storage_count_r;
    remainder_c <= sum_c - conv_std_logic_vector(4,4);

    overwrite_c <= END_STORAGE or START_WITH_DATA;
    overflow_c  <= std_bool(sum_c > conv_std_logic_vector(4,4));


    process (overwrite_c, overflow_c, sum_c, remainder_c, LEFT_ALIGNED_COUNT)

        variable vec : std_logic_vector(0 to 1);

    begin

        vec := overwrite_c & overflow_c;

        case vec is

            when "00" =>

                storage_count_c <= sum_c(1 to 3);

            when "01" =>

                storage_count_c <= remainder_c(1 to 3);

            when "10" =>

                storage_count_c <= LEFT_ALIGNED_COUNT;

            when "11" =>

                storage_count_c <= LEFT_ALIGNED_COUNT;

            when others =>

                storage_count_c <= (others => 'X');

        end case;

    end process;


    -- Register the Storage Count for the next cycle.

    process (USER_CLK)

    begin

        if (USER_CLK'event and USER_CLK = '1') then

            if ((RESET or FRAME_ERROR) = '1') then

                storage_count_r <= (others => '0') after DLY;

            else

                storage_count_r <=  storage_count_c after DLY;

            end if;

        end if;

    end process;


    -- Make the output of the storage count register available to other modules.

    STORAGE_COUNT_Buffer <= storage_count_r;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:55 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: storage_ce_control_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  STORAGE_CE_CONTROL
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: the STORAGE_CE controls the enable signals of the the Storage register
--
--              This module supports 4 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use WORK.AURORA.all;

entity STORAGE_CE_CONTROL is

    port (

            LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
            STORAGE_COUNT      : in std_logic_vector(0 to 2);
            END_STORAGE        : in std_logic;
            START_WITH_DATA    : in std_logic;
            STORAGE_CE         : out std_logic_vector(0 to 3);
            USER_CLK           : in std_logic;
            RESET              : in std_logic

         );

end STORAGE_CE_CONTROL;

architecture RTL of STORAGE_CE_CONTROL is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal STORAGE_CE_Buffer : std_logic_vector(0 to 3);

-- Wire Declarations --

    signal overwrite_c  : std_logic;
    signal excess_c     : std_logic;
    signal ce_command_c : std_logic_vector(0 to 3);

begin

    STORAGE_CE <= STORAGE_CE_Buffer;

-- Main Body of Code --

    -- Combine the end signals.

    overwrite_c <= END_STORAGE or START_WITH_DATA;


    -- For each lane, determine the appropriate CE value.

    excess_c <= std_bool(( ("1" & LEFT_ALIGNED_COUNT) + ("1" & STORAGE_COUNT) ) > conv_std_logic_vector(4,4));

    ce_command_c(0) <= excess_c or std_bool(STORAGE_COUNT < conv_std_logic_vector(1,3)) or overwrite_c;
    ce_command_c(1) <= excess_c or std_bool(STORAGE_COUNT < conv_std_logic_vector(2,3)) or overwrite_c;
    ce_command_c(2) <= excess_c or std_bool(STORAGE_COUNT < conv_std_logic_vector(3,3)) or overwrite_c;
    ce_command_c(3) <= excess_c or std_bool(STORAGE_COUNT < conv_std_logic_vector(4,3)) or overwrite_c;


    -- Register the output.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (RESET = '1') then

                STORAGE_CE_Buffer <= (others => '0') after DLY;

            else

                STORAGE_CE_Buffer <= ce_command_c after DLY;

            end if;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:55 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: storage_switch_control_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--
------------------------------------------------------------------------------
--
--  STORAGE_SWITCH_CONTROL
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: STORAGE_SWITCH_CONTROL selects the input chunk for each storage chunk mux
--
--              This module supports 4 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity STORAGE_SWITCH_CONTROL is

    port (

            LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
            STORAGE_COUNT      : in std_logic_vector(0 to 2);
            END_STORAGE        : in std_logic;
            START_WITH_DATA    : in std_logic;
            STORAGE_SELECT     : out std_logic_vector(0 to 19);
            USER_CLK           : in std_logic

         );

end STORAGE_SWITCH_CONTROL;

architecture RTL of STORAGE_SWITCH_CONTROL is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal STORAGE_SELECT_Buffer : std_logic_vector(0 to 19);

-- Internal Register Declarations --

    signal end_r            : std_logic;
    signal lac_r            : std_logic_vector(0 to 2);
    signal stc_r            : std_logic_vector(0 to 2);
    signal storage_select_c : std_logic_vector(0 to 19);

-- Wire Declarations --

    signal overwrite_c   : std_logic;

begin

    STORAGE_SELECT <= STORAGE_SELECT_Buffer;

-- Main Body of Code --

    -- Combine the end signals.

    overwrite_c <= END_STORAGE or START_WITH_DATA;


    -- Generate switch signals --

    process (overwrite_c, LEFT_ALIGNED_COUNT, STORAGE_COUNT)

        variable vec : std_logic_vector(0 to 5);

    begin

        if (overwrite_c = '1') then

            storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

        else

            vec := LEFT_ALIGNED_COUNT & STORAGE_COUNT;

            case vec is

                when "001000" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

                when "001100" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

                when "010000" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

                when "010011" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(1,5);

                when "010100" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

                when "011000" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

                when "011010" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(2,5);

                when "011011" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(1,5);

                when "011100" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

                when "100000" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

                when "100001" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(3,5);

                when "100010" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(2,5);

                when "100011" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(1,5);

                when "100100" =>

                    storage_select_c(0 to 4) <= conv_std_logic_vector(0,5);

                when others =>

                    storage_select_c(0 to 4) <= (others => 'X');

            end case;

        end if;

    end process;


    process (overwrite_c, LEFT_ALIGNED_COUNT, STORAGE_COUNT)

        variable vec : std_logic_vector(0 to 5);

    begin

        if (overwrite_c = '1') then

            storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

        else

            vec := LEFT_ALIGNED_COUNT & STORAGE_COUNT;

            case vec is

                when "001000" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

                when "001001" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(0,5);

                when "001100" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

                when "010000" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

                when "010001" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(0,5);

                when "010011" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(2,5);

                when "010100" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

                when "011000" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

                when "011001" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(0,5);

                when "011010" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(3,5);

                when "011011" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(2,5);

                when "011100" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

                when "100000" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

                when "100010" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(3,5);

                when "100011" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(2,5);

                when "100100" =>

                    storage_select_c(5 to 9) <= conv_std_logic_vector(1,5);

                when others =>

                    storage_select_c(5 to 9) <= (others => 'X');

            end case;

        end if;

    end process;


    process (overwrite_c, LEFT_ALIGNED_COUNT, STORAGE_COUNT)

        variable vec : std_logic_vector(0 to 5);

    begin

        if (overwrite_c = '1') then

            storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

        else

            vec := LEFT_ALIGNED_COUNT & STORAGE_COUNT;

            case vec is

                when "001000" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

                when "001001" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(1,5);

                when "001010" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(0,5);

                when "001100" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

                when "010000" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

                when "010001" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(1,5);

                when "010010" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(0,5);

                when "010011" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(3,5);

                when "010100" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

                when "011000" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

                when "011001" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(1,5);

                when "011011" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(3,5);

                when "011100" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

                when "100000" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

                when "100011" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(3,5);

                when "100100" =>

                    storage_select_c(10 to 14) <= conv_std_logic_vector(2,5);

                when others =>

                    storage_select_c(10 to 14) <= (others => 'X');

            end case;

        end if;

    end process;


    process (overwrite_c, LEFT_ALIGNED_COUNT, STORAGE_COUNT)

        variable vec : std_logic_vector(0 to 5);

    begin

        if (overwrite_c = '1') then

            storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

        else

            vec := LEFT_ALIGNED_COUNT & STORAGE_COUNT;

            case vec is

                when "001000" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

                when "001001" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(2,5);

                when "001010" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(1,5);

                when "001011" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(0,5);

                when "001100" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

                when "010000" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

                when "010001" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(2,5);

                when "010010" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(1,5);

                when "010100" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

                when "011000" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

                when "011001" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(2,5);

                when "011100" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

                when "100000" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

                when "100100" =>

                    storage_select_c(15 to 19) <= conv_std_logic_vector(3,5);

                when others =>

                    storage_select_c(15 to 19) <= (others => 'X');

            end case;

        end if;

    end process;


    -- Register the storage select signals.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            STORAGE_SELECT_Buffer <= storage_select_c after DLY;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:55 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: sym_gen_4byte_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.1 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  SYM_GEN_4BYTE
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: The SYM_GEN module is a symbol generator for 4-byte Aurora Lanes.
--               Its inputs request the transmission of specific symbols, and its
--               outputs drive the MGT interface to fulfill those requests.
--
--               All generation request inputs must be asserted exclusively
--               except for the GEN_K, GEN_R and GEN_A signals from the Global
--               Logic, and the GEN_PAD and TX_PE_DATA_V signals from TX_LL.
--
--               GEN_K, GEN_R and GEN_A can be asserted anytime, but they are
--               ignored when other signals are being asserted.  This allows the
--               idle generator in the Global Logic to run continuously without
--               feedback, but requires the TX_LL and Lane Init SM modules to
--               be quiescent during Channel Bonding and Verification.
--
--               The GEN_PAD signal is only valid while the TX_PE_DATA_V signal
--               is asserted.  This allows padding to be specified for the LSB
--               of the data transmission.  GEN_PAD must not be asserted when
--               TX_PE_DATA_V is not asserted - this will generate errors.
--
--               This module supports Immediate Mode Native Flow Control.
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SYM_GEN_4BYTE is

    port (

    -- TX_LL Interface                                        -- See description for info about GEN_PAD and TX_PE_DATA_V.

            GEN_SCP      : in std_logic_vector(0 to 1);       -- Generate SCP.
            GEN_ECP      : in std_logic_vector(0 to 1);       -- Generate ECP.
            GEN_SNF      : in std_logic_vector(0 to 1);       -- Generate SNF using code given by FC_NB.
            GEN_PAD      : in std_logic_vector(0 to 1);       -- Replace LSB with Pad character.
            FC_NB        : in std_logic_vector(0 to 7);       -- Size code for Flow Control messages.
            TX_PE_DATA   : in std_logic_vector(0 to 31);      -- Data.  Transmitted when TX_PE_DATA_V is asserted.
            TX_PE_DATA_V : in std_logic_vector(0 to 1);       -- Transmit data.
            GEN_CC       : in std_logic;                      -- Generate Clock Correction symbols.

    -- Global Logic Interface                                 -- See description for info about GEN_K,GEN_R and GEN_A.

            GEN_A        : in std_logic;                      -- Generate A character for MSBYTE
            GEN_K        : in std_logic_vector(0 to 3);       -- Generate K character for selected bytes.
            GEN_R        : in std_logic_vector(0 to 3);       -- Generate R character for selected bytes.
            GEN_V        : in std_logic_vector(0 to 3);       -- Generate Ver data character on selected bytes.

    -- Lane Init SM Interface

            GEN_SP       : in std_logic;                      -- Generate SP pattern.
            GEN_SPA      : in std_logic;                      -- Generate SPA pattern.

    -- MGT Interface

            TX_CHAR_IS_K : out std_logic_vector(3 downto 0);  -- Transmit TX_DATA as a control character.
            TX_DATA      : out std_logic_vector(31 downto 0); -- Data to MGT for transmission to channel partner.

    -- System Interface

            USER_CLK     : in std_logic                       -- Clock for all non-MGT Aurora Logic.

         );

end SYM_GEN_4BYTE;

architecture RTL of SYM_GEN_4BYTE is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal TX_CHAR_IS_K_Buffer : std_logic_vector(3 downto 0);
    signal TX_DATA_Buffer      : std_logic_vector(31 downto 0);

-- Internal Register Declarations --

    -- Slack registers.  These registers allow slack for routing delay and automatic retiming.

    signal gen_scp_r      : std_logic_vector(0 to 1);
    signal gen_ecp_r      : std_logic_vector(0 to 1);
    signal gen_snf_r      : std_logic_vector(0 to 1);
    signal gen_pad_r      : std_logic_vector(0 to 1);
    signal fc_nb_r        : std_logic_vector(0 to 7);
    signal tx_pe_data_r   : std_logic_vector(0 to 31);
    signal tx_pe_data_v_r : std_logic_vector(0 to 1);
    signal gen_cc_r       : std_logic;
    signal gen_a_r        : std_logic;
    signal gen_k_r        : std_logic_vector(0 to 3);
    signal gen_r_r        : std_logic_vector(0 to 3);
    signal gen_v_r        : std_logic_vector(0 to 3);
    signal gen_sp_r       : std_logic;
    signal gen_spa_r      : std_logic;

-- Wire Declarations --

    signal idle_c         : std_logic_vector(0 to 3);

begin

    TX_CHAR_IS_K <= TX_CHAR_IS_K_Buffer;
    TX_DATA      <= TX_DATA_Buffer;

-- Main Body of Code --

    -- Register all inputs with the slack registers.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            gen_scp_r      <= GEN_SCP      after DLY;
            gen_ecp_r      <= GEN_ECP      after DLY;
            gen_snf_r      <= GEN_SNF      after DLY;
            gen_pad_r      <= GEN_PAD      after DLY;
            fc_nb_r        <= FC_NB        after DLY;
            tx_pe_data_r   <= TX_PE_DATA   after DLY;
            tx_pe_data_v_r <= TX_PE_DATA_V after DLY;
            gen_cc_r       <= GEN_CC       after DLY;
            gen_a_r        <= GEN_A        after DLY;
            gen_k_r        <= GEN_K        after DLY;
            gen_r_r        <= GEN_R        after DLY;
            gen_v_r        <= GEN_V        after DLY;
            gen_sp_r       <= GEN_SP       after DLY;
            gen_spa_r      <= GEN_SPA      after DLY;

        end if;

    end process;


    -- Byte 0 --

    -- When none of the byte0 non_idle inputs are asserted, allow idle characters.

    idle_c(0) <= not (gen_scp_r(0)      or
                      gen_ecp_r(0)      or
                      gen_snf_r(0)      or
                      tx_pe_data_v_r(0) or
                      gen_cc_r          or
                      gen_sp_r          or
                      gen_spa_r         or
                      gen_v_r(0));



    -- Generate data for byte0.  Note that all inputs must be asserted exclusively, except
    -- for the GEN_A, GEN_K and GEN_R inputs which are ignored when other characters
    -- are asserted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (gen_scp_r(0) = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"5C" after DLY;                -- K28.2(SCP)

            end if;

            if (gen_ecp_r(0) = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"FD" after DLY;                -- K29.7(ECP)

            end if;

            if (gen_snf_r(0) = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"DC" after DLY;                -- K28.6(SNF)

            end if;

            if (tx_pe_data_v_r(0) = '1') then

                TX_DATA_Buffer(31 downto 24) <= tx_pe_data_r(0 to 7) after DLY; -- DATA

            end if;

            if (gen_cc_r = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"F7" after DLY;                -- K23.7(CC)

            end if;

            if ((idle_c(0) and gen_a_r) = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"7C" after DLY;                -- K28.3(A)

            end if;

            if ((idle_c(0) and gen_k_r(0)) = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"BC" after DLY;                -- K28.5(K)

            end if;

            if ((idle_c(0) and gen_r_r(0)) = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"1C" after DLY;                -- K28.0(R)

            end if;

            if (gen_sp_r = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"BC" after DLY;                -- K28.5(K)

            end if;

            if (gen_spa_r = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"BC" after DLY;                -- K28.5(K)

            end if;

            if (gen_v_r(0) = '1') then

                TX_DATA_Buffer(31 downto 24) <= X"E8" after DLY;                -- D8.7(Ver data)

            end if;

        end if;

    end process;


    -- Generate control signal for MSB.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            TX_CHAR_IS_K_Buffer(3) <= not (tx_pe_data_v_r(0) or
                                           gen_v_r(0)) after DLY;

        end if;

    end process;


    -- Byte 1 --

    -- When none of the byte1 non_idle inputs are asserted, allow idle characters.  Note
    -- that because gen_pad is only valid with the data valid signal, we only look at
    -- the data valid signal.

    idle_c(1) <= not (gen_scp_r(0)      or
                      gen_ecp_r(0)      or
                      gen_snf_r(0)      or
                      tx_pe_data_v_r(0) or
                      gen_cc_r          or
                      gen_sp_r          or
                      gen_spa_r         or
                      gen_v_r(1));


    -- Generate data for byte1.  Note that all inputs must be asserted exclusively except
    -- for the GEN_PAD signal and the GEN_K and GEN_R set.  GEN_PAD can be asserted
    -- at the same time as TX_DATA_VALID.  This will override TX_DATA valid and replace
    -- the lsb user data with a PAD character.  The GEN_K and GEN_R inputs are
    -- ignored if any other input is asserted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (gen_scp_r(0) = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"FB" after DLY;                        -- K27.7(SCP)

            end if;

            if (gen_ecp_r(0) = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"FE" after DLY;                        -- K30.7(ECP)

            end if;

            if (gen_snf_r(0) = '1') then

                TX_DATA_Buffer(23 downto 16) <= fc_nb_r(0 to 3) & "0000" after DLY;     -- SNF Data

            end if;

            if ((tx_pe_data_v_r(0) and gen_pad_r(0)) = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"9C" after DLY;                        -- K28.4(PAD)

            end if;

            if ((tx_pe_data_v_r(0) and not gen_pad_r(0)) = '1') then

                TX_DATA_Buffer(23 downto 16) <= tx_pe_data_r(8 to 15) after DLY;        -- DATA

            end if;

            if (gen_cc_r = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"F7" after DLY;                        -- K23.7(CC)

            end if;

            if ((idle_c(1) and gen_k_r(1)) = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"BC" after DLY;                        -- K28.5(K)

            end if;

            if ((idle_c(1) and gen_r_r(1)) = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"1C" after DLY;                        -- K28.0(R)

            end if;

            if (gen_sp_r = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"4A" after DLY;                        -- D10.2(SP data)

            end if;

            if (gen_spa_r = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"2C" after DLY;                        -- D12.1(SPA data)

            end if;

            if (gen_v_r(1) = '1') then

                TX_DATA_Buffer(23 downto 16) <= X"E8" after DLY;                        -- D8.7(Ver data)

            end if;

        end if;

    end process;


    -- Generate control signal for byte1.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            TX_CHAR_IS_K_Buffer(2) <= not ((tx_pe_data_v_r(0) and not gen_pad_r(0)) or
                                            gen_snf_r(0)      or
                                            gen_sp_r          or
                                            gen_spa_r         or
                                            gen_v_r(1)) after DLY;

        end if;

    end process;


    -- Byte 2 --

    -- When none of the byte2 non_idle inputs are asserted, allow idle characters.

    idle_c(2) <= not (gen_scp_r(1)      or
                      gen_ecp_r(1)      or
                      gen_snf_r(1)      or
                      tx_pe_data_v_r(1) or
                      gen_cc_r          or
                      gen_sp_r          or
                      gen_spa_r         or
                      gen_v_r(2));



    -- Generate data for byte2.  Note that all inputs must be asserted exclusively,
    -- except for the GEN_K and GEN_R inputs which are ignored when other
    -- characters are asserted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (gen_scp_r(1) = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"5C" after DLY;                  -- K28.2(SCP)

            end if;

            if (gen_ecp_r(1) = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"FD" after DLY;                  -- K29.7(ECP)

            end if;

            if (gen_snf_r(1) = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"DC" after DLY;                  -- K28.6(SNF)

            end if;

            if (tx_pe_data_v_r(1) = '1') then

                TX_DATA_Buffer(15 downto 8) <= tx_pe_data_r(16 to 23) after DLY; -- DATA

            end if;

            if (gen_cc_r = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"F7" after DLY;                  -- K23.7(CC)

            end if;

            if ((idle_c(2) and gen_k_r(2)) = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"BC" after DLY;                  -- K28.5(K)

            end if;

            if ((idle_c(2) and gen_r_r(2)) = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"1C" after DLY;                  -- K28.0(R)

            end if;

            if (gen_sp_r = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"4A" after DLY;                  -- D10.2(SP data)

            end if;

            if (gen_spa_r = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"2C" after DLY;                  -- D12.1(SPA data)

            end if;

            if (gen_v_r(2) = '1') then

                TX_DATA_Buffer(15 downto 8) <= X"E8" after DLY;                  -- D8.7(Ver data)

            end if;

        end if;

    end process;


    -- Generate control signal for MSB.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            TX_CHAR_IS_K_Buffer(1) <= not (tx_pe_data_v_r(1) or
                                           gen_sp_r          or
                                           gen_spa_r         or
                                           gen_v_r(2)) after DLY;

        end if;

    end process;


    -- Byte 3 --

    -- When none of the byte3 non_idle inputs are asserted, allow idle characters.
    -- Note that because gen_pad is only valid with the data valid signal, we only
    -- look at the data valid signal.

    idle_c(3) <= not (gen_scp_r(1)      or
                      gen_ecp_r(1)      or
                      gen_snf_r(1)      or
                      tx_pe_data_v_r(1) or
                      gen_cc_r          or
                      gen_sp_r          or
                      gen_spa_r         or
                      gen_v_r(3));



    -- Generate data for byte3.  Note that all inputs must be asserted exclusively
    -- except for the GEN_PAD signal and the GEN_K and GEN_R set.  GEN_PAD
    -- can be asserted at the same time as TX_DATA_VALID.  This will override
    -- TX_DATA valid and replace the lsb user data with a PAD character.  The GEN_K
    -- and GEN_R inputs are ignored if any other input is asserted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (gen_scp_r(1) = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"FB" after DLY;                    -- K27.7(SCP)

            end if;

            if (gen_ecp_r(1) = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"FE" after DLY;                    -- K30.7(ECP)

            end if;

            if (gen_snf_r(1) = '1') then

                TX_DATA_Buffer(7 downto 0) <= fc_nb_r(4 to 7) & "0000" after DLY; -- SNF Data

            end if;

            if ((tx_pe_data_v_r(1) and gen_pad_r(1)) = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"9C" after DLY;                    -- K28.4(PAD)

            end if;

            if ((tx_pe_data_v_r(1) and not gen_pad_r(1)) = '1') then

                TX_DATA_Buffer(7 downto 0) <= tx_pe_data_r(24 to 31) after DLY;   -- DATA

            end if;

            if (gen_cc_r = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"F7" after DLY;                    -- K23.7(CC)

            end if;

            if ((idle_c(3) and gen_k_r(3)) = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"BC" after DLY;                    -- K28.5(K)

            end if;

            if ((idle_c(3) and gen_r_r(3)) = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"1C" after DLY;                    -- K28.0(R)

            end if;

            if (gen_sp_r = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"4A" after DLY;                    -- D10.2(SP data)

            end if;

            if (gen_spa_r = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"2C" after DLY;                    -- D12.1(SPA data)

            end if;

            if (gen_v_r(3) = '1') then

                TX_DATA_Buffer(7 downto 0) <= X"E8" after DLY;                    -- D8.7(Ver data)

            end if;

        end if;

    end process;


    -- Generate control signal for byte3.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            TX_CHAR_IS_K_Buffer(0) <= not ((tx_pe_data_v_r(1) and not gen_pad_r(1)) or
                                            gen_snf_r(1)      or
                                            gen_sp_r          or
                                            gen_spa_r         or
                                            gen_v_r(3)) after DLY;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:55 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: sym_dec_4byte_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.1 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  SYM_DEC_4BYTE
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: The SYM_DEC_4BYTE module is a symbol decoder for the
--               4-byte Aurora Lane.  Its inputs are the raw data from
--               the MGT.  It word-aligns the regular data and decodes
--               all of the Aurora control symbols.  Its outputs are the
--               word-aligned data and signals indicating the arrival of
--               specific control characters.
--
--               This module supports Immediate Mode Native Flow Control.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.AURORA.all;

entity SYM_DEC_4BYTE is

    port (

    -- RX_LL Interface

            RX_PAD           : out std_logic_vector(0 to 1);     -- LSByte is PAD.
            RX_PE_DATA       : out std_logic_vector(0 to 31);    -- Word aligned data from channel partner.
            RX_PE_DATA_V     : out std_logic_vector(0 to 1);     -- Data is valid data and not a control character.
            RX_SCP           : out std_logic_vector(0 to 1);     -- SCP symbol received.
            RX_ECP           : out std_logic_vector(0 to 1);     -- ECP symbol received.
            RX_SNF           : out std_logic_vector(0 to 1);     -- SNF symbol received.
            RX_FC_NB         : out std_logic_vector(0 to 7);     -- Flow Control size code.  Valid with RX_SNF or RX_SUF.

    -- Lane Init SM Interface

            DO_WORD_ALIGN    : in std_logic;                     -- Word alignment is allowed.
            LANE_UP          : in std_logic;
            RX_SP            : out std_logic;                    -- SP sequence received with positive or negative data.
            RX_SPA           : out std_logic;                    -- SPA sequence received.
            RX_NEG           : out std_logic;                    -- Inverted data for SP or SPA received.

    -- Global Logic Interface

            GOT_A            : out std_logic_vector(0 to 3);     -- A character received on indicated byte(s).
            GOT_V            : out std_logic;                    -- V sequence received.

    -- MGT Interface

            RX_DATA          : in std_logic_vector(31 downto 0); -- Raw RX data from MGT.
            RX_CHAR_IS_K     : in std_logic_vector(3 downto 0);  -- Bits indicating which bytes are control characters.
            RX_CHAR_IS_COMMA : in std_logic_vector(3 downto 0);  -- Rx'ed a comma.

    -- System Interface

            USER_CLK         : in std_logic;                     -- System clock for all non-MGT Aurora Logic.
            RESET            : in std_logic

         );

end SYM_DEC_4BYTE;

architecture RTL of SYM_DEC_4BYTE is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

    constant K_CHAR_0       : std_logic_vector(0 to 3) := X"B";
    constant K_CHAR_1       : std_logic_vector(0 to 3) := X"C";
    constant SP_DATA_0      : std_logic_vector(0 to 3) := X"4";
    constant SP_DATA_1      : std_logic_vector(0 to 3) := X"A";
    constant SPA_DATA_0     : std_logic_vector(0 to 3) := X"2";
    constant SPA_DATA_1     : std_logic_vector(0 to 3) := X"C";
    constant SP_NEG_DATA_0  : std_logic_vector(0 to 3) := X"B";
    constant SP_NEG_DATA_1  : std_logic_vector(0 to 3) := X"5";
    constant SPA_NEG_DATA_0 : std_logic_vector(0 to 3) := X"D";
    constant SPA_NEG_DATA_1 : std_logic_vector(0 to 3) := X"3";
    constant PAD_0          : std_logic_vector(0 to 3) := X"9";
    constant PAD_1          : std_logic_vector(0 to 3) := X"C";
    constant SCP_0          : std_logic_vector(0 to 3) := X"5";
    constant SCP_1          : std_logic_vector(0 to 3) := X"C";
    constant SCP_2          : std_logic_vector(0 to 3) := X"F";
    constant SCP_3          : std_logic_vector(0 to 3) := X"B";
    constant ECP_0          : std_logic_vector(0 to 3) := X"F";
    constant ECP_1          : std_logic_vector(0 to 3) := X"D";
    constant ECP_2          : std_logic_vector(0 to 3) := X"F";
    constant ECP_3          : std_logic_vector(0 to 3) := X"E";
    constant SNF_0          : std_logic_vector(0 to 3) := X"D";
    constant SNF_1          : std_logic_vector(0 to 3) := X"C";
    constant A_CHAR_0       : std_logic_vector(0 to 3) := X"7";
    constant A_CHAR_1       : std_logic_vector(0 to 3) := X"C";
    constant VER_DATA_0     : std_logic_vector(0 to 3) := X"E";
    constant VER_DATA_1     : std_logic_vector(0 to 3) := X"8";

-- External Register Declarations --

    signal RX_PAD_Buffer       : std_logic_vector(0 to 1);
    signal RX_PE_DATA_Buffer   : std_logic_vector(0 to 31);
    signal RX_PE_DATA_V_Buffer : std_logic_vector(0 to 1);
    signal RX_SCP_Buffer       : std_logic_vector(0 to 1);
    signal RX_ECP_Buffer       : std_logic_vector(0 to 1);
    signal RX_SNF_Buffer       : std_logic_vector(0 to 1);
    signal RX_FC_NB_Buffer     : std_logic_vector(0 to 7);
    signal RX_SP_Buffer        : std_logic;
    signal RX_SPA_Buffer       : std_logic;
    signal RX_NEG_Buffer       : std_logic;
    signal GOT_A_Buffer        : std_logic_vector(0 to 3);
    signal GOT_V_Buffer        : std_logic;

-- Internal Register Declarations --

    signal left_align_select_r         : std_logic_vector(0 to 1);
    signal previous_cycle_data_r       : std_logic_vector(23 downto 0);
    signal previous_cycle_control_r    : std_logic_vector(2 downto 0);
    signal word_aligned_data_r         : std_logic_vector(0 to 31);
    signal word_aligned_control_bits_r : std_logic_vector(0 to 3);
    signal rx_pe_data_r                : std_logic_vector(0 to 31);
    signal rx_pe_control_r             : std_logic_vector(0 to 3);
    signal rx_pad_d_r                  : std_logic_vector(0 to 3);
    signal rx_scp_d_r                  : std_logic_vector(0 to 7);
    signal rx_ecp_d_r                  : std_logic_vector(0 to 7);
    signal rx_snf_d_r                  : std_logic_vector(0 to 3);
    signal rx_sp_r                     : std_logic_vector(0 to 7);
    signal rx_spa_r                    : std_logic_vector(0 to 7);
    signal rx_sp_neg_d_r               : std_logic_vector(0 to 1);
    signal rx_spa_neg_d_r              : std_logic_vector(0 to 1);
    signal rx_v_d_r                    : std_logic_vector(0 to 7);
    signal got_a_d_r                   : std_logic_vector(0 to 7);
    signal first_v_received_r          : std_logic := '0';

-- Wire Declarations --

    signal got_v_c : std_logic;

begin

    RX_PAD       <= RX_PAD_Buffer;
    RX_PE_DATA   <= RX_PE_DATA_Buffer;
    RX_PE_DATA_V <= RX_PE_DATA_V_Buffer;
    RX_SCP       <= RX_SCP_Buffer;
    RX_ECP       <= RX_ECP_Buffer;
    RX_SNF       <= RX_SNF_Buffer;
    RX_FC_NB     <= RX_FC_NB_Buffer;
    RX_SP        <= RX_SP_Buffer;
    RX_SPA       <= RX_SPA_Buffer;
    RX_NEG       <= RX_NEG_Buffer;
    GOT_A        <= GOT_A_Buffer;
    GOT_V        <= GOT_V_Buffer;

-- Main Body of Code --

    -- Word Alignment --

    -- Determine whether the lane is aligned to the left byte (MSByte) or the
    -- right byte (LSByte).  This information is used for word alignment. To
    -- prevent the word align from changing during normal operation, we do word
    -- alignment only when it is allowed by the lane_init_sm.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if ((DO_WORD_ALIGN and not first_v_received_r) = '1') then

                case RX_CHAR_IS_K is

                    when "1000" => left_align_select_r <= "00" after DLY;
                    when "0100" => left_align_select_r <= "01" after DLY;
                    when "0010" => left_align_select_r <= "10" after DLY;
                    when "1100" => left_align_select_r <= "01" after DLY;
                    when "1110" => left_align_select_r <= "10" after DLY;
                    when "0001" => left_align_select_r <= "11" after DLY;
                    when others => left_align_select_r <= left_align_select_r after DLY;

                end case;

            end if;

        end if;

    end process;


    -- Store bytes 1, 2 and 3 from the previous cycle.  If the lane is aligned
    -- on one of those bytes, we use the data in the current cycle.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            previous_cycle_data_r <= RX_DATA(23 downto 0) after DLY;

        end if;

    end process;


    -- Store the control bits from bytes 1, 2 and 3 from the previous cycle.  If
    -- we align on one of those bytes, we will also need to use their previous
    -- value control bits.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            previous_cycle_control_r <= RX_CHAR_IS_K(2 downto 0) after DLY;

        end if;

    end process;


    -- Select the word-aligned data byte 0.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case left_align_select_r is

                when "00"   => word_aligned_data_r(0 to 7) <= RX_DATA(31 downto 24) after DLY;
                when "01"   => word_aligned_data_r(0 to 7) <= previous_cycle_data_r(23 downto 16) after DLY;
                when "10"   => word_aligned_data_r(0 to 7) <= previous_cycle_data_r(15 downto 8) after DLY;
                when "11"   => word_aligned_data_r(0 to 7) <= previous_cycle_data_r(7 downto 0) after DLY;
                when others => word_aligned_data_r(0 to 7) <= "XXXXXXXX" after DLY;

            end case;

        end if;

    end process;


    -- Select the word-aligned data byte 1.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case left_align_select_r is

                when "00"   => word_aligned_data_r(8 to 15) <= RX_DATA(23 downto 16) after DLY;
                when "01"   => word_aligned_data_r(8 to 15) <= previous_cycle_data_r(15 downto 8) after DLY;
                when "10"   => word_aligned_data_r(8 to 15) <= previous_cycle_data_r(7 downto 0) after DLY;
                when "11"   => word_aligned_data_r(8 to 15) <= RX_DATA(31 downto 24) after DLY;
                when others => word_aligned_data_r(8 to 15) <= "XXXXXXXX" after DLY;

            end case;

        end if;

    end process;


    -- Select the word-aligned data byte 2.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case left_align_select_r is

                when "00"   => word_aligned_data_r(16 to 23) <= RX_DATA(15 downto 8) after DLY;
                when "01"   => word_aligned_data_r(16 to 23) <= previous_cycle_data_r(7 downto 0) after DLY;
                when "10"   => word_aligned_data_r(16 to 23) <= RX_DATA(31 downto 24) after DLY;
                when "11"   => word_aligned_data_r(16 to 23) <= RX_DATA(23 downto 16) after DLY;
                when others => word_aligned_data_r(16 to 23) <= "XXXXXXXX" after DLY;

            end case;

        end if;

    end process;


    -- Select the word-aligned data byte 3.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case left_align_select_r is

                when "00"   => word_aligned_data_r(24 to 31) <= RX_DATA(7 downto 0) after DLY;
                when "01"   => word_aligned_data_r(24 to 31) <= RX_DATA(31 downto 24) after DLY;
                when "10"   => word_aligned_data_r(24 to 31) <= RX_DATA(23 downto 16) after DLY;
                when "11"   => word_aligned_data_r(24 to 31) <= RX_DATA(15 downto 8) after DLY;
                when others => word_aligned_data_r(24 to 31) <= "XXXXXXXX" after DLY;

            end case;

        end if;

    end process;


    -- Select the word-aligned control bit 0.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case left_align_select_r is

                when "00"   => word_aligned_control_bits_r(0) <= RX_CHAR_IS_K(3) after DLY;
                when "01"   => word_aligned_control_bits_r(0) <= previous_cycle_control_r(2) after DLY;
                when "10"   => word_aligned_control_bits_r(0) <= previous_cycle_control_r(1) after DLY;
                when "11"   => word_aligned_control_bits_r(0) <= previous_cycle_control_r(0) after DLY;
                when others => word_aligned_control_bits_r(0) <= 'X' after DLY;

            end case;

        end if;

    end process;


    -- Select the word-aligned control bit 1.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case left_align_select_r is

                when "00"   => word_aligned_control_bits_r(1) <= RX_CHAR_IS_K(2) after DLY;
                when "01"   => word_aligned_control_bits_r(1) <= previous_cycle_control_r(1) after DLY;
                when "10"   => word_aligned_control_bits_r(1) <= previous_cycle_control_r(0) after DLY;
                when "11"   => word_aligned_control_bits_r(1) <= RX_CHAR_IS_K(3) after DLY;
                when others => word_aligned_control_bits_r(1) <= 'X' after DLY;

            end case;

        end if;

    end process;


    -- Select the word-aligned control bit 2.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case left_align_select_r is

                when "00"   => word_aligned_control_bits_r(2) <= RX_CHAR_IS_K(1) after DLY;
                when "01"   => word_aligned_control_bits_r(2) <= previous_cycle_control_r(0) after DLY;
                when "10"   => word_aligned_control_bits_r(2) <= RX_CHAR_IS_K(3) after DLY;
                when "11"   => word_aligned_control_bits_r(2) <= RX_CHAR_IS_K(2) after DLY;
                when others => word_aligned_control_bits_r(2) <= 'X' after DLY;

            end case;

        end if;

    end process;


    -- Select the word-aligned control bit 3.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            case left_align_select_r is

                when "00"   => word_aligned_control_bits_r(3) <= RX_CHAR_IS_K(0) after DLY;
                when "01"   => word_aligned_control_bits_r(3) <= RX_CHAR_IS_K(3) after DLY;
                when "10"   => word_aligned_control_bits_r(3) <= RX_CHAR_IS_K(2) after DLY;
                when "11"   => word_aligned_control_bits_r(3) <= RX_CHAR_IS_K(1) after DLY;
                when others => word_aligned_control_bits_r(3) <= 'X' after DLY;

            end case;

        end if;

    end process;


    -- Pipeline the word-aligned data for 1 cycle to match the Decodes.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_pe_data_r <= word_aligned_data_r after DLY;

        end if;

    end process;


    -- Register the pipelined word-aligned data for the RX_LL interface.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_PE_DATA_Buffer <= rx_pe_data_r after DLY;

        end if;

    end process;


    -- Decode Control Symbols --

    -- All decodes are pipelined to keep the number of logic levels to a minimum.

    -- Delay the control bits: they are most often used in the second stage of the
    -- decoding process.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_pe_control_r <= word_aligned_control_bits_r after DLY;

        end if;

    end process;


    -- Decode PAD.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_pad_d_r(0) <= std_bool(word_aligned_data_r(8 to 11)  = PAD_0) after DLY;
            rx_pad_d_r(1) <= std_bool(word_aligned_data_r(12 to 15) = PAD_1) after DLY;
            rx_pad_d_r(2) <= std_bool(word_aligned_data_r(24 to 27) = PAD_0) after DLY;
            rx_pad_d_r(3) <= std_bool(word_aligned_data_r(28 to 31) = PAD_1) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_PAD_Buffer(0) <= std_bool((rx_pad_d_r(0 to 1) = "11") and (rx_pe_control_r(0 to 1)) = "01") after DLY;
            RX_PAD_Buffer(1) <= std_bool((rx_pad_d_r(2 to 3) = "11") and (rx_pe_control_r(2 to 3)) = "01") after DLY;

        end if;

    end process;



    -- Decode RX_PE_DATA_V.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_PE_DATA_V_Buffer(0) <= not rx_pe_control_r(0) after DLY;
            RX_PE_DATA_V_Buffer(1) <= not rx_pe_control_r(2) after DLY;

        end if;

    end process;


    -- Decode RX_SCP.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_scp_d_r(0) <= std_bool(word_aligned_data_r(0 to 3)   = SCP_0) after DLY;
            rx_scp_d_r(1) <= std_bool(word_aligned_data_r(4 to 7)   = SCP_1) after DLY;
            rx_scp_d_r(2) <= std_bool(word_aligned_data_r(8 to 11)  = SCP_2) after DLY;
            rx_scp_d_r(3) <= std_bool(word_aligned_data_r(12 to 15) = SCP_3) after DLY;
            rx_scp_d_r(4) <= std_bool(word_aligned_data_r(16 to 19) = SCP_0) after DLY;
            rx_scp_d_r(5) <= std_bool(word_aligned_data_r(20 to 23) = SCP_1) after DLY;
            rx_scp_d_r(6) <= std_bool(word_aligned_data_r(24 to 27) = SCP_2) after DLY;
            rx_scp_d_r(7) <= std_bool(word_aligned_data_r(28 to 31) = SCP_3) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_SCP_Buffer(0) <= rx_pe_control_r(0) and
                                rx_pe_control_r(1) and
                                rx_scp_d_r(0)      and
                                rx_scp_d_r(3) after DLY;

            RX_SCP_Buffer(1) <= rx_pe_control_r(2) and
                                rx_pe_control_r(3) and
                                rx_scp_d_r(4)      and
                                rx_scp_d_r(7) after DLY;

        end if;

    end process;


    -- Decode RX_ECP.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_ecp_d_r(0) <= std_bool(word_aligned_data_r(0 to 3)   = ECP_0) after DLY;
            rx_ecp_d_r(1) <= std_bool(word_aligned_data_r(4 to 7)   = ECP_1) after DLY;
            rx_ecp_d_r(2) <= std_bool(word_aligned_data_r(8 to 11)  = ECP_2) after DLY;
            rx_ecp_d_r(3) <= std_bool(word_aligned_data_r(12 to 15) = ECP_3) after DLY;
            rx_ecp_d_r(4) <= std_bool(word_aligned_data_r(16 to 19) = ECP_0) after DLY;
            rx_ecp_d_r(5) <= std_bool(word_aligned_data_r(20 to 23) = ECP_1) after DLY;
            rx_ecp_d_r(6) <= std_bool(word_aligned_data_r(24 to 27) = ECP_2) after DLY;
            rx_ecp_d_r(7) <= std_bool(word_aligned_data_r(28 to 31) = ECP_3) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_ECP_Buffer(0) <= rx_pe_control_r(0) and
                                rx_pe_control_r(1) and
                                rx_ecp_d_r(0)      and
                                rx_ecp_d_r(3) after DLY;

            RX_ECP_Buffer(1) <= rx_pe_control_r(2) and
                                rx_pe_control_r(3) and
                                rx_ecp_d_r(4)      and
                                rx_ecp_d_r(7) after DLY;

        end if;

    end process;


    -- Decode RX_SNF.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_snf_d_r(0) <= std_bool(word_aligned_data_r(0 to 3)   = SNF_0) after DLY;
            rx_snf_d_r(1) <= std_bool(word_aligned_data_r(4 to 7)   = SNF_1) after DLY;
            rx_snf_d_r(2) <= std_bool(word_aligned_data_r(16 to 19) = SNF_0) after DLY;
            rx_snf_d_r(3) <= std_bool(word_aligned_data_r(20 to 23) = SNF_1) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_SNF_Buffer(0) <= rx_pe_control_r(0) and
                                rx_snf_d_r(0)      and
                                rx_snf_d_r(1) after DLY;

            RX_SNF_Buffer(1) <= rx_pe_control_r(2) and
                                rx_snf_d_r(2) and
                                rx_snf_d_r(3) after DLY;

        end if;

    end process;


    -- Extract the Flow Control Size code and register it for the RX_LL interface.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_FC_NB_Buffer(0 to 3) <= rx_pe_data_r(8 to 11) after DLY;
            RX_FC_NB_Buffer(4 to 7) <= rx_pe_data_r(24 to 27) after DLY;

        end if;

    end process;


    -- Indicate the SP sequence was received.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_sp_r(0) <= std_bool(word_aligned_data_r(0 to 3)    = K_CHAR_0) after DLY;
            rx_sp_r(1) <= std_bool(word_aligned_data_r(4 to 7)    = K_CHAR_1) after DLY;

            rx_sp_r(2) <= std_bool((word_aligned_data_r(8 to 11)  = SP_DATA_0) or
                                   (word_aligned_data_r(8 to 11)  = SP_NEG_DATA_0)) after DLY;

            rx_sp_r(3) <= std_bool((word_aligned_data_r(12 to 15) = SP_DATA_1) or
                                   (word_aligned_data_r(12 to 15) = SP_NEG_DATA_1)) after DLY;

            rx_sp_r(4) <= std_bool((word_aligned_data_r(16 to 19) = SP_DATA_0) or
                                   (word_aligned_data_r(16 to 19) = SP_NEG_DATA_0)) after DLY;

            rx_sp_r(5) <= std_bool((word_aligned_data_r(20 to 23) = SP_DATA_1) or
                                   (word_aligned_data_r(20 to 23) = SP_NEG_DATA_1)) after DLY;

            rx_sp_r(6) <= std_bool((word_aligned_data_r(24 to 27) = SP_DATA_0) or
                                   (word_aligned_data_r(24 to 27) = SP_NEG_DATA_0)) after DLY;

            rx_sp_r(7) <= std_bool((word_aligned_data_r(28 to 31) = SP_DATA_1) or
                                   (word_aligned_data_r(28 to 31) = SP_NEG_DATA_1)) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_SP_Buffer <= std_bool((rx_pe_control_r = "1000") and (rx_sp_r = X"FF")) after DLY;

        end if;

    end process;


    -- Indicate the SPA sequence was received.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_spa_r(0) <= std_bool(word_aligned_data_r(0 to 3)   = K_CHAR_0) after DLY;
            rx_spa_r(1) <= std_bool(word_aligned_data_r(4 to 7)   = K_CHAR_1) after DLY;
            rx_spa_r(2) <= std_bool(word_aligned_data_r(8 to 11)  = SPA_DATA_0) after DLY;
            rx_spa_r(3) <= std_bool(word_aligned_data_r(12 to 15) = SPA_DATA_1) after DLY;
            rx_spa_r(4) <= std_bool(word_aligned_data_r(16 to 19) = SPA_DATA_0) after DLY;
            rx_spa_r(5) <= std_bool(word_aligned_data_r(20 to 23) = SPA_DATA_1) after DLY;
            rx_spa_r(6) <= std_bool(word_aligned_data_r(24 to 27) = SPA_DATA_0) after DLY;
            rx_spa_r(7) <= std_bool(word_aligned_data_r(28 to 31) = SPA_DATA_1) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_SPA_Buffer <= std_bool((rx_pe_control_r = "1000") and (rx_spa_r = X"FF")) after DLY;

        end if;

    end process;


    -- Indicate reversed data received.  We look only at the word aligned LSByte
    -- which, during an SP or SPA sequence, will always contain a data byte.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_sp_neg_d_r(0)  <= std_bool(word_aligned_data_r(8 to 11)  = SP_NEG_DATA_0) after DLY;
            rx_sp_neg_d_r(1)  <= std_bool(word_aligned_data_r(12 to 15) = SP_NEG_DATA_1) after DLY;

            rx_spa_neg_d_r(0) <= std_bool(word_aligned_data_r(8 to 11)  = SPA_NEG_DATA_0) after DLY;
            rx_spa_neg_d_r(1) <= std_bool(word_aligned_data_r(12 to 15) = SPA_NEG_DATA_1) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            RX_NEG_Buffer <= not rx_pe_control_r(1) and
                             std_bool((rx_sp_neg_d_r  = "11") or
                                      (rx_spa_neg_d_r = "11")) after DLY;

        end if;

    end process;


    -- Decode GOT_A.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            got_a_d_r(0) <= std_bool(RX_DATA(31 downto 28)   = A_CHAR_0) after DLY;
            got_a_d_r(1) <= std_bool(RX_DATA(27 downto 24)   = A_CHAR_1) after DLY;
            got_a_d_r(2) <= std_bool(RX_DATA(23 downto 20)   = A_CHAR_0) after DLY;
            got_a_d_r(3) <= std_bool(RX_DATA(19 downto 16)   = A_CHAR_1) after DLY;
            got_a_d_r(4) <= std_bool(RX_DATA(15 downto 12)   = A_CHAR_0) after DLY;
            got_a_d_r(5) <= std_bool(RX_DATA(11 downto 8)    = A_CHAR_1) after DLY;
            got_a_d_r(6) <= std_bool(RX_DATA(7  downto 4)    = A_CHAR_0) after DLY;
            got_a_d_r(7) <= std_bool(RX_DATA(3  downto 0)    = A_CHAR_1) after DLY;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            GOT_A_Buffer(0) <= RX_CHAR_IS_K(3) and std_bool(got_a_d_r(0 to 1) = "11") after DLY;
            GOT_A_Buffer(1) <= RX_CHAR_IS_K(2) and std_bool(got_a_d_r(2 to 3) = "11") after DLY;
            GOT_A_Buffer(2) <= RX_CHAR_IS_K(1) and std_bool(got_a_d_r(4 to 5) = "11") after DLY;
            GOT_A_Buffer(3) <= RX_CHAR_IS_K(0) and std_bool(got_a_d_r(6 to 7) = "11") after DLY;

        end if;

    end process;


    -- Verification symbol decode --

    -- Indicate the SP sequence was received.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            rx_v_d_r(0) <= std_bool(word_aligned_data_r(0 to 3)   = K_CHAR_0) after DLY;
            rx_v_d_r(1) <= std_bool(word_aligned_data_r(4 to 7)   = K_CHAR_1) after DLY;
            rx_v_d_r(2) <= std_bool(word_aligned_data_r(8 to 11)  = VER_DATA_0) after DLY;
            rx_v_d_r(3) <= std_bool(word_aligned_data_r(12 to 15) = VER_DATA_1) after DLY;
            rx_v_d_r(4) <= std_bool(word_aligned_data_r(16 to 19) = VER_DATA_0) after DLY;
            rx_v_d_r(5) <= std_bool(word_aligned_data_r(20 to 23) = VER_DATA_1) after DLY;
            rx_v_d_r(6) <= std_bool(word_aligned_data_r(24 to 27) = VER_DATA_0) after DLY;
            rx_v_d_r(7) <= std_bool(word_aligned_data_r(28 to 31) = VER_DATA_1) after DLY;

        end if;

    end process;


    got_v_c <= std_bool((rx_pe_control_r = "1000") and (rx_v_d_r = X"FF"));


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            GOT_V_Buffer <= got_v_c after DLY;

        end if;

    end process;


    -- Remember that the first V sequence has been detected.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (LANE_UP = '0') then

                first_v_received_r <= '0' after DLY;

            else

                if (got_v_c = '1') then

                    first_v_received_r <= '1' after DLY;

                end if;

            end if;

        end if;

    end process;

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:56 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: tx_ll_control_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  TX_LL_CONTROL
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: This module provides the transmitter state machine
--               control logic to connect the LocalLink interface to
--               the Aurora Channel.
--
--               This module supports 4 4-byte lane designs
--
--               This module supports Immediate Mode Native Flow Control.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.AURORA.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.all;
-- synthesis translate_on

entity TX_LL_CONTROL is

    port (

    -- LocalLink PDU Interface

            TX_SRC_RDY_N  : in std_logic;
            TX_SOF_N      : in std_logic;
            TX_EOF_N      : in std_logic;
            TX_REM        : in std_logic_vector(0 to 2);
            TX_DST_RDY_N  : out std_logic;

    -- NFC Interface

            NFC_REQ_N     : in std_logic;
            NFC_NB        : in std_logic_vector(0 to 3);
            NFC_ACK_N     : out std_logic;

    -- Clock Compensation Interface

            WARN_CC       : in std_logic;
            DO_CC         : in std_logic;

    -- Global Logic Interface

            CHANNEL_UP    : in std_logic;

    -- TX_LL Control Module Interface

            HALT_C        : out std_logic;

    -- Aurora Lane Interface

            GEN_SCP       : out std_logic;
            GEN_ECP       : out std_logic;
            GEN_SNF       : out std_logic;
            FC_NB         : out std_logic_vector(0 to 3);
            GEN_CC        : out std_logic_vector(0 to 1);

    -- RX_LL Interface

            TX_WAIT       : in std_logic;
            DECREMENT_NFC : out std_logic;

    -- System Interface

            USER_CLK      : in std_logic

         );

end TX_LL_CONTROL;

architecture RTL of TX_LL_CONTROL is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal TX_DST_RDY_N_Buffer  : std_logic;
    signal NFC_ACK_N_Buffer     : std_logic;
    signal HALT_C_Buffer        : std_logic;
    signal GEN_SCP_Buffer       : std_logic;
    signal GEN_ECP_Buffer       : std_logic;
    signal GEN_SNF_Buffer       : std_logic;
    signal FC_NB_Buffer         : std_logic_vector(0 to 3);
    signal GEN_CC_Buffer        : std_logic_vector(0 to 1);
    signal DECREMENT_NFC_Buffer : std_logic;

-- Internal Register Declarations --

    signal do_cc_r                      : std_logic;
    signal warn_cc_r                    : std_logic;
    signal do_nfc_r                     : std_logic;

    signal idle_r                       : std_logic;
    signal sof_to_data_r                : std_logic;
    signal data_r                       : std_logic;
    signal data_to_eof_1_r              : std_logic;
    signal data_to_eof_2_r              : std_logic;
    signal eof_r                        : std_logic;
    signal sof_to_eof_1_r               : std_logic;
    signal sof_to_eof_2_r               : std_logic;
    signal sof_and_eof_r                : std_logic;

    signal gen_scp_pipeline_r           : std_logic;
    signal gen_ecp_pipeline_r           : std_logic;
    signal gen_snf_pipeline_r           : std_logic;
    signal fc_nb_pipeline_r             : std_logic_vector(0 to 3);
    signal gen_cc_pipeline_r            : std_logic;

-- Wire Declarations --

    signal nfc_ok_c              : std_logic;

    signal next_idle_c           : std_logic;
    signal next_sof_to_data_c    : std_logic;
    signal next_data_c           : std_logic;
    signal next_data_to_eof_1_c  : std_logic;
    signal next_data_to_eof_2_c  : std_logic;
    signal next_eof_c            : std_logic;
    signal next_sof_to_eof_1_c   : std_logic;
    signal next_sof_to_eof_2_c   : std_logic;
    signal next_sof_and_eof_c    : std_logic;

    signal fc_nb_c               : std_logic_vector(0 to 3);
    signal tx_dst_rdy_n_c        : std_logic;
    signal do_sof_c              : std_logic;
    signal do_eof_c              : std_logic;
    signal channel_full_c        : std_logic;
    signal pdu_ok_c              : std_logic;

-- Declarations to handle VHDL limitations
    signal reset_i               : std_logic;

-- Component Declarations --

    component FDR

        generic (INIT : bit := '0');

        port (

                Q : out std_ulogic;
                C : in  std_ulogic;
                D : in  std_ulogic;
                R : in  std_ulogic

             );

    end component;

begin

    TX_DST_RDY_N  <= TX_DST_RDY_N_Buffer;
    NFC_ACK_N     <= NFC_ACK_N_Buffer;
    HALT_C        <= HALT_C_Buffer;
    GEN_SCP       <= GEN_SCP_Buffer;
    GEN_ECP       <= GEN_ECP_Buffer;
    GEN_SNF       <= GEN_SNF_Buffer;
    FC_NB         <= FC_NB_Buffer;
    GEN_CC        <= GEN_CC_Buffer;
    DECREMENT_NFC <= DECREMENT_NFC_Buffer;

-- Main Body of Code --



    reset_i <=  not CHANNEL_UP;


    -- Clock Compensation --

    -- Register the DO_CC and WARN_CC signals for internal use.  Note that the raw DO_CC
    -- signal is used for some logic so the DO_CC signal should be driven directly
    -- from a register whenever possible.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                do_cc_r <= '0' after DLY;

            else

                do_cc_r <= DO_CC after DLY;

            end if;

        end if;

    end process;


    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                warn_cc_r <= '0' after DLY;

            else

                warn_cc_r <= WARN_CC after DLY;

            end if;

        end if;

    end process;


    -- NFC State Machine --

    -- The NFC state machine has 2 states: waiting for an NFC request, and
    -- sending an NFC message.  It can take over the channel at any time
    -- except when there is a UFC message or a CC sequence in progress.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                do_nfc_r <= '0' after DLY;

            else

                if (do_nfc_r = '0') then

                    do_nfc_r <= not NFC_REQ_N and nfc_ok_c after DLY;

                else

                    do_nfc_r <= '0' after DLY;

                end if;

            end if;

        end if;

    end process;


    -- You can only send an NFC message when there is no CC operation or UFC
    -- message in progress.  We also prohibit NFC messages just before CC to
    -- prevent collisions on the first cycle.

    nfc_ok_c <= not do_cc_r and
                not warn_cc_r;


    NFC_ACK_N_Buffer <= not do_nfc_r;


    -- PDU State Machine --

    -- The PDU state machine handles the encapsulation and transmission of user
    -- PDUs.  It can use the channel when there is no CC, NFC message, UFC header,
    -- UFC message or remote NFC request.

    -- State Registers

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                idle_r          <= '1' after DLY;
                sof_to_data_r   <= '0' after DLY;
                data_r          <= '0' after DLY;
                data_to_eof_1_r <= '0' after DLY;
                data_to_eof_2_r <= '0' after DLY;
                eof_r           <= '0' after DLY;
                sof_to_eof_1_r  <= '0' after DLY;
                sof_to_eof_2_r  <= '0' after DLY;
                sof_and_eof_r   <= '0' after DLY;

            else

                if (pdu_ok_c = '1') then

                    idle_r          <= next_idle_c          after DLY;
                    sof_to_data_r   <= next_sof_to_data_c   after DLY;
                    data_r          <= next_data_c          after DLY;
                    data_to_eof_1_r <= next_data_to_eof_1_c after DLY;
                    data_to_eof_2_r <= next_data_to_eof_2_c after DLY;
                    eof_r           <= next_eof_c           after DLY;
                    sof_to_eof_1_r  <= next_sof_to_eof_1_c  after DLY;
                    sof_to_eof_2_r  <= next_sof_to_eof_2_c  after DLY;
                    sof_and_eof_r   <= next_sof_and_eof_c   after DLY;

                end if;

            end if;

        end if;

    end process;


    -- Next State Logic

    next_idle_c          <= (idle_r and not do_sof_c)          or
                            (data_to_eof_2_r and not do_sof_c) or
                            (eof_r and not do_sof_c)           or
                            (sof_to_eof_2_r and not do_sof_c)  or
                            (sof_and_eof_r and not do_sof_c);


    next_sof_to_data_c   <= ((idle_r and do_sof_c) and not do_eof_c)          or
                            ((data_to_eof_2_r and do_sof_c) and not do_eof_c) or
                            ((eof_r and do_sof_c) and not do_eof_c)           or
                            ((sof_to_eof_2_r and do_sof_c) and not do_eof_c)  or
                            ((sof_and_eof_r and do_sof_c) and not do_eof_c);


    next_data_c          <= (sof_to_data_r and not do_eof_c) or
                            (data_r and not do_eof_c);


    next_data_to_eof_1_c <= ((sof_to_data_r and do_eof_c) and channel_full_c) or
                            ((data_r and do_eof_c) and channel_full_c);


    next_data_to_eof_2_c <= data_to_eof_1_r;


    next_eof_c           <= ((sof_to_data_r and do_eof_c) and not channel_full_c) or
                            ((data_r and do_eof_c) and not channel_full_c);


    next_sof_to_eof_1_c  <= (((idle_r and do_sof_c) and do_eof_c) and channel_full_c)          or
                            (((data_to_eof_2_r and do_sof_c) and do_eof_c) and channel_full_c) or
                            (((eof_r and do_sof_c) and do_eof_c) and channel_full_c)           or
                            (((sof_to_eof_2_r and do_sof_c) and do_eof_c) and channel_full_c)  or
                            (((sof_and_eof_r and do_sof_c) and do_eof_c) and channel_full_c);


    next_sof_to_eof_2_c  <= sof_to_eof_1_r;


    next_sof_and_eof_c   <= (((idle_r and do_sof_c) and do_eof_c) and not channel_full_c)          or
                            (((data_to_eof_2_r and do_sof_c) and do_eof_c) and not channel_full_c) or
                            (((eof_r and do_sof_c) and do_eof_c) and not channel_full_c)           or
                            (((sof_to_eof_2_r and do_sof_c) and do_eof_c) and not channel_full_c)  or
                            (((sof_and_eof_r and do_sof_c) and do_eof_c) and not channel_full_c);


    -- We pipeline GEN_SCP because we are pipelining the datapath to leave travelling
    -- registers for the router; we must line up GEN_SCP with the appropriate data cycle.
    -- Drive the GEN_SCP signal when in an SOF state with the PDU state machine active.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                gen_scp_pipeline_r <= '0' after DLY;
                GEN_SCP_Buffer     <= '0' after DLY;

            else

                gen_scp_pipeline_r <= (sof_to_data_r  or
                                       sof_to_eof_1_r or
                                       sof_and_eof_r) and
                                       pdu_ok_c after DLY;

                GEN_SCP_Buffer     <=  gen_scp_pipeline_r after DLY;

            end if;

        end if;

    end process;


    -- We pipeline GEN_ECP because we are pipelining the datapath to leave travelling
    -- registers for the router; we must line up GEN_ECP with the appropriate data cycle.
    -- Drive the GEN_ECP signal when in an EOF state with the PDU state machine active.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                gen_ecp_pipeline_r <= '0' after DLY;
                GEN_ECP_Buffer     <= '0' after DLY;

            else

                gen_ecp_pipeline_r <= (data_to_eof_2_r or
                                       eof_r           or
                                       sof_to_eof_2_r  or
                                       sof_and_eof_r)  and
                                       pdu_ok_c after DLY;

                GEN_ECP_Buffer     <= gen_ecp_pipeline_r after DLY;

            end if;

        end if;

    end process;


    -- TX_DST_RDY is the critical path in this module.  It must be deasserted (high)
    -- whenever an event occurs that prevents the PDU state machine from using the
    -- Aurora channel to transmit PDUs.

    tx_dst_rdy_n_c <= (next_data_to_eof_1_c and pdu_ok_c)            or
                     ((not do_nfc_r and not NFC_REQ_N) and nfc_ok_c) or
                       DO_CC                                         or
                       TX_WAIT                                       or
                      (next_sof_to_eof_1_c and pdu_ok_c)             or
                      (sof_to_eof_1_r and not pdu_ok_c)              or
                      (data_to_eof_1_r and not pdu_ok_c);


    -- We add extra travelling registers to the GEN_CC signal to ease routing.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                gen_cc_pipeline_r <= '0' after DLY;

            else

                gen_cc_pipeline_r <= do_cc_r after DLY;

            end if;

        end if;

    end process;


    -- The flops for the GEN_CC signal are replicated for timing and instantiated to allow us
    -- to set their value reliably on powerup.

    gen_cc_flop_0_i : FDR

        port map (

                    D => gen_cc_pipeline_r,
                    C => USER_CLK,
                    R => reset_i,
                    Q => GEN_CC_Buffer(0)

                 );


    gen_cc_flop_1_i : FDR

        port map (

                    D => gen_cc_pipeline_r,
                    C => USER_CLK,
                    R => reset_i,
                    Q => GEN_CC_Buffer(1)

                 );


    -- We add travelling registers to GEN_SNF to ease routing.  GEN_SNF is asserted whenever the NFC
    -- state machine is not idle.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                gen_snf_pipeline_r <= '0' after DLY;
                GEN_SNF_Buffer     <= '0' after DLY;

            else

                gen_snf_pipeline_r <= do_nfc_r           after DLY;
                GEN_SNF_Buffer     <= gen_snf_pipeline_r after DLY;

            end if;

        end if;

    end process;


    -- Travelling registers must be added for the FC_NB signal so the pipeline for all
    -- signals stays matched.  FC_NB carries flow control codes to the Lane logic.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            fc_nb_pipeline_r <= fc_nb_c          after DLY;
            FC_NB_Buffer     <= fc_nb_pipeline_r after DLY;

        end if;

    end process;


    -- Flow control codes come from the NFC_NB input.

    fc_nb_c <= NFC_NB;


    -- The TX_DST_RDY_N signal is registered.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (CHANNEL_UP = '0') then

                TX_DST_RDY_N_Buffer <= '1' after DLY;

            else

                TX_DST_RDY_N_Buffer <= tx_dst_rdy_n_c after DLY;

            end if;

        end if;

    end process;


    -- Decrement the NFC pause required count whenever the state machine prevents new
    -- PDU data from being sent except when the data is prevented by CC characters.

    DECREMENT_NFC_Buffer <= TX_DST_RDY_N_Buffer and not do_cc_r;


    -- Helper Logic

    -- SOF requests are valid when TX_SRC_RDY_N. TX_DST_RDY_N and TX_SOF_N are asserted

    do_sof_c <=     not TX_SRC_RDY_N            and
                    not TX_DST_RDY_N_Buffer     and
                    not TX_SOF_N;    


    -- EOF requests are valid when TX_SRC_RDY_N, TX_DST_RDY_N and TX_EOF_N are asserted

    do_eof_c <=     not TX_SRC_RDY_N            and
                    not TX_DST_RDY_N_Buffer     and
                    not TX_EOF_N;
                 
                 


    -- Freeze the PDU state machine when CCs or NFCs must be handled.

    pdu_ok_c <= not do_cc_r and
                not do_nfc_r;


    -- Halt the flow of data through the datastream when the PDU state machine is frozen.

    HALT_C_Buffer <= not pdu_ok_c;


    -- The aurora channel is 'full' if there is more than enough data to fit into
    -- a channel that is already carrying an SCP and an ECP character.

    channel_full_c <= std_bool(TX_REM > "011");

end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:56 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: valid_data_counter_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  VALID_DATA_COUNTER
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: The VALID_DATA_COUNTER module counts the number of ones in a register filled
--               with ones and zeros.
--
--               This module supports 4 4-byte lane designs.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity VALID_DATA_COUNTER is

    port (

            PREVIOUS_STAGE_VALID : in std_logic_vector(0 to 3);
            USER_CLK             : in std_logic;
            RESET                : in std_logic;
            COUNT                : out std_logic_vector(0 to 2)

         );

end VALID_DATA_COUNTER;

architecture RTL of VALID_DATA_COUNTER is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal COUNT_Buffer : std_logic_vector(0 to 2);

-- Internal Register Declarations --

    signal  count_c   : std_logic_vector(0 to 2);

begin

    COUNT <= COUNT_Buffer;

-- Main Body of Code --

    -- Return the number of 1's in the binary representation of the input value.

    process (PREVIOUS_STAGE_VALID)

    begin

        count_c <= (

                        conv_std_logic_vector(0,3)
                      + PREVIOUS_STAGE_VALID(0)
                      + PREVIOUS_STAGE_VALID(1)
                      + PREVIOUS_STAGE_VALID(2)
                      + PREVIOUS_STAGE_VALID(3)

                   );

    end process;


    --Register the count

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (RESET = '1') then

                COUNT_Buffer <= (others => '0') after DLY;

            else

                COUNT_Buffer <= count_c after DLY;

            end if;

        end if;

    end process;


end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:56 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: tx_ll_datapath_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  TX_LL_DATAPATH
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: This module pipelines the data path while handling the PAD
--               character placement and valid data flags.
--
--               This module supports 4 4-byte lane designs
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity TX_LL_DATAPATH is

    port (

    -- LocalLink PDU Interface

            TX_D         : in std_logic_vector(0 to 63);
            TX_REM       : in std_logic_vector(0 to 2);
            TX_SRC_RDY_N : in std_logic;
            TX_SOF_N     : in std_logic;
            TX_EOF_N     : in std_logic;

    -- Aurora Lane Interface

            TX_PE_DATA_V : out std_logic_vector(0 to 3);
            GEN_PAD      : out std_logic_vector(0 to 3);
            TX_PE_DATA   : out std_logic_vector(0 to 63);

    -- TX_LL Control Module Interface

            HALT_C       : in std_logic;
            TX_DST_RDY_N : in std_logic;

    -- System Interface

            CHANNEL_UP   : in std_logic;
            USER_CLK     : in std_logic

         );

end TX_LL_DATAPATH;

architecture RTL of TX_LL_DATAPATH is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal TX_PE_DATA_V_Buffer : std_logic_vector(0 to 3);
    signal GEN_PAD_Buffer      : std_logic_vector(0 to 3);
    signal TX_PE_DATA_Buffer   : std_logic_vector(0 to 63);

-- Internal Register Declarations --

    signal in_frame_r              : std_logic;
    signal storage_r               : std_logic_vector(0 to 15);
    signal storage_v_r             : std_logic;
    signal storage_pad_r           : std_logic;
    signal tx_pe_data_r            : std_logic_vector(0 to 63);
    signal valid_c                 : std_logic_vector(0 to 3);
    signal tx_pe_data_v_r          : std_logic_vector(0 to 3);
    signal gen_pad_c               : std_logic_vector(0 to 3);
    signal gen_pad_r               : std_logic_vector(0 to 3);
    signal tx_d_pipeline_r         : std_logic_vector(0 to 63);
    signal tx_rem_pipeline_r       : std_logic_vector(0 to 2);
    signal tx_src_rdy_n_pipeline_r : std_logic;
    signal tx_sof_n_pipeline_r     : std_logic;
    signal tx_eof_n_pipeline_r     : std_logic;
    signal halt_c_pipeline_r       : std_logic;
    signal tx_dst_rdy_n_pipeline_r : std_logic;

-- Internal Wire Declarations --
    
    signal ll_valid_c              : std_logic;
    signal in_frame_c              : std_logic;

begin

    TX_PE_DATA_V <= TX_PE_DATA_V_Buffer;
    GEN_PAD      <= GEN_PAD_Buffer;
    TX_PE_DATA   <= TX_PE_DATA_Buffer;

-- Main Body of Code --

    -- Pipeline all inputs.  This creates 'travelling registers',
    -- which makes it easier for par to place blocks to reduce congestion while
    -- meeting all timing constriants.

    -- First we pipeline the control signals.  Some of these signals are used
    -- many times in the datapath.  The sythesis tool will replicate these
    -- registers to keep fanout low and preserve timing.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if(CHANNEL_UP = '0') then

                tx_src_rdy_n_pipeline_r <= '1' after DLY;
                tx_sof_n_pipeline_r     <= '1' after DLY;
                tx_eof_n_pipeline_r     <= '1' after DLY;
                halt_c_pipeline_r       <= '0' after DLY;
                tx_dst_rdy_n_pipeline_r <= '1' after DLY;

            else

                tx_src_rdy_n_pipeline_r <= TX_SRC_RDY_N after DLY;
                tx_sof_n_pipeline_r     <= TX_SOF_N     after DLY;
                tx_eof_n_pipeline_r     <= TX_EOF_N     after DLY;
                halt_c_pipeline_r       <= HALT_C       after DLY;
                tx_dst_rdy_n_pipeline_r <= TX_DST_RDY_N after DLY;

            end if;

        end if;

    end process;


    -- We pipeline the data and REM seperately from the control signals: we
    -- use no reset because the routing is expensive, and the signals are
    -- all qualified by the control signals.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            tx_d_pipeline_r   <= TX_D   after DLY;
            tx_rem_pipeline_r <= TX_REM after DLY;

        end if;

    end process;



    -- LocalLink input is only valid when TX_SRC_RDY_N and TX_DST_RDY_N are both asserted
    ll_valid_c    <=   not tx_src_rdy_n_pipeline_r and not tx_dst_rdy_n_pipeline_r;


    -- Data must only be read if it is within a frame. If a frame will last multiple cycles
    -- we assert in_frame_r as long as the frame is open.
    process(USER_CLK)
    begin
        if(USER_CLK'event and USER_CLK = '1') then
            if(CHANNEL_UP = '0') then
                in_frame_r  <=  '1' after DLY;
            elsif(ll_valid_c = '1') then
                if( (tx_sof_n_pipeline_r = '0') and (tx_eof_n_pipeline_r = '1') ) then
                    in_frame_r  <=  '1' after DLY;
                elsif(tx_eof_n_pipeline_r = '0') then
                    in_frame_r  <=  '0' after DLY;
                end if;
            end if;
        end if;
    end process;
    
        
    in_frame_c   <=   ll_valid_c and (in_frame_r  or not tx_sof_n_pipeline_r);






    -- The last 2 bytes of data from the LocalLink interface must be stored
    -- for the next cycle to make room for the SCP character that must be
    -- placed at the beginning of the lane.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (halt_c_pipeline_r = '0') then

                storage_r <= tx_d_pipeline_r(48 to 63) after DLY;

            end if;

        end if;

    end process;


    -- All of the remaining bytes (except the last two) must be shifted
    -- and registered to be sent to the Channel.  The stored bytes go
    -- into the first position.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (halt_c_pipeline_r = '0') then

                tx_pe_data_r <= storage_r & tx_d_pipeline_r(0 to 47) after DLY;

            end if;

        end if;

    end process;


    -- We generate the valid_c signal based on the REM signal and the EOF signal.

    process (tx_eof_n_pipeline_r, tx_rem_pipeline_r)

    begin

        if (tx_eof_n_pipeline_r = '1') then

            valid_c <= "1111";

        else

            case tx_rem_pipeline_r(0 to 2) is

                when "000" => valid_c <= "1000";
                when "001" => valid_c <= "1000";
                when "010" => valid_c <= "1100";
                when "011" => valid_c <= "1100";
                when "100" => valid_c <= "1110";
                when "101" => valid_c <= "1110";
                when "110" => valid_c <= "1111";
                when "111" => valid_c <= "1111";
                when others => valid_c <= "1111";

            end case;

        end if;

    end process;


    -- If the last 2 bytes in the word are valid, they are placed in the storage register and
    -- storage_v_r is asserted to indicate the data is valid.  Note that data is only moved to
    -- storage if the PDU datapath is not halted, the data is valid and both TX_SRC_RDY_N
    -- and TX_DST_RDY_N (as indicated by DATA_VALID) are asserted.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (halt_c_pipeline_r = '0') then

                storage_v_r <= valid_c(3)  and in_frame_c after DLY;

            end if;

        end if;

    end process;


    -- The tx_pe_data_v_r registers track valid data in the TX_PE_DATA register.  The data is valid
    -- if it was valid in the previous stage.  Since the first 2 bytes come from storage, validity is
    -- determined from the storage_v_r signal.  The remaining bytes are valid if their valid signal
    -- is asserted, and both TX_SRC_RDY_N and TX_DST_RDY_N (as indicated by DATA_VALID) are asserted.
    -- Note that pdu data movement can be frozen by the halt signal.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (halt_c_pipeline_r = '0') then

                tx_pe_data_v_r(0) <= storage_v_r after DLY;

                tx_pe_data_v_r(1) <= valid_c(0) and in_frame_c after DLY;

                tx_pe_data_v_r(2) <= valid_c(1) and in_frame_c after DLY;

                tx_pe_data_v_r(3) <= valid_c(2) and in_frame_c after DLY;

            end if;

        end if;

    end process;




    -- We generate the gen_pad_c signal based on the REM signal and the EOF signal.

    process (tx_eof_n_pipeline_r, tx_rem_pipeline_r)

    begin

        if (tx_eof_n_pipeline_r = '1') then

            gen_pad_c <= "0000";

        else

            case tx_rem_pipeline_r(0 to 2) is

                when "000" => gen_pad_c <= "1000";
                when "001" => gen_pad_c <= "0000";
                when "010" => gen_pad_c <= "0100";
                when "011" => gen_pad_c <= "0000";
                when "100" => gen_pad_c <= "0010";
                when "101" => gen_pad_c <= "0000";
                when "110" => gen_pad_c <= "0001";
                when "111" => gen_pad_c <= "0000";
                when others => gen_pad_c <= "0000";

            end case;

        end if;

    end process;


    -- Store a padded byte pair if it's padded, TX_SRC_RDY_N is asserted, and data is valid.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (halt_c_pipeline_r = '0') then

                storage_pad_r <= gen_pad_c(3) and in_frame_c after DLY;

            end if;

        end if;

    end process;


    -- Register the gen_pad_r signals.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (halt_c_pipeline_r = '0') then

                gen_pad_r(0) <= storage_pad_r after DLY;

                gen_pad_r(1) <= gen_pad_c(0) and in_frame_c after DLY;

                gen_pad_r(2) <= gen_pad_c(1) and in_frame_c after DLY;

                gen_pad_r(3) <= gen_pad_c(2) and in_frame_c after DLY;

            end if;

        end if;

    end process;


    -- Implement the data out register.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            TX_PE_DATA_Buffer      <= tx_pe_data_r after DLY;
            TX_PE_DATA_V_Buffer(0) <= tx_pe_data_v_r(0) and not halt_c_pipeline_r after DLY;
            TX_PE_DATA_V_Buffer(1) <= tx_pe_data_v_r(1) and not halt_c_pipeline_r after DLY;
            TX_PE_DATA_V_Buffer(2) <= tx_pe_data_v_r(2) and not halt_c_pipeline_r after DLY;
            TX_PE_DATA_V_Buffer(3) <= tx_pe_data_v_r(3) and not halt_c_pipeline_r after DLY;
            GEN_PAD_Buffer(0)      <= gen_pad_r(0) and not halt_c_pipeline_r after DLY;
            GEN_PAD_Buffer(1)      <= gen_pad_r(1) and not halt_c_pipeline_r after DLY;
            GEN_PAD_Buffer(2)      <= gen_pad_r(2) and not halt_c_pipeline_r after DLY;
            GEN_PAD_Buffer(3)      <= gen_pad_r(3) and not halt_c_pipeline_r after DLY;

        end if;

    end process;


end RTL;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:56 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: tx_ll_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  TX_LL
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: The TX_LL module converts user data from the LocalLink interface
--               to Aurora Data, then sends it to the Aurora Channel for transmission.
--               It also handles NFC and UFC messages.
--
--               This module supports 4 4-byte lane designs
--
--               This module supports Immediate Mode Native Flow Control
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity TX_LL is

    port (

    -- LocalLink PDU Interface

            TX_D           : in std_logic_vector(0 to 63);
            TX_REM         : in std_logic_vector(0 to 2);
            TX_SRC_RDY_N   : in std_logic;
            TX_SOF_N       : in std_logic;
            TX_EOF_N       : in std_logic;
            TX_DST_RDY_N   : out std_logic;

    -- NFC Interface

            NFC_REQ_N      : in std_logic;
            NFC_NB         : in std_logic_vector(0 to 3);
            NFC_ACK_N      : out std_logic;

    -- Clock Compensation Interface

            WARN_CC        : in std_logic;
            DO_CC          : in std_logic;

    -- Global Logic Interface

            CHANNEL_UP     : in std_logic;

    -- Aurora Lane Interface

            GEN_SCP        : out std_logic;
            GEN_ECP        : out std_logic;
            GEN_SNF        : out std_logic;
            FC_NB          : out std_logic_vector(0 to 3);
            TX_PE_DATA_V   : out std_logic_vector(0 to 3);
            GEN_PAD        : out std_logic_vector(0 to 3);
            TX_PE_DATA     : out std_logic_vector(0 to 63);
            GEN_CC         : out std_logic_vector(0 to 1);

    -- RX_LL Interface

            TX_WAIT        : in std_logic;
            DECREMENT_NFC  : out std_logic;

    -- System Interface

            USER_CLK       : in std_logic

         );

end TX_LL;

architecture MAPPED of TX_LL is

-- External Register Declarations --

    signal TX_DST_RDY_N_Buffer  : std_logic;
    signal NFC_ACK_N_Buffer     : std_logic;
    signal GEN_SCP_Buffer       : std_logic;
    signal GEN_ECP_Buffer       : std_logic;
    signal GEN_SNF_Buffer       : std_logic;
    signal FC_NB_Buffer         : std_logic_vector(0 to 3);
    signal TX_PE_DATA_V_Buffer  : std_logic_vector(0 to 3);
    signal GEN_PAD_Buffer       : std_logic_vector(0 to 3);
    signal TX_PE_DATA_Buffer    : std_logic_vector(0 to 63);
    signal GEN_CC_Buffer        : std_logic_vector(0 to 1);
    signal DECREMENT_NFC_Buffer : std_logic;

-- Wire Declarations --

    signal halt_c_i       : std_logic;
    signal tx_dst_rdy_n_i : std_logic;

-- Component Declarations --

    component TX_LL_DATAPATH

        port (

        -- LocalLink PDU Interface

                TX_D         : in std_logic_vector(0 to 63);
                TX_REM       : in std_logic_vector(0 to 2);
                TX_SRC_RDY_N : in std_logic;
                TX_SOF_N     : in std_logic;
                TX_EOF_N     : in std_logic;

        -- Aurora Lane Interface

                TX_PE_DATA_V : out std_logic_vector(0 to 3);
                GEN_PAD      : out std_logic_vector(0 to 3);
                TX_PE_DATA   : out std_logic_vector(0 to 63);

        -- TX_LL Control Module Interface

                HALT_C       : in std_logic;
                TX_DST_RDY_N : in std_logic;

        -- System Interface

                CHANNEL_UP   : in std_logic;
                USER_CLK     : in std_logic

             );

    end component;


    component TX_LL_CONTROL

        port (

        -- LocalLink PDU Interface

                TX_SRC_RDY_N  : in std_logic;
                TX_SOF_N      : in std_logic;
                TX_EOF_N      : in std_logic;
                TX_REM        : in std_logic_vector(0 to 2);
                TX_DST_RDY_N  : out std_logic;

        -- NFC Interface

                NFC_REQ_N     : in std_logic;
                NFC_NB        : in std_logic_vector(0 to 3);
                NFC_ACK_N     : out std_logic;

        -- Clock Compensation Interface

                WARN_CC       : in std_logic;
                DO_CC         : in std_logic;

        -- Global Logic Interface

                CHANNEL_UP    : in std_logic;

        -- TX_LL Control Module Interface

                HALT_C        : out std_logic;

        -- Aurora Lane Interface

                GEN_SCP       : out std_logic;
                GEN_ECP       : out std_logic;
                GEN_SNF       : out std_logic;
                FC_NB         : out std_logic_vector(0 to 3);
                GEN_CC        : out std_logic_vector(0 to 1);

        -- RX_LL Interface

                TX_WAIT       : in std_logic;
                DECREMENT_NFC : out std_logic;

        -- System Interface

                USER_CLK      : in std_logic

             );

    end component;

begin

    TX_DST_RDY_N  <= TX_DST_RDY_N_Buffer;
    NFC_ACK_N     <= NFC_ACK_N_Buffer;
    GEN_SCP       <= GEN_SCP_Buffer;
    GEN_ECP       <= GEN_ECP_Buffer;
    GEN_SNF       <= GEN_SNF_Buffer;
    FC_NB         <= FC_NB_Buffer;
    TX_PE_DATA_V  <= TX_PE_DATA_V_Buffer;
    GEN_PAD       <= GEN_PAD_Buffer;
    TX_PE_DATA    <= TX_PE_DATA_Buffer;
    GEN_CC        <= GEN_CC_Buffer;
    DECREMENT_NFC <= DECREMENT_NFC_Buffer;

-- Main Body of Code --

    -- TX_DST_RDY_N is generated by TX_LL_CONTROL and used by TX_LL_DATAPATH and
    -- external modules to regulate incoming pdu data signals.

    TX_DST_RDY_N_Buffer <= tx_dst_rdy_n_i;


    -- TX_LL_Datapath module

    tx_ll_datapath_i : TX_LL_DATAPATH

        port map (

        -- LocalLink PDU Interface

                    TX_D => TX_D,
                    TX_REM => TX_REM,
                    TX_SRC_RDY_N => TX_SRC_RDY_N,
                    TX_SOF_N => TX_SOF_N,
                    TX_EOF_N => TX_EOF_N,

        -- Aurora Lane Interface

                    TX_PE_DATA_V => TX_PE_DATA_V_Buffer,
                    GEN_PAD => GEN_PAD_Buffer,
                    TX_PE_DATA => TX_PE_DATA_Buffer,

        -- TX_LL Control Module Interface

                    HALT_C => halt_c_i,
                    TX_DST_RDY_N => tx_dst_rdy_n_i,

        -- System Interface

                    CHANNEL_UP => CHANNEL_UP,
                    USER_CLK => USER_CLK

                 );


    -- TX_LL_Control module

    tx_ll_control_i : TX_LL_CONTROL

        port map (

        -- LocalLink PDU Interface

                    TX_SRC_RDY_N => TX_SRC_RDY_N,
                    TX_SOF_N => TX_SOF_N,
                    TX_EOF_N => TX_EOF_N,
                    TX_REM => TX_REM,
                    TX_DST_RDY_N => tx_dst_rdy_n_i,

        -- NFC Interface

                    NFC_REQ_N => NFC_REQ_N,
                    NFC_NB => NFC_NB,
                    NFC_ACK_N => NFC_ACK_N_Buffer,

        -- Clock Compensation Interface

                    WARN_CC => WARN_CC,
                    DO_CC => DO_CC,

        -- Global Logic Interface

                    CHANNEL_UP => CHANNEL_UP,

        -- TX_LL Control Module Interface

                    HALT_C => halt_c_i,

        -- Aurora Lane Interface

                    GEN_SCP => GEN_SCP_Buffer,
                    GEN_ECP => GEN_ECP_Buffer,
                    GEN_SNF => GEN_SNF_Buffer,
                    FC_NB => FC_NB_Buffer,
                    GEN_CC => GEN_CC_Buffer,

        -- RX_LL Interface

                    TX_WAIT => TX_WAIT,
                    DECREMENT_NFC => DECREMENT_NFC_Buffer,

        -- System Interface

                    USER_CLK => USER_CLK

                 );

end MAPPED;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:55 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: storage_mux_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  STORAGE_MUX
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: B. Woodard, N. Gulstone
--
--  Description: The STORAGE_MUX has a set of 16 bit muxes to control the
--               flow of data.  Every output position has its own N:1 mux.
--
--               This module supports 4 4-byte lane designs.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity STORAGE_MUX is

    port (

            RAW_DATA     : in std_logic_vector(0 to 63);
            MUX_SELECT   : in std_logic_vector(0 to 19);
            STORAGE_CE   : in std_logic_vector(0 to 3);
            USER_CLK     : in std_logic;
            STORAGE_DATA : out std_logic_vector(0 to 63)

         );

end STORAGE_MUX;

architecture RTL of STORAGE_MUX is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal STORAGE_DATA_Buffer : std_logic_vector(0 to 63);

-- Internal Register Declarations --

    signal storage_data_c : std_logic_vector(0 to 63);

begin

    STORAGE_DATA <= STORAGE_DATA_Buffer;

-- Main Body of Code --

    -- Each lane has a set of 16 N:1 muxes connected to all the raw data lanes.

    -- Muxes for Lane 0

    process (MUX_SELECT(0 to 4), RAW_DATA)

    begin

        case MUX_SELECT(0 to 4) is

            when "00000" =>

                storage_data_c(0 to 15) <= RAW_DATA(0 to 15);

            when "00001" =>

                storage_data_c(0 to 15) <= RAW_DATA(16 to 31);

            when "00010" =>

                storage_data_c(0 to 15) <= RAW_DATA(32 to 47);

            when "00011" =>

                storage_data_c(0 to 15) <= RAW_DATA(48 to 63);

            when others =>

                storage_data_c(0 to 15) <= (others => 'X');

        end case;

    end process;


    -- Muxes for Lane 1

    process (MUX_SELECT(5 to 9), RAW_DATA)

    begin

        case MUX_SELECT(5 to 9) is

            when "00000" =>

                storage_data_c(16 to 31) <= RAW_DATA(0 to 15);

            when "00001" =>

                storage_data_c(16 to 31) <= RAW_DATA(16 to 31);

            when "00010" =>

                storage_data_c(16 to 31) <= RAW_DATA(32 to 47);

            when "00011" =>

                storage_data_c(16 to 31) <= RAW_DATA(48 to 63);

            when others =>

                storage_data_c(16 to 31) <= (others => 'X');

        end case;

    end process;


    -- Muxes for Lane 2

    process (MUX_SELECT(10 to 14), RAW_DATA)

    begin

        case MUX_SELECT(10 to 14) is

            when "00000" =>

                storage_data_c(32 to 47) <= RAW_DATA(0 to 15);

            when "00001" =>

                storage_data_c(32 to 47) <= RAW_DATA(16 to 31);

            when "00010" =>

                storage_data_c(32 to 47) <= RAW_DATA(32 to 47);

            when "00011" =>

                storage_data_c(32 to 47) <= RAW_DATA(48 to 63);

            when others =>

                storage_data_c(32 to 47) <= (others => 'X');

        end case;

    end process;


    -- Muxes for Lane 3

    process (MUX_SELECT(15 to 19), RAW_DATA)

    begin

        case MUX_SELECT(15 to 19) is

            when "00000" =>

                storage_data_c(48 to 63) <= RAW_DATA(0 to 15);

            when "00001" =>

                storage_data_c(48 to 63) <= RAW_DATA(16 to 31);

            when "00010" =>

                storage_data_c(48 to 63) <= RAW_DATA(32 to 47);

            when "00011" =>

                storage_data_c(48 to 63) <= RAW_DATA(48 to 63);

            when others =>

                storage_data_c(48 to 63) <= (others => 'X');

        end case;

    end process;


    -- Register the stored data.

    process (USER_CLK)

    begin

        if (USER_CLK 'event and USER_CLK = '1') then

            if (STORAGE_CE(0) = '1') then

                STORAGE_DATA_Buffer(0 to 15) <= storage_data_c(0 to 15) after DLY;

            end if;

            if (STORAGE_CE(1) = '1') then

                STORAGE_DATA_Buffer(16 to 31) <= storage_data_c(16 to 31) after DLY;

            end if;

            if (STORAGE_CE(2) = '1') then

                STORAGE_DATA_Buffer(32 to 47) <= storage_data_c(32 to 47) after DLY;

            end if;

            if (STORAGE_CE(3) = '1') then

                STORAGE_DATA_Buffer(48 to 63) <= storage_data_c(48 to 63) after DLY;

            end if;

        end if;

    end process;

end RTL;
------------------------------------------------------------------------------
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/12/06 23:41:11 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: aurora_lane_v4_4byte_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.3 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--
------------------------------------------------------------------------------/
--
--  AURORA_LANE_4BYTE
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: the AURORA_LANE_4BYTE module provides a full duplex 4-byte
--               aurora lane connection using a single MGT.  The module handles
--               lane initialization, symbol generation and decoding and error
--               detection.  It also decodes some of the channel bonding
--               indicator signals needed by the Global logic.
--
--               * Supports Virtex 4
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.AURORA.all;

entity AURORA_LANE_4BYTE is

    generic (
            EXTEND_WATCHDOGS   : boolean := FALSE
    );

    port (

    -- MGT Interface

            RX_DATA             : in  std_logic_vector(31 downto 0);    -- 4-byte data bus from the MGT.
            RX_NOT_IN_TABLE     : in  std_logic_vector(3 downto 0);     -- Invalid 10-bit code was recieved.
            RX_DISP_ERR         : in  std_logic_vector(3 downto 0);     -- Disparity error detected on RX interface.
            RX_CHAR_IS_K        : in  std_logic_vector(3 downto 0);     -- Indicates which bytes of RX_DATA are control.
            RX_CHAR_IS_COMMA    : in  std_logic_vector(3 downto 0);     -- Comma received on given byte.
            RX_STATUS           : in  std_logic_vector(5 downto 0);     -- Part of GT_11 status and error bus
            RX_BUF_ERR          : in  std_logic;                        -- Overflow/Underflow of RX buffer detected.
            TX_BUF_ERR          : in  std_logic;                        -- Overflow/Underflow of TX buffer detected.
            RX_REALIGN          : in  std_logic;                        -- SERDES was realigned because of a new comma.
            PMA_RX_LOCK         : in  std_logic;                        -- PMA layer in GT10 MGT Locked
            RX_POLARITY         : out std_logic;                        -- Controls interpreted polarity of serial data inputs.
            RX_RESET            : out std_logic;                        -- Reset RX side of MGT logic.
            TX_CHAR_IS_K        : out std_logic_vector(3 downto 0);     -- TX_DATA byte is a control character.
            TX_DATA             : out std_logic_vector(31 downto 0);    -- 4-byte data bus to the MGT.
            TX_RESET            : out std_logic;                        -- Reset TX side of MGT logic.

    -- Comma Detect Phase Align Interface

            ENA_COMMA_ALIGN     : out std_logic;                        -- Request comma alignment.

    -- TX_LL Interface

            GEN_SCP             : in  std_logic_vector(0 to 1);         -- SCP generation request from TX_LL.
            GEN_ECP             : in  std_logic_vector(0 to 1);         -- ECP generation request from TX_LL.
            GEN_SNF             : in  std_logic_vector(0 to 1);         -- SNF generation request from TX_LL
            GEN_PAD             : in  std_logic_vector(0 to 1);         -- PAD generation request from TX_LL
            FC_NB               : in  std_logic_vector(0 to 7);         -- Size code for SUF and SNF messages
            TX_PE_DATA          : in  std_logic_vector(0 to 31);        -- Data from TX_LL to send over lane.
            TX_PE_DATA_V        : in  std_logic_vector(0 to 1);         -- Indicates TX_PE_DATA is Valid.
            GEN_CC              : in  std_logic;                        -- CC generation request from TX_LL.

    -- RX_LL Interface

            RX_PAD              : out std_logic_vector(0 to 1);         -- Indicates lane received PAD.
            RX_PE_DATA          : out std_logic_vector(0 to 31);        -- RX data from lane to RX_LL.
            RX_PE_DATA_V        : out std_logic_vector(0 to 1);         -- RX_PE_DATA is data, not control symbol.
            RX_SCP              : out std_logic_vector(0 to 1);         -- Indicates lane received SCP.
            RX_ECP              : out std_logic_vector(0 to 1);         -- Indicates lane received ECP
            RX_SNF              : out std_logic_vector(0 to 1);         -- Indicates lane received SNF
            RX_FC_NB            : out std_logic_vector(0 to 7);         -- Size code for SNF or SUF

    -- Global Logic Interface

            GEN_A               : in  std_logic;                        -- 'A character' generation request from Global Logic.
            GEN_K               : in  std_logic_vector(0 to 3);         -- 'K character' generation request from Global Logic.
            GEN_R               : in  std_logic_vector(0 to 3);         -- 'R character' generation request from Global Logic.
            GEN_V               : in  std_logic_vector(0 to 3);         -- Verification data generation request.
            LANE_UP             : out std_logic;                        -- Lane is ready for bonding and verification.
            SOFT_ERROR          : out std_logic_vector(0 to 1);         -- Soft error detected.
            HARD_ERROR          : out std_logic;                        -- Hard error detected.
            CHANNEL_BOND_LOAD   : out std_logic;                        -- Channel Bongding done code recieved.
            GOT_A               : out std_logic_vector(0 to 3);         -- Indicates lane recieved 'A character' bytes.
            GOT_V               : out std_logic;                        -- Verification symbols received.

    -- System Interface

            USER_CLK            : in  std_logic;                        -- System clock for all non-MGT Aurora Logic.
            RESET               : in  std_logic                         -- Reset the lane.

         );

end AURORA_LANE_4BYTE;

architecture RTL of AURORA_LANE_4BYTE is

-- Wire Declarations --

    signal  ena_comma_align_i     : std_logic;
    signal  gen_sp_i              : std_logic;
    signal  gen_spa_i             : std_logic;
    signal  rx_sp_i               : std_logic;
    signal  rx_spa_i              : std_logic;
    signal  rx_neg_i              : std_logic;
    signal  enable_error_detect_i : std_logic;
    signal  do_word_align_i       : std_logic;
    signal  hard_error_reset_i    : std_logic;
    signal  rx_reset_i            : std_logic;

    signal  tx_char_is_k_i        : std_logic_vector(3 downto 0);
    signal  tx_data_i             : std_logic_vector(31 downto 0);
    signal  rx_data_i             : std_logic_vector(31 downto 0);
    signal  rx_char_is_k_i        : std_logic_vector(3 downto 0);
    signal  rx_char_is_comma_i    : std_logic_vector(3 downto 0);
    signal  rx_disp_err_i         : std_logic_vector(3 downto 0);
    signal  rx_not_in_table_i     : std_logic_vector(3 downto 0);
    signal  LANE_UP_Buffer        : std_logic;

-- Component Declarations --

    component LANE_INIT_SM_4BYTE

        port (

        -- MGT Interface

                RX_NOT_IN_TABLE     : in std_logic_vector(3 downto 0); -- MGT received invalid 10b code
                RX_DISP_ERR         : in std_logic_vector(3 downto 0); -- MGT received 10b code w/ wrong disparity
                RX_CHAR_IS_COMMA    : in std_logic_vector(3 downto 0); -- MGT received a Comma
                RX_REALIGN          : in std_logic;                    -- MGT had to change alignment due to new comma
                RX_RESET            : out std_logic;                   -- Reset the RX side of the MGT
                TX_RESET            : out std_logic;                   -- Reset the TX side of the MGT
                RX_POLARITY         : out std_logic;                   -- Sets polarity used to interpet rx'ed symbols

        -- Comma Detect Phase Alignment Interface

                ENA_COMMA_ALIGN     : out std_logic;                   -- Turn on SERDES Alignment in MGT

        -- Symbol Generator Interface

                GEN_SP              : out std_logic;                   -- Generate SP symbol
                GEN_SPA             : out std_logic;                   -- Generate SPA symbol

        -- Symbol Decoder Interface

                RX_SP               : in std_logic;                    -- Lane rx'ed SP sequence w/ + or - data
                RX_SPA              : in std_logic;                    -- Lane rx'ed SPA sequence
                RX_NEG              : in std_logic;                    -- Lane rx'ed inverted SP or SPA data
                DO_WORD_ALIGN       : out std_logic;                   -- Enable word alignment

        -- Error Detection Logic Interface

                ENABLE_ERROR_DETECT : out std_logic;                   -- Turn on Soft Error detection
                HARD_ERROR_RESET    : in std_logic;                    -- Reset lane due to hard error

        -- Global Logic Interface

                LANE_UP             : out std_logic;                   -- Lane is initialized

        -- System Interface

                USER_CLK            : in std_logic;                    -- Clock for all non-MGT Aurora logic
                RESET               : in std_logic                     -- Reset Aurora Lane

             );

    end component;


    component CHBOND_COUNT_DEC_4BYTE

        port (

                RX_STATUS         : in std_logic_vector(5 downto 0);
                CHANNEL_BOND_LOAD : out std_logic;
                USER_CLK          : in std_logic

             );

    end component;


    component SYM_GEN_4BYTE

        port (

        -- TX_LL Interface                                        -- See description for info about GEN_PAD and TX_PE_DATA_V.

                GEN_SCP      : in std_logic_vector(0 to 1);       -- Generate SCP.
                GEN_ECP      : in std_logic_vector(0 to 1);       -- Generate ECP.
                GEN_SNF      : in std_logic_vector(0 to 1);       -- Generate SNF using code given by FC_NB.
                GEN_PAD      : in std_logic_vector(0 to 1);       -- Replace LSB with Pad character.
                FC_NB        : in std_logic_vector(0 to 7);       -- Size code for Flow Control messages.
                TX_PE_DATA   : in std_logic_vector(0 to 31);      -- Data.  Transmitted when TX_PE_DATA_V is asserted.
                TX_PE_DATA_V : in std_logic_vector(0 to 1);       -- Transmit data.
                GEN_CC       : in std_logic;                      -- Generate Clock Correction symbols.

        -- Global Logic Interface                                 -- See description for info about GEN_K,GEN_R and GEN_A.

                GEN_A        : in std_logic;                      -- Generate A character for MSBYTE
                GEN_K        : in std_logic_vector(0 to 3);       -- Generate K character for selected bytes.
                GEN_R        : in std_logic_vector(0 to 3);       -- Generate R character for selected bytes.
                GEN_V        : in std_logic_vector(0 to 3);       -- Generate Ver data character on selected bytes.

        -- Lane Init SM Interface

                GEN_SP       : in std_logic;                      -- Generate SP pattern.
                GEN_SPA      : in std_logic;                      -- Generate SPA pattern.

        -- MGT Interface

                TX_CHAR_IS_K : out std_logic_vector(3 downto 0);  -- Transmit TX_DATA as a control character.
                TX_DATA      : out std_logic_vector(31 downto 0); -- Data to MGT for transmission to channel partner.

        -- System Interface

                USER_CLK     : in std_logic                       -- Clock for all non-MGT Aurora Logic.

             );

    end component;


    component SYM_DEC_4BYTE

        port (

        -- RX_LL Interface

                RX_PAD           : out std_logic_vector(0 to 1);     -- LSByte is PAD.
                RX_PE_DATA       : out std_logic_vector(0 to 31);    -- Word aligned data from channel partner.
                RX_PE_DATA_V     : out std_logic_vector(0 to 1);     -- Data is valid data and not a control character.
                RX_SCP           : out std_logic_vector(0 to 1);     -- SCP symbol received.
                RX_ECP           : out std_logic_vector(0 to 1);     -- ECP symbol received.
                RX_SNF           : out std_logic_vector(0 to 1);     -- SNF symbol received.
                RX_FC_NB         : out std_logic_vector(0 to 7);     -- Flow Control size code.  Valid with RX_SNF or RX_SUF.

        -- Lane Init SM Interface

                DO_WORD_ALIGN    : in std_logic;                     -- Word alignment is allowed.
                LANE_UP          : in std_logic;                     -- Lane is up
                RX_SP            : out std_logic;                    -- SP sequence received with positive or negative data.
                RX_SPA           : out std_logic;                    -- SPA sequence received.
                RX_NEG           : out std_logic;                    -- Inverted data for SP or SPA received.

        -- Global Logic Interface

                GOT_A            : out std_logic_vector(0 to 3);     -- A character received on indicated byte(s).
                GOT_V            : out std_logic;                    -- V sequence received.

        -- MGT Interface

                RX_DATA          : in std_logic_vector(31 downto 0); -- Raw RX data from MGT.
                RX_CHAR_IS_K     : in std_logic_vector(3 downto 0);  -- Bits indicating which bytes are control characters.
                RX_CHAR_IS_COMMA : in std_logic_vector(3 downto 0);  -- Rx'ed a comma.

        -- System Interface

                USER_CLK         : in std_logic;                     -- System clock for all non-MGT Aurora Logic.
                RESET            : in std_logic

             );

    end component;


    component ERROR_DETECT_4BYTE is

        port (

        -- Lane Init SM Interface

                ENABLE_ERROR_DETECT : in  std_logic;
                HARD_ERROR_RESET    : out std_logic;

        -- Global Logic Interface

                SOFT_ERROR          : out std_logic_vector(0 to 1);
                HARD_ERROR          : out std_logic;

        -- MGT Interface

                RX_DISP_ERR         : in  std_logic_vector(3 downto 0);
                RX_NOT_IN_TABLE     : in  std_logic_vector(3 downto 0);
                RX_BUF_ERR          : in  std_logic;
                TX_BUF_ERR          : in  std_logic;
                RX_REALIGN          : in  std_logic;

        -- System Interface

                USER_CLK            : in std_logic

             );

    end component;

begin

    -- Assert RX_RESET automatically if PMA_RX_LOCK is low. Also assert it if 
    -- requested by the Lane Init State Machine
    RX_RESET           <= (not PMA_RX_LOCK) or rx_reset_i;   

    -- Buffers for twisting data from V4 --

    -- V4 MGTs order their data in the opposite direction from Pro MGTs.
    -- To reuse the Pro Aurora logic, we twist the data to make it compatible.

    TX_DATA            <= tx_data_i(7 downto 0) & tx_data_i(15 downto 8) & tx_data_i(23 downto 16) & tx_data_i(31 downto 24);
    TX_CHAR_IS_K       <= tx_char_is_k_i(0) & tx_char_is_k_i(1) & tx_char_is_k_i(2) & tx_char_is_k_i(3);
    rx_data_i          <= RX_DATA(7 downto 0) & RX_DATA(15 downto 8) & RX_DATA(23 downto 16) & RX_DATA(31 downto 24);
    rx_char_is_k_i     <= RX_CHAR_IS_K(0) & RX_CHAR_IS_K(1) & RX_CHAR_IS_K(2) & RX_CHAR_IS_K(3);
    rx_char_is_comma_i <= RX_CHAR_IS_COMMA(0) & RX_CHAR_IS_COMMA(1) & RX_CHAR_IS_COMMA(2) & RX_CHAR_IS_COMMA(3);
    rx_disp_err_i      <= RX_DISP_ERR(0) & RX_DISP_ERR(1) & RX_DISP_ERR(2) & RX_DISP_ERR(3);
    rx_not_in_table_i  <= RX_NOT_IN_TABLE(0) & RX_NOT_IN_TABLE(1) & RX_NOT_IN_TABLE(2) & RX_NOT_IN_TABLE(3);

    LANE_UP            <= LANE_UP_Buffer;

-- Main Body of Code --

    -- Lane Initialization state machine

    lane_init_sm_4byte_i : LANE_INIT_SM_4BYTE

        port map (

        -- MGT Interface

                    RX_NOT_IN_TABLE     =>  RX_NOT_IN_TABLE,
                    RX_DISP_ERR         =>  RX_DISP_ERR,
                    RX_CHAR_IS_COMMA    =>  RX_CHAR_IS_COMMA,
                    RX_REALIGN          =>  RX_REALIGN,
                    RX_RESET            =>  rx_reset_i,
                    TX_RESET            =>  TX_RESET,
                    RX_POLARITY         =>  RX_POLARITY,

        -- Comma Detect Phase Alignment Interface

                    ENA_COMMA_ALIGN     =>  ENA_COMMA_ALIGN,

        -- Symbol Generator Interface

                    GEN_SP              =>  gen_sp_i,
                    GEN_SPA             =>  gen_spa_i,

        -- Symbol Decoder Interface

                    RX_SP               =>  rx_sp_i,
                    RX_SPA              =>  rx_spa_i,
                    RX_NEG              =>  rx_neg_i,
                    DO_WORD_ALIGN       =>  do_word_align_i,

        -- Error Detection Logic Interface

                    HARD_ERROR_RESET    =>  hard_error_reset_i,
                    ENABLE_ERROR_DETECT =>  enable_error_detect_i,

        -- Global Logic Interface

                    LANE_UP             =>  LANE_UP_Buffer,

        -- System Interface

                    USER_CLK            =>  USER_CLK,
                    RESET               =>  RESET

                 );


    -- Channel Bonding Count Decode module

    chbond_count_dec_4byte_i : CHBOND_COUNT_DEC_4BYTE

        port map (

                    RX_STATUS         => RX_STATUS,
                    CHANNEL_BOND_LOAD => CHANNEL_BOND_LOAD,
                    USER_CLK          => USER_CLK

                 );


    -- Symbol Generation module

    sym_gen_4byte_i : SYM_GEN_4BYTE

        port map (

        -- TX_LL Interface

                    GEN_SCP      => GEN_SCP,
                    GEN_ECP      => GEN_ECP,
                    GEN_SNF      => GEN_SNF,
                    GEN_PAD      => GEN_PAD,
                    FC_NB        => FC_NB,
                    TX_PE_DATA   => TX_PE_DATA,
                    TX_PE_DATA_V => TX_PE_DATA_V,
                    GEN_CC       => GEN_CC,

        -- Global Logic Interface

                    GEN_A        => GEN_A,
                    GEN_K        => GEN_K,
                    GEN_R        => GEN_R,
                    GEN_V        => GEN_V,

        -- Lane Init SM Interface

                    GEN_SP       => gen_sp_i,
                    GEN_SPA      => gen_spa_i,

        -- MGT Interface

                    TX_CHAR_IS_K => tx_char_is_k_i,
                    TX_DATA      => tx_data_i,

        -- System Interface

                    USER_CLK     => USER_CLK

                 );


    -- Symbol Decode module

    sym_dec_4byte_i : SYM_DEC_4BYTE

        port map (

        -- RX_LL Interface

                    RX_PAD           => RX_PAD,
                    RX_PE_DATA       => RX_PE_DATA,
                    RX_PE_DATA_V     => RX_PE_DATA_V,
                    RX_SCP           => RX_SCP,
                    RX_ECP           => RX_ECP,
                    RX_SNF           => RX_SNF,
                    RX_FC_NB         => RX_FC_NB,

        -- Lane Init SM Interface

                    DO_WORD_ALIGN    => do_word_align_i,
                    LANE_UP          => LANE_UP_Buffer,
                    RX_SP            => rx_sp_i,
                    RX_SPA           => rx_spa_i,
                    RX_NEG           => rx_neg_i,

        -- Global Logic Interface

                    GOT_A            => GOT_A,
                    GOT_V            => GOT_V,

        -- MGT Interface

                    RX_DATA          => rx_data_i,
                    RX_CHAR_IS_K     => rx_char_is_k_i,
                    RX_CHAR_IS_COMMA => rx_char_is_comma_i,

        -- System Interface

                    USER_CLK         => USER_CLK,
                    RESET            => RESET

                 );


    -- Error Detection module

    error_detect_4byte_i : ERROR_DETECT_4BYTE

        port map (

        -- Lane Init SM Interface

                    ENABLE_ERROR_DETECT => enable_error_detect_i,
                    HARD_ERROR_RESET    => hard_error_reset_i,

        -- Global Logic Interface

                    SOFT_ERROR          => SOFT_ERROR,
                    HARD_ERROR          => HARD_ERROR,

        -- MGT Interface

                    RX_DISP_ERR         => rx_disp_err_i,
                    RX_NOT_IN_TABLE     => rx_not_in_table_i,
                    RX_BUF_ERR          => RX_BUF_ERR,
                    TX_BUF_ERR          => TX_BUF_ERR,
                    RX_REALIGN          => RX_REALIGN,

        -- System Interface

                    USER_CLK            => USER_CLK

                 );

end RTL;
    -------------------------------------------------------------------------------
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/11/07 21:30:54 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: rx_ll_pdu_datapath_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.4 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--
-------------------------------------------------------------------------------
--
--  RX_LL_PDU_DATAPATH
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: the RX_LL_PDU_DATAPATH module takes regular PDU data in Aurora format
--               and transforms it to LocalLink formatted data
--
--               This module supports 4 4-byte lane designs
--              
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use WORK.AURORA.all;

entity RX_LL_PDU_DATAPATH is

    port (

    -- Traffic Separator Interface

            PDU_DATA     : in std_logic_vector(0 to 63);
            PDU_DATA_V   : in std_logic_vector(0 to 3);
            PDU_PAD      : in std_logic_vector(0 to 3);
            PDU_SCP      : in std_logic_vector(0 to 3);
            PDU_ECP      : in std_logic_vector(0 to 3);

    -- LocalLink PDU Interface

            RX_D         : out std_logic_vector(0 to 63);
            RX_REM       : out std_logic_vector(0 to 2);
            RX_SRC_RDY_N : out std_logic;
            RX_SOF_N     : out std_logic;
            RX_EOF_N     : out std_logic;

    -- Error Interface

            FRAME_ERROR  : out std_logic;

    -- System Interface

            USER_CLK     : in std_logic;
            RESET        : in std_logic

         );

end RX_LL_PDU_DATAPATH;


architecture RTL of RX_LL_PDU_DATAPATH is

--****************************Parameter Declarations**************************

    constant DLY : time := 1 ns;

    
--****************************External Register Declarations**************************

    signal RX_D_Buffer                      : std_logic_vector(0 to 63);
    signal RX_REM_Buffer                    : std_logic_vector(0 to 2);
    signal RX_SRC_RDY_N_Buffer              : std_logic;
    signal RX_SOF_N_Buffer                  : std_logic;
    signal RX_EOF_N_Buffer                  : std_logic;
    signal FRAME_ERROR_Buffer               : std_logic;


--****************************Internal Register Declarations**************************
    --Stage 1
    signal stage_1_data_r                   : std_logic_vector(0 to 63); 
    signal stage_1_pad_r                    : std_logic;  
    signal stage_1_ecp_r                    : std_logic_vector(0 to 3);
    signal stage_1_scp_r                    : std_logic_vector(0 to 3);
    signal stage_1_start_detected_r         : std_logic;


    --Stage 2
    signal stage_2_data_r                   : std_logic_vector(0 to 63);
    signal stage_2_pad_r                    : std_logic;  
    signal stage_2_start_with_data_r        : std_logic; 
    signal stage_2_end_before_start_r       : std_logic;
    signal stage_2_end_after_start_r        : std_logic;    
    signal stage_2_start_detected_r         : std_logic; 
    signal stage_2_frame_error_r            : std_logic;
        

    




--*********************************Wire Declarations**********************************
    --Stage 1
    signal stage_1_data_v_r                 : std_logic_vector(0 to 3);
    signal stage_1_after_scp_r              : std_logic_vector(0 to 3);
    signal stage_1_in_frame_r               : std_logic_vector(0 to 3);
    
    --Stage 2
    signal stage_2_left_align_select_r      : std_logic_vector(0 to 11);
    signal stage_2_data_v_r                 : std_logic_vector(0 to 3);
    
    signal stage_2_data_v_count_r           : std_logic_vector(0 to 2);
    signal stage_2_frame_error_c            : std_logic;
             
 
    --Stage 3
    signal stage_3_data_r                   : std_logic_vector(0 to 63);
    
 
    
    signal stage_3_storage_count_r          : std_logic_vector(0 to 2);
    signal stage_3_storage_ce_r             : std_logic_vector(0 to 3);
    signal stage_3_end_storage_r            : std_logic;
    signal stage_3_storage_select_r         : std_logic_vector(0 to 19);
    signal stage_3_output_select_r          : std_logic_vector(0 to 19);
    signal stage_3_src_rdy_n_r              : std_logic;
    signal stage_3_sof_n_r                  : std_logic;
    signal stage_3_eof_n_r                  : std_logic;
    signal stage_3_rem_r                    : std_logic_vector(0 to 2);
    signal stage_3_frame_error_r            : std_logic;
    
  
  
    --Stage 4
    signal storage_data_r                   : std_logic_vector(0 to 63);
  
    

-- ********************************** Component Declarations ************************************--

    component RX_LL_DEFRAMER
    port (
        PDU_DATA_V      : in std_logic_vector(0 to 3);
        PDU_SCP         : in std_logic_vector(0 to 3);
        PDU_ECP         : in std_logic_vector(0 to 3);
        USER_CLK        : in std_logic;
        RESET           : in std_logic;
        
        DEFRAMED_DATA_V : out std_logic_vector(0 to 3);
        IN_FRAME        : out std_logic_vector(0 to 3);
        AFTER_SCP       : out std_logic_vector(0 to 3)
    );
    end component;


    component LEFT_ALIGN_CONTROL
    port (
        PREVIOUS_STAGE_VALID : in std_logic_vector(0 to 3);

        MUX_SELECT           : out std_logic_vector(0 to 11);
        VALID                : out std_logic_vector(0 to 3);

        USER_CLK             : in std_logic;
        RESET                : in std_logic

    );
    end component;


    component VALID_DATA_COUNTER
    port (
        PREVIOUS_STAGE_VALID : in std_logic_vector(0 to 3);
        
        USER_CLK             : in std_logic;
        RESET                : in std_logic;
        
        COUNT                : out std_logic_vector(0 to 2)
     );
     end component;


    component LEFT_ALIGN_MUX
    port (
        RAW_DATA   : in std_logic_vector(0 to 63);
        MUX_SELECT : in std_logic_vector(0 to 11);
        
        USER_CLK   : in std_logic;
        
        MUXED_DATA : out std_logic_vector(0 to 63)

     );
    end component;


    component STORAGE_COUNT_CONTROL
    port (

        LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
        END_STORAGE        : in std_logic;
        START_WITH_DATA    : in std_logic;
        FRAME_ERROR        : in std_logic;
        
        STORAGE_COUNT      : out std_logic_vector(0 to 2);
        
        USER_CLK           : in std_logic;
        RESET              : in std_logic
    );
    end component;


    component STORAGE_CE_CONTROL
    port (
        LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
        STORAGE_COUNT      : in std_logic_vector(0 to 2);
        END_STORAGE        : in std_logic;
        START_WITH_DATA    : in std_logic;
        
        STORAGE_CE         : out std_logic_vector(0 to 3);
        
        USER_CLK           : in std_logic;
        RESET              : in std_logic
    );
    end component;


    component STORAGE_SWITCH_CONTROL
    port (
        LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
        STORAGE_COUNT      : in std_logic_vector(0 to 2);
        END_STORAGE        : in std_logic;
        START_WITH_DATA    : in std_logic;
        
        STORAGE_SELECT     : out std_logic_vector(0 to 19);
        
        USER_CLK           : in std_logic
    );
    end component;


    component OUTPUT_SWITCH_CONTROL
    port (
        LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
        STORAGE_COUNT      : in std_logic_vector(0 to 2);
        END_STORAGE        : in std_logic;
        START_WITH_DATA    : in std_logic;
        
        OUTPUT_SELECT      : out std_logic_vector(0 to 19);
        
        USER_CLK           : in std_logic
    );
    end component;


    component SIDEBAND_OUTPUT
    port (
        LEFT_ALIGNED_COUNT : in std_logic_vector(0 to 2);
        STORAGE_COUNT      : in std_logic_vector(0 to 2);
        END_BEFORE_START   : in std_logic;
        END_AFTER_START    : in std_logic;
        START_DETECTED     : in std_logic;
        START_WITH_DATA    : in std_logic;
        PAD                : in std_logic;
        FRAME_ERROR        : in std_logic;
        USER_CLK           : in std_logic;
        RESET              : in std_logic;
        END_STORAGE        : out std_logic;
        SRC_RDY_N          : out std_logic;
        SOF_N              : out std_logic;
        EOF_N              : out std_logic;
        RX_REM             : out std_logic_vector(0 to 2);
        FRAME_ERROR_RESULT : out std_logic
    );
    end component;


    component STORAGE_MUX
    port (

        RAW_DATA     : in std_logic_vector(0 to 63);
        MUX_SELECT   : in std_logic_vector(0 to 19);
        STORAGE_CE   : in std_logic_vector(0 to 3);
        USER_CLK     : in std_logic;
        
        STORAGE_DATA : out std_logic_vector(0 to 63)
    );
    end component;


    component OUTPUT_MUX
    port (
        STORAGE_DATA      : in std_logic_vector(0 to 63);
        LEFT_ALIGNED_DATA : in std_logic_vector(0 to 63);
        MUX_SELECT        : in std_logic_vector(0 to 19);
        USER_CLK          : in std_logic;
        
        OUTPUT_DATA       : out std_logic_vector(0 to 63)
    );
    end component;


begin    
   
--*********************************Main Body of Code**********************************
    
    -- VHDL Helper Logic
    RX_D         <= RX_D_Buffer;
    RX_REM       <= RX_REM_Buffer;
    RX_SRC_RDY_N <= RX_SRC_RDY_N_Buffer;
    RX_SOF_N     <= RX_SOF_N_Buffer;
    RX_EOF_N     <= RX_EOF_N_Buffer;
    FRAME_ERROR  <= FRAME_ERROR_Buffer;
    
    


    --_____Stage 1: Decode Frame Encapsulation and remove unframed data ________
    
    
    stage_1_rx_ll_deframer_i : RX_LL_DEFRAMER 
    port map
    (        
        PDU_DATA_V          =>   PDU_DATA_V,
        PDU_SCP             =>   PDU_SCP,
        PDU_ECP             =>   PDU_ECP,
        USER_CLK            =>   USER_CLK,
        RESET               =>   RESET,

        DEFRAMED_DATA_V     =>   stage_1_data_v_r,
        IN_FRAME            =>   stage_1_in_frame_r,
        AFTER_SCP           =>   stage_1_after_scp_r
   
    );
    
   
    --Determine whether there were any SCPs detected, regardless of data
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            if(RESET = '1') then
                stage_1_start_detected_r    <= '0' after DLY;  
            else         
                stage_1_start_detected_r    <=  std_bool(PDU_SCP /= "0000") after DLY; 
            end if;
        end if;
    end process;    
   
   
    --Pipeline the data signal, and register a signal to indicate whether the data in
    -- the current cycle contained a Pad character.
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            stage_1_data_r             <=  PDU_DATA after DLY;
            stage_1_pad_r              <=  std_bool(PDU_PAD /= "0000") after DLY;
            stage_1_ecp_r              <=  PDU_ECP after DLY;
            stage_1_scp_r              <=  PDU_SCP after DLY;
        end if;    
    end process;    
    
    
    
    --_______________________Stage 2: First Control Stage ___________________________
    
    
    --We instantiate a LEFT_ALIGN_CONTROL module to drive the select signals for the
    --left align mux in the next stage, and to compute the next stage valid signals
    
    stage_2_left_align_control_i : LEFT_ALIGN_CONTROL 
    port map(
        PREVIOUS_STAGE_VALID    =>   stage_1_data_v_r,

        MUX_SELECT              =>   stage_2_left_align_select_r,
        VALID                   =>   stage_2_data_v_r,
        
        USER_CLK                =>   USER_CLK,
        RESET                   =>   RESET

    );
        

    
    --Count the number of valid data lanes: this count is used to select which data 
    -- is stored and which data is sent to output in later stages    
    stage_2_valid_data_counter_i : VALID_DATA_COUNTER 
    port map(
        PREVIOUS_STAGE_VALID    =>   stage_1_data_v_r,
        USER_CLK                =>   USER_CLK,
        RESET                   =>   RESET,
        
        COUNT                   =>   stage_2_data_v_count_r
    );
     
     
          
    --Pipeline the data and pad bits
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            stage_2_data_r          <=  stage_1_data_r after DLY;        
            stage_2_pad_r           <=  stage_1_pad_r after DLY;
        end if;    
    end process;   
        
        
    
    
    --Determine whether there was any valid data after any SCP characters
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            if(RESET = '1') then
                stage_2_start_with_data_r    <=  '0' after DLY;
            else
                stage_2_start_with_data_r    <=  std_bool((stage_1_data_v_r and stage_1_after_scp_r) /= "0000") after DLY;
            end if;
        end if;
    end process;    
        
        
        
    --Determine whether there were any ECPs detected before any SPC characters
    -- arrived
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            if(RESET = '1') then
                stage_2_end_before_start_r      <=  '0' after DLY;   
            else
                stage_2_end_before_start_r      <=  std_bool((stage_1_ecp_r and not stage_1_after_scp_r) /= "0000") after DLY;
            end if;
        end if;
    end process;    
    
    
    --Determine whether there were any ECPs detected at all
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            if(RESET = '1') then
                stage_2_end_after_start_r       <=  '0' after DLY;   
            else        
                stage_2_end_after_start_r       <=  std_bool((stage_1_ecp_r and stage_1_after_scp_r) /= "0000") after DLY;
            end if;
        end if;
    end process;    
        
    
    --Pipeline the SCP detected signal
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            if(RESET = '1') then
                stage_2_start_detected_r    <=  '0' after DLY;  
            else        
                stage_2_start_detected_r    <=   stage_1_start_detected_r after DLY;
            end if;
        end if;
    end process;    
        
    
    
    --Detect frame errors. Note that the frame error signal is held until the start of 
    -- a frame following the data beat that caused the frame error
    stage_2_frame_error_c   <=   std_bool( (stage_1_ecp_r and not stage_1_in_frame_r) /= "0000" ) or
                                 std_bool( (stage_1_scp_r and stage_1_in_frame_r) /= "0000" );
    
    
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            if(RESET = '1') then
                stage_2_frame_error_r               <=  '0' after DLY;
            elsif(stage_2_frame_error_c = '1') then
                stage_2_frame_error_r               <=  '1' after DLY;
            elsif(stage_1_start_detected_r = '1') then   
                stage_2_frame_error_r               <=  '0' after DLY;
            end if;
        end if;
    end process;    
       
    
        
 



    --_______________________________ Stage 3 Left Alignment _________________________
    
    
    --We instantiate a left align mux to shift all lanes with valid data in the channel leftward
    --The data is seperated into groups of 8 lanes, and all valid data within each group is left
    --aligned.
    stage_3_left_align_datapath_mux_i : LEFT_ALIGN_MUX 
    port map(
        RAW_DATA    =>   stage_2_data_r,
        MUX_SELECT  =>   stage_2_left_align_select_r,
        USER_CLK    =>   USER_CLK,
 
        MUXED_DATA  =>   stage_3_data_r
    );
        






    --Determine the number of valid data lanes that will be in storage on the next cycle
    stage_3_storage_count_control_i : STORAGE_COUNT_CONTROL 
    port map(
        LEFT_ALIGNED_COUNT  =>   stage_2_data_v_count_r,
        END_STORAGE         =>   stage_3_end_storage_r,
        START_WITH_DATA     =>   stage_2_start_with_data_r,
        FRAME_ERROR         =>   stage_2_frame_error_r,
        
        STORAGE_COUNT       =>   stage_3_storage_count_r,
        
        USER_CLK            =>   USER_CLK,
        RESET               =>   RESET
          
    );
        
     
     
    --Determine the CE settings for the storage module for the next cycle
    stage_3_storage_ce_control_i : STORAGE_CE_CONTROL 
    port map(
        LEFT_ALIGNED_COUNT  =>   stage_2_data_v_count_r,
        STORAGE_COUNT       =>   stage_3_storage_count_r,
        END_STORAGE         =>   stage_3_end_storage_r,
        START_WITH_DATA     =>   stage_2_start_with_data_r,

        STORAGE_CE          =>   stage_3_storage_ce_r,
        
        USER_CLK            =>   USER_CLK,
        RESET               =>   RESET
    
    );
    
             
        
    --Determine the appropriate switch settings for the storage module for the next cycle
    stage_3_storage_switch_control_i : STORAGE_SWITCH_CONTROL 
    port map(
        LEFT_ALIGNED_COUNT  =>   stage_2_data_v_count_r,
        STORAGE_COUNT       =>   stage_3_storage_count_r,
        END_STORAGE         =>   stage_3_end_storage_r,
        START_WITH_DATA     =>   stage_2_start_with_data_r,

        STORAGE_SELECT      =>   stage_3_storage_select_r,
        
        USER_CLK            =>   USER_CLK
        
    );
    
        
        
    --Determine the appropriate switch settings for the output module for the next cycle
    stage_3_output_switch_control_i : OUTPUT_SWITCH_CONTROL 
    port map(
        LEFT_ALIGNED_COUNT  =>   stage_2_data_v_count_r,
        STORAGE_COUNT       =>   stage_3_storage_count_r,
        END_STORAGE         =>   stage_3_end_storage_r,
        START_WITH_DATA     =>   stage_2_start_with_data_r,

        OUTPUT_SELECT       =>   stage_3_output_select_r,
        
        USER_CLK            =>   USER_CLK
    
    );
        
    
    --Instantiate a sideband output controller
    sideband_output_i : SIDEBAND_OUTPUT 
    port map(
        LEFT_ALIGNED_COUNT  =>   stage_2_data_v_count_r,
        STORAGE_COUNT       =>   stage_3_storage_count_r,
        END_BEFORE_START    =>   stage_2_end_before_start_r,
        END_AFTER_START     =>   stage_2_end_after_start_r,
        START_DETECTED      =>   stage_2_start_detected_r,
        START_WITH_DATA     =>   stage_2_start_with_data_r,
        PAD                 =>   stage_2_pad_r,
        FRAME_ERROR         =>   stage_2_frame_error_r,
        USER_CLK            =>   USER_CLK,
        RESET               =>   RESET,
    
        END_STORAGE         =>   stage_3_end_storage_r,
        SRC_RDY_N           =>   stage_3_src_rdy_n_r,
        SOF_N               =>   stage_3_sof_n_r,
        EOF_N               =>   stage_3_eof_n_r,
        RX_REM              =>   stage_3_rem_r,
        FRAME_ERROR_RESULT  =>   stage_3_frame_error_r
    );
    
      
    
    
    
    --________________________________ Stage 4: Storage and Output_______________________
 
    
    --Storage: Data is moved to storage when it cannot be sent directly to the output.
    
    stage_4_storage_mux_i : STORAGE_MUX 
    port map(
        RAW_DATA        =>   stage_3_data_r,
        MUX_SELECT      =>   stage_3_storage_select_r,
        STORAGE_CE      =>   stage_3_storage_ce_r,
        USER_CLK        =>   USER_CLK,

        STORAGE_DATA    =>   storage_data_r
        
    );
    
    
    
    --Output: Data is moved to the locallink output when a full word of valid data is ready,
    -- or the end of a frame is reached
    
    output_mux_i : OUTPUT_MUX 
    port map(
        STORAGE_DATA        =>   storage_data_r,    
        LEFT_ALIGNED_DATA   =>   stage_3_data_r,
        MUX_SELECT          =>   stage_3_output_select_r,
        USER_CLK            =>   USER_CLK,
        
        OUTPUT_DATA         =>   RX_D_Buffer
        
    );
    
    
    --Pipeline LocalLink sideband signals
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            RX_SOF_N_Buffer        <=  stage_3_sof_n_r after DLY;
            RX_EOF_N_Buffer        <=  stage_3_eof_n_r after DLY;
            RX_REM_Buffer          <=  stage_3_rem_r after DLY;
        end if;    
    end process;
         

    --Pipeline the LocalLink source Ready signal
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            if(RESET = '1') then
                RX_SRC_RDY_N_Buffer    <=  '1' after DLY;
            else
                RX_SRC_RDY_N_Buffer    <=  stage_3_src_rdy_n_r after DLY;
            end if;
        end if;
    end process;    
        
        
    
    --Pipeline the Frame error signal
    process(USER_CLK)
    begin
        if(USER_CLK 'event and USER_CLK = '1') then
            if(RESET = '1') then
                FRAME_ERROR_Buffer     <=  '0' after DLY;
            else        
                FRAME_ERROR_Buffer     <=  stage_3_frame_error_r after DLY;
            end if;
        end if;
    end process;    
    
 
 
 end RTL;


--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/12/15 01:59:13 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: rx_ll_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.5 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  RX_LL
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: The RX_LL module receives data from the Aurora Channel,
--               converts it to LocalLink and sends it to the user interface.
--               It also handles NFC and UFC messages.
--
--               This module supports 4 4-byte lane designs.
--
--               This module supports Immediate Mode Native Flow Control.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RX_LL is

    port (

    -- LocalLink PDU Interface

            RX_D             : out std_logic_vector(0 to 63);
            RX_REM           : out std_logic_vector(0 to 2);
            RX_SRC_RDY_N     : out std_logic;
            RX_SOF_N         : out std_logic;
            RX_EOF_N         : out std_logic;

    -- Global Logic Interface

            START_RX         : in std_logic;

    -- Aurora Lane Interface

            RX_PAD           : in std_logic_vector(0 to 3);
            RX_PE_DATA       : in std_logic_vector(0 to 63);
            RX_PE_DATA_V     : in std_logic_vector(0 to 3);
            RX_SCP           : in std_logic_vector(0 to 3);
            RX_ECP           : in std_logic_vector(0 to 3);
            RX_SNF           : in std_logic_vector(0 to 3);
            RX_FC_NB         : in std_logic_vector(0 to 15);

    -- TX_LL Interface

            DECREMENT_NFC    : in std_logic;
            TX_WAIT          : out std_logic;

    -- Error Interface

            FRAME_ERROR      : out std_logic;

    -- System Interface

            USER_CLK         : in std_logic

         );

end RX_LL;

architecture MAPPED of RX_LL is

-- External Register Declarations --

    signal RX_D_Buffer             : std_logic_vector(0 to 63);
    signal RX_REM_Buffer           : std_logic_vector(0 to 2);
    signal RX_SRC_RDY_N_Buffer     : std_logic;
    signal RX_SOF_N_Buffer         : std_logic;
    signal RX_EOF_N_Buffer         : std_logic;
    signal TX_WAIT_Buffer          : std_logic;
    signal FRAME_ERROR_Buffer      : std_logic;

-- Wire Declarations --

    signal start_rx_i          : std_logic;

-- Component Declarations --

    component RX_LL_NFC

        port (

        -- Aurora Lane Interface

                RX_SNF        : in  std_logic_vector(0 to 3);
                RX_FC_NB      : in  std_logic_vector(0 to 15);

        -- TX_LL Interface

                DECREMENT_NFC : in  std_logic;
                TX_WAIT       : out std_logic;

        -- Global Logic Interface

                CHANNEL_UP    : in  std_logic;

        -- USER Interface

                USER_CLK      : in  std_logic

             );

    end component;


    component RX_LL_PDU_DATAPATH

        port (

        -- Traffic Separator Interface

                PDU_DATA     : in std_logic_vector(0 to 63);
                PDU_DATA_V   : in std_logic_vector(0 to 3);
                PDU_PAD      : in std_logic_vector(0 to 3);
                PDU_SCP      : in std_logic_vector(0 to 3);
                PDU_ECP      : in std_logic_vector(0 to 3);

        -- LocalLink PDU Interface

                RX_D         : out std_logic_vector(0 to 63);
                RX_REM       : out std_logic_vector(0 to 2);
                RX_SRC_RDY_N : out std_logic;
                RX_SOF_N     : out std_logic;
                RX_EOF_N     : out std_logic;

        -- Error Interface

                FRAME_ERROR  : out std_logic;

        -- System Interface

                USER_CLK     : in std_logic;
                RESET        : in std_logic

             );

    end component;


begin

    RX_D             <= RX_D_Buffer;
    RX_REM           <= RX_REM_Buffer;
    RX_SRC_RDY_N     <= RX_SRC_RDY_N_Buffer;
    RX_SOF_N         <= RX_SOF_N_Buffer;
    RX_EOF_N         <= RX_EOF_N_Buffer;
    TX_WAIT          <= TX_WAIT_Buffer;
    FRAME_ERROR      <= FRAME_ERROR_Buffer;

    start_rx_i       <= not START_RX;

-- Main Body of Code --

    -- NFC processing --

    nfc_module_i : RX_LL_NFC

        port map (

        -- Aurora Lane Interface

                    RX_SNF        => RX_SNF,
                    RX_FC_NB      => RX_FC_NB,

        -- TX_LL Interface

                    DECREMENT_NFC => DECREMENT_NFC,
                    TX_WAIT       => TX_WAIT_Buffer,

        -- Global Logic Interface

                    CHANNEL_UP    => START_RX,

        -- USER Interface

                    USER_CLK      => USER_CLK

                 );


    -- Datapath for user PDUs --

    rx_ll_pdu_datapath_i : RX_LL_PDU_DATAPATH

        port map (

        -- Traffic Separator Interface

                    PDU_DATA     => RX_PE_DATA,
                    PDU_DATA_V   => RX_PE_DATA_V,
                    PDU_PAD      => RX_PAD,
                    PDU_SCP      => RX_SCP,
                    PDU_ECP      => RX_ECP,

        -- LocalLink PDU Interface

                    RX_D         => RX_D_Buffer,
                    RX_REM       => RX_REM_Buffer,
                    RX_SRC_RDY_N => RX_SRC_RDY_N_Buffer,
                    RX_SOF_N     => RX_SOF_N_Buffer,
                    RX_EOF_N     => RX_EOF_N_Buffer,

        -- Error Interface

                    FRAME_ERROR  => FRAME_ERROR_Buffer,

        -- System Interface

                    USER_CLK     => USER_CLK,
                    RESET        => start_rx_i

                 );


end MAPPED;
--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/12/09 18:45:29 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: aurora_v4_4byte_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.5 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  aurora_402_2gb_full
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  Description: This is the top level module for a 2 4-byte lane Aurora
--               reference design module. This module supports the following features:
--
--               * Immediate Mode Native Flow Control
--               * Supports Virtex 4
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.all;
--synthesis translate_on

entity aurora_402_2gb_full is
    generic (                    
            EXTEND_WATCHDOGS     :   boolean  := FALSE;
            SIMULATION_P         :   integer  :=   0;
            LANE0_GT11_MODE_P    :   string   :=   "B";  -- Based on MGT Location
            LANE0_MGT_ID_P       :   integer  :=   1;
            LANE1_GT11_MODE_P    :   string   :=   "A";  -- Based on MGT Location
            LANE1_MGT_ID_P       :   integer  :=   0;
            TX_FD_MIN_P          :   std_logic_vector(8 downto 0) :=   "001111101";      -- floor (128*Tpclk/Tdclk) - 3
            RX_FD_MIN_P          :   std_logic_vector(8 downto 0) :=   "001111101";      -- floor (128*Tpclk/Tdclk) - 3
            DCLK_PERIOD_NS_P     :   integer                      :=   20;    -- Integer period between 20ns and 40ns (50Mhz to 25Mhz). Default is 20 ns
            TXPOST_TAP_PD_P      :   boolean                      := FALSE  -- Default is false, set to true for serial loopback or tuned preemphasis    
    );
    port (

    -- LocalLink TX Interface

            TX_D            : in  std_logic_vector(0 to 63);
            TX_REM          : in  std_logic_vector(0 to 2);
            TX_SRC_RDY_N    : in  std_logic;
            TX_SOF_N        : in  std_logic;
            TX_EOF_N        : in  std_logic;
            TX_DST_RDY_N    : out std_logic;

    -- LocalLink RX Interface

            RX_D            : out std_logic_vector(0 to 63);
            RX_REM          : out std_logic_vector(0 to 2);
            RX_SRC_RDY_N    : out std_logic;
            RX_SOF_N        : out std_logic;
            RX_EOF_N        : out std_logic;

    -- Native Flow Control Interface

            NFC_REQ_N       : in  std_logic;
            NFC_NB          : in  std_logic_vector(0 to 3);
            NFC_ACK_N       : out std_logic;

    -- MGT Serial I/O

            RXP             : in  std_logic_vector(0 to 1);
            RXN             : in  std_logic_vector(0 to 1);
            TXP             : out std_logic_vector(0 to 1);
            TXN             : out std_logic_vector(0 to 1);

    -- MGT Reference Clock Interface

            REF_CLK1_LEFT        : in  std_logic;

    -- Error Detection Interface

            HARD_ERROR      : out std_logic;
            SOFT_ERROR      : out std_logic;
            FRAME_ERROR     : out std_logic;

    -- Status

            CHANNEL_UP      : out std_logic;
            LANE_UP         : out std_logic_vector(0 to 1);

    -- Clock Compensation Control Interface

            WARN_CC         : in  std_logic;
            DO_CC           : in  std_logic;

    -- Calibration Block Interface

            CALBLOCK_ACTIVE : out std_logic_vector(0 to 1);
            DISABLE_CALBLOCK: in  std_logic_vector(0 to 1);
            RESET_CALBLOCKS : in  std_logic;
            RX_SIGNAL_DETECT: in  std_logic_vector(0 to 1); 
            DCLK            : in  std_logic; 

    -- Ports for simulation

            MGT0_COMBUSIN   : in  std_logic_vector(15 downto 0); 
            MGT0_COMBUSOUT  : out std_logic_vector(15 downto 0); 

    -- Ports for simulation

            MGT1_COMBUSIN   : in  std_logic_vector(15 downto 0); 
            MGT1_COMBUSOUT  : out std_logic_vector(15 downto 0); 

    

    -- System Interface

            DCM_NOT_LOCKED  : in  std_logic;
            USER_CLK        : in  std_logic;
            RESET           : in  std_logic;
            POWER_DOWN      : in  std_logic;
            LOOPBACK        : in  std_logic_vector(1 downto 0);
            PMA_INIT        : in  std_logic;
            TX_OUT_CLK      : out std_logic

         );

end aurora_402_2gb_full;

architecture MAPPED of aurora_402_2gb_full is

-- Component Declarations --

    component FD

        generic (
                    INIT : bit := '0'
                );

        port (
                Q : out std_ulogic;
                C : in  std_ulogic;
                D : in  std_ulogic
             );

    end component;


    component AURORA_LANE_4BYTE
        generic (                    
                EXTEND_WATCHDOGS   : boolean := FALSE
        );
        port (

        -- MGT Interface

                RX_DATA             : in  std_logic_vector(31 downto 0);    -- 4-byte data bus from the MGT.
                RX_NOT_IN_TABLE     : in  std_logic_vector(3 downto 0);     -- Invalid 10-bit code was recieved.
                RX_DISP_ERR         : in  std_logic_vector(3 downto 0);     -- Disparity error detected on RX interface.
                RX_CHAR_IS_K        : in  std_logic_vector(3 downto 0);     -- Indicates which bytes of RX_DATA are control.
                RX_CHAR_IS_COMMA    : in  std_logic_vector(3 downto 0);     -- Comma received on given byte.
                RX_BUF_ERR          : in  std_logic;                        -- Overflow/Underflow of RX buffer detected.
                RX_STATUS           : in  std_logic_vector(5 downto 0);     -- Part of GT_11 status and error bus
                TX_BUF_ERR          : in  std_logic;                        -- Overflow/Underflow of TX buffer detected.
                RX_REALIGN          : in  std_logic;                        -- SERDES was realigned because of a new comma.
                PMA_RX_LOCK         : in  std_logic;                        -- PMA layer in GT10 MGT Locked
                RX_POLARITY         : out std_logic;                        -- Controls interpreted polarity of serial data inputs.
                RX_RESET            : out std_logic;                        -- Reset RX side of MGT logic.
                TX_CHAR_IS_K        : out std_logic_vector(3 downto 0);     -- TX_DATA byte is a control character.
                TX_DATA             : out std_logic_vector(31 downto 0);    -- 4-byte data bus to the MGT.
                TX_RESET            : out std_logic;                        -- Reset TX side of MGT logic.

        -- Comma Detect Phase Align Interface

                ENA_COMMA_ALIGN     : out std_logic;                        -- Request comma alignment.

        -- TX_LL Interface

                GEN_SCP             : in  std_logic_vector(0 to 1);         -- SCP generation request from TX_LL.
                GEN_ECP             : in  std_logic_vector(0 to 1);         -- ECP generation request from TX_LL.
                GEN_SNF             : in  std_logic_vector(0 to 1);         -- SNF generation request from TX_LL
                GEN_PAD             : in  std_logic_vector(0 to 1);         -- PAD generation request from TX_LL
                FC_NB               : in  std_logic_vector(0 to 7);         -- Size code for SUF and SNF messages
                TX_PE_DATA          : in  std_logic_vector(0 to 31);        -- Data from TX_LL to send over lane.
                TX_PE_DATA_V        : in  std_logic_vector(0 to 1);         -- Indicates TX_PE_DATA is Valid.
                GEN_CC              : in  std_logic;                        -- CC generation request from TX_LL.

        -- RX_LL Interface

                RX_PAD              : out std_logic_vector(0 to 1);         -- Indicates lane received PAD.
                RX_PE_DATA          : out std_logic_vector(0 to 31);        -- RX data from lane to RX_LL.
                RX_PE_DATA_V        : out std_logic_vector(0 to 1);         -- RX_PE_DATA is data, not control symbol.
                RX_SCP              : out std_logic_vector(0 to 1);         -- Indicates lane received SCP.
                RX_ECP              : out std_logic_vector(0 to 1);         -- Indicates lane received ECP
                RX_SNF              : out std_logic_vector(0 to 1);         -- Indicates lane received SNF
                RX_FC_NB            : out std_logic_vector(0 to 7);         -- Size code for SNF or SUF

        -- Global Logic Interface

                GEN_A               : in  std_logic;                        -- 'A character' generation request from Global Logic.
                GEN_K               : in  std_logic_vector(0 to 3);         -- 'K character' generation request from Global Logic.
                GEN_R               : in  std_logic_vector(0 to 3);         -- 'R character' generation request from Global Logic.
                GEN_V               : in  std_logic_vector(0 to 3);         -- Verification data generation request.
                LANE_UP             : out std_logic;                        -- Lane is ready for bonding and verification.
                SOFT_ERROR          : out std_logic_vector(0 to 1);         -- Soft error detected.
                HARD_ERROR          : out std_logic;                        -- Hard error detected.
                CHANNEL_BOND_LOAD   : out std_logic;                        -- Channel Bongding done code recieved.
                GOT_A               : out std_logic_vector(0 to 3);         -- Indicates lane recieved 'A character' bytes.
                GOT_V               : out std_logic;                        -- Verification symbols received.

        -- System Interface

                USER_CLK            : in  std_logic;                        -- System clock for all non-MGT Aurora Logic.
                RESET               : in  std_logic                         -- Reset the lane.

             );

    end component;


    component MGT_WRAPPER
        generic
        (
            SIMULATION_P      : integer := 0;        -- Set to 1 when using module in simulation
            TX_FD_MIN_P       : std_logic_vector(8 downto 0) := "001111101"; -- Floor (128*Ttxoutclk1/Tdclk) - 3
            TX_FD_EN_P        : std_logic := '1'; -- 1 = enable calblock TX frequency test
            RX_FD_MIN_P       : std_logic_vector(8 downto 0) := "001111101"; -- Floor (128*Trxrecclk1/Tdclk) - 3
            RX_FD_EN_P        : std_logic := '1'; -- 1 = enable calblock RX frequency test
            LANE0_GT11_MODE_P : string := "B";        -- Set based on locations chosen in Aurora Core Customization GUI  
            LANE0_MGT_ID_P    : integer := 1;          -- 0=A, 1=B
            LANE1_GT11_MODE_P : string := "A";        -- Set based on locations chosen in Aurora Core Customization GUI  
            LANE1_MGT_ID_P    : integer := 0;          -- 0=A, 1=B
    
            TX_FD_WIDTH_P     : integer := 9;       -- TX Fdetect MIN value width
            RX_FD_WIDTH_P     : integer := 9;       -- RX Fdetect MIN value width
            DCLK_PERIOD_NS_P  : integer := 20;      -- Integer period between 20ns and 40ns (50Mhz to 25Mhz). Default is 20 ns
            TXPOST_TAP_PD_P   : boolean := FALSE  -- Default is false, set to true for serial loopback or tuned preemphasis    
        );

        port 
        (

            --__________________________________________________________________________
            --__________________________________________________________________________
            --MGT0
    
            ----------------- 8B10B Receive Data Path and Control Ports ----------------
            MGT0_RXCHARISCOMMA_OUT                  :   out   std_logic_vector(3 downto 0);
            MGT0_RXCHARISK_OUT                      :   out   std_logic_vector(3 downto 0);
            MGT0_RXDATA_OUT                         :   out   std_logic_vector(31 downto 0);
            MGT0_RXDISPERR_OUT                      :   out   std_logic_vector(3 downto 0);
            MGT0_RXNOTINTABLE_OUT                   :   out   std_logic_vector(3 downto 0);
            MGT0_RXRUNDISP_OUT                      :   out   std_logic_vector(3 downto 0);
            ----------------- 8B10B Transmit Data Path and Control Ports ---------------
            MGT0_TXBYPASS8B10B_IN                   :   in    std_logic_vector(3 downto 0);
            MGT0_TXCHARDISPMODE_IN                  :   in    std_logic_vector(3 downto 0);
            MGT0_TXCHARDISPVAL_IN                   :   in    std_logic_vector(3 downto 0);
            MGT0_TXCHARISK_IN                       :   in    std_logic_vector(3 downto 0);
            MGT0_TXDATA_IN                          :   in    std_logic_vector(31 downto 0);
            MGT0_TXKERR_OUT                         :   out   std_logic_vector(3 downto 0);
            MGT0_TXRUNDISP_OUT                      :   out   std_logic_vector(3 downto 0);
            -------------------------- Calibration Block Ports -------------------------
            MGT0_ACTIVE_OUT                         :   out   std_logic;
            MGT0_DISABLE_IN                         :   in    std_logic;
            MGT0_DRP_RESET_IN                       :   in    std_logic;
            MGT0_RX_SIGNAL_DETECT_IN                :   in    std_logic;
            MGT0_TX_SIGNAL_DETECT_IN                :   in    std_logic;
            --------------------------- Channel Bonding Ports --------------------------
            MGT0_ENCHANSYNC_IN                      :   in    std_logic;
            --------------------- Dynamic Reconfiguration Port (DRP) -------------------
            MGT0_DCLK_IN                            :   in    std_logic;
            -------------------------------- Global Ports ------------------------------
            MGT0_POWERDOWN_IN                       :   in    std_logic;
            MGT0_TXINHIBIT_IN                       :   in    std_logic;
            ---------------------------------- PLL Lock --------------------------------
            MGT0_RXLOCK_OUT                         :   out   std_logic;
            MGT0_TXLOCK_OUT                         :   out   std_logic;
            --------------------------- Polarity Control Ports -------------------------
            MGT0_RXPOLARITY_IN                      :   in    std_logic;
            MGT0_TXPOLARITY_IN                      :   in    std_logic;
            ---------------------------- Ports for Simulation --------------------------
            MGT0_COMBUSIN_IN                        :   in    std_logic_vector(15 downto 0);
            MGT0_COMBUSOUT_OUT                      :   out   std_logic_vector(15 downto 0);
            ------------------------------ Reference Clocks ----------------------------
            MGT0_GREFCLK_IN                         :   in    std_logic;
            MGT0_REFCLK1_IN                         :   in    std_logic;
            MGT0_REFCLK2_IN                         :   in    std_logic;
            ----------------------------------- Resets ---------------------------------
            MGT0_RXPMARESET_IN                      :   in    std_logic;
            MGT0_RXRESET_IN                         :   in    std_logic;
            MGT0_TXPMARESET_IN                      :   in    std_logic;
            MGT0_TXRESET_IN                         :   in    std_logic;
            ------------------------------ Serdes Alignment ----------------------------
            MGT0_ENMCOMMAALIGN_IN                   :   in    std_logic;
            MGT0_ENPCOMMAALIGN_IN                   :   in    std_logic;
            MGT0_RXREALIGN_OUT                      :   out   std_logic;
            -------------------------------- Serial Ports ------------------------------
            MGT0_RX1N_IN                            :   in    std_logic;
            MGT0_RX1P_IN                            :   in    std_logic;
            MGT0_TX1N_OUT                           :   out   std_logic;
            MGT0_TX1P_OUT                           :   out   std_logic;
            ----------------------------------- Status ---------------------------------
            MGT0_RXBUFERR_OUT                       :   out   std_logic;
            MGT0_RXSTATUS_OUT                       :   out   std_logic_vector(5 downto 0);
            MGT0_TXBUFERR_OUT                       :   out   std_logic;
            -------------------------------- User Clocks -------------------------------
            MGT0_RXRECCLK1_OUT                      :   out   std_logic;
            MGT0_RXRECCLK2_OUT                      :   out   std_logic;
            MGT0_RXUSRCLK_IN                        :   in    std_logic;
            MGT0_RXUSRCLK2_IN                       :   in    std_logic;
            MGT0_TXOUTCLK1_OUT                      :   out   std_logic;
            MGT0_TXOUTCLK2_OUT                      :   out   std_logic;
            MGT0_TXUSRCLK_IN                        :   in    std_logic;
            MGT0_TXUSRCLK2_IN                       :   in    std_logic;

            --__________________________________________________________________________
            --__________________________________________________________________________
            --MGT1
    
            ----------------- 8B10B Receive Data Path and Control Ports ----------------
            MGT1_RXCHARISCOMMA_OUT                  :   out   std_logic_vector(3 downto 0);
            MGT1_RXCHARISK_OUT                      :   out   std_logic_vector(3 downto 0);
            MGT1_RXDATA_OUT                         :   out   std_logic_vector(31 downto 0);
            MGT1_RXDISPERR_OUT                      :   out   std_logic_vector(3 downto 0);
            MGT1_RXNOTINTABLE_OUT                   :   out   std_logic_vector(3 downto 0);
            MGT1_RXRUNDISP_OUT                      :   out   std_logic_vector(3 downto 0);
            ----------------- 8B10B Transmit Data Path and Control Ports ---------------
            MGT1_TXBYPASS8B10B_IN                   :   in    std_logic_vector(3 downto 0);
            MGT1_TXCHARDISPMODE_IN                  :   in    std_logic_vector(3 downto 0);
            MGT1_TXCHARDISPVAL_IN                   :   in    std_logic_vector(3 downto 0);
            MGT1_TXCHARISK_IN                       :   in    std_logic_vector(3 downto 0);
            MGT1_TXDATA_IN                          :   in    std_logic_vector(31 downto 0);
            MGT1_TXKERR_OUT                         :   out   std_logic_vector(3 downto 0);
            MGT1_TXRUNDISP_OUT                      :   out   std_logic_vector(3 downto 0);
            -------------------------- Calibration Block Ports -------------------------
            MGT1_ACTIVE_OUT                         :   out   std_logic;
            MGT1_DISABLE_IN                         :   in    std_logic;
            MGT1_DRP_RESET_IN                       :   in    std_logic;
            MGT1_RX_SIGNAL_DETECT_IN                :   in    std_logic;
            MGT1_TX_SIGNAL_DETECT_IN                :   in    std_logic;
            --------------------------- Channel Bonding Ports --------------------------
            MGT1_ENCHANSYNC_IN                      :   in    std_logic;
            --------------------- Dynamic Reconfiguration Port (DRP) -------------------
            MGT1_DCLK_IN                            :   in    std_logic;
            -------------------------------- Global Ports ------------------------------
            MGT1_POWERDOWN_IN                       :   in    std_logic;
            MGT1_TXINHIBIT_IN                       :   in    std_logic;
            ---------------------------------- PLL Lock --------------------------------
            MGT1_RXLOCK_OUT                         :   out   std_logic;
            MGT1_TXLOCK_OUT                         :   out   std_logic;
            --------------------------- Polarity Control Ports -------------------------
            MGT1_RXPOLARITY_IN                      :   in    std_logic;
            MGT1_TXPOLARITY_IN                      :   in    std_logic;
            ---------------------------- Ports for Simulation --------------------------
            MGT1_COMBUSIN_IN                        :   in    std_logic_vector(15 downto 0);
            MGT1_COMBUSOUT_OUT                      :   out   std_logic_vector(15 downto 0);
            ------------------------------ Reference Clocks ----------------------------
            MGT1_GREFCLK_IN                         :   in    std_logic;
            MGT1_REFCLK1_IN                         :   in    std_logic;
            MGT1_REFCLK2_IN                         :   in    std_logic;
            ----------------------------------- Resets ---------------------------------
            MGT1_RXPMARESET_IN                      :   in    std_logic;
            MGT1_RXRESET_IN                         :   in    std_logic;
            MGT1_TXPMARESET_IN                      :   in    std_logic;
            MGT1_TXRESET_IN                         :   in    std_logic;
            ------------------------------ Serdes Alignment ----------------------------
            MGT1_ENMCOMMAALIGN_IN                   :   in    std_logic;
            MGT1_ENPCOMMAALIGN_IN                   :   in    std_logic;
            MGT1_RXREALIGN_OUT                      :   out   std_logic;
            -------------------------------- Serial Ports ------------------------------
            MGT1_RX1N_IN                            :   in    std_logic;
            MGT1_RX1P_IN                            :   in    std_logic;
            MGT1_TX1N_OUT                           :   out   std_logic;
            MGT1_TX1P_OUT                           :   out   std_logic;
            ----------------------------------- Status ---------------------------------
            MGT1_RXBUFERR_OUT                       :   out   std_logic;
            MGT1_RXSTATUS_OUT                       :   out   std_logic_vector(5 downto 0);
            MGT1_TXBUFERR_OUT                       :   out   std_logic;
            -------------------------------- User Clocks -------------------------------
            MGT1_RXRECCLK1_OUT                      :   out   std_logic;
            MGT1_RXRECCLK2_OUT                      :   out   std_logic;
            MGT1_RXUSRCLK_IN                        :   in    std_logic;
            MGT1_RXUSRCLK2_IN                       :   in    std_logic;
            MGT1_TXOUTCLK1_OUT                      :   out   std_logic;
            MGT1_TXOUTCLK2_OUT                      :   out   std_logic;
            MGT1_TXUSRCLK_IN                        :   in    std_logic;
            MGT1_TXUSRCLK2_IN                       :   in    std_logic
        );

    end component;


    component BUFG

        port (
                O : out STD_ULOGIC;
                I : in STD_ULOGIC
             );

    end component;


    component GLOBAL_LOGIC
        generic (                    
                EXTEND_WATCHDOGS   : boolean := FALSE
        );
        port (

        -- MGT Interface

                CH_BOND_DONE       : in std_logic_vector(0 to 1);
                EN_CHAN_SYNC       : out std_logic;

        -- Aurora Lane Interface

                LANE_UP            : in std_logic_vector(0 to 1);
                SOFT_ERROR         : in std_logic_vector(0 to 3);
                HARD_ERROR         : in std_logic_vector(0 to 1);
                CHANNEL_BOND_LOAD  : in std_logic_vector(0 to 1);
                GOT_A              : in std_logic_vector(0 to 7);
                GOT_V              : in std_logic_vector(0 to 1);
                GEN_A              : out std_logic_vector(0 to 1);
                GEN_K              : out std_logic_vector(0 to 7);
                GEN_R              : out std_logic_vector(0 to 7);
                GEN_V              : out std_logic_vector(0 to 7);
                RESET_LANES        : out std_logic_vector(0 to 1);

        -- System Interface

                USER_CLK           : in std_logic;
                RESET              : in std_logic;
                POWER_DOWN         : in std_logic;
                CHANNEL_UP         : out std_logic;
                START_RX           : out std_logic;
                CHANNEL_SOFT_ERROR : out std_logic;
                CHANNEL_HARD_ERROR : out std_logic

             );

    end component;


    component TX_LL

        port (

        -- LocalLink PDU Interface

                TX_D           : in std_logic_vector(0 to 63);
                TX_REM         : in std_logic_vector(0 to 2);
                TX_SRC_RDY_N   : in std_logic;
                TX_SOF_N       : in std_logic;
                TX_EOF_N       : in std_logic;
                TX_DST_RDY_N   : out std_logic;

        -- NFC Interface

                NFC_REQ_N      : in std_logic;
                NFC_NB         : in std_logic_vector(0 to 3);
                NFC_ACK_N      : out std_logic;

        -- Clock Compensation Interface

                WARN_CC        : in std_logic;
                DO_CC          : in std_logic;

        -- Global Logic Interface

                CHANNEL_UP     : in std_logic;

        -- Aurora Lane Interface

                GEN_SCP        : out std_logic;
                GEN_ECP        : out std_logic;
                GEN_SNF        : out std_logic;
                FC_NB          : out std_logic_vector(0 to 3);
                TX_PE_DATA_V   : out std_logic_vector(0 to 3);
                GEN_PAD        : out std_logic_vector(0 to 3);
                TX_PE_DATA     : out std_logic_vector(0 to 63);
                GEN_CC         : out std_logic_vector(0 to 1);

        -- RX_LL Interface

                TX_WAIT        : in std_logic;
                DECREMENT_NFC  : out std_logic;

        -- System Interface

                USER_CLK       : in std_logic
             );

    end component;


    component RX_LL

        port (

        -- LocalLink PDU Interface
                RX_D             : out std_logic_vector(0 to 63);
                RX_REM           : out std_logic_vector(0 to 2);
                RX_SRC_RDY_N     : out std_logic;
                RX_SOF_N         : out std_logic;
                RX_EOF_N         : out std_logic;

        -- Global Logic Interface

                START_RX         : in std_logic;

        -- Aurora Lane Interface

                RX_PAD           : in std_logic_vector(0 to 3);
                RX_PE_DATA       : in std_logic_vector(0 to 63);
                RX_PE_DATA_V     : in std_logic_vector(0 to 3);
                RX_SCP           : in std_logic_vector(0 to 3);
                RX_ECP           : in std_logic_vector(0 to 3);
                RX_SNF           : in std_logic_vector(0 to 3);
                RX_FC_NB         : in std_logic_vector(0 to 15);

        -- TX_LL Interface

                DECREMENT_NFC    : in std_logic;
                TX_WAIT          : out std_logic;

        -- Error Interface

                FRAME_ERROR      : out std_logic;

        -- System Interface

                USER_CLK         : in std_logic

             );

    end component;

-- Wire Declarations --

   signal   ch_bond_done_i          :   std_logic_vector(1 downto 0);            
   signal   ch_bond_load_not_used_i :   std_logic_vector(0 to 1);            
   signal   channel_up_i            :   std_logic;         
   signal   chbondi_not_used_i      :   std_logic_vector(4 downto 0);         
   signal   chbondo_not_used_i      :   std_logic_vector(9 downto 0);          
   signal   combus_in_not_used_i    :   std_logic_vector(15 downto 0);            
   signal   combusout_out_not_used_i:   std_logic_vector(15 downto 0);            
   signal   decrement_nfc_i         :   std_logic;         
   signal   en_chan_sync_i          :   std_logic;         
   signal   ena_comma_align_i       :   std_logic_vector(1 downto 0);            
   signal   fc_nb_i                 :   std_logic_vector(0 to 3);         

   signal   fc_nb_striped_i         :   std_logic_vector(0 to 7);         
   signal   gen_a_i                 :   std_logic_vector(0 to 1);            
   signal   gen_cc_i                :   std_logic_vector(0 to 1);            
   signal   gen_ecp_i               :   std_logic;         
   signal   gen_ecp_striped_i       :   std_logic_vector(0 to 1);         
   signal   gen_k_i                 :   std_logic_vector(0 to 7);          
   signal   gen_pad_i               :   std_logic_vector(0 to 3);            
   signal   gen_pad_striped_i       :   std_logic_vector(0 to 3);          
   signal   gen_r_i                 :   std_logic_vector(0 to 7);          
   signal   gen_scp_i               :   std_logic;         
   signal   gen_scp_striped_i       :   std_logic_vector(0 to 1);         
   signal   gen_snf_i               :   std_logic;         
   signal   gen_snf_striped_i       :   std_logic_vector(0 to 1);         
   signal   gen_v_i                 :   std_logic_vector(0 to 7);          
   signal   got_a_i                 :   std_logic_vector(0 to 7);          
   signal   got_v_i                 :   std_logic_vector(0 to 1);            
   signal   hard_error_i            :   std_logic_vector(0 to 1);            
   signal   lane_up_i               :   std_logic_vector(0 to 1);            
   signal   master_chbondo_i        :   std_logic_vector(4 downto 0);         
   signal   open_rx_char_is_comma_i :   std_logic_vector(7 downto 0);          
   signal   open_rx_char_is_k_i     :   std_logic_vector(7 downto 0);          
   signal   open_rx_comma_det_i     :   std_logic_vector(1 downto 0);            
   signal   open_rx_data_i          :   std_logic_vector(63 downto 0);         
   signal   open_rx_disp_err_i      :   std_logic_vector(7 downto 0);          
   signal   open_rx_loss_of_sync_i  :   std_logic_vector(3 downto 0);          
   signal   open_rx_not_in_table_i  :   std_logic_vector(7 downto 0);          
   signal   open_rx_rec1_clk_i      :   std_logic_vector(1 downto 0);            
   signal   open_rx_rec2_clk_i      :   std_logic_vector(1 downto 0);            
   signal   open_rx_run_disp_i      :   std_logic_vector(15 downto 0);          
   signal   open_tx_k_err_i         :   std_logic_vector(15 downto 0);          
   signal   open_tx_run_disp_i      :   std_logic_vector(15 downto 0);          
   signal   pma_rx_lock_i           :   std_logic_vector(1 downto 0);            
   signal   raw_tx_out_clk_i        :   std_logic_vector(0 to 1);            
   signal   reset_lanes_i           :   std_logic_vector(0 to 1);            
   signal   rx_buf_err_i            :   std_logic_vector(1 downto 0);            
   signal   rx_char_is_comma_i      :   std_logic_vector(7 downto 0);          
   signal   rx_char_is_comma_mgt_i  :   std_logic_vector(15 downto 0);          
   signal   rx_char_is_k_i          :   std_logic_vector(7 downto 0);          
   signal   rx_char_is_k_mgt_i      :   std_logic_vector(15 downto 0);          
   signal   rx_data_i               :   std_logic_vector(63 downto 0);         
   signal   rx_data_mgt_i           :   std_logic_vector(127 downto 0);         
   signal   rx_data_width_i         :   std_logic_vector(1 downto 0);         
   signal   rx_disp_err_i           :   std_logic_vector(7 downto 0);          
   signal   rx_disp_err_mgt_i       :   std_logic_vector(15 downto 0);          
   signal   rx_ecp_i                :   std_logic_vector(0 to 3);            
   signal   rx_ecp_striped_i        :   std_logic_vector(0 to 3);          
   signal   rx_fc_nb_i              :   std_logic_vector(0 to 15);          
   signal   rx_fc_nb_striped_i      :   std_logic_vector(0 to 15);          
   signal   rx_int_data_width_i     :   std_logic_vector(1 downto 0);         
   signal   rx_not_in_table_i       :   std_logic_vector(7 downto 0);          
   signal   rx_not_in_table_mgt_i   :   std_logic_vector(15 downto 0);          
   signal   rx_pad_i                :   std_logic_vector(0 to 3);            
   signal   rx_pad_striped_i        :   std_logic_vector(0 to 3);          
   signal   rx_pe_data_i            :   std_logic_vector(0 to 63);         
   signal   rx_pe_data_striped_i    :   std_logic_vector(0 to 63);         
   signal   rx_pe_data_v_i          :   std_logic_vector(0 to 3);            
   signal   rx_pe_data_v_striped_i  :   std_logic_vector(0 to 3);          
   signal   rx_polarity_i           :   std_logic_vector(1 downto 0);            
   signal   rx_realign_i            :   std_logic_vector(1 downto 0);            
   signal   rx_reset_i              :   std_logic_vector(1 downto 0);            
   signal   rx_scp_i                :   std_logic_vector(0 to 3);            
   signal   rx_scp_striped_i        :   std_logic_vector(0 to 3);          
   signal   rx_snf_i                :   std_logic_vector(0 to 3);            
   signal   rx_snf_striped_i        :   std_logic_vector(0 to 3);          
   signal   rx_status_float_i       :   std_logic_vector(9 downto 0);            
   signal   rxmclk_out_not_used_i   :   std_logic_vector(0 to 1);            
   signal   rxpcshclkout_not_used_i :   std_logic_vector(0 to 1);            
   signal   soft_error_i            :   std_logic_vector(0 to 3);            
   signal   start_rx_i              :   std_logic;         
   signal   system_reset_c          :   std_logic;         
   signal   tied_to_ground_i        :   std_logic;         
   signal   tied_to_ground_vec_i    :   std_logic_vector(31 downto 0);            
   signal   tied_to_vcc_i           :   std_logic;         
   signal   tx_buf_err_i            :   std_logic_vector(1 downto 0);            
   signal   tx_char_is_k_i          :   std_logic_vector(7 downto 0);          
   signal   tx_char_is_k_mgt_i      :   std_logic_vector(15 downto 0);          
   signal   tx_data_i               :   std_logic_vector(63 downto 0);         
   signal   tx_data_mgt_i           :   std_logic_vector(127 downto 0);         
   signal   tx_data_width_i         :   std_logic_vector(1 downto 0);         
   signal   tx_int_data_width_i     :   std_logic_vector(1 downto 0);         
   signal   tx_lock_i               :   std_logic_vector(0 to 1);            
   signal   tx_out_clk_i            :   std_logic_vector(0 to 1);            
   signal   tx_pe_data_i            :   std_logic_vector(0 to 63);         
   signal   tx_pe_data_striped_i    :   std_logic_vector(0 to 63);         
   signal   tx_pe_data_v_i          :   std_logic_vector(0 to 3);            
   signal   tx_pe_data_v_striped_i  :   std_logic_vector(0 to 3);          
   signal   tx_reset_i              :   std_logic_vector(1 downto 0);            
   signal   tx_wait_i               :   std_logic;         
   signal   txoutclk2_out_not_used_i:   std_logic_vector(0 to 1);            
   signal   txpcshclkout_not_used_i :   std_logic_vector(0 to 1);            
   signal   ufc_tx_ms_i             :   std_logic_vector(0 to 3);         
    
    

begin
-- Main Body of Code --

    -- Tie off top level constants.

    tied_to_ground_vec_i <= (others => '0');
    tied_to_ground_i     <= '0';
    tied_to_vcc_i        <= '1';
    chbondi_not_used_i   <= (others => '0');

    -- Connect top level logic.

    CHANNEL_UP           <= channel_up_i;
    system_reset_c       <= RESET or DCM_NOT_LOCKED or not tx_lock_i(0);

    -- Set the data widths for all lanes.

    rx_data_width_i      <= "10";
    rx_int_data_width_i  <= "11";
    tx_data_width_i      <= "10";
    tx_int_data_width_i  <= "11";

    -- Connect the TXOUTCLK of lane 0 to TX_OUT_CLK.

    TX_OUT_CLK <= raw_tx_out_clk_i(0);

    -- Instantiate Lane 0 --

    LANE_UP(0) <= lane_up_i(0);

    -- Aurora lane striping rules require each 4-byte lane to carry 2 bytes
    -- from the first half of the overall word, and 2 bytes from the second
    -- half. This ensures that the data will be ordered correctly if it is
    -- sent to a 2-byte lane.  Here we perform the required concatenation.

    gen_scp_striped_i <= gen_scp_i & '0';
    gen_snf_striped_i <= gen_snf_i & '0';
    fc_nb_striped_i <= fc_nb_i & "0000";
    gen_pad_striped_i(0 to 1) <= gen_pad_i(0) & gen_pad_i(2);
    tx_pe_data_striped_i(0 to 31) <= tx_pe_data_i(0 to 15) & tx_pe_data_i(32 to 47);
    tx_pe_data_v_striped_i(0 to 1) <= tx_pe_data_v_i(0) & tx_pe_data_v_i(2);
    rx_pad_i(0) <= rx_pad_striped_i(0);
    rx_pad_i(2) <= rx_pad_striped_i(1);
    rx_pe_data_i(0 to 15) <= rx_pe_data_striped_i(0 to 15);
    rx_pe_data_i(32 to 47) <= rx_pe_data_striped_i(16 to 31);
    rx_pe_data_v_i(0) <= rx_pe_data_v_striped_i(0);
    rx_pe_data_v_i(2) <= rx_pe_data_v_striped_i(1);
    rx_scp_i(0) <= rx_scp_striped_i(0);
    rx_scp_i(2) <= rx_scp_striped_i(1);
    rx_ecp_i(0) <= rx_ecp_striped_i(0);
    rx_ecp_i(2) <= rx_ecp_striped_i(1);
    rx_snf_i(0) <= rx_snf_striped_i(0);
    rx_snf_i(2) <= rx_snf_striped_i(1);
    rx_fc_nb_i(0 to 3) <= rx_fc_nb_striped_i(0 to 3);
    rx_fc_nb_i(8 to 11) <= rx_fc_nb_striped_i(4 to 7);


    aurora_lane_4byte_0_i : AURORA_LANE_4BYTE
        generic map (                    
                EXTEND_WATCHDOGS        => EXTEND_WATCHDOGS
        )
        port map (

        -- MGT Interface

                    RX_DATA             => rx_data_i(31 downto 0),
                    RX_NOT_IN_TABLE     => rx_not_in_table_i(3 downto 0),
                    RX_DISP_ERR         => rx_disp_err_i(3 downto 0),
                    RX_CHAR_IS_K        => rx_char_is_k_i(3 downto 0),
                    RX_CHAR_IS_COMMA    => rx_char_is_comma_i(3 downto 0),
                    RX_STATUS           => tied_to_ground_vec_i(5 downto 0),
                    TX_BUF_ERR          => tx_buf_err_i(0),
                    RX_BUF_ERR          => rx_buf_err_i(0),
                    RX_REALIGN          => rx_realign_i(0),
                    PMA_RX_LOCK         => pma_rx_lock_i(0),
                    RX_POLARITY         => rx_polarity_i(0),
                    RX_RESET            => rx_reset_i(0),
                    TX_CHAR_IS_K        => tx_char_is_k_i(3 downto 0),
                    TX_DATA             => tx_data_i(31 downto 0),
                    TX_RESET            => tx_reset_i(0),

        -- Comma Detect Phase Align Interface

                    ENA_COMMA_ALIGN     => ena_comma_align_i(0),

        -- TX_LL Interface
                    GEN_SCP             => gen_scp_striped_i,
                    GEN_SNF             => gen_snf_striped_i,
                    FC_NB               => fc_nb_striped_i,
                    GEN_ECP             => tied_to_ground_vec_i(1 downto 0),
                    GEN_PAD             => gen_pad_striped_i(0 to 1),
                    TX_PE_DATA          => tx_pe_data_striped_i(0 to 31),
                    TX_PE_DATA_V        => tx_pe_data_v_striped_i(0 to 1),
                    GEN_CC              => gen_cc_i(0),

        -- RX_LL Interface

                    RX_PAD              => rx_pad_striped_i(0 to 1),
                    RX_PE_DATA          => rx_pe_data_striped_i(0 to 31),
                    RX_PE_DATA_V        => rx_pe_data_v_striped_i(0 to 1),
                    RX_SCP              => rx_scp_striped_i(0 to 1),
                    RX_ECP              => rx_ecp_striped_i(0 to 1),
                    RX_SNF              => rx_snf_striped_i(0 to 1),
                    RX_FC_NB            => rx_fc_nb_striped_i(0 to 7),

        -- Global Logic Interface

                    GEN_A               => gen_a_i(0),
                    GEN_K               => gen_k_i(0 to 3),
                    GEN_R               => gen_r_i(0 to 3),
                    GEN_V               => gen_v_i(0 to 3),
                    LANE_UP             => lane_up_i(0),
                    SOFT_ERROR          => soft_error_i(0 to 1),
                    HARD_ERROR          => hard_error_i(0),
                    CHANNEL_BOND_LOAD   => ch_bond_load_not_used_i(0),
                    GOT_A               => got_a_i(0 to 3),
                    GOT_V               => got_v_i(0),

        -- System Interface

                    USER_CLK            => USER_CLK,
                    RESET               => reset_lanes_i(0)

                 );


    -- Instantiate Lane 1 --

    LANE_UP(1) <= lane_up_i(1);

    -- Aurora lane striping rules require each 4-byte lane to carry 2 bytes
    -- from the first half of the overall word, and 2 bytes from the second
    -- half. This ensures that the data will be ordered correctly if it is
    -- sent to a 2-byte lane.  Here we perform the required concatenation.

    gen_ecp_striped_i <= '0' & gen_ecp_i;
    gen_pad_striped_i(2 to 3) <= gen_pad_i(1) & gen_pad_i(3);
    tx_pe_data_striped_i(32 to 63) <= tx_pe_data_i(16 to 31) & tx_pe_data_i(48 to 63);
    tx_pe_data_v_striped_i(2 to 3) <= tx_pe_data_v_i(1) & tx_pe_data_v_i(3);
    rx_pad_i(1) <= rx_pad_striped_i(2);
    rx_pad_i(3) <= rx_pad_striped_i(3);
    rx_pe_data_i(16 to 31) <= rx_pe_data_striped_i(32 to 47);
    rx_pe_data_i(48 to 63) <= rx_pe_data_striped_i(48 to 63);
    rx_pe_data_v_i(1) <= rx_pe_data_v_striped_i(2);
    rx_pe_data_v_i(3) <= rx_pe_data_v_striped_i(3);
    rx_scp_i(1) <= rx_scp_striped_i(2);
    rx_scp_i(3) <= rx_scp_striped_i(3);
    rx_ecp_i(1) <= rx_ecp_striped_i(2);
    rx_ecp_i(3) <= rx_ecp_striped_i(3);
    rx_snf_i(1) <= rx_snf_striped_i(2);
    rx_snf_i(3) <= rx_snf_striped_i(3);
    rx_fc_nb_i(4 to 7) <= rx_fc_nb_striped_i(8 to 11);
    rx_fc_nb_i(12 to 15) <= rx_fc_nb_striped_i(12 to 15);


    aurora_lane_4byte_1_i : AURORA_LANE_4BYTE
        generic map (                    
                EXTEND_WATCHDOGS        => EXTEND_WATCHDOGS
        )
        port map (

        -- MGT Interface

                    RX_DATA             => rx_data_i(63 downto 32),
                    RX_NOT_IN_TABLE     => rx_not_in_table_i(7 downto 4),
                    RX_DISP_ERR         => rx_disp_err_i(7 downto 4),
                    RX_CHAR_IS_K        => rx_char_is_k_i(7 downto 4),
                    RX_CHAR_IS_COMMA    => rx_char_is_comma_i(7 downto 4),
                    RX_STATUS           => tied_to_ground_vec_i(5 downto 0),
                    TX_BUF_ERR          => tx_buf_err_i(1),
                    RX_BUF_ERR          => rx_buf_err_i(1),
                    RX_REALIGN          => rx_realign_i(1),
                    PMA_RX_LOCK         => pma_rx_lock_i(1),
                    RX_POLARITY         => rx_polarity_i(1),
                    RX_RESET            => rx_reset_i(1),
                    TX_CHAR_IS_K        => tx_char_is_k_i(7 downto 4),
                    TX_DATA             => tx_data_i(63 downto 32),
                    TX_RESET            => tx_reset_i(1),

        -- Comma Detect Phase Align Interface

                    ENA_COMMA_ALIGN     => ena_comma_align_i(1),

        -- TX_LL Interface
                    GEN_SCP             => tied_to_ground_vec_i(1 downto 0),
                    GEN_SNF             => tied_to_ground_vec_i(1 downto 0),
                    FC_NB               => tied_to_ground_vec_i(7 downto 0),
                    GEN_ECP             => gen_ecp_striped_i,
                    GEN_PAD             => gen_pad_striped_i(2 to 3),
                    TX_PE_DATA          => tx_pe_data_striped_i(32 to 63),
                    TX_PE_DATA_V        => tx_pe_data_v_striped_i(2 to 3),
                    GEN_CC              => gen_cc_i(1),

        -- RX_LL Interface

                    RX_PAD              => rx_pad_striped_i(2 to 3),
                    RX_PE_DATA          => rx_pe_data_striped_i(32 to 63),
                    RX_PE_DATA_V        => rx_pe_data_v_striped_i(2 to 3),
                    RX_SCP              => rx_scp_striped_i(2 to 3),
                    RX_ECP              => rx_ecp_striped_i(2 to 3),
                    RX_SNF              => rx_snf_striped_i(2 to 3),
                    RX_FC_NB            => rx_fc_nb_striped_i(8 to 15),

        -- Global Logic Interface

                    GEN_A               => gen_a_i(1),
                    GEN_K               => gen_k_i(4 to 7),
                    GEN_R               => gen_r_i(4 to 7),
                    GEN_V               => gen_v_i(4 to 7),
                    LANE_UP             => lane_up_i(1),
                    SOFT_ERROR          => soft_error_i(2 to 3),
                    HARD_ERROR          => hard_error_i(1),
                    CHANNEL_BOND_LOAD   => ch_bond_load_not_used_i(1),
                    GOT_A               => got_a_i(4 to 7),
                    GOT_V               => got_v_i(1),

        -- System Interface

                    USER_CLK            => USER_CLK,
                    RESET               => reset_lanes_i(1)

                 );




    -- Instantiate MGT Wrapper --
    mgt_wrapper_i  :  MGT_WRAPPER
        generic map
        (
            SIMULATION_P                 =>      SIMULATION_P,
            LANE0_GT11_MODE_P            =>      LANE0_GT11_MODE_P,
            LANE0_MGT_ID_P               =>      LANE0_MGT_ID_P,
            LANE1_GT11_MODE_P            =>      LANE1_GT11_MODE_P,
            LANE1_MGT_ID_P               =>      LANE1_MGT_ID_P,
            TX_FD_MIN_P                  =>      TX_FD_MIN_P,
            RX_FD_MIN_P                  =>      RX_FD_MIN_P,
            DCLK_PERIOD_NS_P             =>      DCLK_PERIOD_NS_P,
            TXPOST_TAP_PD_P              =>      TXPOST_TAP_PD_P
        )
        port map
        (

            --________________________________________________________________________
            --________________________________________________________________________
            --MGT0  

            ----------------- 8B10B Receive Data Path and Control Ports ----------------
            MGT0_RXCHARISCOMMA_OUT       =>      rx_char_is_comma_i(3 downto 0),
            MGT0_RXCHARISK_OUT           =>      rx_char_is_k_i(3 downto 0),
            MGT0_RXDATA_OUT              =>      rx_data_i(31 downto 0),
            MGT0_RXDISPERR_OUT           =>      rx_disp_err_i(3 downto 0),
            MGT0_RXNOTINTABLE_OUT        =>      rx_not_in_table_i(3 downto 0),
            MGT0_RXRUNDISP_OUT           =>      open,                             --Unused
            ----------------- 8B10B Transmit Data Path and Control Ports ---------------
            MGT0_TXBYPASS8B10B_IN        =>      tied_to_ground_vec_i(3 downto 0),
            MGT0_TXCHARDISPMODE_IN       =>      tied_to_ground_vec_i(3 downto 0),
            MGT0_TXCHARDISPVAL_IN        =>      tied_to_ground_vec_i(3 downto 0),
            MGT0_TXCHARISK_IN            =>      tx_char_is_k_i(3 downto 0),
            MGT0_TXDATA_IN               =>      tx_data_i(31 downto 0),
            MGT0_TXKERR_OUT              =>      open,                             --Unused
            MGT0_TXRUNDISP_OUT           =>      open,                             --Unused
            -------------------------- Calibration Block Ports -------------------------
            MGT0_ACTIVE_OUT              =>      CALBLOCK_ACTIVE(0),
            MGT0_DISABLE_IN              =>      DISABLE_CALBLOCK(0),
            MGT0_DRP_RESET_IN            =>      RESET_CALBLOCKS,
            MGT0_RX_SIGNAL_DETECT_IN     =>      RX_SIGNAL_DETECT(0),
            MGT0_TX_SIGNAL_DETECT_IN     =>      tied_to_vcc_i,
            --------------------------- Channel Bonding Ports --------------------------
            MGT0_ENCHANSYNC_IN           =>      en_chan_sync_i,                             
            --------------------- Dynamic Reconfiguration Port (DRP -------------------
            MGT0_DCLK_IN                 =>      DCLK,
            -------------------------------- Global Ports ------------------------------
            MGT0_POWERDOWN_IN            =>      POWER_DOWN,
            MGT0_TXINHIBIT_IN            =>      tied_to_ground_i,
            ---------------------------------- PLL Lock --------------------------------
            MGT0_RXLOCK_OUT              =>      pma_rx_lock_i(0),
            MGT0_TXLOCK_OUT              =>      tx_lock_i(0),
            --------------------------- Polarity Control Ports -------------------------
            MGT0_RXPOLARITY_IN           =>      rx_polarity_i(0),
            MGT0_TXPOLARITY_IN           =>      tied_to_ground_i,
            ---------------------------- Ports for Simulation --------------------------
            MGT0_COMBUSIN_IN             =>      MGT0_COMBUSIN,
            MGT0_COMBUSOUT_OUT           =>      MGT0_COMBUSOUT,
            ------------------------------ Reference Clocks ----------------------------
            MGT0_GREFCLK_IN              =>      tied_to_ground_i,
            MGT0_REFCLK1_IN              =>      REF_CLK1_LEFT,
            MGT0_REFCLK2_IN              =>      tied_to_ground_i,
            ----------------------------------- Resets ---------------------------------
            MGT0_RXPMARESET_IN           =>      PMA_INIT,
            MGT0_RXRESET_IN              =>      rx_reset_i(0),
            MGT0_TXPMARESET_IN           =>      PMA_INIT,
            MGT0_TXRESET_IN              =>      tx_reset_i(0),
            ------------------------------ Serdes Alignment ----------------------------
            MGT0_ENMCOMMAALIGN_IN        =>      ena_comma_align_i(0),
            MGT0_ENPCOMMAALIGN_IN        =>      ena_comma_align_i(0),
            MGT0_RXREALIGN_OUT           =>      rx_realign_i(0),
            -------------------------------- Serial Ports ------------------------------
            MGT0_RX1N_IN                 =>      RXN(0),
            MGT0_RX1P_IN                 =>      RXP(0),
            MGT0_TX1N_OUT                =>      TXN(0),
            MGT0_TX1P_OUT                =>      TXP(0),
            ----------------------------------- Status ---------------------------------
            MGT0_RXBUFERR_OUT            =>      rx_buf_err_i(0),
            MGT0_RXSTATUS_OUT(5)         =>      ch_bond_done_i(0),
            MGT0_RXSTATUS_OUT(4 downto 0)=>      rx_status_float_i(4 downto 0),    --Unused
            MGT0_TXBUFERR_OUT            =>      tx_buf_err_i(0),
            -------------------------------- User Clocks -------------------------------
            MGT0_RXRECCLK1_OUT           =>      open,                             --Unused
            MGT0_RXRECCLK2_OUT           =>      open,                             --Unused
            MGT0_RXUSRCLK_IN             =>      USER_CLK,
            MGT0_RXUSRCLK2_IN            =>      USER_CLK,
            MGT0_TXOUTCLK1_OUT           =>      raw_tx_out_clk_i(0),
            MGT0_TXOUTCLK2_OUT           =>      open,                             --Unused
            MGT0_TXUSRCLK_IN             =>      USER_CLK,
            MGT0_TXUSRCLK2_IN            =>      USER_CLK,

        
            --________________________________________________________________________
            --________________________________________________________________________
            --MGT1  

            ----------------- 8B10B Receive Data Path and Control Ports ----------------
            MGT1_RXCHARISCOMMA_OUT       =>      rx_char_is_comma_i(7 downto 4),
            MGT1_RXCHARISK_OUT           =>      rx_char_is_k_i(7 downto 4),
            MGT1_RXDATA_OUT              =>      rx_data_i(63 downto 32),
            MGT1_RXDISPERR_OUT           =>      rx_disp_err_i(7 downto 4),
            MGT1_RXNOTINTABLE_OUT        =>      rx_not_in_table_i(7 downto 4),
            MGT1_RXRUNDISP_OUT           =>      open,                             --Unused
            ----------------- 8B10B Transmit Data Path and Control Ports ---------------
            MGT1_TXBYPASS8B10B_IN        =>      tied_to_ground_vec_i(3 downto 0),
            MGT1_TXCHARDISPMODE_IN       =>      tied_to_ground_vec_i(3 downto 0),
            MGT1_TXCHARDISPVAL_IN        =>      tied_to_ground_vec_i(3 downto 0),
            MGT1_TXCHARISK_IN            =>      tx_char_is_k_i(7 downto 4),
            MGT1_TXDATA_IN               =>      tx_data_i(63 downto 32),
            MGT1_TXKERR_OUT              =>      open,                             --Unused
            MGT1_TXRUNDISP_OUT           =>      open,                             --Unused
            -------------------------- Calibration Block Ports -------------------------
            MGT1_ACTIVE_OUT              =>      CALBLOCK_ACTIVE(1),
            MGT1_DISABLE_IN              =>      DISABLE_CALBLOCK(1),
            MGT1_DRP_RESET_IN            =>      RESET_CALBLOCKS,
            MGT1_RX_SIGNAL_DETECT_IN     =>      RX_SIGNAL_DETECT(1),
            MGT1_TX_SIGNAL_DETECT_IN     =>      tied_to_vcc_i,
            --------------------------- Channel Bonding Ports --------------------------
            MGT1_ENCHANSYNC_IN           =>      tied_to_vcc_i,                             
            --------------------- Dynamic Reconfiguration Port (DRP -------------------
            MGT1_DCLK_IN                 =>      DCLK,
            -------------------------------- Global Ports ------------------------------
            MGT1_POWERDOWN_IN            =>      POWER_DOWN,
            MGT1_TXINHIBIT_IN            =>      tied_to_ground_i,
            ---------------------------------- PLL Lock --------------------------------
            MGT1_RXLOCK_OUT              =>      pma_rx_lock_i(1),
            MGT1_TXLOCK_OUT              =>      tx_lock_i(1),
            --------------------------- Polarity Control Ports -------------------------
            MGT1_RXPOLARITY_IN           =>      rx_polarity_i(1),
            MGT1_TXPOLARITY_IN           =>      tied_to_ground_i,
            ---------------------------- Ports for Simulation --------------------------
            MGT1_COMBUSIN_IN             =>      MGT1_COMBUSIN,
            MGT1_COMBUSOUT_OUT           =>      MGT1_COMBUSOUT,
            ------------------------------ Reference Clocks ----------------------------
            MGT1_GREFCLK_IN              =>      tied_to_ground_i,
            MGT1_REFCLK1_IN              =>      REF_CLK1_LEFT,
            MGT1_REFCLK2_IN              =>      tied_to_ground_i,
            ----------------------------------- Resets ---------------------------------
            MGT1_RXPMARESET_IN           =>      PMA_INIT,
            MGT1_RXRESET_IN              =>      rx_reset_i(1),
            MGT1_TXPMARESET_IN           =>      PMA_INIT,
            MGT1_TXRESET_IN              =>      tx_reset_i(1),
            ------------------------------ Serdes Alignment ----------------------------
            MGT1_ENMCOMMAALIGN_IN        =>      ena_comma_align_i(1),
            MGT1_ENPCOMMAALIGN_IN        =>      ena_comma_align_i(1),
            MGT1_RXREALIGN_OUT           =>      rx_realign_i(1),
            -------------------------------- Serial Ports ------------------------------
            MGT1_RX1N_IN                 =>      RXN(1),
            MGT1_RX1P_IN                 =>      RXP(1),
            MGT1_TX1N_OUT                =>      TXN(1),
            MGT1_TX1P_OUT                =>      TXP(1),
            ----------------------------------- Status ---------------------------------
            MGT1_RXBUFERR_OUT            =>      rx_buf_err_i(1),
            MGT1_RXSTATUS_OUT(5)         =>      ch_bond_done_i(1),
            MGT1_RXSTATUS_OUT(4 downto 0)=>      rx_status_float_i(9 downto 5),    --Unused
            MGT1_TXBUFERR_OUT            =>      tx_buf_err_i(1),
            -------------------------------- User Clocks -------------------------------
            MGT1_RXRECCLK1_OUT           =>      open,                             --Unused
            MGT1_RXRECCLK2_OUT           =>      open,                             --Unused
            MGT1_RXUSRCLK_IN             =>      USER_CLK,
            MGT1_RXUSRCLK2_IN            =>      USER_CLK,
            MGT1_TXOUTCLK1_OUT           =>      raw_tx_out_clk_i(1),
            MGT1_TXOUTCLK2_OUT           =>      open,                             --Unused
            MGT1_TXUSRCLK_IN             =>      USER_CLK,
            MGT1_TXUSRCLK2_IN            =>      USER_CLK

            

        );


    -- Instantiate Global Logic to combine Lanes into a Channel --

    global_logic_i : GLOBAL_LOGIC
        generic map (                    
                EXTEND_WATCHDOGS       => EXTEND_WATCHDOGS
        )
        port map (

        -- MGT Interface

                    CH_BOND_DONE            => ch_bond_done_i,
                    EN_CHAN_SYNC            => en_chan_sync_i,

        -- Aurora Lane Interface

                    LANE_UP                 => lane_up_i,
                    SOFT_ERROR              => soft_error_i,
                    HARD_ERROR              => hard_error_i,
                    CHANNEL_BOND_LOAD       => ch_bond_done_i,
                    GOT_A                   => got_a_i,
                    GOT_V                   => got_v_i,
                    GEN_A                   => gen_a_i,
                    GEN_K                   => gen_k_i,
                    GEN_R                   => gen_r_i,
                    GEN_V                   => gen_v_i,
                    RESET_LANES             => reset_lanes_i,

        -- System Interface

                    USER_CLK                => USER_CLK,
                    RESET                   => system_reset_c,
                    POWER_DOWN              => POWER_DOWN,
                    CHANNEL_UP              => channel_up_i,
                    START_RX                => start_rx_i,
                    CHANNEL_SOFT_ERROR      => SOFT_ERROR,
                    CHANNEL_HARD_ERROR      => HARD_ERROR

                 );


    -- Instantiate TX_LL --

    tx_ll_i : TX_LL

        port map (

        -- LocalLink PDU Interface

                    TX_D                    => TX_D,
                    TX_REM                  => TX_REM,
                    TX_SRC_RDY_N            => TX_SRC_RDY_N,
                    TX_SOF_N                => TX_SOF_N,
                    TX_EOF_N                => TX_EOF_N,
                    TX_DST_RDY_N            => TX_DST_RDY_N,

        -- NFC Interface

                    NFC_REQ_N               => NFC_REQ_N,
                    NFC_NB                  => NFC_NB,
                    NFC_ACK_N               => NFC_ACK_N,

        -- Clock Compenstaion Interface

                    WARN_CC                 => WARN_CC,
                    DO_CC                   => DO_CC,

        -- Global Logic Interface

                    CHANNEL_UP              => channel_up_i,

        -- Aurora Lane Interface

                    GEN_SCP                 => gen_scp_i,
                    GEN_ECP                 => gen_ecp_i,
                    GEN_SNF                 => gen_snf_i,
                    FC_NB                   => fc_nb_i,
                    TX_PE_DATA_V            => tx_pe_data_v_i,
                    GEN_PAD                 => gen_pad_i,
                    TX_PE_DATA              => tx_pe_data_i,
                    GEN_CC                  => gen_cc_i,

        -- RX_LL Interface

                    TX_WAIT                 => tx_wait_i,
                    DECREMENT_NFC           => decrement_nfc_i,

        -- System Interface

                    USER_CLK                => USER_CLK

                 );

    -- Instantiate RX_LL --

   rx_ll_i : RX_LL

        port map (

        -- LocalLink PDU Interface

                    RX_D                    => RX_D,
                    RX_REM                  => RX_REM,
                    RX_SRC_RDY_N            => RX_SRC_RDY_N,
                    RX_SOF_N                => RX_SOF_N,
                    RX_EOF_N                => RX_EOF_N,

        -- Global Logic Interface

                    START_RX                => start_rx_i,

        -- Aurora Lane Interface

                    RX_PAD                  => rx_pad_i,
                    RX_PE_DATA              => rx_pe_data_i,
                    RX_PE_DATA_V            => rx_pe_data_v_i,
                    RX_SCP                  => rx_scp_i,
                    RX_ECP                  => rx_ecp_i,
                    RX_SNF                  => rx_snf_i,
                    RX_FC_NB                => rx_fc_nb_i,
        -- TX_LL Interface
                    DECREMENT_NFC           => decrement_nfc_i,
                    TX_WAIT                 => tx_wait_i,

        -- Error Interface

                    FRAME_ERROR             => FRAME_ERROR,

        -- System Interface

                    USER_CLK                => USER_CLK

                 );

end MAPPED;
