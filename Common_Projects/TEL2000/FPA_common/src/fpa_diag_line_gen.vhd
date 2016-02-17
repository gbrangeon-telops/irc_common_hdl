-------------------------------------------------------------------------------
--
-- Title       : fpa_diag_line_gen
-- Design      : Mars_tb
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00180-IRC\src\FPA\Mars\src\fpa_diag_line_gen.vhd
-- Generated   : Mon Dec 12 11:31:08 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity fpa_diag_line_gen is
   generic (
      ANALOG_IDDCA           : boolean := false;
      SAMP_NUM_PER_PIX       : natural range 0 to 15 := 5  --  S'applique juste pour les iDDCA analogiques. c'est le nombre d`echantillons à sortir par pixel. EN somme, le nombre d'échantillons renvoyés par l'ADC par pixel
      );
   
   port(
      CLK                : in std_logic;
      ARESET             : in std_logic;
      
      -- config
      LINE_SIZE          : in std_logic_vector(15 downto 0);
      START_PULSE        : in std_logic; --! Pulse qui permet de générer une ligne complète même s'il dure 1 CLK
      FIRST_VALUE        : in std_logic_vector(15 downto 0);  --! Premiere valeur à sortir 
      INCR_VALUE         : in std_logic_vector(15 downto 0); --! Increment sur les valeurs 
      
      -- sampling rate (used with analog iddca only)
      PIX_SAMP_TRIG      : in std_logic;      -- parfaitement synchrone sur CLK. En fait CLK = ADC_CLK_SOURCE qui vaut aussi MCLK_SOURCE pour les iddcas analogiques. C'est un pulse de durée 1CLK qui permet d'envoyer un echantillons de pixel
      
      -- Sorties 
      DIAG_DATA          : out std_logic_vector(15 downto 0);   --! sortie des données
      DIAG_DVAL          : out std_logic; --! signal de vaidation du bus des données
      DIAG_SOL           : out std_logic; --! Start of Line
      DIAG_EOL           : out std_logic; --! End of Line     
      DIAG_DONE          : out std_logic 
      -- absence de MISO ou AFULL car on ne peut arrêter le détecteur
      );
end fpa_diag_line_gen;


architecture RTL of fpa_diag_line_gen is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   type diag_gen_sm_type is (idle, samp_on_st, samp_off_st);
   
   constant SAMP_NUM_PER_PIX_M1              : natural := SAMP_NUM_PER_PIX -1;
   
   signal diag_gen_sm      : diag_gen_sm_type;
   signal sreset           : std_logic;
   signal diag_sol_i       : std_logic;
   signal diag_eol_i       : std_logic;
   signal diag_dval_i      : std_logic;
   signal diag_data_i      : integer range -65535 to 65535;
   signal pix_cnt          : unsigned(LINE_SIZE'length-1 downto 0);
   signal done             : std_logic;
   signal line_size_i      : natural;
   signal incr_value_i     : natural;
   signal samp_cnt         : natural range 0 to SAMP_NUM_PER_PIX + 1; 
   
begin     
   
   --------------------------------------------------
   -- output map
   -------------------------------------------------- 
   DIAG_DATA <= std_logic_vector(to_signed(diag_data_i, DIAG_DATA'LENGTH));       
   DIAG_DVAL <= diag_dval_i;  
   DIAG_SOL <= diag_sol_i;
   DIAG_EOL <= diag_eol_i;   
   DIAG_DONE <= done;
   
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
   -- generation des données diag iddca numériques
   -------------------------------------------------- 
   d_iddca_gen : if (not ANALOG_IDDCA) generate 
      
      U2: process(CLK)
      begin       
         if rising_edge(CLK) then
            if sreset = '1' then 
               diag_sol_i <= '0';
               diag_eol_i <= '0';
               diag_dval_i <= '0';
               done <= '0';
               diag_gen_sm <= idle;
            else
               
               case diag_gen_sm  is
                  
                  when idle => 
                     pix_cnt <= to_unsigned(1, pix_cnt'length);
                     done <= '1';
                     if START_PULSE = '1' then
                        done <= '0';
                        line_size_i <= to_integer(unsigned(LINE_SIZE));
                        diag_data_i <= to_integer(unsigned(FIRST_VALUE)) - to_integer(unsigned(INCR_VALUE));
                        incr_value_i <= to_integer(unsigned(INCR_VALUE));
                        diag_gen_sm <= samp_on_st;
                     end if;
                  
                  when samp_on_st  =>                  
                     diag_data_i <= diag_data_i + incr_value_i;
                     pix_cnt <=  pix_cnt + 1;
                     diag_sol_i <= '0';
                     diag_eol_i <= '0';
                     diag_dval_i <= '1';
                     if pix_cnt = 1 then
                        diag_sol_i <= '1';
                     elsif pix_cnt = line_size_i then
                        diag_eol_i <= '1';                        
                     elsif pix_cnt > line_size_i then
                        diag_gen_sm <= idle;
                        diag_dval_i <= '0';
                     end if;          
                  
                  when others =>
                  
               end case;
               
            end if;
         end if;
      end process;
      
   end generate;
   
   
   --------------------------------------------------
   -- generation des données diag iddcas analogiques
   --------------------------------------------------   
   a_iddca_gen : if ANALOG_IDDCA generate  
      
      U2: process(CLK)
      begin       
         if rising_edge(CLK) then
            if sreset = '1' then 
               diag_sol_i <= '0';
               diag_eol_i <= '0';
               diag_dval_i <= '0';
               done <= '0';         
               diag_gen_sm <= idle;
            else
               
               case diag_gen_sm  is
                  
                  when idle => 
                     pix_cnt <= to_unsigned(1, pix_cnt'length);
                     samp_cnt <= 1;
                     done <= '1';
                     diag_eol_i <= '0';
                     if START_PULSE = '1' then 
                        line_size_i <= to_integer(unsigned(LINE_SIZE));
                        diag_data_i <= to_integer(unsigned(FIRST_VALUE));
                        incr_value_i <= to_integer(unsigned(INCR_VALUE));
                        diag_gen_sm <= samp_on_st;
                     end if;
                  
                  when samp_on_st  =>
                     done <= '0'; 
                     diag_sol_i <= '0';
                     diag_eol_i <= '0';
                     if PIX_SAMP_TRIG = '1' then                        
                        diag_dval_i <= '1'; 
                        diag_gen_sm <= samp_off_st;
                     end if;                   
                     if pix_cnt = 1 then
                        diag_sol_i <= '1';
                     elsif pix_cnt = line_size_i then
                        diag_eol_i <= '1';                     
                     end if; 
                  
                  when samp_off_st  =>       -- l'existence de cet état suppose que  freq(CLK)/freq(PIXEL_SAMP_TRIG) = un entier > 1
                     diag_dval_i <= '0';  
                     samp_cnt <= samp_cnt + 1;
                     diag_gen_sm <= samp_on_st;                   
                     if samp_cnt = SAMP_NUM_PER_PIX then
                        samp_cnt <= 1;
                        diag_data_i <= diag_data_i + incr_value_i;
                        pix_cnt <= pix_cnt + 1;
                        if pix_cnt = line_size_i then
                           diag_gen_sm <= idle;
                        end if;
                     end if;                     
                  
                  when others =>
                  
               end case;
               
            end if;
         end if;
      end process;
      
   end generate;
   
   
end RTL;

