------------------------------------------------------------------
--!   @file : afpa_elec_offset_mem
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
use IEEE.numeric_std.all;
use work.Fpa_Common_Pkg.all;
use work.fpa_define.all;
use work.tel2000.all;

entity afpa_elec_offset_mem is
   
   port(
      ARESET        : in std_logic;
      CLK           : in std_logic;
           
      FLUSH_FIFO    : in std_logic;
      FLUSH_DONE    : out std_logic;
      
      OFS1_MOSI     : in t_ll_ext_mosi72;  -- offset pour les colonnes 1 à N (N etant le nombre de taps max)
      OFS1_MISO     : out t_ll_ext_miso;
      
      OFS2_MOSI     : in t_ll_ext_mosi72;  -- offset pour les colonnes N+1 à 2N (N etant le nombre de taps max)
      OFS2_MISO     : out t_ll_ext_miso;
      
      OFS_MOSI      : out t_ll_ext_mosi72; 
      OFS_MISO      : in t_ll_ext_miso;
      
      ERR           : out std_logic
      );
   
end afpa_elec_offset_mem;


architecture rtl of afpa_elec_offset_mem is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   component fwft_sfifo_w76_d16
      port (
         clk : in std_logic;
         rst : in std_logic;
         din : in std_logic_vector(75 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(75 downto 0);
         full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;
   
   type fifo_rst_fsm_type is (idle, flush_fifo_st);
   
   signal fifo_rst_fsm   : fifo_rst_fsm_type;   
   signal sreset         : std_logic;
   signal ofs_fifo_rst   : std_logic;
   signal ofs_fifo_din   : std_logic_vector(75 downto 0);
   signal ofs_fifo_dout  : std_logic_vector(75 downto 0);
   signal ofs_fifo_wr    : std_logic;
   signal ofs_fifo_rd    : std_logic;
   signal ofs_fifo_dval  : std_logic;
   signal dly_count      : unsigned(4 downto 0);
   signal flush_done_i   : std_logic;
   signal flush_fifo_last: std_logic;
   --signal sreset   : std_logic;
   
begin
   
   --------------------------------------------------
   -- IO maps 
   -------------------------------------------------- 
   OFS_MOSI.DATA <= ofs_fifo_dout(OFS_MOSI.DATA'LENGTH-1 downto 0);
   OFS_MOSI.SUPPORT_BUSY <= '1';
   OFS_MOSI.DVAL <= ofs_fifo_dval;
   FLUSH_DONE <= flush_done_i; 
   ofs_fifo_rd <= not OFS_MISO.BUSY;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );
   
   --------------------------------------------------
   -- offset fifo fwft
   -------------------------------------------------- 
   U2 : fwft_sfifo_w76_d16
   port map (
      rst => ofs_fifo_rst,
      clk => CLK,
      din => ofs_fifo_din,
      wr_en => ofs_fifo_wr,
      rd_en => ofs_fifo_rd,
      dout => ofs_fifo_dout,
      valid => ofs_fifo_dval,
      full => open,
      overflow => open,
      empty => open
      );   
      
   --------------------------------------------------
   -- contrôle du fifo des offsets
   -------------------------------------------------- 
   U3 :  process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then 
            ofs_fifo_rst <= '1';
            fifo_rst_fsm <= idle;
            flush_done_i <= '0';
            flush_fifo_last <= FLUSH_FIFO;
            
         else
            
            flush_fifo_last <= FLUSH_FIFO;
            
            -- mux des données à ecrire dans le fifo
            if OFS1_MOSI.DVAL = '1' then 
               ofs_fifo_din <= resize(OFS1_MOSI.DATA, ofs_fifo_din'length);               
            elsif OFS2_MOSI.DVAL = '1' then
               ofs_fifo_din <= resize(OFS2_MOSI.DATA, ofs_fifo_din'length);
            else
               ofs_fifo_din <= ofs_fifo_dout;   -- recyclage
            end if;               
            ofs_fifo_wr <= OFS1_MOSI.DVAL or OFS2_MOSI.DVAL or (ofs_fifo_dval and ofs_fifo_rd);            
            
            -- fsm pour reset
            case fifo_rst_fsm is                          
               
               when idle =>           -- 
                  ofs_fifo_rst <= '0';
                  flush_done_i <= '1';
                  dly_count <= (others => '0');
                  if FLUSH_FIFO = '1' and flush_fifo_last = '0' then 
                     fifo_rst_fsm <= flush_fifo_st;  
                  end if;
               
               when flush_fifo_st =>  --                   
                  ofs_fifo_rst <= '1'; 
                  flush_done_i <= '0';
                  dly_count <= dly_count + 1;
                  if dly_count(4) = '1' then 
                     fifo_rst_fsm <= idle;
                  end if;           
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   
end rtl;
