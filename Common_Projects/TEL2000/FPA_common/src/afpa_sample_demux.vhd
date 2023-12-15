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
use work.proxy_define.all;
use work.fpa_common_pkg.all;

entity afpa_sample_demux is
   port(
      ARESET        : in std_logic;
      CLK           : in std_logic;
           
      RX_MOSI       : in t_ll_area_mosi72;
      RX_MISO       : out t_ll_area_miso;
      
      PIX_MOSI      : out t_ll_ext_mosi72;
      PIX_MISO      : in t_ll_ext_miso;
      
      REF0_MOSI     : out t_ll_ext_mosi72;
      REF0_MISO     : in t_ll_ext_miso;
      
      REF1_MOSI     : out t_ll_ext_mosi72;
      REF1_MISO     : in t_ll_ext_miso
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
   PIX_MOSI.DATA <= RX_MOSI.DATA;
   PIX_MOSI.SOF  <= RX_MOSI.AOI_SOF;
   PIX_MOSI.EOF  <= RX_MOSI.AOI_EOF;
   PIX_MOSI.SOL  <= RX_MOSI.AOI_SOL;
   PIX_MOSI.EOL  <= RX_MOSI.AOI_EOL;
   PIX_MOSI.DVAL <= RX_MOSI.AOI_DVAL;
   PIX_MOSI.MISC <= '0'&RX_MOSI.AOI_SPARE;
   PIX_MOSI.SUPPORT_BUSY  <= RX_MOSI.SUPPORT_BUSY;
   RX_MISO.AFULL <= '0'; --PIX_MISO.AFULL;
   RX_MISO.BUSY  <= '0'; --PIX_MISO.BUSY;
   
   ------------------------------------------------------
   -- non AOI :reference 0 
   ------------------------------------------------------
   REF0_MOSI.DATA <= RX_MOSI.DATA;
   REF0_MOSI.SOF  <= RX_MOSI.NAOI_START and RX_MOSI.NAOI_DVAL;
   REF0_MOSI.EOF  <= RX_MOSI.NAOI_STOP and RX_MOSI.NAOI_DVAL;
   REF0_MOSI.SOL  <= '0';
   REF0_MOSI.EOL  <= '0';
   REF0_MOSI.DVAL <= RX_MOSI.NAOI_DVAL and RX_MOSI.NAOI_REF_VALID(0);
   REF0_MOSI.MISC <= "00" & RX_MOSI.NAOI_SPARE & RX_MOSI.NAOI_REF_VALID(0);
   REF0_MOSI.SUPPORT_BUSY  <= RX_MOSI.SUPPORT_BUSY;    
   
   ------------------------------------------------------
   -- non AOI :reference 1 
   ------------------------------------------------------
   REF1_MOSI.DATA <= RX_MOSI.DATA;
   REF1_MOSI.SOF  <= RX_MOSI.NAOI_START and RX_MOSI.NAOI_DVAL;
   REF1_MOSI.EOF  <= RX_MOSI.NAOI_STOP and RX_MOSI.NAOI_DVAL;
   REF1_MOSI.SOL  <= '0';
   REF1_MOSI.EOL  <= '0';
   REF1_MOSI.DVAL <= RX_MOSI.NAOI_DVAL and RX_MOSI.NAOI_REF_VALID(1);
   REF1_MOSI.MISC <= "00" & RX_MOSI.NAOI_SPARE & RX_MOSI.NAOI_REF_VALID(1);
   REF1_MOSI.SUPPORT_BUSY  <= RX_MOSI.SUPPORT_BUSY;   
   
end rtl;
