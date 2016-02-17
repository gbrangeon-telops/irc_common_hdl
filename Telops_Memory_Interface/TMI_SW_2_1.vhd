-------------------------------------------------------------------------------
--
-- Title       : TMI_SW_2_1
-- Author      : Patrick Dubois, Simon Savary
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

library ieee;
use ieee.std_logic_1164.all;
library Common_HDL;     
use Common_HDL.all;  

entity TMI_SW_2_1 is  
   generic(            
      DLEN : natural := 32;
      ALEN : natural := 21);     
   port(
      --------------------------------
      -- TMI in #1
      --------------------------------       
      TMI1_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI1_RNW       : in  std_logic;
      TMI1_DVAL      : in  std_logic;
      TMI1_BUSY      : out std_logic;
      TMI1_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI1_RD_DVAL   : out std_logic; 
      TMI1_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);   
      TMI1_IDLE      : out std_logic;
      TMI1_ERROR     : out std_logic;
      --------------------------------
      -- TMI in #2
      -------------------------------- 
      TMI2_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI2_RNW       : in  std_logic;      
      TMI2_DVAL      : in  std_logic;
      TMI2_BUSY      : out std_logic;
      TMI2_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI2_RD_DVAL   : out std_logic;                           
      TMI2_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);   
      TMI2_IDLE      : out std_logic;
      TMI2_ERROR     : out std_logic;      
      --------------------------------
      -- TMI out
      --------------------------------       
      TMI_ADD        : out std_logic_vector(ALEN-1 downto 0);
      TMI_RNW        : out std_logic;
      TMI_DVAL       : out std_logic;
      TMI_BUSY       : in  std_logic;
      TMI_RD_DATA    : in  std_logic_vector(DLEN-1 downto 0);
      TMI_RD_DVAL    : in  std_logic;
      TMI_WR_DATA    : out std_logic_vector(DLEN-1 downto 0);
      TMI_IDLE       : in  std_logic;
      TMI_ERROR      : in  std_logic;   
      --------------------------------
      -- Others
      --------------------------------       
      SEL            : in  std_logic_vector(1 downto 0);      
      ARESET         : in  std_logic;
      CLK            : in  std_logic        
      );
end TMI_SW_2_1;


architecture RTL of TMI_SW_2_1 is	   
   type state_t is (PORT1, PORT2, FINISH_TRANSACTION1,FINISH_TRANSACTION2);
   
   signal cs,ns : state_t := FINISH_TRANSACTION1;  -- Current state (cs), Next state (ns)
   signal sel_i : std_logic_vector(1 downto 0) := "00";
   signal sel_sync : std_logic_vector(1 downto 0) := "00";
   signal sel_sync_r1 : std_logic_vector(1 downto 0) := "00";
   
   signal tmi1_busy_i : std_logic;
   signal tmi2_busy_i : std_logic;
   signal tmi_busy_r1 : std_logic;
   signal tmi1_add_r1 : std_logic_vector(ALEN-1 downto 0);
   signal tmi2_add_r1 : std_logic_vector(ALEN-1 downto 0);
   signal tmi_rd_data_r1 : std_logic_vector(DLEN-1 downto 0);
   signal tmi1_wr_data_r1 : std_logic_vector(DLEN-1 downto 0);
   signal tmi2_wr_data_r1 : std_logic_vector(DLEN-1 downto 0);
   signal tmi1_dval_r1 : std_logic;
   signal tmi2_dval_r1 : std_logic;
   signal tmi_rd_dval_r1 : std_logic;
   signal tmi1_rnw_r1 : std_logic;
   signal tmi2_rnw_r1 : std_logic;
   signal tmi_idle_r1 : std_logic;
   
   signal tmi1_dval_i : std_logic;
   signal tmi2_dval_i : std_logic;
   
   signal RESET : std_logic := '0';
   
   component double_sync_vector is
      port(
         D : in std_logic_vector;
         Q : out std_logic_vector;
         CLK : in std_logic
         );
   end component;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;  
