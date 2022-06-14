-------------------------------------------------------------------------------
--
-- Title       : SCPIO_data_dispatcher
-- Design      : 
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00180-IRC\src\FPA\SCPIO_Hercules\src\SCPIO_data_dispatcher.vhd
-- Generated   : Mon Jan 10 13:16:11 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Fpa_Common_Pkg.all;
use work.FPA_Define.all;
use work.proxy_define.all;
use work.tel2000.all;
use work.img_header_define.all;


entity afpa_data_dispatcher is
   
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      ACQ_INT           : in std_logic;  -- ACQ_INT et FRAME_ID sont parfaitement synchronisés
      FRAME_ID          : in std_logic_vector(31 downto 0);
      INT_TIME          : in std_logic_vector(31 downto 0);
      INT_INDX          : in std_logic_vector(7 downto 0);
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;
      
      QUAD_FIFO_RST     : in std_logic;
      QUAD_FIFO_CLK     : in std_logic;
      QUAD_FIFO_DIN     : in std_logic_vector(95 downto 0);      
      QUAD_FIFO_WR      : in std_logic;
      
      READOUT           : out std_logic;   -- ENO: 06 mars 2021.  READOUT monte à '1' avec SOF et tombe à '0' juste après EOF. Donc en tenir compte lorsqu'on utilise le mode READOUT_END_TO_TRIG_START 
      
      DATA_MOSI         : out t_ll_area_mosi72;
      DATA_MISO          : in t_ll_area_miso;
      
      HDER_MOSI         : out t_axi4_lite_mosi;
      HDER_MISO         : in t_axi4_lite_miso;
      
      DISPATCH_INFO     : out img_info_type;
      FPA_TEMP_STAT     : in fpa_temp_stat_type;
      
      FIFO_ERR          : out std_logic;
      SPEED_ERR         : out std_logic;
      CFG_MISMATCH      : out std_logic;
      ASSUMP_ERR        : out std_logic;
      DONE              : out std_logic
      
      );
end afpa_data_dispatcher;

