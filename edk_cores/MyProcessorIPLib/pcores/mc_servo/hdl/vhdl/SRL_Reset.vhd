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
--  Title   : SRL_Reset
--  By      : Patrick Dubois
--  Date    : August 2006
--
--******************************************************************************
--Description
--******************************************************************************
-- This Entity makes sure that the Reset will occur at the FPGA power-up,
-- using SLR16
--
--******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;  

-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on

entity SRL_Reset is
   port (
      CLK          : in std_logic;	-- System Clock
      RESET_IN_N   : in std_logic;	-- Active LOW  - Directly from the input pin
      RESET_OUT    : out std_logic	-- Active HIGH - Circuit Reset (with a power-on pulse)
      );
end SRL_Reset;

architecture RTL of SRL_Reset is 

   attribute KEEP_HIERARCHY : string;
   attribute KEEP_HIERARCHY of RTL: architecture is "true";
   
   signal RESET_IN_N_sync : std_logic :='0';
   signal RESET_OUT_N_buf : std_logic :='1'; 
   
   -- Component declaration of the "srl16(srl16_v)" unit defined in
   -- file: "./src/virtex2P.vhd"
   component srl16
      generic(
         INIT : BIT_VECTOR := X"0000");
      port(
         Q : out std_ulogic;
         A0 : in std_ulogic;
         A1 : in std_ulogic;
         A2 : in std_ulogic;
         A3 : in std_ulogic;
         CLK : in std_ulogic;
         D : in std_ulogic);
   end component;
   --for all: srl16 use entity virtex2p.srl16(srl16_v);
   
   
begin    
   
   -- The input flip-flop is to avoid meta-stability in the SRL16
   -- The output flip-flop is there for timing-closure
   sync_flops : process (CLK)
   begin
      if rising_edge(CLK) then
         RESET_IN_N_sync <= RESET_IN_N;
         RESET_OUT <= not RESET_OUT_N_buf;
      end if;
   end process;
   
   -- SRL16: 16-bit shift register LUT operating on posedge of clock
   -- All FPGAs
   -- The current version of the Xilinx HDL Libraries Guide
   SRL16_inst : SRL16
   -- The following generic declaration is only necessary if you wish to
   -- change the initial contents of the SRL to anything other than all
   -- zero's.
   generic map (
      INIT => X"0000")
   port map (
      Q => RESET_OUT_N_buf, -- SRL data output
      A0 => '1', -- Select[0] input
      A1 => '1', -- Select[1] input
      A2 => '1', -- Select[2] input
      A3 => '1', -- Select[3] input
      CLK => CLK, -- Clock input
      D => RESET_IN_N_sync -- SRL data input
      );
   -- End of SRL16_inst instantiation   
   
   
end RTL;