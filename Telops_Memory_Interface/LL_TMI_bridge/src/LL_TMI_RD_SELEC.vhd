-------------------------------------------------------------------------------
--
-- Title       : LL_TMI_RD_SELEC
-- Author      : Jean-Alexis Boulet/Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
library Common_HDL;
use Common_HDL.telops.all;

entity LL_TMI_RD_SELEC is
   generic(               
      XLEN : natural := 9;
      ALEN : natural := 21);     
   port(

      --------------------------------
      -- LL-TMI Read
      --------------------------------  
      RCFG_CONFIG_in       : in std_logic_vector(4 downto 0);   
      RCFG_CONTROL_in      : in std_logic_vector(2 downto 0);
      --------------------------------
      -- LL-TMI Read0
      --------------------------------         
      R0_CFG_START_ADD    : in std_logic_vector(ALEN-1 downto 0);
      R0_CFG_END_ADD      : in std_logic_vector(ALEN-1 downto 0);
      R0_CFG_STEP_ADD     : in std_logic_vector(XLEN-1 downto 0);
      R0_CFG_WIDTH        : in std_logic_vector(XLEN-1 downto 0);      
      R0_CFG_SKIP         : in std_logic_vector(ALEN-1 downto 0);      
      R0_CFG_DONE         : out  std_logic;                   
      R0_CFG_IN_PROGRESS  : out  std_logic;    

      
	   --------------------------------
      -- LL-TMI Read1
      --------------------------------   
      R1_CFG_START_ADD    : in std_logic_vector(ALEN-1 downto 0);
      R1_CFG_END_ADD      : in std_logic_vector(ALEN-1 downto 0);
      R1_CFG_STEP_ADD     : in std_logic_vector(XLEN-1 downto 0);
      R1_CFG_WIDTH        : in std_logic_vector(XLEN-1 downto 0);      
      R1_CFG_SKIP         : in std_logic_vector(ALEN-1 downto 0);      
      R1_CFG_DONE         : out  std_logic;                   
      R1_CFG_IN_PROGRESS  : out  std_logic;    
      
      
      --------------------------------
      -- LL-TMI Read output
      --------------------------------
      RCFG_CONFIG_out       : out std_logic_vector(4 downto 0);   
      RCFG_CONTROL_out      : out std_logic_vector(2 downto 0);   
      RCFG_START_ADD    : out std_logic_vector(ALEN-1 downto 0);
      RCFG_END_ADD      : out std_logic_vector(ALEN-1 downto 0);
      RCFG_STEP_ADD     : out std_logic_vector(XLEN-1 downto 0);
      RCFG_WIDTH        : out std_logic_vector(XLEN-1 downto 0);      
      RCFG_SKIP         : out std_logic_vector(ALEN-1 downto 0);      
      RCFG_DONE         : in  std_logic;                   
      RCFG_IN_PROGRESS  : in  std_logic; 

      --------------------------------
      -- TMI Switch
      --------------------------------        
      RD_SEL         : in std_logic;   

      ARESET         : in std_logic;
      CLK            : in std_logic       
      );
end LL_TMI_RD_SELEC;


architecture RTL of LL_TMI_RD_SELEC is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;      
 
   signal Rd_Sel_i : std_logic;
   signal sreset   : std_logic;
begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);    
   
   RCFG_CONFIG_out     <= RCFG_CONFIG_in;
   RCFG_CONTROL_out    <= RCFG_CONTROL_in;
   RCFG_START_ADD      <= R0_CFG_START_ADD   when Rd_Sel_i = '0' else R1_CFG_START_ADD;
   RCFG_END_ADD        <= R0_CFG_END_ADD     when Rd_Sel_i = '0' else R1_CFG_END_ADD;
   RCFG_STEP_ADD       <= R0_CFG_STEP_ADD    when Rd_Sel_i = '0' else R1_CFG_STEP_ADD;
   RCFG_WIDTH          <= R0_CFG_WIDTH       when Rd_Sel_i = '0' else R1_CFG_WIDTH;
   RCFG_SKIP           <= R0_CFG_SKIP        when Rd_Sel_i = '0' else R1_CFG_SKIP;
      
   R0_CFG_DONE         <= RCFG_DONE          when Rd_Sel_i = '0' else '0';
   R0_CFG_IN_PROGRESS  <= RCFG_IN_PROGRESS   when Rd_Sel_i = '0' else '0';
   R1_CFG_DONE         <= RCFG_DONE          when Rd_Sel_i = '1' else '0';
   R1_CFG_IN_PROGRESS  <= RCFG_IN_PROGRESS   when Rd_Sel_i = '1' else '0';
   
   
   
   process(CLK)
   begin
      if rising_edge(CLK) then         
         if (sreset = '1') then
            Rd_Sel_i <= '0';   
         else
            Rd_Sel_i <= RD_SEL;
         end if;  
      end if;
   end process;
   
end RTL;
