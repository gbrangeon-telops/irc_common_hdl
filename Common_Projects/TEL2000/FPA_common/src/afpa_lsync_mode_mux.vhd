------------------------------------------------------------------
--!   @file : mglk_DOUT_DVALiter
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
use IEEE.NUMERIC_STD.all;
use work.fpa_define.all;
use work.fpa_common_pkg.all; 

entity afpa_lsync_mode_mux is
   port (
      ARESET          : in std_logic;
      CLK             : in std_logic;
      
      FPA_INTF_CFG    : in fpa_intf_cfg_type;
      
      READOUT_INFO_I  : in readout_info_type;
      READOUT_INFO_O  : out readout_info_type;
      
      LINE_GEN_ENABLE : out std_logic_vector(1 downto 0);
      
      READOUT         : in std_logic;
      DIN             : in std_logic_vector(57 downto 0);
      DIN_DVAL        : in std_logic;
      
      FLUSH_FIFO      : out std_logic      
      );  
end afpa_lsync_mode_mux;


architecture rtl of afpa_lsync_mode_mux is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component double_sync is
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D     : in std_logic;
         Q     : out std_logic := '0';
         RESET : in std_logic;
         CLK   : in std_logic
         );
   end component;
   
   type line_mux_fsm_type is (init_st1, init_st2, init_st3, init_st4, idle, sync_flow_st, wait_feedback_st, flush_fifo_st);
   signal line_mux_fsm     : line_mux_fsm_type;
   signal sreset            : std_logic;
   signal flush_fifo_i      : std_logic;
   signal dly_cnt           : unsigned(7 downto 0);
   signal readout_sync      : std_logic;
   signal pix_count         : unsigned(7 downto 0);   
   signal readout_info_pipe : readout_info_type;
   signal frame_sync        : std_logic;
   signal line_gen_enable_i : unsigned(1 downto 0);
   signal din_dval_i        : std_logic;
   signal sol_last          : std_logic;
   
   --attribute dont_touch     : string;
   --attribute dont_touch of dout_dval_o         : signal is "true"; 
   --attribute dont_touch of dout_o              : signal is "true";
   --attribute dont_touch of samp_fifo_ovfl      : signal is "true";
   --attribute dont_touch of flag_fifo_ovfl      : signal is "true";
   
begin
   
   --------------------------------------------------
   -- Outputs map
   -------------------------------------------------- 
   READOUT_INFO_O <= readout_info_pipe;
   FLUSH_FIFO <= flush_fifo_i;
   LINE_GEN_ENABLE <= std_logic_vector(line_gen_enable_i);
   
   --------------------------------------------------
   -- synchro 
   --------------------------------------------------   
   U1A: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );      
   
   U1B : double_sync
   port map(
      CLK => CLK,
      D   => READOUT,
      Q   => readout_sync,
      RESET => sreset
      );
   
   --------------------------------------------------
   -- Process
   --------------------------------------------------
   U2: process(CLK)
      variable incr :std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            line_mux_fsm <= init_st1;
            flush_fifo_i <= '0';       -- ENO 20 nov 2015 : fait expres sinon en mode diag sreset = '1' et les fifos seront en reset. Le ARESET flushera le fifo (voir generation de QUAD_FIFO_RST fifo)
            line_gen_enable_i <= (others => '0');
            -- pragma translate_off
            line_mux_fsm <= idle;
            -- pragma translate_on
            
         else           
            
            frame_sync <= DIN(57);             -- sync_flag 
            din_dval_i <= DIN_DVAL;           
            
            readout_info_pipe <= READOUT_INFO_I;      -- pour une synchro avec line_gen_enable_i
            
            sol_last <= READOUT_INFO_I.SOL;
            
            case line_mux_fsm is         -- ENO: 23 juillet 2014. les etats init_st sont requis pour éviter des problèmes de synchro          
               
               when init_st1 =>      
                  flush_fifo_i <= '0';
                  pix_count <= (others => '0');
                  if frame_sync = '1' then  -- je vois un signal de synchro
                     line_mux_fsm <= init_st2;
                  end if;                                                                       
               
               when init_st2 =>     
                  if frame_sync = '0' then  -- je ne vois plus le signal de synchro
                     line_mux_fsm <= init_st3;
                  end if;  
               
               when init_st3 =>
                  if din_dval_i = '1' then      
                     pix_count <= pix_count + DEFINE_FPA_TAP_NUMBER;
                  end if;                                           
                  if pix_count >= 64 then    -- je vois au moins un nombre de pixels équivalent à la plus petite ligne d'image de TEL-2000. cela implique que le système en amont est actif. je m'en vais en idle et attend la prochaine synchro 
                     line_mux_fsm <= init_st4;     
                  end if;
               
               when init_st4 =>             -- la carte ADc est connectée sinon on ne parviendra pas ici
                  if READOUT_INFO_I.READ_END = '1' then  -- je vois la tombée du fval d'une readout_info =>
                     line_mux_fsm <= idle; 
                  end if;
                  
               -- une fois ici, je suis certain que les deux flows seront synchronisables
               when idle =>   
                  flush_fifo_i <= '0';
                  line_gen_enable_i <= "00";
                  dly_cnt <= (others => '0');
                  if frame_sync = '1' then      
                     line_mux_fsm <= sync_flow_st;
                     line_gen_enable_i <= "01";
                  end if;
               
               when sync_flow_st =>
                  if READOUT_INFO_I.SOL = '1' and sol_last = '0' then 
                     line_gen_enable_i <= not line_gen_enable_i;
                  end if;
                  if READOUT_INFO_I.READ_END = '1'  then      --
                     line_mux_fsm <= wait_feedback_st;
                  end if;
               
               when wait_feedback_st =>
                  if readout_sync = '0' then    -- on attend la fin du readout en aval pour reset des fifos
                     line_mux_fsm <= flush_fifo_st;
                  end if;
               
               when flush_fifo_st =>            -- le reset dure 20 coups d'horloge. Le fifo est reseté pour qu'un manque de pixel dans l'image actuelle n'affecte pas la suivante.
                  flush_fifo_i <= '1';
                  dly_cnt <= dly_cnt + 1;
                  if dly_cnt = 20 then 
                     line_mux_fsm <= idle; 
                  end if;                       
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
end rtl;