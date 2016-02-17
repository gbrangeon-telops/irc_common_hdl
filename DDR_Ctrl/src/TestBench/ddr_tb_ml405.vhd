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
library work;
use work.all;

entity ddr_tb is
end ddr_tb;

architecture functional of ddr_tb is

   component ddr_mig is
   port (
      -- System
      SYS_RST_N      : in     std_logic;
      SYS_CLK100     : in     std_logic;

      -- DDR memory
      MEM_CK_P       : out    std_logic;
      MEM_CK_N       : out    std_logic;
      MEM_CKE        : out    std_logic;
      MEM_CS_N       : out    std_logic;
      MEM_RAS_N      : out    std_logic;
      MEM_CAS_N      : out    std_logic;
      MEM_WE_N       : out    std_logic;
      MEM_BA         : out    std_logic_vector( 1 downto 0);
      MEM_ADD        : out    std_logic_vector(12 downto 0);
      MEM_DQS        : inout  std_logic_vector( 1 downto 0);
      MEM_DQ         : inout  std_logic_vector(15 downto 0);
      MEM_DM         : out    std_logic_vector( 1 downto 0)
   );
   end component;
   
   component MT46V32M8
   generic (                                   -- Timing for -6 component
      tCK       : TIME    :=  6.000 ns;
      tCH       : TIME    :=  2.700 ns;       -- 0.45*tCK
      tCL       : TIME    :=  2.700 ns;       -- 0.45*tCK
      tDH       : TIME    :=  0.450 ns;
      tDS       : TIME    :=  0.450 ns;
      tIH       : TIME    :=  0.750 ns;
      tIS       : TIME    :=  0.750 ns;
      tMRD      : TIME    := 12.000 ns;
      tRAS      : TIME    := 42.000 ns;
      tRAP      : TIME    := 18.000 ns;
      tRC       : TIME    := 60.000 ns;
      tRFC      : TIME    := 72.000 ns;
      tRCD      : TIME    := 18.000 ns;
      tRP       : TIME    := 18.000 ns;
      tRRD      : TIME    := 12.000 ns;
      tWR       : TIME    := 15.000 ns;
      addr_bits : INTEGER := 13;
      data_bits : INTEGER :=  8;
      cols_bits : INTEGER := 12
   );
   port (
      Dq    : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => 'Z');
      Dqs   : INOUT STD_LOGIC := 'Z';
      Addr  : IN    STD_LOGIC_VECTOR (12 DOWNTO 0);
      Ba    : IN    STD_LOGIC_VECTOR             (1 DOWNTO 0);
      Clk   : IN    STD_LOGIC;
      Clk_n : IN    STD_LOGIC;
      Cke   : IN    STD_LOGIC;
      Cs_n  : IN    STD_LOGIC;
      Ras_n : IN    STD_LOGIC;
      Cas_n : IN    STD_LOGIC;
      We_n  : IN    STD_LOGIC;
      Dm    : IN    STD_LOGIC
   );
   end component;

   -- Misc
   signal sys_rst_n     : std_logic := '0';
   signal sys_clk       : std_logic := '0';
   
   -- Memory
   signal mem_ck_p      : std_logic;
   signal mem_ck_n      : std_logic;
   signal mem_cke       : std_logic;
   signal mem_cs_n      : std_logic;
   signal mem_ras_n     : std_logic;
   signal mem_cas_n     : std_logic;
   signal mem_we_n      : std_logic;
   signal mem_ba        : std_logic_vector( 1 downto 0);
   signal mem_add       : std_logic_vector(12 downto 0);
   signal mem_dqs       : std_logic_vector( 1 downto 0);
   signal mem_dq        : std_logic_vector(15 downto 0);
   signal mem_dm        : std_logic_vector( 1 downto 0);
   
begin
   
   sys_rst_n   <= '1' after 40 ns;
   sys_clk     <= not sys_clk after 5 ns;

   fpga: ddr_mig
   port map (
      -- System
      SYS_RST_N      => sys_rst_n,
      SYS_CLK100     => sys_clk,

      -- DDR memory
      MEM_CK_P       => mem_ck_p,
      MEM_CK_N       => mem_ck_n,
      MEM_CKE        => mem_cke,
      MEM_CS_N       => mem_cs_n,
      MEM_RAS_N      => mem_ras_n,
      MEM_CAS_N      => mem_cas_n,
      MEM_WE_N       => mem_we_n,
      MEM_BA         => mem_ba,
      MEM_ADD        => mem_add,
      MEM_DQS        => mem_dqs,
      MEM_DM         => mem_dm,
      MEM_DQ         => mem_dq
   );
   
   mem_dq      <= (others => 'L');
   
   -- HYB25D512160BC6 (=MT46v32m16) simulated with two x8 components
   comp1: MT46V32M8
   port map(
      Dq    => mem_dq(7 downto 0),
      Dqs   => mem_dqs(0),
      Addr  => mem_add,
      Ba    => mem_ba,
      Clk   => mem_ck_p,
      Clk_n => mem_ck_n,
      Cke   => mem_cke,
      Cs_n  => mem_cs_n,
      Ras_n => mem_ras_n,
      Cas_n => mem_cas_n,
      We_n  => mem_we_n,
      Dm    => mem_dm(0)
   );

   comp2: MT46V32M8
   port map(
      Dq    => mem_dq(15 downto 8),
      Dqs   => mem_dqs(1),
      Addr  => mem_add,
      Ba    => mem_ba,
      Clk   => mem_ck_p,
      Clk_n => mem_ck_n,
      Cke   => mem_cke,
      Cs_n  => mem_cs_n,
      Ras_n => mem_ras_n,
      Cas_n => mem_cas_n,
      We_n  => mem_we_n,
      Dm    => mem_dm(1)
   );

end functional;
