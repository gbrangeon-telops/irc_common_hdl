------------------------------------------------------------------
--!   @file : adc_brd_switch_ctrl
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
use work.fpa_define.all;

entity adc_brd_switch_ctrl is
   port(
      CLK         : in std_logic;
      ARESET      : in std_logic;
      
      RQST        : out std_logic;
      DONE        : out std_logic;
      EN          : in std_logic;
      SWITCH_PROG : in std_logic;
      SWITCH_DONE : out std_logic;
      
      GLOBAL_ERR  : in std_logic;
      
      MISO        : in std_logic;     
      CSN         : out std_logic;
      SCLK        : out std_logic;
      MOSI        : out std_logic;
      
      ERR         : out std_logic
      );
end adc_brd_switch_ctrl;



architecture rtl of adc_brd_switch_ctrl is 
   
   constant C_SWITCH_SPI_CLK_FACTOR    : integer  := 1_000;    -- ce qui donne une horloge SPI de 100KHz
   
   component LL8_ext_to_spi_tx
      generic(
         CS_TO_DATA_DLY : NATURAL range 1 to 31 := 1;
         DATA_TO_CS_DLY : NATURAL range 1 to 31 := 1;
         OUTPUT_MSB_FIRST : BOOLEAN := false
         );
      port (
         ARESET   : in std_logic;
         CLK      : in std_logic;
         RX_DREM  : in std_logic_vector(3 downto 0);
         RX_MOSI  : in t_ll_ext_mosi8;
         SCLKI    : in std_logic;
         CS_N     : out std_logic;
         ERR      : out std_logic;
         FRM_DONE : out std_logic;
         RX_MISO  : out t_ll_ext_miso;
         SCLK0    : out std_logic;
         SD       : out std_logic
         );
   end component;
   
   component sync_reset is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   component Clk_Divider is
      Generic(	Factor:		integer := 2);		
      Port ( 
         Clock  : in std_logic;
         Reset  : in std_logic;		
         Clk_div: out std_logic);
   end component;
   
   type switch_fsm_type is (idle, wait_cfg_st, rqst_st, start_spi_st, end_spi_st);
   type cfg_word_fsm_type is (idle, current_src_st1, current_src_st2, current_src_st3, flex_psp_st1, flex_psp_st2, flex_psp_st3, roic_en_st, digioV_st1, digioV_st2, digioV_st3, cfg_done_st);
   
   signal done_i               : std_logic;
   signal spi_sclk_i           : std_logic;
   signal sreset               : std_logic;
   signal cfg_mosi             : t_ll_ext_mosi8;
   signal cfg_miso             : t_ll_ext_miso;
   signal spi_done             : std_logic;
   signal switch_fsm           : switch_fsm_type;
   signal cfg_word_fsm         : cfg_word_fsm_type;
   signal switch_cfg_word_last : std_logic_vector(8 downto 1);
   signal switch_cfg_word      : std_logic_vector(8 downto 1);
   signal switch_data          : std_logic_vector(7 downto 0);
   signal switch_cfg_word_dval : std_logic; 
   signal rqst_i               : std_logic;
   
