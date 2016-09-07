--******************************************************************************
-- Destination: 
--
--	File: fleg_brd_define.vhd
-- Hierarchy: Package file
-- Use: 
--	Project: IRCDEV
--	By: Edem Nofodjie
-- Date: 22 october 2009	  
--
--******************************************************************************
--Description
--******************************************************************************
-- 1- Defines the global variables 
-- 2- Defines the project function
--******************************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.all;
use work.fpa_common_pkg.all;  


package fleg_brd_define is    
   
   constant DEFINE_DAC_VALUE_DEFAULT      : unsigned(13 downto 0) := (others => '0'); -- par defaut tous les dacs sont programmés à 0 => 0*(2^14)/VREF 
   constant DEFINE_FLEG_LDO_DLY_mSEC      : natural := 1_000;      -- le delai max de U14 + 1000 msec         
   constant DEFINE_FLEG_DAC_PWR_WAIT_mSEC : natural := 400;      -- après allumage du dac, le temps d'attente avant de les declarer rdy doit être inférieur à 1sec
   constant DEFINE_FPA_100M_CLK_RATE_KHZ  : integer := 100_000;    -- horloge de 100M en KHz
   constant DEFINE_FPA_80M_CLK_RATE_KHZ   : integer := 80_000;     -- horloge de 80M en KHz
   
   -- constantes decrivant les cmds des dacs 
   -- attention ne correspond pas aux bitstream des dacs mais c'est OK: voir fichier ad5648_driver.vhd pour comprendre)
   constant wr_dacN                    : std_logic_vector(3 downto 0) := x"0";
   constant update_dacN                : std_logic_vector(3 downto 0) := x"1";
   constant wr_and_update_dacN         : std_logic_vector(3 downto 0) := x"2";
   constant normal_op_mode             : std_logic_vector(3 downto 0) := x"3";
   constant ldac_mode                  : std_logic_vector(3 downto 0) := x"4";
   constant int_reference_mode         : std_logic_vector(3 downto 0) := x"5";
   constant ext_reference_mode         : std_logic_vector(3 downto 0) := x"6";
   constant load_clear_code            : std_logic_vector(3 downto 0) := x"7";
   
   
   -- calculs
   constant DEFINE_FLEG_LDO_DLY_FACTOR       : integer := DEFINE_FLEG_LDO_DLY_mSEC * DEFINE_FPA_80M_CLK_RATE_KHZ;
   constant DEFINE_FLEG_DAC_PWR_WAIT_FACTOR  : integer := DEFINE_FLEG_DAC_PWR_WAIT_mSEC * DEFINE_FPA_80M_CLK_RATE_KHZ;
   
   
   type vdac_limit_type is 
   record
      min_word : integer range 0 to 2**14-1;
      max_word : integer range 0 to 2**14-1;       
   end record;   
   type fleg_vdac_limit_array_type is array (1 to 8) of vdac_limit_type;                   -- ce type contient des dac_words correspondant aux limites des dacs
   type fleg_vdac_value_type is array (1 to 8) of unsigned(13 downto 0);              -- ce type ne contient pas de voltage, ce sont les words definis à partir des voltages
   type fleg_vcc_voltage_limit_type is array (1 to 2) of  natural range 0 to 8000;    -- ce type contient deux valeurs (FPA_VCC_min_mV, FPA_VCC_max_mV) à ne jamais dépasser 
   
end fleg_brd_define;


package body fleg_brd_define is
   
end package body fleg_brd_define; 
