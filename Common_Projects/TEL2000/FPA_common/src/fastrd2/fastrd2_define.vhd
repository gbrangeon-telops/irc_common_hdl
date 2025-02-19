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
   
   constant FPA_MCLK_NUM_MAX : integer:= 8;  --- Le max des nombres de domaines MCLK utilis�s dans tous les designs 
   
   
   type fastrd2_integer_array_type is array (FPA_MCLK_NUM_MAX-1 downto 0) of natural;
   
   ------------------------------------------------------------
   -- type de base pour caract�riser l'horloge detecteur
   ------------------------------------------------------------
   type fpa_clk_base_info_type is 
   record
      sof    : std_logic;
      eof    : std_logic;
      clk    : std_logic;
      clk_id : unsigned(3 downto 0);
   end record;
   
   type fastrd2_clk_array_type is array (FPA_MCLK_NUM_MAX-1 downto 0) of fpa_clk_base_info_type;
   type fastrd2_clk_std_array_type is array (FPA_MCLK_NUM_MAX-1 downto 0) of std_logic_vector(2 downto 0);
   
   ------------------------------------------------------------
   -- type pour grouper toutes les infos des horloges detecteur
   ------------------------------------------------------------
   type fpa_clk_info_type is 
   record
      mclk_source_rate_hz  : natural;
      
      -- master clock part
      mclk_rate_hz         : fastrd2_integer_array_type;
      mclk_rate_factor     : fastrd2_integer_array_type;
      mclk_rate_factor_m1  : fastrd2_integer_array_type;
      mclk_rate_factor_div2: fastrd2_integer_array_type;
      
      -- pixel clock part
      pclk_rate_hz         : fastrd2_integer_array_type;     
      pclk_rate_factor     : fastrd2_integer_array_type;
      pclk_rate_factor_m1  : fastrd2_integer_array_type;
      pclk_rate_factor_div2: fastrd2_integer_array_type;
   end record;
   
   ------------------------------------------------------------
   -- area  cfg                                                   
   ------------------------------------------------------------
   type area_cfg_type is
   record
      
      clk_id                         : unsigned(3 downto 0);    -- clk_id associ� � la zone decrite par la config
      
      -- delimiteurs de trames et de lignes
      sof_posf_pclk                  : unsigned(9 downto 0);     -- 
      eof_posf_pclk                  : unsigned(23 downto 0);    --
      sol_posl_pclk                  : unsigned(9 downto 0);     --
      eol_posl_pclk                  : unsigned(12 downto 0);    --
      
      -- position du debut et de la fin du pulse lsync
      lsync_start_posl_pclk          : unsigned(12 downto 0); 
      lsync_end_posl_pclk            : unsigned(12 downto 0);
      lsync_num                      : unsigned(12 downto 0);    -- le nombre de pulse Lsync � generer. 
      spare                          : unsigned(12 downto 0);    -- le nombre de pulse Lsync � generer. 
      
      -- lignes de debut et fin des zones    
      line_start_num                 : unsigned(9 downto 0);     -- 
      line_end_num                   : unsigned(12 downto 0);    -- 
      
      -- parametres divers
      readout_pclk_cnt_max           : unsigned(23 downto 0);   -- readout_pclk_cnt_max = taille en pclk de l'image incluant les pauses, les lignes non valides etc.. = (XSIZE/TAP_NUM + LOVH)* (YSIZE + FOVH) + 1  (un dernier PCLK pur finir)
      line_period_pclk               : unsigned(12 downto 0);    -- nombre de pclk =  XSIZE/TAP_NUM + LOVH)
      
   end record;
   
   ----------------------------------------------								
   -- Type raw_area and user_area
   ----------------------------------------------
   type area_type is
   record
      
      spare                : std_logic_vector(3 downto 0);
      adc_sample_num       : unsigned(3 downto 0);          -- compteur d'�chantillon d'ADC par pixel
      imminent_clk_change  : std_logic;                     -- permet de signaler 1 CLK � l'avance un changement d'horloge. Ce qui donne le temps d'arreter l'horloge courante et activer la prochaine. 
      imminent_aoi         : std_logic;                     -- permet de signaler 1 CLK � l'avance une entr�e en zone AOI. Ce qui donne le temps de se synchroniser sur l'horloge des ADCs
      
      sof                  : std_logic;        
      eof                  : std_logic;
      sol                  : std_logic;
      eol                  : std_logic;
      fval                 : std_logic;
      lval                 : std_logic;
      dval                 : std_logic;
      lsync                : std_logic;
      rd_end               : std_logic;
      line_cnt             : unsigned(12 downto 0);   -- numero de ligne
      line_pclk_cnt        : unsigned(12 downto 0);   -- compteur de coups d'horloge PCLK sur une ligne
      
   end record;   
   
   ----------------------------------------------								
   -- Type area_info_type
   ----------------------------------------------
   type area_info_type is
   record
      
      -- dval de area info au complet
      info_dval            : std_logic;             -- dit si tout l'enregistrement (tout le regroupement de champs de donn�es) est valide
      
      -- user_area info
      user                 : area_type;
      
      -- raw_area info
      raw                  : area_type;
      
      -- horloges associ�es
      clk_info             : fpa_clk_base_info_type;  -- 
      
   end record; 
   
   ----------------------------------------------								
   -- Type double_area_info_type
   ----------------------------------------------
   type double_area_info_type is
   record
      info_dval            : std_logic;
      present              : area_info_type;
      future               : area_info_type;
   end record; 
   
   ------------------------------------------
   -- functions --
   --------------------------------------------  
   function gen_fpa_clk_info_func(mclk_source_rate_hz : integer; pixnum_per_mclk_and_per_tap : integer; mclk_rate_hz : fastrd2_integer_array_type) return fpa_clk_info_type;
   function area_info_to_vector_func(area_info: area_info_type) return std_logic_vector;
   function vector_to_area_info_func(yy: std_logic_vector) return area_info_type;
   
