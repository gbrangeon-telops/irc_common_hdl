-------------------------------------------------------------------------------
--
-- Title       : neg_float32
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity neg_float32 is
   generic(                       
      complex_flow : boolean := true; -- If true, then neg_real and neg_imag options are used, otherwise always negate.
      neg_real    : boolean := false;
      neg_imag    : boolean := false
      );
   port(
      RX_LL_MOSI  : in  t_ll_mosi32;
      RX_LL_MISO  : out t_ll_miso;
      
      TX_LL_MOSI  : out t_ll_mosi32;
      TX_LL_MISO  : in  t_ll_miso;
      
      ARESET      : in std_logic;
      CLK         : in std_logic
      );
end neg_float32;     

-- pragma translate_off
library IEEE_proposed;
use ieee_proposed.float_pkg.all;
-- pragma translate_on

architecture RTL of neg_float32 is
   signal Sel : std_logic;    
   signal data_buf : std_logic_vector(31 downto 0);
   -- pragma translate_off
   signal data_buf_real : real; 
   -- pragma translate_on   
begin
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   TX_LL_MOSI.SOF <= RX_LL_MOSI.SOF;
   TX_LL_MOSI.EOF <= RX_LL_MOSI.EOF;
   TX_LL_MOSI.DATA <= data_buf;
   TX_LL_MOSI.DVAL <= RX_LL_MOSI.DVAL;      
   
   RX_LL_MISO <= TX_LL_MISO;
   
   data_buf(30 downto 0) <= RX_LL_MOSI.DATA(30 downto 0);
   data_buf(31) <= not RX_LL_MOSI.DATA(31) when (not complex_flow or (complex_flow and ((neg_real and Sel='0') or (neg_imag and Sel='1'))  )) else RX_LL_MOSI.DATA(31);
   
   -- pragma translate_off      
   data_buf_real <= to_real(to_float(data_buf));         
   -- pragma translate_on   
   
   process(CLK, ARESET)      
   begin
      if ARESET = '1' then
         Sel <= '0';
      elsif rising_edge(CLK) then
         if RX_LL_MOSI.DVAL='1' and TX_LL_MISO.BUSY='0' and complex_flow then
            Sel <= not Sel;   
         end if; 
         -- pragma translate_off
         assert (RX_LL_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;                        
         -- pragma translate_on         
      end if;
   end process;
   
end RTL;
