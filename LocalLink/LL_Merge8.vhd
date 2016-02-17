-------------------------------------------------------------------------------
--
-- Title       : LL_Merge8
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : This block merges two LocalLink dataflow into one.
--               It will "open" one port when it detects a SOF on that port and
--               will let that port open until it detects its EOF. The priority
--               is given to RX1, unless RX1 just finished its stream
--               with EOF. In that case it will give priority to RX2.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_Merge8 is
   port(
      RX1_MOSI : in  t_ll_mosi8;
      RX1_MISO : out t_ll_miso;
      
      RX2_MOSI : in  t_ll_mosi8; 
      RX2_MISO : out t_ll_miso;
      
      TX_MOSI  : out t_ll_mosi8;
      TX_MISO  : in  t_ll_miso;
      
      ARESET   : in  std_logic;
      CLK      : in  std_logic
      );
end LL_Merge8;


architecture RTL of LL_Merge8 is   
   component SYNC_RESET is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   signal RX1_dval : std_logic;
   signal RX2_dval : std_logic;   
   signal RX1_busy : std_logic;
   signal RX2_busy : std_logic;
   signal RX1_block : std_logic;
   signal RX2_block : std_logic;      
   
   signal rx_priority : std_logic;
   
   signal sreset : std_logic;
   
   type State_t is (RX1_Priority, RX2_Priority, RX1_Flow, RX2_Flow);
   signal State : State_t;
   
begin              
   -- synchronize reset locally
   the_sync_reset : sync_reset port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   TX_MOSI.SUPPORT_BUSY <= '1';       
   RX1_dval <= RX1_MOSI.DVAL and not RX1_busy;
   RX2_dval <= RX2_MOSI.DVAL and not RX2_busy; 
   RX1_MISO.BUSY <= RX1_busy;
   RX2_MISO.BUSY <= RX2_busy;
   
   -- These statements will create a critical path on the BUSY signals.
   -- Add a fifo at the input of RX1 and RX2 if this is a problem.
   RX1_busy <= '1' when RX1_block='1' else
   TX_MISO.BUSY when RX_priority='0' else
   TX_MISO.BUSY or rx2_dval;
   
   RX2_busy <= '1' when RX2_block='1' else
   TX_MISO.BUSY when RX_priority='1' else
   TX_MISO.BUSY or rx1_dval;
   
   
   process(CLK)      
   begin
      if rising_edge(CLK) then  
         
         -- Unconditionnal statements
         RX1_MISO.AFULL <= TX_MISO.AFULL;  
         RX2_MISO.AFULL <= TX_MISO.AFULL; 
         
         if TX_MISO.BUSY = '0' then
            
            -- Default values
            TX_MOSI.SOF <= '0';
            TX_MOSI.EOF <= '0';  
            TX_MOSI.DVAL <= '0';
            
            -- State Machine
            case State is
               
               when RX1_Priority =>   
                  rx_priority <= '0';  
                  RX1_block <= '0';
                  RX2_block <= '0';              
                  if RX1_dval = '1' and RX1_MOSI.SOF = '1' then                         
                     TX_MOSI.SOF <= '1';
                     TX_MOSI.DATA <= RX1_MOSI.DATA;
                     TX_MOSI.DVAL <= '1';
                     RX2_block <= '1';
                     State <= RX1_Flow; 
                  elsif RX2_dval = '1' and RX2_MOSI.SOF = '1' then                      
                     TX_MOSI.SOF <= '1';
                     TX_MOSI.DATA <= RX2_MOSI.DATA;
                     TX_MOSI.DVAL <= '1';                         
                     rx_priority <= '1';
                     RX1_block <= '1';
                     State <= RX2_Flow; 
                  end if;
                  
               when RX2_Priority =>   
                  rx_priority <= '1'; 
                  RX1_block <= '0';
                  RX2_block <= '0';               
                  if RX2_dval = '1' and RX2_MOSI.SOF = '1' then
                     TX_MOSI.SOF <= '1';
                     TX_MOSI.DATA <= RX2_MOSI.DATA;
                     TX_MOSI.DVAL <= '1';   
                     RX1_block <= '1';
                     State <= RX2_Flow;  
                  elsif RX1_dval = '1' and RX1_MOSI.SOF = '1' then
                     TX_MOSI.SOF <= '1';
                     TX_MOSI.DATA <= RX1_MOSI.DATA;
                     TX_MOSI.DVAL <= '1'; 
                     rx_priority <= '0';  
                     RX2_block <= '1';
                     State <= RX1_Flow;                     
                  end if;               
                  
               when RX1_Flow =>  
                  RX2_block <= '1';
                  TX_MOSI.DATA <= RX1_MOSI.DATA;
                  TX_MOSI.DVAL <= RX1_MOSI.DVAL;   
                  TX_MOSI.EOF <= RX1_MOSI.EOF;
                  if RX1_dval = '1' and RX1_MOSI.EOF = '1' then 
                     rx_priority <= '1';     
                     RX1_block <= '0';
                     RX2_block <= '0';                  
                     State <= RX2_Priority;                    
                  end if;    
                  
               when RX2_Flow =>   
                  RX1_block <= '1';
                  TX_MOSI.DATA <= RX2_MOSI.DATA;
                  TX_MOSI.DVAL <= RX2_MOSI.DVAL;   
                  TX_MOSI.EOF <= RX2_MOSI.EOF;            
                  if RX2_dval = '1' and RX2_MOSI.EOF = '1' then
                     rx_priority <= '0';
                     RX1_block <= '0';
                     RX2_block <= '0';                    
                     State <= RX1_Priority;     
                  end if; 
                  
               when others => 
               State <= RX1_Priority;
            end case; 
            
         end if;
         
         -- Put the reset statement at the end to impact only the signals we care about.
         if sreset = '1' then 
            State <= RX1_Priority;    
            RX1_block <= '1';
            RX2_block <= '1';    
            rx_priority <= '0';
            TX_MOSI.DVAL <= '0';
         end if;       
         
         -- pragma translate_off
         assert (RX1_MOSI.SUPPORT_BUSY = '1') report "RX1 Upstream module must support the BUSY signal" severity FAILURE;               
         assert (RX2_MOSI.SUPPORT_BUSY = '1') report "RX2 Upstream module must support the BUSY signal" severity FAILURE;               
         -- pragma translate_on            
         
      end if;      
   end process;   
   
end RTL;
