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
use work.tel2000.all;
use work.img_header_define.all;


entity afpa_data_dispatcher is
   
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      ACQ_INT           : in std_logic;  -- ACQ_INT et FRAME_ID sont parfaitement synchronis�s
      FRAME_ID          : in std_logic_vector(31 downto 0);
      INT_TIME          : in std_logic_vector(31 downto 0);
      INT_INDX          : in std_logic_vector(7 downto 0);
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;
      
      QUAD_FIFO_RST     : in std_logic;
      QUAD_FIFO_CLK     : in std_logic;
      QUAD_FIFO_DIN     : in std_logic_vector(61 downto 0);      
      QUAD_FIFO_WR      : in std_logic;
      
      READOUT           : out std_logic;
      
      PIX_MOSI          : out t_ll_ext_mosi72;
      PIX_MISO          : in t_ll_ext_miso;
      
      HDER_MOSI         : out t_axi4_lite_mosi;
      HDER_MISO         : in t_axi4_lite_miso;
      
      DISPATCH_INFO     : out img_info_type;
      FPA_TEMP_STAT     : in fpa_temp_stat_type;
      
      FIFO_ERR          : out std_logic;
      SPEED_ERR         : out std_logic;
      CFG_MISMATCH      : out std_logic;
      DONE              : out std_logic
      
      );
end afpa_data_dispatcher;

