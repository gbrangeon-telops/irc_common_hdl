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

entity LL_21_to_16 is      
   generic(
      Saturate_Signed   : boolean := false -- If true, will treat the data as signed and will saturate to 32767 or -32768
      );
   port(        
      --------------------------------
      -- RX Interface
      -------------------------------- 
      RX_MISO  : out t_ll_miso;
      RX_MOSI  : in  t_ll_mosi21;       
      
      --------------------------------
      -- TX Interface
      --------------------------------		 
      TX_MOSI  : out t_ll_mosi;
      TX_MISO  : in  t_ll_miso;
      
      --------------------------------
      -- Misc
      --------------------------------	
      CLK         : in std_logic;
      ARESET      : in std_logic      
      );
end LL_21_to_16;

architecture RTL of LL_21_to_16 is 
   
   signal RESET      : std_logic; 

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
   
   signal tx_data21 : std_logic_vector(20 downto 0);
   
begin     
   
   sync_RST : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);
   
   TX_MOSI.SOF  <= RX_MOSI.SOF;
   TX_MOSI.EOF  <= RX_MOSI.EOF;
   TX_MOSI.DVAL <= RX_MOSI.DVAL;  
   
   RX_MISO.BUSY <= TX_MISO.BUSY;
   RX_MISO.AFULL <= TX_MISO.AFULL;                  
   
   gen_no_sat : if Saturate_Signed=false generate
      TX_MOSI.DATA <= RX_MOSI.DATA(TX_MOSI.DATA'range);
   end generate gen_no_sat;
   
   gen_sat : if Saturate_Signed generate            
      
      -- For saturating purposes, data is always assumed to be signed.
      -- This is okay because the reason for saturating is to correctly scale the FFT 21-bit data.
      -- When input data is unsigned (such as raw igm or calibrated spectra), data is assured not to saturate. 
      
      tx_data21 <= std_logic_vector(   clipper(signed(RX_MOSI.DATA),16)   ); 
      TX_MOSI.DATA <= tx_data21(15 downto 0);
      
--      Scale_Saturate : process (RX_MOSI.DATA
--         -- translate_off
--         ,RX_MOSI.DVAL, TX_MISO.BUSY
--         -- translate_on      
--         )
--         constant nBitsOut : integer := TX_MOSI.DATA'LENGTH;  
--         constant nBitsIn : integer := RX_MOSI.DATA'LENGTH;
--      begin        
--         if RX_MOSI.DATA(nBitsIn-1 downto nBitsOut) = (nBitsIn-1 downto nBitsOut => '0') or
--            RX_MOSI.DATA(nBitsIn-1 downto nBitsOut) = (nBitsIn-1 downto nBitsOut => '1') then
--            -- No saturation
--            TX_MOSI.DATA <= RX_MOSI.DATA(15 downto 0);
--         else
--            -- Saturation
--            TX_MOSI.DATA <= (RX_MOSI.DATA(nBitsIn-1),others=>not RX_MOSI.DATA(nBitsIn-1)); 
--            
--            -- pragma translate_off
--            if RX_MOSI.DVAL='1' and TX_MISO.BUSY='0' then
--               assert FALSE report "LL_21_to_16 block saturation!" severity ERROR;
--            end if;
--            -- pragma translate_on
--         end if; 
--      end process;
      
      -- translate_off
      process (CLK, ARESET)
         variable sign : std_logic;
      begin
         if ARESET = '1' then
         elsif rising_edge(CLK) then
            if RX_MOSI.DVAL = '1' and TX_MISO.BUSY = '0' then 
               sign := RX_MOSI.DATA(20);
               if sign = '0' then
                  assert (RX_MOSI.DATA(19 downto 16) = "0000") report "21 to 16-bit overflow!!" severity ERROR;
               else
                  assert (RX_MOSI.DATA(19 downto 16) = "1111") report "21 to 16-bit overflow!!" severity ERROR;
               end if;
            end if;
         end if;
      end process;
      -- translate_on  
      
   end generate gen_sat;
   
   
   
end RTL;
