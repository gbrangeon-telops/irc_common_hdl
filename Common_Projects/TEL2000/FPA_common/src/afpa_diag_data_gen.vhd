-------------------------------------------------------------------------------
--
-- Title       : afpa_diag_data_gen
-- Design      : 
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00180-IRC\src\FPA\PROXY_Hercules\src\afpa_diag_data_gen.vhd
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.FPA_define.all;
use work.fpa_common_pkg.all;
use work.proxy_define.all;


entity afpa_diag_data_gen is
   generic(
      G_DIAG_QUAD_ID     : integer range 0 to 16 := 1;   -- le numero du quad à emuler en mode diag. Si diversité de canal, alors vaut le numero du quad qui a subi la diversité de canal
      G_DIAG_TAP_NUMBER  : integer range 1 to 64 := DEFINE_FPA_TAP_NUMBER
      );
   port(      
      ARESET             : in std_logic;
      MCLK_SOURCE        : in std_logic;
      
      FPA_INTF_CFG       : fpa_intf_cfg_type;
      ENABLE             : in std_logic;
      
      FPA_INT            : in std_logic;
      ACQ_INT            : in std_logic;
      
      DIAG_FVAL          : out std_logic;
      DIAG_DATA          : out std_logic_vector(95 downto 0); --! sortie des données 
      DIAG_DVAL          : out std_logic
      );
end afpa_diag_data_gen;


