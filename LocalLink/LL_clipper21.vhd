---------------------------------------------------------------------------------------------------
--
-- Title       : LL_21_to_16
-- Author      : Patrick Dubois
-- Company     : Université Laval-Faculté des Sciences et de Génie
--
---------------------------------------------------------------------------------------------------
--
-- Description :  This module will saturate any value that is greater than 32767 or lower than
--                -32768. It will saturate to either 0x7FFF (32767) or 0x8000 (-32768).
--                Values that are within the 16-bit range are left untouched.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;           
use IEEE.numeric_std.ALL;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_clipper21 is    
   generic(
      nBitsSat : natural := 16);
   port(        
      --------------------------------
      -- RX Interface
      --------------------------------
      EN_CLIP  : in  std_logic;     -- Enable signed data clipping to -32768 or 32767 (if nBitsSat = 16)
      RX_MISO  : out t_ll_miso;
      RX_MOSI  : in  t_ll_mosi21;       
      
      --------------------------------
      -- TX Interface
      --------------------------------		 
      TX_MOSI  : out t_ll_mosi21;
      TX_MISO  : in  t_ll_miso;
      
      --------------------------------
      -- Misc
      --------------------------------	
      CLK         : in std_logic;
      ARESET      : in std_logic      
      );
end LL_clipper21;

architecture RTL of LL_clipper21 is 
   
   signal RESET      : std_logic; 
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;   
   
   function clipper (x : signed; nBitsSat : natural) return signed is 
      -- This function returns the same number of bits as the input BUT clips the value to nBitsSat.
      constant nBitsIn  : integer := x'LENGTH; 
      variable y : signed(nBitsIn-1 downto 0); 
      
      constant MAX_VAL : signed(nBitsIn-1 downto 0) := to_signed(2**(nBitsSat-1) - 1, nBitsIn);
      constant MIN_VAL : signed(nBitsIn-1 downto 0) := to_signed(-(2**(nBitsSat-1)), nBitsIn);
   begin        
      
      if x > MAX_VAL then
         y := MAX_VAL;
      elsif x < MIN_VAL then
         y := MIN_VAL;
      else
         y := x;
      end if;         
      
      return y;      
   end clipper; 
   
   
begin     
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);
   
   TX_MOSI.SUPPORT_BUSY <= '1';
   RX_MISO.BUSY         <= TX_MISO.BUSY;
   RX_MISO.AFULL        <= TX_MISO.AFULL;                  
   
   main : process(CLK)
   begin  
      if rising_edge(CLK) then
         
         if TX_MISO.BUSY = '0' then -- Acts as a clock-enable
            if TX_MISO.AFULL = '0' then
               TX_MOSI.SOF  <= RX_MOSI.SOF;
               TX_MOSI.EOF  <= RX_MOSI.EOF;
               TX_MOSI.DVAL <= RX_MOSI.DVAL;
               if EN_CLIP = '1' then
                  TX_MOSI.DATA <= std_logic_vector(clipper(signed(RX_MOSI.DATA), nBitsSat));
               else
                  TX_MOSI.DATA <= RX_MOSI.DATA;
               end if;
            else   
               TX_MOSI.DVAL <= '0';   
            end if;
         end if;                  
         
         if RESET = '1' then
            TX_MOSI.DVAL <= '0';   
         end if;
      end if;
   end process;           
   
   
end RTL;
