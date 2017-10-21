------------------------------------------------------------------
--!   @file : afpa_sample_demux
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
-----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.FPA_Define.all;
use work.fpa_common_pkg.all;

entity afpa_sample_demux is
   port(
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      FPA_INTF_CFG  : in fpa_intf_cfg_type;
      
      RX_MOSI       : in t_ll_area_mosi72;
      RX_MISO       : out t_ll_area_miso;
      
      AOI_MOSI      : out t_ll_ext_mosi72;
      AOI_MISO      : in t_ll_ext_miso;
      
      NON_AOI_MOSI  : out t_ll_ext_mosi72;
      NON_AOI_MISO  : in t_ll_ext_miso    
      );
end afpa_sample_demux;

architecture rtl of afpa_sample_demux is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   signal sreset			      : std_logic;
   
begin
   
   ------------------------------------------------------
   -- Sync reset
   ------------------------------------------------------
   sync_reset_map : sync_reset
   port map(
      ARESET => ARESET,
      CLK => CLK,
      SRESET => sreset
      ); 
   
   ------------------------------------------------------
   -- AOI
   ------------------------------------------------------ 
   AOI_MOSI.DATA <= RX_MOSI.DATA;
   AOI_MOSI.SOF  <= RX_MOSI.AOI_SOF;
   AOI_MOSI.EOF  <= RX_MOSI.AOI_EOF;
   AOI_MOSI.SOL  <= RX_MOSI.AOI_SOL;
   AOI_MOSI.EOL  <= RX_MOSI.AOI_EOL;
   AOI_MOSI.DVAL <= RX_MOSI.AOI_DVAL;
   AOI_MOSI.MISC <= '0'&RX_MOSI.AOI_SPARE;
   AOI_MOSI.SUPPORT_BUSY  <= RX_MOSI.SUPPORT_BUSY;
   RX_MISO.AFULL <= AOI_MISO.AFULL;
   RX_MISO.BUSY  <= AOI_MISO.BUSY;
   
   ------------------------------------------------------
   -- non AOI
   ------------------------------------------------------
   NON_AOI_MOSI.DATA <= RX_MOSI.DATA;
   NON_AOI_MOSI.SOF  <= RX_MOSI.NAOI_START;
   NON_AOI_MOSI.EOF  <= RX_MOSI.NAOI_STOP;
   NON_AOI_MOSI.SOL  <= '0';
   NON_AOI_MOSI.EOL  <= '0';
   NON_AOI_MOSI.DVAL <= RX_MOSI.NAOI_DVAL;
   NON_AOI_MOSI.MISC <= '0'&RX_MOSI.NAOI_SPARE;
   NON_AOI_MOSI.SUPPORT_BUSY  <= RX_MOSI.SUPPORT_BUSY;  
   
end rtl;
