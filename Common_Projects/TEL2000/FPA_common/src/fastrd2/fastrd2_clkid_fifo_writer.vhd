------------------------------------------------------------------
--!   @file : fastrd2_clkid_fifo_writer
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
use IEEE.NUMERIC_STD.all;
use work.fastrd2_define.all;
use work.fpa_define.all;

entity fastrd2_clkid_fifo_writer is
   
   generic(
      G_FIFO_FULL_THRESHOLD : integer := 896
      );   
   
   port(
      ARESET           : in std_logic;
      CLK              : in std_logic;
      
      AREA_FIFO_DATA   : in std_logic_vector(71 downto 0);
      AREA_FIFO_DVAL   : in std_logic;
      AREA_FIFO_AFULL  : out std_logic;
      
      CLKID_FIFO_DCNT  : in std_logic_vector(10 downto 0);
      CLKID_FIFO_DIN   : out std_logic_vector(7 downto 0);
      CLKID_FIFO_WR    : out std_logic
      );
end fastrd2_clkid_fifo_writer;

architecture rtl of fastrd2_clkid_fifo_writer is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component; 
   
   signal sreset                 : std_logic;
   signal active_wr              : std_logic;
   signal clkid_fifo_din_i       : std_logic_vector(CLKID_FIFO_DIN'LENGTH-1 downto 0);
   signal afull_i                : std_logic;
   signal clkid_fifo_wr_i        : std_logic;
   signal area_info              : area_info_type;
   signal area_info_dval         : std_logic;   
   
begin
   
   --------------------------------------------------
   -- output map
   --------------------------------------------------
   CLKID_FIFO_DIN <= clkid_fifo_din_i;
   CLKID_FIFO_WR  <= clkid_fifo_wr_i;
   AREA_FIFO_AFULL <= afull_i;
   
   --------------------------------------------------
   -- input map
   --------------------------------------------------
   area_info <= vector_to_area_info_func(AREA_FIFO_DATA);
   area_info_dval <= AREA_FIFO_DVAL;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );   
   
   --------------------------------------------------
   -- cas d'un pixel par MCLK
   --------------------------------------------------    
   Gen1: if DEFINE_FPA_PIX_PER_MCLK_PER_TAP = 1 generate
      U2: process(CLK)
      begin          
         if rising_edge(CLK) then                     
            if sreset = '1' then  
               active_wr <= '1';
               clkid_fifo_wr_i <= '0';
            else
               clkid_fifo_din_i <= std_logic_vector(area_info.imminent_clk_id) & std_logic_vector(area_info.clk_id);  -- extraction du clk_id
               clkid_fifo_wr_i <= area_info_dval;
            end if;
         end if;
      end process;
   end generate;   
   
   --------------------------------------------------
   -- cas de deux pixels par MCLK (indigo)
   --------------------------------------------------
   -- on ecrit un element sur deux uisque chaque element est generé pour un pclk
   Gen2: if DEFINE_FPA_PIX_PER_MCLK_PER_TAP = 2 generate
      U3: process(CLK)
      begin          
         if rising_edge(CLK) then                     
            if sreset = '1' then  
               active_wr <= '1';
               clkid_fifo_wr_i <= '0';
            else
               
               if AREA_FIFO_DVAL = '1' then                  
                  active_wr <= not active_wr;
               end if;
               clkid_fifo_wr_i  <= (active_wr or area_info.raw.rd_end) and area_info_dval;
               clkid_fifo_din_i <= std_logic_vector(area_info.imminent_clk_id) & std_logic_vector(area_info.clk_id);
               
            end if;   
         end if;
      end process;       
   end generate;   
   
   -------------------------------------------------- 
   -- Ecriture dans le fifo                                 
   -------------------------------------------------- 
   U4: process(CLK)
   begin          
      if rising_edge(CLK) then                     
         if unsigned(CLKID_FIFO_DCNT) > G_FIFO_FULL_THRESHOLD then 
            afull_i <= '1';
         else
            afull_i <= '0';
         end if;            
      end if;
   end process;   
   
   
   
end rtl;