architecture rtl of afpa_diag_data_gen is
   
   constant spare : std_logic := '0';
   
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
   
   component Clk_Divider is
      Generic(	
         Factor : integer := 2);		
      Port ( 
         Clock     : in std_logic;
         Reset     : in std_logic;		
         Clk_div   : out std_logic);
   end component;
   
   component fwft_sfifo_w3_d16
      port (
         clk         : in std_logic;
         srst        : in std_logic;
         din         : in std_logic_vector(2 downto 0);
         wr_en       : in std_logic;
         rd_en       : in std_logic;
         dout        : out std_logic_vector(2 downto 0);
         full        : out std_logic;
         almost_full : out std_logic;
         overflow    : out std_logic;
         empty       : out std_logic;
         valid       : out std_logic
         );
   end component;
   
   component fpa_diag_line_gen
      generic (
         ANALOG_IDDCA           : boolean := false;
         SAMP_NUM_PER_PIX       : natural range 0 to 15 := 5 
         );
      port(
         CLK                : in std_logic;
         ARESET             : in std_logic;
         LINE_SIZE          : in std_logic_vector(15 downto 0);
         START_PULSE        : in std_logic;
         FIRST_VALUE        : in std_logic_vector(15 downto 0); 
         INCR_VALUE         : in std_logic_vector(15 downto 0);
         PIX_SAMP_TRIG      : in std_logic;
         DIAG_DATA          : out std_logic_vector(15 downto 0);
         DIAG_DVAL          : out std_logic; 
         DIAG_SOL           : out std_logic;
         DIAG_EOL           : out std_logic;
         DIAG_LVAL          : out std_logic;
         DIAG_DONE          : out std_logic
         );
   end component;
   
   constant  C_DIAG_TAP_NUMBER_M1 : integer := G_DIAG_TAP_NUMBER - 1;
   constant  C_DIAG_BASE_OFFSET   : integer := (G_DIAG_QUAD_ID - 1) * DEFINE_DIAG_DATA_INC * G_DIAG_TAP_NUMBER;
   
   type diag_fsm_type is (idle, wait_int_fe_st, int_st, junk_data_st, tir_dly_st, get_line_data_st, cfg_line_gen_st, lovh_dly_st, check_end_st);
   type img_change_sm_type is (idle, change_st); 
   type data_type is array (0 to C_DIAG_TAP_NUMBER_M1) of std_logic_vector(15 downto 0);
   
   signal diag_fsm          : diag_fsm_type;
   signal img_change_sm     : img_change_sm_type;
   signal data              : data_type;
   signal diag_frame_done   : std_logic;
   signal aoi_dval_i        : std_logic;    
   signal sreset            : std_logic;
   signal line_size         : std_logic_vector(15 downto 0);
   signal diag_line_gen_en  : std_logic;
   signal first_value       : data_type;
   signal incr_value        : std_logic_vector(15 downto 0);
   signal fpa_2xmclk_dummy  : std_logic;
   
   signal diag_data_i       : data_type;
   signal diag_dval_i       : std_logic_vector(C_DIAG_TAP_NUMBER_M1 downto 0);
   signal diag_done         : std_logic_vector(C_DIAG_TAP_NUMBER_M1 downto 0);
   signal dly_cnt           : unsigned(15 downto 0);
   signal lovh_dly_cnt      : unsigned(15 downto 0);
   signal data_cnt          : unsigned(15 downto 0);
   signal line_cnt          : unsigned(FPA_INTF_CFG.DIAG.YSIZE'length-1 downto 0);
   signal fpa_int_last      : std_logic;
   signal revert_img        : std_logic;
   signal clk_div_i         : std_logic;
   signal clk_div_last      : std_logic;
   signal pix_count         : unsigned(31 downto 0);
   signal fpa_int_i         : std_logic;
   signal pixel_samp_trig   : std_logic;
   signal diag_quad_clk_i   : std_logic;
   signal diag_quad_clk_last: std_logic;
   signal diag_done_last    : std_logic;
   signal diag_sol          : std_logic_vector(C_DIAG_TAP_NUMBER_M1 downto 0);
   signal diag_eol          : std_logic_vector(C_DIAG_TAP_NUMBER_M1 downto 0);
   signal diag_lval         : std_logic_vector(C_DIAG_TAP_NUMBER_M1 downto 0);
   signal aoi_sof_i         : std_logic;
   signal aoi_eof_i         : std_logic;
   signal aoi_sol_i         : std_logic;
   signal aoi_eol_i         : std_logic;
   signal aoi_lval_i        : std_logic;
   signal aoi_fval_i        : std_logic;
   signal diag_eol_last     : std_logic;
   signal aoi_img_end       : std_logic;
   signal aoi_img_start     : std_logic;
   signal img_pending_cnt   : unsigned(1 downto 0);
   signal int_fifo_rd       : std_logic;
   signal int_fifo_din      : std_logic_vector(2 downto 0);
   signal int_fifo_wr       : std_logic;
   signal int_fifo_dval     : std_logic;
   signal int_fifo_dout     : std_logic_vector(2 downto 0);
   signal acq_data_i        : std_logic;
   signal acq_int_o         : std_logic;
   signal acq_int_i         : std_logic;
   signal sim_cnt           : unsigned(7 downto 0) := (others => '0');
   signal aoi_pix_fval_i    : std_logic;
   
   
begin
   
   ----------------------------------------------
   -- OUTPUTS                                    
   ----------------------------------------------
   DIAG_FVAL               <= aoi_fval_i;
   
   DIAG_DATA(95)           <= '0';                  -- non_utilisé;
   DIAG_DATA(94 downto 80) <= (others => '0');
   DIAG_DATA(79)           <= '0';
   DIAG_DATA(78)           <= '0';
   DIAG_DATA(77)           <= '0';                  -- non aoi dval = '0' pour que le patron de tests ne bousille pas le contenu des regitres de stockage des refrences de calculs de gain et offset deja existances
   
   DIAG_DATA(76 downto 65) <= (others => '0');      -- aoi spares(14 downto 3)
   DIAG_DATA(64)           <= aoi_pix_fval_i;       -- pix_fval
   DIAG_DATA(63)           <= aoi_lval_i;           -- lval
   DIAG_DATA(62)           <= acq_data_i;           -- aoi_spare(0)
   
   DIAG_DATA(61)           <= aoi_dval_i;           -- aoi_dval          
   DIAG_DATA(60)           <= aoi_eof_i;            -- eof
   DIAG_DATA(59)           <= aoi_sof_i;            -- sof
   DIAG_DATA(58)           <= aoi_fval_i;           -- fval
   DIAG_DATA(57)           <= aoi_eol_i;            -- eol
   DIAG_DATA(56)           <= aoi_sol_i;            -- sol
   DIAG_DATA(55 downto 0)  <= data(3)(13 downto 0)  & data(2)(13 downto 0)  & data(1)(13 downto 0)  & data(0)(13 downto 0);
   DIAG_DVAL               <= aoi_dval_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U0: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => MCLK_SOURCE,
      SRESET => sreset
      );
   
   --------------------------------------------------
   -- double sync 
   --------------------------------------------------
   U0A: double_sync
   port map(
      CLK => MCLK_SOURCE,
      D   => ACQ_INT,
      Q   => acq_int_i,
      RESET => sreset
      ); 
   
   U0B: double_sync
   port map(
      CLK => MCLK_SOURCE,
      D   => FPA_INT,
      Q   => fpa_int_i,
      RESET => sreset
      ); 
   
   --------------------------------------------------
   -- pixel_samp_trig gen
   --------------------------------------------------
   UgenA : if (DEFINE_ADC_QUAD_CLK_FACTOR = 1) generate  -- cas où diag_quad_clk est identique à mclk_source
      pixel_samp_trig <= '1';   
   end generate;
   
   UgenB : if (DEFINE_ADC_QUAD_CLK_FACTOR /= 1) generate  -- cas où diag_quad_clk est issue de mclk_source divisé par un facteur > 1
      -- sampling clk enable
      UCa: Clk_Divider
      Generic map(
         Factor => DEFINE_ADC_QUAD_CLK_FACTOR
         )
      Port map( 
         Clock   => MCLK_SOURCE, 
         Reset   => sreset, 
         Clk_div => diag_quad_clk_i   -- attention, c'est en realité un clock enable.
         );  
      
      -- sampling trig en mode diag
      UCb : process(MCLK_SOURCE)
      begin
         if rising_edge(MCLK_SOURCE) then
            diag_quad_clk_last <= diag_quad_clk_i;
            pixel_samp_trig <= not diag_quad_clk_last and diag_quad_clk_i;
         end if;
      end process;
   end generate;
   
   --------------------------------------------------
   -- 4 channels diag data gen 
   --------------------------------------------------
   -- mapping avec generateur de données
   U1 : for ii in 0 to C_DIAG_TAP_NUMBER_M1 generate 
      diag_line_ii : fpa_diag_line_gen 
      generic map(
         ANALOG_IDDCA => true,      
         SAMP_NUM_PER_PIX => DEFINE_FPA_PIX_SAMPLE_NUM_PER_CH
         )
      port map(
         CLK           => MCLK_SOURCE,
         ARESET        => ARESET,
         LINE_SIZE     => line_size,
         START_PULSE   => diag_line_gen_en,
         FIRST_VALUE   => first_value(ii),
         INCR_VALUE    => incr_value,
         PIX_SAMP_TRIG => pixel_samp_trig,
         DIAG_DATA     => diag_data_i(ii),
         DIAG_DVAL     => diag_dval_i(ii),
         DIAG_SOL      => diag_sol(ii),
         DIAG_EOL      => diag_eol(ii),
         DIAG_LVAL     => diag_lval(ii),
         DIAG_DONE     => diag_done(ii)
         );
   end generate; 
   
   -- pragma translate_off
   Udbg : fpa_diag_line_gen 
   generic map(
      ANALOG_IDDCA => true,      
      SAMP_NUM_PER_PIX => DEFINE_FPA_PIX_SAMPLE_NUM_PER_CH
      )
   port map(
      CLK         => MCLK_SOURCE,
      ARESET      => ARESET,
      LINE_SIZE   => line_size,
      START_PULSE => diag_line_gen_en,
      FIRST_VALUE => first_value(0),
      INCR_VALUE  => incr_value,
      PIX_SAMP_TRIG => pixel_samp_trig,
      DIAG_DATA   => open,
      DIAG_DVAL   => open,
      DIAG_SOL    => open,
      DIAG_EOL    => open,
      DIAG_LVAL   => open,
      DIAG_DONE   => open
      );
   -- pragma translate_on
   
   --------------------------------------------------
   -- fifo fwft pour edge de l'intégration
   --------------------------------------------------
   Ue : fwft_sfifo_w3_d16
   port map (
      clk         => MCLK_SOURCE,
      srst        => sreset,
      din         => int_fifo_din,    
      wr_en       => int_fifo_wr,
      rd_en       => int_fifo_rd,
      dout        => int_fifo_dout,   
      full        => open,
      almost_full => open,
      overflow    => open,
      empty       => open,
      valid       => int_fifo_dval
      );
   
   -------------------------------------------------------------------
   -- generation des données du mode diag   
   -------------------------------------------------------------------   
   U3: process(MCLK_SOURCE)
   begin          
      if rising_edge(MCLK_SOURCE) then 
         if sreset = '1' then 
            diag_fsm <=  idle;
            aoi_dval_i <= '0';
            aoi_fval_i <= '0';
            aoi_lval_i <= '0';
            diag_frame_done <= '0';
            fpa_int_last <= '0';
            diag_line_gen_en <= '0';
            diag_eol_last <= '0';
            aoi_img_end <= '0';
            aoi_img_start <= '0';
            --elec_ofs_start_i <= '0';
            --elec_ofs_dval_i <= '0';
            --elec_ofs_end_i <= '1';
            img_pending_cnt <= (others => '0');
            int_fifo_wr <= '0';
            int_fifo_rd <= '0';
            -- fpa_int_i <= '0';
            aoi_pix_fval_i <= '0';
            
         else   
            
            diag_done_last <= diag_done(0);            
            -- fpa_int_i <= FPA_INT;
            fpa_int_last <= fpa_int_i; 
            diag_eol_last <= diag_eol(0);
            
            int_fifo_din(2) <= acq_int_i;                         -- acq_int rentre dans le fifo
            int_fifo_din(1) <= not fpa_int_last and fpa_int_i;  -- front montant
            int_fifo_din(0) <= fpa_int_last and not fpa_int_i;  -- front descendant
            int_fifo_wr     <= (fpa_int_last xor fpa_int_i) and ENABLE;          -- on ecrit les edges dans le fifo
            
            -- pragma translate_off
            if sim_cnt < 100  then               
               int_fifo_wr <= '0';
               sim_cnt <= sim_cnt + 1;            
            end if;            
            -- pragma translate_on
            
            -- configuration des generateurs de lignes
            if FPA_INTF_CFG.COMN.FPA_DIAG_TYPE = DEFINE_TELOPS_DIAG_CNST then  -- constant
               for ii in 0 to C_DIAG_TAP_NUMBER_M1 loop
                  first_value(ii) <= std_logic_vector(to_unsigned(4096, first_value(0)'length)); 
                  incr_value <= (others => '0');
               end loop;               
            else                                                       
               for ii in 0 to C_DIAG_TAP_NUMBER_M1 loop                  -- degradé lineaire constant et dégradé linéaire dynamique
                  first_value(ii) <= std_logic_vector(to_unsigned(C_DIAG_BASE_OFFSET + ii*DEFINE_DIAG_DATA_INC, first_value(0)'length));
                  incr_value <= std_logic_vector(to_unsigned(DEFINE_FPA_TAP_NUMBER*DEFINE_DIAG_DATA_INC, first_value(0)'length));
               end loop;                        
            end if;
            
            
            -- machine à états
            case diag_fsm is 
               
               when idle =>
                  aoi_img_end <= '0';
                  for ii in 0 to C_DIAG_TAP_NUMBER_M1 loop
                     data(ii) <= (others => '0');                  -- offset electronique vaut 0 en mode diag
                  end loop;
                  dly_cnt <= (others => '0');
                  data_cnt <= to_unsigned(1, data_cnt'length);
                  line_cnt <= to_unsigned(1, line_cnt'length);
                  aoi_dval_i <= '0';
                  aoi_fval_i <= '0';                  
                  diag_frame_done <= '1';
                  diag_line_gen_en <= '0';
                  aoi_sof_i <= '0';
                  aoi_eof_i <= '0';
                  
                  if int_fifo_dout(1) = '1' and int_fifo_dval = '1' then  -- front montant de int_signal via fifo. Il n'est pas en temps reel en IWR : il a eu lieu pendant un readout et enregistré dans un fifo.
                     int_fifo_rd <= '1'; 
                     acq_data_i <= int_fifo_dout(2);
                     diag_fsm <= wait_int_fe_st;
                  end if;                                                
               
               when wait_int_fe_st =>
                  int_fifo_rd <= '0';
                  if int_fifo_dout(0) = '1' and int_fifo_dval = '1' then  -- front tombant de int_signal
                     int_fifo_rd <= '1';
                     diag_fsm <= tir_dly_st;
                  end if;
               
               when tir_dly_st =>
                  int_fifo_rd <= '0';
                  diag_frame_done <= '0';   
                  dly_cnt <= dly_cnt + 1;
                  if dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then 
                     diag_fsm <= cfg_line_gen_st;
                     aoi_img_start <= '1';
                  end if;                         
               
               when cfg_line_gen_st => 
                  aoi_img_start <= '0';
                  diag_line_gen_en <= '1';                              -- on active le module généateur des données diag
                  aoi_fval_i <= '1';
                  line_size <= std_logic_vector(resize(FPA_INTF_CFG.DIAG.XSIZE_DIV_TAPNUM, line_size'length)); 
                  dly_cnt <= (others => '0');
                  lovh_dly_cnt <= (others => '0');
                  diag_fsm <=  get_line_data_st;
               
               when get_line_data_st => 
                  aoi_dval_i <= diag_dval_i(0);
                  if diag_done(0) = '0' then
                     diag_line_gen_en <= '0';              
                  end if;
                  -- on se branche sur le module generateur de données diag
                  if revert_img = '1' then
                     for ii in 0 to C_DIAG_TAP_NUMBER_M1 loop
                        data(ii) <= not diag_data_i(ii);                  -- dégradé vers la gauche
                     end loop;
                  else                                                              
                     for ii in 0 to C_DIAG_TAP_NUMBER_M1 loop
                        data(ii) <= diag_data_i(ii);                      -- dégradé vers la droite 
                     end loop;
                  end if;                  
                  
                  -- compteur de lignes
                  if diag_eol(0) = '0' and diag_eol_last = '1' then  
                     diag_fsm <=  check_end_st;                     
                  end if;
                  
                  -- identificateurs de trames
                  if line_cnt = 1 then 
                     aoi_sof_i <= diag_sol(0);
                     if diag_sol(0) = '1' then
                        aoi_pix_fval_i <= '1';
                     end if;
                  else
                     aoi_sof_i <= '0';
                  end if;
                  if line_cnt = to_integer(FPA_INTF_CFG.DIAG.YSIZE) then 
                     aoi_eof_i <= diag_eol(0);
                     aoi_img_end <= diag_eol(0);
                  else
                     aoi_eof_i <= '0';
                  end if;
                  
                  if aoi_eof_i = '1' and aoi_dval_i = '1' then
                     aoi_pix_fval_i <= '0';
                  end if;
                  
                  aoi_sol_i <= diag_sol(0);
                  aoi_eol_i <= diag_eol(0);
                  aoi_lval_i <= diag_lval(0);
               
               when check_end_st =>
                  if line_cnt >= to_integer(FPA_INTF_CFG.DIAG.YSIZE) then
                     diag_fsm <=  idle;
                  else
                     diag_fsm <= lovh_dly_st; 
                     line_cnt <= line_cnt + 1; 
                  end if;
               
               when lovh_dly_st =>         -- permet de ralentir le mode diag express. Ainsi le détecteur ne sera pas surcadencé
                  lovh_dly_cnt <= lovh_dly_cnt + 1;                  
                  if lovh_dly_cnt >= to_integer(FPA_INTF_CFG.DIAG.LOVH_MCLK_SOURCE) then 
                     diag_fsm <= cfg_line_gen_st;
                  end if;
               
               when others =>
               
            end case;
            
         end if;         
      end if;
   end process;
   
   --------------------------------------------------------
   -- Genereteur d'impulsion de 2 secondes environ de periode
   -------------------------------------------------------- 
   U4: Clk_Divider
   Generic map(
      Factor=> 200_000_000
      -- pragma translate_off
      /10_000
      -- pragma translate_on
      )
   Port map( 
      Clock => MCLK_SOURCE, 
      Reset => sreset, 
      Clk_div => clk_div_i
      );
   
   ----------------------------------------------------------
   -- contrôle du basculement de l'image en mode dynamique
   ---------------------------------------------------------- 
   U5: process(MCLK_SOURCE)
   begin          
      if rising_edge(MCLK_SOURCE) then 
         if sreset = '1' then 
            img_change_sm <= idle;
            revert_img <= '0';
         else 
            
            clk_div_last <= clk_div_i;
            
            case img_change_sm is
               
               when idle =>
                  if FPA_INTF_CFG.COMN.FPA_DIAG_TYPE = DEFINE_TELOPS_DIAG_DEGR_DYN then --  mode degradé dynamique
                     if clk_div_last = '0' and clk_div_i = '1' then    -- il faut attendre 2 secondes avant de changer d'état
                        img_change_sm <= change_st;
                     end if;
                  else
                     revert_img <= '0';
                  end if;
               
               when change_st =>
                  if diag_frame_done = '1' then                            -- on attend la fin de l'image pour que le chagement d'état soit effectif
                     revert_img <= not revert_img;
                     img_change_sm <= idle;
                  end if;
               
               when others =>
               
            end case;        
            
         end if;
      end if;
   end process; 
   
end rtl;
