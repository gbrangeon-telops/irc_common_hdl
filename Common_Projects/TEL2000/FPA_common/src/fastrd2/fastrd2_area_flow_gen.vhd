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
            area_fifo_rd_i <= '0';
            
         else 
            
            incr := unsigned('0'& (AREA_FIFO_DVAL and not AFULL));
            
            --------------------------------------------
            -- pipe 0
            --------------------------------------------             
            case ctler_fsm is
               
               when idle =>
                  counter <= to_unsigned(2, counter'length);
                  area_info_o.info_dval <= '0';
                  if AREA_FIFO_DVAL = '1'  and AFULL = '0' then 
                     ctler_fsm <= weight_st;
                  end if;
               
               when weight_st =>                   
                  area_info_o <= area_info_i;
                  area_info_o.info_dval <= AREA_FIFO_DVAL and not AFULL;
                  counter <= counter + incr;
                  area_fifo_rd_i <= '0';
                  if counter >= DEFINE_FPA_CLK_INFO.PCLK_RATE_FACTOR(to_integer(area_info_i.clk_id)) then
                     counter <= to_unsigned(1, counter'length);
                     area_fifo_rd_i <= AREA_FIFO_DVAL;  
                     if AREA_FIFO_DVAL = '0' or AFULL = '1'  then
                        area_info_o.info_dval <= '0';
                        area_fifo_rd_i <= '0';
                        ctler_fsm <= idle; 
                     end if;
                  end if;                  
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;    
   
end rtl;
