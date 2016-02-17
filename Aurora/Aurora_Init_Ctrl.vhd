-------------------------------------------------------------------------------
--
-- Title       : Aurora_Init_Ctrl
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- SVN modified fields:
-- $Revision$
-- $Author$
-- $LastChangedDate$
--
-------------------------------------------------------------------------------
--
-- Description : This module is based on the file:
--            \Common_HDL\Aurora\aurora_402_2gb_v4_core\testbench\sample_tb.vhd
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library common_hdl;

entity Aurora_Init_Ctrl is
   port(            
      -- Calibration Block Interface
      --CALBLOCK_ACTIVE   : in  std_logic_vector(0 to 1);  -- We ignore this input.      
      RESET_CALBLOCKS   : out std_logic;
      RX_SIGNAL_DETECT  : out std_logic_vector(0 to 1);                          
      DRP_CLK           : in  STD_LOGIC;    
      CHANNEL_UP        : in  std_logic;
      
      -- PMA_INTERFACE
      PMA_INIT          : out std_logic;      
      USER_CLK          : in  std_logic;      
      
      AURORA_RESET      : out std_logic; -- This is synchronous to USER_CLK
      
      ARESET            : in  STD_LOGIC
      
      );
end Aurora_Init_Ctrl;

architecture RTL of Aurora_Init_Ctrl is     
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component double_sync
      generic(
         INIT_VALUE : BIT := '0');
      port(
         D : in std_logic;
         Q : out std_logic;
         RESET : in std_logic;
         CLK : in std_logic);
   end component;
   
   signal PMA_INITi : std_logic;
   signal Rst_Count : integer range 0 to 33_554_431; 
   
   signal user_rst : std_logic;
   signal drp_rst  : std_logic;
   
begin      
   
   sync_RST_user : sync_reset
   port map(ARESET => ARESET, SRESET => user_rst, CLK => USER_CLK); 
   
   sync_RST_aurora : sync_reset
   port map(ARESET => PMA_INITi, SRESET => AURORA_RESET, CLK => USER_CLK);    
   
   sync_RST_drp :  sync_reset
   port map(ARESET => ARESET, SRESET => drp_rst, CLK => DRP_CLK);   
    
   Init_Sequence : process(drp_rst, DRP_CLK)
   begin	       
      
      if drp_rst = '1' then
         Rst_Count <= 0;
         PMA_INITi <= '1';
         RESET_CALBLOCKS <= '1';
      elsif (rising_edge(DRP_CLK)) then
         if Rst_Count < 33_554_431 and CHANNEL_UP = '0' then
            Rst_Count <= Rst_Count + 1; 
         end if;         
         
         -- Hold PMA_INIT during 40 *REF_CLK* clock cycles (so let's say 10 DRP_CLK)
         if Rst_Count > 10 then
            PMA_INITi <= '0';
            RESET_CALBLOCKS <= '0';
         else
            PMA_INITi <= '1';
            RESET_CALBLOCKS <= '1';
         end if;    
         
         -- Reset if Channel doesn't come up.  
         if Rst_Count = 33_554_431 then
            Rst_Count <= 0;    
         end if;
                  
      end if;
      
   end process;   
   
   
   PMA_INIT <= PMA_INITi; 
   RX_SIGNAL_DETECT <= "11";
   
--   sync_calblocks : double_sync
--   port map(CLK => DRP_CLK, D => PMA_INITi, Q => RESET_CALBLOCKS, RESET => '0');   
   
end RTL;
