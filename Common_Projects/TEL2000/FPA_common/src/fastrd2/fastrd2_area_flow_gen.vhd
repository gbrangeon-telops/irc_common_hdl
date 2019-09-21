------------------------------------------------------------------
--!   @file : fastrd2_area_flow_gen
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
use work.fpa_define.all;
use work.fastrd2_define.all; 

entity fastrd2_area_flow_gen is
   
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      AREA_FIFO_DVAL    : in std_logic;
      AREA_FIFO_RD      : out std_logic;
      AREA_FIFO_DATA    : in std_logic_vector(71 downto 0);
      
      AREA_INFO         : out area_info_type;
      AFULL             : in std_logic
      );  
end fastrd2_area_flow_gen;


architecture rtl of fastrd2_area_flow_gen is 
   
   component sync_reset
      port(
         ARESET                 : in std_logic;
         SRESET                 : out std_logic;
         CLK                    : in std_logic);
   end component;
   
   type ctler_fsm_type is (idle, weight_st);
   
   
   signal ctler_fsm             : ctler_fsm_type;
   signal area_info_i           : area_info_type;
   signal area_info_o           : area_info_type;
   signal sreset                : std_logic;
   signal area_fifo_rd_i        : std_logic;
   signal counter               : unsigned(9 downto 0);
   signal area_info_dval_i      : std_logic;
   
begin
   
   ---------------------------------------------------
   --  output map 
   ---------------------------------------------------
   AREA_FIFO_RD <= area_fifo_rd_i;
   AREA_INFO <= area_info_o;   
   
   ---------------------------------------------------
   --  input map 
   ---------------------------------------------------
   area_info_i <= vector_to_area_info_func(AREA_FIFO_DATA);   
   
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
   -- analyse et sortie des données 
   --------------------------------------------------
   U3: process(CLK) 
      variable incr : unsigned(1 downto 0);
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            ctler_fsm <= idle;
            area_info_o.info_dval <= '0';
            area_info_o.raw.rd_end <= '0';
            area_fifo_rd_i <= '0';
            counter <= to_unsigned(0, counter'length);
            area_info_dval_i <= '0';
            area_info_o.clk_info.clk <= '0';
            
         else 
            
            incr := unsigned('0'& (AREA_FIFO_DVAL and not AFULL));
            area_fifo_rd_i <= '0';
            area_info_dval_i <= AREA_FIFO_DVAL and not AFULL;
            
            --------------------------------------------------------
            -- outputs
            --------------------------------------------------------
            area_info_o.raw <= area_info_i.raw;
            area_info_o.user <= area_info_i.user;
            area_info_o.info_dval <= area_info_dval_i;
            
            --------------------------------------------------------
            -- generation de clk_info
            --------------------------------------------------------
            counter <= counter + incr;
            if counter = 1 then
               area_info_o.clk_info.sof <= '1';
            else
               area_info_o.clk_info.sof <= '0';
            end if;
            
            if counter = 0 then
               area_info_o.clk_info.eof <= '1';
            else
               area_info_o.clk_info.eof <= '0';
            end if;
            
            if counter = 1 then
               area_info_o.clk_info.clk <= '1';
            elsif counter = DEFINE_FPA_CLK_INFO.MCLK_RATE_FACTOR_DIV2(to_integer(area_info_i.clk_info.clk_id)) then
               area_info_o.clk_info.clk <= '0';
            end if;
            
            --------------------------------------------------------
            -- lecture fifo
            --------------------------------------------------------
            if counter >= DEFINE_FPA_CLK_INFO.PCLK_RATE_FACTOR_M1(to_integer(area_info_i.clk_info.clk_id)) then
               counter <= to_unsigned(0, counter'length);
               area_fifo_rd_i <= '1';  
            end if;                  
            
            
         end if;
      end if;
   end process;    
   
end rtl;
