---------------------------------------------------------------------------------------------------
--                                                      ..`??!````??!..
--                                                  .?!                `1.
--                                               .?`                      i
--                                             .!      ..vY=!``?74.        i
--.........          .......          ...     ?      .Y=` .+wA..   ?,      .....              ...
--"""HMM"""^         MM#"""5         .MM|    :     .H\ .JQgNa,.4o.  j      MM#"MMN,        .MM#"WMF
--   JM#             MMNggg2         .MM|   `      P.;,jMt   `N.r1. ``     MMmJgMM'        .MMMNa,.
--   JM#             MM%````         .MM|   :     .| 1A Wm...JMy!.|.t     .MMF!!`           . `7HMN
--   JMM             MMMMMMM         .MMMMMMM!     W. `U,.?4kZ=  .y^     .!MMt              YMMMMB=
--                                          `.      7&.  ?1+...JY'     .J
--                                           ?.        ?""""7`       .?`
--                                             :.                ..?`
--
---------------------------------------------------------------------------------------------------
--
-- Title       : VP7_Define
-- Design      : VP7
-- Author      : Patrick Dubois
-- Company     : Telops
--
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;	

package VP7_Define is	 
	
	------------------------------------------
	-- Types declarations							
	------------------------------------------
	--type t_dflow_source is (DIAG,ROIC,HEAD,FPGA1,FPGA2,NONE);
	------------------------------------------
	-- Project constants								
	------------------------------------------  
   constant SW_NONE : std_logic_vector(2 downto 0) := "111";
   constant SW_HEAD : std_logic_vector(2 downto 0) := "000";
   constant SW_DIAG : std_logic_vector(2 downto 0) := "010";
   constant SW_FP1  : std_logic_vector(2 downto 0) := "001";
   constant SW_FP2  : std_logic_vector(2 downto 0) := "011"; 
   
   constant CLINK_MODE_STOP   : std_logic_vector(2 downto 0) := "000";
   constant CLINK_MODE_NORMAL : std_logic_vector(2 downto 0) := "001";
   constant CLINK_MODE_DIAG1  : std_logic_vector(2 downto 0) := "010";
   constant CLINK_MODE_DIAG2  : std_logic_vector(2 downto 0) := "011";
   
   
	------------------------------------------
	-- *** FUNCTIONS DECLARATIONS***
	------------------------------------------

end VP7_Define;

------------------------------------------
-- *** ADMET_DEFINE PACKAGE BODY***			
------------------------------------------
package body VP7_Define is

end package body VP7_Define;