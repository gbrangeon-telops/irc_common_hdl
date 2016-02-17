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
--	                                              ^^^^^......^^^^^
---------------------------------------------------------------------------------------------------
--
--  Title   : idelay_ctr_gen
--  By      : Jean-Philippe Déry
--  Date    : April 2009
--
--******************************************************************************
--Description
--******************************************************************************
-- Instantiates N idelay_ctrl blocks
--
--******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;  

-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on

entity idelay_ctrl_gen is
   generic(
      IDELAYCTRL_NUM : integer := 1
   );
   port (
      clk200          : in std_logic;	-- System Clock
      reset   : in std_logic;	-- Active LOW  - Directly from the input pin
      rdy_status    : out std_logic	-- Active HIGH - Circuit Reset (with a power-on pulse)
      );
end idelay_ctrl_gen;

architecture RTL of idelay_ctrl_gen is 

   component IDELAYCTRL is
     port(
         RDY	: out std_ulogic;
         REFCLK	: in  std_ulogic;
         RST	: in  std_ulogic
     );
   end component;

  constant ONES : std_logic_vector(IDELAYCTRL_NUM-1 downto 0) := (others=>'1');

  signal rdy_status_i : std_logic_vector(IDELAYCTRL_NUM-1 downto 0);
   
begin    
   
  IDELAYCTRL_INST : for bnk_i in 0 to IDELAYCTRL_NUM-1 generate

  u_idelayctrl : IDELAYCTRL
    port map (
      RDY    => rdy_status_i(bnk_i),
      REFCLK => clk200,
      RST    => reset
      );

  end generate IDELAYCTRL_INST;

  rdy_status <= '1' when (rdy_status_i = ONES) else
                    '0';

end RTL;