-------------------------------------------------------------------------------
--
-- Title       : ad5648_driver
-- Design      : SPI_DRIVER
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\SPI_DRIVER\src\ad5648_driver.vhd
-- Generated   : Mon Jul  9 10:41:52 2007
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.numeric_std.all;
use work.fleg_brd_define.all;


entity ad5648_driver is  
   
   port(
      CLK               : in std_logic;
      ARESET            : in std_logic;
      
      DAC_ID            : in std_logic_vector(3 downto 0);
      DAC_CMD           : in std_logic_vector(3 downto 0);
      DAC_DATA          : in std_logic_vector(13 downto 0);
      DAC_EN            : in std_logic; 
      DAC_DONE          : out std_logic;
      
      SPI_DATA          : out std_logic_vector(31 downto 0);
      SPI_DVAL          : out std_logic;  
      
      SPI_DONE          : in std_logic
      );
end ad5648_driver;



architecture RTL of ad5648_driver is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component;
   
   type   dac_cmd_fsm_type is	( idle, fill_cfg_st, check_spi_done_st, send_cfg_st, pause_st);
   signal dac_cmd_fsm      : dac_cmd_fsm_type;
   signal cmd_i            : std_logic_vector(3 downto 0);
   signal add_i            : unsigned(3 downto 0);
   signal data_i           : std_logic_vector(13 downto 0);
   signal done_i           : std_logic;
   signal din_word_done    : std_logic;
   signal cfg_i            : std_logic_vector(31 downto 0);
   signal spi_dval_i       : std_logic;
   signal sreset           : std_logic;
   
begin
   
   DAC_DONE <= done_i;
   
   SPI_DATA <= cfg_i;
   SPI_DVAL <= spi_dval_i;
   
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U0: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   -------------------------------------------------------------
   -- Interpretation des commandes pour le DAC 5628  
   ------------------------------------------------------------- 
   U1: process(clk)                                             
      
   begin                                                                          
      if rising_edge(clk) then
         
         
         cfg_i <= (others =>'0');          -- initialisation de tous les bits de CFG         
         cfg_i(23 downto 20) <= std_logic_vector(add_i);     -- le dac auquel est envoyée la commande
         
         case  cmd_i is                        
            
            when wr_dacN =>                -- permet de configurer le dacN
               cfg_i(27 downto 24) <= "0000";       
               cfg_i(19 downto 6) <= data_i;     
            
            when update_dacN =>            -- permet de mettre à jour la sortie du dacN
               cfg_i(27 downto 24) <= "0001";                     
            
            when wr_and_update_dacN =>     -- permet de configuer le dacN puis de le mettre à jour immédiatement après
               cfg_i(27 downto 24) <= "0011";         
               cfg_i(19 downto 6) <= data_i;            
            
            when  normal_op_mode =>         -- permet de placer le dac désigné en mode normal
               cfg_i(27 downto 24) <= "0100";
               cfg_i(9 downto 8) <= "00";                     -- mode normal
               cfg_i(7 downto 0) <= (others => '1');          -- tous les dacs en mode normal (selon la doc "When using the internal reference, only all channel power-down to the selected modes is supported")             
            
            when  ldac_mode =>     -- permet la mise à jour du DAC reg designé automatiquement
               cfg_i(27 downto 24) <= "0110";
               cfg_i(7 downto 0) <= (others => '1');         -- la mise à jour se fera automatiquement pour le dac designé, à la fin de la communication SPI
            
            when  int_reference_mode =>
               cfg_i(27 downto 24) <= "1000"; 
               cfg_i(0) <= '1';    -- reference interne utilisée
            
            when  ext_reference_mode =>
               cfg_i(27 downto 24) <= "1000"; 
               cfg_i(0) <= '0';    -- reference externe utilisée
            
            when load_clear_code =>          -- permet de faire un reset de toutes les sorties à 0 volt
               cfg_i(27 downto 24) <= "0101"; 
               cfg_i(1 downto 0) <= "00";    -- clear to 0.
            
            when  others =>
            
         end case;
         
      end if;
   end process; 
   
   
   -------------------------------------------------------------
   -- Process d'envoi des commandes 
   -------------------------------------------------------------      
   -- input interface : latch des parametres de commande
   U2: process(clk)
   begin  
      if rising_edge(clk) then 
         if sreset = '1' then 
            dac_cmd_fsm <= idle;
            done_i <= '0';
            spi_dval_i <= '0';            
         else
            
            case  dac_cmd_fsm is  
               
               when idle     => 
                  spi_dval_i <= '0';
                  done_i <= '1';         
                  cmd_i <= DAC_CMD;        
                  add_i <= unsigned(DAC_ID) - 1;      
                  data_i <= DAC_DATA;
                  if DAC_EN = '1'  then              -- en quittant cet etat,  cmd_i, add_i, data__i sont latchés automatiquement
                     dac_cmd_fsm <= fill_cfg_st;
                  end if; 
               
               when fill_cfg_st  =>                  -- on remplit la config selon la commande perçue 
                  done_i <= '0'; 
                  dac_cmd_fsm <= check_spi_done_st;
               
               when check_spi_done_st =>
                  if SPI_DONE = '1' then
                     dac_cmd_fsm <= send_cfg_st; 
                  end if;
               
               when send_cfg_st => 
                  spi_dval_i <= '1';
                  if SPI_DONE = '0' then 
                     dac_cmd_fsm <= pause_st;
                  end if;
               
               when pause_st  =>  
                  spi_dval_i <= '0';
                  if  SPI_DONE = '1' then   
                     dac_cmd_fsm <= idle;
                  end if;              
               
               when others =>
               
            end case; 
         end if;
      end if;
      
   end process;
end RTL;




