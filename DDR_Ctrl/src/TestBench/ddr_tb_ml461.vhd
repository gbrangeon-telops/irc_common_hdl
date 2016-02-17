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
      SYS_CLK200_P   : in     std_logic;
      SYS_CLK200_N   : in     std_logic;

      -- DDR memory
      MEM_CK_P       : out    std_logic;
      MEM_CK_N       : out    std_logic;
      MEM_CKE        : out    std_logic_vector( 1 downto 0);
      MEM_RST_N      : out    std_logic;
      MEM_CS_N       : out    std_logic_vector( 3 downto 0);
      MEM_RAS_N      : out    std_logic;
      MEM_CAS_N      : out    std_logic;
      MEM_WE_N       : out    std_logic;
      MEM_BA         : out    std_logic_vector( 2 downto 0);
      MEM_ADD        : out    std_logic_vector(15 downto 0);
      MEM_DQS        : inout  std_logic_vector(17 downto 0);
      MEM_DQ         : inout  std_logic_vector(71 downto 0);
      MEM_SA         : out    std_logic_vector( 2 downto 0);
      MEM_SCL        : out    std_logic;
      MEM_SDA        : inout  std_logic;
      
      -- Misc
      home_reset     : in     std_logic
   );
   end component;
   
   component MT36VDDF25672 is -- Verilog DDR model
   port (
      RESET_N     : in    std_logic;
      CLK         : in    std_logic;
      CLK_N       : in    std_logic;
      CKE         : in    std_logic_vector( 1 downto 0);
      S_N         : in    std_logic_vector( 1 downto 0);
      CAS_N       : in    std_logic;
      RAS_N       : in    std_logic;
      WE_N        : in    std_logic;
      BA          : in    std_logic_vector( 1 downto 0);
      A           : in    std_logic_vector(12 downto 0);
      DQS         : inout std_logic_vector(17 downto 0);
      DQ          : inout std_logic_vector(63 downto 0);
      CB          : inout std_logic_vector( 7 downto 0)
   );
   end component;

   component MT36VDDF25672G is -- VHDL DDR model (old)
   port (
      RESET_N     : in    std_logic;
      CLK         : in    std_logic;
      CLK_N       : in    std_logic;
      CKE         : in    std_logic_vector( 1 downto 0);
      S_N         : in    std_logic_vector( 1 downto 0);
      CAS_N       : in    std_logic;
      RAS_N       : in    std_logic;
      WE_N        : in    std_logic;
      BA          : in    std_logic_vector( 1 downto 0);
      A           : in    std_logic_vector(12 downto 0);
      DQS         : inout std_logic_vector(17 downto 0);
      DQ          : inout std_logic_vector(63 downto 0);
      CB          : inout std_logic_vector( 7 downto 0)
   );
   end component;

   -- Misc
   signal sys_rst_n     : std_logic := '0';
   signal sys_clk_p     : std_logic := '0';
   signal sys_clk_n     : std_logic := '1';
   
   -- Memory
   signal mem_ck_p      : std_logic;
   signal mem_ck_n      : std_logic;
   signal mem_cke       : std_logic_vector( 1 downto 0);
   signal mem_rst_n     : std_logic;
   signal mem_cs_n      : std_logic_vector( 3 downto 0);
   signal mem_ras_n     : std_logic;
   signal mem_cas_n     : std_logic;
   signal mem_we_n      : std_logic;
   signal mem_ba        : std_logic_vector( 2 downto 0);
   signal mem_add       : std_logic_vector(15 downto 0);
   signal mem_dqs       : std_logic_vector(17 downto 0);
   signal mem_dq        : std_logic_vector(71 downto 0);
   
begin
   
   sys_rst_n   <= '1' after 20 ns;
   sys_clk_p   <= not sys_clk_p after 2.5 ns;
   sys_clk_n   <= not sys_clk_p;

   fpga: ddr_mig
   port map (
      -- System
      SYS_RST_N      => sys_rst_n,
      SYS_CLK200_P   => sys_clk_p,
      SYS_CLK200_N   => sys_clk_n,

      -- DDR memory
      MEM_CK_P       => mem_ck_p,
      MEM_CK_N       => mem_ck_n,
      MEM_CKE        => mem_cke,
      MEM_RST_N      => mem_rst_n,
      MEM_CS_N       => mem_cs_n,
      MEM_RAS_N      => mem_ras_n,
      MEM_CAS_N      => mem_cas_n,
      MEM_WE_N       => mem_we_n,
      MEM_BA         => mem_ba,
      MEM_ADD        => mem_add,
      MEM_DQS        => mem_dqs,
      MEM_DQ         => mem_dq,
      MEM_SA         => open,
      MEM_SCL        => open,
      MEM_SDA        => open,
      
      -- Misc
      home_reset     => 'H'
   );
   
   mem_dq <= (others => 'L');
   
   DDR_DIMM: MT36VDDF25672G
   port map (
      RESET_N     => mem_rst_n,
      CLK         => mem_ck_p,
      CLK_N       => mem_ck_n,
      CKE         => mem_cke,
      S_N         => mem_cs_n(1 downto 0),
      CAS_N       => mem_cas_n,
      RAS_N       => mem_ras_n,
      WE_N        => mem_we_n,
      BA          => mem_ba(1 downto 0),
      A           => mem_add(12 downto 0),
      DQS         => mem_dqs,
      DQ          => mem_dq(63 downto  0),
      CB          => mem_dq(71 downto 64)
   );

end functional;
