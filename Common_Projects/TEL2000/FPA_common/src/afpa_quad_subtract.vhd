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
   
   generic(
      FORCE_NEG_RESULT_TO_ZERO : boolean := false
      );
   
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
   
   type data_type is array (0 to 3) of std_logic_vector(18 downto 0);
   
   signal data_i, data_o   : data_type;
   signal sof_i, sof_o     : std_logic;
   signal sol_i, sol_o     : std_logic;
   signal eol_i, eol_o     : std_logic;
   signal eof_i, eof_o     : std_logic;
   signal dval_i, dval_o   : std_logic;
   signal support_busy     : std_logic;
   
   signal sreset           : std_logic;
   signal sync_dval_i      : std_logic;
   signal err_i, err_o     : std_logic;
   
begin
   
   TX_MOSI.SOF  <= sof_o;
   TX_MOSI.EOF  <= eof_o;
   TX_MOSI.DVAL <= dval_o;
   TX_MOSI.SOL  <= sol_o;
   TX_MOSI.EOL  <= eol_o;
   TX_MOSI.SUPPORT_BUSY <= '1';
   TX_MOSI.DATA <= data_o(3)(17 downto 0) & data_o(2)(17 downto 0) & data_o(1)(17 downto 0) & data_o(0)(17 downto 0);
   
   ERR <= err_o;
   
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
   -- operateur de soustraction (A-B)                          
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
            if RXB_MINUS_RXA = '0' then    -- operation normale: soustraction de l'offset electronique. Utilisation des valeyrs signées
               data_i(3) <= std_logic_vector(signed('0'& RXA_MOSI.DATA(71 downto 54)) - signed('0'& RXB_MOSI.DATA(71 downto 54)));
               data_i(2) <= std_logic_vector(signed('0'& RXA_MOSI.DATA(53 downto 36)) - signed('0'& RXB_MOSI.DATA(53 downto 36)));
               data_i(1) <= std_logic_vector(signed('0'& RXA_MOSI.DATA(35 downto 18)) - signed('0'& RXB_MOSI.DATA(35 downto 18)));
               data_i(0) <= std_logic_vector(signed('0'& RXA_MOSI.DATA(17 downto 0))  - signed('0'& RXB_MOSI.DATA(17 downto 0)));
            else                          -- operation en mode map: on sort l'offset électronique (RXA vaut 0.)
               data_i(3) <= std_logic_vector(signed('0'& RXB_MOSI.DATA(71 downto 54)) - signed('0'& RXA_MOSI.DATA(71 downto 54)));
               data_i(2) <= std_logic_vector(signed('0'& RXB_MOSI.DATA(53 downto 36)) - signed('0'& RXA_MOSI.DATA(53 downto 36)));
               data_i(1) <= std_logic_vector(signed('0'& RXB_MOSI.DATA(35 downto 18)) - signed('0'& RXA_MOSI.DATA(35 downto 18)));
               data_i(0) <= std_logic_vector(signed('0'& RXB_MOSI.DATA(17 downto 0))  - signed('0'& RXA_MOSI.DATA(17 downto 0)));
            end if;
            err_i <= data_i(3)(18) or data_i(2)(18) or data_i(1)(18) or data_i(0)(18); -- l'operation a donné un nombre negatif!!!
            
         end if;
      end if;
   end process;               
   
   --------------------------------------------------    
   -- Aucune gestion de la saturation negative                         
   --------------------------------------------------
   g0: if not FORCE_NEG_RESULT_TO_ZERO generate      
      begin          
      sof_o  <= sof_i;  eof_o  <= eof_i; dval_o <= dval_i; sol_o  <= sol_i; eol_o  <= eol_i; data_o <= data_i; err_o  <= err_i;
   end generate g0;
   
   --------------------------------------------------    
   -- gestion de la saturation negative                         
   --------------------------------------------------
   g1: if FORCE_NEG_RESULT_TO_ZERO generate      
      begin      
      U4 :  process(CLK) 
      begin
         if rising_edge(CLK) then
            if sreset = '1' then 
               dval_o <= '0';
               err_o <= '0';
            else            
               
               -- données
               if data_i(0)(18) = '1' then     -- l operation a donné un nombre negatif
                  data_o(0) <= (others => '0');
               else
                  data_o(0) <= data_i(0);
               end if;
               
               if data_i(1)(18) = '1' then     -- l operation a donné un nombre negatif
                  data_o(1) <= (others => '0');
               else
                  data_o(1) <= data_i(1);
               end if;
               
               if data_i(2)(18) = '1' then     -- l operation a donné un nombre negatif
                  data_o(2) <= (others => '0');
               else
                  data_o(2) <= data_i(2);
               end if;
               
               if data_i(3)(18) = '1' then     -- l operation a donné un nombre negatif
                  data_o(3) <= (others => '0');
               else
                  data_o(3) <= data_i(3);
               end if;
               
               -- identificateurs
               sof_o  <= sof_i;
               eof_o  <= eof_i;
               dval_o <= dval_i;
               sol_o  <= sol_i;
               eol_o  <= eol_i;
               data_o <= data_i;
               err_o  <= err_i;
               
            end if;
         end if;
      end process;      
   end generate g1;
   
   
   
end rtl;
