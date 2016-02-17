---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: spi_tx.vhd
--  Use: general purpose spi master interface (DACs etc...)
--  Author: ENO
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Notes: core divides incoming clock by CLKDIV to generate SPI clock must be at least a factor
--         of 2
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use  Common_HDL.Telops.all;

entity LL8_to_spi_tx is
   generic( 
      OUTPUT_MSB_FIRST : boolean := false     -- si à true, alors RX_MOSI.DATA(7) est le premier bit à sortir sur le lien SPI. Cela signifie une sortie des bits 7 dowto 0
      -- si à false alors RX_MOSI.DATA(0) est le premier bit à sortir sur le lien SPI. Cela signifie une sortie des bits 0 to 7
      );
   
   port(
      -- general
      ARESET   : in std_logic;
      CLK      : in std_logic; 
      
      -- flow d'entrée
      RX_MOSI  : in t_ll_mosi8;
      RX_MISO  : out t_ll_miso;
      RX_DREM  : in std_logic_vector(3 downto 0); -- DREM = 8, 7, 6, ....1, pour signifier le nnombre de Bit valides dans le EOF 
      -- clock SPI fournie
      SCLKI    : in std_logic;      
      
      -- lien sortant spi master
      SCLK0    : out std_logic;
      SD       : out std_logic;
      CS_N     : out std_logic;
      FRM_DONE : out std_logic;      --indique la fin de l'envoi d'une trame commeneçant par SOF et se terminant par EOF
      
      --err
      ERR      : out std_logic 
      );
end LL8_to_spi_tx;

