-------------------------------------------------------------------------------
--
-- Title       : Test Bench for mig_dataproc_top
-- Design      : MIG_dataproc
-- Author      : Olivier Bourgois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\mig_dataproc_top_TB.vhd
-- Generated   : 2007-10-17, 12:41
-- From        : $DSN\compile\MIG_dataproc_top.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for mig_dataproc_top_tb
--
-------------------------------------------------------------------------------

library ieee,common_hdl;
use ieee.std_logic_1164.all;

-- Add your library and packages declaration here ...

entity mig_dataproc_top_tb is
end mig_dataproc_top_tb;

architecture TB_ARCHITECTURE of mig_dataproc_top_tb is
   -- Component declaration of the tested unit
   component mig_dataproc_top
      port(
         CLK100_IN_N : in std_logic;
         CLK100_IN_P : in std_logic;
         RESET_IN_N : in std_logic;
         DDR_CAS_N : out std_logic;
         DDR_CLK_N : out std_logic;
         DDR_CLK_P : out std_logic;
         DDR_RAS_N : out std_logic;
         DDR_RESET_N : out std_logic;
         DDR_SCL : out std_logic;
         DDR_WE_N : out std_logic;
         DDR_ADD : out std_logic_vector(12 downto 0);
         DDR_BA : out std_logic_vector(1 downto 0);
         DDR_CKE : out std_logic_vector(1 downto 0);
         DDR_CS_N : out std_logic_vector(1 downto 0);
         DDR_SA : out std_logic_vector(2 downto 0);
         DDR_SDA : inout std_logic;
         DDR_DQ : inout std_logic_vector(71 downto 0);
         DDR_DQS : inout std_logic_vector(17 downto 0)
         );
   end component;
   
   -- DIMM Module component
   component MT36VDDF25672G is
      port(
         CAS_N : in STD_LOGIC;
         CLK : in STD_LOGIC;
         CLK_N : in STD_LOGIC;
         RAS_N : in STD_LOGIC;
         RESET_N : in STD_LOGIC;
         WE_N : in STD_LOGIC;
         A : in STD_LOGIC_VECTOR(12 downto 0);
         BA : in STD_LOGIC_VECTOR(1 downto 0);
         CKE : in std_logic_vector(1 downto 0);
         S_N : in std_logic_vector(1 downto 0);
         CB : inout STD_LOGIC_VECTOR(7 downto 0);
         DQ : inout STD_LOGIC_VECTOR(63 downto 0);
         DQS : inout std_logic_vector(17 downto 0));
   end component;
   
   component WireDelay is
     generic (Delay_g : time);
     port
       (A : inout Std_Logic;
        B : inout Std_Logic
        );
   end component;

   -- Stimulus signals - signals mapped to the input and inout ports of tested entity
   signal CLK100_IN_N : std_logic;
   signal CLK100_IN_P : std_logic;
   signal RESET_IN_N : std_logic;
   -- DDR
   signal DDR_SDA : std_logic;
   signal DDR_DQ : std_logic_vector(71 downto 0);
   signal DDR_DQS : std_logic_vector(17 downto 0);
   signal DDR_CAS_N : std_logic;
   signal DDR_CLK_N : std_logic;
   signal DDR_CLK_P : std_logic;
   signal DDR_RAS_N : std_logic;
   signal DDR_RESET_N : std_logic;
   signal DDR_SCL : std_logic;
   signal DDR_WE_N : std_logic;
   signal DDR_ADD : std_logic_vector(12 downto 0);
   signal DDR_BA : std_logic_vector(1 downto 0);
   signal DDR_CKE : std_logic_vector(1 downto 0);
   signal DDR_CS_N : std_logic_vector(1 downto 0);
   signal DDR_SA : std_logic_vector(2 downto 0);
   -- FPGA
   signal FPGA_SDA : std_logic;
   signal FPGA_DQ : std_logic_vector(71 downto 0);
   signal FPGA_DQS : std_logic_vector(17 downto 0);
   signal FPGA_CAS_N : std_logic;
   signal FPGA_CLK_N : std_logic;
   signal FPGA_CLK_P : std_logic;
   signal FPGA_RAS_N : std_logic;
   signal FPGA_RESET_N : std_logic;
   signal FPGA_SCL : std_logic;
   signal FPGA_WE_N : std_logic;
   signal FPGA_ADD : std_logic_vector(12 downto 0);
   signal FPGA_BA : std_logic_vector(1 downto 0);
   signal FPGA_CKE : std_logic_vector(1 downto 0);
   signal FPGA_CS_N : std_logic_vector(1 downto 0);
   signal FPGA_SA : std_logic_vector(2 downto 0);
   
   -- Delay
