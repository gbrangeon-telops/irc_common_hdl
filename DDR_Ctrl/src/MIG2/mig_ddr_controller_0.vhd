--*****************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you a
-- license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as-is" solely for use in developing programs and
-- solutions for Xilinx devices, with no obligation on the
-- part of Xilinx to provide support. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are
-- done at the user's sole risk and will be unsupported.
--
-- Copyright (c) 2005-2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part
-- of this text at all times.
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : 2.3
--  \   \        Application        : MIG
--  /   /        Filename           : mig_ddr_controller_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: This is the main control logic of the memory interface. All
--              commands are issued from here acoording to the burst, CAS
--              Latency and the user commands.
-- Revision History:
--   Rev 1.1 - Changes for V4 no edge straddle calibration scheme.
--             Added cal_first_loop input to issue a second pattern calibration
--             read if the first one does not result in a successful
--             calibration. Various other changes. JYO. 6/6/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_ddr_controller_0 is
  generic
    (
     COL_WIDTH : integer := COLUMN_ADDRESS;
     ROW_WIDTH : integer := ROW_ADDRESS
    );
  port(
    clk_0                : in  std_logic;
    rst                  : in  std_logic;
    -- FIFO  signals
    af_addr              : in  std_logic_vector(35 downto 0);
    af_empty             : in  std_logic;
    --  signals for the Dummy Reads
    comp_done            : in  std_logic;
    phy_dly_slct_done    : in  std_logic;
    cal_first_loop       : in  std_logic;
    ctrl_dummyread_start : out std_logic;
    -- FIFO read enable signals
    ctrl_af_rden         : out std_logic;
    ctrl_wdf_rden        : out std_logic;
    -- Rst and Enable signals for DQS logic
    ctrl_dqs_rst         : out std_logic;
    ctrl_dqs_en          : out std_logic;
    -- Read and Write Enable signals to the phy interface
    ctrl_wren            : out std_logic;
    ctrl_rden            : out std_logic;

    ctrl_ddr_address     : out std_logic_vector((ROW_ADDRESS - 1) downto 0);
    ctrl_ddr_ba          : out std_logic_vector((BANK_ADDRESS - 1) downto 0);
    ctrl_ddr_ras_l       : out std_logic;
    ctrl_ddr_cas_l       : out std_logic;
    ctrl_ddr_we_l        : out std_logic;
    ctrl_ddr_cs_l        : out std_logic_vector((CS_WIDTH - 1) downto 0);
    ctrl_ddr_cke         : out std_logic_vector((CKE_WIDTH - 1) downto 0);
    init_done            : out std_logic;
    burst_length_div2    : out std_logic_vector(2 downto 0);

    -- Debug Signals
    dbg_init_done        : out std_logic
    );

    attribute syn_maxfan : integer;
    attribute IOB        : string;
    attribute syn_maxfan of af_empty  : signal is 10;
    attribute IOB of ctrl_ddr_address : signal is "TRUE";
    attribute IOB of ctrl_ddr_ba      : signal is "TRUE";
    attribute IOB of ctrl_ddr_ras_l   : signal is "TRUE";
    attribute IOB of ctrl_ddr_cas_l   : signal is "TRUE";
    attribute IOB of ctrl_ddr_we_l    : signal is "TRUE";
    attribute IOB of ctrl_ddr_cs_l    : signal is "TRUE";
    attribute IOB of ctrl_ddr_cke     : signal is "TRUE";
end mig_ddr_controller_0;

