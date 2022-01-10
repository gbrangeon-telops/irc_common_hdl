------------------------------------------------------------------
--!   @file : afpa_cropping_core
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

entity afpa_cropping_core is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      PIX_MOSI       : in t_ll_ext_mosi72;
      PIX_MISO       : out t_ll_ext_miso;
      
      FLAG1_MOSI     : in t_ll_ext_mosi72;
      FLAG1_MISO     : out t_ll_ext_miso;
      
      FLAG2_MOSI     : in t_ll_ext_mosi72;
      FLAG2_MISO     : out t_ll_ext_miso;
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      
      ERR            : out std_logic
      
      );
end afpa_cropping_core;


architecture rtl of afpa_cropping_core is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   component fwft_sfifo_w72_d512
      port (
         clk         : in std_logic;
         srst        : in std_logic;
         din         : in std_logic_vector(71 downto 0);
         wr_en       : in std_logic;
         rd_en       : in std_logic;
         dout        : out std_logic_vector(71 downto 0);
         data_count  : out std_logic_vector(9 downto 0);
         full        : out std_logic;
         almost_full : out STD_LOGIC;
         overflow    : out std_logic;
         empty       : out std_logic;
         valid       : out std_logic
         );
   end component; 
   
   component fwft_sfifo_w4_d1024
      port (
         clk         : in std_logic;
         srst        : in std_logic;
         din         : in std_logic_vector(3 downto 0);
         wr_en       : in std_logic;
         rd_en       : in std_logic;
         dout        : out std_logic_vector(3 downto 0);
         data_count  : out std_logic_vector(10 downto 0);
         full        : out std_logic;
         almost_full : out STD_LOGIC;
         overflow    : out std_logic;
         empty       : out std_logic;
         valid       : out std_logic
         );
   end component; 
   
   signal tx_mosi_i         : t_ll_ext_mosi72;
   signal sreset            : std_logic;
   signal pix_fifo_dout     : std_logic_vector(71 downto 0);
   signal pix_fifo_dval     : std_logic;
   signal pix_fifo_ovfl     : std_logic;
   signal flag_fifo_din     : std_logic_vector(3 downto 0);
   signal flag_fifo_dout    : std_logic_vector(3 downto 0);
   signal flag_fifo_dval    : std_logic;
   signal flag_fifo_ovfl    : std_logic;
   signal flag_fifo_wr      : std_logic;
   signal fifo_rd           : std_logic;
   signal err_i             : std_logic;
   
   
begin
   
   
   PIX_MISO   <= TX_MISO;
   FLAG1_MISO <= TX_MISO;
   FLAG2_MISO <= TX_MISO;
   TX_MOSI    <= tx_mosi_i;
   ERR        <= err_i;
   
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
   -- fifo des données 
   -------------------------------------------------- 
   U2 : fwft_sfifo_w72_d512
   port map (
      srst        => sreset,
      clk         => CLK,
      din         => PIX_MOSI.DATA,
      wr_en       => PIX_MOSI.DVAL,
      rd_en       => fifo_rd,
      dout        => pix_fifo_dout,
      valid       => pix_fifo_dval,
      full        => open,
      overflow    => pix_fifo_ovfl,
      empty       => open,
      data_count  => open,
      almost_full => open
      );
   
   --------------------------------------------------
   -- fifo des flags 
   -------------------------------------------------- 
   U3 : fwft_sfifo_w4_d1024
   port map (
      srst        => sreset,
      clk         => CLK,
      din         => flag_fifo_din,
      wr_en       => flag_fifo_wr,
      rd_en       => fifo_rd,
      dout        => flag_fifo_dout,
      valid       => flag_fifo_dval,
      full        => open,
      overflow    => flag_fifo_ovfl,
      empty       => open,
      data_count  => open,
      almost_full => open
      );
   
   fifo_rd <= pix_fifo_dval and flag_fifo_dval; 
   
   
   --------------------------------------------------
   -- ecriture fifo des flags 
   -------------------------------------------------- 
   U4 :  process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            flag_fifo_wr   <= '0';
            tx_mosi_i.dval <= '0';
            err_i <= '0';
            
         else
            
            err_i <= pix_fifo_ovfl or flag_fifo_ovfl or (TX_MISO.BUSY and (PIX_MOSI.DVAL or FLAG1_MOSI.DVAL or FLAG2_MOSI.DVAL));           
            
            -- ecriture flag fifo
            flag_fifo_wr  <= FLAG1_MOSI.DVAL or FLAG2_MOSI.DVAL;
            if FLAG1_MOSI.DVAL = '1' then
               flag_fifo_din <= FLAG1_MOSI.SOF & FLAG1_MOSI.SOL & FLAG1_MOSI.EOL & FLAG1_MOSI.EOF;
            elsif FLAG2_MOSI.DVAL = '1' then
               flag_fifo_din <= FLAG2_MOSI.SOF & FLAG2_MOSI.SOL & FLAG2_MOSI.EOL & FLAG2_MOSI.EOF;
            end if; 
            
            -- sortie des données
            tx_mosi_i.sof  <= flag_fifo_dout(3);
            tx_mosi_i.sol  <= flag_fifo_dout(2);
            tx_mosi_i.eol  <= flag_fifo_dout(1);
            tx_mosi_i.eof  <= flag_fifo_dout(0);
            tx_mosi_i.dval <= fifo_rd;
            tx_mosi_i.data <= pix_fifo_dout;
            
         end if;
      end if;
      
   end process;
end rtl;
