---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: mig_adapt.vhd
--  Use:  wrapper for MIG DDR core to adapt to our interfacing conventions
--  By: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Notes: Isolates the MIG code here for clarity
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mig_adapt is
--   generic(
--      --------------------------------
--      -- MIG Core Generics
--      --------------------------------
--      REGISTERED_DIMM : std_logic := '1');
   
   port(
      --------------------------------
      -- Global clocks and resets
      --------------------------------
      ARESET       : in    std_logic;
      MEM_CLK0     : in    std_logic;
      MEM_CLK90    : in    std_logic;
      MEM_CLK_200M : in    std_logic;
      
      --------------------------------
      -- Core interface
      --------------------------------          
      CORE_DATA_VLD  : out std_logic;
      CORE_DATA_RD   : out std_logic_vector(143 downto 0);
      CORE_AFULL     : out std_logic; 
      CORE_DATA_WR   : in std_logic_vector(143 downto 0);
      CORE_ADDR      : in std_logic_vector(27 downto 0);
      CORE_CMD       : in std_logic_vector(2 downto 0);
      CORE_CMD_VALID : in std_logic;
      CORE_INITDONE  : out std_logic;
      
      --------------------------------
      -- DDR DIMM interface
      --------------------------------
      DDR_RESET_N  : out   std_logic;
      DDR_CK_P     : out   std_logic;
      DDR_CK_N     : out   std_logic;
      DDR_CKE      : out   std_logic_vector(1 downto 0);
      DDR_CS_N     : out   std_logic_vector(3 downto 0);
      DDR_RAS_N    : out   std_logic;
      DDR_CAS_N    : out   std_logic;
      DDR_WE_N     : out   std_logic;
      DDR_BA       : out   std_logic_vector(2 downto 0);
      DDR_A        : out   std_logic_vector(15 downto 0);
      DDR_DQS      : inout std_logic_vector(17 downto 0);
      DDR_DQ       : inout std_logic_vector(71 downto 0);
      DDR_SA       : out   std_logic_vector(2 downto 0);
      DDR_SCL      : out   std_logic;
      DDR_SDA      : inout std_logic);
end mig_adapt;

