-------------------------------------------------------------------------------
--
-- Title       : CLK_RST_MNG
-- Design      : MC_Servo
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\FIR-00162-MINI-MODULE(FIRST)\compile\CLK_RST_MNG.vhd
-- Generated   : Tue Jan 15 16:46:13 2008
-- From        : D:\Telops\FIR-00162-MINI-MODULE(FIRST)\src\CLK_RST_MNG.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;


-- other libraries declarations
-- synopsys translate_off 
library VIRTEX4;
library IEEE;
use IEEE.vital_timing.all;
-- synopsys translate_on 

entity CLK_RST_MNG is
  port(
       CLK_IN : in std_ulogic;
       RST_IN : in STD_LOGIC;
       CLK_OUT : out STD_LOGIC;
       RST_OUT : out STD_LOGIC
  );
end CLK_RST_MNG;

architecture CLK_RST_MNG of CLK_RST_MNG is

---- Component declarations -----

component DCM
  port (
       CLKIN_IN : in STD_LOGIC;
       RST_IN : in STD_LOGIC;
       CLK0_OUT : out STD_LOGIC;
       LOCKED_OUT : out STD_LOGIC
  );
end component;
component dcm_reset
  port (
       CLK : in STD_LOGIC;
       RST_IN : in STD_LOGIC;
       DCM_RST : out STD_LOGIC := '1'
  );
end component;
component SRL_Reset
  port (
       CLK : in STD_LOGIC;
       RESET_IN_N : in STD_LOGIC;
       RESET_OUT : out STD_LOGIC
  );
end component;
component IBUFG
-- synopsys translate_off
  generic(
       CAPACITANCE : STRING := "DONT_CARE";
       IBUF_DELAY_VALUE : STRING := "0";
       IOSTANDARD : STRING := "DEFAULT"
  );
-- synopsys translate_on
  port (
       I : in std_ulogic;
       O : out std_ulogic
  );
end component;

---- Signal declarations used on the diagram ----

signal NET100 : STD_LOGIC;
signal NET112 : STD_LOGIC;
signal NET570 : STD_LOGIC;
signal NET574 : STD_LOGIC;
signal NET85 : STD_LOGIC;

---- Configuration specifications for declared components 

-- synopsys translate_off
for U12 : IBUFG use entity VIRTEX4.IBUFG;
-- synopsys translate_on

begin

----  Component instantiations  ----

U1 : DCM
  port map(
       CLK0_OUT => CLK_OUT,
       CLKIN_IN => NET85,
       LOCKED_OUT => NET574,
       RST_IN => NET112
  );

U12 : IBUFG
  port map(
       I => CLK_IN,
       O => NET85
  );

U2 : dcm_reset
  port map(
       CLK => NET85,
       DCM_RST => NET112,
       RST_IN => NET100
  );

RST_OUT <= NET100 or NET570;

U4 : SRL_Reset
  port map(
       CLK => NET85,
       RESET_IN_N => RST_IN,
       RESET_OUT => NET100
  );

NET570 <= not(NET574);


end CLK_RST_MNG;
