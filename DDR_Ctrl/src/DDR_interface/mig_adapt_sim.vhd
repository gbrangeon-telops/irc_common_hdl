---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: mig_adapt_sim.vhd
--  Use:  fake wrapper for MIG DDR core to adapt to our interfacing conventions
--        but which uses simple_mem instead of the real MIG core
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
library common_hdl;
use common_hdl.simple_mem;

entity mig_adapt is

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
      DLY_CTRL_RDY   : out std_logic;
      CORE_DATA_VLD  : out std_logic;
      CORE_DATA_RD   : out std_logic_vector(143 downto 0);
      CORE_AFULL      : out std_logic; 
      CORE_DATA_WR   : in std_logic_vector(143 downto 0);
      CORE_ADDR      : in std_logic_vector(27 downto 0);
      CORE_CMD       : in std_logic_vector(2 downto 0);
      CORE_CMD_VALID : in std_logic;
      CORE_DATA_REQ  : out std_logic;
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

architecture simple_sim of mig_adapt is
   
   -- set these constants to the max value, we simply truncate
   --constant USER_DATA_WIDTH : integer range 128 to 144 := 144; -- 128 or 144
   --constant USER_ADDR_WIDTH : integer range 25 to 27 := 27;
   
   constant USER_ADDR_WIDTH : integer := CORE_ADDR'length-1;
   constant USER_DATA_WIDTH : integer := CORE_DATA_WR'length;
   
   component simple_mem is
      generic(
         Sections_bits  : integer := 16;
         SectWidth_bits : integer := 11;
         data_bits : integer := 144;
         latency   : integer := 5);
      port(
         CLK            : in  std_logic;
         DATA_VLD       : out std_logic;
         DATA_RD        : out std_logic_vector(data_bits-1 downto 0);
         DATA_WR        : in  std_logic_vector(data_bits-1 downto 0);
         U_ADDR         : in  std_logic_vector(Sections_bits+SectWidth_bits-1 downto 0);
         U_CMD          : in  std_logic;
         U_CMD_VALID    : in  std_logic);
   end component;
   
begin                
   
   DLY_CTRL_RDY <= '1';
   
   inst_simple_mem : simple_mem
   generic map(
      Sections_bits  => USER_ADDR_WIDTH-11,
      SectWidth_bits => 11, -- because this is not DDR and BurstLength = 1 !!
      data_bits => USER_DATA_WIDTH,
      latency   => 5)
   port map(
      CLK => MEM_CLK0,
      DATA_VLD => CORE_DATA_VLD,
      DATA_RD => CORE_DATA_RD(USER_DATA_WIDTH-1 downto 0),
      DATA_WR => CORE_DATA_WR,
      U_ADDR => CORE_ADDR(USER_ADDR_WIDTH downto 1),
      U_CMD => CORE_CMD(0),
      U_CMD_VALID => CORE_CMD_VALID);
   
   -- other control signals to a sane value
   wrap_reg : process(MEM_CLK0)
   begin
      if (MEM_CLK0'event and MEM_CLK0 = '1') then
         CORE_DATA_REQ <= CORE_CMD_VALID and CORE_CMD(1); -- request data on write with one register delay
      end if;
   end process wrap_reg;
   
   CORE_AFULL <= '0'; 
   CORE_INITDONE <= not ARESET;
   
   
end simple_sim;


