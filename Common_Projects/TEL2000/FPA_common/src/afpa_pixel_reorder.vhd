------------------------------------------------------------------
--!   @file : afpa_pixel_reorder
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
use work.proxy_define.all;
use work.tel2000.all;

entity afpa_pixel_reorder is
   port(		 
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      FPA_INTF_CFG  : fpa_intf_cfg_type;
      
      QUAD_MOSI     : in t_ll_ext_mosi72;
      QUAD_MISO     : out t_ll_ext_miso;
      
      DOUT_MOSI     : out t_axi4_stream_mosi32; 
      DOUT_MISO     : in t_axi4_stream_miso;
      
      ERR           : out std_logic   
      
      );
end afpa_pixel_reorder;


architecture rtl of afpa_pixel_reorder is
   
   component fwft_sfifo_w33_d16
      port (
         clk   : in std_logic;
         srst   : in std_logic;
         din   : in std_logic_vector(32 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout  : out std_logic_vector(32 downto 0);
         full  : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   --type reorder_sm_type is (idle, samp_on_st, samp_off_st);
   type fifo_data_type is array (1 to 2) of std_logic_vector(32 downto 0);
   
   --signal reorder_sm       : reorder_sm_type;
   signal sreset           : std_logic;
   signal fifo_din         : fifo_data_type;
   signal fifo_dout        : fifo_data_type;
   signal fifo_wr_en       : std_logic_vector(1 to 2);
   signal fifo_rd_en       : std_logic_vector(1 to 2);
   signal fifo_dval        : std_logic_vector(1 to 2);
   signal fifo_full        : std_logic_vector(1 to 2);
   signal dout             : std_logic_vector(31 downto 0);
   signal dout_dval        : std_logic;
   signal dout_eof         : std_logic;
   signal count            : integer range 1 to 2;
   signal err_i            : std_logic;
   
begin    
   
   --------------------------------------------------
   -- outputs maps
   -------------------------------------------------- 
   DOUT_MOSI.TDATA <=  dout(15 downto 0) & dout(31 downto 16); -- inversion pour compenser celle dans le header inserter
   DOUT_MOSI.TVALID<=  dout_dval;
   DOUT_MOSI.TSTRB <=  dout_dval & dout_dval & dout_dval & dout_dval;
   DOUT_MOSI.TKEEP <=  dout_dval & dout_dval & dout_dval & dout_dval;
   DOUT_MOSI.TLAST <=  dout_eof;
   DOUT_MOSI.TUSER <=  (others => '0');
   DOUT_MOSI.TID   <=  (others => '0');
   DOUT_MOSI.TDEST <=  (others => '0');
   
   QUAD_MISO.BUSY  <=  fifo_full(1) or fifo_full(2);--not DOUT_MISO.TREADY;     -- on repartit les fifo_full.
   QUAD_MISO.AFULL <=  '0';
   
   ERR <= err_i;
   
   --------------------------------------------------
   -- inputs maps
   --------------------------------------------------        
   U0 : process(CLK)
   begin
      if rising_edge(CLK) then 
         if FPA_INTF_CFG.REORDER_COLUMN = '0' then
            fifo_din(1)   <= '0' & QUAD_MOSI.DATA(33 downto 18) & QUAD_MOSI.DATA(15 downto 0); 
            fifo_din(2)   <= QUAD_MOSI.EOF & QUAD_MOSI.DATA(69 downto 54) & QUAD_MOSI.DATA(51 downto 36);
         else
            fifo_din(1)   <= '0' & QUAD_MOSI.DATA(51 downto 36) & QUAD_MOSI.DATA(69 downto 54); 
            fifo_din(2)   <= QUAD_MOSI.EOF & QUAD_MOSI.DATA(15 downto 0) & QUAD_MOSI.DATA(33 downto 18);
         end if;
         fifo_wr_en(1) <= QUAD_MOSI.DVAL;
         fifo_wr_en(2) <= QUAD_MOSI.DVAL;
      end if;
   end process;
   
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
   -- 2 fifos de 32 bits pour les données 
   --------------------------------------------------   
   U2 : for ii in 1 to 2 generate
      dfifo_ii : fwft_sfifo_w33_d16 
      port map(
         clk      =>  CLK,
         srst     =>  sreset,
         din      =>  fifo_din(ii),
         wr_en    =>  fifo_wr_en(ii), 
         rd_en    =>  fifo_rd_en(ii),
         dout     =>  fifo_dout(ii),
         full     =>  fifo_full(ii),
         overflow =>  open,
         empty    =>  open,
         valid    =>  fifo_dval(ii)      
         );
   end generate;  
   
   --------------------------------------------------
   -- multiplexage
   -------------------------------------------------- 
   U3 : process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            count <=  1;
            fifo_rd_en <= (others => '0');
            dout_dval <= '0';
            err_i <= '0';
            
         else          
            
            err_i <= dout_dval and not DOUT_MISO.TREADY;   -- j'ai horreur du busy. Erreur grave de vitesse 
            
            fifo_rd_en <= (others => '0');                 -- par defaut on ne lit aucun fifo
            
            if fifo_dval(count) = '1' then
               fifo_rd_en(count) <= '1';
               count <= (count mod 2) + 1;
               dout_dval <= '1';
            else
               dout_dval <= '0';
            end if; 
            dout     <= fifo_dout(count)(31 downto 0);
            dout_eof <= fifo_dout(count)(32);
            
            
         end if;                             
      end if;
   end process;
   
end rtl;
