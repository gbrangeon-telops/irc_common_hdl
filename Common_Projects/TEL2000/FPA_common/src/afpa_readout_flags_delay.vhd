------------------------------------------------------------------
--!   @file : afpa_readout_flags_delay
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
use IEEE.numeric_std.all;
use work.fpa_define.all;
use work.proxy_define.all;

entity afpa_readout_flags_delay is
   port(
      ARESET         : in std_logic;
      MCLK_SOURCE    : in std_logic;
      
      FPA_INTF_CFG   : in fpa_intf_cfg_type;
      
      READOUT_INFO_I : in readout_info_type;
      READOUT_INFO_O : out readout_info_type;
      ERR            : out std_logic
      );
end afpa_readout_flags_delay;
 

architecture rtl of afpa_readout_flags_delay is

constant C_FIFO_RST_CNT_BIT_POS :integer := 3; -- position du bit du compteur de rst

   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component fwft_sfifo_w32_d256
      port (
         clk   : in std_logic;
         srst  : in std_logic;
         din   : in std_logic_vector(31 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout  : out std_logic_vector(31 downto 0);
         full  : out std_logic;
         almost_full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;
   
   type fsm_type is (idle, dly_st, rd_st, wait_end_st, rst_fifo_st);
   
   
   signal aoi_fsm, naoi_fsm    : fsm_type;            
   signal sreset               : std_logic;
   signal readout_info_s       : readout_info_type;
   
   signal aoi_fifo_dval        : std_logic;
   signal aoi_fifo_dout        : std_logic_vector(31 downto 0);
   signal aoi_fifo_din         : std_logic_vector(31 downto 0);
   signal aoi_fifo_wr          : std_logic;
   signal aoi_fifo_rd          : std_logic;
   signal aoi_fifo_ovfl        : std_logic;                                    
   signal aoi_fifo_rst         : std_logic;
   signal aoi_dly_cnt          : unsigned(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY'LENGTH-1 downto 0);
   signal aoi_rst_cnt          : unsigned(7 downto 0);
   
   signal naoi_fifo_dval       : std_logic := '0';
   signal naoi_fifo_dout       : std_logic_vector(31 downto 0) := (others =>'0');
   signal naoi_fifo_din        : std_logic_vector(31 downto 0) := (others =>'0');
   signal naoi_fifo_wr         : std_logic := '0';
   signal naoi_fifo_rd         : std_logic := '0';
   signal naoi_fifo_ovfl       : std_logic := '0';                                    
   signal naoi_fifo_rst        : std_logic := '0';
   signal naoi_dly_cnt         : unsigned(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY'LENGTH-1 downto 0);
   signal naoi_rst_cnt         : unsigned(7 downto 0);
   
   signal err_i                : std_logic;
   
begin
   
   
   READOUT_INFO_O <= readout_info_s;
   ERR <= err_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------
   U1: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => MCLK_SOURCE,
      SRESET => sreset
      );
   
   ---------------------------------------------------------------------
   -- flags out                                                
   ---------------------------------------------------------------------
   U2: process(MCLK_SOURCE)
   begin
      if rising_edge(MCLK_SOURCE) then         
         if sreset = '1' then
            readout_info_s.aoi.samp_pulse  <= '0';
            readout_info_s.aoi.dval        <= '0';
            readout_info_s.naoi.samp_pulse <= '0';
            readout_info_s.naoi.dval       <= '0';
            readout_info_s.samp_pulse      <= '0';
            
         else
            
            
            readout_info_s.samp_pulse <= READOUT_INFO_I.SAMP_PULSE;
            
            -- aoi flag fifo out
            readout_info_s.aoi.spare         <= aoi_fifo_dout(22 downto 8);
            readout_info_s.aoi.samp_pulse    <= aoi_fifo_dout(7);
            readout_info_s.aoi.sof           <= aoi_fifo_dout(6);
            readout_info_s.aoi.eof           <= aoi_fifo_dout(5);
            readout_info_s.aoi.sol           <= aoi_fifo_dout(4);
            readout_info_s.aoi.eol           <= aoi_fifo_dout(3);
            readout_info_s.aoi.fval          <= aoi_fifo_dout(2);
            readout_info_s.aoi.lval          <= aoi_fifo_dout(1);
            readout_info_s.aoi.dval          <= aoi_fifo_dout(0) and aoi_fifo_dval and aoi_fifo_rd;
            
            -- non_aoi flag fifo out 
            readout_info_s.naoi.spare        <= naoi_fifo_dout(18 downto 6);
            readout_info_s.naoi.samp_pulse   <= naoi_fifo_dout(5);
            readout_info_s.naoi.ref_valid    <= naoi_fifo_dout(4 downto 3);
            readout_info_s.naoi.dval         <= naoi_fifo_dout(2) and naoi_fifo_dval and naoi_fifo_rd;
            readout_info_s.naoi.stop         <= naoi_fifo_dout(1);
            readout_info_s.naoi.start        <= naoi_fifo_dout(0);
            
         end if;     
      end if; 
      
   end process;
   
   
   ------------------------------------------------
   -- AOI
   ------------------------------------------------
   -- aoi fag fifo mapping      
   U3 : fwft_sfifo_w32_d256
   port map (
      clk         => MCLK_SOURCE,
      srst        => aoi_fifo_rst,
      din         => aoi_fifo_din,
      wr_en       => aoi_fifo_wr,
      rd_en       => aoi_fifo_rd,
      dout        => aoi_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => aoi_fifo_ovfl,
      empty       => open,
      valid       => aoi_fifo_dval
      );
   
   -- aoi_fsm de contrôle
   U4: process(MCLK_SOURCE)
   begin
      if rising_edge(MCLK_SOURCE) then 
         if sreset = '1' then
            aoi_fsm   <= idle;
            aoi_fifo_rst <= '1'; 
            aoi_fifo_wr <= '0';
            aoi_fifo_rd <= '0';
            err_i <= '0';
            
         else
            
            aoi_fifo_din(22 downto 0) <= READOUT_INFO_I.AOI.SPARE & READOUT_INFO_I.SAMP_PULSE & READOUT_INFO_I.AOI.SOF & READOUT_INFO_I.AOI.EOF & READOUT_INFO_I.AOI.SOL & READOUT_INFO_I.AOI.EOL & READOUT_INFO_I.AOI.FVAL & READOUT_INFO_I.AOI.LVAL & READOUT_INFO_I.AOI.DVAL;  -- read_end n'est plus ecrit dans les fifos
            
            if aoi_fifo_ovfl = '1' or naoi_fifo_ovfl = '1' then 
               err_i <= '1';
            end if;
            
            case aoi_fsm is
               
               --  on attend le debut d'une image              
               when idle =>
                  aoi_dly_cnt <= (others => '0');
                  aoi_rst_cnt <= (others => '0');
                  aoi_fifo_rst <= '0';
                  aoi_fifo_rd <= '0';
                  aoi_fifo_wr <= '0';
                  if READOUT_INFO_I.AOI.SOF = '1' and READOUT_INFO_I.AOI.DVAL = '1' then
                     aoi_fifo_wr <= '1';
                     aoi_fsm <= dly_st; 
                  end if;               
                  
               --  on decale la lecture du fifo 
               when dly_st =>
                  if READOUT_INFO_I.SAMP_PULSE = '1' then   -- SAMP_PULSE est issue d'une horloge de reference qui a une phase constante avec celle des ADCs
                     aoi_dly_cnt <= aoi_dly_cnt + 1;                     
                     if aoi_dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then    
                        aoi_fsm <= rd_st;
                     end if;
                  end if;
                  
               --  on permet la lecture des données du fifo
               when rd_st =>
                  aoi_fifo_rd <= aoi_fifo_dval;
                  if readout_info_s.aoi.fval = '1' then
                     aoi_fsm <= wait_end_st;
                  end if;
                  
               --  on s'assure que la tombée de fval a eu lieu   
               when wait_end_st =>
                  if readout_info_s.aoi.fval = '0' then
                     aoi_fifo_rd <= '0';
                     aoi_fifo_wr <= '0';
                     aoi_fsm <= rst_fifo_st;
                  end if; 
                  
               -- on fait un reset sur le fifo pour le vider  
               when rst_fifo_st =>
                  aoi_fifo_rst <= '1';
                  aoi_rst_cnt  <= aoi_rst_cnt + 1;
                  if aoi_rst_cnt(C_FIFO_RST_CNT_BIT_POS) = '1' then
                     aoi_fsm <= idle;
                  end if;              
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   ------------------------------------------------
   -- NON_ AOI: Gestionnaire des Flags
   ------------------------------------------------
   
   g0: if (DEFINE_GENERATE_ELCORR_CHAIN = '0') generate
      begin
      naoi_fifo_dout <= (others => '0');
      naoi_fifo_ovfl <= '0';
      naoi_fifo_dval <= '0';
   end generate;
   
   
   g1: if (DEFINE_GENERATE_ELCORR_CHAIN = '1') generate
      begin
      
      -- naoi fag fifo mapping      
      U5 : fwft_sfifo_w32_d256
      port map (
         clk         => MCLK_SOURCE,
         srst        => naoi_fifo_rst,
         din         => naoi_fifo_din,
         wr_en       => naoi_fifo_wr,
         rd_en       => naoi_fifo_rd,
         dout        => naoi_fifo_dout,
         full        => open,
         almost_full => open,
         overflow    => naoi_fifo_ovfl,
         empty       => open,
         valid       => naoi_fifo_dval
         );
      
      -- naoi_fsm de contrôle
      U6: process(MCLK_SOURCE)
      begin
         if rising_edge(MCLK_SOURCE) then 
            if sreset = '1' then
               naoi_fsm   <= idle;
               naoi_fifo_rst <= '1'; 
               naoi_fifo_wr <= '0';
               naoi_fifo_rd <= '0';
               
            else
               
               naoi_fifo_din(18 downto 0) <= READOUT_INFO_I.NAOI.SPARE & READOUT_INFO_I.SAMP_PULSE & READOUT_INFO_I.NAOI.REF_VALID & READOUT_INFO_I.NAOI.DVAL & READOUT_INFO_I.NAOI.STOP & READOUT_INFO_I.NAOI.START;            
               
               case naoi_fsm is
                  
                  --  on attend le debut            
                  when idle =>
                     naoi_dly_cnt <= (others => '0');
                     naoi_rst_cnt <= (others => '0');
                     naoi_fifo_rst <= '0';
                     naoi_fifo_rd <= '0';
                     naoi_fifo_wr <= '0';
                     if READOUT_INFO_I.NAOI.START = '1' and READOUT_INFO_I.NAOI.DVAL = '1' then
                        naoi_fifo_wr <= '1';
                        naoi_fsm <= dly_st; 
                     end if;               
                     
                  --  on decale la lecture du fifo 
                  when dly_st =>
                  if READOUT_INFO_I.SAMP_PULSE = '1' then
                        naoi_dly_cnt <= naoi_dly_cnt + 1;                     
                        if naoi_dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then    
                           naoi_fsm <= rd_st;
                        end if;
                     end if;
                     
                  --  on permet la lecture des données du fifo
                  when rd_st =>
                     naoi_fifo_rd <= naoi_fifo_dval;
                     if readout_info_s.naoi.stop = '1' then
                        naoi_fsm <= wait_end_st;
                     end if;
                     
                  --  on s'assure que la tombée de fval a eu lieu   
                  when wait_end_st =>
                     if readout_info_s.naoi.stop = '0' then
                        naoi_fifo_rd <= '0';
                        naoi_fifo_wr <= '0';
                        naoi_fsm <= rst_fifo_st;
                     end if;                   
                     
                  -- on fait un reset sur le fifo pour le vider  
                  when rst_fifo_st =>
                     naoi_fifo_rst <= '1';
                     naoi_rst_cnt  <= naoi_rst_cnt + 1;
                     if naoi_rst_cnt(C_FIFO_RST_CNT_BIT_POS) = '1' then
                        naoi_fsm <= idle;
                     end if;              
                  
                  when others =>
                  
               end case;
               
            end if;
         end if;
      end process;
      
   end generate; 
   
   
end rtl;