architecture rtl of mig_adapt is

   -- MIG
   component mem_interface_top
      port (                 
         dly_ctrl_rdy              : out std_logic;
         cntrl0_DDR_DQ             : inout  std_logic_vector(71 downto 0);
         cntrl0_DDR_A              : out std_logic_vector(12 downto 0);
         cntrl0_DDR_BA             : out std_logic_vector(1 downto 0);
         cntrl0_DDR_CKE            : out std_logic_vector(1 downto 0);
         cntrl0_DDR_CS_N           : out std_logic_vector(1 downto 0);
         cntrl0_DDR_RAS_N          : out std_logic;
         cntrl0_DDR_CAS_N          : out std_logic;
         cntrl0_DDR_WE_N           : out std_logic;
         cntrl0_DDR_RESET_N        : out std_logic;
         init_done                 : out std_logic;
         SYS_RESET_IN_N            : in std_logic;
         cntrl0_CLK_TB             : out std_logic;
         cntrl0_RESET_TB           : out std_logic;
         cntrl0_WDF_ALMOST_FULL    : out std_logic;
         cntrl0_AF_ALMOST_FULL     : out std_logic;
         cntrl0_READ_DATA_VALID    : out std_logic;
         cntrl0_APP_WDF_WREN       : in std_logic;
         cntrl0_APP_AF_WREN        : in std_logic;
         cntrl0_BURST_LENGTH       : out std_logic_vector(2 downto 0);
         cntrl0_APP_AF_ADDR        : in std_logic_vector(35 downto 0);
         cntrl0_APP_WDF_DATA       : in std_logic_vector(143 downto 0);
         cntrl0_READ_DATA_FIFO_OUT : out std_logic_vector(143 downto 0);
         clk_0                     : in std_logic;
         clk_90                    : in std_logic;
         clk_200                   : in std_logic;
         dcm_lock                  : in std_logic;
         cntrl0_DDR_DQS            : inout std_logic_vector(17 downto 0);
         cntrl0_DDR_CK             : out std_logic_vector(0 downto 0);
         cntrl0_DDR_CK_N           : out std_logic_vector(0 downto 0)
         );
   end component;
   
   -- MIG2
   component mig
      port (                 
      cntrl0_ddr_dq                 : inout std_logic_vector(71 downto 0);
      cntrl0_ddr_a                  : out   std_logic_vector(12 downto 0);
      cntrl0_ddr_ba                 : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_cke                : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_cs_n               : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_ras_n              : out   std_logic;
      cntrl0_ddr_cas_n              : out   std_logic;
      cntrl0_ddr_we_n               : out   std_logic;
      cntrl0_ddr_reset_n            : out   std_logic;
      init_done                     : out   std_logic;
      sys_reset_in_n                : in    std_logic;
      cntrl0_clk_tb                 : out   std_logic;
      cntrl0_reset_tb               : out   std_logic;
      cntrl0_wdf_almost_full        : out   std_logic;
      cntrl0_af_almost_full         : out   std_logic;
      cntrl0_read_data_valid        : out   std_logic;
      cntrl0_app_wdf_wren           : in    std_logic;
      cntrl0_app_af_wren            : in    std_logic;
      cntrl0_burst_length_div2      : out   std_logic_vector(2 downto 0);
      cntrl0_app_af_addr            : in    std_logic_vector(35 downto 0);
      cntrl0_app_wdf_data           : in    std_logic_vector(143 downto 0);
      cntrl0_read_data_fifo_out     : out   std_logic_vector(143 downto 0);
      clk_0                         : in    std_logic;
      clk_90                        : in    std_logic;
      clk_200                       : in    std_logic;
      dcm_lock                      : in    std_logic;
      cntrl0_ddr_dqs                : inout std_logic_vector(17 downto 0);
      cntrl0_ddr_ck                 : out   std_logic_vector(0 downto 0);
      cntrl0_ddr_ck_n               : out   std_logic_vector(0 downto 0)
      );
   end component;

   -- interface signals which do not map directly
   signal mig_areset_n            : std_logic;
   signal mig_initdone            : std_logic;
   signal mig_DDR_A               : std_logic_vector(12 downto 0);
   signal mig_DDR_BA              : std_logic_vector(1 downto 0);
   signal mig_DDR_CS_N            : std_logic_vector(1 downto 0);
   signal mig_APP_WDF_WREN        : std_logic;
   signal mig_APP_AF_WREN         : std_logic;
   signal mig_APP_AF_ADDR         : std_logic_vector(35 downto 0);
   signal mig_APP_AF_ADDR_old     : std_logic_vector(35 downto 0);
   signal mig_APP_WDF_DATA        : std_logic_vector(143 downto 0);
   signal mig_WDF_ALMOST_FULL     : std_logic;
   signal mig_AF_ALMOST_FULL      : std_logic;
   signal mig_DDR_CK_P            : std_logic_vector(0 downto 0);
   signal mig_DDR_CK_N            : std_logic_vector(0 downto 0);      
   
