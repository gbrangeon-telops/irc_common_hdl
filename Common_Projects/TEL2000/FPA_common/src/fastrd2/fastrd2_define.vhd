---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$
-- $Id$
-- $URL$
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;

package fastrd2_define is
   
   
   constant FPA_MCLK_NUM_MAX : integer:= 3;  --- Le max des nombres de domaines MCLK utilisés dans tous les designs 
   
   type array_type is array (0 to FPA_MCLK_NUM_MAX - 1) of natural;
   
   ------------------------------------------------------------
   -- type pour grouper toutes les horloges detecteur
   ------------------------------------------------------------
   type fpa_mclk_grp_type is 
   record
      mclk : std_logic_vector(FPA_MCLK_NUM_MAX-1  downto 0);
      pclk : std_logic_vector(FPA_MCLK_NUM_MAX-1  downto 0);      
   end record;   
   
   ------------------------------------------------------------
   -- type pour grouper les param des horloges detecteur
   ------------------------------------------------------------
   type fpa_mclk_info_type is 
   record
      mclk_source_rate_khz : natural; 
      mclk_rate_khz        : array_type; 
      pclk_rate_khz        : array_type;
      mclk_rate_factor     : array_type;
      pclk_rate_factor     : array_type;
   end record;
   
   ------------------------------------------
   -- functions --
   --------------------------------------------  
   function gen_fpa_mclk_info_func(mclk_source_rate_khz: integer; pixnum_per_mclk_and_per_tap : integer; mclk_rate_khz: array_type) return fpa_mclk_info_type;
   
   
end fastrd2_define;

package body fastrd2_define is
   
   ---------------------------------------------------------------------------------------------
   -- function de generation des infos relatives aux mclk
   --------------------------------------------------------------------------------------------- 
   function gen_fpa_mclk_info_func(mclk_source_rate_khz: integer; pixnum_per_mclk_and_per_tap : integer; mclk_rate_khz: array_type) return fpa_mclk_info_type is
      variable yy : fpa_mclk_info_type;
   begin
      
      -- reconduction des données
      yy.mclk_source_rate_khz := mclk_source_rate_khz;
      yy.mclk_rate_khz        := mclk_rate_khz;       
      
      -- calculs
      for ii in 0 to FPA_MCLK_NUM_MAX - 1 loop
         if  yy.mclk_rate_khz(ii) /= 0 then 
            yy.pclk_rate_khz(ii)    := pixnum_per_mclk_and_per_tap * yy.mclk_rate_khz(ii);
            yy.mclk_rate_factor(ii) := integer(yy.mclk_source_rate_khz / yy.mclk_rate_khz(ii));
            yy.pclk_rate_factor(ii) := integer(yy.mclk_source_rate_khz / yy.pclk_rate_khz(ii));
         else
            yy.pclk_rate_khz(ii)    := 0;
            yy.mclk_rate_factor(ii) := 0;
            yy.pclk_rate_factor(ii) := 0;
         end if;
      end loop;      
      return yy;
      
   end gen_fpa_mclk_info_func;   
   
end package body fastrd2_define;