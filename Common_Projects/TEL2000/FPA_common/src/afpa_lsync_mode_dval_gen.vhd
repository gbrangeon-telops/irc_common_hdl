------------------------------------------------------------------
--!   @file : afpa_lsync_mode_dval_gen
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------

-- ENO 27 sept 2017 :  
--    revision en profondeur pour tenir compte de le necessité de sortir les données hors AOI.
--    le flushing des fifos est abandonné. le frame sync ne sert qu'à l'initialisation. Ainsi, le mode IWR sera facilité puisque frame_sync est une entrave dans ce cas.  

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fpa_define.all;

entity afpa_lsync_mode_dval_gen is
   port(
      
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      FPA_INTF_CFG  : in fpa_intf_cfg_type;
      
      READOUT       : in std_logic;
      FPA_DIN       : in std_logic_vector(57 downto 0);
      FPA_DIN_DVAL  : in std_logic;
      READOUT_INFO  : in readout_info_type;
      
      DIAG_MODE_EN  : in std_logic;
      
      FPA_DOUT      : out std_logic_vector(71 downto 0);
      FPA_DOUT_DVAL : out std_logic;
      
      ERR           : out std_logic_vector(1 downto 0)
      );
end afpa_lsync_mode_dval_gen;


architecture rtl of afpa_lsync_mode_dval_gen is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component fwft_sfifo_w8_d256
      port (
         clk : in std_logic;
         rst : in std_logic;
         din : in std_logic_vector(7 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(7 downto 0);
         full : out std_logic;
         almost_full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
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
   
   type init_fsm_type is (init_st1, init_st2, init_st3, init_st4, init_done_st);
   type sync_fsm_type is (wait_init_done_st, idle, active_pixel_dly_st, launch_sync_st);   
   
   signal init_fsm          : init_fsm_type;
   
   signal sync_fsm          : sync_fsm_type;
   signal dly_cnt           : unsigned(7 downto 0); 
   signal sync_err_i        : std_logic;
   
   signal global_areset     : std_logic;
   signal sreset            : std_logic;
   signal init_done         : std_logic;
   signal pix_count         : unsigned(7 downto 0);
   
   signal frame_sync        : std_logic;
   signal frame_sync_last   : std_logic;
   signal img_start         : std_logic;
   signal img_end           : std_logic;
   signal din_dval_i        : std_logic;
   signal fpa_line_in_progress      : std_logic;
   
   
   signal flag_fifo_dval    : std_logic;
   signal flag_fifo_dout    : std_logic_vector(7 downto 0);
   signal flag_fifo_din     : std_logic_vector(7 downto 0);
   signal flag_fifo_wr      : std_logic;
   signal flag_fifo_rd      : std_logic;
   signal flag_fifo_ovfl    : std_logic;
   
   signal flag_fifo_rst     : std_logic;
   
   signal dout_o            : std_logic_vector(FPA_DOUT'LENGTH-1 downto 0);
   signal dout_wr_en_o      : std_logic;
   
   signal line_sync         : std_logic;      
   signal line_sync_last    : std_logic;
   signal line_sync_edge_detected : std_logic;
   signal err_i             : std_logic_vector(ERR'LENGTH-1 downto 0);
   signal readout_info_o    : readout_info_type;
   --attribute dont_touch     : string;
   --attribute dont_touch of dout_dval_o         : signal is "true"; 
   --attribute dont_touch of dout_o              : signal is "true";
   --attribute dont_touch of samp_fifo_ovfl      : signal is "true";
   --attribute dont_touch of flag_fifo_ovfl      : signal is "true";
   
begin
   
   --------------------------------------------------
   -- Outputs map
   -------------------------------------------------- 
   FPA_DOUT_DVAL <= dout_wr_en_o; 
   FPA_DOUT <= dout_o; --
   ERR <= err_i;
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------
   U1A: sync_reset
   port map(
      ARESET => global_areset,
      CLK    => CLK,
      SRESET => sreset
      ); 
   global_areset <= ARESET or DIAG_MODE_EN;   -- tout le module sera en reset tant qu'on est en mode diag    
   
   --------------------------------------------------
   -- quelques definitions
   -------------------------------------------------- 
   U1B: process(CLK)
   begin
      if rising_edge(CLK) then          
         
         -- erreurs
         err_i(0) <= sync_err_i or sync_err_i; 
         err_i(1) <= flag_fifo_ovfl;         
         
         -- sync_flag 
         frame_sync <= FPA_DIN(57);
         frame_sync_last <= frame_sync;
         
         din_dval_i <= FPA_DIN_DVAL;
         
         -- debut et fin de l'image
         img_start <= not frame_sync_last and frame_sync;
         img_end <= flag_fifo_dval and readout_info_o.read_end;
         
         -- line sync
         line_sync  <= FPA_DIN(56); 
         line_sync_last <= line_sync;       
         
         -- front montant ou descendant
         if DEFINE_FPA_SYNC_FLAG_VALID_ON_FE then 
            line_sync_edge_detected <= line_sync_last and not line_sync; 
         else
            line_sync_edge_detected <= not line_sync_last and line_sync; 
         end if;         
      end if;
   end process;
   
   --------------------------------------------------
   -- Process d'initialisation
   --------------------------------------------------
   U2: process(CLK)
      variable incr :std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            init_fsm <= init_st1;
            init_done <= '0';
            flag_fifo_rst <= '1';
            -- pragma translate_off
            init_fsm <= init_done_st;
            -- pragma translate_on
            
         else              
            
            case init_fsm is         -- ENO: 23 juillet 2014. les etats init_st sont requis pour éviter des problèmes de synchro          
               
               when init_st1 =>      
                  pix_count <= (others => '0');
                  if frame_sync = '1' then  -- je vois un signal de synchro
                     init_fsm <= init_st2;
                  end if;                                                                       
               
               when init_st2 =>     
                  if frame_sync = '0' then  -- je ne vois plus le signal de synchro
                     init_fsm <= init_st3;
                  end if;  
               
               when init_st3 =>
                  if din_dval_i = '1' then      
                     pix_count <= pix_count + DEFINE_FPA_TAP_NUMBER;
                  end if;                                           
                  if pix_count >= 64 then   -- je vois au moins un nombre de pixels équivalent à la plus petite ligne d'image de TEL-2000. cela implique que le système en amont est actif. je m'en vais en idle et attend la prochaine synchro 
                     init_fsm <= init_st4;     
                  end if;
               
               when init_st4 =>                        -- la carte ADC est connectée sinon on ne parviendra pas ici
                  if READOUT_INFO.READ_END = '1' then  -- je vois la tombée du fval d'une readout_info =>
                     init_fsm <= init_done_st; 
                  end if;
               
               when init_done_st =>
                  init_done <= '1';
                  flag_fifo_rst <= '0';
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process; 
   
   ----------------------------------------------------------------
   -- contrôle du synchronisateur des données avec les flags 
   ----------------------------------------------------------------
   U3: process(CLK)
      variable incr :std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then          
            sync_fsm <= wait_init_done_st;
            sync_err_i <= '0';
            fpa_line_in_progress <= '0';
            
         else        
            
            if readout_info_o.eol = '1' and FPA_DIN_DVAL = '1' then -- FPA_DIN_DVAL assure qu'effectivement eol est lu
               fpa_line_in_progress <= '0';
            end if;
            
            case sync_fsm is        
               
               when wait_init_done_st =>  -- si l'on quitte cet état, c'est que la fsm précédente assure que les deux flows seront synchronisables
                  if init_done = '1' then
                     sync_fsm <= idle;                     
                  end if;                   
               
               when idle =>               -- en idle, on sort les données non AOI
                  dly_cnt <= (others => '0');                  
                  if line_sync_edge_detected = '1' then
                     sync_fsm <= active_pixel_dly_st;
                  end if; 
               
               when active_pixel_dly_st =>  -- delai en nombre de samples avant d'aller chercher les pixels d'une ligne
                  incr := '0'& FPA_DIN_DVAL;
                  dly_cnt <= dly_cnt + to_integer(unsigned(incr));                 
                  if dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then -- REAL_MODE_ACTIVE_PIXEL_DLY est configurable via microblaze
                     sync_fsm <= launch_sync_st;                     
                  end if;                    
               
               when launch_sync_st =>     -- 
                  fpa_line_in_progress <= '1';
                  sync_err_i <= not flag_fifo_dval; -- erreur grave! pendant la sortie d'une ligne AOI, il manquait des données Flag. Problème de débit 
                  if FPA_DIN_DVAL = '1' then        -- on est certain ainsi que flag_fifo_rd a été activé
                     sync_fsm <= idle;          
                  end if;                   
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   --------------------------------------------------
   -- synchronisateur des données sortantes
   --------------------------------------------------
   U4: process(CLK)
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            dout_wr_en_o <= '0';
            
         else      
            
            -- ecriture des données en aval
            dout_wr_en_o <= init_done and (FPA_DIN_DVAL or img_start or img_end); -- les données sortent tout le temps. les flags permettront de distinguer le AOI du non_AOI 
            
            -- données écrite en aval
            if DEFINE_FPA_VIDEO_DATA_INVERTED = '1' then 
               dout_o(55 downto 0) <= not FPA_DIN(55 downto 0);
            else
               dout_o(55 downto 0) <= FPA_DIN(55 downto 0);   
            end if;            
            
            -- flags AOI
            dout_o(56) <= readout_info_o.lval and fpa_line_in_progress;
            dout_o(57) <= readout_info_o.sol and fpa_line_in_progress;                       -- aoi_sol
            dout_o(58) <= readout_info_o.eol and fpa_line_in_progress;                       -- aoi_eol
            dout_o(59) <= readout_info_o.fval;                                               -- aoi_fval 
            dout_o(60) <= readout_info_o.sof and fpa_line_in_progress;                       -- aoi_sof
            dout_o(61) <= readout_info_o.eof and fpa_line_in_progress;                       -- aoi_eof
            
            dout_o(62) <= readout_info_o.dval and fpa_line_in_progress and FPA_DIN_DVAL;     -- aoi_dval  (nouvel ajout)
            dout_o(63) <= img_start;                                                         -- img_start (nouvel ajout) À '1' dit qu'une image s'en vient. les pixels ne sont pas encore lus mais ils s'en viennent 
            dout_o(64) <= img_end;                                                           -- img_end   (nouvel ajout) À '1' dit que le AOI est terminée. Tous les pixels de l'AOI sont lus. Attention, peut monter à '1' bien après le dernier pixel de l'AOI.
            
            -- flags non AOI
            dout_o(65) <= not (fpa_line_in_progress and FPA_DIN_DVAL) and FPA_DIN_DVAL;                                 -- outside_aoi_dval    (ie non aoi data dval)
            
            -- spares pour le futur
            dout_o(71 downto 66) <= (others => '0');                                
            
         end if;
      end if;
   end process;
  
   ------------------------------------------------
   -- Gestionnaires des Flags
   ------------------------------------------------
   flag_fifo_rd <= (fpa_line_in_progress and FPA_DIN_DVAL) or readout_info_o.read_end;
   
   -- fag fifo mapping      
   U5A : fwft_sfifo_w8_d256
   port map (
      clk         => CLK,
      rst         => flag_fifo_rst,
      din         => flag_fifo_din,
      wr_en       => flag_fifo_wr,
      rd_en       => flag_fifo_rd,
      dout        => flag_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => flag_fifo_ovfl,
      empty       => open,
      valid       => flag_fifo_dval
      );
   
   -- flag fifo write
   U5B : process(CLK)
   begin
      if rising_edge(CLK) then         
         flag_fifo_din <= READOUT_INFO.SOF & READOUT_INFO.EOF & READOUT_INFO.SOL & READOUT_INFO.EOL & READOUT_INFO.FVAL & READOUT_INFO.LVAL & READOUT_INFO.DVAL & READOUT_INFO.READ_END;
         flag_fifo_wr <= (READOUT_INFO.SAMP_PULSE and READOUT_INFO.DVAL) or  READOUT_INFO.READ_END; -- remarquer qu'on n'ecrit pas les samples d'interligne! on écrit juste les données AOI !!!!!       
      end if;
   end process;        
   
   -- flag fifo out 
   readout_info_o.sof  <= flag_fifo_dout(7);
   readout_info_o.eof  <= flag_fifo_dout(6);
   readout_info_o.sol  <= flag_fifo_dout(5);
   readout_info_o.eol  <= flag_fifo_dout(4);
   readout_info_o.fval <= flag_fifo_dout(3);
   readout_info_o.lval <= flag_fifo_dout(2);
   readout_info_o.dval <= flag_fifo_dout(1);
   readout_info_o.read_end <= flag_fifo_dout(0);
   
end rtl;

