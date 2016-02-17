-------------------------------------------------------------------------------
--
-- Title       : ll_rand
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : This module is meant to add variable AFULL/BUSY signals in
--               a LocalLink dataflow for simulation purposes.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;  
-- pragma translate_off
use ieee.math_real.trunc; 
library Aldec;
use aldec.random_pkg.all;
use ieee.std_logic_arith.conv_std_logic_vector;
-- pragma translate_on       
library Common_HDL;
use Common_HDL.Telops.all;

entity ll_rand is
   generic(
      Random : boolean := FALSE
      );
   port(
      CLK : in STD_LOGIC;
      --ARESET : in STD_LOGIC;
      RX_LL_MOSI : in t_ll_mosi;
      TX_LL_MISO : in t_ll_miso;
      RX_LL_MISO : out t_ll_miso;
      TX_LL_MOSI : out t_ll_mosi
      );
end ll_rand;


architecture ll_rand of ll_rand is
   
   signal rand : std_logic;
   signal random_std : std_logic_vector(7 downto 0);
   signal TX_LL_MISOi : t_ll_miso;
   
begin    
   rand <= random_std(0); 
   --TX_LL_MOSI <= RX_LL_MOSI;
   RX_LL_MISO <= TX_LL_MISOi;
   
--   TX_LL_MISOi.BUSY <= TX_LL_MISO.BUSY;
--   TX_LL_MISOi.AFULL <= TX_LL_MISO.AFULL or rand_afull;

   TX_LL_MISOi.BUSY <= TX_LL_MISO.BUSY or rand;
   TX_LL_MISOi.AFULL <= TX_LL_MISO.AFULL;
   
   TX_LL_MOSI.SOF <= RX_LL_MOSI.SOF;
   TX_LL_MOSI.EOF <= RX_LL_MOSI.EOF;
   TX_LL_MOSI.DATA <= RX_LL_MOSI.DATA;
   TX_LL_MOSI.DVAL <= RX_LL_MOSI.DVAL and not TX_LL_MISOi.BUSY;
   
   uniform_prc: process(CLK)
      -- pragma translate_off
      -- parameters of waveform -----										 									  
      constant seed:	integer	:= 1;
      constant rlow:	integer	:= 0;
      constant rhigh:	integer	:= 100;
      --------------------------------
      
      variable vseed:	integer := seed;
      variable rlow_v:	integer := rlow;
      variable rhigh_v:	integer := rhigh;	
      variable r:			real;
      
      variable result:	integer;		
      -- pragma translate_on
   begin                    
      
      if rising_edge(CLK) then
         random_std(0) <= '0';   
         -- pragma translate_off
         if (rlow > rhigh) then
            rlow_v := rhigh;
            rhigh_v := rlow;
         end if;
         if (rhigh /= integer'high) then
            rhigh_v := rhigh + 1;
            uniform_p(vseed, rlow_v, rhigh_v, r);  
            if (r >= 0.0) then
               result := integer(trunc(r));
            else
               result := integer(trunc(r-1.0));
            end if;
            if (result < rlow_v) then result := rlow_v; end if;
            if (result >= rhigh_v) then result := rhigh_v-1; end if;
         elsif (rlow /= integer'low) then
            rlow_v := rlow - 1;
            uniform_p(vseed, rlow_v, rhigh_v, r);
            r := r + 1.0;
            if (r >= 0.0) then
               result := integer(trunc(r));
            else
               result := integer(trunc(r-1.0));
            end if;
            if (result <= rlow_v) then result := rlow_v+1; end if;
            if (result > rhigh_v) then result := rhigh_v; end if;
         else
            uniform_p(vseed, rlow_v, rhigh_v, r);
            r := (r + 2147483648.0)/4294967295.0;
            r := r*4294967296.0 - 2147483648.0;
            if (r >= 0.0) then
               result := integer(trunc(r));
            else
               result := integer(trunc(r-1.0));
            end if;
         end if;		
         
         -- main assigment(s):
         random_std <= conv_std_logic_vector(result, 8);	-- std_logic_vector  
         -- pragma translate_on
      end if;
   end process uniform_prc;  
   -- pragma translate_on
   
end ll_rand;
