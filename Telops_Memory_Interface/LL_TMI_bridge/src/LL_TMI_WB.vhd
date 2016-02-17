-------------------------------------------------------------------------------
--
-- Title       : LL_TMI_WB
-- Author      : Patrick Dubois
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

entity LL_TMI_WB is
   generic(               
      XLEN : natural := 9;
      ALEN : natural := 21);     
   port(
      --------------------------------
      -- Wishbone
      --------------------------------   
      WB_MOSI           : in  t_wb_mosi32;
      WB_MISO           : out t_wb_miso32;   
      --------------------------------
      -- LL-TMI Write
      --------------------------------       
      WCFG_START_ADD    : out std_logic_vector(ALEN-1 downto 0);
      WCFG_END_ADD      : out std_logic_vector(ALEN-1 downto 0);
      WCFG_STEP_ADD     : out std_logic_vector(XLEN downto 0);
      WCFG_WIDTH        : out std_logic_vector(XLEN-1 downto 0);      
      WCFG_SKIP         : out std_logic_vector(ALEN downto 0);      
      WCFG_CONTROL      : out std_logic_vector(2 downto 0);
      WCFG_CONFIG       : out std_logic_vector(4 downto 0);
      WCFG_DONE         : in  std_logic;       
      WCFG_IN_PROGRESS  : in  std_logic;    
      --------------------------------
      -- LL-TMI Read
      --------------------------------         
      RCFG_START_ADD    : out std_logic_vector(ALEN-1 downto 0);
      RCFG_END_ADD      : out std_logic_vector(ALEN-1 downto 0);
      RCFG_STEP_ADD     : out std_logic_vector(XLEN downto 0);
      RCFG_WIDTH        : out std_logic_vector(XLEN-1 downto 0);      
      RCFG_SKIP         : out std_logic_vector(ALEN downto 0);      
      RCFG_CONTROL      : out std_logic_vector(2 downto 0);
      RCFG_DONE         : in  std_logic;                   
      RCFG_IN_PROGRESS  : in  std_logic;    
      RCFG_CONFIG       : out std_logic_vector(4 downto 0);
      --------------------------------
      -- TMI Switch
      --------------------------------        
      SW_SEL         : out std_logic_vector(1 downto 0);   
      --------------------------------
      -- Others
      --------------------------------        
      WERROR         : in  std_logic;    -- To be mapped to a Wishbone register
      RERROR         : in  std_logic;    -- To be mapped to a Wishbone register
      ERROR          : out std_logic;    -- Single bit, OR of every possible errors.
      
      ARESET         : in std_logic;
      CLK            : in std_logic       
      );
end LL_TMI_WB;


architecture RTL of LL_TMI_WB is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;      
   
   
   signal rStatus : std_logic_vector(5 downto 0);  -- rStatus(0) = Werror
                                                   -- rStatus(1) = Rerror
                                                   -- rStatus(2) = WCFG_DONE
                                                   -- rStatus(3) = RCFG_DONE   
                                                   -- rStatus(4) = WCFG_IN_PROGRESS
                                                   -- rStatus(5) = RCFG_IN_PROGRESS                                                   
   signal rWCFG_start_add : std_logic_vector(ALEN-1 downto 0);
   signal rWCFG_end_add   : std_logic_vector(ALEN-1 downto 0);
   signal rWCFG_step_add   : std_logic_vector(XLEN downto 0);
   signal rWCFG_width     : std_logic_vector(XLEN-1 downto 0);
   signal rWCFG_skip      : std_logic_vector(ALEN downto 0);
   signal rWCFG_control   : std_logic_vector(2 downto 0);
   signal rWCFG_config    : std_logic_vector(4 downto 0);
   signal rRCFG_start_add : std_logic_vector(ALEN-1 downto 0);
   signal rRCFG_end_add   : std_logic_vector(ALEN-1 downto 0);
   signal rRCFG_step_add   : std_logic_vector(XLEN downto 0);
   signal rRCFG_width     : std_logic_vector(XLEN-1 downto 0);
   signal rRCFG_skip      : std_logic_vector(ALEN downto 0);
   signal rRCFG_control   : std_logic_vector(2 downto 0);
   signal rRCFG_config    : std_logic_vector(4 downto 0);
   
   signal rSwitch : std_logic_vector(1 downto 0);
   
   signal sreset : std_logic;
   signal wr_ack : std_logic;
   signal rd_ack : std_logic; 
   
   
begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);    
   
   ERROR <= WERROR or RERROR;
   SW_SEL <= rSwitch;
   
   WCFG_START_ADD <= rWCFG_start_add;
   WCFG_END_ADD   <= rWCFG_end_add;
   WCFG_STEP_ADD   <= rWCFG_step_add;
   WCFG_WIDTH     <= rWCFG_width;
   WCFG_SKIP      <= rWCFG_skip;
   WCFG_CONTROL   <= rWCFG_control;
   WCFG_CONFIG    <= rWCFG_config;

   RCFG_START_ADD <= rRCFG_start_add;
   RCFG_END_ADD   <= rRCFG_end_add;
   RCFG_STEP_ADD   <= rRCFG_step_add;
   RCFG_WIDTH     <= rRCFG_width;
   RCFG_SKIP      <= rRCFG_skip;
   RCFG_CONTROL   <= rRCFG_control;
   RCFG_CONFIG    <= rRCFG_config;
   
   WB_MISO.ACK <= wr_ack or rd_ack;
   
   wb_wr : process(CLK)
   begin
      if rising_edge(CLK) then         
         if (sreset = '1') then
            rWCFG_start_add <= (others => '0');
            rWCFG_end_add <= (others => '0');  
            rWCFG_step_add <= (others => '0');
            rWCFG_width <= (others => '0');    
            rWCFG_skip <= (others => '0');     
            rWCFG_control <= (others => '0');  
            rWCFG_config <= (others => '0');   
            rRCFG_start_add <= (others => '0');
            rRCFG_end_add <= (others => '0');
            rRCFG_step_add <= (others => '0');  
            rRCFG_width <= (others => '0');    
            rRCFG_skip <= (others => '0');     
            rRCFG_control <= (others => '0'); 
            rRCFG_config <= (others => '0');
            rSwitch <= (others => '0');
            wr_ack <= '0';
         else
            wr_ack <= '0';
            if( (WB_MOSI.STB and WB_MOSI.WE) = '1') then -- Master write
               wr_ack <= '1';
               case WB_MOSI.ADR(7 downto 0) is
                  when X"00" =>
                  rWCFG_control <= WB_MOSI.DAT(2 downto 0);
                  when X"04" =>
                  rWCFG_start_add <= WB_MOSI.DAT(ALEN-1 downto 0);
                  when X"08" =>
                  rWCFG_config <= WB_MOSI.DAT(4 downto 0);
                  when X"0C" =>
                  rWCFG_end_add <= WB_MOSI.DAT(ALEN-1 downto 0);
                  when X"10" =>
                  rWCFG_step_add <= WB_MOSI.DAT(WB_MISO.DAT'length-1) & WB_MOSI.DAT(XLEN-1 downto 0);    --SIGNED BIT from int_32
                  when X"14" =>
                  rWCFG_width <= WB_MOSI.DAT(XLEN-1 downto 0);
                  when X"18" =>
                  rWCFG_skip <= WB_MOSI.DAT(WB_MISO.DAT'length-1) & WB_MOSI.DAT(ALEN-1 downto 0);        --SIGNED BIT from int_32
                  when X"1C" =>
                  rRCFG_control <= WB_MOSI.DAT(2 downto 0);
                  when X"20" =>
                  rRCFG_config <= WB_MOSI.DAT(4 downto 0);
                  when X"24" =>
                  rRCFG_start_add <= WB_MOSI.DAT(ALEN-1 downto 0);
                  when X"28" =>
                  rRCFG_end_add <= WB_MOSI.DAT(ALEN-1 downto 0);
                  when X"2C" =>
                  rRCFG_step_add <= WB_MOSI.DAT(WB_MISO.DAT'length-1) & WB_MOSI.DAT(XLEN-1 downto 0);    --SIGNED BIT from int_32
                  when X"30" =>
                  rRCFG_width <= WB_MOSI.DAT(XLEN-1 downto 0);
                  when X"34" =>
                  rRCFG_skip <= WB_MOSI.DAT(WB_MISO.DAT'length-1) & WB_MOSI.DAT(ALEN-1 downto 0); --SIGNED BIT from int_32
                  when X"38" =>
                  rSwitch <= WB_MOSI.DAT(1 downto 0);
                  when others => --do nothing
               end case;
            end if;
         end if;
      end if;
   end process;
   
   wb_rd : process(CLK)
   begin 
      if rising_edge(CLK) then        
         if (sreset = '1') then
            WB_MISO.DAT <= (others => '0');
            rd_ack <= '0';
            rStatus <= (others => '0');
         else
            rStatus <= RCFG_IN_PROGRESS & WCFG_IN_PROGRESS & RCFG_DONE & WCFG_DONE & RERROR & WERROR;
            rd_ack <= '0';
            if (WB_MOSI.STB = '1' and WB_MOSI.WE = '0') then              
               rd_ack <= '1';
               WB_MISO.DAT <= (others => '0');
               case WB_MOSI.ADR(7 downto 0) is
                  when X"00" =>
                  WB_MISO.DAT(2 downto 0) <= rWCFG_control;
                  when X"04" =>
                  WB_MISO.DAT(ALEN-1 downto 0) <= rWCFG_start_add;
                  when X"08" =>
                  WB_MISO.DAT(4 downto 0) <= rWCFG_config;
                  when X"0C" =>
                  WB_MISO.DAT(ALEN-1 downto 0) <= rWCFG_end_add;
                  when X"10" =>
                  WB_MISO.DAT(XLEN-1 downto 0) <= rWCFG_step_add(XLEN-1 downto 0);
                  WB_MISO.DAT(WB_MISO.DAT'length-1) <= rWCFG_step_add(XLEN);
                  when X"14" =>
                  WB_MISO.DAT(XLEN-1 downto 0) <= rWCFG_width;
                  when X"18" =>
                  WB_MISO.DAT(ALEN-1 downto 0) <= rWCFG_skip(ALEN-1 downto 0);
                  WB_MISO.DAT(WB_MISO.DAT'length-1) <= rWCFG_skip(ALEN);
                  when X"1C" =>
                  WB_MISO.DAT(2 downto 0) <= rRCFG_control;
                  when X"20" =>
                  WB_MISO.DAT(4 downto 0) <= rRCFG_config;
                  when X"24" =>
                  WB_MISO.DAT(ALEN-1 downto 0) <= rRCFG_start_add;
                  when X"28" =>
                  WB_MISO.DAT(ALEN-1 downto 0) <= rRCFG_end_add;
                  when X"2C" =>
                  WB_MISO.DAT(XLEN-1 downto 0) <= rRCFG_step_add(XLEN-1 downto 0);
                  WB_MISO.DAT(WB_MISO.DAT'length-1) <= rRCFG_step_add(XLEN);
                  when X"30" =>
                  WB_MISO.DAT(XLEN-1 downto 0) <= rRCFG_width;
                  when X"34" =>
                  WB_MISO.DAT(ALEN-1 downto 0) <= rRCFG_skip(ALEN-1 downto 0);
                  WB_MISO.DAT(WB_MISO.DAT'length-1) <= rRCFG_skip(ALEN);
                  when X"38" =>
                  WB_MISO.DAT(1 downto 0) <= rSwitch;
                  when X"3C" =>
                  WB_MISO.DAT(5 downto 0) <= rStatus;
                  when others => --do nothing
               end case; 
            end if;      
         end if;
      end if;
   end process;   
   
end RTL;
