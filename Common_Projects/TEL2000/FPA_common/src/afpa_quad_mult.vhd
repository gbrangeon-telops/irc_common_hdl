------------------------------------------------------------------
--!   @file : afpa_quad_mult
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

entity afpa_quad_mult is
   
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      RXA_MOSI       : in t_ll_ext_mosi72; 
      RXA_MISO       : out t_ll_ext_miso;
      
      RXB_MOSI       : in t_ll_ext_mosi72;
      RXB_MISO       : out t_ll_ext_miso;
      
      TX_MISO        : in t_ll_ext_miso;
      TX_MOSI        : out t_ll_ext_mosi144;
      
      ERR            : out std_logic
      );
end afpa_quad_mult;

architecture rtl of afpa_quad_mult is
   
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
   
   type data_type is array (0 to 3) of std_logic_vector(35 downto 0);
   
   signal data_i   : data_type;
   signal sof_i    : std_logic;
   signal sol_i    : std_logic;
   signal eol_i    : std_logic;
   signal eof_i    : std_logic;
   signal dval_i   : std_logic;
   signal support_busy     : std_logic;
   
   signal sreset           : std_logic;
   signal sync_dval_i      : std_logic;
   signal err_i            : std_logic;
   
begin
   
   TX_MOSI.SOF  <= sof_i;
   TX_MOSI.EOF  <= eof_i;
   TX_MOSI.DVAL <= dval_i;
   TX_MOSI.SOL  <= sol_i;
   TX_MOSI.EOL  <= eol_i;
   TX_MOSI.SUPPORT_BUSY <= '1';
   TX_MOSI.DATA <= data_i(3)(17 downto 0) & data_i(2)(17 downto 0) & data_i(1)(17 downto 0) & data_i(0)(17 downto 0);
   
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
   -- synchro des entrées
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
   -- operateur de multiplication                          
   --------------------------------------------------
   U3 :  process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then 
            dval_i <= '0'; 
            err_i <= '0';
            
         else                        
            sof_i  <= RXA_MOSI.SOF;
            eof_i  <= RXA_MOSI.EOF;
            sol_i  <= RXA_MOSI.SOL;
            eol_i  <= RXA_MOSI.EOL;
            dval_i <= sync_dval_i;
            data_i(3) <= std_logic_vector(signed(RXA_MOSI.DATA(71 downto 54)) * signed(RXB_MOSI.DATA(71 downto 54)));
            data_i(2) <= std_logic_vector(signed(RXA_MOSI.DATA(53 downto 36)) * signed(RXB_MOSI.DATA(53 downto 36)));
            data_i(1) <= std_logic_vector(signed(RXA_MOSI.DATA(35 downto 18)) * signed(RXB_MOSI.DATA(35 downto 18)));
            data_i(0) <= std_logic_vector(signed(RXA_MOSI.DATA(17 downto 0))  * signed(RXB_MOSI.DATA(17 downto 0)));                    
         end if;
      end if;
   end process;               
   
   
end rtl;