architecture rtl of afpa_data_dispatcher is 
   
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS       : natural := DEFINE_FPA_EXP_TIME_CONV_DENOMINATOR_BIT_POS;  -- log2 de FPA_EXP_TIME_CONV_DENOMINATOR  
   constant C_EXP_TIME_CONV_DENOMINATOR               : integer := 2**C_EXP_TIME_CONV_DENOMINATOR_BIT_POS;
   -- constant C_EXP_TIME_CONV_NUMERATOR              : unsigned(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 4 downto 0):= to_unsigned(integer(real(DEFINE_FPA_100M_CLK_RATE_KHZ)*real(2**C_EXP_TIME_CONV_DENOMINATOR_BIT_POS)/real(DEFINE_FPA_INTCLK_RATE_KHZ)), C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 5);     --
   constant C_EXP_TIME_CONV_NUMERATOR_BITLEN          : integer := C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 5;
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27  : natural := C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 27; --pour un total de 27 bits pour le temps d'integration
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_M_1   : natural := C_EXP_TIME_CONV_DENOMINATOR_BIT_POS - 1; 
   
   constant C_AOI_PIPE_LEN : integer := 10; -- integer(real(DEFINE_FPA_100M_CLK_RATE_KHZ)/real(DEFINE_FPA_PCLK_RATE_KHZ));
   
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
   
   component fwft_afifo_w96_d128
      port (
         rst      : in std_logic;
         wr_clk   : in std_logic;
         rd_clk   : in std_logic;
         din      : in std_logic_vector(95 downto 0);
         wr_en    : in std_logic;
         rd_en    : in std_logic;
         dout     : out std_logic_vector(95 downto 0);
         valid    : out std_logic;
         full     : out std_logic;
         overflow : out std_logic;
         empty    : out std_logic;
         wr_rst_busy : out std_logic;   
         rd_rst_busy : out std_logic
         );
   end component;
   
   component fwft_sfifo_w72_d16
      port (
         clk       : in std_logic;
         srst       : in std_logic;
         din       : in std_logic_vector(71 downto 0);
         wr_en     : in std_logic;
         rd_en     : in std_logic;
         dout      : out std_logic_vector(71 downto 0);
         valid     : out std_logic;
         full      : out std_logic;
         overflow  : out std_logic;
         empty     : out std_logic
         );
   end component;
   
   type frame_fsm_type is (idle, wait_fval_st);
   type fast_hder_sm_type is (idle, exp_info_dval_st, send_hder_st, wait_acq_hder_st);                    
   type exp_time_pipe_type is array (0 to 3) of unsigned(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27 downto 0);
   
   signal exp_time_pipe                : exp_time_pipe_type;
   signal exp_dval_pipe                : std_logic_vector(7 downto 0) := (others => '0');
   signal fast_hder_sm                 : fast_hder_sm_type;
   signal frame_fsm                    : frame_fsm_type;
   signal sreset                       : std_logic;
   signal quad_fifo_dval               : std_logic;
   signal data                         : std_logic_vector(55 downto 0); 
   signal aoi_fval                     : std_logic;
   signal aoi_lval                     : std_logic;
   signal aoi_sol                      : std_logic;
   signal aoi_eol                      : std_logic;
   signal aoi_sof                      : std_logic;
   signal aoi_eof                      : std_logic;
   signal aoi_spare                    : std_logic_vector(14 downto 0);
   signal aoi_dval                     : std_logic;    
   signal quad_fifo_dout               : std_logic_vector(QUAD_FIFO_DIN'LENGTH-1 downto 0);
   signal acq_hder_last                : std_logic;    
   signal quad_fifo_ovfl               : std_logic;
   signal acq_hder_fifo_din            : std_logic_vector(71 downto 0);
   signal acq_hder_fifo_wr             : std_logic;
   signal acq_hder_fifo_rd             : std_logic;
   signal acq_hder_fifo_dout           : std_logic_vector(71 downto 0);
   signal acq_hder_fifo_dval           : std_logic;
   signal acq_hder_fifo_ovfl           : std_logic;
   signal acq_int_sync_last            : std_logic;
   signal readout_i                    : std_logic;
   signal acq_hder                     : std_logic;
   signal acq_int_sync                 : std_logic;
   signal frame_id_i                   : std_logic_vector(31 downto 0);
   signal int_time_assump_err          : std_logic := '0';
   signal gain_assump_err              : std_logic := '0';
   signal mode_assump_err              : std_logic := '0';
   signal temp_reg_dval                : std_logic;
   signal hder_cnt                     : unsigned(7 downto 0) := (others => '0');
   signal int_time_i                   : unsigned(31 downto 0);
   signal temp_reg                     : std_logic_vector(15 downto 0);
   signal hder_mosi_i                  : t_axi4_lite_mosi;
   signal data_mosi_i                  : t_ll_area_mosi72;
   signal data_link_rdy                : std_logic;
   signal hder_link_rdy                : std_logic;
   signal int_time_100MHz              : unsigned(31 downto 0);
   signal int_time_100MHz_dval         : std_logic;
   signal dispatch_info_i              : img_info_type;
   signal hder_param                   : hder_param_type;
   signal hcnt                         : unsigned(7 downto 0);
   signal acq_finge_assump_err         : std_logic := '0';
   signal int_indx_i                   : std_logic_vector(7 downto 0);
   signal pix_count                    : unsigned(31 downto 0);
   signal pause_cnt                    : unsigned(7 downto 0);
   signal naoi_dval                    : std_logic := '0';
   signal naoi_spare                   : std_logic_vector(12 downto 0);
   signal img_start                    : std_logic := '0';
   signal img_end                      : std_logic;
   signal naoi_start                   : std_logic;
   signal naoi_stop                    : std_logic;
   signal naoi_ref_valid               : std_logic_vector(1 downto 0);
   signal aoi_eof_pipe                 : std_logic_vector(C_AOI_PIPE_LEN downto 0);
   signal aoi_sof_pipe                 : std_logic_vector(C_AOI_PIPE_LEN downto 0);
   signal aoi_acq_data                 : std_logic;
   
   
begin
   
   HDER_MOSI <= hder_mosi_i;
   DATA_MOSI <= data_mosi_i;
   DISPATCH_INFO <= dispatch_info_i;
   
   READOUT <= readout_i;
   hder_link_rdy <= HDER_MISO.WREADY and HDER_MISO.AWREADY;
   data_link_rdy  <= not DATA_MISO.BUSY;
   
   --quad_fifo_dval  <= quad_fifo_dval; -- les données sortent dès leur arrivée. Elle se retrouvent sur le bus PIX_MOSI. PIX_MOSI.DVAL permet de savoir que la donnée est valide pour AOI ou non. PIX_MOSI.MISC permet d'identifier les données (pour correction offset par exemple)    
   
   --------------------------------------------------
   -- synchro 
   --------------------------------------------------   
   U0B: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );
   
   U0C: double_sync
   port map(
      CLK => CLK,
      D   => ACQ_INT,
      Q   => acq_int_sync,
      RESET => sreset
      );
   
   --------------------------------------------------
   -- fifo fwft quad_DATA 
   -------------------------------------------------- 
   U1 : fwft_afifo_w96_d128
   port map (
      rst => QUAD_FIFO_RST,
      wr_clk => QUAD_FIFO_CLK,
      rd_clk => CLK,
      din => QUAD_FIFO_DIN,
      wr_en => QUAD_FIFO_WR,
      rd_en => quad_fifo_dval,   -- les données sortent dès leur arrivée. Elle se retrouvent sur le bus PIX_MOSI. PIX_MOSI.DVAL permet de savoir que la donnée est valide pour AOI ou non. PIX_MOSI.MISC permet d'identifier les données (pour correction offset par exemple)     
      dout => quad_fifo_dout,
      valid  => quad_fifo_dval,
      full => open,
      overflow => quad_fifo_ovfl,
      empty => open,
      wr_rst_busy => open,  
      rd_rst_busy => open
      );
   
   --------------------------------------------------
   -- fifo fwft pour acq fringe et l'index de intTime
   --------------------------------------------------
   U2 : fwft_sfifo_w72_d16  
   port map (
      srst => sreset,
      clk => CLK,
      din => acq_hder_fifo_din,
      wr_en => acq_hder_fifo_wr,
      rd_en => acq_hder_fifo_rd,
      dout => acq_hder_fifo_dout,
      valid  => acq_hder_fifo_dval,
      full => open,
      overflow => acq_hder_fifo_ovfl,
      empty => open
      );
   
   ------------------------------------------------
   -- flags de la fsm acq_hder
   ------------------------------------------------ 
   
   
   U0A: process(CLK)
   begin          
      if rising_edge(CLK) then       
         
         -- quelques pipes : -- ENO: 25 septembre 2018: la regeneration de img_end pour regler un bug lorsqu'on a du suréchnatillonnage temporel d'un meme pixel (par exemple N echantillons par pixel sur un même canal analogique) 
         aoi_sof_pipe(C_AOI_PIPE_LEN downto 0) <= aoi_sof_pipe(C_AOI_PIPE_LEN-1 downto 0) & (aoi_sof and aoi_dval); 
         aoi_eof_pipe(C_AOI_PIPE_LEN downto 0) <= aoi_eof_pipe(C_AOI_PIPE_LEN-1 downto 0) & (aoi_eof and aoi_dval);   
         -- flags de prise de decision
         img_start <= aoi_sof_pipe(C_AOI_PIPE_LEN);               -- img_start. À '1' dit qu'une image s'en vient. les pixels ne sont pas encore lus mais ils s'en viennent. 
         img_end <= aoi_eof_pipe(C_AOI_PIPE_LEN);                 -- ENO: 25 septembre 2018:  img_end retardé pour ne pas tronquer les echantillons de aoi_eof. À '1' dit que le AOI est terminée. Tous les SAMPLES de pixels de l'AOI sont lus. Attention, peut monter à '1' bien après le dernier pixel de l'AOI.  
         
      end if;
   end process; 
   
   ------------------------------------------------
   -- decodage données sortant du fifo
   ------------------------------------------------
   -- data  (AOI ou non AOI data)
   data           <= quad_fifo_dout(55 downto 0);
   
   -- AOI area flags
   aoi_sol        <= quad_fifo_dout(56);  
   aoi_eol        <= quad_fifo_dout(57);
   aoi_fval       <= quad_fifo_dout(58);
   aoi_sof        <= quad_fifo_dout(59);  
   aoi_eof        <= quad_fifo_dout(60);
   aoi_dval       <= quad_fifo_dout(61) and quad_fifo_dval; 
   aoi_spare      <= quad_fifo_dout(76 downto 62);   
   aoi_acq_data   <= quad_fifo_dout(62); -- spare(0) consacré à aoi_acq_data           
   
   -- non AOI area flags         
   naoi_dval      <= quad_fifo_dout(77) and quad_fifo_dval;
   naoi_start     <= quad_fifo_dout(78);
   naoi_stop      <= quad_fifo_dout(79);
   naoi_ref_valid <= quad_fifo_dout(81 downto 80);
   naoi_spare     <= quad_fifo_dout(94 downto 82);
   
   -------------------------------------------------------------------
   -- generation de acq_hder et stockage dans un fifo fwft  
   -------------------------------------------------------------------   
   -- il faut ecrire dans un fifo fwft le FRAME_ID, que lorsque l'image est prise avec ACQ_TRIG (image à envoyer dans la chaine) 
   -- a) Fifo vide pendant qu'une image rentre dans le présent module => image à ne pas envoyer dans la chaine
   -- b) Fifo contient une donnée pendant qu'une image rentre => image à envoyer dans la chaine avec FRAME_ID contenu dans le fifo
   U4: process(CLK)
   begin          
      if rising_edge(CLK) then         
         if sreset = '1' then 
            frame_fsm <= idle;
            acq_hder_fifo_wr <= '0';
            acq_hder_fifo_rd <= '0';
            acq_hder <= '0';
            readout_i <= '0';
            acq_int_sync_last <= '1'; 
            --acq_int_sync <= '0';
            
         else         
            
            --acq_int_sync <= ACQ_INT;
            acq_int_sync_last <= acq_int_sync;
            
            -- ecriture de FRAME_ID dans le acq fringe fifo
            acq_hder_fifo_din <= INT_INDX & INT_TIME & FRAME_ID; -- le frame_id est écrit dans le fifo que s'il s'agit d'une image à envoyer dans la chaine
            acq_hder_fifo_wr <= not acq_int_sync_last and acq_int_sync;
            
            -- generation de acq_hder et readout_i
            case frame_fsm is 
               
               when idle =>
                  acq_hder_fifo_rd <= '0';
                  readout_i <= '0';
                  acq_hder <= acq_hder_fifo_dval;                  -- acq_hder est utilisé par fast_hder_sm pour envoyer le header
                  if acq_hder_fifo_dval = '1' then                   -- il y a une acq integration à traiter 
                     frame_id_i <= acq_hder_fifo_dout(31 downto 0);
                     int_time_i <= unsigned(acq_hder_fifo_dout(63 downto 32));
                     int_indx_i <= acq_hder_fifo_dout(71 downto 64);
                  else
                     frame_id_i <= (others => '0'); -- id farfelue d'une extra_fringe provenant du module hw_driver (de toute façon, non envoyée dans la chaine)
                  end if;
                  if img_start = '1' then     -- en quittant idle, frame_id_i et acq_hder sont implicitement latchés, donc pas besoin de latchs explicites
                     frame_fsm <= wait_fval_st;
                     acq_hder_fifo_rd <= aoi_acq_data; -- ENO: 19 fev 2020. Mis à jour de la sortie du fwft pour le prochain frame si et seulement si l'image en cours est une acq image. Sinon, c'est une image acquise en XTRA_TRIG/PROG_TRIG et donc le acq_hder_fifo doit rester intact.
                     readout_i <= '1';                 -- signal de readout, à sortir même en mode xtra_trig
                  end if;                   
               
               when wait_fval_st =>
                  acq_hder_fifo_rd <= '0';
                  if img_end = '1' then
                     readout_i <= '0';
                     if acq_hder = '1' and aoi_acq_data = '1' then -- ENO: pour RWI, acq_hder tombe ssi la donnee dans acq_hder_fifo a trouvé son image associee
                        acq_hder <= '0';
                     end if;
                     frame_fsm <= idle;
                  end if;      
               
               when others =>
               
            end case;
            
         end if;         
      end if;
   end process;
   
   -----------------------------------------------------------------
   -- Sortie des pixels
   -------------------------------------------------------------------   
   U5: process(CLK)
   begin          
      if rising_edge(CLK) then 
         --données
         data_mosi_i.data             <= resize(data(55 downto 42),18) & resize(data(41 downto 28),18) & resize(data(27 downto 14),18) & resize(data(13 downto 0),18);            
         -- flags de données des pixels
         data_mosi_i.aoi_dval         <= aoi_dval and aoi_acq_data and not sreset; -- ENO. 22 fev 2020: les données sortent automatiquement dès qu'elles ont le tag aoi_acq_data à '1'.
         data_mosi_i.aoi_sof          <= aoi_sof;
         data_mosi_i.aoi_eof          <= aoi_eof;
         data_mosi_i.aoi_sol          <= aoi_sol;
         data_mosi_i.aoi_eol          <= aoi_eol;
         data_mosi_i.aoi_spare        <= aoi_spare;
         -- flags de données non pixels
         data_mosi_i.naoi_dval        <= naoi_dval;
         data_mosi_i.naoi_start       <= naoi_start;
         data_mosi_i.naoi_stop        <= naoi_stop;
         data_mosi_i.naoi_spare       <= naoi_spare;
         data_mosi_i.naoi_ref_valid   <= naoi_ref_valid;
      end if;
   end process; 
   
   -----------------------------------------------------------------
   -- Sorties du header fast
   -------------------------------------------------------------------   
   U6: process(CLK)
   begin          
      if rising_edge(CLK) then         
         if sreset = '1' then
            fast_hder_sm <= idle;
            hder_mosi_i.awvalid <= '0';
            hder_mosi_i.wvalid <= '0';
            hder_mosi_i.wstrb <= (others => '0');
            hder_mosi_i.awprot <= (others => '0');
            hder_mosi_i.arvalid <= '0';
            hder_mosi_i.bready <= '1';
            hder_mosi_i.rready <= '0';
            hder_mosi_i.arprot <= (others => '0');
            
            dispatch_info_i.exp_feedbk <= '0';
            dispatch_info_i.exp_info.exp_dval <= '0';
            
         else            
            
            acq_hder_last <= acq_hder;
            
            -- construction des données hder fast
            hder_param.exp_time <= int_time_100MHz; 
            hder_param.frame_id <= unsigned(frame_id_i);
            hder_param.sensor_temp_raw <= FPA_TEMP_STAT.TEMP_DATA(hder_param.sensor_temp_raw'length-1 downto 0);--others => '0');-- à faire plus tard 
            hder_param.exp_index <= unsigned(int_indx_i);
            hder_param.rdy <= int_time_100MHz_dval;
            
            --  generation des données de l'image info (exp_feedbk et frame_id proviennent de hw_driver pour eviter d'ajouter un clk supplementaire dans le présent module)
            dispatch_info_i.exp_info.exp_time <= hder_param.exp_time;
            dispatch_info_i.exp_info.exp_indx <= int_indx_i;
            
            -- pragma translate_off
            if data_mosi_i.aoi_dval = '1' then 
               pix_count <= pix_count + 4;               
               if data_mosi_i.aoi_sof = '1' then
                  pix_count <= to_unsigned(4, pix_count'length);
               end if;
            end if;
            -- pragma translate_on
            
            
            
            -- sortie de la partie header fast provenant du module
            case fast_hder_sm is
               
               when idle =>
                  --                  hder_mosi_i.awvalid <= '0';
                  --                  hder_mosi_i.wvalid <= '0';
                  --                  hder_mosi_i.wstrb <= (others => '0');
                  hcnt <= to_unsigned(1, hcnt'length);
                  dispatch_info_i.exp_info.exp_dval <= '0';
                  pause_cnt <= (others => '0');
                  if hder_param.rdy = '1' and acq_hder = '1' then
                     fast_hder_sm <= exp_info_dval_st;                     
                  end if;
               
               when exp_info_dval_st =>
                  pause_cnt <= pause_cnt + 1;
                  if pause_cnt = 4 then 
                     dispatch_info_i.exp_info.exp_dval <= '1';  -- sortira après dispatch_info_i.exp_info afin de reduire les risques d'aleas de séquences sur les regitres
                  end if;
                  if pause_cnt = 12 then                         -- ainsi dispatch_info_i.exp_info.exp_dval durera au moins 12-4 = 8 CLK
                     dispatch_info_i.exp_info.exp_dval <= '0';                            
                     fast_hder_sm <= send_hder_st;
                  end if;
               
               when send_hder_st =>                  
                  if hder_link_rdy = '1' then                         
                     if hcnt = 1 then -- frame_id 
                        hder_mosi_i.awaddr <= x"0000" &  std_logic_vector(hder_param.frame_id(7 downto 0)) &  std_logic_vector(resize(FrameIDAdd32, 8));--
                        hder_mosi_i.awvalid <= '1';
                        hder_mosi_i.wdata <=  std_logic_vector(hder_param.frame_id);
                        hder_mosi_i.wvalid <= '1';
                        hder_mosi_i.wstrb <= FrameIDBWE;
                        
                     elsif hcnt = 2 then -- sensor_temp_raw
                        hder_mosi_i.awaddr <= x"0000" &  std_logic_vector(hder_param.frame_id(7 downto 0)) &  std_logic_vector(resize(SensorTemperatureRawAdd32, 8));--
                        hder_mosi_i.awvalid <= '1';
                        hder_mosi_i.wdata <= std_logic_vector(shift_left(resize(unsigned(hder_param.sensor_temp_raw), 32), SensorTemperatureRawShift)); --resize(hder_param.sensor_temp_raw, 32);
                        hder_mosi_i.wvalid <= '1';
                        hder_mosi_i.wstrb <= SensorTemperatureRawBWE;
                        
                     elsif hcnt = 3 then    -- exp_time -- en troisieme position pour donner du temps au calcul de hder_param.exp_time
                        hder_mosi_i.awaddr <= x"FFFF" & std_logic_vector(hder_param.frame_id(7 downto 0)) &  std_logic_vector(resize(ExposureTimeAdd32, 8));--
                        hder_mosi_i.awvalid <= '1';
                        hder_mosi_i.wdata <=  std_logic_vector(hder_param.exp_time);
                        hder_mosi_i.wvalid <= '1';
                        hder_mosi_i.wstrb <= ExposureTimeBWE;
                        fast_hder_sm <= wait_acq_hder_st;
                     end if;                     
                     hcnt <= hcnt + 1;
                     --                  else
                     --                     hder_mosi_i.awvalid <= '0';
                     --                     hder_mosi_i.wvalid <= '0';
                  end if;
               
               when wait_acq_hder_st =>
                  hder_mosi_i.awvalid <= '0';
                  hder_mosi_i.wvalid <= '0';
                  hder_mosi_i.wstrb <= (others => '0');
                  if acq_hder = '0' then
                     fast_hder_sm <= idle;
                  end if;
               
               when others =>
               
            end case;               
            
         end if;  
      end if;
   end process; 
   
   -----------------------------------------------------  
   -- calcul du temps d'integration en coups de 100MHz                               
   -----------------------------------------------------
   U7: process (CLK)
   begin
      if rising_edge(CLK) then 
         
         -- pipe pour le calcul du temps d'integration en clk de 100 MHz
         exp_time_pipe(0) <= resize(int_time_i, exp_time_pipe(0)'length) ;
         exp_time_pipe(1) <= resize(exp_time_pipe(0) * resize(FPA_INTF_CFG.COMN.INTCLK_TO_CLK100_CONV_NUMERATOR, C_EXP_TIME_CONV_NUMERATOR_BITLEN), exp_time_pipe(0)'length);          
         exp_time_pipe(2) <= resize(exp_time_pipe(1)(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27 downto C_EXP_TIME_CONV_DENOMINATOR_BIT_POS), exp_time_pipe(0)'length);  -- soit une division par 2^EXP_TIME_CONV_DENOMINATOR
         exp_time_pipe(3) <= exp_time_pipe(2) + resize("00"& exp_time_pipe(1)(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_M_1), exp_time_pipe(0)'length);  -- pour l'operation d'arrondi
         int_time_100MHz  <= exp_time_pipe(3)(int_time_100MHz'length-1 downto 0);
         
         -- pipe pour rendre valide la donnée qques CLKs apres sa sortie
         exp_dval_pipe(0)           <= acq_hder and not acq_hder_last;
         exp_dval_pipe(1)           <= exp_dval_pipe(0); 
         exp_dval_pipe(2)           <= exp_dval_pipe(1); 
         exp_dval_pipe(3)           <= exp_dval_pipe(2);
         exp_dval_pipe(4)           <= exp_dval_pipe(3);
         exp_dval_pipe(5)           <= exp_dval_pipe(4);
         int_time_100MHz_dval       <= exp_dval_pipe(5);         
         
      end if;
   end process; 
   
   -------------------------------------------------------------------
   -- generation misc signaux
   -------------------------------------------------------------------   
   U8: process(CLK)
   begin          
      if rising_edge(CLK) then
         if sreset = '1' then
            SPEED_ERR <= '0';   
            CFG_MISMATCH <= '0'; 
            FIFO_ERR <= '0'; 
            ASSUMP_ERR <= '0';
            DONE <= '0';
            
         else
            
            -- erreur grave de vitesse
            if (data_mosi_i.aoi_dval and not data_link_rdy) = '1' then 
               SPEED_ERR <= '1';
            end if;
            
            -- errer de fifo
            if (quad_fifo_ovfl or acq_hder_fifo_ovfl) = '1' then
               FIFO_ERR <= '1';
            end if;
            
            -- done
            DONE <= not readout_i; 
            
         end if;
         
      end if;
   end process; 
   
end rtl;
