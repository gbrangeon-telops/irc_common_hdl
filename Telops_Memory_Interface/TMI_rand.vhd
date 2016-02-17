-------------------------------------------------------------------------------
--
-- Title       : TMI_rand
-- Author      : Simon Savary
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$
-------------------------------------------------------------------------------
--
-- Description : bloc pour ralentir le flot TMI en générant un signal TMI_BUSY 
--                pseudo-aléatoire
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  
library Common_HDL;
use Common_HDL.all;


entity TMI_rand is  
   generic(            
      Random : boolean := true;
      random_seed : std_logic_vector(3 downto 0) := x"1"; -- --Pseudo-random generator seed
      BUSY_DURATION : integer := 20;  -- Duration of TMI_BUSY signal in clock cycles
      DLEN : natural := 32;
      ALEN : natural := 21);     
   port(
      
      TMI_IN_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI_IN_RNW       : in  std_logic;
      TMI_IN_DVAL      : in  std_logic;
      TMI_IN_BUSY      : out std_logic;
      TMI_IN_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI_IN_RD_DVAL   : out std_logic; 
      TMI_IN_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);   
      TMI_IN_IDLE      : out std_logic;
      TMI_IN_ERROR     : out std_logic;
      
      TMI_OUT_ADD        : out std_logic_vector(ALEN-1 downto 0);
      TMI_OUT_RNW        : out std_logic;
      TMI_OUT_DVAL       : out std_logic;
      TMI_OUT_BUSY       : in  std_logic;
      TMI_OUT_RD_DATA    : in  std_logic_vector(DLEN-1 downto 0);
      TMI_OUT_RD_DVAL    : in  std_logic;
      TMI_OUT_WR_DATA    : out std_logic_vector(DLEN-1 downto 0);
      TMI_OUT_IDLE       : in  std_logic;
      TMI_OUT_ERROR      : in  std_logic;    
      
      ARESET         : in std_logic;
      CLK            : in std_logic        
      );
end TMI_rand;


architecture rtl of TMI_rand is
   
   signal tmi_busy_s	: std_logic;
   signal lfsr     : std_logic_vector(15 downto 0) := (others => '0');   -- To avoid X in simulation
   signal lfsr_in  : std_logic;
   signal busy_cnt : unsigned(7 downto 0);
   signal sreset : std_logic;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   TMI_OUT_ADD <= TMI_IN_ADD;
   TMI_OUT_RNW <= TMI_IN_RNW;
   TMI_OUT_DVAL <= TMI_IN_DVAL;
   TMI_IN_RD_DATA <= TMI_OUT_RD_DATA;
   TMI_IN_RD_DVAL <= TMI_OUT_RD_DVAL;
   TMI_OUT_WR_DATA <= TMI_IN_WR_DATA;
   TMI_IN_IDLE <= TMI_OUT_IDLE;
   TMI_IN_ERROR <= TMI_OUT_ERROR;
   
   BusyEmulate_gen0 : if Random = false generate
      TMI_IN_BUSY <= TMI_OUT_BUSY;
   end generate BusyEmulate_gen0;
   
   BusyEmulate_gen1 : if Random = true generate 
      ------------------------------------------------
      -- Process for pseudo-random generator
      ------------------------------------------------
      lfsr_in <= lfsr(1) xor lfsr(2) xor lfsr(4) xor lfsr(15);
      process(CLK)
      begin
         if rising_edge(CLK) then
            lfsr(0) <= lfsr_in;
            lfsr(15 downto 2) <= lfsr(14 downto 1);
            
            if sreset = '1' then
               lfsr(0) <= random_seed(0); -- We need at least one '1' in the LFSR to activate it.
               lfsr(2) <= random_seed(1);
               lfsr(3) <= random_seed(2); 
               lfsr(5) <= random_seed(3);
            else
               lfsr(1) <= lfsr(0);   
            end if;
         end if;
      end process;			
      
      ------------------------------------------------
      -- Process to emulate a memory BUSY (TMI_BUSY)
      -- signal.
      ------------------------------------------------
      process(CLK)
      begin
         if rising_edge(CLK) then
            if sreset = '1' then
               tmi_busy_s <= '1'; -- Busy at reset time					
               busy_cnt <= (others =>'0');
            else					
               -- Count the busy signal duration				
               if tmi_busy_s = '1' then
                  busy_cnt <= busy_cnt + 1;
                  if busy_cnt = to_unsigned(BUSY_DURATION-1,8) then	-- Clear busy signal
                     busy_cnt <= (others =>'0');
                     tmi_busy_s <= '0';
                  end if;					
               elsif lfsr(7) = '1' then -- Randomly set busy signal						
                  tmi_busy_s <= '1';	
               end if;
            end if;
         end if;
      end process;
      TMI_IN_BUSY <= TMI_OUT_BUSY or tmi_busy_s;		
   end generate BusyEmulate_gen1;
   
end rtl;
