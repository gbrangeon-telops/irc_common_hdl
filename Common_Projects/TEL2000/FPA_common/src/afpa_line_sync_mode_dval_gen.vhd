------------------------------------------------------------------
--!   @file : afpa_line_sync_mode_dval_gen
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
--    le flushing des fifos est abandonné. le frame sync ne sert qu'à l'initialisation. Ainsi, le mode IWR sera facilité puisque frame_sync aurait été une entrave.  

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fpa_define.all;

entity afpa_line_sync_mode_dval_gen is
   port(
      
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      FPA_INTF_CFG  : in fpa_intf_cfg_type;
      
      READOUT       : in std_logic;
      FPA_DIN       : in std_logic_vector(71 downto 0);
      FPA_DIN_DVAL  : in std_logic;
      READOUT_INFO  : in readout_info_type;
      
      ENABLE        : in std_logic;
      
      FPA_DOUT      : out std_logic_vector(95 downto 0);
      FPA_DOUT_DVAL : out std_logic;
      
      STAT           : out std_logic_vector(7 downto 0)
      );
end afpa_line_sync_mode_dval_gen;


architecture rtl of afpa_line_sync_mode_dval_gen is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component fwft_sfifo_w32_d256
      port (
         clk : in std_logic;
         srst: in std_logic;
         din : in std_logic_vector(31 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(31 downto 0);
         full : out std_logic;
         almost_full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;
   
   component fwft_sfifo_w16_d256 is
      Port ( 
         clk : in std_logic;
         srst : in std_logic;
         din : in std_logic_vector(15 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(15 downto 0);
         full : out std_logic;
         almost_full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic;
         data_count : out std_logic_vector ( 8 downto 0 );
         prog_full : out std_logic
         );
   end component;
   
   component var_shift_reg_w16_d32 is
      Port ( 
         A    : in std_logic_vector(4 downto 0);
         D    : in std_logic_vector(15 downto 0);
         CLK  : in std_logic;
         CE   : in std_logic;
         SCLR : in std_logic;
         Q : out std_logic_vector(15 downto 0)
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
   
   constant C_AOI_LSYNC_POS   : natural := 56;
   constant C_AOI_FSYNC_POS   : natural := 57; 
   constant C_NAOI_START_POS  : natural := 58;
   
   type init_fsm_type is (init_st1, init_st2, init_st3, init_st4, init_done_st, non_init_done_st);
   --type sync_fsm_type is (wait_init_done_st, idle, active_data_dly_st, launch_sync_st);   
   
   signal init_fsm                  : init_fsm_type;
   
   --signal aoi_sync_fsm              : sync_fsm_type;
   --signal naoi_sync_fsm             : sync_fsm_type;  
   signal aoi_dly_cnt               : unsigned(7 downto 0);
   signal naoi_dly_cnt              : unsigned(7 downto 0); 
   signal sync_err_i                : std_logic := '0';
   
   signal global_areset             : std_logic;
   signal sreset                    : std_logic;
   signal aoi_init_done             : std_logic;
   signal naoi_init_done            : std_logic;
   signal pix_count                 : unsigned(7 downto 0);
   
   signal frame_sync_last           : std_logic;
   signal adc_flag                  : std_logic_vector(15 downto 0);
   signal adc_flag_dval             : std_logic;
   
   signal adc_flag_fifo_dval        : std_logic;
   signal adc_flag_fifo_dout        : std_logic_vector(15 downto 0);
   signal adc_flag_fifo_din         : std_logic_vector(15 downto 0);
   signal adc_flag_fifo_wr          : std_logic;
   signal adc_flag_fifo_rd          : std_logic;
   signal adc_flag_fifo_ovfl        : std_logic;                                    
   signal adc_flag_fifo_rst         : std_logic;
   
   signal aoi_in_progress           : std_logic;  
   signal aoi_flag_fifo_dval        : std_logic;
   signal aoi_flag_fifo_dout        : std_logic_vector(31 downto 0);
   signal aoi_flag_fifo_din         : std_logic_vector(31 downto 0);
   signal aoi_flag_fifo_wr          : std_logic;
   signal aoi_flag_fifo_rd          : std_logic;
   signal aoi_flag_fifo_ovfl        : std_logic;                                    
   signal aoi_flag_fifo_rst         : std_logic;
   
   signal naoi_in_progress          : std_logic;  
   signal naoi_flag_fifo_dval       : std_logic;
   signal naoi_flag_fifo_dout       : std_logic_vector(31 downto 0);
   signal naoi_flag_fifo_din        : std_logic_vector(31 downto 0);
   signal naoi_flag_fifo_wr         : std_logic;
   signal naoi_flag_fifo_rd         : std_logic;
   signal naoi_flag_fifo_ovfl       : std_logic;                                    
   signal naoi_flag_fifo_rst        : std_logic;
   
   signal dout_o                    : std_logic_vector(FPA_DOUT'LENGTH-1 downto 0);
   signal dout_wr_en_o              : std_logic;
   
   signal aoi_line_sync_last            : std_logic;
   signal aoi_line_sync_edge_detected   : std_logic;
   signal err_i                     : std_logic_vector(1 downto 0);
   signal readout_info_o            : readout_info_type;
   signal naoi_start_last           : std_logic;
   signal naoi_start_edge_detected  : std_logic;
   signal fpa_din_dval_last         : std_logic;
   signal adc_flag_last_o           : std_logic_vector(adc_flag'length-1 downto 0);
   signal adc_flag_o                : std_logic_vector(adc_flag'length-1 downto 0);
   signal aoi_rd_end_i              : std_logic;
   signal aoi_rd_end_last           : std_logic;
   signal naoi_stop_i               : std_logic;
   signal naoi_stop_last            : std_logic;
   signal global_init_done          : std_logic;
   
   ---- attribute dont_touch     : string;
   ---- attribute dont_touch of dout_dval_o         : signal is "true"; 
   ---- attribute dont_touch of dout_o              : signal is "true";
   ---- attribute dont_touch of samp_fifo_ovfl      : signal is "true";
   ---- attribute dont_touch of aoi_flag_fifo_ovfl      : signal is "true";
   
begin
   --------------------------------------------------
   -- notes importantes
   --------------------------------------------------   
   -- note 1: ENO: 22 avril 2019
   --    en clair ne jamais generer les signaux naoi si DEFINE_GENERATE_ELCORR_CHAIN = 0 pour eviter des bugs de non sortie d'images.
   
   
   --------------------------------------------------
   -- Outputs map
   -------------------------------------------------- 
   FPA_DOUT_DVAL <= dout_wr_en_o; 
   FPA_DOUT <= dout_o; --
   STAT(2) <= err_i(1);
   STAT(1) <= err_i(0);
   STAT(0) <= global_init_done;
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------
   U1: sync_reset
   port map(
      ARESET => global_areset,
      CLK    => CLK,
      SRESET => sreset
      ); 
   global_areset <= ARESET or not ENABLE;   -- tout le module sera en reset tant qu'on est en mode diag    
   
   --------------------------------------------------
   -- quelques definitions
   -------------------------------------------------- 
   U2: process(CLK)
   begin
      if rising_edge(CLK) then          
         
         fpa_din_dval_last <= FPA_DIN_DVAL;
         
         -- erreurs
         err_i(0) <= sync_err_i; 
         err_i(1) <= aoi_flag_fifo_ovfl or adc_flag_fifo_ovfl or naoi_flag_fifo_ovfl;         
         
         -- sync_flag 
         frame_sync_last <= FPA_DIN(C_AOI_FSYNC_POS);
         aoi_line_sync_last  <= FPA_DIN(C_AOI_LSYNC_POS); 
         naoi_start_last <= FPA_DIN(C_NAOI_START_POS); 
         
         -- les flags adc considérés dans le shifregister
         adc_flag(0)   <= FPA_DIN(C_AOI_LSYNC_POS); -- FPA_DIN(C_AOI_LSYNC_POS) and not aoi_line_sync_last;   -- aoi_lsync :  on considere uniqument les RE
         adc_flag(1)   <= FPA_DIN(C_NAOI_START_POS);-- FPA_DIN(C_NAOI_START_POS) and not naoi_start_last;     -- naoi_start:  on considere uniqument les RE
         adc_flag_dval <= FPA_DIN_DVAL and global_init_done;--(not fpa_din_dval_last and FPA_DIN_DVAL) and aoi_init_done and naoi_init_done;  --  on considere uniqument les RE 
         
         -- front montant ou descendant
         if DEFINE_FPA_SYNC_FLAG_VALID_ON_FE then 
            aoi_line_sync_edge_detected <= aoi_line_sync_last and not FPA_DIN(C_AOI_LSYNC_POS); 
            naoi_start_edge_detected <= naoi_start_last and not FPA_DIN(C_NAOI_START_POS); 
         else
            aoi_line_sync_edge_detected <= not aoi_line_sync_last and FPA_DIN(C_AOI_LSYNC_POS);
            naoi_start_edge_detected <= not naoi_start_last and FPA_DIN(C_NAOI_START_POS); 
         end if;    
         
         -- 
      end if;
   end process;
   
   --------------------------------------------------
   -- Process d'initialisation
   --------------------------------------------------
   U3: process(CLK)
      variable incr :std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            init_fsm <= init_done_st;
            aoi_init_done <= '0';
            naoi_init_done <= '0';
            aoi_flag_fifo_rst <= '1';
            naoi_flag_fifo_rst <= '1';
            aoi_rd_end_last <= aoi_rd_end_i;
            naoi_stop_last <= naoi_stop_i;
            naoi_stop_i <= '0';
            global_init_done <= '0';
            -- pragma translate_off
            init_fsm <= init_done_st;
            -- pragma translate_on
            
         else              
            
            aoi_rd_end_i <= READOUT_INFO.AOI.READ_END;
            aoi_rd_end_last <= aoi_rd_end_i;
            
            naoi_stop_i <= READOUT_INFO.NAOI.STOP;
            naoi_stop_last <= naoi_stop_i;
            
            case init_fsm is         -- ENO: 23 juillet 2014. les etats init_st sont requis pour éviter des problèmes de synchro          
               
               when init_done_st => 
                  if aoi_rd_end_last = '1' and aoi_rd_end_i = '0' then  -- je vois la tombée du fval d'une readout_info.aoi =>
                     aoi_init_done <= '1';
                     aoi_flag_fifo_rst <= '0';
                  end if;
                  if DEFINE_GENERATE_ELCORR_CHAIN = '0' then
                     naoi_init_done <= '1';           -- permet le passage des données même si les naoi ne sont pas générées
                     naoi_flag_fifo_rst <= '1';
                  elsif naoi_stop_last = '1' and naoi_stop_i = '0' then  -- je vois la fin d'une readout_info.naoi =>
                     naoi_init_done <= '1';
                     naoi_flag_fifo_rst <= '0';
                  end if;
                  global_init_done <= aoi_init_done and naoi_init_done;
                  
                  -- pragma translate_off           -- ENO 18 avril 2019: ne plus utiliser car crée bcp de probleme en simulation
                  --                  aoi_init_done <= '1';
                  --                  naoi_init_done <= '1';
                  --                  naoi_flag_fifo_rst <= '0';
                  --                  aoi_flag_fifo_rst <= '0';
                  -- pragma translate_on
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process; 
   
   ----------------------------------------------------------------
   -- decalage des synchronisateurs
   ----------------------------------------------------------------
   ufd: var_shift_reg_w16_d32
   Port map ( 
      A    => std_logic_vector(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY(4 downto 0)),
      D    => adc_flag,
      CLK  => CLK,
      CE   => adc_flag_dval,
      SCLR => sreset,
      Q    => adc_flag_o
      );      
   
   ----------------------------------------------------------------
   -- fifo des synchronisateurs
   ----------------------------------------------------------------    
   -- adc_sync flag fifo write
   Uadc : process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            adc_flag_last_o  <= adc_flag_o;
            adc_flag_fifo_wr <= '0';
         else
            adc_flag_fifo_din <= adc_flag_o;
            adc_flag_last_o   <= adc_flag_o;
            adc_flag_fifo_wr  <=(adc_flag_o(1) or adc_flag_o(0)) and READOUT_INFO.SAMP_PULSE; -- adc_flag_o(1)) et adc_flag_o(0) ne doivent jamais se chevaucher et c'est theoriquement vrai; -- juste les transitions des flags. Ainsi on est certain d'avoir un flag par information.    
         end if;
      end if;
   end process;           
   
   uff: fwft_sfifo_w16_d256
   Port map( 
      clk         => CLK,
      srst         => sreset,
      din         => adc_flag_fifo_din,
      wr_en       => adc_flag_fifo_wr,
      rd_en       => adc_flag_fifo_rd,
      dout        => adc_flag_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => adc_flag_fifo_ovfl,
      empty       => open,
      valid       => adc_flag_fifo_dval,
      data_count  => open,
      prog_full   => open
      );
   
   adc_flag_fifo_rd <= ((readout_info_o.aoi.eol and aoi_flag_fifo_dval) or (readout_info_o.naoi.stop and naoi_flag_fifo_dval)) and FPA_DIN_DVAL;
   aoi_in_progress  <= adc_flag_fifo_dout(0) and adc_flag_fifo_dval;
   naoi_in_progress <= adc_flag_fifo_dout(1) and adc_flag_fifo_dval;
   
   ------------------------------------------------
   -- AOI: Gestionnaire des Flags
   ------------------------------------------------
   aoi_flag_fifo_rd <= aoi_in_progress and FPA_DIN_DVAL;
   
   -- aoi fag fifo mapping      
   Uaoi2 : fwft_sfifo_w32_d256
   port map (
      clk         => CLK,
      srst        => aoi_flag_fifo_rst,
      din         => aoi_flag_fifo_din,
      wr_en       => aoi_flag_fifo_wr,
      rd_en       => aoi_flag_fifo_rd,
      dout        => aoi_flag_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => aoi_flag_fifo_ovfl,
      empty       => open,
      valid       => aoi_flag_fifo_dval
      );
   
   -- AOi flag fifo write
   Uaoi3 : process(CLK)
   begin
      if rising_edge(CLK) then         
         aoi_flag_fifo_din(21 downto 0) <= READOUT_INFO.AOI.SPARE & READOUT_INFO.AOI.SOF & READOUT_INFO.AOI.EOF & READOUT_INFO.AOI.SOL & READOUT_INFO.AOI.EOL & READOUT_INFO.AOI.FVAL & READOUT_INFO.AOI.LVAL & READOUT_INFO.AOI.DVAL;  -- read_end n'est plus ecrit dans les fifos
         aoi_flag_fifo_wr <= READOUT_INFO.SAMP_PULSE and READOUT_INFO.AOI.DVAL and global_init_done; -- remarquer qu'on n'ecrit pas les samples d'interligne! on écrit juste les données AOI !!!!! Même pas READ_END puisqu'il n'a pas de DVAL associé à READ_END     
      end if;
   end process;        
   
   ------------------------------------------------
   -- NON_ AOI: Gestionnaire des Flags
   ------------------------------------------------
   naoi_flag_fifo_rd <= FPA_DIN_DVAL and naoi_in_progress;
   
   -- naoi fag fifo mapping      
   Unaoi2 : fwft_sfifo_w32_d256
   port map (
      clk         => CLK,
      srst        => naoi_flag_fifo_rst,
      din         => naoi_flag_fifo_din,
      wr_en       => naoi_flag_fifo_wr,
      rd_en       => naoi_flag_fifo_rd,
      dout        => naoi_flag_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => naoi_flag_fifo_ovfl,
      empty       => open,
      valid       => naoi_flag_fifo_dval
      );
   
   -- naoi flag fifo write
   Unaoi3 : process(CLK)
   begin
      if rising_edge(CLK) then         
         naoi_flag_fifo_din(17 downto 0) <= READOUT_INFO.NAOI.SPARE & READOUT_INFO.NAOI.REF_VALID & READOUT_INFO.NAOI.DVAL & READOUT_INFO.NAOI.STOP & READOUT_INFO.NAOI.START;
         naoi_flag_fifo_wr <= READOUT_INFO.SAMP_PULSE and READOUT_INFO.NAOI.DVAL and global_init_done;    
      end if;
   end process; 
   
   ---------------------------------------------------------------------
   -- FLAG FIFO OUT                                                
   ---------------------------------------------------------------------
   readout_info_o.aoi.spare      <= aoi_flag_fifo_dout(21 downto 7);
   readout_info_o.aoi.sof        <= aoi_flag_fifo_dout(6);
   readout_info_o.aoi.eof        <= aoi_flag_fifo_dout(5);
   readout_info_o.aoi.sol        <= aoi_flag_fifo_dout(4);
   readout_info_o.aoi.eol        <= aoi_flag_fifo_dout(3);
   readout_info_o.aoi.fval       <= aoi_flag_fifo_dout(2);
   readout_info_o.aoi.lval       <= aoi_flag_fifo_dout(1);
   readout_info_o.aoi.dval       <= aoi_flag_fifo_dout(0) and aoi_flag_fifo_dval;
   
   -- non_aoi flag fifo out 
   readout_info_o.naoi.spare     <= naoi_flag_fifo_dout(17 downto 5);
   readout_info_o.naoi.ref_valid <= naoi_flag_fifo_dout(4 downto 3);
   readout_info_o.naoi.dval      <= naoi_flag_fifo_dout(2) and naoi_flag_fifo_dval;
   readout_info_o.naoi.stop      <= naoi_flag_fifo_dout(1);
   readout_info_o.naoi.start     <= naoi_flag_fifo_dout(0);
   
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
            dout_wr_en_o <= global_init_done and FPA_DIN_DVAL; -- les données sortent tout le temps. les flags permettront de distinguer le AOI du NAOI 
            
            -- données écrites en aval
            if DEFINE_FPA_VIDEO_DATA_INVERTED = '1' then 
               dout_o(55 downto 0) <= not FPA_DIN(55 downto 0);
            else
               dout_o(55 downto 0) <= FPA_DIN(55 downto 0);   
            end if;            
            
            -- zone AOI
            dout_o(56)           <= readout_info_o.aoi.sol and aoi_in_progress;                       -- aoi_sol
            dout_o(57)           <= readout_info_o.aoi.eol and aoi_in_progress;                       -- aoi_eol
            dout_o(58)           <= readout_info_o.aoi.fval and aoi_flag_fifo_dval;                   -- aoi_fval 
            dout_o(59)           <= readout_info_o.aoi.sof and aoi_in_progress;                       -- aoi_sof
            dout_o(60)           <= readout_info_o.aoi.eof and aoi_in_progress;                       -- aoi_eof            
            dout_o(61)           <= readout_info_o.aoi.dval and aoi_in_progress and FPA_DIN_DVAL;     -- aoi_dval    (nouvel ajout)
            dout_o(76 downto 62) <= readout_info_o.aoi.spare;                                         -- aoi_spares  (nouvel ajout)
            
            -- Zone NON AOI
            dout_o(77)           <= readout_info_o.naoi.dval and naoi_in_progress and FPA_DIN_DVAL;   -- naoi_dval    
            dout_o(78)           <= readout_info_o.naoi.start and naoi_in_progress;                   -- naoi_start
            dout_o(79)           <= readout_info_o.naoi.stop and naoi_in_progress;                    -- naoi_stop            
            dout_o(81 downto 80) <= readout_info_o.naoi.ref_valid;                                    -- naoi_ref_valid
            dout_o(94 downto 82) <= readout_info_o.naoi.spare;                                        -- naoi_spares
            
            -- non utilisé                                                                            -- non utilisé
            dout_o(95)           <= '0'; 
            
         end if;
      end if;
   end process;
   
end rtl;