architecture rtl of afpa_data_dispatcher is 
   
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS : natural := 26;  -- log2 de FPA_EXP_TIME_CONV_DENOMINATOR  
   constant C_EXP_TIME_CONV_DENOMINATOR  : integer := 2**C_EXP_TIME_CONV_DENOMINATOR_BIT_POS;
   constant C_EXP_TIME_CONV_NUMERATOR    : unsigned(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 4 downto 0):= to_unsigned(integer(real(DEFINE_FPA_100M_CLK_RATE_KHZ)*real(2**C_EXP_TIME_CONV_DENOMINATOR_BIT_POS)/real(DEFINE_FPA_MCLK_RATE_KHZ)), C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 5);     --
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27  : natural := C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 27; --pour un total de 27 bits pour le temps d'integration
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_M_1   : natural := C_EXP_TIME_CONV_DENOMINATOR_BIT_POS - 1; 
   
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
   
   component fwft_afifo_w62_d16
      port (
         rst      : in std_logic;
         wr_clk   : in std_logic;
         rd_clk   : in std_logic;
         din      : in std_logic_vector(61 downto 0);
         wr_en    : in std_logic;
         rd_en    : in std_logic;
         dout     : out std_logic_vector(61 downto 0);
         valid    : out std_logic;
         full     : out std_logic;
         overflow : out std_logic;
         empty    : out std_logic
         );
   end component;
   
   component fwft_sfifo_w72_d16
      port (
         clk       : in std_logic;
         rst       : in std_logic;
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
   
   type acq_fringe_fsm_type is (idle, wait_fval_st);
   type fast_hder_sm_type is (idle, exp_info_dval_st, send_hder_st);                    
   type exp_time_pipe_type is array (0 to 3) of unsigned(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27 downto 0);
   
   signal exp_time_pipe                : exp_time_pipe_type;
   signal exp_dval_pipe                : std_logic_vector(7 downto 0) := (others => '0');
   signal fast_hder_sm                 : fast_hder_sm_type;
   signal acq_fringe_fsm               : acq_fringe_fsm_type;
   signal sreset                       : std_logic;
   signal quad_fifo_dval               : std_logic;
   signal pix_data                     : std_logic_vector(55 downto 0); 
   signal pix_fval                     : std_logic;
   signal pix_lval                     : std_logic;
   signal pix_sol                      : std_logic;
   signal pix_eol                      : std_logic;
   signal pix_sof                      : std_logic;
   signal pix_eof                      : std_logic;
   signal quad_fifo_dout               : std_logic_vector(61 downto 0);
   signal acq_fringe_last              : std_logic;    
   signal quad_fifo_rd                 : std_logic;
   signal quad_fifo_ovfl               : std_logic;
   signal fringe_fifo_din              : std_logic_vector(71 downto 0);
   signal fringe_fifo_wr               : std_logic;
   signal fringe_fifo_rd               : std_logic;
   signal fringe_fifo_dout             : std_logic_vector(71 downto 0);
   signal fringe_fifo_dval             : std_logic;
   signal fringe_fifo_ovfl             : std_logic;
   signal acq_int_sync_last            : std_logic;
   signal readout_i                    : std_logic;
   signal acq_fringe                   : std_logic;
   signal acq_int_sync                 : std_logic;
   signal frame_id_i                   : std_logic_vector(31 downto 0);
   signal int_time_assump_err          : std_logic := '0';
   signal gain_assump_err              : std_logic := '0';
   signal mode_assump_err              : std_logic := '0';
   signal temp_reg_dval                : std_logic;
   signal hder_cnt                     : unsigned(7 downto 0) := (others => '0');
   --signal int_time_mismatch            : std_logic;
   --signal xsize_mismatch               : std_logic;
   --signal ysize_mismatch               : std_logic;
   --signal gain_mismatch                : std_logic;
   signal int_time_i                   : unsigned(31 downto 0);
   signal temp_reg                     : std_logic_vector(15 downto 0);
   signal hder_mosi_i                  : t_axi4_lite_mosi;
   signal pix_mosi_i                   : t_ll_ext_mosi72;
   signal pix_link_rdy                 : std_logic;
   signal hder_link_rdy                : std_logic;
   signal int_time_100MHz              : unsigned(31 downto 0);
   signal int_time_100MHz_dval         : std_logic;
   --signal int_time_100MHz_corr         : unsigned(31 downto 0);
   signal dispatch_info_i              : img_info_type;
   signal hder_param                   : hder_param_type;
   signal hcnt                         : unsigned(7 downto 0);
   signal acq_finge_assump_err         : std_logic := '0';
   signal int_indx_i                   : std_logic_vector(7 downto 0);
   --signal quad_fifo_ovfl_sync          : std_logic;
   signal pix_count                    : unsigned(31 downto 0);
   signal pause_cnt                    : unsigned(7 downto 0);
   
   --  attribute dont_touch                     : string; 
   --  attribute dont_touch of int_time         : signal is "true"; 
   --  attribute dont_touch of int_time_100MHz_x_2P15  : signal is "true";
   
begin
   
   HDER_MOSI <= hder_mosi_i;
   PIX_MOSI <= pix_mosi_i;
   DISPATCH_INFO <= dispatch_info_i;
   
   READOUT <= readout_i;
   hder_link_rdy <= HDER_MISO.WREADY and HDER_MISO.AWREADY;
   pix_link_rdy  <= not PIX_MISO.BUSY;
   
   quad_fifo_rd  <= quad_fifo_dval;        
   
   ------------------------------------------------
   -- decodage donn�es sortant du fifo
   ------------------------------------------------
   pix_data <= quad_fifo_dout(55 downto 0);
   pix_lval <= quad_fifo_dout(56);  -- Lval  
   pix_sol  <= quad_fifo_dout(57);  
   pix_eol  <= quad_fifo_dout(58);
   pix_fval <= quad_fifo_dout(59);  -- Fval
   pix_sof  <= quad_fifo_dout(60);  
   pix_eof  <= quad_fifo_dout(61);
   
   --------------------------------------------------
   -- synchro 
   --------------------------------------------------   
   U0A: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );
   
   U0B : double_sync
   port map(
      CLK => CLK,
      D   => ACQ_INT,
      Q   => acq_int_sync,
      RESET => sreset
      );
   
   --------------------------------------------------
   -- fifo fwft quad_DATA 
   -------------------------------------------------- 
   U1 : fwft_afifo_w62_d16
   port map (
      rst => QUAD_FIFO_RST,
      wr_clk => QUAD_FIFO_CLK,
      rd_clk => CLK,
      din => QUAD_FIFO_DIN,
      wr_en => QUAD_FIFO_WR,
      rd_en => quad_fifo_rd,
      dout => quad_fifo_dout,
      valid  => quad_fifo_dval,
      full => open,
      overflow => quad_fifo_ovfl,
      empty => open
      );
   
   --------------------------------------------------
   -- fifo fwft pour acq fringe et l'index de intTime
   --------------------------------------------------
   U2 : fwft_sfifo_w72_d16  
   port map (
      rst => ARESET,
      clk => CLK,
      din => fringe_fifo_din,
      wr_en => fringe_fifo_wr,
      rd_en => fringe_fifo_rd,
      dout => fringe_fifo_dout,
      valid  => fringe_fifo_dval,
      full => open,
      overflow => fringe_fifo_ovfl,
      empty => open
      );
   
   -------------------------------------------------------------------
   -- generation de acq_fringe et stockage dans un fifo fwft  
   -------------------------------------------------------------------   
   -- il faut ecrire dans un fifo fwft le FRAME_ID, que lorsque l'image est prise avec ACQ_TRIG (image � envoyer dans la chaine) 
   -- a) Fifo vide pendant qu'une image rentre dans le pr�sent module => image � ne pas envoyer dans la chaine
   -- b) Fifo contient une donn�e pendant qu'une image rentre => image � envoyer dans la chaine avec FRAME_ID contenu dans le fifo
   U4: process(CLK)
   begin          
      if rising_edge(CLK) then         
         if sreset = '1' then 
            acq_fringe_fsm <= idle;
            fringe_fifo_wr <= '0';
            fringe_fifo_rd <= '0';
            acq_fringe <= '0';
            readout_i <= '0';
            acq_int_sync_last <= '1'; 
            --acq_int_sync <= '0';
            
         else         
            
            --acq_int_sync <= ACQ_INT;
            acq_int_sync_last <= acq_int_sync;
            
            -- ecriture de FRAME_ID dans le acq fringe fifo
            fringe_fifo_din <= INT_INDX & INT_TIME & FRAME_ID; -- le frame_id est �crit dans le fifo que s'il s'agit d'une image � envoyer dans la chaine
            fringe_fifo_wr <= not acq_int_sync_last and acq_int_sync;
            
            -- generation de acq_fringe et readout_i
            case acq_fringe_fsm is 
               
               when idle =>
                  fringe_fifo_rd <= '0';
                  readout_i <= '0';
                  acq_fringe <= fringe_fifo_dval; -- ACQ_INT de l'image k vient toujours avant le readout de l'image k. Ainsi le fifo contiendra une donn�e avant le readout si l'image est � envoyer dans la chaine. Sinon, c'est une XTRA_FRINGE 
                  if fringe_fifo_dval = '1' then  
                     frame_id_i <= fringe_fifo_dout(31 downto 0);
                     int_time_i <= unsigned(fringe_fifo_dout(63 downto 32));
                     int_indx_i <= fringe_fifo_dout(71 downto 64);
                  else
                     frame_id_i <= (others => '0'); -- id farfelue d'une extra_fringe provenant du module hw_driver (de toute fa�on, non envoy�e dans la chaine)
                  end if;
                  if pix_fval = '1' then     -- en quittant idle, frame_id_i et acq_fringe sont implicitement latch�s, donc pas besoin de latchs explicites
                     acq_fringe_fsm <= wait_fval_st;
                     fringe_fifo_rd <= '1'; -- mis � jour de la sortie du fwft pour le prochain frame
                     readout_i <= '1'; -- signal de readout, � sortir m�me en mode xtra_trig
                  end if;                   
               
               when wait_fval_st =>
                  fringe_fifo_rd <= '0';
                  if pix_fval = '0' then
                     readout_i <= '0';
                     acq_fringe <= '0';
                     acq_fringe_fsm <= idle;
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
         -- sortie des pixels
         pix_mosi_i.dval <= quad_fifo_rd and pix_fval and quad_fifo_dval and acq_fringe and not sreset;
         pix_mosi_i.data <= resize(pix_data(55 downto 42),18) & resize(pix_data(41 downto 28),18) & resize(pix_data(27 downto 14),18) & resize(pix_data(13 downto 0),18);            
         pix_mosi_i.sof  <= pix_sof;
         pix_mosi_i.eof  <= pix_eof;
         pix_mosi_i.sol  <= pix_sol;
         pix_mosi_i.eol  <= pix_eol;
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
            
            acq_fringe_last <= acq_fringe;
            
            -- construction des donn�es hder fast
            hder_param.exp_time <= int_time_100MHz; 
            hder_param.frame_id <= unsigned(frame_id_i);
            hder_param.sensor_temp_raw <= FPA_TEMP_STAT.TEMP_DATA(hder_param.sensor_temp_raw'length-1 downto 0);--others => '0');-- � faire plus tard 
            hder_param.exp_index <= unsigned(int_indx_i);
            hder_param.rdy <= int_time_100MHz_dval;
            
            --  generation des donn�es de l'image info (exp_feedbk et frame_id proviennent de hw_driver pour eviter d'ajouter un clk supplementaire dans le pr�sent module)
            dispatch_info_i.exp_info.exp_time <= hder_param.exp_time;
            dispatch_info_i.exp_info.exp_indx <= int_indx_i;
            
            -- pragma translate_off
            if pix_mosi_i.dval = '1' then 
               pix_count <= pix_count + 4;               
               if pix_mosi_i.sof = '1' then
                  pix_count <= to_unsigned(4, pix_count'length);
               end if;
            end if;
            -- pragma translate_on
            
            -- sortie des pixels
            
            
            -- sortie de la partie header fast provenant du module
            case fast_hder_sm is
               
               when idle =>
                  hder_mosi_i.awvalid <= '0';
                  hder_mosi_i.wvalid <= '0';
                  hder_mosi_i.wstrb <= (others => '0');
                  hcnt <= to_unsigned(1, hcnt'length);
                  dispatch_info_i.exp_info.exp_dval <= '0';
                  pause_cnt <= (others => '0');
                  if hder_param.rdy = '1' and acq_fringe = '1' then
                     fast_hder_sm <= exp_info_dval_st;                     
                  end if;
               
               when exp_info_dval_st =>
                  pause_cnt <= pause_cnt + 1;
                  if pause_cnt = 4 then 
                     dispatch_info_i.exp_info.exp_dval <= '1';  -- sortira apr�s dispatch_info_i.exp_info afin de reduire les risques d'aleas de s�quences sur les regitres
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
                        fast_hder_sm <= idle;
                     end if;                     
                     hcnt <= hcnt + 1;
                     --                  else
                     --                     hder_mosi_i.awvalid <= '0';
                     --                     hder_mosi_i.wvalid <= '0';
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
         exp_time_pipe(1) <= resize(exp_time_pipe(0) * C_EXP_TIME_CONV_NUMERATOR, exp_time_pipe(0)'length);          
         exp_time_pipe(2) <= resize(exp_time_pipe(1)(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27 downto C_EXP_TIME_CONV_DENOMINATOR_BIT_POS), exp_time_pipe(0)'length);  -- soit une division par 2^EXP_TIME_CONV_DENOMINATOR
         exp_time_pipe(3) <= exp_time_pipe(2) + resize("00"& exp_time_pipe(1)(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_M_1), exp_time_pipe(0)'length);  -- pour l'operation d'arrondi
         int_time_100MHz  <= exp_time_pipe(3)(int_time_100MHz'length-1 downto 0);
         
         -- pipe pour rendre valide la donn�e qques CLKs apres sa sortie
         exp_dval_pipe(0)           <= acq_fringe and not acq_fringe_last;
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
            DONE <= '0';
            
         else
            
            -- erreur grave de vitesse
            SPEED_ERR <= pix_mosi_i.dval and not pix_link_rdy;           
            
            -- errer de fifo
            FIFO_ERR <= quad_fifo_ovfl or fringe_fifo_ovfl;
            
            -- done
            DONE <= not pix_fval; 
            
         end if;
         
      end if;
   end process; 
   
end rtl;
