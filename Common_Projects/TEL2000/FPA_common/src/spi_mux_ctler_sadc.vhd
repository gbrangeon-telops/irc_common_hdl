------------------------------------------------------------------
--!   @file : spi_mux_ctler_sadc
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
use IEEE.NUMERIC_STD.all;
use work.tel2000.all;

entity spi_mux_ctler_sadc is
   port(  		 
      
      -- signaux generaux
      CLK      : in std_logic;
      ARESET   : in std_logic;
      
      -- contrôle des clients SPI
      RQST     : in std_logic_vector(1 downto 0);
      EN       : out std_logic_vector(1 downto 0);
      
      -- SPI signals (master side)
      CSN      : in std_logic_vector(1 downto 0);
      SCLK     : in std_logic_vector(1 downto 0);
      MOSI     : in std_logic_vector(1 downto 0);
      MISO     : out std_logic;      
      DONE     : in std_logic_vector(1 downto 0); 
      
      -- SPI signals (slave side) 
      SPI_SDO  : in std_logic;
      SPI_CS1_N: out std_logic;
      SPI_CS0_N: out std_logic;
      SPI_SCLK : out std_logic;
      SPI_SDI  : out std_logic
      
      );
end spi_mux_ctler_sadc;

architecture rtl of spi_mux_ctler_sadc is
   
   type rqst_fsm_type is (idle, client_en_st, wait_end_st);
   
   -- sync_reset
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   
   signal sreset           : std_logic;
   signal spi_sdo_iob      : std_logic;
   signal spi_sdi_iob      : std_logic;
   signal spi_sclk_iob     : std_logic;
   signal spi_cs1n_iob     : std_logic;
   signal spi_cs0n_iob     : std_logic;
   signal client_id        : natural range 0 to 1;
   
   signal rqst_fsm         : rqst_fsm_type;
   
   --   attribute equivalent_register_removal : string;      
   --   attribute equivalent_register_removal of spi_sdo_iob  : signal is "NO"; 
   --   attribute equivalent_register_removal of spi_sdi_iob  : signal is "NO";
   --   attribute equivalent_register_removal of spi_sclk_iob : signal is "NO";
   --   attribute equivalent_register_removal of spi_csn_iob  : signal is "NO";
   
   attribute IOB : string;
   attribute IOB of spi_sdo_iob          : signal is "TRUE"; 
   attribute IOB of spi_sdi_iob          : signal is "TRUE";
   attribute IOB of spi_sclk_iob         : signal is "TRUE";
   attribute IOB of spi_cs1n_iob         : signal is "TRUE";
   attribute IOB of spi_cs0n_iob         : signal is "TRUE";
   
   --attribute dont_touch : string;
   --attribute dont_touch of client_id     : signal is "TRUE"; 
   --attribute dont_touch of rqst_fsm      : signal is "TRUE"; 
   --attribute dont_touch of DONE          : signal is "TRUE"; 
   --attribute dont_touch of EN            : signal is "TRUE";
   --attribute dont_touch of RQST          : signal is "TRUE";
begin
   
   MISO <= spi_sdo_iob;
   
   --------------------------------------------------
   -- IOs
   -------------------------------------------------- 
   -- ATTENTION : contrôle des signaux SPI sortants et MUX sortants sur '0' et '1'  
   SPI_SDI  <= spi_sdi_iob;
   SPI_CS1_N <= spi_cs1n_iob;--'0' when spi_csn_iob  = '0' else 'Z';
   SPI_CS0_N <= spi_cs0n_iob;--'0' when spi_csn_iob  = '0' else 'Z';
   SPI_SCLK <= spi_sclk_iob;
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1: sync_reset
   port map(ARESET => ARESET, CLK => CLK, SRESET => sreset);    
   
   --------------------------------------------------
   -- requests manager
   -------------------------------------------------- 
   U2: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            rqst_fsm <=  idle;
            EN <= (others => '0');
            client_id <= 0;
         else                   
            
            --fsm de contrôle
            
            case  rqst_fsm is 
               
               -- attente d'une demande de transaction SPI
               when idle =>
                  EN <= (others => '0');                     
                  if RQST(0) = '1' then            -- priorité 1: switch
                     client_id <= 0;
                     rqst_fsm <= client_en_st;
                  elsif RQST(1) = '1' then            -- priorité 2: monitoring ADC
                     client_id <= 1;
                     rqst_fsm <= client_en_st; 
                  end if;
                  
               -- accès accordé au client demandeur 
               when client_en_st =>     
                  EN(client_id) <= '1';                 
                  if DONE(client_id) = '0' then
                     rqst_fsm <= wait_end_st;
                  end if;
                  
               -- attente de la fin de transaction
               when  wait_end_st =>  
                  EN <= (others =>'0');
                  if DONE(client_id) = '1' then
                     rqst_fsm <= idle;
                  end if;               
               
               when others =>
               
            end case;
            
         end if;
      end if;   
   end process;
   
   --------------------------------------------------
   -- signaux spi
   --------------------------------------------------  
   U3: process(CLK)   
   begin
      if rising_edge(CLK) then
         spi_sdi_iob  <= MOSI(client_id);
         spi_cs1n_iob  <= CSN(1);
         spi_cs0n_iob  <= CSN(0);
         spi_sclk_iob <= SCLK(client_id);
         spi_sdo_iob  <= SPI_SDO;        
      end if;   
   end process;
   
end rtl;
