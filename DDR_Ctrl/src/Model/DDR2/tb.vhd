---------------------------------------------------------------------------------------------------
--
-- Title       : ddr_tb
-- Design      : ddr_tb
-- Author      : Jean-Philippe Déry
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : Testbench for MIG memory controller
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_timing.ALL;
USE IEEE.VITAL_primitives.ALL;
USE STD.textio.ALL;
LIBRARY FMF;
USE FMF.gen_utils.ALL;
USE FMF.conversions.ALL;
library work;
use work.all;

entity tb is
end tb;

architecture functional of tb is

  component mem_interfacetopDDR2dclock200CL4
  port (
    cntrl0_DDR2_DQ                       : inout  std_logic_vector(71 downto 0);
    cntrl0_DDR2_A                        : out  std_logic_vector(13 downto 0);
    cntrl0_DDR2_BA                       : out  std_logic_vector(2 downto 0);
    cntrl0_DDR2_RAS_N                    : out std_logic;
    cntrl0_DDR2_CAS_N                    : out std_logic;
    cntrl0_DDR2_WE_N                     : out std_logic;
    cntrl0_DDR2_CS_N                     : out  std_logic_vector(0 downto 0);
    cntrl0_DDR2_ODT                      : out  std_logic_vector(0 downto 0);
    cntrl0_DDR2_CKE                      : out  std_logic_vector(0 downto 0);
    cntrl0_DDR2_RESET_N                  : out std_logic;
    SYS_RESET_IN_N                       : in std_logic;
    cntrl0_INIT_DONE                     : out std_logic;
    cntrl0_CLK_TB                        : out std_logic;
    cntrl0_RESET_TB                      : out std_logic;
    cntrl0_WDF_ALMOST_FULL               : out std_logic;
    cntrl0_AF_ALMOST_FULL                : out std_logic;
    cntrl0_READ_DATA_VALID               : out std_logic;
    cntrl0_APP_WDF_WREN                  : in std_logic;
    cntrl0_APP_AF_WREN                   : in std_logic;
    cntrl0_BURST_LENGTH                  : out  std_logic_vector(2 downto 0);
    cntrl0_APP_AF_ADDR                   : in  std_logic_vector(35 downto 0);
    cntrl0_READ_DATA_FIFO_OUT            : out  std_logic_vector(143 downto 0);
    cntrl0_APP_WDF_DATA                  : in  std_logic_vector(143 downto 0);
    cntrl0_APP_MASK_DATA                 : in  std_logic_vector(17 downto 0);
    clk_0                                : in std_logic;
    clk_90                               : in std_logic;
    clk_200                              : in std_logic;
    dcm_lock                             : in std_logic;
    cntrl0_DDR2_DQS                      : inout  std_logic_vector(17 downto 0);
    cntrl0_DDR2_DQS_N                    : inout  std_logic_vector(17 downto 0);
    cntrl0_DDR2_CK                       : out  std_logic_vector(0 downto 0);
    cntrl0_DDR2_CK_N                     : out  std_logic_vector(0 downto 0)
    );
    end component;
   
   component mt47h64m16
    GENERIC (
        -- tipd delays: interconnect path delays
        tipd_ODT          : VitalDelayType01 := VitalZeroDelay01;
        tipd_CK           : VitalDelayType01 := VitalZeroDelay01;
        tipd_CKNeg        : VitalDelayType01 := VitalZeroDelay01;
        tipd_CKE          : VitalDelayType01 := VitalZeroDelay01;
        tipd_CSNeg        : VitalDelayType01 := VitalZeroDelay01;
        tipd_RASNeg       : VitalDelayType01 := VitalZeroDelay01;
        tipd_CASNeg       : VitalDelayType01 := VitalZeroDelay01;
        tipd_WENeg        : VitalDelayType01 := VitalZeroDelay01;
        tipd_LDM          : VitalDelayType01 := VitalZeroDelay01;
        tipd_UDM          : VitalDelayType01 := VitalZeroDelay01;
        tipd_BA0          : VitalDelayType01 := VitalZeroDelay01;
        tipd_BA1          : VitalDelayType01 := VitalZeroDelay01;
        tipd_BA2          : VitalDelayType01 := VitalZeroDelay01;
        tipd_A0           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A1           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A2           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A3           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A4           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A5           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A6           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A7           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A8           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A9           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A10          : VitalDelayType01 := VitalZeroDelay01;
        tipd_A11          : VitalDelayType01 := VitalZeroDelay01;
        tipd_A12          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ0          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ1          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ2          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ3          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ4          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ5          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ6          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ7          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ8          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ9          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ10         : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ11         : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ12         : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ13         : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ14         : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ15         : VitalDelayType01 := VitalZeroDelay01;
        tipd_UDQS         : VitalDelayType01 := VitalZeroDelay01;
        tipd_UDQSNeg      : VitalDelayType01 := VitalZeroDelay01;
        tipd_LDQS         : VitalDelayType01 := VitalZeroDelay01;
        tipd_LDQSNeg      : VitalDelayType01 := VitalZeroDelay01;

        -- tpd delays
        tpd_CK_DQ0        : VitalDelayType01Z := UnitDelay01Z; -- tAC(max), tHZ
        tpd_CK_DQ1        : VitalDelayType := UnitDelay; -- tAC(min)
        tpd_CK_LDQS       : VitalDelayType01Z := UnitDelay01Z; -- tDQSCK(max)

        -- tsetup values
        tsetup_DQ0_LDQS   : VitalDelayType := UnitDelay; -- tDSb
        tsetup_A0_CK      : VitalDelayType := UnitDelay; -- tISb
        tsetup_LDQS_CK_CL3_negedge_posedge: VitalDelayType := UnitDelay; -- tDSS
        tsetup_LDQS_CK_CL4_negedge_posedge: VitalDelayType := UnitDelay; -- tDSS
        tsetup_LDQS_CK_CL5_negedge_posedge: VitalDelayType := UnitDelay; -- tDSS
        tsetup_LDQS_CK_CL6_negedge_posedge: VitalDelayType := UnitDelay; -- tDSS

        -- thold values
        thold_DQ0_LDQS    : VitalDelayType := UnitDelay; -- tDHb
        thold_A0_CK       : VitalDelayType := UnitDelay; -- tIHb
        thold_LDQS_CK_CL3_posedge_posedge : VitalDelayType := UnitDelay; -- tDSH
        thold_LDQS_CK_CL4_posedge_posedge : VitalDelayType := UnitDelay; -- tDSH
        thold_LDQS_CK_CL5_posedge_posedge : VitalDelayType := UnitDelay; -- tDSH
        thold_LDQS_CK_CL6_posedge_posedge : VitalDelayType := UnitDelay; -- tDSH

        -- tpw values
        tpw_CK_CL3_posedge: VitalDelayType := UnitDelay; -- tCHAVG
        tpw_CK_CL3_negedge: VitalDelayType := UnitDelay; -- tCLAVG
        tpw_CK_CL4_posedge: VitalDelayType := UnitDelay; -- tCHAVG
        tpw_CK_CL4_negedge: VitalDelayType := UnitDelay; -- tCLAVG
        tpw_CK_CL5_posedge: VitalDelayType := UnitDelay; -- tCHAVG
        tpw_CK_CL5_negedge: VitalDelayType := UnitDelay; -- tCLAVG
        tpw_CK_CL6_posedge: VitalDelayType := UnitDelay; -- tCHAVG
        tpw_CK_CL6_negedge: VitalDelayType := UnitDelay; -- tCLAVG
        tpw_A0_CL3        : VitalDelayType := UnitDelay; -- tIPW
        tpw_A0_CL4        : VitalDelayType := UnitDelay; -- tIPW
        tpw_A0_CL5        : VitalDelayType := UnitDelay; -- tIPW
        tpw_A0_CL6        : VitalDelayType := UnitDelay; -- tIPW
        tpw_DQ0_CL3       : VitalDelayType := UnitDelay; -- tDIPW
        tpw_DQ0_CL4       : VitalDelayType := UnitDelay; -- tDIPW
        tpw_DQ0_CL5       : VitalDelayType := UnitDelay; -- tDIPW
        tpw_DQ0_CL6       : VitalDelayType := UnitDelay; -- tDIPW
        tpw_LDQS_normCL3_posedge : VitalDelayType := UnitDelay; -- tDQSH
        tpw_LDQS_normCL3_negedge : VitalDelayType := UnitDelay; -- tDQSL
        tpw_LDQS_normCL4_posedge : VitalDelayType := UnitDelay; -- tDQSH
        tpw_LDQS_normCL4_negedge : VitalDelayType := UnitDelay; -- tDQSL
        tpw_LDQS_normCL5_posedge : VitalDelayType := UnitDelay; -- tDQSH
        tpw_LDQS_normCL5_negedge : VitalDelayType := UnitDelay; -- tDQSL
        tpw_LDQS_normCL6_posedge : VitalDelayType := UnitDelay; -- tDQSH
        tpw_LDQS_normCL6_negedge : VitalDelayType := UnitDelay; -- tDQSL
        tpw_LDQS_preCL3_negedge  : VitalDelayType := UnitDelay; -- tWPRE
        tpw_LDQS_preCL4_negedge  : VitalDelayType := UnitDelay; -- tWPRE
        tpw_LDQS_preCL5_negedge  : VitalDelayType := UnitDelay; -- tWPRE
        tpw_LDQS_preCL6_negedge  : VitalDelayType := UnitDelay; -- tWPRE
        tpw_LDQS_postCL3_negedge : VitalDelayType := UnitDelay; -- tWPST
        tpw_LDQS_postCL4_negedge : VitalDelayType := UnitDelay; -- tWPST
        tpw_LDQS_postCL5_negedge : VitalDelayType := UnitDelay; -- tWPST
        tpw_LDQS_postCL6_negedge : VitalDelayType := UnitDelay; -- tWPST

        -- tperiod values
        tperiod_CK_CL3    : VitalDelayType := UnitDelay; -- tCKAVG(min)
        tperiod_CK_CL4    : VitalDelayType := UnitDelay; -- tCKAVG(min)
        tperiod_CK_CL5    : VitalDelayType := UnitDelay; -- tCKAVG(min)
        tperiod_CK_CL6    : VitalDelayType := UnitDelay; -- tCKAVG(min)

        -- tskew values
        tskew_CK_LDQS_CL3_posedge_posedge: VitalDelayType := UnitDelay; -- tDQSS
        tskew_CK_LDQS_CL4_posedge_posedge: VitalDelayType := UnitDelay; -- tDQSS
        tskew_CK_LDQS_CL5_posedge_posedge: VitalDelayType := UnitDelay; -- tDQSS
        tskew_CK_LDQS_CL6_posedge_posedge: VitalDelayType := UnitDelay; -- tDQSS

        -- tdevice values: values for internal delays
        tdevice_tRC       : VitalDelayType    := 54 ns; -- tRC
        tdevice_tRRD      : VitalDelayType    := 10 ns; -- tRRD
        tdevice_tRCD      : VitalDelayType    := 12 ns; -- tRCD
        tdevice_tFAW      : VitalDelayType    := 50 ns; -- tFAW
        tdevice_tRASMIN   : VitalDelayType    := 40 ns; -- tRAS(min)
        tdevice_tRASMAX   : VitalDelayType    := 70 us; -- tRAS(max)
        tdevice_tRTP      : VitalDelayType    := 7.5 ns; -- tRTP
        tdevice_tWR       : VitalDelayType    := 15 ns; -- tWR
        tdevice_tWTR      : VitalDelayType    := 7.5 ns; -- tWTR
        tdevice_tRP       : VitalDelayType    := 12 ns; -- tRP
        tdevice_tRFCMIN   : VitalDelayType    := 127.5 ns; -- tRFC(min)
        tdevice_tRFCMAX   : VitalDelayType    := 70 us; -- tRFC(max)
        tdevice_REFPer    : VitalDelayType    := 64 ms; -- refresh period
        tdevice_tCKAVGMAX : VitalDelayType    := 8 ns; -- tCKAVG(max)

        -- generic control parameters
        InstancePath      : string    := DefaultInstancePath;
        TimingChecksOn    : boolean   := DefaultTimingChecks;
        MsgOn             : boolean   := DefaultMsgOn;
        XOn               : boolean   := DefaultXon;

        -- memory file to be loaded
        mem_file_name     : string    := "none";
        UserPreload       : boolean   := FALSE;

        -- For FMF SDF technology file usage
        TimingModel       : string    := DefaultTimingModel
    );
    PORT (
        ODT             : IN    std_ulogic := 'U';
        CK              : IN    std_ulogic := 'U';
        CKNeg           : IN    std_ulogic := 'U';
        CKE             : IN    std_ulogic := 'U';
        CSNeg           : IN    std_ulogic := 'U';
        RASNeg          : IN    std_ulogic := 'U';
        CASNeg          : IN    std_ulogic := 'U';
        WENeg           : IN    std_ulogic := 'U';
        LDM             : IN    std_ulogic := 'U';
        UDM             : IN    std_ulogic := 'U';
        BA0             : IN    std_ulogic := 'U';
        BA1             : IN    std_ulogic := 'U';
        BA2             : IN    std_ulogic := 'U';
        A0              : IN    std_ulogic := 'U';
        A1              : IN    std_ulogic := 'U';
        A2              : IN    std_ulogic := 'U';
        A3              : IN    std_ulogic := 'U';
        A4              : IN    std_ulogic := 'U';
        A5              : IN    std_ulogic := 'U';
        A6              : IN    std_ulogic := 'U';
        A7              : IN    std_ulogic := 'U';
        A8              : IN    std_ulogic := 'U';
        A9              : IN    std_ulogic := 'U';
        A10             : IN    std_ulogic := 'U';
        A11             : IN    std_ulogic := 'U';
        A12             : IN    std_ulogic := 'U';
        DQ0             : INOUT std_ulogic := 'U';
        DQ1             : INOUT std_ulogic := 'U';
        DQ2             : INOUT std_ulogic := 'U';
        DQ3             : INOUT std_ulogic := 'U';
        DQ4             : INOUT std_ulogic := 'U';
        DQ5             : INOUT std_ulogic := 'U';
        DQ6             : INOUT std_ulogic := 'U';
        DQ7             : INOUT std_ulogic := 'U';
        DQ8             : INOUT std_ulogic := 'U';
        DQ9             : INOUT std_ulogic := 'U';
        DQ10            : INOUT std_ulogic := 'U';
        DQ11            : INOUT std_ulogic := 'U';
        DQ12            : INOUT std_ulogic := 'U';
        DQ13            : INOUT std_ulogic := 'U';
        DQ14            : INOUT std_ulogic := 'U';
        DQ15            : INOUT std_ulogic := 'U';
        UDQS            : INOUT std_ulogic := 'U';
        UDQSNeg         : INOUT std_ulogic := 'U';
        LDQS            : INOUT std_ulogic := 'U';
        LDQSNeg         : INOUT std_ulogic := 'U'
    );
   END component;
   
   signal clk                 : std_logic := '0';
   signal clk90               : std_logic := '0';
   signal sys_rst_n           : std_logic := '0';
   signal mem_clk             : std_logic_vector(0 downto 0);
   signal mem_clk_n           : std_logic_vector(0 downto 0);
   signal mem_rst_n           : std_logic;
   signal mem_cke             : std_logic_vector(0 downto 0);
   signal mem_ras_n           : std_logic;
   signal mem_cas_n           : std_logic;
   signal mem_we_n            : std_logic;
   signal mem_cs_n            : std_logic_vector(0 downto 0);
   signal mem_odt             : std_logic_vector(0 downto 0);
   signal mem_ba              : std_logic_vector(2 downto 0);
   signal mem_a               : std_logic_vector(13 downto 0);
   signal mem_dqs             : std_logic_vector(17 downto 0);
   signal mem_dqs_n           : std_logic_vector(17 downto 0);
   signal mem_dq              : std_logic_vector(71 downto 0);

   signal wr_en               : std_logic;
   signal wr_addr             : std_logic_vector(35 downto 0);
   signal wr_data             : std_logic_vector(143 downto 0);
   signal rd_en               : std_logic;
   signal rd_val              : std_logic;
   signal rd_data             : std_logic_vector(143 downto 0);
   signal state               : std_logic_vector(3 downto 0);
   signal clk_tb              : std_logic;
   signal rst_tb              : std_logic;
   signal init_done           : std_logic;
   
