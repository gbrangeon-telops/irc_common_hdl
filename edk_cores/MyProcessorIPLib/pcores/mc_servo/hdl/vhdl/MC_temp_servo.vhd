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
--								  `````.....`````
---------------------------------------------------------------------------------------------------

--  Destination: General VHDL code
--				
--
--	File: MC_temp_servo.vhd
--	Hierarchy: Sub-module file
--  Use: Performs the P-I servo-loop of a TEC-driven temperature control system
--	Project: GATORADE - ROIC Card (EFA-00077-004) & Interface Card (EFA-00130-001)
--	By: Loeïza Noblesse
--  Date: 18 may 2006
--
--******************************************************************************
--Description
--******************************************************************************
--	This Entity compares the temperature reading and the desired setpoints.
-- The error integrator and proportional servo-loop, adjusted with Kp and Ki.
-- The result is the Current Command that should be applied to the Heat Resistor.
--******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.ALL;
use work.MC_define.ALL;

entity MC_temp_servo is		
	generic (
		KI	:	integer := 0;
		KP 	:	integer := 0;
		KP_LSB	:integer :=0;
		KI_LSB	:integer :=0;
		CLK_RATE :integer :=Gen_Clk_Rate;
		SERVO_RATE_DEN : integer :=SERVO_RATE_DEN;
		SERVO_RATE_NUM : integer :=SERVO_RATE_NUM
		);
		
	port (
		-- General signals
		CLK       : in std_logic;	
		RST       : in std_logic;							 
		-- Temperature signals
		ADC_DATA  : in std_logic_vector(15 downto 0);	--	Temperature Readout ADC ADC_DATA
		ADC_DVAL  : in std_logic;				  		-- ADC ADC_DATA Valid
		-- Control signal
		ENABLE    :	in std_logic;							  
 	    TEMP_SET  : in std_logic_vector(15 downto 0);
      	DAC_VAL   : out std_logic_vector(15 downto 0);
		DAC_TEST	 : out std_logic_vector(15 downto 0);
		STEP_MODE : in std_logic);						-- Enables Fixed commands rather than Servo-loop
	end MC_temp_servo;

architecture RTL of MC_temp_servo is	
-- all constant defined in MC_Define.vhd

	-- Détails du calcul de KP - KI
	-- Gain = Gain_BO / 10  (Valide pour système du premier ordre)
	-- constant Gain_BO : real := 10.0;
	-- constant Gain : real := Gain_BO / 10.0;	
	-- Le gain se définit comme [(Temp_Final - Temp_Initial) / (Cmd Finale - Cmd Initiale)]
	-- 3*Tau = Temps de réponse à l'échelon de 0 à 95% 
	-- constant Tau : real := 5.0; -- [sec]
	-- KP is the Proportional Coefficient
	-- KP = 1/Gain_BF
	-- constant KP_LSB : integer := 4; 	-- KP LSB = 2^-4
	-- KI is the Integrator Coefficient
	-- KI = 1/Tau * 1/Gain * 1/SL_Rate
	-- constant KI_LSB : integer := 13;  -- KI LSB = 2^-13
	-- constant KI : integer := (2**KI_LSB) / integer(Tau * Gain) / SL_Rate; 
	
	-- Signaux intermédiaires
	signal Error 		: signed(16 downto 0);				-- TEMP_SET - Temp
	signal Integrator : unsigned((15 + KI_LSB) downto 0);	-- Accumulation of Err_Integ (16 bits integer + KI_LSB bits fractionnal)
	signal KP_Coeff : signed(6 downto 0);					-- Proportional Coefficient
	signal KI_Coeff : signed(6 downto 0);					-- Integrator Coefficient
	signal Err_Propor : signed((Error'length+KP_Coeff'length - 1) downto 0);	-- Error * KP_Coeff
	signal Err_Integ  : signed((Error'length+KI_Coeff'length - 1) downto 0);	-- Error * KI_Coeff
	signal Command : unsigned(15 downto 0);
	signal ADC_DVAL_sr : std_logic;	-- Register copy of ADC_DVAL to detect transitions on risin edge
	signal loop_pulse : std_logic;
	
	--Constantes
	constant DIV_RATIO   : integer := CLK_RATE * SERVO_RATE_DEN/SERVO_RATE_NUM;			--servo clock computation

	-- clock divider instantiation for heating servo loop freq
	component clk_divider_pulse is
		generic(
			FACTOR : integer);
		port(
			CLOCK     : in  std_logic;
			RESET     : in  std_logic;
			PULSE     : out std_logic);
	end component clk_divider_pulse; 
	
	
	-- GRAY ENCODED state machine: Servo_SM
	type Servo_SM_type is (Idle, Wait_data, Coeff, Integrate);
	signal Servo_SM: Servo_SM_type;
	
	--attribute enum_encoding: string;
