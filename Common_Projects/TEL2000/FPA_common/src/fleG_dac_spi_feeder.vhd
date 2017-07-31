------------------------------------------------------------------
--!   @file : fleG_dac_spi_feeder
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
use IEEE. numeric_std.all;
use work.fpa_common_pkg.all;
--use work.fpa_define.all;
--use work.tel2000.all;

entity fleG_dac_spi_feeder is
   port(		 
      ARESET      : in std_logic;
      CLK         : in std_logic;
      
      SPI_DATA    : in std_logic_vector(31 downto 0);
      SPI_DONE    : out std_logic;
      SPI_EN      : in std_logic;
      
      -- interface avec le contrôleur SPI
      TX_MOSI     : out t_ll_ext_mosi8;
      TX_MISO     : in t_ll_ext_miso;
      TX_DREM     : out std_logic_vector(3 downto 0); -- DREM = 8, 7, 6, ....1, pour signifier le nnombre de Bit valides dans le EOF  
      FRM_DONE    : in std_logic
      );
end fleG_dac_spi_feeder;

architecture rtl of fleG_dac_spi_feeder is
   
   constant C_SPI_DATA_BYTE_NUM    : natural := 4;
   constant C_SPI_DATA_BYTE_NUM_M1 : natural := C_SPI_DATA_BYTE_NUM - 1;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component;  
   
   type spi_feeder_fsm_type  is (idle, launch_spi_tx_st, check_end_st, wait_spi_end_st, count_dec_st, check_eof_gen_st);
   type byte_array_type is array (0 to C_SPI_DATA_BYTE_NUM_M1) of std_logic_vector(7 downto 0); 
   signal spi_feeder_fsm            : spi_feeder_fsm_type;
   signal sreset                    : std_logic; 
   signal tx_mosi_i                 : t_ll_ext_mosi8;
   signal spi_done_i                : std_logic; 
   signal tx_drem_i                 : unsigned(TX_DREM'range);
   signal byte_cnt                  : natural range 0 to C_SPI_DATA_BYTE_NUM;
   signal spi_data_i                : std_logic_vector(C_SPI_DATA_BYTE_NUM*8 - 1 downto 0);
   signal spi_byte                  : byte_array_type;
   
begin  
   
   TX_MOSI <= tx_mosi_i;
   SPI_DONE <= spi_done_i;
   TX_DREM <= std_logic_vector(tx_drem_i);
   
   ------------------------------------------------
   -- determination des bytes
   ------------------------------------------------
   Ub : for ii in 0 to C_SPI_DATA_BYTE_NUM_M1 generate 
      spi_byte(ii) <= SPI_DATA(8*ii + 7 downto 8*ii);
   end generate; 
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );   
   
   ------------------------------------------------
   -- Voir s'il faut programmer le détecteur
   ------------------------------------------------
   U3 : process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            tx_mosi_i.dval <= '0';
            spi_feeder_fsm <= idle;			
            spi_done_i <= '0';
         else 
            
            case spi_feeder_fsm is            
               
               when idle =>               
                  tx_mosi_i.dval <= '0';
                  tx_mosi_i.sof  <= '1'; 
                  tx_mosi_i.eof  <= '0';
                  tx_drem_i <= to_unsigned(8, tx_drem_i'length);
                  byte_cnt <= C_SPI_DATA_BYTE_NUM_M1; 
                  spi_done_i <= '1';
                  if SPI_EN = '1' then
                     spi_feeder_fsm <= launch_spi_tx_st; 
                  end if;
               
               when launch_spi_tx_st =>              -- on prend des morceaux de 8 bits qu'on envoie au driver spi
                  spi_done_i <= '0';
                  tx_mosi_i.data <= spi_byte(byte_cnt); -- SPI_DATA pas besoin d'etre latché car il ne change pas tant que la configiration n'est pas envoyée au complet.
                  tx_mosi_i.dval <= '1';
                  if TX_MISO.BUSY = '0' then
                     spi_feeder_fsm <= check_end_st;
                  end if; 
               
               when check_end_st =>
                  tx_mosi_i.sof <= '0';
                  tx_mosi_i.dval <= '0';
                  if byte_cnt = 0 then
                     spi_feeder_fsm <= wait_spi_end_st;
                  else 
                     spi_feeder_fsm <= count_dec_st;
                  end if; 
               
               when count_dec_st =>        -- ce compteur permet de balayer lentement le mpt de configuraion du detecteur 
                  byte_cnt <= byte_cnt - 1;          
                  tx_drem_i <= to_unsigned(8, tx_drem_i'length);
                  spi_feeder_fsm <= check_eof_gen_st; 
               
               when check_eof_gen_st =>                
                  if byte_cnt = 0 then
                     tx_mosi_i.eof <= '1';
                  end if; 
                  spi_feeder_fsm <= launch_spi_tx_st;
               
               when  wait_spi_end_st =>
                  if FRM_DONE = '1' then
                     spi_feeder_fsm <= idle;
                  end if;
               
               when others => 
               
            end case;
            
         end if;
      end if;
   end process;
   
   
end rtl;
