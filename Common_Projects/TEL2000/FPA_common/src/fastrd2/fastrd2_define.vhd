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
use ieee.MATH_REAL.all;

package fastrd2_define is
   
   
   constant FPA_MCLK_NUM_MAX : integer:= 8;  --- Le max des nombres de domaines MCLK utilisés dans tous les designs 
   
   type fastrd2_integer_array_type is array (FPA_MCLK_NUM_MAX-1 downto 0) of natural;
   
   ------------------------------------------------------------
   -- type de base pour caractériser l'horloge detecteur
   ------------------------------------------------------------
   type fpa_clk_base_info_type is 
   record
      sof : std_logic;
      eof : std_logic;
      clk : std_logic;   
   end record;
   
   type fastrd2_clk_array_type is array (FPA_MCLK_NUM_MAX-1 downto 0) of fpa_clk_base_info_type;
   
   ------------------------------------------------------------
   -- type pour grouper toutes les infos des horloges detecteur
   ------------------------------------------------------------
   type fpa_clk_info_type is 
   record
      mclk_source_rate_khz : natural;
      
      -- master clock part
      mclk                 : fastrd2_clk_array_type;             -- horloge avec sof et eof 
      mclk_rate_khz        : fastrd2_integer_array_type;
      mclk_rate_factor     : fastrd2_integer_array_type; 
      
      -- pixel clock part
      pclk                 : fastrd2_clk_array_type;             -- horloge avec sof et eof 
      pclk_rate_khz        : fastrd2_integer_array_type;     
      pclk_rate_factor     : fastrd2_integer_array_type;      
   end record;
   
   ------------------------------------------------------------
   -- area  cfg                                                   
   ------------------------------------------------------------
   type area_cfg_type is
   record
      -- parametres de window
      xstart                         : unsigned(12 downto 0); 
      ystart                         : unsigned(12 downto 0);
      xsize                          : unsigned(12 downto 0);
      ysize                          : unsigned(12 downto 0);      
      
      -- delimiteurs de trames et de lignes
      sof_posf_pclk                  : unsigned(9 downto 0);     -- 
      eof_posf_pclk                  : unsigned(23 downto 0);    --
      sol_posl_pclk                  : unsigned(9 downto 0);     --
      eol_posl_pclk                  : unsigned(12 downto 0);    --
      eol_posl_pclk_p1               : unsigned(12 downto 0);    -- eol_posl_pclk + 1      
      
      -- lignes de debut et fin des zones    
      line_start_num                 : unsigned(9 downto 0);    -- 
      line_end_num                   : unsigned(12 downto 0);    -- 
      
      -- parametres divers
      readout_pclk_cnt_max           : unsigned(23 downto 0);   -- readout_pclk_cnt_max = taille en pclk de l'image incluant les pauses, les lignes non valides etc.. = (XSIZE/TAP_NUM + LOVH)* (YSIZE + FOVH) + 1  (un dernier PCLK pur finir)
      line_period_pclk               : unsigned(12 downto 0);    -- nombre de pclk =  XSIZE/TAP_NUM + LOVH)
      window_lsync_num               : unsigned(12 downto 0);    -- le nombre de pulse Lsync à envoyer. Il vaut active_line_end_num puisqu'il n'y a pas de ligne non active après les lignes actives.   
   end record;
   
   ----------------------------------------------								
   -- Type raw_area and user_area
   ----------------------------------------------
   type area_type is
   record
      sof                  : std_logic;        
      eof                  : std_logic;
      sol                  : std_logic;
      eol                  : std_logic;
      fval                 : std_logic;
      lval                 : std_logic;
      dval                 : std_logic;
      lsync                : std_logic;
      line_cnt             : unsigned(12 downto 0);   -- numero de ligne
      line_pclk_cnt        : unsigned(12 downto 0);   -- compteur de coups d'horloge PCLK sur une ligne
      record_valid         : std_logic;               -- dit tout l'enregistrement (tout le regroupement de champs de données) est valide
      
      imminent_clk_change  : std_logic;               -- permet de signaler 1 CLK à l'avance un changement d'horloge
      imminent_aoi         : std_logic;               -- permet de signaler 1 CLK à l'avance une entrée en zone AOI.
      spare                : std_logic_vector(7 downto 0);
   end record;   
   
   ----------------------------------------------								
   -- Type window_area_type
   ----------------------------------------------
   type window_info_type is
   record
      -- raw_area info
      raw                  : area_type;                     
      
      -- user_area info
      user                 : area_type;
      
      -- horloges associées
      clk_id               : unsigned(3 downto 0);  -- ID de l'horloge à utiliser pour le pixel associé      
      
   end record;
   
   ------------------------------------------
   -- functions --
   --------------------------------------------  
   function gen_fpa_mclk_info_func(mclk_source_rate_khz: integer; pixnum_per_mclk_and_per_tap : integer; mclk_rate_khz: fastrd2_integer_array_type) return fpa_clk_info_type;
   
   
end fastrd2_define;

package body fastrd2_define is
   
   ---------------------------------------------------------------------------------------------
   -- function de generation des infos relatives aux mclk
   --------------------------------------------------------------------------------------------- 
   function gen_fpa_mclk_info_func(mclk_source_rate_khz: integer; pixnum_per_mclk_and_per_tap : integer; mclk_rate_khz: fastrd2_integer_array_type) return fpa_clk_info_type is
      variable yy : fpa_clk_info_type;
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