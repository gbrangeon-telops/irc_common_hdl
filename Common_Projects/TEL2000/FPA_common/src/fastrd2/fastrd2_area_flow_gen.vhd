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
   type area_info_pipe_type is array (0 to 3) of area_info_type;
   
   
   signal ctler_fsm             : ctler_fsm_type;
   signal area_info_i           : area_info_type;
   signal sreset                : std_logic;
   signal area_fifo_rd_i        : std_logic;
   signal counter               : unsigned(9 downto 0);
   signal area_info_dval_i      : std_logic;
   signal adc_sample_num        : unsigned(area_info_i.user.adc_sample_num'length-1 downto 0);
   signal mclk_source_cnt       : unsigned(7 downto 0);
   signal area_info_pipe        : area_info_pipe_type;
   
begin
   
   ---------------------------------------------------
   --  output map 
   ---------------------------------------------------
   AREA_FIFO_RD <= area_fifo_rd_i;
   AREA_INFO <= area_info_pipe(1);   
   
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
      variable incr : std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            ctler_fsm <= idle;
            area_fifo_rd_i <= '0';
            counter <= to_unsigned(0, counter'length);
            area_info_dval_i <= '0';
            area_info_pipe(0).clk_info.clk <= '0';
            area_info_pipe(0).user.adc_sample_num <= to_unsigned(1, area_info_pipe(0).user.adc_sample_num'length);
            mclk_source_cnt <=  to_unsigned(0, mclk_source_cnt'length);
            for ii in 0 to 3 loop
               area_info_pipe(ii).info_dval <= '0';
            end loop;
            
         else 
            
            incr := '0'& (AREA_FIFO_DVAL and not AFULL);
            area_fifo_rd_i <= '0';
            area_info_dval_i <= AREA_FIFO_DVAL and not AFULL;
            
            --------------------------------------------------------
            -- pipe(0): generation du reste de clk_info
            --------------------------------------------------------
            area_info_pipe(0).raw <= area_info_i.raw;
            area_info_pipe(0).user <= area_info_i.user;
            area_info_pipe(0).clk_info.clk_id <= area_info_i.clk_info.clk_id;
            area_info_pipe(0).info_dval <= area_info_dval_i;
            counter <= counter + unsigned(incr);
            
            if counter > DEFINE_FPA_CLK_INFO.MCLK_RATE_FACTOR_DIV2(to_integer(area_info_i.clk_info.clk_id)) then
               area_info_pipe(0).clk_info.clk <= '0';
            end if;
            
            if counter = 1 then
               area_info_pipe(0).clk_info.sof <= '1';
               area_info_pipe(0).clk_info.clk <= '1';
            else
               area_info_pipe(0).clk_info.sof <= '0';
            end if;
            
            if counter = 0 then
               area_info_pipe(0).clk_info.eof <= '1';
               area_info_pipe(0).clk_info.clk <= '0';
            else
               area_info_pipe(0).clk_info.eof <= '0';
            end if;
            
            --------------------------------------------------------
            -- lecture fifo
            --------------------------------------------------------
            if counter >= DEFINE_FPA_CLK_INFO.PCLK_RATE_FACTOR_M1(to_integer(area_info_i.clk_info.clk_id)) then
               counter <= to_unsigned(0, counter'length);
               area_fifo_rd_i <= '1';  
            end if;
            
            --------------------------------------------------------
            -- pipe(1): user.adc_sample_num
            -------------------------------------------------------- 
            area_info_pipe(1) <= area_info_pipe(0);
            mclk_source_cnt <= mclk_source_cnt + unsigned('0' & area_info_pipe(0).info_dval);
            
            if mclk_source_cnt = DEFINE_ADC_QUAD_CLK_FACTOR then                                     
               mclk_source_cnt <=  to_unsigned(1, mclk_source_cnt'length);
               adc_sample_num <= adc_sample_num + 1;
            end if;
            if area_info_pipe(0).raw.line_pclk_cnt /= area_info_i.raw.line_pclk_cnt then    -- reset du compteur à chaque debut de pixel 
               mclk_source_cnt <=  to_unsigned(1, mclk_source_cnt'length);
               adc_sample_num <=  to_unsigned(1, adc_sample_num'length);
            end if;
            area_info_pipe(1).raw.adc_sample_num <= adc_sample_num;
            area_info_pipe(1).user.adc_sample_num <= adc_sample_num;
            
         end if;
      end if;
   end process;    
   
end rtl;
