------------------------------------------------------------------
--!   @file : fastrd2_clk_info_feeder.vhd
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

entity fastrd2_clk_info_feeder is  
   
   port(
      ARESET           : in std_logic;
      CLK              : in std_logic;
      
      AREA_INFO_I      : in area_info_type;
      AREA_INFO_O      : out area_info_type      
      );
end fastrd2_clk_info_feeder;

architecture rtl of fastrd2_clk_info_feeder is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component; 
   
   signal sreset                 : std_logic;
   signal active_wr              : std_logic;
   signal area_info              : area_info_type;
   signal area_info_dval         : std_logic;   
   
begin
   
   --------------------------------------------------
   -- output map
   --------------------------------------------------
   AREA_INFO_O <= area_info;
   
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
      area_info <= AREA_INFO_I; 
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
               area_info.info_dval <= '0';
            else
               
               if AREA_FIFO_DVAL = '1' then                  
                  active_wr <= not active_wr;
               end if; 
               area_info <=  AREA_INFO_I;
               area_info.info_dval  <= (active_wr or AREA_INFO_I.RAW.RD_END) and AREA_INFO_I.INFO_DVAL;
               
            end if;   
         end if;
      end process;       
   end generate;   
   
end rtl;
