------------------------------------------------------------------
--!   @file : afpa_offset_corr_core
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
use IEEE.numeric_std.all;
use work.fpa_define.ALL;
use work.fpa_common_pkg.all;

entity afpa_offset_corr_core is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
	   FPA_INTF_CFG   : in fpa_intf_cfg_type; 
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      LINE_POS       : in std_logic_vector(13 downto 0);
      ERR            : out std_logic
   );
end afpa_offset_corr_core;


architecture rtl of afpa_offset_corr_core is

   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
  
   component afpa_quad_subtract is
  	generic(
    	  G_SYNC_OPERAND : boolean := false
      	);
   	port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      OP_SEL         : in std_logic_vector(1 downto 0);
      
      RX1_MOSI       : in t_ll_ext_mosi72; 
      RX1_MISO       : out t_ll_ext_miso;
      
      RX2_MOSI       : in t_ll_ext_mosi72;
      RX2_MISO       : out t_ll_ext_miso;
      
      TX_MISO        : in t_ll_ext_miso;
      TX_MOSI        : out t_ll_ext_mosi72;
      
      ERR            : out std_logic
    );
   end component;

   signal sreset : std_logic := '1';
   signal line_start_i : std_logic_vector(13 downto 0);
   signal line_end_i   : std_logic_vector(13 downto 0);
   signal coeff0_i     : std_logic_vector(13 downto 0);
   signal line_pos_i   : std_logic_vector(13 downto 0);
   signal rx_mosi_i    : t_ll_ext_mosi72;  
   signal rx_miso_i    : t_ll_ext_miso;   
   signal tx_mosi_i    : t_ll_ext_mosi72;
   signal tx_miso_i    : t_ll_ext_miso;
   signal corr_active  : std_logic;
   signal op_sel_i     : std_logic_vector(1 downto 0);   
   signal rx1_mosi_i   : t_ll_ext_mosi72;
   signal rx1_miso_i   : t_ll_ext_miso;
   signal rx2_mosi_i   : t_ll_ext_mosi72;
   signal err_i        : std_logic;   

begin

    --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
   );

   --------------------------------------------------
   -- Inputs mapping
   --------------------------------------------------	
   rx_mosi_i      <= RX_MOSI;
   tx_miso_i      <= TX_MISO;
   line_start_i   <= FPA_INTF_CFG.offcorr_line_start;
   line_end_i     <= FPA_INTF_CFG.offcorr_line_end;
   coeff0_i       <= FPA_INTF_CFG.offcorr_coeff0;
   line_pos_i     <= LINE_POS;
	
   --------------------------------------------------
   -- Outputs mapping
   --------------------------------------------------	
   RX_MISO  <= rx_miso_i;
   TX_MOSI  <= tx_mosi_i;
   ERR      <= err_i;
  
   -- MISO signal driving
   rx_miso_i <= rx1_miso_i;
   
   -- Corrected zone detection
   corr_active <= '1' when (line_pos_i >= line_start_i and line_pos_i <= line_end_i) else '0';
   
   --------------------------------------------------
   -- Offset correction
   --------------------------------------------------
   U2 : afpa_quad_subtract
      generic map (G_SYNC_OPERAND => FALSE)
      port map (
         ARESET      => ARESET,
         CLK         => CLK,
         OP_SEL      => op_sel_i,
         RX1_MOSI    => rx1_mosi_i,
         RX1_MISO    => rx1_miso_i,
         RX2_MOSI    => rx2_mosi_i,
         RX2_MISO    => open,
         TX_MISO     => tx_miso_i,
         TX_MOSI     => tx_mosi_i,
         ERR         => err_i
      );
   
   -- Apply correction only when needed
   op_sel_i <= "11" when corr_active = '1' else "01";  
   
   -- Incoming pixels
   rx1_mosi_i <= rx_mosi_i;  
   
   -- Coeff0
   rx2_mosi_i.sof <= rx1_mosi_i.sof;
   rx2_mosi_i.eof <= rx1_mosi_i.eof;
   rx2_mosi_i.sol <= rx1_mosi_i.sol;
   rx2_mosi_i.eol <= rx1_mosi_i.eol;
   rx2_mosi_i.data <= X"0" & coeff0_i & X"0" & coeff0_i & X"0" & coeff0_i & X"0" & coeff0_i;
   rx2_mosi_i.dval <= rx1_mosi_i.dval;
   rx2_mosi_i.misc <= rx1_mosi_i.misc;
   rx2_mosi_i.support_busy <= rx1_mosi_i.support_busy;
   
end rtl;