begin 
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);
   
   sync_sel: double_sync_vector
   port map(D => SEL, Q => sel_sync, CLK => CLK); 
   
   -- stop listening to incoming commands if either client or the controller are busy
   tmi1_dval_i <= TMI1_DVAL and not TMI_BUSY and not tmi1_busy_i;
   tmi2_dval_i <= TMI2_DVAL and not TMI_BUSY and not tmi2_busy_i;
   
   TMI_ADD <= TMI1_ADD_r1 when sel_i(0) = '0' else TMI2_ADD_r1;
   TMI_RNW <= TMI1_RNW_r1 when sel_i(0) = '0' else TMI2_RNW_r1;
   TMI_DVAL <= tmi1_dval_r1 when sel_i(0) = '0' else tmi2_dval_r1;
   TMI_WR_DATA <= TMI1_WR_DATA_r1 when sel_i(0) = '0' else TMI2_WR_DATA_r1;
   TMI1_RD_DVAL <= TMI_RD_DVAL_r1 when sel_i(0) = '0' else '0';
   TMI2_RD_DVAL <= TMI_RD_DVAL_r1 when sel_i(0) = '1' else '0'; 
   
   TMI1_IDLE <= TMI_IDLE_r1;
   TMI2_IDLE <= TMI_IDLE_r1;
   
   TMI1_RD_DATA <= TMI_RD_DATA_r1;
   TMI2_RD_DATA <= TMI_RD_DATA_r1;
   
   TMI1_ERROR <= TMI_ERROR;
   TMI2_ERROR <= TMI_ERROR;
   
   TMI1_BUSY <= tmi1_busy_i;
   TMI2_BUSY <= tmi2_busy_i;
   
   -- process(CLK)
   --   begin
   --      if rising_edge(CLK) then
   tmi_busy_r1 <= TMI_BUSY;
   tmi1_add_r1 <= TMI1_ADD;
   tmi2_add_r1 <= TMI2_ADD;
   tmi_rd_data_r1 <= TMI_RD_DATA;
   tmi1_wr_data_r1 <= TMI1_WR_DATA;
   tmi2_wr_data_r1 <= TMI2_WR_DATA;
   tmi1_dval_r1 <= tmi1_dval_i;
   tmi2_dval_r1 <= tmi2_dval_i;
   tmi_rd_dval_r1 <= TMI_RD_DVAL;
   tmi1_rnw_r1 <= TMI1_RNW;
   tmi2_rnw_r1 <= TMI2_RNW;
   tmi_idle_r1 <= TMI_IDLE;
   sel_sync_r1 <= sel_sync;
   --    end if;
   --   end process;
   
   ------------------
   -- Assign next state to current state
   ------------------
   reg_sm: process(CLK)
   begin
      if rising_edge(CLK) then            
         if RESET = '1' then
            cs <= FINISH_TRANSACTION1;
         else
            cs <= ns;
         end if;            
      end if;
   end process;
   
   -------------------
   -- Asynchronous state machine
   -------------------
   comb_sm: process(cs,sel_sync,TMI_IDLE_r1,TMI_BUSY_r1,TMI1_DVAL_r1,TMI2_DVAL_r1)
   begin
      case cs is            
         when PORT1 =>
            if sel_sync = "01" then
               ns <= FINISH_TRANSACTION1;
            else
               ns <= PORT1;
            end if;
            
            tmi1_busy_i <= TMI_BUSY_r1;
            tmi2_busy_i <= '1';
            sel_i <= "00";
         
         when FINISH_TRANSACTION1 =>
            if TMI_IDLE_r1 = '1' then --and TMI1_DVAL_r1 = '0' then
               if sel_sync = "00" then
                  ns <= PORT1;
               else
                  ns <= PORT2;
               end if;
            else
               ns <= FINISH_TRANSACTION1;
            end if;
            
            tmi1_busy_i <= '1';
            tmi2_busy_i <= '1';
            sel_i <= "00";
         
         when FINISH_TRANSACTION2 =>
            if TMI_IDLE_r1 = '1'  then --and TMI2_DVAL_r1 = '0' then
               if sel_sync = "00" then
                  ns <= PORT1;
               else
                  ns <= PORT2;
               end if;
            else
               ns <= FINISH_TRANSACTION2;
            end if;
            
            tmi1_busy_i <= '1';
            tmi2_busy_i <= '1';
            
            sel_i <= "01";
         
         when PORT2 =>
            if sel_sync = "00" then
               ns <= FINISH_TRANSACTION2;
            else
               ns <= PORT2;
            end if;
            tmi1_busy_i <= '1';
            tmi2_busy_i <= TMI_BUSY_r1;
            sel_i <= "01";
         
         when others =>
            tmi1_busy_i <= '1';
            tmi2_busy_i <= '1';
            ns <= FINISH_TRANSACTION1;
            sel_i <= "00";
      end case;
   end process;
   
end RTL;