begin
   
   --------------------------------------
   -- Outputs registered
   --------------------------------------  
   U0 : process(CLK)
   begin
      if rising_edge(CLK) then 
         SWITCH_DONE <= done_i;
         DONE <= done_i;
         RQST <= rqst_i;
      end if;
   end process;
   
   ------------------------------------
   -- sync reset
   ------------------------------------
   U1: sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK); 
   
   
   --------------------------------------------------
   -- Generateur de l'horloge SPI du Switch
   -------------------------------------------------- 
   U2: Clk_Divider
   Generic map(Factor=> C_SWITCH_SPI_CLK_FACTOR
      -- pragma translate_off
      /1
      -- pragma translate_on
      )
   Port map( Clock => CLK, Reset => sreset, Clk_div => spi_sclk_i);
   
   
   --------------------------------------
   -- spi_tx
   --------------------------------------
   U3 : LL8_ext_to_spi_tx
   generic map (
      OUTPUT_MSB_FIRST => true,
      DATA_TO_CS_DLY   => 1,
      CS_TO_DATA_DLY   => 1      
      )
   port map(
   ARESET   => ARESET,
   CLK      => CLK,
   
   RX_MOSI  => cfg_mosi, 
   RX_MISO  => cfg_miso,
   RX_DREM  => x"8",
   
   SCLKI    => spi_sclk_i,
   
   SCLK0    => SCLK,
   SD       => MOSI,
   CS_N     => CSN,
   FRM_DONE => spi_done,
   
   ERR      => ERR
   );
   
   
   --------------------------------------
   -- spi_control
   -------------------------------------- 
   U4: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            switch_fsm <=  idle;
            rqst_i <= '0';
            done_i <= '0';
            switch_cfg_word_last <= (others => '1'); -- fait expres pour qu'au demarrage, la switch se programme à x"00".
         else       
            
            
            case  switch_fsm is               
               
               when idle =>
                  rqst_i <= '0';
                  done_i <= '1';
                  cfg_mosi.dval <= '0';
                  if SWITCH_PROG = '1' or switch_cfg_word /= switch_cfg_word_last then  -- SWITCH_PROG permet de programmer la switch meme si 
                     switch_fsm <=  wait_cfg_st;
                  end if;
               
               when wait_cfg_st =>
                  done_i <= '0';
                  if switch_cfg_word_dval = '1' then
                     switch_fsm <=  rqst_st;
                     switch_data <= switch_cfg_word;
                  end if;
               
               when rqst_st =>  
                  rqst_i <= '1';
                  if EN = '1' then 
                     switch_fsm <=  start_spi_st;
                  end if;
               
               when start_spi_st => 
                  rqst_i <= '0';
                  cfg_mosi.data <= switch_data;
                  cfg_mosi.sof  <= '1';
                  cfg_mosi.eof  <= '1';
                  cfg_mosi.dval <= '1';
                  if spi_done = '0' then 
                     switch_fsm <=  end_spi_st;
                     cfg_mosi.dval <= '0';
                  end if;
               
               when end_spi_st =>
                  switch_cfg_word_last <= cfg_mosi.data;
                  if spi_done = '1' then 
                     switch_fsm <=  idle;
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;   
   end process;
   
   
   --------------------------------------
   -- switch config word
   -------------------------------------- 
   --SW_IO1 ---> Current source
   --SW_IO2 ---> Current source
   --SW_IO3 ---> Generation voltage V+ du flex
   --SW_IO4 ---> Generation voltage V+ du flex
   --SW_IO5 ---> ROIC_EN -- allumage du FPA via FPA_ON
   --SW_IO6 ---> Programmation de FPA_DIGIO_VOLTAGE
   --SW_IO7 ---> Programmation de FPA_DIGIO_VOLTAGE
   --SW_IO8 ---> Allumage de la led orange d'erreur
   U5: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            switch_cfg_word <= (others => '0');
            cfg_word_fsm <= idle;
         else
            
            case cfg_word_fsm is
               
               when idle =>                  
                  switch_cfg_word(8) <= GLOBAL_ERR;       -- error
                  switch_cfg_word_dval <= '1';
                  if SWITCH_PROG = '1' then               -- SWITCH_PROG passe à '1' ssi le HW est conforme
                     switch_cfg_word_dval <= '0';
                     cfg_word_fsm <= current_src_st1;
                  end if;
                  
               -- current source
               when current_src_st1 =>                  
                  switch_cfg_word(2 downto 1) <= "00";                -- courant de 25uA (valeur par defaut                        
                  cfg_word_fsm <= current_src_st2;
               
               when current_src_st2 =>    
                  if DEFINE_FPA_TEMP_DIODE_CURRENT_uA = 100 then      -- courant de 100uA
                     switch_cfg_word(2 downto 1) <= "01";
                  end if;
                  cfg_word_fsm <= current_src_st3;
               
               when current_src_st3 =>    
                  if DEFINE_FPA_TEMP_DIODE_CURRENT_uA = 1000 or DEFINE_FPA_TEMP_DIODE_CURRENT_uA = 150 then     -- courant de 1000uA ou 150uA sur EFA-00253-411 (xro3503A)
                     switch_cfg_word(2 downto 1) <= "11";
                  end if;
                  cfg_word_fsm <= flex_psp_st1;          
                  
               -- Flex V+ 
               when flex_psp_st1 =>                                            
                  switch_cfg_word(4 downto 3) <= "00";                -- flex_PSP de 5V                                                          
                  cfg_word_fsm <= flex_psp_st2;
               
               when flex_psp_st2 =>
                  if DEFINE_FLEX_VOLTAGEP_mV    = 6_500 then          -- flex_PSP de 6.5V
                     switch_cfg_word(4 downto 3) <= "01"; 
                  end if;
                  cfg_word_fsm <= flex_psp_st3;    
               
               when flex_psp_st3 =>
                  if DEFINE_FLEX_VOLTAGEP_mV = 8_000 then             -- flex_PSP de 8V
                     switch_cfg_word(4 downto 3) <= "11"; 
                  end if;
                  cfg_word_fsm <= roic_en_st;  
                  
               -- roic_en
               when roic_en_st =>
                  switch_cfg_word(5) <= '1';                          -- toujours à '1'. On permet l'allumage du flex mais le dernier mot revient au driver.
                  cfg_word_fsm <= digioV_st1;
                  
               -- digioV
               when digioV_st1 =>
                  switch_cfg_word(7 downto 6) <= "00";                -- digioV de 2.5V (valeur par defaut)          
                  cfg_word_fsm <= digioV_st2;
               
               when digioV_st2 =>
                  if DEFINE_FPA_INPUT = LVCMOS33 then                 -- digioV de 3.3V
                     switch_cfg_word(7 downto 6) <= "01";
                  end if;
                  cfg_word_fsm <= digioV_st3;
               
               when digioV_st3 =>
                  if DEFINE_FPA_INPUT = LVTTL50 then                  -- digioV de 5.0V
                     switch_cfg_word(7 downto 6) <= "11";   
                  end if;
                  cfg_word_fsm <= cfg_done_st;
                  
               -- cfg_done
               when cfg_done_st =>            
                  switch_cfg_word_dval <= '1';
                  cfg_word_fsm <= idle;
               
               when others =>
               
            end case;
         end if;  
         
         
      end if;   
   end process;
   
   
   
end rtl;
