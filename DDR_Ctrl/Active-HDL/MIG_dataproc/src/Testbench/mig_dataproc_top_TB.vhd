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
   
   -- Stimulus signals - signals mapped to the input and inout ports of tested entity
   signal CLK100_IN_N : std_logic;
   signal CLK100_IN_P : std_logic;
   signal RESET_IN_N : std_logic;
   signal DDR_SDA : std_logic;
   signal DDR_DQ : std_logic_vector(71 downto 0);
   signal DDR_DQS : std_logic_vector(17 downto 0);
   -- Observed signals - signals mapped to the output ports of tested entity
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
   signal DDRT_STAT : std_logic_vector(1 downto 0);
   
   -- Add your code here ...
   
begin
   
   -- Unit Under Test port map
   UUT : mig_dataproc_top
   port map (
      CLK100_IN_N => CLK100_IN_N,
      CLK100_IN_P => CLK100_IN_P,
      RESET_IN_N => RESET_IN_N,
      DDR_CAS_N => DDR_CAS_N,
      DDR_CLK_N => DDR_CLK_N,
      DDR_CLK_P => DDR_CLK_P,
      DDR_RAS_N => DDR_RAS_N,
      DDR_RESET_N => DDR_RESET_N,
      DDR_SCL => DDR_SCL,
      DDR_WE_N => DDR_WE_N,
      DDR_ADD => DDR_ADD,
      DDR_BA => DDR_BA,
      DDR_CKE => DDR_CKE,
      DDR_CS_N => DDR_CS_N,
      DDR_SA => DDR_SA,
      DDR_SDA => DDR_SDA,
      DDR_DQ => DDR_DQ,
      DDR_DQS => DDR_DQS
      );
   
   -- Add your stimulus here ...
   
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

