---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: spi_tx.vhd
--  Use: general purpose spi master interface (DACs etc...)
--  Author: ENO
--
--  $Revision: 16251 $
--  $Author: enofodjie $
--  $LastChangedDate: 2015-07-02 19:16:22 -0400 (jeu., 02 juil. 2015) $
--
--  Notes: core divides incoming clock by CLKDIV to generate SPI clock must be at least a factor
--         of 2
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE. numeric_std.all;
use work.fpa_common_pkg.all;

entity LL8_ext_to_spi_tx is
   generic( 
      OUTPUT_MSB_FIRST : boolean := false;     -- si à true, alors RX_MOSI.DATA(7) est le premier bit à sortir sur le lien SPI. Cela signifie une sortie des bits 7 dowto 0
      -- si à false alors RX_MOSI.DATA(0) est le premier bit à sortir sur le lien SPI. Cela signifie une sortie des bits 0 to 7
      DATA_TO_CS_DLY : natural range 1 to 31 := 1;  -- delai en coups de SCLK entre la tombée de CS_N et la premiere donnée de SD. SCLK0 est à '0' durant ce delai
      CS_TO_DATA_DLY : natural range 1 to 31 := 1   -- delai en coups de SCLK entre le dernier SD et la remontee de CS_N. SCLK0 est à '0' durant ce delai   
      );
   
   port(
      -- general
      ARESET   : in std_logic;
      CLK      : in std_logic; 
      
      -- flow d'entrée
      RX_MOSI  : in t_ll_ext_mosi8;
      RX_MISO  : out t_ll_ext_miso;
      RX_DREM  : in std_logic_vector(3 downto 0); -- DREM = 8, 7, 6, ....1, pour signifier le nnombre de Bit valides dans le EOF 
      
      -- clock SPI fournie
      SCLKI    : in std_logic;      
      
      -- lien sortant spi master
      SCLK0    : out std_logic;      -- vaut SCLKI decalé de 1CLK
      SD       : out std_logic;
      CS_N     : out std_logic;
      FRM_DONE : out std_logic;      --indique la fin de l'envoi d'une trame commeneçant par SOF et se terminant par EOF
      
      --err
      ERR      : out std_logic 
      );
end LL8_ext_to_spi_tx;

