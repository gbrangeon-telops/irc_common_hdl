------------------------------------------------------------------
--!   @file : afpa_lsync_mode_dval_gen
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity afpa_lsync_mode_dval_gen is
   port(
      
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      FPA_INTF_CFG  : in fpa_intf_cfg_type;
      
      READOUT       : in std_logic;
      FPA_DIN       : in std_logic_vector(57 downto 0);
      FPA_DIN_DVAL  : in std_logic;
      READOUT_INFO  : in readout_info_type;
      
      DIAG_MODE_EN  : in std_logic;
      
      FPA_DOUT      : out std_logic_vector(61 downto 0);
      FPA_DOUT_DVAL : out std_logic;
      
      FLUSH_FIFO    : out std_logic
      );
end afpa_lsync_mode_dval_gen;


architecture rtl of afpa_lsync_mode_dval_gen is
begin
   

   
   
end rtl;
