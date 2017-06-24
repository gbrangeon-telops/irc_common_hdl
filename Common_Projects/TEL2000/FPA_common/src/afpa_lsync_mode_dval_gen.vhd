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

entity afpa_lsync_mode_dval_gen is
   port (
      ARESET          : in std_logic;
      CLK             : in std_logic;
      
      FPA_INTF_CFG    : in fpa_intf_cfg_type;
      DIAG_MODE_EN    : in std_logic;
      
      READOUT         : in std_logic;
      FPA_DIN         : in std_logic_vector(57 downto 0);
      FPA_DIN_DVAL    : in std_logic;
      
      READOUT_INFO    : in readout_info_type;
      
      FPA_DOUT        : out std_logic_vector(61 downto 0);
      FPA_DOUT_DVAL   : out std_logic;   
      
      FLUSH_FIFO      : out std_logic      
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
   
   component fwft_sfifo_w56_d256
      port (
         clk : in std_logic;
         rst : in std_logic;
         din : in std_logic_vector(55 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(55 downto 0);
         full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;
   
   component fwft_sfifo_w1_d16
      port (
         clk      : in std_logic;
         srst     : in std_logic;
         din      : in std_logic_vector(0 downto 0);
         wr_en    : in std_logic;
         rd_en    : in std_logic;
         dout     : out std_logic_vector(0 downto 0);
         full     : out std_logic;
         almost_full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;  
   
   type din_sync_fsm_type is (init_st1, init_st2, init_st3, init_st4, init_st5, idle, id_info_gen_st, active_pixel_dly_st, write_samp_fifo_st, wait_read_end_st, wait_lsync_st, flush_fifo_st);
   type dout_sync_fsm_type is (idle, sync_flows_st);
   type samp_fifo_data_type is array (0 to 1) of std_logic_vector(55 downto 0);
   
   signal din_sync_fsm      : din_sync_fsm_type;
   signal dout_sync_fsm     : dout_sync_fsm_type;
   signal sreset            : std_logic;
   signal dout_dval_o       : std_logic;
   
   signal frame_sync        : std_logic;
   signal frame_sync_last   : std_logic;
   signal flush_fifo_o      : std_logic;
   signal dly_cnt           : unsigned(7 downto 0);
   signal readout_sync      : std_logic;
   signal din_dval_i        : std_logic;
   
   signal flag_fifo_dval    : std_logic;
   signal flag_fifo_dout    : std_logic_vector(7 downto 0);
   signal flag_fifo_din     : std_logic_vector(7 downto 0);
   signal flag_fifo_wr_i    : std_logic;
   signal flag_fifo_ovfl    : std_logic;
   signal flag_fifo_rd      : std_logic;
   
   signal samp_fifo_dval    : std_logic_vector(1 downto 0);
   signal samp_fifo_dout    : samp_fifo_data_type;
   signal samp_fifo_din     : std_logic_vector(55 downto 0);
   signal samp_fifo_wr      : std_logic_vector(1 downto 0);
   signal samp_fifo_rd      : std_logic_vector(1 downto 0);
   signal samp_fifo_ovfl    : std_logic_vector(1 downto 0);
   signal samp_fifo_empty   : std_logic_vector(1 downto 0);
   signal samp_fifo_id_i    : std_logic_vector(0 downto 0);
   signal samp_fifo_id_o    : std_logic_vector(0 downto 0);
   --signal samp_fifo_id_last : std_logic;
   
   signal pix_count         : unsigned(7 downto 0);
   signal dout_o            : std_logic_vector(61 downto 0);
   
   signal readout_info_o      : readout_info_type;
   signal permit_flag_fifo_wr : std_logic;
   signal permit_samp_fifo_wr : std_logic_vector(1 downto 0);
   signal fsm_areset          : std_logic;
   signal flag_fifo_rst       : std_logic;
   signal samp_fifo_rst       : std_logic_vector(1 downto 0);
   signal fsm_sreset          : std_logic;
   signal line_sync           : std_logic;      
   signal line_sync_last      : std_logic;
   signal din_sync_err_i      : std_logic;
   
   signal permit_flag_fifo_rd      : std_logic;
   signal permit_samp_fifo_rd      : std_logic_vector(1 downto 0);
   signal line_sync_edge_detected  : std_logic;   
   signal frame_sync_edge_detected : std_logic;
   
   signal id_info_wr        : std_logic;
   signal id_info_dval      : std_logic;
   signal id_info_rd        : std_logic;
   signal id_fifo_srst      : std_logic;
   
   
   --attribute dont_touch     : string;
   --attribute dont_touch of dout_dval_o         : signal is "true"; 
   --attribute dont_touch of dout_o              : signal is "true";
   --attribute dont_touch of samp_fifo_ovfl      : signal is "true";
   --attribute dont_touch of flag_fifo_ovfl      : signal is "true";
   
begin
   
   --------------------------------------------------
   -- Outputs map
   -------------------------------------------------- 
   FPA_DOUT_DVAL <= dout_dval_o;
   FLUSH_FIFO <= flush_fifo_o; 
   FPA_DOUT <= dout_o; --
   
   --------------------------------------------------
   -- Inputs map
   -------------------------------------------------- 
   frame_sync <= FPA_DIN(57);                -- frame_sync
   line_sync  <= FPA_DIN(56);                -- line_sync non utilisé ici
   din_dval_i <= FPA_DIN_DVAL;
   fsm_areset <= ARESET or DIAG_MODE_EN;   -- tout le module sera en reset tant qu'on est en mode diag 
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1: sync_reset
   port map(
      ARESET => fsm_areset,
      CLK    => CLK,
      SRESET => fsm_sreset
      );      
   
   --------------------------------------------------
   -- flag valid sur RE ou FE
   -------------------------------------------------- 
   Uflag1 : if not DEFINE_FPA_SYNC_FLAG_VALID_ON_FE  generate  -- avec le scorpiomwA, il faut reduire le delai sur le flag en regardant juste sa montée et non sa descente
      begin                                             
      frame_sync_edge_detected <= not frame_sync_last and frame_sync;
      line_sync_edge_detected <= not line_sync_last and line_sync; 
   end generate; 
   
   Uflag2 : if DEFINE_FPA_SYNC_FLAG_VALID_ON_FE generate  -- 
      begin                                             
      frame_sync_edge_detected <= frame_sync_last and not frame_sync;
      line_sync_edge_detected <= line_sync_last and not line_sync; 
   end generate; 
   
   --------------------------------------------------
   -- Process
   --------------------------------------------------
   -- on ecrit dans les fifos que les données valides et une donnée invalide
   -- permettant aux modules en aval de détecter la tombée du fval.
   U2A: process(CLK)
      variable incr                : std_logic_vector(1 downto 0);
      variable active_write_samp_fifo    : std_logic_vector(1 downto 0);
      variable inactive_write_samp_fifo  : std_logic_vector(1 downto 0);
      variable active_read_samp_fifo    : std_logic_vector(1 downto 0);
      variable inactive_read_samp_fifo  : std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then         
         if fsm_sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            din_sync_err_i <= '0';
            din_sync_fsm <= init_st1;
            dout_sync_fsm <= idle;
            permit_flag_fifo_wr <= '0'; 
            permit_samp_fifo_wr <= (others => '0');
            permit_flag_fifo_rd <= '0';
            flush_fifo_o <= '0';       -- ENO 20 nov 2015 : fait expres sinon en mode diag fsm_sreset = '1' et les fifos seront en reset. Le ARESET flushera le fifo (voir generation de QUAD_FIFO_RST fifo)
            id_fifo_srst <= '1';
            samp_fifo_id_i(0) <= '1';
            --samp_fifo_id_last <= samp_fifo_id_i(0);
            id_info_wr <= '0';
            id_info_rd <= '0';
            samp_fifo_rst <= (others => '1');
            -- pragma translate_off
            din_sync_fsm <= idle;
            -- pragma translate_on
            
         else           
            
            readout_sync <= READOUT;
            frame_sync_last <= frame_sync;
            
            line_sync_last <= line_sync;
            
            --samp_fifo_id_last <= samp_fifo_id_i(0);
            
            if samp_fifo_id_i = samp_fifo_id_o then               -- il y a erreur si le samp fifo en cours de lecture est le même que celui en érciture. Cela signifie une rreur grave de vitesse
               din_sync_err_i <= id_info_wr and id_info_dval; 
            end if;
            ----------------------------------------------------------------------
            -- fsm1 : s'occupe de la synchronisation des données entrantes        
            ----------------------------------------------------------------------
            active_write_samp_fifo   := ('0' & samp_fifo_id_i);
            inactive_write_samp_fifo := ('0' & (not samp_fifo_id_i));
            
            case din_sync_fsm is         -- ENO: 23 juillet 2014. les etats init_st sont requis pour éviter des problèmes de synchro          
               
               when init_st1 =>
                  id_fifo_srst <= '0';
                  flush_fifo_o <= '0';
                  pix_count <= (others => '0');
                  if frame_sync = '1' then  -- je vois un signal de synchro
                     din_sync_fsm <= init_st2;
                  end if;                                                                       
               
               when init_st2 =>     
                  if frame_sync = '0' then  -- je ne vois plus le signal de synchro
                     din_sync_fsm <= init_st3;
                  end if;  
               
               when init_st3 =>
                  if din_dval_i = '1' then      
                     pix_count <= pix_count + DEFINE_FPA_TAP_NUMBER;
                  end if;                                           
                  if pix_count >= 64 then    -- je vois au moins un nombre de pixels équivalent à la plus petite ligne d'image de TEL-2000. cela implique que le système en amont est actif. je m'en vais en idle et attend la prochaine synchro 
                     din_sync_fsm <= init_st4;     
                  end if;
               
               when init_st4 =>             -- la carte ADc est connectée sinon on ne parviendra pas ici
                  if READOUT_INFO.READ_END = '1' then  -- je vois la tombée du fval d'une readout_info =>
                     din_sync_fsm <= idle; 
                  end if;
                  
               -- une fois ici, je suis certain que les deux flows seront synchronisables
               when idle =>           
                  flush_fifo_o <= '0';
                  id_fifo_srst <= '0';
                  samp_fifo_rst <= (others => '0');
                  dly_cnt <= (others => '0');
                  if frame_sync_edge_detected = '1' then       -- suppose que frame_sync précède line_sync d'au moins 1 CLK. Ne pas depasser un delai = taille de fifo des flags
                     if line_sync_edge_detected = '1' then 
                        din_sync_fsm <= id_info_gen_st;
                     else
                        din_sync_fsm <= wait_lsync_st;
                     end if;
                     permit_flag_fifo_wr <= '1';               -- permet l'écriture dans les fifos de syncrhonisation des flows de données adc et les infos de readout
                  end if;
               
               when wait_lsync_st =>
                  if line_sync_edge_detected = '1' then      
                     din_sync_fsm <= id_info_gen_st;                     
                  end if;
                  if readout_info_o.read_end = '1' and flag_fifo_dval = '1' and flag_fifo_rd = '1' then -- flag_fifo_dval et flag_fifo_rd valident le readout_info.read_end
                     din_sync_fsm <= wait_read_end_st;
                  end if;
               
               when id_info_gen_st =>
                  samp_fifo_id_i <= not samp_fifo_id_i;  -- toggle sur l'id du fifo actif
                  id_info_wr <= '1';
                  din_sync_fsm <= active_pixel_dly_st;
                  
               when active_pixel_dly_st =>               -- delai en nombre de samples avant d'aller chercher les pixels d'une ligne
                  id_info_wr <= '0';
                  incr := '0'& din_dval_i;
                  dly_cnt <= dly_cnt + to_integer(unsigned(incr));                 
                  if dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then -- REAL_MODE_ACTIVE_PIXEL_DLY est configurable via microblaze
                     din_sync_fsm <= write_samp_fifo_st;                     
                  end if;                    
               
               when write_samp_fifo_st =>
                  id_info_wr <= '0';
                  dly_cnt <= (others => '0');
                  permit_samp_fifo_wr(to_integer(unsigned(active_write_samp_fifo))) <= '1';
                  permit_samp_fifo_wr(to_integer(unsigned(inactive_write_samp_fifo))) <= '0';
                  din_sync_fsm <= wait_lsync_st;          --retourner rapidement pour ne pas manquer le prochain synchro de ligne
               
               when wait_read_end_st =>
                  if readout_sync = '0' then    -- on attend la fin du readout en aval pour reset des fifos
                     din_sync_fsm <= flush_fifo_st;
                  end if;
               
               when flush_fifo_st =>            -- le reset dure 20 coups d'horloge. Le fifo est reseté pour qu'un manque de pixel dans l'image actuelle n'affecte pas la suivante.
                  permit_flag_fifo_wr <= '0';
                  permit_samp_fifo_wr <= (others => '0');
                  flush_fifo_o <= '1';                -- flush des fifos downstream
                  id_fifo_srst <= '1';
                  samp_fifo_rst <= (others => '1');   -- flush fifo des samples
                  dly_cnt <= dly_cnt + 1;
                  if dly_cnt = 20 then 
                     din_sync_fsm <= idle; 
                  end if; 
                  
               
               when others =>
               
            end case;
            
            ----------------------------------------------------------------------
            -- fsm2 : s'occupe de la synchronisation des données sortantes        
            ----------------------------------------------------------------------          
            active_read_samp_fifo   := ('0' & samp_fifo_id_o);
            inactive_read_samp_fifo := ('0' & (not samp_fifo_id_o));
            
            case dout_sync_fsm is
               
               when idle =>
                  id_info_rd <= '0'; 
                  permit_flag_fifo_rd <= '0';
                  permit_samp_fifo_rd <= (others => '0');
                  if id_info_dval = '1' then  
                     dout_sync_fsm <= sync_flows_st;
                  end if;
               
               when sync_flows_st =>                  
                  permit_flag_fifo_rd <= '1';
                  permit_samp_fifo_rd(to_integer(unsigned(active_read_samp_fifo))) <= '1';         -- on active juste le fifo en désigné par son id
                  if readout_info_o.eol = '1' and flag_fifo_dval = '1' and flag_fifo_rd = '1' then            -- on arrete la lecture du flag fifo à la fin valide d'une ligne
                     permit_flag_fifo_rd <= '0';                     -- le flag fifo est arrêté
                     permit_samp_fifo_rd(to_integer(unsigned(active_read_samp_fifo))) <= '0';      -- le samp fifo n lecture est arrêté
                     samp_fifo_rst(to_integer(unsigned(active_read_samp_fifo))) <= '1';           -- le samp fifo qui vient d'être lu est en reset
                     samp_fifo_rst(to_integer(unsigned(inactive_read_samp_fifo))) <= '0';       -- le samp fifo qui n'est pas lu n'est plus en reset  
                     id_info_rd <= '1';                          -- on change d'id pour la prochaine ligne à synchroniser
                     dout_sync_fsm <= idle;
                  end if;                  
               
               when others =>
               
            end case; 
            
            -- sortie des données            
            dout_dval_o <= flag_fifo_rd and (readout_info_o.dval or readout_info_o.read_end); -- readout_info_o.read_end permet de faire tomber fval en aval
            dout_o(61)  <= readout_info_o.eof and flag_fifo_rd;  -- eof
            dout_o(60)  <= readout_info_o.sof and flag_fifo_rd;  -- sof
            dout_o(59)  <= readout_info_o.fval; -- fval
            dout_o(58)  <= readout_info_o.eol and flag_fifo_rd;  -- eol
            dout_o(57)  <= readout_info_o.sol and flag_fifo_rd;  -- sol
            dout_o(56)  <= readout_info_o.lval;
            dout_o(55 downto 0) <= samp_fifo_dout(to_integer(unsigned(active_read_samp_fifo))); --
            
         end if;
      end if;
   end process;
   
   --------------------------------
   -- fifo de id
   --------------------------------
   U2B : fwft_sfifo_w1_d16
   port map (
      clk         => CLK,
      srst        => id_fifo_srst,
      din         => samp_fifo_id_i,
      wr_en       => id_info_wr,
      rd_en       => id_info_rd,
      dout        => samp_fifo_id_o,
      full        => open,
      almost_full => open,
      overflow    => open,
      empty       => open,
      valid       => id_info_dval
      );   
   
   ------------------------------------------------------------------------------------
   --  ecriture de readout_info dans un fifo pour synchro avec donnée entrante
   ------------------------------------------------------------------------------------
   readout_info_o.sof  <= flag_fifo_dout(7);
   readout_info_o.eof  <= flag_fifo_dout(6);
   readout_info_o.sol  <= flag_fifo_dout(5);
   readout_info_o.eol  <= flag_fifo_dout(4);
   readout_info_o.fval <= flag_fifo_dout(3);
   readout_info_o.lval <= flag_fifo_dout(2);
   readout_info_o.dval <= flag_fifo_dout(1);
   readout_info_o.read_end <= flag_fifo_dout(0);
   
   flag_fifo_rst <= fsm_areset;
   
   U3A : fwft_sfifo_w8_d256
   port map (
      clk         => CLK,
      rst         => flag_fifo_rst,
      din         => flag_fifo_din,
      wr_en       => flag_fifo_wr_i,
      rd_en       => flag_fifo_rd,
      dout        => flag_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => flag_fifo_ovfl,
      empty       => open,
      valid       => flag_fifo_dval
      );
   
   U3B : process(CLK)
   begin
      if rising_edge(CLK) then         
         flag_fifo_din <= READOUT_INFO.SOF & READOUT_INFO.EOF & READOUT_INFO.SOL & READOUT_INFO.EOL & READOUT_INFO.FVAL & READOUT_INFO.LVAL & READOUT_INFO.DVAL & READOUT_INFO.READ_END;
         flag_fifo_wr_i <= ((READOUT_INFO.SAMP_PULSE and READOUT_INFO.DVAL) or  READOUT_INFO.READ_END) and permit_flag_fifo_wr; -- seuls les flags validés par DVAl sont ecrits        
      end if;
   end process;
   
   ------------------------------------------------------------------------------------
   --  ecriture desa echantillons des ADcs dans un fifo pour synchro avec readout_info
   ------------------------------------------------------------------------------------
   U4A : fwft_sfifo_w56_d256
   port map (
      clk         => CLK,
      rst         => samp_fifo_rst(0),
      din         => samp_fifo_din,
      wr_en       => samp_fifo_wr(0),
      rd_en       => samp_fifo_rd(0),
      dout        => samp_fifo_dout(0),
      full        => open,
      overflow    => open,
      empty       => open,
      valid       => samp_fifo_dval(0)
      );
   
   U4B : fwft_sfifo_w56_d256
   port map (
      clk         => CLK,
      rst         => samp_fifo_rst(1),
      din         => samp_fifo_din,
      wr_en       => samp_fifo_wr(1),
      rd_en       => samp_fifo_rd(1),
      dout        => samp_fifo_dout(1),
      full        => open,
      overflow    => open,
      empty       => open,
      valid       => samp_fifo_dval(1)
      );
   
   -- pour synchro parfaite avec les données allant vers le detecteur 
   -- données inversées
   Data_Inv_Gen : if DEFINE_FPA_VIDEO_DATA_INVERTED = '1' generate      
      U4_inv : process(CLK)
      begin
         if rising_edge(CLK) then         
            samp_fifo_din <= not FPA_DIN(55 downto 0);
            samp_fifo_wr(0) <= FPA_DIN_DVAL and permit_samp_fifo_wr(0);        -- ecriture en alternance dans les fifos
            samp_fifo_wr(1) <= FPA_DIN_DVAL and permit_samp_fifo_wr(1);              -- ecriture en alternance dans les fifos
         end if;
      end process;
   end generate;
   
   -- pour synchro parfaite avec les données allant vers le detecteur
   -- données non inversées
   Data_Ninv_Gen : if DEFINE_FPA_VIDEO_DATA_INVERTED = '0' generate      
      U4_Ninv : process(CLK)
      begin
         if rising_edge(CLK) then         
            samp_fifo_din <= FPA_DIN(55 downto 0);      
            samp_fifo_wr(0) <= FPA_DIN_DVAL and permit_samp_fifo_wr(0);        -- ecriture en alternance dans les fifos
            samp_fifo_wr(1) <= FPA_DIN_DVAL and permit_samp_fifo_wr(1);              -- ecriture en alternance dans les fifos        
         end if;
      end process;
   end generate; 
   
   
   
   --------------------------------------------------
   --  sortie des identificateurs de trames 
   --------------------------------------------------
   flag_fifo_rd    <= (((samp_fifo_dval(0) or samp_fifo_dval(1)) and permit_flag_fifo_rd) or readout_info_o.read_end) and flag_fifo_dval; 
   samp_fifo_rd(0) <= samp_fifo_dval(0) and flag_fifo_dval and permit_samp_fifo_rd(0);
   samp_fifo_rd(1) <= samp_fifo_dval(1) and flag_fifo_dval and permit_samp_fifo_rd(1); 
   
   
end rtl;
