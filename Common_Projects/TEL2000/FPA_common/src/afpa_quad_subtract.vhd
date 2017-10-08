------------------------------------------------------------------
--!   @file : afpa_quad_subtract
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
use work.tel2000.all;

entity afpa_quad_subtract is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      RXB_MINUS_RXA  : in std_logic;
      
      RXA_MOSI       : in t_ll_ext_mosi72; 
      RXA_MISO       : out t_ll_ext_miso;
      
      RXB_MOSI       : in t_ll_ext_mosi72;
      RXB_MISO       : out t_ll_ext_miso;
      
      TX_MISO        : in t_ll_ext_miso;
      TX_MOSI        : out t_ll_ext_mosi72;
      
      ERR            : out std_logic
      );
end afpa_quad_subtract;

architecture rtl of afpa_quad_subtract is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;   
   
   component LL_ext_sync_flow
      port(           
         
         RX0_DVAL    : in std_logic;
         RX0_BUSY    : out std_logic;
         
         RX1_DVAL    : in std_logic;
         RX1_BUSY    : out std_logic;
         
         SYNC_BUSY   : in std_logic;      
         SYNC_DVAL   : out std_logic               
         
         );
   end component;
   
   signal tx_mosi_i        : t_ll_ext_mosi72;
   signal sreset           : std_logic;
   signal sync_dval_i      : std_logic;
   signal err_i            : std_logic;
   
begin
   
   TX_MOSI <= tx_mosi_i;
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
   -- synchro des entr�es
   --------------------------------------------------   
   U2 : LL_ext_sync_flow
   port map(
      RX0_DVAL  => RXA_MOSI.DVAL,
      RX0_BUSY  => RXA_MISO.BUSY,
      
      RX1_DVAL  => RXB_MOSI.DVAL,
      RX1_BUSY  => RXB_MISO.BUSY,
      
      SYNC_BUSY => TX_MISO.BUSY,
      SYNC_DVAL => sync_dval_i      
      );
    RXA_MISO.AFULL <= '0';
    RXB_MISO.AFULL <= '0';
   --------------------------------------------------    
   -- operateur de soustraction (A-B)                          
   --------------------------------------------------
   U3 :  process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then 
            tx_mosi_i.dval <= '0'; 
            tx_mosi_i.support_busy <= '1';
            err_i <= '0';
            
         else
            
            tx_mosi_i.sof  <= RXA_MOSI.SOF;
            tx_mosi_i.eof  <= RXA_MOSI.EOF;
            tx_mosi_i.sol  <= RXA_MOSI.SOL;
            tx_mosi_i.eol  <= RXA_MOSI.EOL;
            tx_mosi_i.dval <= sync_dval_i;
            if RXB_MINUS_RXA = '0' then    -- operation normale: soustraction de l'offset electronique
               tx_mosi_i.data(71 downto 54) <= std_logic_vector(unsigned(RXA_MOSI.DATA(71 downto 54)) - unsigned(RXB_MOSI.DATA(71 downto 54)));
               tx_mosi_i.data(53 downto 36) <= std_logic_vector(unsigned(RXA_MOSI.DATA(53 downto 36)) - unsigned(RXB_MOSI.DATA(53 downto 36)));
               tx_mosi_i.data(35 downto 18) <= std_logic_vector(unsigned(RXA_MOSI.DATA(35 downto 18)) - unsigned(RXB_MOSI.DATA(35 downto 18)));
               tx_mosi_i.data(17 downto 0)  <= std_logic_vector(unsigned(RXA_MOSI.DATA(17 downto 0))  - unsigned(RXB_MOSI.DATA(17 downto 0)));
            else                          -- operation en mode map: on sort l'offset �lectronique (RXA vaut 0.)
               tx_mosi_i.data(71 downto 54) <= std_logic_vector(unsigned(RXB_MOSI.DATA(71 downto 54)) - unsigned(RXA_MOSI.DATA(71 downto 54)));
               tx_mosi_i.data(53 downto 36) <= std_logic_vector(unsigned(RXB_MOSI.DATA(53 downto 36)) - unsigned(RXA_MOSI.DATA(53 downto 36)));
               tx_mosi_i.data(35 downto 18) <= std_logic_vector(unsigned(RXB_MOSI.DATA(35 downto 18)) - unsigned(RXA_MOSI.DATA(35 downto 18)));
               tx_mosi_i.data(17 downto 0)  <= std_logic_vector(unsigned(RXB_MOSI.DATA(17 downto 0))  - unsigned(RXA_MOSI.DATA(17 downto 0)));
            end if;
            err_i <= tx_mosi_i.data(71) or tx_mosi_i.data(53) or tx_mosi_i.data(35) or tx_mosi_i.data(17); -- l'operation a donn� un nombre negatif!!!
            
         end if;
      end if;
   end process;    
end rtl;