architecture arch of mig_ddr_controller_0 is

  -- time to wait between consecutive commands in PHY_INIT - this is a
  -- generic number, and must be large enough to account for worst case
  -- timing parameter (tRFC - refresh-to-active) across all memory speed
  -- grades and operating frequencies.
  constant CNTNEXT : std_logic_vector(4 downto 0) := "11000";

  constant INIT_IDLE               : std_logic_vector(4 downto 0) := "00000";
  constant INIT_COUNT_200          : std_logic_vector(4 downto 0) := "00001";
  constant INIT_COUNT_200_WAIT     : std_logic_vector(4 downto 0) := "00010";
  constant INIT_PRECHARGE          : std_logic_vector(4 downto 0) := "00011";
  constant INIT_PRECHARGE_WAIT     : std_logic_vector(4 downto 0) := "00100";
  constant INIT_LOAD_MODE_REG_ST   : std_logic_vector(4 downto 0) := "00101";
  constant INIT_MODE_REGISTER_WAIT : std_logic_vector(4 downto 0) := "00110";
  constant INIT_AUTO_REFRESH       : std_logic_vector(4 downto 0) := "00111";
  constant INIT_AUTO_REFRESH_WAIT  : std_logic_vector(4 downto 0) := "01000";
  constant INIT_DEEP_MEMORY_ST     : std_logic_vector(4 downto 0) := "01001";
  constant INIT_DUMMY_ACTIVE       : std_logic_vector(4 downto 0) := "01010";
  constant INIT_DUMMY_ACTIVE_WAIT  : std_logic_vector(4 downto 0) := "01011";
  constant INIT_DUMMY_WRITE        : std_logic_vector(4 downto 0) := "01100";
  constant INIT_DUMMY_WRITE_READ   : std_logic_vector(4 downto 0) := "01101";
  constant INIT_DUMMY_FIRST_READ   : std_logic_vector(4 downto 0) := "01110";
  constant INIT_DUMMY_READ         : std_logic_vector(4 downto 0) := "01111";
  constant INIT_DUMMY_READ_WAIT    : std_logic_vector(4 downto 0) := "10000";
  constant INIT_PATTERN_WRITE1     : std_logic_vector(4 downto 0) := "10001";
  constant INIT_PATTERN_WRITE2     : std_logic_vector(4 downto 0) := "10010";
  constant INIT_PATTERN_WRITE_READ : std_logic_vector(4 downto 0) := "10011";
  constant INIT_PATTERN_READ1      : std_logic_vector(4 downto 0) := "10100";
  constant INIT_PATTERN_READ2      : std_logic_vector(4 downto 0) := "10101";
  constant INIT_PATTERN_READ_WAIT  : std_logic_vector(4 downto 0) := "10110";

  constant IDLE               : std_logic_vector(4 downto 0) := "00000";  --5'h00
  constant LOAD_MODE_REG_ST   : std_logic_vector(4 downto 0) := "00001";  --5'h01
  constant MODE_REGISTER_WAIT : std_logic_vector(4 downto 0) := "00010";  --5'h02
  constant PRECHARGE          : std_logic_vector(4 downto 0) := "00011";  --5'h03
  constant PRECHARGE_WAIT     : std_logic_vector(4 downto 0) := "00100";  --5'h04
  constant AUTO_REFRESH       : std_logic_vector(4 downto 0) := "00101";  --5'h05
  constant AUTO_REFRESH_WAIT  : std_logic_vector(4 downto 0) := "00110";  --5'h06
  constant ACTIVE             : std_logic_vector(4 downto 0) := "00111";  --5'h07
  constant ACTIVE_WAIT        : std_logic_vector(4 downto 0) := "01000";  --5'h08
  constant FIRST_WRITE        : std_logic_vector(4 downto 0) := "01001";  --5'h09
  constant BURST_WRITE        : std_logic_vector(4 downto 0) := "01010";  --5'h0A
  constant WRITE_WAIT         : std_logic_vector(4 downto 0) := "01011";  --5'h0B
  constant WRITE_READ         : std_logic_vector(4 downto 0) := "01100";  --5'h0C
  constant FIRST_READ         : std_logic_vector(4 downto 0) := "01101";  --5'h0D
  constant BURST_READ         : std_logic_vector(4 downto 0) := "01110";  --5'h0E
  constant READ_WAIT          : std_logic_vector(4 downto 0) := "01111";  --5'h0F
  constant READ_WRITE         : std_logic_vector(4 downto 0) := "10000";  --5'h10

  signal init_count              : std_logic_vector(3 downto 0);
  signal init_count_cp           : std_logic_vector(3 downto 0);
  signal init_memory             : std_logic;
  signal count_200_cycle         : std_logic_vector(7 downto 0);
  signal ref_flag                : std_logic;
  signal ref_flag_0            : std_logic;
  signal ref_flag_0_r          : std_logic;
  signal auto_ref                : std_logic;
  signal next_state              : std_logic_vector(4 downto 0);
  signal state                   : std_logic_vector(4 downto 0);
  signal state_r2                : std_logic_vector(4 downto 0);
  signal row_addr_r              : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ddr_address_init_r      : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ddr_address_r1          : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ddr_address_bl          : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ddr_ba_r1               : std_logic_vector((BANK_ADDRESS - 1) downto 0);
  signal mrd_count               : std_logic_vector(2 downto 0);
  signal rp_count                : std_logic_vector(2 downto 0);
  signal rfc_count               : std_logic_vector(5 downto 0);
  signal rcd_count               : std_logic_vector(2 downto 0);
  signal ras_count               : std_logic_vector(3 downto 0);
  signal wr_to_rd_count          : std_logic_vector(3 downto 0);
  signal rd_to_wr_count          : std_logic_vector(3 downto 0);
  signal rtp_count               : std_logic_vector(3 downto 0);
  signal wtp_count               : std_logic_vector(3 downto 0);
  signal refi_count            : std_logic_vector((MAX_REF_WIDTH - 1) downto 0);
  signal cas_count               : std_logic_vector(2 downto 0);
  signal cas_check_count         : std_logic_vector(3 downto 0);
  signal wrburst_cnt             : std_logic_vector(2 downto 0);
  signal read_burst_cnt          : std_logic_vector(2 downto 0);
  signal ctrl_wren_cnt           : std_logic_vector(2 downto 0);
  signal rdburst_cnt             : std_logic_vector(2 downto 0);
  signal af_addr_r               : std_logic_vector(35 downto 0);
  signal wdf_rden_r              : std_logic;
  signal wdf_rden_r2             : std_logic;
  signal wdf_rden_r3             : std_logic;
  signal wdf_rden_r4             : std_logic;
  signal af_rden                 : std_logic;
  signal ddr_ras_r2              : std_logic;
  signal ddr_cas_r2              : std_logic;
  signal ddr_we_r2               : std_logic;
  signal ddr_ras_r               : std_logic;
  signal ddr_cas_r               : std_logic;
  signal ddr_we_r                : std_logic;
  signal ddr_ras_r3              : std_logic;
  signal ddr_cas_r3              : std_logic;
  signal ddr_we_r3               : std_logic;
  signal idle_cnt                : std_logic_vector(3 downto 0);
  signal ctrl_dummyread_start_r1 : std_logic;
  signal ctrl_dummyread_start_r2 : std_logic;
  signal ctrl_dummyread_start_r3 : std_logic;
  signal ctrl_dummyread_start_r4 : std_logic;
  signal conflict_resolved_r     : std_logic;
  signal ddr_cs_r                : std_logic_vector(cs_width-1 downto 0);
  signal ddr_cs_r1               : std_logic_vector(cs_width-1 downto 0);
  signal ddr_cs_r_out            : std_logic_vector(cs_width-1 downto 0);
  signal ddr_cke_r               : std_logic_vector(cke_width-1 downto 0);
  signal chip_cnt                : std_logic_vector(1 downto 0);
  signal dummy_read_en           : std_logic;
  signal ctrl_init_done          : std_logic;
  signal count_200cycle_done_r   : std_logic;
  signal init_done_int           : std_logic;
  signal burst_cnt               : std_logic_vector(3 downto 0);
  signal burst_cnt_by2           : std_logic_vector(2 downto 0);
  signal conflict_detect         : std_logic;
  signal conflict_detect_r       : std_logic;
  signal load_mode_reg           : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ext_mode_reg            : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal cas_latency_value       : std_logic_vector(3 downto 0);
  signal burst_length_value      : std_logic_vector(2 downto 0);
  signal registered_dimm        : std_logic;
  signal wr                      : std_logic;
  signal rd                      : std_logic;
  signal lmr                     : std_logic;
  signal pre                     : std_logic;
  signal ref                     : std_logic;
  signal act                     : std_logic;
  signal wr_r                    : std_logic;
  signal rd_r                    : std_logic;
  signal lmr_r                   : std_logic;
  signal pre_r                   : std_logic;
  signal ref_r                   : std_logic;
  signal act_r                   : std_logic;
  signal af_empty_r              : std_logic;
  signal lmr_pre_ref_act_cmd_r   : std_logic;
  signal command_address         : std_logic_vector(2 downto 0);
  signal cke_200us_cnt           : std_logic_vector(4 downto 0);
  signal done_200us              : std_logic;
  signal write_state             : std_logic;
  signal read_state              : std_logic;
  signal read_write_state        : std_logic;
  signal burst_write_state       : std_logic;
  signal first_write_state       : std_logic;
  signal burst_read_state        : std_logic;
  signal first_read_state        : std_logic;
  signal burst_read_state_r2     : std_logic;
  signal burst_read_state_r3     : std_logic;
  signal first_read_state_r2     : std_logic;
  signal read_write_state_r2     : std_logic;
  signal dummy_write_state       : std_logic;
  signal dummy_write_state_1     : std_logic;
  signal dummy_write_state_r     : std_logic;
  signal pattern_read_state      : std_logic;
  signal pattern_read_state_1    : std_logic;
  signal pattern_read_state_r2   : std_logic;
  signal pattern_read_state_r3   : std_logic;
  signal pattern_read_state_1_r2 : std_logic;
  signal dummy_write_flag        : std_logic;
  signal rst_r                   : std_logic;
  signal ctrl_wdf_rden_r         : std_logic;
  signal ctrl_wdf_rden_r1        : std_logic;
  signal ctrl_dqs_rst_r          : std_logic;
  signal ctrl_dqs_rst_r1         : std_logic;
  signal ctrl_wren_r             : std_logic;
  signal ctrl_wren_r1            : std_logic;
  signal ctrl_rden_r             : std_logic;
  signal ctrl_rden_r1            : std_logic;
  signal ctrl_dqs_en_r           : std_logic;
  signal ctrl_dqs_en_r1          : std_logic;
  signal comp_done_r             : std_logic;
  signal ddr_address_r2          : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ddr_ba_r2              : std_logic_vector((BANK_ADDRESS - 1) downto 0);
  signal init_next_state         : std_logic_vector(4 downto 0);
  signal init_state              : std_logic_vector(4 downto 0);
  signal init_state_r2           : std_logic_vector(4 downto 0);
  signal count5                  : std_logic_vector(4 downto 0);
  signal cs_width0               : std_logic_vector(1 downto 0);
  signal cs_width1               : std_logic_vector(2 downto 0);
  signal auto_cnt                : std_logic_vector(2 downto 0);

   -- Precharge fix for deep memory
   signal pre_cnt                 : std_logic_vector(2 downto 0);

  signal ddr_addr_col            : std_logic_vector(ROW_ADDRESS-1 downto 0);


attribute syn_preserve : boolean;
attribute syn_preserve of arch : architecture is true;

begin

  --***************************************************************************

  --***************************************************************************
  -- Debug output ("dbg_*")
  -- NOTES:
  --  1. All debug outputs coming out of DDR_CONTROLLER are clocked off CLK0,
  --     although they are also static after calibration is complete. This
  --     means the user can either connect them to a Chipscope ILA, or to
  --     either a sync/async VIO input block. Using an async VIO has the
  --     advantage of not requiring these paths to meet cycle-to-cycle timing.
  -- SIGNAL DESCRIPTION:
  --  1. init_done: 1 bit - asserted if both per bit and pattern calibration
  --                are completed.
  --***************************************************************************

  dbg_init_done <= init_done_int;

  --***************************************************************************

 registered_dimm <= '1';



  --*****************************************************************
  -- Mode Register (MR):
  --   [15:14] - unused          - 00
  --   [13]    - reserved        - 0
  --   [12]    - Power-down mode - 0 (normal)
  --   [11:9]  - write recovery  - same value as written to CAS LAT
  --   [8]     - DLL reset       - 0 or 1
  --   [7]     - Test Mode       - 0 (normal)
  --   [6:4]   - CAS latency     - CAS_LAT
  --   [3]     - Burst Type      - BURST_TYPE
  --   [2:0]   - Burst Length    - BURST_LEN
  --*****************************************************************
  cas_latency_value <= "0010" when (load_mode_reg(6 downto 4) = "110") else
                       '0' & load_mode_reg(6 downto 4);
  burst_length_value <= load_mode_reg(2 downto 0);
  burst_length_div2  <= burst_cnt(2 downto 0);

  --***************************************************************************
  -- Write/read burst logic
  --***************************************************************************

  burst_read_state <= '1' when ((conflict_detect = '0') or (conflict_resolved_r = '1'))
                       and (state = BURST_READ) and (rd = '1') else '0';
  first_read_state <= '1' when ((conflict_detect = '0') or (conflict_resolved_r = '1'))
                       and (state = FIRST_READ) and (rd = '1') else '0';
  read_state        <= burst_read_state or first_read_state;
  read_write_state  <= write_state or read_state;
  burst_write_state <= '1' when ((conflict_detect = '0') or (conflict_resolved_r = '1'))
                       and (state = BURST_WRITE) and (wr = '1') else '0';
  first_write_state <= '1' when ((conflict_detect = '0') or (conflict_resolved_r = '1'))
                       and (state = FIRST_WRITE) and (wr = '1') else '0';
  write_state <= burst_write_state or first_write_state;

  dummy_write_state <= '1' when ((init_state = INIT_DUMMY_WRITE) or
                                     (init_state = INIT_PATTERN_WRITE1) or
                                     (init_state = INIT_PATTERN_WRITE2))
                           else '0';
  dummy_write_state_1 <= '1' when ((init_state = INIT_DUMMY_WRITE) or
                                     (init_state = INIT_PATTERN_WRITE1))
                            else '0';
  pattern_read_state <= '1' when ((init_state = INIT_PATTERN_READ1) or
                                     (init_state = INIT_PATTERN_READ2))
                           else '0';
  pattern_read_state_1 <= '1' when (init_state = INIT_PATTERN_READ1) else '0';

  -- fifo control signals

  ctrl_af_rden <= af_rden;

  conflict_detect <= af_addr(35) and ctrl_init_done and (not af_empty);
  cs_width1       <= (('0' & cs_width0) + "001");

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      rst_r <= rst;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        pattern_read_state_r2 <= '0';
        pattern_read_state_r3 <= '0';
      else
        pattern_read_state_r2 <= pattern_read_state;
        pattern_read_state_r3 <= pattern_read_state_r2;
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        pattern_read_state_1_r2 <= '0';
      else
        pattern_read_state_1_r2 <= pattern_read_state_1;
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        dummy_write_state_r <= '0';
      else
        dummy_write_state_r <= dummy_write_state;
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        comp_done_r <= '0';
      else
        comp_done_r <= comp_done;
      end if;
    end if;
  end process;

  -- commands

  command_address    <= af_addr(34 downto 32);

  process(command_address, ctrl_init_done, af_empty)
  begin
    wr  <= '0';
    rd  <= '0';
    lmr <= '0';
    pre <= '0';
    ref <= '0';
    act <= '0';
    if((ctrl_init_done = '1') and (af_empty = '0')) then
      case command_address is
        when "000"  => lmr <= '1';
        when "001"  => ref <= '1';
        when "010"  => pre <= '1';
        when "011"  => act <= '1';
        when "100"  => wr  <= '1';
        when "101"  => rd  <= '1';
        when others => null;
      end case;
    end if;
  end process;