end fastrd2_define;

package body fastrd2_define is
   
   ---------------------------------------------------------------------------------------------
   -- function de generation des infos relatives aux mclk
   --------------------------------------------------------------------------------------------- 
   function gen_fpa_clk_info_func(mclk_source_rate_hz : integer; pixnum_per_mclk_and_per_tap : integer; mclk_rate_hz : fastrd2_integer_array_type) return fpa_clk_info_type is
      variable yy : fpa_clk_info_type;
   begin
      
      -- reconduction des donn�es
      yy.mclk_source_rate_hz  := mclk_source_rate_hz ;
      yy.mclk_rate_hz         := mclk_rate_hz ;       
      
      -- calculs
      for ii in 0 to FPA_MCLK_NUM_MAX - 1 loop
         if  yy.mclk_rate_hz(ii) /= 0 then 
            
            yy.mclk_rate_factor(ii)       := integer(round(real(yy.mclk_source_rate_hz ) / real(yy.mclk_rate_hz(ii))));
            yy.mclk_rate_factor_div2(ii)  := yy.mclk_rate_factor(ii)/2;
            yy.mclk_rate_factor_m1(ii)    := yy.mclk_rate_factor(ii) - 1;
            
            yy.pclk_rate_hz(ii)           := pixnum_per_mclk_and_per_tap * yy.mclk_rate_hz(ii);
            yy.pclk_rate_factor(ii)       := integer(round(real(yy.mclk_source_rate_hz ) / real(yy.pclk_rate_hz(ii))));
            yy.pclk_rate_factor_div2(ii)  := yy.pclk_rate_factor(ii)/2;
            yy.pclk_rate_factor_m1(ii)    := integer(round(real(yy.mclk_source_rate_hz ) / real(yy.pclk_rate_hz(ii)))) - 1;
         else
            yy.pclk_rate_hz(ii)           := 0;
            yy.mclk_rate_factor(ii)       := 0;
            yy.pclk_rate_factor(ii)       := 0;
            yy.pclk_rate_factor_m1(ii)    := 0;
         end if;
      end loop;      
      return yy;
      
   end gen_fpa_clk_info_func;
   
   ---------------------------------------------------------------------------------------------
   -- area_info_to_vector_func
   --------------------------------------------------------------------------------------------- 
   function area_info_to_vector_func(area_info: area_info_type) return std_logic_vector is
      variable yy : std_logic_vector(68 downto 0);
   begin
      yy := 
      
      area_info.info_dval
      
      & area_info.user.spare 
      & std_logic_vector(area_info.user.adc_sample_num)                           
      & area_info.user.sof                  
      & area_info.user.eof                  
      & area_info.user.sol                  
      & area_info.user.eol                  
      & area_info.user.fval                 
      & area_info.user.lval
      & area_info.user.dval
      & area_info.user.rd_end
      
      & area_info.raw.spare
      & std_logic_vector(area_info.raw.adc_sample_num)
      & area_info.raw.imminent_clk_change  
      & area_info.raw.imminent_aoi            
      & area_info.raw.sof                  
      & area_info.raw.eof                  
      & area_info.raw.sol                  
      & area_info.raw.eol                  
      & area_info.raw.fval                 
      & area_info.raw.lval                 
      & area_info.raw.dval                 
      & area_info.raw.lsync 
      & area_info.raw.rd_end                
      & std_logic_vector(area_info.raw.line_cnt)             
      & std_logic_vector(area_info.raw.line_pclk_cnt)
      
      & std_logic_vector(area_info.clk_info.clk_id)
      & area_info.clk_info.sof
      & area_info.clk_info.eof
      & area_info.clk_info.clk;
      
      return yy;
      
   end area_info_to_vector_func;
   
   ---------------------------------------------------------------------------------------------
   -- vector_to_area_info_func
   --------------------------------------------------------------------------------------------- 
   function vector_to_area_info_func(yy: std_logic_vector) return area_info_type is
      variable area_info : area_info_type;
   begin      
      
      area_info.info_dval                  :=  yy(68);
      
      area_info.user.spare                 :=  yy(67 downto 64);
      area_info.user.adc_sample_num        :=  unsigned(yy(63 downto 60));
      area_info.user.sof                   :=  yy(59);
      area_info.user.eof                   :=  yy(58);
      area_info.user.sol                   :=  yy(57);
      area_info.user.eol                   :=  yy(56);
      area_info.user.fval                  :=  yy(55);
      area_info.user.lval                  :=  yy(54);
      area_info.user.dval                  :=  yy(53);
      area_info.user.rd_end                :=  yy(52);
      
      area_info.raw.spare                  :=  yy(51 downto 48);
      area_info.raw.adc_sample_num         :=  unsigned(yy(47 downto 44));
      area_info.raw.imminent_clk_change    :=  yy(43);
      area_info.raw.imminent_aoi           :=  yy(42);
      area_info.raw.sof                    :=  yy(41);
      area_info.raw.eof                    :=  yy(40);
      area_info.raw.sol                    :=  yy(39);
      area_info.raw.eol                    :=  yy(38);
      area_info.raw.fval                   :=  yy(37);
      area_info.raw.lval                   :=  yy(36);
      area_info.raw.dval                   :=  yy(35);
      area_info.raw.lsync                  :=  yy(34);
      area_info.raw.rd_end                 :=  yy(33);
      area_info.raw.line_cnt               :=  unsigned(yy(32 downto 20));    
      area_info.raw.line_pclk_cnt          :=  unsigned(yy(19 downto 7));
      
      area_info.clk_info.clk_id            :=  unsigned(yy(6 downto 3));
      area_info.clk_info.sof               :=  yy(2);
      area_info.clk_info.eof               :=  yy(1);
      area_info.clk_info.clk               :=  yy(0);
      
      return area_info;
      
   end vector_to_area_info_func;
   
end package body fastrd2_define;