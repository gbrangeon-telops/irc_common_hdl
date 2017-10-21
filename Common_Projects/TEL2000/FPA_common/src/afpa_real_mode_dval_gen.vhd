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

entity afpa_real_mode_dval_gen is
   port (
      ARESET          : in std_logic;
      CLK             : in std_logic;
      
      FPA_INTF_CFG    : in fpa_intf_cfg_type;
      DIAG_MODE_EN    : in std_logic;
      
      READOUT         : in std_logic;
      FPA_DIN         : in std_logic_vector(56 downto 0);
      FPA_DIN_DVAL    : in std_logic;
      
      READOUT_INFO    : in readout_info_type;
      
      FPA_DOUT        : out std_logic_vector(61 downto 0);
      FPA_DOUT_DVAL   : out std_logic;   
      
      FLUSH_FIFO      : out std_logic      
      );  
end afpa_real_mode_dval_gen;


architecture rtl of afpa_real_mode_dval_gen is
   
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
   
   component fwft_sfifo_w56_d256
      port (
         clk : in std_logic;
         rst : in std_logic;
         din : in std_logic_vector(55 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(55 downto 0);
         full : out STD_LOGIC;
         overflow : out STD_LOGIC;
         empty : out STD_LOGIC;
         valid : out STD_LOGIC
         );
   end component;
   
   type sync_flow_fsm_type is (init_st1, init_st2, init_st3, init_st4, init_st5, idle, delay_st, sync_flow_st, wait_feedback_st, wait_img_start_st, wait_img_end_st, flush_fifo_st);
   signal sync_flow_fsm     : sync_flow_fsm_type;
   signal sreset            : std_logic;
   signal dout_dval_o       : std_logic;
   
   signal sync_flag         : std_logic;
   signal sync_flag_last    : std_logic;
   signal flush_fifo_o      : std_logic;
   signal dly_cnt           : unsigned(7 downto 0);
   signal readout_sync      : std_logic;
   signal din_dval_i        : std_logic;
   
   signal flag_fifo_dval    : std_logic;
   signal flag_fifo_dout    : std_logic_vector(7 downto 0);
   signal flag_fifo_din     : std_logic_vector(7 downto 0);
   signal flag_fifo_wr_en   : std_logic;
   signal flag_fifo_ovfl    : std_logic;
   signal fifo_rd_en        : std_logic;
   
   signal samp_fifo_dval    : std_logic;
   signal samp_fifo_dout    : std_logic_vector(55 downto 0);
   signal samp_fifo_din     : std_logic_vector(55 downto 0);
   signal samp_fifo_wr_en   : std_logic;
   signal samp_fifo_ovfl    : std_logic;
   
   signal pix_count         : unsigned(7 downto 0);
   signal dout_o            : std_logic_vector(61 downto 0);
   
   signal readout_info_o    : readout_info_type;
   signal flag_fifo_enabled : std_logic;
   signal samp_fifo_enabled : std_logic;
   signal fsm_areset        : std_logic;
   signal flag_fifo_rst     : std_logic;
   signal samp_fifo_rst     : std_logic;
   signal fsm_sreset        : std_logic;
   
   signal sync_flag_edge_detected : std_logic;  
   
   --attribute dont_touch     : string;
   --attribute dont_touch of dout_dval_o         : signal is "true"; 
   --attribute dont_touch of dout_o              : signal is "true";
   --attribute dont_touch of samp_fifo_ovfl      : signal is "true";
   --attribute dont_touch of flag_fifo_ovfl      : signal is "true";
   
begin
   
--   --------------------------------------------------
--   -- Outputs map
--   -------------------------------------------------- 
--   FPA_DOUT_DVAL <= dout_dval_o;
--   FLUSH_FIFO <= flush_fifo_o; 
--   FPA_DOUT <= dout_o; --
--   
--   --------------------------------------------------
--   -- Inputs map
--   -------------------------------------------------- 
--   sync_flag <= FPA_DIN(56);               -- sync_flag 
--   din_dval_i <= FPA_DIN_DVAL;
--   fsm_areset <= ARESET or DIAG_MODE_EN;   -- tout le module sera en reset tant qu'on est en mode diag 
--   
--   --------------------------------------------------
--   -- synchro reset 
--   --------------------------------------------------   
--   U1: sync_reset
--   port map(
--      ARESET => fsm_areset,
--      CLK    => CLK,
--      SRESET => fsm_sreset
--      );      
--   
--   --------------------------------------------------
--   -- flag valid sur RE ou FE
--   -------------------------------------------------- 
--   Uflag1 : if not DEFINE_FPA_SYNC_FLAG_VALID_ON_FE  generate  -- avec le scorpiomwA, il faut reduire le delai sur le flag en regardant juste sa montée et non sa descente
--      begin                                             
--      sync_flag_edge_detected <= not sync_flag_last and sync_flag;      
--   end generate; 
--   
--   Uflag2 : if DEFINE_FPA_SYNC_FLAG_VALID_ON_FE generate  -- 
--      begin                                             
--      sync_flag_edge_detected <= sync_flag_last and not sync_flag;      
--   end generate; 
--   
--   --------------------------------------------------
--   -- Process
--   --------------------------------------------------
--   -- on ecrit dans les fifos que les données valides et une donnée invalide
--   -- permettant aux modules en aval de détecter la tombée du fval.
--   U2: process(CLK)
--      variable incr :std_logic_vector(1 downto 0);
--   begin
--      if rising_edge(CLK) then         
--         if fsm_sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
--            sync_flow_fsm <= init_st1;
--            flag_fifo_enabled <= '0'; 
--            samp_fifo_enabled <= '0';
--            flush_fifo_o <= '0';       -- ENO 20 nov 2015 : fait expres sinon en mode diag fsm_sreset = '1' et les fifos seront en reset. Le ARESET flushera le fifo (voir generation de QUAD_FIFO_RST fifo)
--            
--            -- pragma translate_off
--            sync_flow_fsm <= idle;
--            -- pragma translate_on
--            
--         else           
--            
--            readout_sync <= READOUT;
--            sync_flag_last <= sync_flag;
--            
--            case sync_flow_fsm is         -- ENO: 23 juillet 2014. les etats init_st sont requis pour éviter des problèmes de synchro          
--               
--               when init_st1 =>      
--                  flush_fifo_o <= '0';
--                  pix_count <= (others => '0');
--                  if sync_flag = '1' then  -- je vois un signal de synchro
--                     sync_flow_fsm <= init_st2;
--                  end if;                                                                       
--               
--               when init_st2 =>     
--                  if sync_flag = '0' then  -- je ne vois plus le signal de synchro
--                     sync_flow_fsm <= init_st3;
--                  end if;  
--               
--               when init_st3 =>
--                  if din_dval_i = '1' then      
--                     pix_count <= pix_count + DEFINE_FPA_TAP_NUMBER;
--                  end if;                                           
--                  if pix_count >= 64 then    -- je vois au moins un nombre de pixels équivalent à la plus petite ligne d'image de TEL-2000. cela implique que le système en amont est actif. je m'en vais en idle et attend la prochaine synchro 
--                     sync_flow_fsm <= init_st4;     
--                  end if;
--               
--               when init_st4 =>             -- la carte ADc est connectée sinon on ne parviendra pas ici
--                  if READOUT_INFO.READ_END = '1' then  -- je vois la tombée du fval d'une readout_info =>
--                     sync_flow_fsm <= idle; 
--                  end if;
--                  
--               -- une fois ici, je suis certain que les deux flows seront synchronisables
--               when idle =>   
--                  flag_fifo_enabled <= '1';   -- permet l'écriture dans les fifos de syncrhonisation des flows de données adc et les infos de readout
--                  flush_fifo_o <= '0';
--                  dly_cnt <= (others => '0');
--                  if sync_flag_edge_detected = '1' then      
--                     sync_flow_fsm <= delay_st;
--                  end if;
--               
--               when delay_st =>               -- delai en nombre de samples avant d'aller chercher les pixels de l'image 
--                  incr := '0'& din_dval_i;
--                  dly_cnt <= dly_cnt + to_integer(unsigned(incr));                 
--                  if dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then -- REAL_MODE_ACTIVE_PIXEL_DLY est configurable via microblaze
--                     sync_flow_fsm <= sync_flow_st;  
--                  end if;                    
--               
--               when sync_flow_st =>
--                  dly_cnt <= (others => '0'); 
--                  samp_fifo_enabled <= '1';
--                  sync_flow_fsm <= wait_img_start_st; 
--               
--               when wait_img_start_st => 
--                  if readout_info_o.fval = '1' and flag_fifo_dval = '1' then 
--                     sync_flow_fsm <= wait_img_end_st;
--                  end if;
--               
--               when wait_img_end_st =>
--                  if readout_info_o.read_end = '1'  then      --
--                     sync_flow_fsm <= wait_feedback_st;
--                  end if;
--               
--               when wait_feedback_st =>
--                  samp_fifo_enabled <= '0';
--                  dly_cnt <= (others => '0');
--                  if readout_sync = '0' then    -- on attend la fin du readout en aval pour reset des fifos
--                     sync_flow_fsm <= flush_fifo_st;
--                  end if;
--               
--               when flush_fifo_st =>            -- le reset dure 20 coups d'horloge. Le fifo est reseté pour qu'un manque de pixel dans l'image actuelle n'affecte pas la suivante.
--                  flush_fifo_o <= '1';
--                  dly_cnt <= dly_cnt + 1;
--                  if dly_cnt = 20 then 
--                     sync_flow_fsm <= idle; 
--                  end if;                       
--               
--               when others =>
--               
--            end case;
--            
--         end if;
--      end if;
--   end process;
--   
--   ------------------------------------------------------------------------------------
--   --  ecriture de readout_info dans un fifo pour synchro avec donnée entrante
--   ------------------------------------------------------------------------------------
--   readout_info_o.sof  <= flag_fifo_dout(7);
--   readout_info_o.eof  <= flag_fifo_dout(6);
--   readout_info_o.sol  <= flag_fifo_dout(5);
--   readout_info_o.eol  <= flag_fifo_dout(4);
--   readout_info_o.fval <= flag_fifo_dout(3);
--   readout_info_o.lval <= flag_fifo_dout(2);
--   readout_info_o.dval <= flag_fifo_dout(1);
--   readout_info_o.read_end <= flag_fifo_dout(0);
--   
--   flag_fifo_rst <= fsm_areset;
--   
--   U3A : fwft_sfifo_w8_d256
--   port map (
--      clk         => CLK,
--      rst         => flag_fifo_rst,
--      din         => flag_fifo_din,
--      wr_en       => flag_fifo_wr_en,
--      rd_en       => fifo_rd_en,
--      dout        => flag_fifo_dout,
--      full        => open,
--      almost_full => open,
--      overflow    => flag_fifo_ovfl,
--      empty       => open,
--      valid       => flag_fifo_dval
--      );
--   
--   U3B : process(CLK)
--   begin
--      if rising_edge(CLK) then         
--         flag_fifo_din <= READOUT_INFO.SOF & READOUT_INFO.EOF & READOUT_INFO.SOL & READOUT_INFO.EOL & READOUT_INFO.FVAL & READOUT_INFO.LVAL & READOUT_INFO.DVAL & READOUT_INFO.READ_END;
--         flag_fifo_wr_en <= (READOUT_INFO.SAMP_PULSE or  READOUT_INFO.READ_END) and flag_fifo_enabled;         
--      end if;
--   end process;
--   
--   ------------------------------------------------------------------------------------
--   --  ecriture desa echantillons des ADcs dans un fifo pour synchro avec readout_info
--   ------------------------------------------------------------------------------------
--   samp_fifo_rst <= flush_fifo_o or fsm_areset;
--   U4A : fwft_sfifo_w56_d256
--   port map (
--      clk         => CLK,
--      rst         => samp_fifo_rst,
--      din         => samp_fifo_din,
--      wr_en       => samp_fifo_wr_en,
--      rd_en       => fifo_rd_en,
--      dout        => samp_fifo_dout,
--      full        => open,
--      overflow    => samp_fifo_ovfl,
--      empty       => open,
--      valid       => samp_fifo_dval
--      );
--   
--   -- pour synchro parfaite avec les données allant vers le detecteur 
--   -- données inversées
--   Data_Inv_Gen : if DEFINE_FPA_VIDEO_DATA_INVERTED = '1' generate      
--      U4_inv : process(CLK)
--      begin
--         if rising_edge(CLK) then         
--            samp_fifo_din <= not FPA_DIN(55 downto 0);
--            samp_fifo_wr_en <= FPA_DIN_DVAL and samp_fifo_enabled;         
--         end if;
--      end process;
--   end generate;
--   
--   -- pour synchro parfaite avec les données allant vers le detecteur
--   -- données non inversées
--   Data_Ninv_Gen : if DEFINE_FPA_VIDEO_DATA_INVERTED = '0' generate      
--      U4_Ninv : process(CLK)
--      begin
--         if rising_edge(CLK) then         
--            samp_fifo_din <= FPA_DIN(55 downto 0);      
--            samp_fifo_wr_en <= FPA_DIN_DVAL and samp_fifo_enabled;         
--         end if;
--      end process;
--   end generate; 
--   
--   
--   
--   --------------------------------------------------
--   --  sortie des identificateurs de trames 
--   --------------------------------------------------
--   fifo_rd_en <= samp_fifo_dval and flag_fifo_dval; 
--   U3: process(CLK)
--   begin
--      if rising_edge(CLK) then
--         dout_dval_o <= fifo_rd_en and (readout_info_o.dval or readout_info_o.read_end); -- readout_info_o.read_end permet de faire tomber fval en aval
--         dout_o(55 downto 0) <= samp_fifo_dout; --
--         dout_o(56) <= readout_info_o.lval;  
--         dout_o(57) <= readout_info_o.sol;
--         dout_o(58) <= readout_info_o.eol;  -- eol
--         dout_o(59) <= readout_info_o.fval; -- fval
--         dout_o(60) <= readout_info_o.sof;  -- sof
--         dout_o(61) <= readout_info_o.eof;  -- eof
--      end if;
--   end process;
   
end rtl;
