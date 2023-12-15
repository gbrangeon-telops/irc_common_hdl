------------------------------------------------------------------
--!   @file : afpa_data_ctrl_map
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
use work.Fpa_Common_Pkg.all;
use work.fpa_define.all;
use work.proxy_define.all;
use work.tel2000.all;

entity afpa_data_ctrl_map is
   port(		 
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      QUAD_MOSI    : in t_ll_ext_mosi72;
      QUAD_MISO    : out t_ll_ext_miso;
      
      DOUT_MOSI     : out t_axi4_stream_mosi64; 
      DOUT_MISO     : in t_axi4_stream_miso;
      
      ERR           : out std_logic   
      
      );
end afpa_data_ctrl_map;


architecture rtl of afpa_data_ctrl_map is
     
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   --signal reorder_sm       : reorder_sm_type;
   signal sreset           : std_logic;
   signal err_i            : std_logic;
   
begin    
   
   --------------------------------------------------
   -- outputs maps
   -------------------------------------------------- 
   DOUT_MOSI.TDATA <= QUAD_MOSI.DATA(69 downto 54) & QUAD_MOSI.DATA(51 downto 36) & QUAD_MOSI.DATA(33 downto 18) & QUAD_MOSI.DATA(15 downto 0); -- 
   DOUT_MOSI.TVALID<= QUAD_MOSI.DVAL;
   DOUT_MOSI.TSTRB <= (others => '1');
   DOUT_MOSI.TKEEP <= (others => '1');
   DOUT_MOSI.TLAST <= QUAD_MOSI.EOF;
   DOUT_MOSI.TUSER <= (others => '0');
   DOUT_MOSI.TID   <= (others => '0');
   DOUT_MOSI.TDEST <= (others => '0');    
   QUAD_MISO.BUSY  <=  not DOUT_MISO.TREADY;     -- on repartit les fifo_full.
   QUAD_MISO.AFULL <=  '0';
   
   ERR <= err_i;                                          
   
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
   -- multiplexage
   -------------------------------------------------- 
   U3 : process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            err_i <= '0';            
         else            
            err_i <= QUAD_MOSI.DVAL and not DOUT_MISO.TREADY;   -- le module fpa a horreur du busy. Erreur grave de vitesse                   
         end if;                             
      end if;
   end process; 
end rtl;
