-------------------------------------------------------------------------------
--
-- Title       : MC_Servo
-- Design      : MC_Servo
-- Author      : Loeïza Noblesse
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : D:\telops\Common_HDL\edk_cores\MyProcessorIPLib\pcores\mc_servo\aldec\compile\MC_Servo.vhd
-- Generated   : Thu Feb 28 16:16:31 2008
-- From        : D:\telops\Common_HDL\edk_cores\MyProcessorIPLib\pcores\mc_servo\aldec\src\MC_Servo.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MC_define.all;

entity MC_Servo is
  port(
       ADC_1_CPLD_CS_N : in STD_LOGIC;
       CLK : in STD_LOGIC;
       DAC_SERVO_HEATER_CS_LD_N : in STD_LOGIC;
       HEAT_ZONE1_MST_EN_N : in STD_LOGIC;
       HEAT_ZONE2_MST_EN_N : in STD_LOGIC;
       RST : in STD_LOGIC;
       SCLK_CPLD : in STD_LOGIC;
       SDI_B : in STD_LOGIC;
       SDO_CPLD : in STD_LOGIC;
       STEP_MODE : in STD_LOGIC;
       MUX_CPLD_A : in STD_LOGIC_VECTOR(3 downto 0);
       ADC_1_CS_N : out STD_LOGIC;
       DAC_HEATER_CS_LD_N : out STD_LOGIC;
       HEAT_ZONE1_EN_N : out STD_LOGIC;
       HEAT_ZONE2_EN_N : out STD_LOGIC;
       SCLK_B : out STD_LOGIC;
       SDI_A : out STD_LOGIC;
       SDO_B : out STD_LOGIC;
       MUX_A : out STD_LOGIC_VECTOR(3 downto 0)
  );
end MC_Servo;

architecture from_bde of MC_Servo is

---- Component declarations -----

component double_sync
  port (
       CLK : in STD_LOGIC;
       D : in STD_LOGIC;
       RESET : in STD_LOGIC;
       Q : out STD_LOGIC := '0'
  );
end component;
component MC_spi_ctrl_loop
  generic(
       CLK_RATE : INTEGER := 100000000;
       I1_max : std_logic_vector(15 downto 0) := x"FFFF";
       I2_max : std_logic_vector(15 downto 0) := x"FFFF";
       Meas_Rate : INTEGER := 250;
       NB_SLAVES : NATURAL := 2;
       SCL_RATIO_BIT : INTEGER := 6
  );
  port (
       A : in STD_LOGIC_VECTOR(3 downto 0);
       CLK : in STD_LOGIC;
       DAC_A_VAL : in STD_LOGIC_VECTOR(15 downto 0);
       DAC_B_VAL : in STD_LOGIC_VECTOR(15 downto 0);
       RST : in STD_LOGIC;
       SPI_DIN : in STD_LOGIC_VECTOR(23 downto 0);
       SPI_DNE : in STD_LOGIC;
       ADC_A_DVAL : out STD_LOGIC;
       ADC_B_DVAL : out STD_LOGIC;
       ADC_VAL : out STD_LOGIC_VECTOR(15 downto 0);
       ADR : out STD_LOGIC_VECTOR(3 downto 0);
       DATA : out STD_LOGIC_VECTOR(15 downto 0);
       Error_1 : out STD_LOGIC;
       Error_2 : out STD_LOGIC;
       SCL2XSRC : out STD_LOGIC;
       SPI_CPHA : out STD_LOGIC;
       SPI_CPOL : out STD_LOGIC;
       SPI_DOUT : out STD_LOGIC_VECTOR(23 downto 0);
       SPI_EN_SSn : out STD_LOGIC_VECTOR(NB_SLAVES-1 downto 0);
       SPI_NBITS : out STD_LOGIC_VECTOR(4 downto 0);
       SPI_STB : out STD_LOGIC
  );