-- register address outputs
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        wr_r                  <= '0';
        rd_r                  <= '0';
        lmr_r                 <= '0';
        pre_r                 <= '0';
        ref_r                 <= '0';
        act_r                 <= '0';
        af_empty_r            <= '0';
        lmr_pre_ref_act_cmd_r <= '0';
      else
        wr_r                  <= wr;
        rd_r                  <= rd;
        lmr_r                 <= lmr;
        pre_r                 <= pre;
        ref_r                 <= ref;
        act_r                 <= act;
        lmr_pre_ref_act_cmd_r <= lmr or pre or ref or act;
        af_empty_r            <= af_empty;
      end if;
    end if;
  end process;


-- register address outputs
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        af_addr_r           <= (others => '0');
        conflict_detect_r   <= '0';
        read_write_state_r2 <= '0';
        first_read_state_r2 <= '0';
        burst_read_state_r2 <= '0';
        burst_read_state_r3 <= '0';
      else
        af_addr_r           <= af_addr;
        conflict_detect_r   <= conflict_detect;
        read_write_state_r2 <= read_write_state;
        first_read_state_r2 <= first_read_state;
        burst_read_state_r2 <= burst_read_state;
        burst_read_state_r3 <= burst_read_state_r2;
      end if;
    end if;
  end process;


  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        load_mode_reg <= LOAD_MODE_REGISTER((ROW_ADDRESS - 1) downto 0);
      elsif((state = LOAD_MODE_REG_ST) and (lmr_r = '1') and
           (af_addr_r((BANK_ADDRESS+ROW_ADDRESS+COLUMN_ADDRESS-1)
                                       downto (COLUMN_ADDRESS+ROW_ADDRESS)) = "00")) then
        load_mode_reg <= af_addr ((ROW_ADDRESS - 1) downto 0);
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ext_mode_reg <= EXT_LOAD_MODE_REGISTER((ROW_ADDRESS - 1) downto 0);
      elsif((state = LOAD_MODE_REG_ST) and
            (lmr_r = '1') and (af_addr_r((BANK_ADDRESS+ROW_ADDRESS+COLUMN_ADDRESS-1)
                                       downto (COLUMN_ADDRESS+ROW_ADDRESS)) = "01")) then
        ext_mode_reg <= af_addr (ROW_ADDRESS - 1 downto 0);
      end if;
    end if;
  end process;