architecture rtl of LL8_ext_to_spi_tx is
   
   component double_sync
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D : in std_logic;
         Q : out std_logic := '0';
         RESET : in std_logic;
         CLK : in std_logic
         );
   end component;
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   component fwft_sfifo_w3_d16
      port (
         clk : in std_logic;
         rst : in std_logic;
         din : in std_logic_vector(2 DOWNTO 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(2 DOWNTO 0);
         full : out std_logic;
         almost_full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;
   
   type spi_fsm_type  is (init_st, wait_data_st, check_sof_st, check_eof_st, active_cs_st, inactive_cs_st, output_data_st, cs_to_data_dly_st, data_to_cs_dly_st);
   type fifo_fsm_type is (idle, wait_data_st, wait_param_st, build_data_st, build_data_st2, wr_data_st, check_wr_end_st);
   
   signal fifo_fsm                  : fifo_fsm_type;
   signal spi_fsm                   : spi_fsm_type;
   signal sd_o                      : std_logic;
   signal cs_n_o                    : std_logic;
   signal sclk_o                    : std_logic;
   signal frm_done_i                : std_logic;
   signal sreset                    : std_logic; 
   signal bit_cnt                   : unsigned(3 downto 0);
   signal busy_i                    : std_logic;
   --signal rx_mosi_i                 : t_ll_ext_mosi8;
   signal rx_mosi_latch             : t_ll_ext_mosi8;
   signal fifo_din                  : std_logic_vector(2 downto 0);
   signal fifo_dout                 : std_logic_vector(2 downto 0);
   signal fifo_wr_en                : std_logic;
   signal fifo_rd_en                : std_logic;
   signal fifo_dval                 : std_logic;
   signal fifo_afull                : std_logic; 
   signal bitcnt                    : integer range -1 to 8;
   signal bitcnt_start              : natural range 0 to 7;
   signal bitcnt_end                : natural range 0 to 7;
   signal bitcnt_inc                : integer range -1 to 1;
   signal sclk_last                 : std_logic;
   signal sof_o, eof_o, dout_o      : std_logic;
   signal dly_cnt                   : natural range 0 to 31;
   --signal sclko_reg                 : std_logic;
   --signal byte_window_reg           : std_logic;
   --signal cs_n_reg                  : std_logic;
   
begin
   
   ------------------------------------------------------
   --Outputs map                        
   ------------------------------------------------------   
   RX_MISO.AFULL <= '0';
   RX_MISO.BUSY <= busy_i; 
   
   Ureg : process(CLK)
   begin
      if rising_edge(CLK) then    
         SCLK0 <= sclk_o;
         SD <= sd_o;
         CS_N <= cs_n_o; 
         FRM_DONE  <= frm_done_i;    
      end if;
   end process;
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U0 : sync_reset
   port map(ARESET => ARESET, CLK => CLK, SRESET => sreset); 
   
   --------------------------------------------------
   -- parametres 
   -------------------------------------------------- 
   U1_false : if not OUTPUT_MSB_FIRST generate
      begin
      U1_p: process(CLK)
      begin
         if rising_edge(CLK) then
            bitcnt_start <= 0;
            if busy_i = '0' and RX_MOSI.DVAL = '1' then
               bitcnt_end <= to_integer(unsigned(RX_DREM))-1; 
            end if;
            bitcnt_inc <= 1;
         end if;
      end process; 
   end generate;   
   
   U1_true : if OUTPUT_MSB_FIRST generate
      begin
      process(CLK)
      begin
         if rising_edge(CLK) then
            if busy_i = '0' and RX_MOSI.DVAL = '1' then
               bitcnt_start <= to_integer(unsigned(RX_DREM))-1;
            end if;
            bitcnt_end <= 0;
            bitcnt_inc <= -1;
         end if;
      end process;
   end generate;
   
   --------------------------------------------------
   -- input fifo
   -------------------------------------------------- 
   U2 : fwft_sfifo_w3_d16  
   port map (
      rst => ARESET,
      clk => CLK,
      din => fifo_din,
      wr_en => fifo_wr_en,
      rd_en => fifo_rd_en,
      dout => fifo_dout,
      valid  => fifo_dval,
      full => open,
      almost_full => fifo_afull,
      overflow => open,
      empty => open
      );
   
   ------------------------------------------------------
   -- Écriture dans le fifo 
   ------------------------------------------------------
   U3: process(CLK)
   begin       
      if rising_edge(CLK) then
         if sreset = '1' then 
            fifo_fsm <= idle;
            fifo_wr_en <= '0';
            busy_i <= '1';
            ERR <= '0';
         else                    
            
            if unsigned(RX_DREM) = 0 then
               ERR <= rx_mosi_latch.dval;
            end if;
            
            case fifo_fsm is
               
               when idle =>  
                  fifo_wr_en <= '0';
                  busy_i <= '0';                  
                  fifo_fsm <= wait_data_st;
               
               when wait_data_st => 
                  if RX_MOSI.DVAL = '1' then
                     fifo_fsm <= wait_param_st;
                     busy_i <= '1';
                     rx_mosi_latch <= RX_MOSI;
                  end if;
               
               when wait_param_st =>      -- cet etat est requis pour que bitcnt_start soit valide
                  bitcnt <= bitcnt_start; 
                  fifo_fsm <= build_data_st;
               
               when build_data_st => 
                  fifo_din(1) <= '0';
                  fifo_din(2) <= '0';
                  if bitcnt = bitcnt_start then       -- les parametres bitcnt_start, bitcnt_end, bitcnt_inc et rx_mosi_latch sont valides 1CLK apres
                     fifo_din(2) <= rx_mosi_latch.sof;
                  elsif bitcnt = bitcnt_end then
                     fifo_din(1) <= rx_mosi_latch.eof;
                  end if;
                  fifo_fsm <= wr_data_st;
               
               when wr_data_st =>              
                  fifo_din(0) <= rx_mosi_latch.data(bitcnt);
                  fifo_wr_en <= not fifo_afull;
                  if fifo_afull = '0' then
                     fifo_fsm <= check_wr_end_st;
                  end if;
               
               when check_wr_end_st =>
                  fifo_wr_en <= '0';
                  bitcnt <= bitcnt + bitcnt_inc; 
                  if bitcnt = bitcnt_end then
                     fifo_fsm <= idle;
                  else
                     fifo_fsm <= build_data_st;
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;   
   
   ------------------------------------------------------
   -- fsm de contrôle 
   ------------------------------------------------------
   sof_o <= fifo_dout(2);
   eof_o <= fifo_dout(1);
   dout_o <= fifo_dout(0);
   
   U4: process(CLK)
   begin       
      if rising_edge(CLK) then
         if sreset = '1' then 
            spi_fsm <= init_st;
            cs_n_o <= '1';  
            fifo_rd_en <= '0';
            frm_done_i <= '0';
            sclk_last <= '1';
            sclk_o <= '0';
            sd_o <= '0';    -- ENO 22 dec 2015 : fait expres car requis pour plusieurs detecteurs (indigo surtout)
         else                    
            
            sclk_last <= SCLKI;
            
            -- sclk_o se remet automatiquemnt à '0' sur le fe de SCLKI
            if SCLKI = '0' and sclk_last = '1' then 
               sclk_o <= '0';
            end if;
            
            -- fsm de contrôle
            case spi_fsm is
               
               when init_st =>
                  frm_done_i <= '1';
                  spi_fsm <= wait_data_st; 
               
               when wait_data_st =>  
                  dly_cnt <= 1;
                  fifo_rd_en <= '0';
                  if fifo_dval = '1' then
                     spi_fsm <= check_sof_st; 
                  end if;
               
               when check_sof_st =>
                  if sof_o = '1' then
                     spi_fsm <= active_cs_st; 
                  else
                     spi_fsm <=  output_data_st;   -- s'il n'ya jamais eu de sof, alors cs_n ne sera jamais activé bien que la fsm  roule
                  end if;
               
               when active_cs_st =>
                  frm_done_i <= '0';
                  if SCLKI = '1' and sclk_last = '0' then 
                     cs_n_o <= '0';
                     spi_fsm <= cs_to_data_dly_st;
                  end if; 
               
               when cs_to_data_dly_st =>
                  if SCLKI = '1' and sclk_last = '0' then
                     dly_cnt <= dly_cnt + 1;
                  end if;
                  if dly_cnt >= CS_TO_DATA_DLY then
                     spi_fsm <= output_data_st;
                  end if;                          
               
               when output_data_st =>
                  dly_cnt <= 1;
                  if SCLKI = '1' and sclk_last = '0' then 
                     sd_o <= dout_o;
                     sclk_o <= '1';                     
                     spi_fsm <= check_eof_st;   
                  end if;                                 
               
               when check_eof_st =>
                  if eof_o = '1' then
                     spi_fsm <= data_to_cs_dly_st;
                  else
                     spi_fsm <= wait_data_st;
                  end if;
                  fifo_rd_en <= '1';
               
               when data_to_cs_dly_st => 
                  fifo_rd_en <= '0';
                  if SCLKI = '1' and sclk_last = '0' then
                     dly_cnt <= dly_cnt + 1;
                  end if;
                  if dly_cnt >= DATA_TO_CS_DLY then
                     spi_fsm <= inactive_cs_st;
                  end if;   
               
               when inactive_cs_st =>                  
                  if SCLKI = '1' and sclk_last = '0' then 
                     sd_o <= '0';    -- ENO 22 dec 2015 : fait expres car requis pour plusieurs detecteurs (indigo surtout)
                     cs_n_o <= '1';
                     frm_done_i <= '1';
                     spi_fsm <= wait_data_st;
                  end if;  
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;     
   
   
end rtl;