--	attribute enum_encoding of Servo_SM_type: type is
--		"00 " &		-- Idle
--		"01 " &		-- Wait Data
--		"10 " &		-- Coeff
--		"11 " ;		-- Integrator
		
-----------------------------------------------------------------	
--Adder with saturation management	
-----------------------------------------------------------------		
	function Adder (a: unsigned;b : signed) return unsigned is
		variable aext :	signed(a'length+1 downto 0);
		variable bext :	signed(b'length+1 downto 0);
		variable lca_sum:	signed(a'length+1 downto 0);
		variable lcb_sum: signed(b'length+1 downto 0);
		variable s :	unsigned(a'length-1 downto 0);
		variable No_Sat : boolean;  						-- True if the sum does not saturate
	begin
		aext := signed(resize(a,a'length+2));
		bext := resize(b,b'length+2);
		if (a'length >= b'length) then
			lca_sum := aext + bext; 
			if lca_sum(a'length+1 downto a'length) = "00" then
				-- Positive, no saturation
				s := unsigned(lca_sum(a'length-1 downto 0));
			else
				-- Negative, forced to zero
				-- Positive saturation, forced to positive max
				-- Negative saturation, forced to zero
				s := (others => not lca_sum(a'length+1));
			end if;	
			return s;
		else
		 	lcb_sum := aext + bext;
			No_Sat := true;
			for i in b'length+1 downto a'length loop
				No_Sat := No_Sat and ( lcb_sum(i) = '0' );
			end loop;
			if No_Sat then -- No saturation
				s := unsigned(lcb_sum(a'length-1 downto 0));
			else
				s:= (others=>not lcb_sum(b'length+1));
			end if;
			return s;
		end if;		
		
	end function Adder;		

begin		
	-- clock divider instantiation for temperature servo loop freq
	clk_div_inst : clk_divider_pulse
	generic map(
		FACTOR => DIV_RATIO)
	port map(
		CLOCK => CLK,
		RESET => RST,
		PULSE => loop_pulse);	 

	KP_Coeff <= to_signed(KP,KP_Coeff'length);
	KI_Coeff <= to_signed(KI,KI_Coeff'length);	
	DAC_VAL <= std_logic_vector(Command);	
	
	----------------------------------------------------------------------
	-- Machine: Servo_SM
	----------------------------------------------------------------------
	Servo_SM_machine: process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				ADC_DVAL_sr <= '0';
				Err_Propor <= (others => '0');
				Command <= (others => '0');
				Integrator <= (others => '0');
				Error <= (others => '0');
				Servo_SM <= Idle;
			else				
				ADC_DVAL_sr <= ADC_DVAL;
				case Servo_SM is
					when Idle =>
						-- Le calcul d'erreur est inversé car la Température est inversement proportionnelle
						-- au voltage lu.
						--Error <=  signed('0' & ADC_DATA) - signed('0'& TEMP_SET);
						--Error <= signed('0'& TEMP_SET) - signed('0' & ADC_DATA); --Gain négatif
						-- Waiting for the next temperature measurement
						-- Flush the Accumulator when the loop is disabled
						if ENABLE = '0' then
							Integrator <= (others => '0');
							Err_Propor <= (others => '0');
							Error <= (others => '0');
						elsif (loop_pulse = '1') then
							Servo_SM <= Wait_data;							
						end if;
						
						if STEP_MODE = '0' then
							Command <= unsigned(TEMP_SET);
							DAC_TEST <= ADC_DATA;
						else
							Command <= Adder(Integrator(Integrator'high downto KI_LSB),Err_Propor(Err_Propor'high downto KP_LSB));
							DAC_TEST <= not std_logic(Error(16)) & std_logic_vector(Error(15 downto 1));
						end if;
					when Wait_data =>
						if ADC_DVAL = '1' and ADC_DVAL_sr = '0' then	--Détection transition sur ADC_DVAL
							Error <= signed('0'& TEMP_SET) - signed('0' & ADC_DATA); --Gain négatif
							Servo_SM <= Coeff;							
						end if;
					when Coeff =>
					-- Calculates P and I Errors
						Err_Propor	<= Error * KP_Coeff;
						Err_Integ 	<= Error * KI_Coeff;
						Servo_SM 	<= Integrate;
					when Integrate =>
					-- Accumulates Err_Integ
						Integrator <= Adder(Integrator,Err_Integ);
						Servo_SM <= Idle;
					when others =>
						-- trap state
						Servo_SM <= Idle;
						Err_Propor <= (others => '0');
						Command <= (others => '0');
						Integrator <= (others => '0');
				end case;
			end if;	
		end if;
	end process;
	
end RTL;