--to initialize memory
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if ((rst_r = '1') or (init_state = INIT_DEEP_MEMORY_ST)) then
        init_memory <= '1';
      elsif (init_count_cp = "1010") then
        init_memory <= '0';
      else
        init_memory <= init_memory;
      end if;
    end if;
  end process;

  --*****************************************************************
  -- Various delay counters
  --*****************************************************************

  -- mrd count
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        mrd_count <= "000";
      elsif (state = LOAD_MODE_REG_ST) then
        mrd_count <= MRD_COUNT_VALUE;
      elsif (mrd_count /= "000") then
        mrd_count <= "000";
      else
        mrd_count <= "000";
      end if;
    end if;
  end process;

  -- rp count
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        rp_count(2 downto 0) <= "000";
      elsif (state = PRECHARGE) then
        rp_count(2 downto 0) <= RP_COUNT_VALUE;
      elsif (rp_count(2 downto 0) /= "000") then
        rp_count(2 downto 0) <= rp_count(2 downto 0) - 1;
      else
        rp_count(2 downto 0) <= "000";
      end if;
    end if;
  end process;

  -- rfc count
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        rfc_count(5 downto 0) <= "000000";
      elsif (state = AUTO_REFRESH) then
        rfc_count(5 downto 0) <= RFC_COUNT_VALUE;
      elsif (rfc_count(5 downto 0) /= "000000") then
        rfc_count(5 downto 0) <= rfc_count(5 downto 0) - 1;
      else
        rfc_count(5 downto 0) <= "000000";
      end if;
    end if;
  end process;

  -- rcd count
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        rcd_count(2 downto 0) <= "000";
      elsif (state = ACTIVE) then
        rcd_count(2 downto 0) <= RCD_COUNT_VALUE;
      elsif (rcd_count(2 downto 0) /= "000") then
        rcd_count(2 downto 0) <= rcd_count(2 downto 0) - 1;
      else
        rcd_count(2 downto 0) <= "000";
      end if;
    end if;
  end process;

  -- ras count - active to precharge
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ras_count(3 downto 0) <= "0000";
      elsif (state = ACTIVE) then
        ras_count(3 downto 0) <= RAS_COUNT_VALUE;
      elsif (ras_count(3 downto 1) = "000") then
        if (ras_count(0) /= '0') then
          ras_count(0) <= '0';
        end if;
      else
        ras_count(3 downto 0) <= ras_count(3 downto 0) - 1;
      end if;
    end if;
  end process;

  --AL+BL/2+TRTP-2
  -- rtp count - read to precharge
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        rtp_count(3 downto 0) <= "0000";
      elsif (read_state = '1') then
        rtp_count(2 downto 0) <= TRTP_COUNT_VALUE;
      elsif (rtp_count(3 downto 1) = "000") then
        if (rtp_count(0) /= '0') then
          rtp_count(0) <= '0';
        end if;
      else
        rtp_count(3 downto 0) <= rtp_count(3 downto 0) - 1;
      end if;
    end if;
  end process;

  -- WL+BL/2+TWR
  -- wtp count - write to precharge
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        wtp_count(3 downto 0) <= "0000";
      elsif (write_state = '1') then
        wtp_count(2 downto 0) <= TWR_COUNT_VALUE;
      elsif (wtp_count(3 downto 1) = "000") then
        if (wtp_count(0) /= '0') then
          wtp_count(0) <= '0';
        end if;
      else
        wtp_count(3 downto 0) <= wtp_count(3 downto 0) - 1;
      end if;
    end if;
  end process;

  -- write to read counter
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        wr_to_rd_count(3 downto 0) <= "0000";
      elsif (write_state = '1') then
        wr_to_rd_count(2 downto 0) <= TWTR_COUNT_VALUE;
      elsif (wr_to_rd_count(3 downto 0) /= "0000") then
        wr_to_rd_count(3 downto 0) <= wr_to_rd_count(3 downto 0) - 1;
      else
        wr_to_rd_count(3 downto 0) <= "0000";
      end if;
    end if;
  end process;

  -- read to write counter
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        rd_to_wr_count(3 downto 0) <= "0000";
      elsif (read_state = '1') then
        rd_to_wr_count(3 downto 0) <= REGISTERED + burst_cnt + load_mode_reg(6)
                                      + load_mode_reg(4);
      elsif (rd_to_wr_count(3 downto 0) /= "0000") then
        rd_to_wr_count(3 downto 0) <= rd_to_wr_count(3 downto 0) - 1;
      else
        rd_to_wr_count(3 downto 0) <= "0000";
      end if;
    end if;
  end process;

  -- auto refresh interval counter in clk_0 domain
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        refi_count <= (others => '0');
      elsif (refi_count = MAX_REF_CNT) then
        refi_count <= (others => '0');
      else
        refi_count <= refi_count + 1;
      end if;
    end if;
  end process;

  ref_flag <= '1' when ((refi_count = MAX_REF_CNT) and (done_200us = '1')) else
              '0';

  --***************************************************************************
  -- Initial delay after power-on
  --***************************************************************************
  -- 200us counter for cke
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if (rst_r = '1') then
        cke_200us_cnt <= "11011";
      elsif (refi_count(MAX_REF_WIDTH - 1 downto 0) = MAX_REF_CNT) then
        cke_200us_cnt <= cke_200us_cnt - 1;
      else
        cke_200us_cnt <= cke_200us_cnt;
      end if;
    end if;
  end process;

  -- refresh detect
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ref_flag_0   <= '0';
        ref_flag_0_r <= '0';
        done_200us     <= '0';
      else
        ref_flag_0   <= ref_flag;
        ref_flag_0_r <= ref_flag_0;
        if (done_200us = '0' and (cke_200us_cnt = "00000")) then
          done_200us <= '1';
        end if;
      end if;
    end if;
  end process;

  -- refresh flag detect
  -- auto_ref high indicates auto_refresh requirement
  -- auto_ref is held high until auto refresh command is issued.
  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        auto_ref <= '0';
      elsif (ref_flag_0 = '1' and ref_flag_0_r = '0') then
        auto_ref <= '1';
      elsif ((state = AUTO_REFRESH) or (init_state = INIT_AUTO_REFRESH)) then
        auto_ref <= '0';
      else
        auto_ref <= auto_ref;
      end if;
    end if;
  end process;

  -- 200 clocks counter - count value : C8
  -- required for initialization
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        count_200_cycle(7 downto 0) <= "00000000";
      elsif (init_state = INIT_COUNT_200) then
        count_200_cycle(7 downto 0) <= "11001000";
      elsif (count_200_cycle(7 downto 0) /= "00000000") then
        count_200_cycle(7 downto 0) <= count_200_cycle(7 downto 0) - 1;
      else
        count_200_cycle(7 downto 0) <= "00000000";
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        count_200cycle_done_r <= '0';
      elsif ((init_memory = '1') and (count_200_cycle = "00000000")) then
        count_200cycle_done_r <= '1';
      else
        count_200cycle_done_r <= '0';
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        init_done_int <= '0';
      elsif ((PHY_MODE = '1') and (comp_done = '1') and (init_state_r2 = INIT_IDLE)) then
        init_done_int <= '1';
        --synthesis translate_off
        report "Calibration completed at time " & time'image(now);
        --synthesis translate_on
      else
        init_done_int <= init_done_int;
      end if;
    end if;
  end process;

  ctrl_init_done <= init_done_int;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      init_done <= init_done_int;
    end if;
  end process;

  burst_cnt <= "0010" when (burst_length_value = "010") else
               "0100" when (burst_length_value = "011") else
               "0001";

  burst_cnt_by2 <= "001" when (burst_length_value = "010") else
                   "010" when (burst_length_value = "011") else
                   "000";

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if ((rst_r = '1')or (init_state = INIT_DEEP_MEMORY_ST)) then
        init_count(3 downto 0) <= "0000";
      elsif (init_memory = '1') then
        if (init_state=INIT_LOAD_MODE_REG_ST or init_state=INIT_PRECHARGE or
            init_state = INIT_AUTO_REFRESH or init_state=INIT_DUMMY_ACTIVE
            or init_state=INIT_COUNT_200 or init_state=INIT_DEEP_MEMORY_ST) then
          init_count(3 downto 0) <= init_count(3 downto 0) + 1;
        elsif(init_count = "1010") then
          init_count(3 downto 0) <= "0000";
        else
          init_count(3 downto 0) <= init_count(3 downto 0);
        end if;
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if ((rst_r = '1')or (init_state = INIT_DEEP_MEMORY_ST)) then
        init_count_cp(3 downto 0) <= "0000";
      elsif (init_memory = '1') then
        if (init_state = INIT_LOAD_MODE_REG_ST or init_state = INIT_PRECHARGE or
            init_state = INIT_AUTO_REFRESH or
            init_state = INIT_DUMMY_ACTIVE or init_state=INIT_COUNT_200
            or init_state = INIT_DEEP_MEMORY_ST) then
          init_count_cp(3 downto 0) <= init_count_cp(3 downto 0) + 1;
        elsif(init_count_cp = "1010") then
          init_count_cp(3 downto 0) <= "0000";
        else
          init_count_cp(3 downto 0) <= init_count_cp(3 downto 0);
        end if;
      end if;
    end if;
  end process;

  --*****************************************************************
  -- handle deep memory configuration:
  --   During initialization: Repeat initialization sequence once for each
  --   chip select.
  --   Once initialization complete, assert only Last chip for calibration.
  --*****************************************************************

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        chip_cnt <= "00";
      elsif (init_state = INIT_DEEP_MEMORY_ST) then
        chip_cnt <= chip_cnt + "01";
      else
        chip_cnt <= chip_cnt;
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if (clk_0 = '1' and clk_0'event) then
      if (rst_r = '1' or state = PRECHARGE) then
        auto_cnt <= "000";
      elsif (state = AUTO_REFRESH and init_memory = '0') then
        auto_cnt <= auto_cnt + "001";
      else
        auto_cnt <= auto_cnt;
      end if;
    end if;
  end process;

  --  Precharge fix for deep memory
  process(clk_0)
  begin
    if (clk_0 = '1' and clk_0'event) then
      if (rst_r = '1' or state = AUTO_REFRESH) then
        pre_cnt <= "000";
      elsif (state = PRECHARGE and init_memory = '0' and
        (auto_ref = '1' or REF_r = '1')) then
        pre_cnt <= pre_cnt + "001";
      else
        pre_cnt <= pre_cnt;
      end if;
    end if;
  end process;

  -- write burst count
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        wrburst_cnt(2 downto 0) <= "000";
      elsif (write_state = '1' or dummy_write_state = '1') then
        wrburst_cnt(2 downto 0) <= burst_cnt(2 downto 0);
      elsif (wrburst_cnt(2 downto 0) /= "000") then
        wrburst_cnt(2 downto 0) <= wrburst_cnt(2 downto 0) - 1;
      else
        wrburst_cnt(2 downto 0) <= "000";
      end if;
    end if;
  end process;

  -- read burst count for state machine
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        read_burst_cnt(2 downto 0) <= "000";
      elsif (read_state = '1') then
        read_burst_cnt(2 downto 0) <= burst_cnt(2 downto 0);
      elsif (read_burst_cnt(2 downto 0) /= "000") then
        read_burst_cnt(2 downto 0) <= read_burst_cnt(2 downto 0) - 1;
      else
        read_burst_cnt(2 downto 0) <= "000";
      end if;
    end if;
  end process;

  -- count to generate write enable to the data path
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ctrl_wren_cnt(2 downto 0) <= "000";
      elsif ((wdf_rden_r = '1') or (dummy_write_state_r = '1')) then
        ctrl_wren_cnt(2 downto 0) <= burst_cnt(2 downto 0);
      elsif (ctrl_wren_cnt(2 downto 0) /= "000") then
        ctrl_wren_cnt(2 downto 0) <= ctrl_wren_cnt(2 downto 0) -1;
      else
        ctrl_wren_cnt(2 downto 0) <= "000";
      end if;
    end if;
  end process;

  -- write enable to data path
  process (ctrl_wren_cnt)
  begin
    if (ctrl_wren_cnt(2 downto 0) /= "000") then
      ctrl_wren_r <= '1';
    else
      ctrl_wren_r <= '0';
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ctrl_wren_r1 <= '0';
      else
        ctrl_wren_r1 <= ctrl_wren_r;
      end if;
    end if;
  end process;

  ctrl_wren <= ctrl_wren_r1 when (registered_dimm = '1') else
               ctrl_wren_r;

  -- DQS reset to data path
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ctrl_dqs_rst_r <= '0';
      elsif (first_write_state = '1' or dummy_write_state_1 = '1') then
        ctrl_dqs_rst_r <= '1';
      else
        ctrl_dqs_rst_r <= '0';
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ctrl_dqs_rst_r1 <= '0';
      else
        ctrl_dqs_rst_r1 <= ctrl_dqs_rst_r;
      end if;
    end if;
  end process;

  ctrl_dqs_rst <= ctrl_dqs_rst_r1 when (registered_dimm = '1') else
                  ctrl_dqs_rst_r;

  -- DQS enable to data path
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ctrl_dqs_en_r <= '0';
      elsif ((write_state = '1') or (wrburst_cnt /= "000") or
             (dummy_write_state = '1')) then
        ctrl_dqs_en_r <= '1';
      else
        ctrl_dqs_en_r <= '0';
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ctrl_dqs_en_r1 <= '0';
      else
        ctrl_dqs_en_r1 <= ctrl_dqs_en_r;
      end if;
    end if;
  end process;

  ctrl_dqs_en <= ctrl_dqs_en_r1 when (registered_dimm = '1') else
                 ctrl_dqs_en_r;

  -- cas count
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        cas_count(2 downto 0) <= "000";
      elsif ((init_state = INIT_DUMMY_FIRST_READ)) then
        cas_count(2 downto 0) <= cas_latency_value(2 downto 0) + REGISTERED;
      elsif (cas_count(2 downto 0) /= "000") then
        cas_count(2 downto 0) <= cas_count(2 downto 0) - 1;
      else
        cas_count(2 downto 0) <= "000";
      end if;
    end if;
  end process;

  -- dummy_read enable
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        dummy_read_en <= '0';
      elsif (init_state = INIT_DUMMY_READ) then
        dummy_read_en <= '1';
      elsif (phy_dly_slct_done = '1') then
        dummy_read_en <= '0';
      else
        dummy_read_en <= dummy_read_en;
      end if;
    end if;
  end process;

  -- ctrl_dummyread_start signal generation to the data path module
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then

        ctrl_dummyread_start_r1 <= '0';
      elsif ((dummy_read_en = '1') and (cas_count = "000")) then
        ctrl_dummyread_start_r1 <= '1';
      elsif (phy_dly_slct_done = '1') then
        ctrl_dummyread_start_r1 <= '0';
      else
        ctrl_dummyread_start_r1 <= ctrl_dummyread_start_r1;
      end if;
    end if;
  end process;

  -- register ctrl_dummyread_start signal
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ctrl_dummyread_start_r2 <= '0';
        ctrl_dummyread_start_r3 <= '0';
        ctrl_dummyread_start_r4 <= '0';
        ctrl_dummyread_start    <= '0';
      else
        ctrl_dummyread_start_r2 <= ctrl_dummyread_start_r1;
        ctrl_dummyread_start_r3 <= ctrl_dummyread_start_r2;
        ctrl_dummyread_start_r4 <= ctrl_dummyread_start_r3;
        ctrl_dummyread_start    <= ctrl_dummyread_start_r4;
      end if;
    end if;
  end process;

  -- read_wait/write_wait to idle count
  -- the state machine waits for 15 clock cycles in the write wait state for any
  -- wr/rd commands to be issued. If no commands are issued in 15 clock cycles,
  -- the statemachine enters the idle state and stays in the idle state
  -- until an auto refresh is required.

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        idle_cnt(3 downto 0) <= "0000";
      elsif (read_write_state = '1') then
        idle_cnt(3 downto 0) <= "1111";
      elsif (idle_cnt(3 downto 0) /= "0000") then
        idle_cnt(3 downto 0) <= idle_cnt(3 downto 0) - 1;
      else
        idle_cnt(3 downto 0) <= "0000";
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        cas_check_count(3 downto 0) <= "0000";
      elsif (first_read_state_r2 = '1' or pattern_read_state_1_r2 = '1') then
        cas_check_count(3 downto 0) <= (cas_latency_value - 1);
      elsif (cas_check_count(3 downto 0) /= "0000") then
        cas_check_count(3 downto 0) <= cas_check_count(3 downto 0) - 1;
      else
        cas_check_count(3 downto 0) <= "0000";
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if (rst_r = '1') then
        rdburst_cnt(2 downto 0) <= "000";
        ctrl_rden_r             <= '0';
      elsif ((cas_check_count = "0001") and (burst_read_state_r3 = '0')) then
        rdburst_cnt(2 downto 0) <= burst_cnt(2 downto 0);
        ctrl_rden_r             <= '1';
      elsif(burst_read_state_r3 = '1' or pattern_read_state_r3 = '1') then
        if(burst_cnt = "0100") then
          rdburst_cnt(2 downto 0) <= cas_latency_value(2 downto 0) +
                                     burst_cnt_by2;
        elsif (burst_cnt = "0010") then
          rdburst_cnt(2 downto 0) <= cas_latency_value(2 downto 0);
        else
          rdburst_cnt(2 downto 0) <= cas_latency_value(2 downto 0) -
                                     burst_cnt(2 downto 0);
        end if;
        if(burst_read_state_r3 = '1') then
          ctrl_rden_r <= '1';
        end if;
      elsif (rdburst_cnt(2 downto 0) /= "000") then
        rdburst_cnt(2 downto 0) <= rdburst_cnt(2 downto 0) - '1';
        if(rdburst_cnt = "001") then
          ctrl_rden_r <= '0';
        end if;
      else
        rdburst_cnt(2 downto 0) <= "000";
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if (rst_r = '1') then
        ctrl_rden_r1 <= '0';
      else
        ctrl_rden_r1 <= ctrl_rden_r;
      end if;
    end if;
  end process;

  ctrl_rden <= ctrl_rden_r1 when (registered_dimm = '1') else
               ctrl_rden_r;

  -- write address FIFO read enable signals

  af_rden <= '1' when ((read_write_state = '1') or
                       ((state = MODE_REGISTER_WAIT) and lmr_r = '1'
                        and (mrd_count = "000"))
                       or ((state = PRECHARGE)and pre_r = '1') or
                       ((state = AUTO_REFRESH) and ref_r = '1')
                       or ((state = ACTIVE)and act_r = '1')) else '0';

  -- write data fifo read enable
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if (rst_r = '1') then
        wdf_rden_r <= '0';
      elsif (write_state = '1' or dummy_write_state = '1') then
        wdf_rden_r <= '1';
      else
        wdf_rden_r <= '0';
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if (rst_r = '1') then
        wdf_rden_r2 <= '0';
        wdf_rden_r3 <= '0';
        wdf_rden_r4 <= '0';
      else
        wdf_rden_r2 <= wdf_rden_r;
        wdf_rden_r3 <= wdf_rden_r2;
        wdf_rden_r4 <= wdf_rden_r3;
      end if;
    end if;
  end process;

  -- Read enable to the data fifo

  process (burst_cnt, wdf_rden_r, wdf_rden_r2, wdf_rden_r3, wdf_rden_r4)
  begin
    if (burst_cnt = "0001") then
      ctrl_wdf_rden_r <= (wdf_rden_r);
    elsif (burst_cnt = "0010") then
      ctrl_wdf_rden_r <= (wdf_rden_r or wdf_rden_r2);
    elsif (burst_cnt = "0100") then
      ctrl_wdf_rden_r <= (wdf_rden_r or wdf_rden_r2 or wdf_rden_r3 or
                          wdf_rden_r4);
    else
      ctrl_wdf_rden_r <= '0';
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ctrl_wdf_rden_r1 <= '0';
      else
        ctrl_wdf_rden_r1 <= ctrl_wdf_rden_r;
      end if;
    end if;
  end process;

  ctrl_wdf_rden <= ctrl_wdf_rden_r1 when (registered_dimm = '1') else
                   ctrl_wdf_rden_r;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        dummy_write_flag <= '0';
      else
        dummy_write_flag <= phy_dly_slct_done and (not(comp_done));
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        state <= IDLE;
      else
        state <= next_state;
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        init_state <= INIT_IDLE;
      else
        init_state <= init_next_state;
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        count5 <= (others => '0');
      else
        case init_state is
          when INIT_PRECHARGE_WAIT | INIT_MODE_REGISTER_WAIT |
            INIT_AUTO_REFRESH_WAIT | INIT_DUMMY_WRITE_READ |
            INIT_PATTERN_WRITE_READ| INIT_PATTERN_READ_WAIT |
            INIT_DUMMY_READ_WAIT   | INIT_DUMMY_ACTIVE_WAIT =>
            count5 <= count5 + '1';

          when others =>
            count5 <= (others => '0');
        end case;
      end if;
    end if;
  end process;

  cs_width0 <= "00" when CS_WIDTH = 1 else
               "01" when CS_WIDTH = 2 else
               "10" when CS_WIDTH = 3 else
               "11" when CS_WIDTH = 4;

  --***************************************************************************
  -- Initialization state machine
  --***************************************************************************

  process (auto_ref, chip_cnt, count_200cycle_done_r, done_200us,
           init_count, init_memory, phy_dly_slct_done, init_state,
           burst_cnt, comp_done, dummy_write_flag, cs_width0, count5, comp_done_r, cal_first_loop)
  begin

    init_next_state <= init_state;
    case init_state is

      when INIT_IDLE =>
        if (init_memory = '1' and done_200us = '1') then
          case init_count is            -- synthesis parallel_case full_case
            when "0000" => init_next_state <= INIT_COUNT_200;
            when "0001" => init_next_state <= INIT_PRECHARGE;
            when "0010" => init_next_state <= INIT_LOAD_MODE_REG_ST;
            when "0011" => init_next_state <= INIT_LOAD_MODE_REG_ST;
            when "0100" => init_next_state <= INIT_COUNT_200;
            when "0101" => init_next_state <= INIT_PRECHARGE;
            when "0110" => init_next_state <= INIT_AUTO_REFRESH;
            when "0111" => init_next_state <= INIT_AUTO_REFRESH;
            when "1000" => init_next_state <= INIT_LOAD_MODE_REG_ST;
            when "1001" =>
              if((chip_cnt < cs_width0)) then
                init_next_state <= INIT_DEEP_MEMORY_ST;
              elsif ((Phy_Mode = '1' and count_200cycle_done_r = '1')) then
                init_next_state <= INIT_DUMMY_ACTIVE;
              else
                init_next_state <= INIT_IDLE;
              end if;
            when "1010" =>
              if (phy_Dly_Slct_Done = '1') then
                init_next_state <= INIT_IDLE;
              end if;
            when others => init_next_state <= INIT_IDLE;
          end case;  -- case(init_count )
        end if;

      when INIT_DEEP_MEMORY_ST => init_next_state <= INIT_IDLE;

      when INIT_COUNT_200 => init_next_state <= INIT_COUNT_200_WAIT;

      when INIT_COUNT_200_WAIT =>
        if (count_200cycle_done_r = '1') then
          init_next_state <= INIT_IDLE;
        else
          init_next_state <= INIT_COUNT_200_WAIT;
        end if;

      when INIT_DUMMY_ACTIVE => init_next_state <= INIT_DUMMY_ACTIVE_WAIT;

      when INIT_DUMMY_ACTIVE_WAIT =>
        if (count5 = CNTNEXT) then
            init_next_state <= INIT_DUMMY_WRITE;
        else
          init_next_state <= INIT_DUMMY_ACTIVE_WAIT;
        end if;

      when INIT_DUMMY_WRITE => init_next_state <= INIT_DUMMY_WRITE_READ;

      when INIT_DUMMY_WRITE_READ =>
        if (count5 = CNTNEXT) then
          init_next_state <= INIT_DUMMY_FIRST_READ;
        else
          init_next_state <= INIT_DUMMY_WRITE_READ;
        end if;

      when INIT_DUMMY_FIRST_READ =>
        init_next_state <= INIT_DUMMY_READ_WAIT;

      when INIT_DUMMY_READ_WAIT =>
        if (phy_dly_slct_done = '1') then
          if(count5 = CNTNEXT) then
              init_next_state <= INIT_PATTERN_WRITE1;
          else
            init_next_state <= INIT_DUMMY_READ_WAIT;
          end if;
        else
          init_next_state <= INIT_DUMMY_READ;
        end if;

      when INIT_DUMMY_READ =>
        if((burst_cnt = "0001") and (phy_dly_slct_done = '0')) then
          init_next_state <= INIT_DUMMY_READ;
        else
          init_next_state <= INIT_DUMMY_READ_WAIT;
        end if;

      when INIT_PATTERN_WRITE1 =>
        if (burst_cnt = "0001") then
          init_next_state <= INIT_PATTERN_WRITE2;
        else
          init_next_state <= INIT_PATTERN_WRITE_READ;
        end if;

      when INIT_PATTERN_WRITE2 =>
        init_next_state <= INIT_PATTERN_WRITE_READ;

      when INIT_PATTERN_WRITE_READ =>
        if (count5 = CNTNEXT) then
          init_next_state <= INIT_PATTERN_READ1;
        else
          init_next_state <= INIT_PATTERN_WRITE_READ;
        end if;

      when INIT_PATTERN_READ1 =>
        if (burst_cnt = "0001") then
          init_next_state <= INIT_PATTERN_READ2;
        else
          init_next_state <= INIT_PATTERN_READ_WAIT;
        end if;

      when INIT_PATTERN_READ2 =>
        init_next_state <= INIT_PATTERN_READ_WAIT;

      when INIT_PATTERN_READ_WAIT =>
        -- Precharge fix after pattern read
        if (comp_done_r = '1') then
          init_next_state <= INIT_PRECHARGE;
        -- Controller issues a second pattern calibration read
            -- if the first one does not result in a successful calibration
        elsif((not(cal_first_loop)) = '1') then
          init_next_state <= INIT_PATTERN_READ1;
        else
          init_next_state <= INIT_PATTERN_READ_WAIT;
        end if;

      when INIT_PRECHARGE => init_next_state <= INIT_PRECHARGE_WAIT;

      when INIT_PRECHARGE_WAIT =>
        if (count5 = CNTNEXT) then
          if (auto_ref = '1' and dummy_write_flag = '1') then
            init_next_state <= INIT_AUTO_REFRESH;
          else
            init_next_state <= INIT_IDLE;
          end if;
        else
          init_next_state <= INIT_PRECHARGE_WAIT;
        end if;

      when INIT_LOAD_MODE_REG_ST => init_next_state <= INIT_MODE_REGISTER_WAIT;

      when INIT_MODE_REGISTER_WAIT =>
        if (count5 = CNTNEXT) then
          init_next_state <= INIT_IDLE;
        else
          init_next_state <= INIT_MODE_REGISTER_WAIT;
        end if;

      when INIT_AUTO_REFRESH => init_next_state <= INIT_AUTO_REFRESH_WAIT;

      when INIT_AUTO_REFRESH_WAIT =>
        if ((count5 = CNTNEXT) and (phy_dly_slct_done = '1')) then
          init_next_state <= INIT_DUMMY_ACTIVE;
        elsif (count5 = CNTNEXT) then
          init_next_state <= INIT_IDLE;
        else
          init_next_state <= INIT_AUTO_REFRESH_WAIT;
        end if;

      when others => init_next_state <= INIT_IDLE;

    end case;
  end process;

  --***************************************************************************
  -- main control state machine
  --***************************************************************************

  process (act_r, lmr_pre_ref_act_cmd_r, lmr_r, rd
           , rd_r, ref_r, wr, wr_r, auto_ref, auto_cnt
           , conflict_detect, conflict_detect_r
           , conflict_resolved_r, idle_cnt, mrd_count, ras_count, rcd_count
           , rd_to_wr_count, read_burst_cnt, rfc_count, rp_count
           , rtp_count, state, wr_to_rd_count, wrburst_cnt
           , wtp_count, burst_cnt, cs_width1, init_done_int, af_empty_r)
  begin

    next_state <= state;

    case state is

      when IDLE =>
        if ((conflict_detect_r='1' or lmr_pre_ref_act_cmd_r='1' or auto_ref='1')
            and ras_count = "0000" and init_done_int = '1') then
          next_state <= PRECHARGE;
        elsif ((wr_r = '1' or rd_r = '1') and (ras_count = "0000")) then
          next_state <= ACTIVE;
        end if;

      when LOAD_MODE_REG_ST => next_state <= MODE_REGISTER_WAIT;

      when MODE_REGISTER_WAIT =>
        if (mrd_count = "000") then
          next_state <= IDLE;
        else
          next_state <= MODE_REGISTER_WAIT;
        end if;

      when PRECHARGE => next_state <= PRECHARGE_WAIT;

      when PRECHARGE_WAIT =>
        if (rp_count = "000") then
          if ((auto_ref or ref_r) = '1') then
            if ((pre_cnt < cs_width1) and init_memory = '0')then
              next_state <= PRECHARGE;
            else
              next_state <= AUTO_REFRESH;
            end if;
          elsif (lmr_r = '1') then
            next_state <= LOAD_MODE_REG_ST;
          elsif ((conflict_detect_r or act_r) = '1') then
            next_state <= ACTIVE;
          else
            next_state <= IDLE;
          end if;
        else
          next_state <= PRECHARGE_WAIT;
        end if;

      when AUTO_REFRESH => next_state <= AUTO_REFRESH_WAIT;

      when AUTO_REFRESH_WAIT =>
        if ((auto_cnt < cs_width1) and rfc_count = "000001" and
          init_memory = '0')then
          next_state <= AUTO_REFRESH;
        elsif ((rfc_count = "000001") and (conflict_detect_r = '1')) then
          next_state <= ACTIVE;
        elsif (rfc_count = "000001") then
          next_state <= IDLE;
        else
          next_state <= AUTO_REFRESH_WAIT;
        end if;

      when ACTIVE => next_state <= ACTIVE_WAIT;

      when ACTIVE_WAIT =>
        if (rcd_count = "000") then
          if(wr = '1') then
            next_state <= FIRST_WRITE;
          elsif (rd = '1') then
            next_state <= FIRST_READ;
          else
            next_state <= IDLE;
          end if;
        else
          next_state <= ACTIVE_WAIT;
        end if;

      when FIRST_WRITE =>
        if((((conflict_detect = '1') and (conflict_resolved_r = '0')) or
            (auto_ref = '1')) or rd = '1') then
          next_state <= WRITE_WAIT;
        elsif((burst_cnt = "0001") and (wr = '1')) then
          next_state <= BURST_WRITE;
        else
          next_state <= WRITE_WAIT;
        end if;

      when BURST_WRITE =>
        if((((conflict_detect = '1') and (conflict_resolved_r = '0')) or
            (auto_ref = '1')) or (rd = '1')) then
          next_state <= WRITE_WAIT;
        elsif((burst_cnt = "0001") and (wr = '1')) then
          next_state <= BURST_WRITE;
        else
          next_state <= WRITE_WAIT;
        end if;

      when WRITE_WAIT =>
        if (((conflict_detect = '1') and (conflict_resolved_r = '0')) or
            (auto_ref = '1')) then
          if ((wtp_count = "0000") and (ras_count = "0000")) then
            next_state <= PRECHARGE;
          else
            next_state <= WRITE_WAIT;
          end if;
        elsif (rd = '1') then
          next_state <= WRITE_READ;
        elsif ((wr = '1') and (wrburst_cnt = "010")) then
          next_state <= BURST_WRITE;
        elsif((wr = '1') and (wrburst_cnt = "000")) then
          next_state <= FIRST_WRITE;
        elsif (idle_cnt = "0000") then
          next_state <= PRECHARGE;
        else
          next_state <= WRITE_WAIT;
        end if;

      when WRITE_READ =>
        if (wr_to_rd_count = "0000") then
          next_state <= FIRST_READ;
        else
          next_state <= WRITE_READ;
        end if;

      when FIRST_READ =>
        if((((conflict_detect = '1') and (conflict_resolved_r = '0')) or
            (auto_ref = '1')) or (wr = '1')) then
          next_state <= READ_WAIT;
        elsif((burst_cnt = "0001") and (rd = '1')) then
          next_state <= BURST_READ;
        else
          next_state <= READ_WAIT;
        end if;

      when BURST_READ =>
        if((((conflict_detect = '1') and (conflict_resolved_r = '0'))or
            (auto_ref = '1')) or (wr = '1')) then
          next_state <= READ_WAIT;
        elsif((burst_cnt = "0001") and (rd = '1')) then
          next_state <= BURST_READ;
        else
          next_state <= READ_WAIT;
        end if;

      when READ_WAIT =>
        if (((conflict_detect = '1') and (conflict_resolved_r = '0')) or
            (auto_ref = '1')) then
          if(rtp_count = "0000" and ras_count = "0000") then
            next_state <= PRECHARGE;
          else
            next_state <= READ_WAIT;
          end if;
        elsif (wr = '1') then
          next_state <= READ_WRITE;
        elsif ((rd = '1') and (read_burst_cnt <= "010")) then
          if(af_empty_r = '1') then
            next_state <= FIRST_READ;
          else
            next_state <= BURST_READ;
          end if;
        elsif (idle_cnt = "0000") then
          next_state <= PRECHARGE;
        else
          next_state <= READ_WAIT;
        end if;

      when READ_WRITE =>
        if (rd_to_wr_count = "0000") then
          next_state <= FIRST_WRITE;
        else
          next_state <= READ_WRITE;
        end if;

      when others => next_state <= IDLE;

    end case;
  end process;

  -- register command outputs
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      state_r2 <= state;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      init_state_r2 <= init_state;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        conflict_resolved_r <= '0';
      else
        if (((state = PRECHARGE_WAIT) or (init_state = INIT_PRECHARGE_WAIT))
            and (conflict_detect_r = '1')) then
          conflict_resolved_r <= '1';
        elsif(af_rden = '1') then
          conflict_resolved_r <= '0';
        end if;
      end if;
    end if;
  end process;

  --***************************************************************************
  -- control signals to memory
  --***************************************************************************

  -- commands to the memory
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_ras_r <= '1';
      elsif ((state = LOAD_MODE_REG_ST) or (state = PRECHARGE) or (state = ACTIVE)
             or (state = AUTO_REFRESH) or (init_state = INIT_LOAD_MODE_REG_ST)
             or (init_state = INIT_PRECHARGE) or (init_state = INIT_AUTO_REFRESH)
             or (init_state = INIT_DUMMY_ACTIVE)) then
        ddr_ras_r <= '0';
      else ddr_ras_r <= '1';
      end if;
    end if;
  end process;

  -- commands to the memory
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_cas_r <= '1';
      elsif ((state = LOAD_MODE_REG_ST) or (init_state = INIT_LOAD_MODE_REG_ST)
             or (read_write_state = '1') or (init_state = INIT_DUMMY_FIRST_READ)
             or (dummy_write_state = '1') or (state = AUTO_REFRESH)
             or (init_state = INIT_AUTO_REFRESH) or (init_state = INIT_DUMMY_READ)
             or (pattern_read_state = '1')) then
        ddr_cas_r <= '0';
      elsif ((state = ACTIVE_WAIT) or (init_state = INIT_DUMMY_ACTIVE_WAIT)) then
        ddr_cas_r <= '1';
      else
        ddr_cas_r <= '1';
      end if;
    end if;
  end process;

  -- commands to the memory
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_we_r <= '1';
      elsif ((state = LOAD_MODE_REG_ST) or (state = PRECHARGE) or
             (init_state = INIT_LOAD_MODE_REG_ST) or
             (init_state = INIT_PRECHARGE) or (write_state = '1')
             or (dummy_write_state = '1')) then
        ddr_we_r <= '0';
      else ddr_we_r <= '1';
      end if;
    end if;
  end process;

  -- register commands to the memory
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_ras_r2 <= '1';
        ddr_cas_r2 <= '1';
        ddr_we_r2  <= '1';
      else
        ddr_ras_r2 <= ddr_ras_r;
        ddr_cas_r2 <= ddr_cas_r;
        ddr_we_r2  <= ddr_we_r;
      end if;
    end if;
  end process;

  -- register commands to the memory
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if (rst_r = '1') then
        ddr_ras_r3 <= '1';
        ddr_cas_r3 <= '1';
        ddr_we_r3  <= '1';
      else
        ddr_ras_r3 <= ddr_ras_r2;
        ddr_cas_r3 <= ddr_cas_r2;
        ddr_we_r3  <= ddr_we_r2;
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        row_addr_r(ROW_ADDRESS - 1 downto 0) <= (others => '0');
      else
        row_addr_r(ROW_ADDRESS - 1 downto 0) <= af_addr((ROW_ADDRESS + COLUMN_ADDRESS)
                                                      -1 downto COLUMN_ADDRESS);
      end if;
    end if;
  end process;

   -- chip enable generation logic
   process(clk_0)
   begin
      if (clk_0 = '1' and clk_0'event) then
         if (rst_r = '1') then
            ddr_cs_r((CS_WIDTH-1) downto 0) <= (others => '0');
         else
            if (af_addr_r((CHIP_ADDRESS + BANK_ADDRESS +ROW_ADDRESS + (COLUMN_ADDRESS-1)) downto
               (BANK_ADDRESS + ROW_ADDRESS + COLUMN_ADDRESS)) =  CS_H0((CHIP_ADDRESS - 1) downto 0)) then
               ddr_cs_r((CS_WIDTH-1) downto 0) <= CS_HE((CS_WIDTH-1) downto 0);
            elsif (af_addr_r((CHIP_ADDRESS + BANK_ADDRESS + ROW_ADDRESS + (COLUMN_ADDRESS-1)) downto
               (BANK_ADDRESS +ROW_ADDRESS + COLUMN_ADDRESS)) =  CS_H1((CHIP_ADDRESS - 1) downto 0)) then
               ddr_cs_r((CS_WIDTH-1) downto 0) <= CS_HD((CS_WIDTH-1) downto 0);
            elsif (af_addr_r((CHIP_ADDRESS + BANK_ADDRESS +ROW_ADDRESS + (COLUMN_ADDRESS-1)) downto
               (BANK_ADDRESS + ROW_ADDRESS + COLUMN_ADDRESS)) = CS_H2((CHIP_ADDRESS - 1) downto 0)) then
               ddr_cs_r((CS_WIDTH-1) downto 0) <= CS_HB((CS_WIDTH-1) downto 0);
            elsif (af_addr_r((CHIP_ADDRESS + BANK_ADDRESS +ROW_ADDRESS + (COLUMN_ADDRESS-1)) downto
               (BANK_ADDRESS + ROW_ADDRESS + COLUMN_ADDRESS)) = CS_H3((CHIP_ADDRESS - 1) downto 0)) then
               ddr_cs_r((CS_WIDTH-1) downto 0) <= CS_H7((CS_WIDTH-1) downto 0);
            else
               ddr_cs_r((CS_WIDTH-1) downto 0) <= CS_HF((CS_WIDTH-1) downto 0);
            end if;
         end if;
      end if;
   end process;

  --*****************************************************************
  -- memory address during init
  --*****************************************************************

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_address_init_r <= (others => '0');
      elsif (init_memory = '1') then
        if (init_state_r2 = INIT_PRECHARGE) then
          ddr_address_init_r <= ADD_CONST1((ROW_ADDRESS - 1) downto 0);
                                            --A10 = 1 for precharge all
        elsif ((init_state_r2=INIT_LOAD_MODE_REG_ST) and
               (init_count_cp="0011")) then
          ddr_address_init_r <= ext_mode_reg;  -- A0 = 0 for DLL enable
        elsif ((init_state_r2=INIT_LOAD_MODE_REG_ST) and
               (init_count_cp = "0100")) then
          ddr_address_init_r <= ADD_CONST2((ROW_ADDRESS - 1) downto 0) or
                                load_mode_reg;  -- A8 = 1 for DLL reset
        elsif ((init_state_r2 = INIT_LOAD_MODE_REG_ST) and
               (init_count_cp = "1001")) then
          ddr_address_init_r <= ADD_CONST5((ROW_ADDRESS - 1) downto 0) and
                                load_mode_reg; -- A8 = 0 to deactivate DLL reset
        else
          ddr_address_init_r <= ADD_CONST3((ROW_ADDRESS - 1) downto 0);
        end if;
      end if;
    end if;
  end process;

  -- turn off auto-precharge when issuing commands (A10 = 0)
  -- mapping the col add for linear addressing.
  gen_ddr_addr_col_0: if (COL_WIDTH = ROW_WIDTH-1) generate
    ddr_addr_col <= (af_addr_r(COL_WIDTH-1 downto 10) & '0' &
                     af_addr_r(9 downto 0));
  end generate;
  gen_ddr_addr_col_1: if ((COL_WIDTH > 10) and
                          not(COL_WIDTH = ROW_WIDTH-1)) generate
    ddr_addr_col(ROW_WIDTH-1 downto COL_WIDTH+1) <= (others => '0');
    ddr_addr_col(COL_WIDTH downto 0) <=
      (af_addr_r(COL_WIDTH-1 downto 10) & '0' & af_addr_r(9 downto 0));
  end generate;
  gen_ddr_addr_col_2: if (not((COL_WIDTH > 10) or
                              (COL_WIDTH = ROW_WIDTH-1))) generate
    ddr_addr_col(ROW_WIDTH-1 downto COL_WIDTH+1) <= (others => '0');
    ddr_addr_col(COL_WIDTH downto 0) <=
      ('0' & af_addr_r(COL_WIDTH-1 downto 0));
  end generate;

  ddr_address_bl <= ADD_CONST7((ROW_ADDRESS - 1) downto 0) when
                    (burst_length_value = "010") else
                    ADD_CONST8((ROW_ADDRESS - 1) downto 0) when
                    (burst_length_value = "011") else
                    ADD_CONST9((ROW_ADDRESS - 1) downto 0);

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_address_r1 <= (others => '0');
      elsif ((init_state_r2=INIT_DUMMY_WRITE) or
             (init_state_r2=INIT_PATTERN_WRITE1) or
             (init_state_r2=INIT_PATTERN_READ1)) then
        ddr_address_r1 <= (others => '0');
      elsif ((init_state_r2=INIT_PATTERN_WRITE2) or
             (init_state_r2 = INIT_PATTERN_READ2)) then
        ddr_address_r1 <= ddr_address_bl;
      elsif ((state_r2 = ACTIVE)) then
        ddr_address_r1 <= row_addr_r;
      elsif (read_write_state_r2 = '1') then
        ddr_address_r1 <= ddr_addr_col;
      elsif ((state_r2 = PRECHARGE) or (init_state_r2 = INIT_PRECHARGE)) then
          ddr_address_r1 <= ADD_CONST1((ROW_ADDRESS - 1) downto 0);  --X"0400";
      elsif ((state_r2=LOAD_MODE_REG_ST) or (init_state_r2=INIT_LOAD_MODE_REG_ST))then
        ddr_address_r1 <= af_addr_r(ROW_ADDRESS - 1 downto 0);
      else
        ddr_address_r1 <= ADD_CONST3((ROW_ADDRESS - 1) downto 0); --X"0000";
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_address_r2 <= (others => '0');
      elsif(init_memory = '1') then
        ddr_address_r2 <= ddr_address_init_r;
      else
        ddr_address_r2 <= ddr_address_r1;
      end if;
    end if;
  end process;

  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_ba_r1(BANK_ADDRESS - 1 downto 0) <= (others => '0');
      elsif (init_memory = '1' and (state_r2 = LOAD_MODE_REG_ST or
                                    init_state_r2 = INIT_LOAD_MODE_REG_ST)) then
        if (init_count_cp = "0011") then
          ddr_ba_r1(BANK_ADDRESS - 1 downto 0) <= "01";  --X"1";
        else
          ddr_ba_r1(BANK_ADDRESS - 1 downto 0) <= "00";  --X"0";
        end if;
      elsif ((state_r2 = ACTIVE) or (init_state_r2 = INIT_DUMMY_ACTIVE) or
             (state_r2=LOAD_MODE_REG_ST) or (init_state_r2=INIT_LOAD_MODE_REG_ST)
             or (((state_r2 = PRECHARGE) or (init_state_r2=INIT_PRECHARGE))
                 and pre_r = '1')) then
        ddr_ba_r1(BANK_ADDRESS - 1 downto 0) <= af_addr((BANK_ADDRESS+ROW_ADDRESS+
                                                       COLUMN_ADDRESS)-1 downto
                                                      (COLUMN_ADDRESS+ROW_ADDRESS));
      else ddr_ba_r1(BANK_ADDRESS - 1 downto 0) <= ddr_ba_r1(BANK_ADDRESS - 1 downto 0);
      end if;
    end if;
  end process;

  process(clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_ba_r2 <= (others => '0');
      else
        ddr_ba_r2 <= ddr_ba_r1;
      end if;
    end if;
  end process;

   process(clk_0)
   begin
      if (clk_0 = '1' and clk_0'event) then
         if (rst_r = '1') then
            ddr_cs_r1((CS_WIDTH-1) downto 0) <= (others => '1');
         elsif (init_memory = '1') then
            if (chip_cnt = "00") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HE((CS_WIDTH-1) downto 0);
            elsif (chip_cnt = "01") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HD((CS_WIDTH-1) downto 0);
            elsif (chip_cnt = "10") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HB((CS_WIDTH-1) downto 0);
            elsif (chip_cnt = "11") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_H7((CS_WIDTH-1) downto 0);
            else
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HF((CS_WIDTH-1) downto 0);
            end if;
            
            --  Precharge fix for deep memory
         elsif (state_r2 = PRECHARGE) then
            if (pre_cnt = "001") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HE((CS_WIDTH-1) downto 0);
            elsif (pre_cnt = "010") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HD((CS_WIDTH-1) downto 0);
            elsif (pre_cnt = "011") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HB((CS_WIDTH-1) downto 0);
            elsif (pre_cnt = "100") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_H7((CS_WIDTH-1) downto 0);
            elsif (pre_cnt = "000") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= ddr_cs_r1((CS_WIDTH-1) downto 0); --cs_hF
            else
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HF((CS_WIDTH-1) downto 0);
            end if;
            
         elsif (state_r2 = AUTO_REFRESH) then
            if (auto_cnt = "001") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HE((CS_WIDTH-1) downto 0);
            elsif (auto_cnt = "010") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HD((CS_WIDTH-1) downto 0);
            elsif (auto_cnt = "011") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HB((CS_WIDTH-1) downto 0);
            elsif (auto_cnt = "100") then
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_H7((CS_WIDTH-1) downto 0);
            else
               ddr_cs_r1((CS_WIDTH-1) downto 0) <= CS_HF((CS_WIDTH-1) downto 0);
            end if;
            
         elsif ((state_r2 = ACTIVE) or (init_state_r2 = INIT_DUMMY_ACTIVE) or
            (state_r2 = LOAD_MODE_REG_ST) or (state_r2 = PRECHARGE_WAIT) or
            (init_state_r2 = INIT_LOAD_MODE_REG_ST) or
            (init_state_r2 = INIT_PRECHARGE_WAIT))  then
            ddr_cs_r1((CS_WIDTH-1) downto 0) <= ddr_cs_r((CS_WIDTH-1) downto 0);
            
         else
            ddr_cs_r1((CS_WIDTH-1) downto 0) <= ddr_cs_r1((CS_WIDTH-1) downto 0);
         end if;
      end if;
   end process;
   
  process(clk_0)
  begin
    if (clk_0 = '1' and clk_0'event) then
      if (rst_r = '1') then
        ddr_cs_r_out <= (others => '1');
      else
        ddr_cs_r_out <= ddr_cs_r1;
      end if;
    end if;
  end process;
   
  process (clk_0)
  begin
    if(clk_0'event and clk_0 = '1') then
      if(rst_r = '1') then
        ddr_cke_r <= cs_h0(cke_width-1 downto 0);
      else
        if(done_200us = '1') then
          ddr_cke_r <= cs_hF(cke_width-1 downto 0);
        end if;
      end if;
    end if;
  end process;


  ctrl_ddr_address(ROW_ADDRESS - 1 downto 0) <= ddr_address_r2(ROW_ADDRESS - 1 downto 0);
  ctrl_ddr_ba (BANK_ADDRESS - 1 downto 0)    <= ddr_ba_r2(BANK_ADDRESS - 1 downto 0);
  ctrl_ddr_ras_l                           <= ddr_ras_r3;
  ctrl_ddr_cas_l                           <= ddr_cas_r3;
  ctrl_ddr_we_l                            <= ddr_we_r3;
  ctrl_ddr_cs_l                            <= ddr_cs_r_out;

  ctrl_ddr_cke <= ddr_cke_r;

end arch;
