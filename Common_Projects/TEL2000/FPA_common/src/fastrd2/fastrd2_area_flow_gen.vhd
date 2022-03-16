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
         ARESET       : in std_logic;
         SRESET       : out std_logic;
         CLK          : in std_logic);
   end component;
   
   component fastrd2_area_flow_gen_core    
      port(      
         ARESET       : in std_logic;
         CLK          : in std_logic;      
         START        : in std_logic;
         AREA_DIN     : in area_info_type;     
         AREA_DOUT    : out area_info_type;      
         DONE         : out std_logic
         );  
   end component;
   
   
   type flow_gen_fsm_type is (idle, feed_lane0_st, feed_lane1_st);
   type area_info_pipe_type is array (0 to 4) of area_info_type;
   type clk_source_cnt_pipe_type is array (0 to 4) of unsigned(9 downto 0);
   
   
   signal flow_gen_fsm          : flow_gen_fsm_type;
   signal area_info_i           : area_info_type;
   signal sreset                : std_logic;
   signal area_fifo_rd_i        : std_logic;
   signal area_info_dval_i      : std_logic;
   signal adc_sample_num        : unsigned(area_info_i.user.adc_sample_num'length-1 downto 0);
   signal mclk_source_cnt_pipe  : clk_source_cnt_pipe_type;
   signal area_info_pipe        : area_info_pipe_type;
   signal mclk_type_is_ddr      : std_logic;
   signal gen_start_i           : std_logic_vector(1 downto 0);
   signal gen_done_i            : std_logic_vector(1 downto 0);
   signal area_info_flow        : area_info_type;
   signal gen_dout_i            : area_info_pipe_type;
   signal gen_din_i             : area_info_type;
   signal dly_cnt               : unsigned(9 downto 0);
   signal mclk_source_cnt_lim   : natural range 0 to 31;
   
begin
   
   ---------------------------------------------------
   --  output map 
   ---------------------------------------------------
   AREA_FIFO_RD <= area_fifo_rd_i;
   AREA_INFO <= area_info_pipe(3);   
   
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
   -- repartiteur en ping pong vers les generateurs 
   --------------------------------------------------
   U2: process(CLK)      
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            flow_gen_fsm <= idle;
            area_fifo_rd_i <= '0';
            gen_start_i <= (others => '0');
            
         else     
            
            -- default values
            area_fifo_rd_i <= '0';
            gen_start_i <= (others => '0');
            
            case flow_gen_fsm is 
               
               when idle =>               
                  if AFULL = '0' and AREA_FIFO_DVAL = '1' then 
                     flow_gen_fsm <= feed_lane0_st;
                     dly_cnt <= to_unsigned(1, dly_cnt'length);
                  end if;               
               
               when feed_lane0_st =>
                  dly_cnt <= dly_cnt - 1;
                  if AREA_FIFO_DVAL = '1' and gen_done_i(0) = '1' and dly_cnt = 1 then 
                     flow_gen_fsm <= feed_lane1_st;
                     gen_din_i <= area_info_i;
                     gen_start_i(0) <= '1';
                     area_fifo_rd_i <= '1';
                     dly_cnt <= to_unsigned(DEFINE_FPA_CLK_INFO.PCLK_RATE_FACTOR(to_integer(area_info_i.clk_info.clk_id)), dly_cnt'length);
                  end if;
               
               when feed_lane1_st =>
                  dly_cnt <= dly_cnt - 1;
                  if AREA_FIFO_DVAL = '1'and gen_done_i(1) = '1' and dly_cnt = 1 then
                     flow_gen_fsm <= feed_lane0_st;
                     gen_din_i <= area_info_i;
                     gen_start_i(1) <= '1';
                     area_fifo_rd_i <= '1';
                     dly_cnt <= to_unsigned(DEFINE_FPA_CLK_INFO.PCLK_RATE_FACTOR(to_integer(area_info_i.clk_info.clk_id)), dly_cnt'length);
                  end if;
                  if AFULL = '1' then
                     flow_gen_fsm <= idle; 
                  end if;
               
               when others =>                 
               
            end case;
            
         end if;
      end if;
   end process; 
   
   --------------------------------------------------
   -- les deux generateurs de flow en ping pong
   --------------------------------------------------  
   Ug0: fastrd2_area_flow_gen_core
   port map(
      ARESET    => ARESET,
      CLK       => CLK,
      START     => gen_start_i(0),
      AREA_DIN  => gen_din_i,  
      AREA_DOUT => gen_dout_i(0),  
      DONE      => gen_done_i(0)      
      ); 
   
   Ug1: fastrd2_area_flow_gen_core
   port map(
      ARESET    => ARESET,
      CLK       => CLK,
      START     => gen_start_i(1),
      AREA_DIN  => gen_din_i,  
      AREA_DOUT => gen_dout_i(1),  
      DONE      => gen_done_i(1)      
      ); 
   
   --------------------------------------------------
   -- le merger des deux flows
   --------------------------------------------------  
   U3: process(CLK)      
   begin
      if rising_edge(CLK) then 
         if gen_dout_i(0).info_dval = '1' then
            area_info_flow <= gen_dout_i(0);
         elsif gen_dout_i(1).info_dval = '1' then
            area_info_flow <= gen_dout_i(1);
         else
            area_info_flow.info_dval <= '0';           
         end if;           
      end if;
   end process;
   
   -----------------------------------------------------
   -- generation des flags
   -----------------------------------------------------
   U4: process(CLK)      
   begin
      if rising_edge(CLK) then
         if sreset = '1' then 
            mclk_source_cnt_pipe(0) <=  to_unsigned(1, mclk_source_cnt_pipe(0)'length);
            adc_sample_num <= to_unsigned(1, adc_sample_num'length);
            mclk_source_cnt_lim <= DEFINE_ADC_QUAD_CLK_FACTOR;
            
            for ii in 0 to 3 loop
               area_info_pipe(ii).info_dval <= '0';  
            end loop;
            
         else            
            
            if DEFINE_FPA_PIX_PER_MCLK_PER_TAP = 2 then 
               mclk_type_is_ddr <= '1';
            else
               mclk_type_is_ddr <= '0'; 
            end if;
            
            -----------------------------------------------------
            -- pipe0 : compteur de mclk_source sur les données
            -----------------------------------------------------
            area_info_pipe(0) <= area_info_flow;
            if area_info_flow.info_dval = '1' then                             
               mclk_source_cnt_pipe(0) <= mclk_source_cnt_pipe(0) + 1;
               if area_info_flow.raw.line_pclk_cnt /= area_info_pipe(0).raw.line_pclk_cnt then    -- reset du compteur à chaque debut de pixel 
                  mclk_source_cnt_pipe(0) <=  to_unsigned(1, mclk_source_cnt_pipe(0)'length);
               end if;
            end if;
            
            --------------------------------------------------------
            -- pipe(1): generation de clk_info.clk
            --------------------------------------------------------
            area_info_pipe(1)      <= area_info_pipe(0);
            mclk_source_cnt_pipe(1) <= mclk_source_cnt_pipe(0);
            if area_info_pipe(0).info_dval = '1' then
               if mclk_type_is_ddr = '1' then                        -- pour les fpa en mode ddr, l'horloge est à '1' pour les pixels impairs.
                  area_info_pipe(1).clk_info.clk <= area_info_pipe(0).raw.line_pclk_cnt(0);
               else                                                  -- pour les fpa en mode sdr, l'horloge est à '1' pour la moitié de la durée du pixel.
                  if mclk_source_cnt_pipe(0) <= DEFINE_FPA_CLK_INFO.PCLK_RATE_FACTOR_DIV2(to_integer(area_info_pipe(0).clk_info.clk_id)) then
                     area_info_pipe(1).clk_info.clk <= '1';
                  else
                     area_info_pipe(1).clk_info.clk <= '0';  
                  end if;
               end if;
            end if;
            
            --------------------------------------------------------
            -- pipe(2): generation de adc_sample_num 
            --------------------------------------------------------
            area_info_pipe(2)      <= area_info_pipe(1);
            mclk_source_cnt_pipe(2) <= mclk_source_cnt_pipe(1); 
            if area_info_pipe(1).info_dval = '1' then           
               if mclk_source_cnt_pipe(1) = mclk_source_cnt_lim then                                     
                  adc_sample_num <= adc_sample_num + 1;
                  mclk_source_cnt_lim <=  (to_integer(adc_sample_num) + 1)*DEFINE_ADC_QUAD_CLK_FACTOR;
               end if;
               if area_info_pipe(1).raw.line_pclk_cnt /= area_info_pipe(0).raw.line_pclk_cnt then    -- reset du compteur à chaque debut de pixel 
                  adc_sample_num <=  to_unsigned(1, adc_sample_num'length);
                  mclk_source_cnt_lim <= DEFINE_ADC_QUAD_CLK_FACTOR;
               end if;
            else
               adc_sample_num <= to_unsigned(1, adc_sample_num'length);
               mclk_source_cnt_lim <= DEFINE_ADC_QUAD_CLK_FACTOR;
            end if;
            area_info_pipe(2).raw.adc_sample_num <= adc_sample_num;
            area_info_pipe(2).user.adc_sample_num <= adc_sample_num;
            
            --------------------------------------------------------
            -- pipe(3): generation de clk_info.sof
            -------------------------------------------------------- 
            area_info_pipe(3).clk_info.sof <= '0';
            area_info_pipe(3)      <= area_info_pipe(2);
            if area_info_pipe(2).info_dval = '1' then      
               area_info_pipe(3).clk_info.sof <= area_info_pipe(2).clk_info.clk and not area_info_pipe(3).clk_info.clk;
            end if;
            
         end if;
      end if;
   end process;
   
   
end rtl;
