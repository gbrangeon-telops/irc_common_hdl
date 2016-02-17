-------------------------------------------------------------------------------
--
-- Title       : LL_RandomDREM_32
-- Author      : ENO
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : This module adds randomness DREM signal. 
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all; 

entity LL_RandomDREM_32 is  
   generic(
      random_seed : std_logic_vector(3 downto 0) := x"7");
   
   port(     
      RX_MOSI  : in  t_ll_mosi32; 
      RX_MISO  : out t_ll_miso;
      
      TX_MOSI  : out t_ll_mosi32;
      TX_MISO  : in  t_ll_miso; 
      
      RANDOM   : in  std_logic;
      --FALL     : in  std_logic;
      
      ARESET   : in  std_logic;
      CLK      : in  std_logic
      );
end LL_RandomDREM_32;

architecture RTL of LL_RandomDREM_32 is         
   signal lfsr       : std_logic_vector(15 downto 0) := (others => '0');   -- To avoid X in simulation
   signal lfsr_drem  : std_logic_vector(1 downto 0)  := "01";
   signal lfsr_in    : std_logic;
   signal sreset     : std_logic;
   signal lfsr_busy2 : std_logic;
   signal TX_busy    : std_logic;
   
   attribute keep_hierarchy : string;
   attribute keep_hierarchy of RTL : architecture is "true";
   
begin     
   
   the_sync_RESET : entity sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK); 
   
   lfsr_in <= lfsr(1) xor lfsr(2) xor lfsr(4) xor lfsr(15);
   --lfsr_busy2 <= lfsr_busy or sreset;
   
   RX_MISO.AFULL  <= TX_MISO.AFULL;
   RX_MISO.BUSY   <= TX_MISO.BUSY;
   
   TX_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   TX_MOSI.SOF    <= RX_MOSI.SOF;
   TX_MOSI.EOF    <= RX_MOSI.EOF;
   TX_MOSI.DATA   <= RX_MOSI.DATA;
   TX_MOSI.DVAL   <= RX_MOSI.DVAL;          
   TX_MOSI.DREM   <= RX_MOSI.DREM when RANDOM='0'--lfsr_drem when RANDOM='1' 
                  else lfsr_drem ;--RX_MOSI.DREM;
   TX_busy        <= Uto0(TX_MISO.BUSY);
   process(CLK, ARESET)
   begin
      
      if rising_edge(CLK) then
         
       --  if TX_busy ='0' then 
            lfsr(0) <= lfsr_in;
            lfsr(15 downto 2) <= lfsr(14 downto 1); 
            
            if RANDOM = '1' then         
               lfsr_drem(1) <= lfsr(15);
            end if;
         --end if;  
         if sreset = '1' then
            lfsr(0) <= random_seed(0); -- We need at least one '1' in the LFSR to activate it.
            lfsr(2) <= random_seed(1);
            lfsr(3) <= random_seed(2); 
            lfsr(5) <= random_seed(3);
        -- else
        -- lfsr(1) <= lfsr(0);
         end if;
          lfsr(1) <= lfsr(0); 
      end if; 
      
   end process;      
   
end RTL;