end component;
component MC_temp_servo
  generic(
       CLK_RATE : INTEGER := Gen_Clk_Rate;
       KI : INTEGER := 0;
       KI_LSB : INTEGER := 0;
       KP : INTEGER := 0;
       KP_LSB : INTEGER := 0;
       SERVO_RATE_DEN : INTEGER := SERVO_RATE_DEN;
       SERVO_RATE_NUM : INTEGER := SERVO_RATE_NUM
  );
  port (
       ADC_DATA : in STD_LOGIC_VECTOR(15 downto 0);
       ADC_DVAL : in STD_LOGIC;
       CLK : in STD_LOGIC;
       ENABLE : in STD_LOGIC;
       RST : in STD_LOGIC;
       STEP_MODE : in STD_LOGIC;
       TEMP_SET : in STD_LOGIC_VECTOR(15 downto 0);
       DAC_TEST : out STD_LOGIC_VECTOR(15 downto 0);
       DAC_VAL : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;
component spi_master
  generic(
       SLAVES : NATURAL := 3
  );
  port (
       ARST : in STD_LOGIC;
       CLK : in STD_LOGIC;
       SCL2XSRC : in STD_LOGIC;
       SPI_CPHA : in STD_LOGIC;
       SPI_CPOL : in STD_LOGIC;
       SPI_DIN : in STD_LOGIC_VECTOR(23 downto 0);
       SPI_EN_SSn : in STD_LOGIC_VECTOR(SLAVES-1 downto 0);
       SPI_MISO : in STD_LOGIC;
       SPI_NBITS : in STD_LOGIC_VECTOR(4 downto 0);
       SPI_STB : in STD_LOGIC;
       SPI_DNE : out STD_LOGIC;
       SPI_DOUT : out STD_LOGIC_VECTOR(23 downto 0);
       SPI_MOSI : out STD_LOGIC;
       SPI_SCK : out STD_LOGIC;
       SPI_SSn : out STD_LOGIC_VECTOR(SLAVES-1 downto 0)
  );
end component;
component SPI_slave_MISO
  port (
       CLK : in STD_LOGIC;
       CS_N : in STD_LOGIC;
       DATA : in STD_LOGIC_VECTOR(15 downto 0);
       RST : in STD_LOGIC;
       SCK : in STD_LOGIC;
       SDI : out STD_LOGIC
  );
end component;
component SPI_slave_MOSI
  port (
       CLK : in STD_LOGIC;
       CS_N : in STD_LOGIC;
       RST : in STD_LOGIC;
       SCK : in STD_LOGIC;
       SDO : in STD_LOGIC;
       TEMP_SET_A : out STD_LOGIC_VECTOR(15 downto 0);
       TEMP_SET_B : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;

---- Signal declarations used on the diagram ----

signal ENABLE_A : STD_LOGIC;
signal ENABLE_B : STD_LOGIC;
signal NET268 : STD_LOGIC;
signal NET272 : STD_LOGIC;
signal NET276 : STD_LOGIC;
signal NET280 : STD_LOGIC;
signal NET284 : STD_LOGIC;
signal NET315 : STD_LOGIC;
signal NET339 : STD_LOGIC;
signal NET482 : STD_LOGIC;
signal NET584 : STD_LOGIC;
signal NET598 : STD_LOGIC;
signal NET602 : STD_LOGIC;
signal NET6212 : STD_LOGIC;
signal NET6226 : STD_LOGIC;
signal BUS11269 : STD_LOGIC_VECTOR (23 downto 0);
signal BUS11273 : STD_LOGIC_VECTOR (23 downto 0);
signal BUS288 : STD_LOGIC_VECTOR (4 downto 0);
signal BUS311 : STD_LOGIC_VECTOR (15 downto 0);
signal BUS328 : STD_LOGIC_VECTOR (15 downto 0);
signal BUS331 : STD_LOGIC_VECTOR (15 downto 0);
signal DATA : STD_LOGIC_VECTOR (15 downto 0);
signal SPI_EN_SSn : STD_LOGIC_VECTOR (1 downto 0);
signal SPI_SSn : STD_LOGIC_VECTOR (1 downto 0);
signal TEMP_SET_A : STD_LOGIC_VECTOR (15 downto 0);
signal TEMP_SET_B : STD_LOGIC_VECTOR (15 downto 0);

begin

----  Component instantiations  ----

U1 : MC_spi_ctrl_loop
  generic map (
       CLK_RATE => Gen_Clk_Rate,
       I1_max => I1_MAX,
       I2_max => I2_MAX,
       Meas_Rate => Meas_RATE,
       NB_SLAVES => 2,
       SCL_RATIO_BIT => 6
  )
  port map(
       A => MUX_CPLD_A,
       ADC_A_DVAL => NET315,
       ADC_B_DVAL => NET339,
       ADC_VAL => BUS328,
       ADR => MUX_A,
       CLK => CLK,
       DAC_A_VAL => BUS311,
       DAC_B_VAL => BUS331,
       DATA => DATA,
       Error_1 => NET6212,
       Error_2 => NET6226,
       RST => RST,
       SCL2XSRC => NET268,
       SPI_CPHA => NET284,
       SPI_CPOL => NET280,
       SPI_DIN => BUS11273,
       SPI_DNE => NET276,
       SPI_DOUT => BUS11269,
       SPI_EN_SSn => SPI_EN_SSn( 1 downto 0 ),
       SPI_NBITS => BUS288,
       SPI_STB => NET272
  );

U10 : double_sync
  port map(
       CLK => CLK,
       D => DAC_SERVO_HEATER_CS_LD_N,
       Q => NET598,
       RESET => RST
  );

U11 : double_sync
  port map(
       CLK => CLK,
       D => SDO_CPLD,
       Q => NET602,
       RESET => RST
  );

ENABLE_A <= not(HEAT_ZONE1_MST_EN_N or NET6212);

ENABLE_B <= not(HEAT_ZONE2_MST_EN_N or NET6226);

HEAT_ZONE1_EN_N <= not(ENABLE_A);

HEAT_ZONE2_EN_N <= not(ENABLE_B);

U2 : spi_master
  generic map (
       SLAVES => 2
  )
  port map(
       ARST => RST,
       CLK => CLK,
       SCL2XSRC => NET268,
       SPI_CPHA => NET284,
       SPI_CPOL => NET280,
       SPI_DIN => BUS11269,
       SPI_DNE => NET276,
       SPI_DOUT => BUS11273,
       SPI_EN_SSn => SPI_EN_SSn( 1 downto 0 ),
       SPI_MISO => SDI_B,
       SPI_MOSI => SDO_B,
       SPI_NBITS => BUS288,
       SPI_SCK => SCLK_B,
       SPI_SSn => SPI_SSn( 1 downto 0 ),
       SPI_STB => NET272
  );

U3 : MC_temp_servo
  generic map (
       KI => FTS_KI,
       KI_LSB => FTS_KI_LSB,
       KP => FTS_KP,
       KP_LSB => FTS_KP_LSB
  )
  port map(
       ADC_DATA => BUS328,
       ADC_DVAL => NET339,
       CLK => CLK,
       DAC_VAL => BUS331,
       ENABLE => ENABLE_B,
       RST => RST,
       STEP_MODE => STEP_MODE,
       TEMP_SET => TEMP_SET_B
  );

U4 : SPI_slave_MISO
  port map(
       CLK => CLK,
       CS_N => NET482,
       DATA => DATA,
       RST => RST,
       SCK => NET584,
       SDI => SDI_A
  );

U5 : SPI_slave_MOSI
  port map(
       CLK => CLK,
       CS_N => NET598,
       RST => RST,
       SCK => NET584,
       SDO => NET602,
       TEMP_SET_A => TEMP_SET_A,
       TEMP_SET_B => TEMP_SET_B
  );

U6 : MC_temp_servo
  generic map (
       KI => FTS_KI,
       KI_LSB => FTS_KI_LSB,
       KP => FTS_KP,
       KP_LSB => FTS_KP_LSB
  )
  port map(
       ADC_DATA => BUS328,
       ADC_DVAL => NET315,
       CLK => CLK,
       DAC_VAL => BUS311,
       ENABLE => ENABLE_A,
       RST => RST,
       STEP_MODE => STEP_MODE,
       TEMP_SET => TEMP_SET_A
  );

U8 : double_sync
  port map(
       CLK => CLK,
       D => SCLK_CPLD,
       Q => NET584,
       RESET => RST
  );

U9 : double_sync
  port map(
       CLK => CLK,
       D => ADC_1_CPLD_CS_N,
       Q => NET482,
       RESET => RST
  );


---- Terminal assignment ----

    -- Output\buffer terminals
	ADC_1_CS_N <= SPI_SSn(0);
	DAC_HEATER_CS_LD_N <= SPI_SSn(1);


end from_bde;