--   constant DELAY : time := 0 ps;
--   constant GLOBAL_DELAY : time := 0 ps;
--   constant CLK_DELAY    : time := 0 ps;
--   constant ADD_DELAY    : time := 0 ps;
--   constant CTRL_DELAY   : time := 0 ps;
--   constant CS_DELAY     : time := 0 ps;
--   constant DATA0_DELAY  : time := 0 ps;
--   constant DATA1_DELAY  : time := 0 ps;
--   constant DATA2_DELAY  : time := 0 ps;
--   constant DATA3_DELAY  : time := 0 ps;
--   constant DATA4_DELAY  : time := 0 ps;
--   constant DATA5_DELAY  : time := 0 ps;
--   constant DATA6_DELAY  : time := 0 ps;
--   constant DATA7_DELAY  : time := 0 ps;
--   constant DATA8_DELAY  : time := 0 ps;
--   constant DATA9_DELAY  : time := 0 ps;
--   constant DATA10_DELAY : time := 0 ps;
--   constant DATA11_DELAY : time := 0 ps;
--   constant DATA12_DELAY : time := 0 ps;
--   constant DATA13_DELAY : time := 0 ps;
--   constant DATA14_DELAY : time := 0 ps;
--   constant DATA15_DELAY : time := 0 ps;
--   constant DATA16_DELAY : time := 0 ps;
--   constant DATA17_DELAY : time := 0 ps;
--   constant DQS0_DELAY   : time := 0 ps;
--   constant DQS1_DELAY   : time := 0 ps;
--   constant DQS2_DELAY   : time := 0 ps;
--   constant DQS3_DELAY   : time := 0 ps;
--   constant DQS4_DELAY   : time := 0 ps;
--   constant DQS5_DELAY   : time := 0 ps;
--   constant DQS6_DELAY   : time := 0 ps;
--   constant DQS7_DELAY   : time := 0 ps;
--   constant DQS8_DELAY   : time := 0 ps;
--   constant DQS9_DELAY   : time := 0 ps;
--   constant DQS10_DELAY  : time := 0 ps;
--   constant DQS11_DELAY  : time := 0 ps;
--   constant DQS12_DELAY  : time := 0 ps;
--   constant DQS13_DELAY  : time := 0 ps;
--   constant DQS14_DELAY  : time := 0 ps;
--   constant DQS15_DELAY  : time := 0 ps;
--   constant DQS16_DELAY  : time := 0 ps;
--   constant DQS17_DELAY  : time := 0 ps;
-- Delay
   constant DELAY : time := 700 ps;
   constant GLOBAL_DELAY : time := 166 ps;
   constant CLK_DELAY    : time := 495 ps;
   constant ADD_DELAY    : time := 525 ps;
   constant CTRL_DELAY   : time := 510 ps;
   constant CS_DELAY     : time := 580 ps;
   constant DATA0_DELAY  : time := 295 ps;
   constant DATA1_DELAY  : time := 305 ps;
   constant DATA2_DELAY  : time := 255 ps;
   constant DATA3_DELAY  : time := 260 ps;
   constant DATA4_DELAY  : time := 275 ps;
   constant DATA5_DELAY  : time := 275 ps;
   constant DATA6_DELAY  : time := 350 ps;
   constant DATA7_DELAY  : time := 370 ps;
   constant DATA8_DELAY  : time := 545 ps;
   constant DATA9_DELAY  : time := 545 ps;
   constant DATA10_DELAY : time := 505 ps;
   constant DATA11_DELAY : time := 500 ps;
   constant DATA12_DELAY : time := 620 ps;
   constant DATA13_DELAY : time := 625 ps;
   constant DATA14_DELAY : time := 705 ps;
   constant DATA15_DELAY : time := 680 ps;
   constant DATA16_DELAY : time := 655 ps;
   constant DATA17_DELAY : time := 660 ps;
   constant DQS0_DELAY   : time := 330 ps;
   constant DQS1_DELAY   : time := 295 ps;
   constant DQS2_DELAY   : time := 295 ps;
   constant DQS3_DELAY   : time := 370 ps;
   constant DQS4_DELAY   : time := 465 ps;
   constant DQS5_DELAY   : time := 545 ps;
   constant DQS6_DELAY   : time := 655 ps;
   constant DQS7_DELAY   : time := 685 ps;
   constant DQS8_DELAY   : time := 685 ps;
   constant DQS9_DELAY   : time := 330 ps;
   constant DQS10_DELAY  : time := 295 ps;
   constant DQS11_DELAY  : time := 295 ps;
   constant DQS12_DELAY  : time := 370 ps;
   constant DQS13_DELAY  : time := 565 ps;
   constant DQS14_DELAY  : time := 545 ps;
   constant DQS15_DELAY  : time := 655 ps;
   constant DQS16_DELAY  : time := 685 ps;
   constant DQS17_DELAY  : time := 685 ps;
   
