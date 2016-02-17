--******************************************************************************
-- 	Destination:
--
--	File: CC_define.vhd
-- 	Hierarchy: Package file
-- 	Use: 
--	Project: FIRST
--	By: Loeïza Noblesse
-- 	Date: 13 June 2006	  
--
--******************************************************************************
--	Description
--******************************************************************************
-- 
--******************************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.ALL;

package MC_Define is
	
	constant Code_Rev : std_logic_vector(7 downto 0) := x"3_1";	-- 3.1 => GATORADE May 2006

	-- Project Define
	constant FIRST : boolean := FALSE;

	-----------------------
	-- Timing Constants  --
	-----------------------
	-- Input Clock rates
	constant Gen_Clk_Rate	:	integer := 100_000_000;	-- 100.000 MHz

	-- Meas_Rate est la fréquence d'opération pour les lectures à ADC
	-- maximum de 185 Hz (mesuré en simulation) dû au temps de stabilisation du filtre à l'ADC 
 	constant Meas_Rate: integer := 100;
	
	------------------------
	-- Servo Loop Parameter-
	------------------------
	
	-- Servo Loop divisor
	constant SERVO_RATE_DEN :integer := 10; 		--Dénominateur pour génération de la fréquence de la servoloop 
	constant SERVO_RATE_NUM :integer := 1; 			--Numérateur 
	
	-- FTS Zone Parameter
	-- Open Loop Parameter
	constant FTS_Gain_BO : real := -0.511;
	constant FTS_Gain : real := FTS_Gain_BO / 10.0;
	-- 3*Tau = Temps de réponse à l'échelon de 0 à 95%
	constant FTS_Tau : real := 956.67;	-- second
	-- KP is the Proportional Coefficient
	-- KP = 1/Gain
	constant FTS_KP_LSB : integer := 1; 	-- KP LSB = 2^-1
	constant FTS_KP : integer := integer(real(2**FTS_KP_LSB) / FTS_Gain); 
	-- KI is the Integrator Coefficient
	-- KI = 1/Tau * 1/Gain * 1/SL_Rate
	constant FTS_KI_LSB : integer := 7;  -- KI LSB = 2^-7
	constant FTS_KI : integer := integer(real(2**FTS_KI_LSB) * real(SERVO_RATE_DEN) / (FTS_Tau * FTS_Gain * real(SERVO_RATE_NUM)));
	
	-- IRLens Zone Parameter
	-- Open Loop Parameter
	constant IRL_Gain_BO : real := -0.447;
	constant IRL_Gain : real := IRL_Gain_BO / 10.0;
	-- 3*Tau = Temps de réponse à l'échelon de 0 à 95%
	constant IRL_Tau : real := 1675.0;	-- second
	-- KP is the Proportional Coefficient
	-- KP = 1/Gain
	constant IRL_KP_LSB : integer := 1; 	-- KP LSB = 2^0
	constant IRL_KP : integer := integer(real(2**IRL_KP_LSB) / IRL_Gain); 
	-- KI is the Integrator Coefficient
	-- KI = 1/Tau * 1/Gain * 1/SL_Rate
	constant IRL_KI_LSB : integer := 8;  -- KI LSB = 2^-8
	constant IRL_KI : integer := integer(real(2**IRL_KI_LSB) * real(SERVO_RATE_DEN) / (IRL_Tau * IRL_Gain * real(SERVO_RATE_NUM)));

	
	constant I1_MAX : std_logic_vector(15 downto 0) := x"FFFF";
	constant I2_MAX : std_logic_vector(15 downto 0) := x"FFFF";
	
 
	function to_std(x:boolean) return std_logic;
	function to_unsigned(x:std_logic) return unsigned;
	
end MC_Define;


-- *** MC_DEFINE PACKAGE BODY***

package body MC_Define is
	
	function to_std(x:boolean) return std_logic is
		variable	y : std_logic;
	begin
		if x then
			y := '1';
		else
			y := '0';
		end if;
		return y;
	end to_std;
	
	function to_unsigned(x:std_logic) return unsigned is
		variable y : unsigned(0 downto 0);
	begin					
		if x = '1' then
			y(0) := '1';
		else
			y(0) := '0';
		end if;
		return y;
	end to_unsigned;

end package body MC_Define;
