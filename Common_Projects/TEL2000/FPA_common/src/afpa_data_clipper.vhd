------------------------------------------------------------------
--!   @file : afpa_data_clipper
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.FPA_Define.all;
use work.proxy_define.all;
use work.fpa_common_pkg.all;

entity afpa_data_clipper is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      MAX_LEVEL      : in std_logic_vector(13 downto 0);
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      
      ERR            : out std_logic
      );
end afpa_data_clipper;


architecture rtl of afpa_data_clipper is 
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   type data_type is array (1 to 4) of signed(17 downto 0); 
   
   signal data_i, data_o            : data_type;
   signal sreset			            : std_logic;
   signal err_o                     : std_logic;
   signal sof_o                     : std_logic;
   signal sol_o                     : std_logic;
   signal eol_o                     : std_logic;
   signal eof_o                     : std_logic;
   signal dval_o                    : std_logic;
   signal clipping_level            : signed(MAX_LEVEL'LENGTH downto 0);
   
   
begin
   
   
   ------------------------------------------------------
   -- output map
   ------------------------------------------------------
   TX_MOSI.SOF  <= sof_o;
   TX_MOSI.EOF  <= eof_o;
   TX_MOSI.SOL  <= sol_o;
   TX_MOSI.EOL  <= eol_o;
   TX_MOSI.DVAL <= dval_o;
   TX_MOSI.DATA <= std_logic_vector(data_o(4)) & std_logic_vector(data_o(3)) & std_logic_vector(data_o(2)) & std_logic_vector(data_o(1));
   
   ERR <= err_o;	
   RX_MISO <= TX_MISO;
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
   -- input map
   ------------------------------------------------------	
   data_i(4) <= signed(RX_MOSI.DATA(71 downto 54));
   data_i(3) <= signed(RX_MOSI.DATA(53 downto 36));
   data_i(2) <= signed(RX_MOSI.DATA(35 downto 18));
   data_i(1) <= signed(RX_MOSI.DATA(17 downto 0));	
   
   ------------------------------------------------------
   --process de calcul des moyennes
   ------------------------------------------------------
   process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            err_o <= '0';
            dval_o <= '0';
            
         else
            
            -- defintion du niveau d'écretage 
            clipping_level <= signed('0'& MAX_LEVEL);
            
            -- division
            for ii in 1 to 4 loop
               if data_i(ii) > clipping_level then
                  data_o(ii) <= resize(clipping_level, data_o(ii)'length);
               else
                  data_o(ii) <= data_i(ii);
               end if;
            end loop;
            
            -- flags
            dval_o <= RX_MOSI.DVAL;
            sof_o  <= RX_MOSI.SOF;
            sol_o  <= RX_MOSI.SOL;
            eof_o  <= RX_MOSI.EOF;
            eol_o  <= RX_MOSI.EOL;
            
            -- erreurs
            err_o <= TX_MISO.BUSY and dval_o;  
            
            
         end if;
      end if;       
      
   end process;
   
   
end rtl;
