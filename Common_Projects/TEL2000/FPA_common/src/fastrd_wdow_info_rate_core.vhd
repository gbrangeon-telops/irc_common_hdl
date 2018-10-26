------------------------------------------------------------------
--!   @file : fastrd_wdow_info_rate_core
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
use work.fpa_define.all;
use work.fpa_common_pkg.all; 

entity fastrd_wdow_info_rate_core is
   port(
      
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      -- fifos des horloges traitées      
      FAST_CLK_EN    : out std_logic;
      FAST_CLK_DATA  : in std_logic_vector(7 downto 0);
      FAST_CLK_DVAL  : in std_logic;
      
      CLK_FIFO_RDY   : in std_logic;    -- à '1' lorsque le fifo de l'horloge la plus lente est prête. Donc tous les fifoos sont prêts
      
      --SLOW_CLK_EN    : out std_logic;
      --SLOW_CLK_DATA  : in std_logic_vector(7 downto 0);
      --SLOW_CLK_DVAL  : in std_logic;
      
      IFIFO_DCNT    : in std_logic_vector(9 downto 0);
      OFIFO_DCNT    : in std_logic_vector(9 downto 0);
      
      WDOW_MCLK     : out std_logic;
      WDOW_PCLK     : out std_logic
      
      );
end fastrd_wdow_info_rate_core;

architecture rtl of fastrd_wdow_info_rate_core is

constant OFIFO_DEPTH          : natural := 512; -- taille du fifo de sortie qui ne doit jamais deborder ni se vider
constant PIPE_DLY             : natural := 30;  -- estimation de la taille du pipe avant d'atteindre le in_fifo
constant SECUR_MARGIN         : natural := 50;  -- marge de scurité

constant FIFO_HIGH_THRESHOLD  : natural := MAX(OFIFO_DEPTH - PIPE_DLY*DEFINE_FPA_PCLK_RATE_FACTOR - SECUR_MARGIN, 128);
constant FIFO_LOW_THRESHOLD   : natural := FIFO_HIGH_THRESHOLD/2;

   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   type dcnt_fsm_type is (clk_on_st, clk_off_st);   
   
   signal wdow_pclk_i         : std_logic;
   signal wdow_mclk_i         : std_logic;
   signal sreset              : std_logic;
   signal fast_mclk_sof       : std_logic;
   signal fast_mclk_eof       : std_logic;
   signal fast_mclk           : std_logic;
   signal fast_pclk_sof       : std_logic;
   signal fast_pclk_eof       : std_logic;
   signal fast_pclk           : std_logic;
   signal idcnt_fsm           : dcnt_fsm_type;
   signal odcnt_fsm           : dcnt_fsm_type;
   signal i_fast_clk_fifo_rd  : std_logic;
   signal o_fast_clk_fifo_rd  : std_logic;
   signal fast_clk_fifo_rd    : std_logic;
   signal fifo_dcnt           : natural := 0;
   signal in_fifo_conv        : natural;
   
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------
   FAST_CLK_EN <= o_fast_clk_fifo_rd;
   --SLOW_CLK_EN <= slow_clk_fifo_rd_i;
   WDOW_MCLK    <= wdow_mclk_i;
   WDOW_PCLK    <= wdow_pclk_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   --------------------------------------------------
   --  decodage de la sortie du fifo des horloges
   --------------------------------------------------
   --slow_mclk_sof <= SLOW_CLK_DATA(5); 
   --slow_mclk_eof <= SLOW_CLK_DATA(4); 
   --slow_mclk     <= SLOW_CLK_DATA(3); 
   --slow_pclk_sof <= SLOW_CLK_DATA(2); 
   --slow_pclk_eof <= SLOW_CLK_DATA(1); 
   --slow_pclk     <= SLOW_CLK_DATA(0); 
   
   fast_mclk_sof <= FAST_CLK_DATA(5); 
   fast_mclk_eof <= FAST_CLK_DATA(4); 
   fast_mclk     <= FAST_CLK_DATA(3); 
   fast_pclk_sof <= FAST_CLK_DATA(2); 
   fast_pclk_eof <= FAST_CLK_DATA(1); 
   fast_pclk     <= FAST_CLK_DATA(0);
   
   ----------------  ----------------------------------
   --  lecture des fifos et synchronisation
   --------------------------------------------------
   U3: process(CLK)
      variable inc : unsigned(1 downto 0);
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then            
            i_fast_clk_fifo_rd <= '0';
            o_fast_clk_fifo_rd <= '0';
            fast_clk_fifo_rd <= '0';
            in_fifo_conv <= 0;
            
         else  
            
            
            fast_clk_fifo_rd <= o_fast_clk_fifo_rd; 
            in_fifo_conv <= to_integer(unsigned(IFIFO_DCNT)) * DEFINE_FPA_PCLK_RATE_FACTOR;
            fifo_dcnt <= in_fifo_conv + to_integer(unsigned(OFIFO_DCNT));          
            
            -----------------------------------------------------------------
            -- odcnt                      
            -----------------------------------------------------------------
            case odcnt_fsm is
               
               when clk_on_st =>                  
                  o_fast_clk_fifo_rd <= CLK_FIFO_RDY;
                  if fifo_dcnt > FIFO_HIGH_THRESHOLD then    -- ie tant que (OFIFO_DCNT + (IFIFO_DCNT + PIPE_DLY)*DEFINE_FPA_PCLK_RATE_FACTOR + SECUR_MARGIN < OFIFO_DEPTH) on peut utiliser le fast_clk   
                     odcnt_fsm <= clk_off_st;
                  end if;                   
               
               when clk_off_st =>
                  if fast_pclk_eof = '1' then
                     o_fast_clk_fifo_rd <= '0';
                  end if;				  
                  if fifo_dcnt < FIFO_LOW_THRESHOLD then       
                     odcnt_fsm <= clk_on_st;
                  end if;
                  
               when others =>
               
            end case;
            
            
         end if;
      end if;
   end process; 
   
   ----------------------------------------------------
   --  sortie des données
   --------------------------------------------------
   U4: process(CLK)
   begin
      if rising_edge(CLK) then 
         
         -- Clocks 
         wdow_mclk_i <= fast_mclk and o_fast_clk_fifo_rd; 
         wdow_pclk_i <= fast_pclk and o_fast_clk_fifo_rd;
         
      end if;
   end process;    
   
end rtl;
