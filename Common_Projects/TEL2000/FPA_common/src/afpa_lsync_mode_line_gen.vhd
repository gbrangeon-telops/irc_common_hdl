------------------------------------------------------------------
--!   @file : mglk_DOUT_WR_ENiter
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
use work.fpa_common_pkg.all; 

entity afpa_lsync_mode_line_gen is
   port (
      ARESET          : in std_logic;
      CLK             : in std_logic;
      
      FPA_INTF_CFG    : fpa_intf_cfg_type;
      
      DIN             : in std_logic_vector(57 downto 0);
      DIN_DVAL        : in std_logic;
      
      ENABLE          : in std_logic;
      
      READOUT_INFO    : in readout_info_type;
      
      DOUT            : out std_logic_vector(71 downto 0);
      DOUT_WR_EN      : out std_logic;
      
      ERR             : out std_logic
      );  
   
end afpa_lsync_mode_line_gen;


architecture rtl of afpa_lsync_mode_line_gen is
   
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
   
   type sync_fsm_type is (idle, active_pixel_dly_st, write_samp_fifo_st, wait_end_st, pause_st, fifo_flush_st);
   
   signal sync_fsm          : sync_fsm_type;
   signal sreset            : std_logic;
   signal dout_wr_en_o       : std_logic;
   
   signal flush_fifo_o      : std_logic;
   signal dly_cnt           : unsigned(7 downto 0);
   
   signal flag_fifo_dval    : std_logic;
   signal flag_fifo_dout    : std_logic_vector(7 downto 0);
   signal flag_fifo_din     : std_logic_vector(7 downto 0);
   signal flag_fifo_wr_i    : std_logic;
   signal flag_fifo_ovfl    : std_logic;
   signal flag_fifo_rd      : std_logic;
   
   signal samp_fifo_dval    : std_logic;
   signal samp_fifo_dout    : std_logic_vector(55 downto 0);
   signal samp_fifo_din     : std_logic_vector(55 downto 0);
   signal samp_fifo_wr      : std_logic;
   signal samp_fifo_rd      : std_logic;
   signal samp_fifo_ovfl    : std_logic;
   signal samp_fifo_empty   : std_logic;
   signal samp_fifo_id_i    : std_logic;
   signal samp_fifo_id_o    : std_logic;
   
   signal samp_fifo_en      : std_logic;
   
   signal dout_o            : std_logic_vector(DOUT'LENGTH-1 downto 0);
   
   signal readout_info_o      : readout_info_type;
   signal fifo_rd_en          : std_logic;
   signal fifo_flush          : std_logic;
   signal line_sync           : std_logic;      
   signal line_sync_last      : std_logic;
   signal line_sync_edge_detected : std_logic;
   
   signal line_in_progress    : std_logic;   
   
begin
   
   --------------------------------------------------
   -- Outputs map
   -------------------------------------------------- 
   DOUT_WR_EN <= dout_wr_en_o; 
   DOUT <= dout_o; --
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U0: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   --------------------------------------------------
   -- quelques definitions
   -------------------------------------------------- 
   U1: process(CLK)
   begin
      if rising_edge(CLK) then                                               
         
         -- line sync
         line_sync  <= DIN(56); 
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
   -- samp fifo : write
   --------------------------------------------------
   U2: process(CLK)
      variable incr : std_logic_vector(1 downto 0);
      
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            sync_fsm <= idle;
            samp_fifo_en <= '0';
            fifo_flush <= '1';
            -- pragma translate_off
            sync_fsm <= idle;
            -- pragma translate_on
            
         else           
            
            case sync_fsm is         -- ENO: 23 juillet 2014. les etats init_st sont requis pour éviter des problèmes de synchro          
               
               when idle =>
                  dly_cnt <= (others => '0');
                  fifo_flush <= '0';
                  if line_sync_edge_detected = '1' and ENABLE = '1' then        -- ENABLE assure que l'on s'adresse bien au bon module     
                     sync_fsm <= active_pixel_dly_st;                     
                  end if;
               
               when active_pixel_dly_st =>                                               -- delai en nombre de samples avant d'aller chercher les pixels d'une ligne
                  incr := '0'& DIN_DVAL;
                  dly_cnt <= dly_cnt + to_integer(unsigned(incr));                 
                  if dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then -- REAL_MODE_ACTIVE_PIXEL_DLY est configurable via microblaze
                     sync_fsm <= write_samp_fifo_st;                     
                  end if;                    
               
               when write_samp_fifo_st =>
                  samp_fifo_en <= '1';
                  dly_cnt <= (others => '0');
                  sync_fsm <= pause_st;          --
               
               when pause_st =>
                  if ENABLE = '0' then   -- on a la fin du readout de ligne
                     sync_fsm <= wait_end_st;            
                  end if;
               
               when wait_end_st =>                     
                  if line_in_progress = '0' then
                     sync_fsm <= fifo_flush_st; 
                     samp_fifo_en <= '0';
                  end if;
               
               when fifo_flush_st =>                    -- le reset dure 20 coups d'horloge. Le fifo est reseté pour qu'un manque de pixel dans l'image actuelle n'affecte pas la suivante.
                  fifo_flush <= '1';        
                  dly_cnt <= dly_cnt + 1;
                  if dly_cnt = 20 then 
                     sync_fsm <= idle; 
                  end if;                  
               
               when others =>
               
            end case;
            
            -- samp fifo data in 
            if DEFINE_FPA_VIDEO_DATA_INVERTED = '1' then 
               samp_fifo_din <= not DIN(55 downto 0);
            else
               samp_fifo_din <= DIN(55 downto 0);   
            end if;
            samp_fifo_wr <= DIN_DVAL and samp_fifo_en;           
            
         end if;
      end if;
   end process;
   
   --------------------------------------------------
   -- flag fifo : write
   --------------------------------------------------
   U3 : process(CLK)
   begin
      if rising_edge(CLK) then         
         -- flag_fifo
         flag_fifo_din <= READOUT_INFO.SOF & READOUT_INFO.EOF & READOUT_INFO.SOL & READOUT_INFO.EOL & READOUT_INFO.FVAL & READOUT_INFO.LVAL & READOUT_INFO.DVAL & READOUT_INFO.READ_END;
         flag_fifo_wr_i <= ((READOUT_INFO.SAMP_PULSE and READOUT_INFO.DVAL) or  READOUT_INFO.READ_END) and ENABLE; -- remarquer qu'on n'ecrit pas les samples d'interligne        
      end if;
   end process;
   
   --------------------------------------------------
   -- flag and samp fifo : read
   --------------------------------------------------
   fifo_rd_en <= flag_fifo_dval and samp_fifo_dval;
   
   ------------------------------------------------------------------------------------
   -- map des flags sortantes du flag fifo
   ------------------------------------------------------------------------------------
   readout_info_o.sof  <= flag_fifo_dout(7);
   readout_info_o.eof  <= flag_fifo_dout(6);
   readout_info_o.sol  <= flag_fifo_dout(5);
   readout_info_o.eol  <= flag_fifo_dout(4);
   readout_info_o.fval <= flag_fifo_dout(3);
   readout_info_o.lval <= flag_fifo_dout(2);
   readout_info_o.dval <= flag_fifo_dout(1);
   readout_info_o.read_end <= flag_fifo_dout(0);
   
   --------------------------------------------------
   -- synchro des données sortantes
   --------------------------------------------------
   U4: process(CLK)
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            dout_wr_en_o <= '0';
            line_in_progress <= '0';
         else      
            
            -- ecriture des données en aval
            dout_wr_en_o <= fifo_rd_en or; -- readout_info_o.read_end permet de faire tomber fval en aval
            
            -- non_aoi_data flag
            dout_o(65) <= fifo_rd_en xor readout_info_o.dval; -- out_aoi_dval (ie non aoi data dval)
            
            -- aoi_data_flags
            dout_o(64) <= fifo_rd_en and readout_info_o.read_end; -- aoi_read_end
            dout_o(63) <= fifo_rd_en and readout_info_o.dval;     -- aoi_dval                  
            dout_o(62) <= fifo_rd_en and readout_info_o.dval;     -- aoi_dval
            dout_o(61) <= readout_info_o.eof and fifo_rd_en;      -- aoi_eof
            dout_o(60) <= readout_info_o.sof and fifo_rd_en;      -- aoi_sof
            if fifo_rd_en = '1' then         -- permet de ne pas couper en apparence les signaux en simulation et dans chipscope. Aucun changement réel
               dout_o(59)  <= readout_info_o.fval;                -- aoi_fval 
               dout_o(56)  <= readout_info_o.lval;                -- aoi_lval
            end if;
            dout_o(58) <= readout_info_o.eol and fifo_rd_en;      -- aoi_eol
            dout_o(57) <= readout_info_o.sol and fifo_rd_en;      -- aoi_sol
            
            -- data (either aoi or not)
            dout_o(55 downto 0) <= samp_fifo_dout; --             -- data (aoi_data or outside aoi_data)   
            
            -- fin d'une ligne sortante
            if (readout_info_o.sol and fifo_rd_en) = '1' then     -- line_in_progress à '1' via sol 
               line_in_progress <= '1'; 
            end if;
            
            if ((readout_info_o.read_end  or  readout_info_o.eol)and fifo_rd_en) = '1' then -- line_in_progress à '0' via eol ou readout_info_o.read_end 
               line_in_progress <= '0';
            end if;
            
            
         end if;
      end if;
   end process; 
   
   -------------------------------
   --  flag fifo
   ------------------------------- 
   U3A : fwft_sfifo_w8_d256
   port map (
      clk         => CLK,
      rst         => fifo_flush,
      din         => flag_fifo_din,
      wr_en       => flag_fifo_wr_i,
      rd_en       => fifo_rd_en,
      dout        => flag_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => flag_fifo_ovfl,
      empty       => open,
      valid       => flag_fifo_dval
      );
   
   -------------------------------
   --  samp fifo
   -------------------------------
   U3B : fwft_sfifo_w56_d256
   port map (
      clk         => CLK,
      rst         => fifo_flush,
      din         => samp_fifo_din,
      wr_en       => samp_fifo_wr,
      rd_en       => fifo_rd_en,
      dout        => samp_fifo_dout,
      full        => open,
      overflow    => open,
      empty       => open,
      valid       => samp_fifo_dval
      );
   
end rtl;
