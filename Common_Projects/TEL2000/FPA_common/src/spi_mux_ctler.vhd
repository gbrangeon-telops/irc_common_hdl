------------------------------------------------------------------
--!   @file : spi_mux_ctler
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

entity spi_mux_ctler is
   port(  		 
      
      -- signaux generaux
      CLK      : in std_logic;
      ARESET   : in std_logic;
      
      -- contrôle des clients SPI
      RQST     : in std_logic_vector(3 downto 0);
      EN       : out std_logic_vector(3 downto 0);
      
      -- SPI signals (master side)
      CSN      : in std_logic_vector(3 downto 0);
      SCLK     : in std_logic_vector(3 downto 0);
      MOSI     : in std_logic_vector(3 downto 0);
      MISO     : out std_logic;      
      DONE     : in std_logic_vector(3 downto 0);
      
      -- contrôle du mux SPI sur la carte ADC
      SPI_MUX0  : out std_logic;   
      SPI_MUX1  : out std_logic; 
      
      -- SPI signals (slave side) 
      SPI_SDO  : in std_logic;
      SPI_CSN  : out std_logic;
      SPI_SCLK : out std_logic;
      SPI_SDI  : out std_logic
      
      );
end spi_mux_ctler;

architecture rtl of spi_mux_ctler is
   
   constant C_MUX_STABILIZATION_TIME_FACTOR : natural :=  10_000; --Valeur empirique. Soit 100 usec. 
   type rqst_fsm_type is (idle, cfg_brd_mux_st, wait_mux_stab_st, client_en_st, wait_end_st);
   
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
   signal spi_csn_iob      : std_logic;
   signal client_id        : natural range 0 to 3;
   signal pause_cnt        : unsigned(log2(C_MUX_STABILIZATION_TIME_FACTOR)+1 downto 0);
   
   signal rqst_fsm         : rqst_fsm_type;
   signal mux_iob          : std_logic_vector(1 downto 0);
   signal mux_i            : std_logic_vector(1 downto 0);
   
   --   attribute equivalent_register_removal : string;      
   --   attribute equivalent_register_removal of spi_sdo_iob  : signal is "NO"; 
   --   attribute equivalent_register_removal of spi_sdi_iob  : signal is "NO";
   --   attribute equivalent_register_removal of spi_sclk_iob : signal is "NO";
   --   attribute equivalent_register_removal of spi_csn_iob  : signal is "NO";
   
   attribute IOB : string;
   attribute IOB of spi_sdo_iob          : signal is "TRUE"; 
   attribute IOB of spi_sdi_iob          : signal is "TRUE";
   attribute IOB of spi_sclk_iob         : signal is "TRUE";
   attribute IOB of spi_csn_iob          : signal is "TRUE";
   
   --attribute dont_touch : string;
   --attribute dont_touch of client_id     : signal is "TRUE"; 
   --attribute keep of mux_iob            : signal is "TRUE"; 
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
   SPI_MUX0 <= mux_iob(0);
   SPI_MUX1 <= mux_iob(1);  
   SPI_SDI  <= spi_sdi_iob;
   SPI_CSN  <= spi_csn_iob;--'0' when spi_csn_iob  = '0' else 'Z';
   SPI_SCLK <= spi_sclk_iob;
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1: sync_reset
   port map(ARESET => ARESET, CLK => CLK, SRESET => sreset);    
   
   --------------------------------------------------
   -- requests manager
   -------------------------------------------------- 
   -- [MUX1, MUX0] = "00" --> quad_adc_ctrl en communication 
   -- [MUX1, MUX0] = "01" --> switch en communication
   -- [MUX1, MUX0] = "10" --> monitoring_adc en communication 
   -- [MUX1, MUX0] = "11" --> adc_freq_id_reader en communication
   
   U2: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            rqst_fsm <=  idle;
            EN <= (others => '0');
            client_id <= 3;
            mux_i <= "11";
         else                   
            
            --fsm de contrôle
            
            case  rqst_fsm is 
               
               -- attente d'une demande de transaction SPI
               when idle =>
                  pause_cnt <= (others => '0');
                  EN <= (others => '0');                   
                  if RQST(3) = '1' then               -- priorité 1: freq_id_reader
                     client_id <= 3;
                     rqst_fsm <= cfg_brd_mux_st;                     
                  elsif RQST(1) = '1' then            -- priorité 2: switch
                     client_id <= 1;
                     rqst_fsm <= cfg_brd_mux_st;                     
                  elsif RQST(0) = '1' then            -- priorité 3: quad_adc_ctrl
                     client_id <= 0;
                     rqst_fsm <= cfg_brd_mux_st;
                  elsif RQST(2) = '1' then            -- priorité 4: monitoring ADC
                     client_id <= 2;
                     rqst_fsm <= cfg_brd_mux_st; 
                  end if;
                  
               -- activation du mux sur la carte
               when cfg_brd_mux_st =>  
                  mux_i <= std_logic_vector(to_unsigned(client_id, 2));
                  rqst_fsm <= wait_mux_stab_st;
                  
               -- attente pour la propagation vers le mux sur la carte et sa stabilisation
               when wait_mux_stab_st => 
                  pause_cnt <= pause_cnt + 1;
                  if pause_cnt = C_MUX_STABILIZATION_TIME_FACTOR then 
                     rqst_fsm <= client_en_st;
                  end if;
                  -- pragma translate_off
                  rqst_fsm <= client_en_st;
                  -- pragma translate_on
                  
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
         mux_iob <= mux_i;
         spi_sdi_iob  <= MOSI(client_id);
         spi_csn_iob  <= CSN(client_id);
         spi_sclk_iob <= SCLK(client_id);
         spi_sdo_iob  <= SPI_SDO;        
      end if;   
   end process;
   
end rtl;
