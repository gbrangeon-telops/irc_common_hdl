------------------------------------------------------------------
--!   @file : fastrd2_area_flow_gen_core
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

entity fastrd2_area_flow_gen_core is
   
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      START             : in std_logic;
      AREA_DIN          : in area_info_type;     
      AREA_DOUT         : out area_info_type;
      
      DONE              : out std_logic
      );  
end fastrd2_area_flow_gen_core;


architecture rtl of fastrd2_area_flow_gen_core is 
   
   component sync_reset
      port(
         ARESET                 : in std_logic;
         SRESET                 : out std_logic;
         CLK                    : in std_logic);
   end component;
   
   type core_fsm_type is (idle, weight_st);
   
   signal core_fsm              : core_fsm_type;
   signal area_dout_i           : area_info_type;
   signal sreset                : std_logic;
   signal done_i                : std_logic;
   signal dcnt                  : unsigned(9 downto 0);
   
begin
   
   ---------------------------------------------------
   --  output map 
   ---------------------------------------------------
   AREA_DOUT <= area_dout_i;
   DONE <= done_i;   
   
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
   -- repartition des données entre deux lanes  
   --------------------------------------------------
   U3: process(CLK) 
      
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            core_fsm <= idle;
            done_i <= '0';
            area_dout_i.info_dval <= '0';
            
         else      
            
            
            case core_fsm is 
               
               when idle =>
                  done_i <= '1';
                  dcnt <= to_unsigned(1, dcnt'length);
                  if START = '1' then                     
                     area_dout_i <= AREA_DIN;
                     area_dout_i.info_dval <= '1';   -- une redondance en fait
                     done_i <= '0';
                     core_fsm <= weight_st;
                  end if;
               
               when weight_st =>
                  dcnt <= dcnt + 1;
                  if dcnt = DEFINE_FPA_CLK_INFO.PCLK_RATE_FACTOR(to_integer(area_dout_i.clk_info.clk_id)) then
                     done_i <= '1';    -- done devancé d'un clk pour gain en vitesse 
                     area_dout_i.info_dval <= '0';
                     core_fsm <= idle;
                  end if;                  
               
               when others =>
               
            end case;
            
            
         end if;
      end if;
   end process;
   
   
end rtl;