begin
   
   -- Unit Under Test port map
   UUT : mig_dataproc_top
   port map (
      CLK100_IN_N => CLK100_IN_N,
      CLK100_IN_P => CLK100_IN_P,
      RESET_IN_N => RESET_IN_N,
      DDR_CAS_N => FPGA_CAS_N,
      DDR_CLK_N => FPGA_CLK_N,
      DDR_CLK_P => FPGA_CLK_P,
      DDR_RAS_N => FPGA_RAS_N,
      DDR_RESET_N => FPGA_RESET_N,
      DDR_SCL => FPGA_SCL,
      DDR_WE_N => FPGA_WE_N,
      DDR_ADD => FPGA_ADD,
      DDR_BA => FPGA_BA,
      DDR_CKE => FPGA_CKE,
      DDR_CS_N => FPGA_CS_N,
      DDR_SA => FPGA_SA,
      DDR_SDA => FPGA_SDA,
      DDR_DQ => FPGA_DQ,
      DDR_DQS => FPGA_DQS
      );
   
   -- PCB delays
   DDR_CAS_N <= FPGA_CAS_N after CTRL_DELAY+GLOBAL_DELAY;
   DDR_CLK_N <= FPGA_CLK_N after CLK_DELAY+GLOBAL_DELAY;
   DDR_CLK_P <= FPGA_CLK_P after CLK_DELAY+GLOBAL_DELAY;
   DDR_RAS_N <= FPGA_RAS_N after CTRL_DELAY+GLOBAL_DELAY;
   DDR_RESET_N <= FPGA_RESET_N after CTRL_DELAY+GLOBAL_DELAY;
   DDR_WE_N <= FPGA_WE_N after CTRL_DELAY+GLOBAL_DELAY;
   DDR_ADD <= FPGA_ADD after ADD_DELAY+GLOBAL_DELAY;