begin
   clk       <= not clk after 2.5 ns;
   clk90     <= clk after 1.25 ns;
   sys_rst_n <= '1' after 20 ns;
   mem_dq    <= (others => 'L');
   mem_dqs   <= (others => 'L');
   mem_dqs_n <= (others => 'H');
   
   process(clk_tb, rst_tb)
   begin
      if(rst_tb = '1') then
         state <= "0000";
         wr_en <= '0';
         wr_addr <= (others => '0');
         wr_data <= (others => '0');
         rd_en <= '0';
      elsif clk_tb'event and clk_tb = '1' then
         wr_en <= '0';
         rd_en <= '0';
         wr_addr <= (others => '0');
         wr_data <= (others => '0');
         case state is
            when "0000" =>
               if init_done = '1' then
                  state <= "0001";
               end if;
            when "0001" =>
               wr_en <= '1';
               rd_en <= '1';
               wr_addr <= x"400000000";
               wr_data <= x"AAAAAAAAAAAAAAAAAA555555555555555555";
               state <= "0010";
            when "0010" =>
               wr_en <= '1';
               rd_en <= '1';
               wr_addr <= x"400000004";
               wr_data <= x"999999999999999999666666666666666666";
               state <= "0011";
            when "0011" =>
               wr_en <= '1';
               rd_en <= '1';
               wr_addr <= x"400000008";
               wr_data <= x"FFFFFFFFFFFFFFFFFF111111111111111111";
               state <= "0100";
            when "0100" =>
               wr_en <= '1';
               rd_en <= '1';
               wr_addr <= x"40000000C";
               wr_data <= x"BBBBBBBBBBBBBBBBBB444444444444444444";
               state <= "0101";
            when "0101" =>
               rd_en <= '1';
               wr_addr <= x"500000000";
               state <= "0110";
            when "0110" =>
               rd_en <= '1';
               wr_addr <= x"500000004";
               state <= "0111";
            when "0111" =>
               rd_en <= '1';
               wr_addr <= x"500000008";
               state <= "1000";
            when "1000" =>
               rd_en <= '1';
               wr_addr <= x"50000000C";
               state <= "1001";
            when "1001" =>
               state <= "1001";
            when others =>
               state <= "0000";
         end case;
      end if;
   end process;
   
  ctrl: mem_interfacetopDDR2dclock200CL4
  port map(
    cntrl0_DDR2_DQ                       => mem_dq,
    cntrl0_DDR2_A                        => mem_a,
    cntrl0_DDR2_BA                       => mem_ba,
    cntrl0_DDR2_RAS_N                    => mem_ras_n,
    cntrl0_DDR2_CAS_N                    => mem_cas_n,
    cntrl0_DDR2_WE_N                     => mem_we_n,
    cntrl0_DDR2_CS_N                     => mem_cs_n,
    cntrl0_DDR2_ODT                      => mem_odt,
    cntrl0_DDR2_CKE                      => mem_cke,
    cntrl0_DDR2_RESET_N                  => mem_rst_n,
    SYS_RESET_IN_N                       => sys_rst_n,
    cntrl0_INIT_DONE                     => init_done,
    cntrl0_CLK_TB                        => clk_tb,
    cntrl0_RESET_TB                      => rst_tb,
    cntrl0_WDF_ALMOST_FULL               => open,
    cntrl0_AF_ALMOST_FULL                => open,
    cntrl0_READ_DATA_VALID               => rd_val,
    cntrl0_APP_WDF_WREN                  => wr_en,
    cntrl0_APP_AF_WREN                   => rd_en,
    cntrl0_BURST_LENGTH                  => open,
    cntrl0_APP_AF_ADDR                   => wr_addr,
    cntrl0_READ_DATA_FIFO_OUT            => rd_data,
    cntrl0_APP_WDF_DATA                  => wr_data,
    cntrl0_APP_MASK_DATA                 => "000000000000000000",
    clk_0                                => clk,
    clk_90                               => clk90,
    clk_200                              => clk,
    dcm_lock                             => '1',
    cntrl0_DDR2_DQS                      => mem_dqs,
    cntrl0_DDR2_DQS_N                    => mem_dqs_n,
    cntrl0_DDR2_CK                       => mem_clk,
    cntrl0_DDR2_CK_N                     => mem_clk_n
    );
   
   ddr_gen: for i in 0 to 3 generate
   ddr: mt47h64m16
    PORT map(
        ODT             => mem_odt(0),
        CK              => mem_clk(0),
        CKNeg           => mem_clk_n(0),
        CKE             => mem_cke(0),
        CSNeg           => mem_cs_n(0),
        RASNeg          => mem_ras_n,
        CASNeg          => mem_cas_n,
        WENeg           => mem_we_n,
        LDM             => '0',
        UDM             => '0',
        BA0             => mem_ba(0),
        BA1             => mem_ba(1),
        BA2             => mem_ba(2),
        A0              => mem_a(0),
        A1              => mem_a(1),
        A2              => mem_a(2),
        A3              => mem_a(3),
        A4              => mem_a(4),
        A5              => mem_a(5),
        A6              => mem_a(6),
        A7              => mem_a(7),
        A8              => mem_a(8),
        A9              => mem_a(9),
        A10             => mem_a(10),
        A11             => mem_a(11),
        A12             => mem_a(12),
        DQ0             => mem_dq(16*i+0),
        DQ1             => mem_dq(16*i+1),
        DQ2             => mem_dq(16*i+2),
        DQ3             => mem_dq(16*i+3),
        DQ4             => mem_dq(16*i+4),
        DQ5             => mem_dq(16*i+5),
        DQ6             => mem_dq(16*i+6),
        DQ7             => mem_dq(16*i+7),
        DQ8             => mem_dq(16*i+8),
        DQ9             => mem_dq(16*i+9),
        DQ10            => mem_dq(16*i+10),
        DQ11            => mem_dq(16*i+11),
        DQ12            => mem_dq(16*i+12),
        DQ13            => mem_dq(16*i+13),
        DQ14            => mem_dq(16*i+14),
        DQ15            => mem_dq(16*i+15),
        UDQS            => mem_dqs(i*4+2),
        UDQSNeg         => mem_dqs_n(i*4+2),
        LDQS            => mem_dqs(i*4),
        LDQSNeg         => mem_dqs_n(i*4)
    );
    end generate;
   ddr: mt47h64m16
    PORT map(
        ODT             => mem_odt(0),
        CK              => mem_clk(0),
        CKNeg           => mem_clk_n(0),
        CKE             => mem_cke(0),
        CSNeg           => mem_cs_n(0),
        RASNeg          => mem_ras_n,
        CASNeg          => mem_cas_n,
        WENeg           => mem_we_n,
        LDM             => '0',
        UDM             => '0',
        BA0             => mem_ba(0),
        BA1             => mem_ba(1),
        BA2             => mem_ba(2),
        A0              => mem_a(0),
        A1              => mem_a(1),
        A2              => mem_a(2),
        A3              => mem_a(3),
        A4              => mem_a(4),
        A5              => mem_a(5),
        A6              => mem_a(6),
        A7              => mem_a(7),
        A8              => mem_a(8),
        A9              => mem_a(9),
        A10             => mem_a(10),
        A11             => mem_a(11),
        A12             => mem_a(12),
        DQ0             => mem_dq(64),
        DQ1             => mem_dq(65),
        DQ2             => mem_dq(66),
        DQ3             => mem_dq(67),
        DQ4             => mem_dq(68),
        DQ5             => mem_dq(69),
        DQ6             => mem_dq(70),
        DQ7             => mem_dq(71),
        DQ8             => open,
        DQ9             => open,
        DQ10            => open,
        DQ11            => open,
        DQ12            => open,
        DQ13            => open,
        DQ14            => open,
        DQ15            => open,
        UDQS            => open,
        UDQSNeg         => open,
        LDQS            => mem_dqs(16),
        LDQSNeg         => mem_dqs_n(16)
    );
end functional;