architecture rtl of LL8_to_spi_tx is
   
   component double_sync
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D : in STD_LOGIC;
         Q : out STD_LOGIC := '0';
         RESET : in STD_LOGIC;
         CLK : in STD_LOGIC
         );
   end component;
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   type spi_fsm_type  is (idle, sync_sclk_st, byte_window_st, assert_cs_st, desassert_cs_st, done_st);
   signal spi_fsm                   : spi_fsm_type;
   signal clk_en                    : std_logic;     
   --signal sclko_i                   : std_logic;
   signal sd_i                      : std_logic;
   signal cs_n_i                    : std_logic;
   signal sclki_sync                : std_logic;
   signal sreset                    : std_logic; 
   signal sclki_sync_last           : std_logic;
   signal proc_sclki_rise           : std_logic;
   signal bit_trig                  : std_logic;
   signal byte_window               : std_logic;
   signal dout_reg                  : std_logic_vector(7 downto 0);
   signal done_i                    : std_logic;
   signal fsm_busy                  : std_logic;
   signal sof_err                   : std_logic;
   signal valid_frame                 : std_logic; 
   signal eof_latch                 : std_logic;
   signal bit_cnt                   : unsigned(3 downto 0);
   signal sclki_pipe, sclko_pipe    : std_logic_vector(7 downto 0);
   signal proc_sclki_rise_delayed   : std_logic;
   signal drem_latch                : unsigned(RX_DREM'LENGTH-1 downto 0);
   signal drem_err                  : std_logic;
   --signal sclko_reg                 : std_logic;
   --signal byte_window_reg           : std_logic;
   --signal cs_n_reg                  : std_logic;
   
begin
   
   ------------------------------------------------------
   --Outputs map                        
   ------------------------------------------------------ 
   
   FRM_DONE  <= done_i;
   
   RX_MISO.AFULL <= '0';
   RX_MISO.BUSY <= fsm_busy; 
   
   SCLK0 <= sclko_pipe(5);  -- decalage de 4 CLK par rapport à SD
   SD <= sd_i;
   CS_N <= cs_n_i; 
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U0 : sync_reset
   port map(ARESET => ARESET, CLK => CLK, SRESET => sreset); 
   
   
   ------------------------------------------------------
   -- synchronisation de l'horloge SPI                         
   ------------------------------------------------------ 
   U1: double_sync 
   generic map( INIT_VALUE => '0')
   port map(D => SCLKI, Q => sclki_sync, RESET => sreset, CLK => CLK);
   
   ------------------------------------------------------
   -- detection des changements d'etat de l'horloge SPI                         
   ------------------------------------------------------
   U2: process(CLK)
   begin       
      if rising_edge(CLK) then
         if sreset = '1' then 
            sclki_pipe <= (others => '0');
            proc_sclki_rise <= '0';
         else
            sclki_pipe(0) <= sclki_sync;
            sclki_pipe(7 downto 1) <= sclki_pipe(6 downto 0);
            
            proc_sclki_rise <= sclki_sync and not sclki_pipe(0);      -- front montant utilisé par le process de contrôle
            
         end if;
      end if;
   end process;  
   
   
   ------------------------------------------------------
   -- synchro
   ------------------------------------------------------
   U3: process (CLK)
   begin
      if rising_edge(CLK) then
         if sreset = '1' then
            bit_trig <= '0';
            proc_sclki_rise_delayed <= '0';
            sclko_pipe <= (others => '0');
         else
            proc_sclki_rise_delayed <= proc_sclki_rise;           -- ce decalage d'un CLK est requis pour s'aligner avec les sorties de la fsm de contrôle
            bit_trig <= byte_window and proc_sclki_rise_delayed;  -- definition de bit_trig             
            sclko_pipe(0) <= sclki_pipe(1) and byte_window;            
            sclko_pipe(7 downto 1) <= sclko_pipe(6 downto 0);     -- sclko_pipe(1) est parfaitement synchrone avec la donnée
         end if;  
      end if;
   end process; 
   
   
   ------------------------------------------------------
   -- fsm de contrôle 
   ------------------------------------------------------
   
   U4: process(CLK)
   begin       
      if rising_edge(CLK) then
         if sreset = '1' then 
            spi_fsm <= idle;
            done_i <= '1';
            byte_window <= '0';
            fsm_busy <= '1';
            valid_frame <= '0';
            eof_latch <= '0'; 
            sof_err <= '0';
            dout_reg <= (others => '0'); 
            cs_n_i <= '1';  
            sd_i <= '0';
            drem_err <= '0';
            ERR <= '0';
         else                    
            
            -- sortie des données
            if  bit_trig = '1' then 
               sd_i <= dout_reg(7);          -- le dout_reg(7) sort en premier
               dout_reg(7 downto 1) <= dout_reg(6 downto 0);
            end if;
            
            -- erreurs            
            if unsigned(RX_DREM) /= RX_MOSI.DATA'LENGTH then 
               drem_err <= not RX_MOSI.EOF and RX_MOSI.DVAL;
            end if;               
            ERR  <= sof_err or drem_err;            
            
            -- fsm de contrôle
            case spi_fsm is
               
               when idle =>
                  fsm_busy <= '0';
                  bit_cnt <= (others => '0');
                  if RX_MOSI.DVAL = '1' then 
                     if OUTPUT_MSB_FIRST then         
                        dout_reg <= RX_MOSI.DATA;                  -- pour que RX_MOSI.DATA(7) soit le premier bit à sortir sur le lien SPI        
                     else 
                        for ii in 0 to 7 loop 
                           dout_reg(ii) <= RX_MOSI.DATA(7 - ii);   -- pour que RX_MOSI.DATA(0) soit le premier bit à sortir sur le lien SPI 
                        end loop;
                     end if;                  
                     sof_err <= valid_frame and RX_MOSI.SOF;
                     --sof
                     if RX_MOSI.SOF = '1' then 
                        spi_fsm <= sync_sclk_st; 
                        fsm_busy <= '1';
                        valid_frame <= '1';
                     else
                        if valid_frame = '1' then
                           spi_fsm <= byte_window_st;
                           fsm_busy <= '1';
                        else
                           sof_err <= '1';   -- la trame ne commence pas par SOF. On ne fait rien.
                        end if;
                     end if;
                     --eof
                     if RX_MOSI.EOF = '1' then 
                        eof_latch <= '1';
                     end if;
                     -- drem
                     drem_latch <= unsigned(RX_DREM);               
                     
                  end if;          
               
               when sync_sclk_st =>
                  if proc_sclki_rise = '1' then 
                     spi_fsm <= assert_cs_st;
                     done_i <= '0';
                  end if;
               
               when assert_cs_st =>              
                  if proc_sclki_rise = '1' then 
                     cs_n_i <= '0';
                     spi_fsm <= byte_window_st;
                  end if;  
               
               when byte_window_st =>
                  if proc_sclki_rise = '1' then 
                     if bit_cnt < drem_latch then
                        byte_window <= '1';         -- byte windiow dure exactement 8 SPI_CLK
                     else
                        byte_window <= '0';
                        fsm_busy <= '0';
                        if eof_latch = '1' then 
                           spi_fsm <= desassert_cs_st;
                        else
                           spi_fsm <= idle; 
                        end if;
                     end if; 
                     bit_cnt <= bit_cnt + 1;                     
                  end if;   
               
               when desassert_cs_st =>
                  if proc_sclki_rise = '1' then 
                     cs_n_i <= '1';
                     eof_latch <= '0';
                     valid_frame <= '0';
                     spi_fsm <= done_st;
                  end if;  
               
               when done_st =>
                  done_i <= '1';
                  spi_fsm <= idle;
               
               when others =>
               
            end case;
            
         end if;
      end if;      
      
   end process;   
   
   
   ------------------------------------------------------
   --  ajustement des timings pour la sortie 
   ------------------------------------------------------ 
   -- U5: process(CLK)
   --   begin
   --      if rising_edge(CLK) then 
   --         if sreset = '1' then 
   --            sclki_sync_pipe <= (others => '0');
   --            sclko_reg_pipe <= (others => '0');
   --            sclko_reg <= '0';
   --            SCLK0 <= '0';
   --            CS_N  <= '1';
   --            byte_window_reg <= '0';
   --            cs_n_reg <= '0';
   --         else
   --            
   --            -- decalage de byte_window et cs_n_i pour s'aligner sur sdi
   --            if proc_sclki_rise = '1' then 
   --               byte_window_reg <= byte_window;
   --               cs_n_reg <= cs_n_i;
   --            end if;
   --            
   --            -- synchronisation de la clock avec byteWindow
   --            sclki_sync_pipe(0) <= sclki_sync;
   --            sclki_sync_pipe(2 downto 1) <= sclki_sync_pipe(1 downto 0);
   --            
   --            -- la clock valide le temps d'un transfert 
   --            sclko_reg <= sclki_sync_pipe(1) and byte_window;
   --            
   --            -- la clock est decalée de 3CLK avant la sortie 
   --            sclko_reg_pipe(0) <= sclko_reg;
   --            sclko_reg_pipe(2 downto 1) <= sclko_reg_pipe(1 downto 0);
   --            
   --            -- sortie finales synchroniées
   --            SCLK0 <= sclko_reg_pipe(2);
   --            SD    <= sd_i;
   --            CS_N  <= cs_n_i;         
   --         end if; 
   --      end if;   
   --   end process;
   --   
   
   
   
end rtl;