--   DDR_ADD <= (FPGA_ADD(12 downto 10) & '0' & (FPGA_ADD(8 downto 0))) after ADD_DELAY+GLOBAL_DELAY;
   DDR_BA <= FPGA_BA after ADD_DELAY+GLOBAL_DELAY;
   DDR_CKE <= FPGA_CKE after CTRL_DELAY+GLOBAL_DELAY;
   DDR_CS_N <= FPGA_CS_N after CS_DELAY+GLOBAL_DELAY;
   DDR_SCL <= FPGA_SCL after DELAY+GLOBAL_DELAY;
   DDR_SA <= FPGA_SA after DELAY+GLOBAL_DELAY;
   DDR_SDA <= FPGA_SDA after DELAY+GLOBAL_DELAY;

   dqs_dly0: WireDelay
     generic map(Delay_g => DQS0_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(0),
        B => FPGA_DQS(0)
        );
   dqs_dly1: WireDelay
     generic map(Delay_g => DQS1_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(1),
        B => FPGA_DQS(1)
        );
   dqs_dly2: WireDelay
     generic map(Delay_g => DQS2_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(2),
        B => FPGA_DQS(2)
        );
   dqs_dly3: WireDelay
     generic map(Delay_g => DQS3_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(3),
        B => FPGA_DQS(3)
        );
   dqs_dly4: WireDelay
     generic map(Delay_g => DQS4_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(4),
        B => FPGA_DQS(4)
        );
   dqs_dly5: WireDelay
     generic map(Delay_g => DQS5_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(5),
        B => FPGA_DQS(5)
        );
   dqs_dly6: WireDelay
     generic map(Delay_g => DQS6_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(6),
        B => FPGA_DQS(6)
        );
   dqs_dly7: WireDelay
     generic map(Delay_g => DQS7_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(7),
        B => FPGA_DQS(7)
        );
   dqs_dly8: WireDelay
     generic map(Delay_g => DQS8_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(8),
        B => FPGA_DQS(8)
        );
   dqs_dly9: WireDelay
     generic map(Delay_g => DQS9_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(9),
        B => FPGA_DQS(9)
        );
   dqs_dly10: WireDelay
     generic map(Delay_g => DQS10_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(10),
        B => FPGA_DQS(10)
        );
   dqs_dly11: WireDelay
     generic map(Delay_g => DQS11_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(11),
        B => FPGA_DQS(11)
        );
   dqs_dly12: WireDelay
     generic map(Delay_g => DQS12_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(12),
        B => FPGA_DQS(12)
        );
   dqs_dly13: WireDelay
     generic map(Delay_g => DQS13_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(13),
        B => FPGA_DQS(13)
        );
   dqs_dly14: WireDelay
     generic map(Delay_g => DQS14_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(14),
        B => FPGA_DQS(14)
        );
   dqs_dly15: WireDelay
     generic map(Delay_g => DQS15_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(15),
        B => FPGA_DQS(15)
        );
   dqs_dly16: WireDelay
     generic map(Delay_g => DQS16_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(16),
        B => FPGA_DQS(16)
        );
   dqs_dly17: WireDelay
     generic map(Delay_g => DQS17_DELAY+GLOBAL_DELAY)
     port map
       (A => DDR_DQS(17),
        B => FPGA_DQS(17)
        );

   data_dly0 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA0_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(0+i),
           B => FPGA_DQ(0+i)
           );
   end generate;
   data_dly1 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA1_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(4+i),
           B => FPGA_DQ(4+i)
           );
   end generate;
   data_dly2 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA2_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(8+i),
           B => FPGA_DQ(8+i)
           );
   end generate;
   data_dly3 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA3_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(12+i),
           B => FPGA_DQ(12+i)
           );
   end generate;
   data_dly4 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA4_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(16+i),
           B => FPGA_DQ(16+i)
           );
   end generate;
   data_dly5 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA5_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(20+i),
           B => FPGA_DQ(20+i)
           );
   end generate;
   data_dly6 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA6_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(24+i),
           B => FPGA_DQ(24+i)
           );
   end generate;
   data_dly7 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA7_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(28+i),
           B => FPGA_DQ(28+i)
           );
   end generate;
   data_dly8 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA8_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(32+i),
           B => FPGA_DQ(32+i)
           );
   end generate;
   data_dly9 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA9_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(36+i),
           B => FPGA_DQ(36+i)
           );
   end generate;
   data_dly10 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA10_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(40+i),
           B => FPGA_DQ(40+i)
           );
   end generate;
   data_dly11 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA11_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(44+i),
           B => FPGA_DQ(44+i)
           );
   end generate;
   data_dly12 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA12_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(48+i),
           B => FPGA_DQ(48+i)
           );
   end generate;
   data_dly13 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA13_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(52+i),
           B => FPGA_DQ(52+i)
           );
   end generate;
   data_dly14 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA14_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(56+i),
           B => FPGA_DQ(56+i)
           );
   end generate;
   data_dly15 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA15_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(60+i),
           B => FPGA_DQ(60+i)
           );
   end generate;
   data_dly16 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA16_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(64+i),
           B => FPGA_DQ(64+i)
           );
   end generate;
   data_dly17 : for i in 0 to 3 generate
      dly: WireDelay
        generic map(Delay_g => DATA17_DELAY+GLOBAL_DELAY)
        port map
          (A => DDR_DQ(68+i),
           B => FPGA_DQ(68+i)
           );
   end generate;
   
   -- instantiate the DIMM
   DIMM : MT36VDDF25672G
   port map (
      CAS_N => DDR_CAS_N,
      CLK => DDR_CLK_P,
      CLK_N => DDR_CLK_N,
      RAS_N => DDR_RAS_N,
      RESET_N => DDR_RESET_N,
      WE_N => DDR_WE_N,
      A => DDR_ADD,
      BA => DDR_BA,
      CKE => DDR_CKE,
      S_N => DDR_CS_N,
      CB(7 downto 0) => DDR_DQ(71 downto 64),
      DQ(63 downto 0) => DDR_DQ(63 downto 0),
      DQS(0) => DDR_DQS(0),
      DQS(9) => DDR_DQS(1),
      DQS(1) => DDR_DQS(2),
      DQS(10) => DDR_DQS(3),
      DQS(2) => DDR_DQS(4),
      DQS(11) => DDR_DQS(5),
      DQS(3) => DDR_DQS(6),
      DQS(12) => DDR_DQS(7),
      DQS(4) => DDR_DQS(8),
      DQS(13) => DDR_DQS(9),
      DQS(5) => DDR_DQS(10),
      DQS(14) => DDR_DQS(11),
      DQS(6) => DDR_DQS(12),
      DQS(15) => DDR_DQS(13),
      DQS(7) => DDR_DQS(14),
      DQS(16) => DDR_DQS(15),
      DQS(8) => DDR_DQS(16),
      DQS(17) => DDR_DQS(17));
   -- DQS => DDR_DQS);
   
   -- this is required for the core to work!
   DDR_DQS <= (others => 'L');
   DDR_DQ  <= (others => 'L');
   
   -- generate a clock source
   clock : process
   begin
      CLK100_IN_P <= '0';
      loop
         wait for 5 ns;
         CLK100_IN_P <= not CLK100_IN_P;
      end loop;
   end process clock;
   CLK100_IN_N <= not CLK100_IN_P;
   
   -- generate a reset
   gen_rst : process
   begin
      RESET_IN_N <= '0';
      wait for 20ns;
      RESET_IN_N <= '1';
      wait;
   end process gen_rst;
   
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_mig_dataproc_top of mig_dataproc_top_tb is
   for TB_ARCHITECTURE
      for UUT : mig_dataproc_top
         use entity work.mig_dataproc_top(from_bde);
      end for;
   end for;
end TESTBENCH_FOR_mig_dataproc_top;

