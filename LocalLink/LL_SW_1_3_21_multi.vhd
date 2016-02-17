-------------------------------------------------------------------------------
--
-- Title       : LL_SW_1_3_21_multi
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Radiocommunication and Signal Processing Laboratory (LRTS)
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink Switch (demux) 1 to 3
--               This "multi-purpose" switch has a special HOLE (fall) mode when
--               SEL uses a special pattern (see code).
--               This is rather specialized and maybe shouldn't be in Common_HDL
--               after all ;)
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_SW_1_3_21_multi is
   port(
      RX_MOSI  : in  t_ll_mosi21;
      RX_MISO  : out t_ll_miso;
      
      TX0_MOSI : out t_ll_mosi21;
      TX0_MISO : in  t_ll_miso;
      
      TX1_MOSI : out t_ll_mosi21;
      TX1_MISO : in  t_ll_miso;
      
      TX2_MOSI : out t_ll_mosi21;
      TX2_MISO : in  t_ll_miso;      
      
      SEL         : in  std_logic_vector(2 downto 0)
      
      );
end LL_SW_1_3_21_multi;


architecture RTL of LL_SW_1_3_21_multi is         
   
   attribute KEEP_HIERARCHY : string;
   attribute KEEP_HIERARCHY of RTL: architecture is "false";
   
   signal FALL : std_logic;
   
   signal FAN1_MOSI : t_ll_mosi21;
   signal FAN1_MISO : t_ll_miso;
   signal FAN2_MOSI : t_ll_mosi21;
   signal FAN2_MISO : t_ll_miso;   
   
begin                 
   
   The_ll_fanout21 : entity ll_fanout21
   generic map(
      use_fifos   => false
      )             
   port map(
   RX_MOSI => RX_MOSI,
   RX_MISO => RX_MISO,
   TX1_MOSI => FAN1_MOSI,
   TX1_MISO => FAN1_MISO,
   TX2_MOSI => FAN2_MOSI,
   TX2_MISO => FAN2_MISO,
   ARESET => '0',
   CLK => '0'
   );         
   
   The_ll_sw_1_2_21 : entity ll_sw_1_2_21
   port map(
      RX_MOSI => FAN1_MOSI,
      RX_MISO => FAN2_MISO,
      TX0_MOSI => TX0_MOSI,
      TX0_MISO => TX0_MISO,
      TX1_MOSI => TX1_MOSI,
      TX1_MISO => TX1_MISO,
      SEL => SEL(1 downto 0)
      );                 
   
   The_ll_hole : entity ll_hole21
   port map(
      RX_MOSI => RX_MOSI,
      RX_MISO => RX_MISO,
      TX_MOSI => TX2_MOSI,
      TX_MISO => TX2_MISO,
      FALL => FALL
      );         
      
      FALL <= '0' when SEL = "010" or SEL = "100" or SEL = "101" else '1';
   
end RTL;
