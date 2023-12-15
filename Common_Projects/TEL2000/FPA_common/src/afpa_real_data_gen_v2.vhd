------------------------------------------------------------------
--!   @file : afpa_real_data_gen_v2
--!   @brief  Ce module procure une economie considerable en ressources par raport à la version afpa_real_data_gen. Il est à utiliser avec afpa_data_deserializer_16chn_v2/afpa_data_deserializer_8chn_v2
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fpa_define.all;
use work.proxy_define.all;

entity afpa_real_data_gen_v2 is
   port(
      
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      FPA_INTF_CFG  : in fpa_intf_cfg_type;
      
      READOUT       : in std_logic;
      FPA_DIN       : in std_logic_vector(71 downto 0);   -- rentre en raison d'un echantillon par clock d'adc
      FPA_DIN_DVAL  : in std_logic;                       -- n'est plus utilisé puisque FPA_DIN trentre en raison d'un echantillon par periode de clock ADC.
      READOUT_INFO  : in readout_info_type;
      
      ENABLE        : in std_logic;
      
      FPA_DOUT_FVAL : out std_logic;
      FPA_DOUT      : out std_logic_vector(95 downto 0);
      FPA_DOUT_DVAL : out std_logic;
      
      STAT          : out std_logic_vector(7 downto 0)    
      
      );
end afpa_real_data_gen_v2;



architecture rtl of afpa_real_data_gen_v2 is
begin
   
   
   ----------------------------------------------------------------------
   -- outputs
   ----------------------------------------------------------------------
   FPA_DOUT_DVAL          <= FPA_DIN_DVAL; -- READOUT_INFO.SAMP_PULSE;                              -- les données sortent tout le temps. les flags permettront de distinguer le AOI du NAOI 
   FPA_DOUT_FVAL          <= READOUT_INFO.AOI.FVAL;
   
   FPA_DOUT(95)           <= '0';                                       -- non utilisé
   
   
   ----------------------------------------------------------------------
   -- Zone NAOI                                                       
   ----------------------------------------------------------------------                                                       
   FPA_DOUT(94 downto 82) <= READOUT_INFO.NAOI.SPARE;                   -- naoi_spares
   FPA_DOUT(81 downto 80) <= READOUT_INFO.NAOI.REF_VALID;               -- naoi_ref_valid
   FPA_DOUT(79)           <= READOUT_INFO.NAOI.STOP;                    -- naoi_stop 
   FPA_DOUT(78)           <= READOUT_INFO.NAOI.START;                   -- naoi_start
   FPA_DOUT(77)           <= READOUT_INFO.NAOI.DVAL;                    -- naoi_dval 
   
   
   ----------------------------------------------------------------------
   -- Zone AOI                                                       
   ----------------------------------------------------------------------
   FPA_DOUT(76 downto 62) <= READOUT_INFO.AOI.SPARE;                    -- aoi_spares  (nouvel ajout)
   FPA_DOUT(61)           <= READOUT_INFO.AOI.DVAL;                     -- aoi_dval    (nouvel ajout) 
   FPA_DOUT(60)           <= READOUT_INFO.AOI.EOF;                      -- aoi_eof
   FPA_DOUT(59)           <= READOUT_INFO.AOI.SOF;                      -- aoi_sof  
   FPA_DOUT(58)           <= READOUT_INFO.AOI.FVAL;                     -- fval
   FPA_DOUT(57)           <= READOUT_INFO.AOI.EOL;                      -- aoi_eol 
   FPA_DOUT(56)           <= READOUT_INFO.AOI.SOL;                      -- aoi_sol
   FPA_DOUT(55 downto 0)  <= FPA_DIN(55 downto 0);                      -- données écrites en aval (DEFINE_FPA_VIDEO_DATA_INVERTED a été renviyé au afpa_data_deserializer_16chn_v2 ou au afpa_data_deserializer_8chn_v2)
   
   
end rtl;