begin
   
   -- user interface signal mappings
   CORE_AFULL <= mig_WDF_ALMOST_FULL or mig_AF_ALMOST_FULL or not mig_initdone;
   
   -- registering to break long combinational chains
   wrap_reg : process(MEM_CLK0)
   begin
      if (MEM_CLK0'event and MEM_CLK0 = '1') then
         if (mig_initdone = '1' and CORE_CMD_VALID = '1') then
            mig_APP_AF_WREN  <= CORE_CMD(2); -- write or read
            mig_APP_WDF_WREN <= CORE_CMD(2) and not CORE_CMD(1) and not CORE_CMD(0); -- write
            mig_APP_AF_ADDR_old <= '0' & CORE_CMD & "000" & CORE_ADDR(27 downto 10)& '0' & CORE_ADDR(9 downto 0);
            mig_APP_AF_ADDR <= '0' & CORE_CMD & "0000" & CORE_ADDR;
            mig_APP_WDF_DATA <= CORE_DATA_WR;
         else
            mig_APP_AF_WREN <= '0';
            mig_APP_WDF_WREN <= '0';
            mig_APP_AF_ADDR <= (others => '0');
            mig_APP_WDF_DATA <= (others => '0');
         end if;
      end if;
   end process wrap_reg;

   mig_areset_n <= not ARESET;
      
   -- MIG DDR side non-direct signal mappings
   DDR_BA               <= '0' & mig_DDR_BA;
   DDR_A                <= "000" & mig_DDR_A;
   DDR_CK_P             <= mig_DDR_CK_P(0);
   DDR_CK_N             <= mig_DDR_CK_N(0);
   DDR_CS_N             <= "11" & mig_DDR_CS_N;
   DDR_SA               <= (others => '0');
   DDR_SCL              <= '0';
   DDR_SDA              <= '0';
   CORE_INITDONE        <= mig_initdone;
   
--   -- instantiate the MIG core
--   mig_core: mem_interface_top
--      port map(
--      dly_ctrl_rdy              => open,
--      cntrl0_DDR_DQ             => DDR_DQ,
--      cntrl0_DDR_A              => mig_DDR_A,
--      cntrl0_DDR_BA             => mig_DDR_BA,
--      cntrl0_DDR_CKE            => DDR_CKE,
--      cntrl0_DDR_CS_N           => mig_DDR_CS_N,
--      cntrl0_DDR_RAS_N          => DDR_RAS_N,
--      cntrl0_DDR_CAS_N          => DDR_CAS_N,
--      cntrl0_DDR_WE_N           => DDR_WE_N,
--      cntrl0_DDR_RESET_N        => DDR_RESET_N,
--      init_done                 => mig_initdone,
--      SYS_RESET_IN_N            => mig_areset_n,
--      cntrl0_CLK_TB             => open,              -- this is simply clk_0 comming back out
--      cntrl0_RESET_TB           => open,              -- this is simply a sync reset synced to clk0
--      cntrl0_WDF_ALMOST_FULL    => mig_WDF_ALMOST_FULL,
--      cntrl0_AF_ALMOST_FULL     => mig_AF_ALMOST_FULL,
--      cntrl0_READ_DATA_VALID    => CORE_DATA_VLD,
--      cntrl0_APP_WDF_WREN       => mig_APP_WDF_WREN,
--      cntrl0_APP_AF_WREN        => mig_APP_AF_WREN,
--      cntrl0_BURST_LENGTH       => open,
--      cntrl0_APP_AF_ADDR        => mig_APP_AF_ADDR_old,
--      cntrl0_APP_WDF_DATA       => mig_APP_WDF_DATA,
--      cntrl0_READ_DATA_FIFO_OUT => CORE_DATA_RD,
--      clk_0                     => MEM_CLK0,
--      clk_90                    => MEM_CLK90,
--      clk_200                   => MEM_CLK_200M,
--      dcm_lock                  => mig_areset_n,
--      cntrl0_DDR_DQS            => DDR_DQS,
--      cntrl0_DDR_CK             => mig_DDR_CK_P,
--      cntrl0_DDR_CK_N           => mig_DDR_CK_N
--      );

   -- instantiate the MIG2 core
   mig_core: mig
      port map(                 
      cntrl0_ddr_dq             => DDR_DQ,
      cntrl0_ddr_a              => mig_DDR_A,
      cntrl0_ddr_ba             => mig_DDR_BA,
      cntrl0_ddr_cke            => DDR_CKE,
      cntrl0_ddr_cs_n           => mig_DDR_CS_N,
      cntrl0_ddr_ras_n          => DDR_RAS_N,
      cntrl0_ddr_cas_n          => DDR_CAS_N,
      cntrl0_ddr_we_n           => DDR_WE_N,
      cntrl0_ddr_reset_n        => DDR_RESET_N,
      init_done                 => mig_initdone,
      sys_reset_in_n            => mig_areset_n,
      cntrl0_clk_tb             => open,              -- this is simply clk_0 comming back out
      cntrl0_reset_tb           => open,              -- this is simply a sync reset synced to clk0
      cntrl0_wdf_almost_full    => mig_WDF_ALMOST_FULL,
      cntrl0_af_almost_full     => mig_AF_ALMOST_FULL,
      cntrl0_read_data_valid    => CORE_DATA_VLD,
      cntrl0_app_wdf_wren       => mig_APP_WDF_WREN,
      cntrl0_app_af_wren        => mig_APP_AF_WREN,
      cntrl0_burst_length_div2  => open,
      cntrl0_app_af_addr        => mig_APP_AF_ADDR,
      cntrl0_app_wdf_data       => mig_APP_WDF_DATA,
      cntrl0_read_data_fifo_out => CORE_DATA_RD,
      clk_0                     => MEM_CLK0,
      clk_90                    => MEM_CLK90,
      clk_200                   => MEM_CLK_200M,
      dcm_lock                  => mig_areset_n,
      cntrl0_ddr_dqs            => DDR_DQS,
      cntrl0_ddr_ck             => mig_DDR_CK_P,
      cntrl0_ddr_ck_n           => mig_DDR_CK_N
      );

end rtl;


