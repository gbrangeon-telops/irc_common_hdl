---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: _MC_spi_ctrl_loop.vhd
--  Hierarchy: Sub-module file
--  Use: control loop for accessing SPI peripherals (reading ADCs and setting DACs) 
--	 Project: FIRST - Temperature control loop
--	 By: Olivier Bourgois  revised by Loeïza Noblesse
--
--  Revision history:  (use CVS for exact code history)
--    OBO : Oct 7, 2005  - original implementation
--    OBO : Dec 13, 2005 - no longer reading Vref, ICS1, ICS2, ICS3 => smaller RAM
--                         ADDR(2) bit is not used and will be optimized out by ISE
--                         (did not want to change entire chain for now)
--    OBO : May 15, 2006 - fixed and simplified loop rate calculation
--	  LNO : May 31, 2006 - modified code for FIRST needs
--	  HDO : July 25, 2007 - Revised code and tested it on board
--
--  References:
--    EFP-00162-001 schematics -> sheet 13 SPI DAC LTC2602IMS8
--                             -> sheet 15 SPI ADC ADS8320EB
--
--  Notes:
--    Maximum SPI clock rates are 2.4MHz for ADS8320 (limiting factor), 50MHz for LTC2602 
--    -> SCL_RATIO_BIT is set to 6 which gives
--    an SCL frequency of 1.562500 MHz which is < 2.4MHz
--
--    No checks are made to see that all transactions fit within SL_RATE given the SCL_RATIO_BIT
--    value, simulate to verify that no pulse outputs are ignored (arrives before transaction
--    is completed)
--	
--    LNO comments:
--	  The spi_ctrl_loop adresses the MUX, the ADC in loop. When the measure is the temperature for
-- 	  the servo loop (measure 0 and measure 1), after reading the ADC, the data are sent to the servo
-- 	  loop and then the DAC is addressed to send a new command.

---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.conv_std_logic_vector;
library work;

entity MC_spi_ctrl_loop is
	generic(
		CLK_RATE      : integer := 100_000_000;   -- system clock frequency
		Meas_Rate       : integer := 250;         -- Measure loop frequency (Hz)
		SCL_RATIO_BIT : integer := 6;		      -- system clock to SPI clock ratio = 2**SCL_RATIO_BIT
		NB_SLAVES	  : natural := 2;
		
		I1_max : std_logic_vector(15 downto 0) := x"FFFF";	-- max value for the zone 1 current
		I2_max : std_logic_vector(15 downto 0) := x"FFFF"	-- max value for the zone 2 current
		
		);
	port(
		CLK        : in  std_logic;
		RST        : in  std_logic;
		SCL2XSRC   : out std_logic;
		DAC_A_VAL   : in  std_logic_vector(15 downto 0);
		DAC_B_VAL    : in  std_logic_vector(15 downto 0);
		ADC_A_DVAL   : out std_logic;
		ADC_B_DVAL   : out std_logic;
		ADC_VAL    : out std_logic_vector(15 downto 0);
		SPI_DOUT    : out std_logic_vector(23 downto 0);
		SPI_DIN  	: in  std_logic_vector(23 downto 0);
		SPI_STB    : out std_logic;
		SPI_CPOL   : out std_logic;
		SPI_CPHA   : out std_logic;
		SPI_NBITS  : out std_logic_vector(4 downto 0);
		SPI_EN_SSn : out std_logic_vector((NB_SLAVES -1) downto 0); 
		SPI_DNE    : in  std_logic;
		
		ADR 	   : out std_logic_vector(3 downto 0); 	-- address bus to select the mux chanel
		
		A		   : in std_logic_vector(3 downto 0);	-- address bus to chose the measure to read
		DATA	   : out std_logic_vector(15 downto 0); 
		
		Error_1 : out STD_LOGIC;  -- overcurrnet error
		Error_2 : out STD_LOGIC  -- overcurrnet error
		
		);
	
end entity MC_spi_ctrl_loop;

architecture rtl of MC_spi_ctrl_loop is
	
	-- For data and address (from the Rabbit) synchronisation 
	component double_sync_vector is
		port(
			D : in STD_LOGIC_vector;
			Q : out STD_LOGIC_vector;
			CLK : in STD_LOGIC
			);
	end component double_sync_vector;
	
	-- number of SPI BURSTS per loop -> 2 burts per measure for 16 temperature reading phases + 2 DAC setting phases 
	--constant SPI_BURSTS  : integer := 34;
	--constant DIV_RATIO   : integer := CLK_RATE / (Meas_Rate * SPI_BURSTS);
	constant DIV_RATIO   : integer := CLK_RATE / Meas_Rate;			--servo clock computation
	constant STAB_RATIO	 : integer := CLK_RATE / 3180;				--filter cut off freq = 15.9KHz (5tau stab delay)
	
	-- components declaration 
	
	-- clock divider instantiation for temperature measure loop freq
	component clk_divider_pulse is
		generic(
			FACTOR : integer);
		port(
			CLOCK     : in  std_logic;
			RESET     : in  std_logic;
			PULSE     : out std_logic);
	end component clk_divider_pulse;  
	
	-- Pulse generator for analog filter stabilisation 
	component Pulse_gen is
		Generic (	
			Delay:		integer;		-- Delay before pulse generation
			Duration:	integer;		-- Pulse width
			Polarity:	boolean);		-- Pulse Polarity  
		Port (		
			Clock:		in STD_LOGIC;		-- Clock signal
			Reset:		in STD_LOGIC;		-- Resets all counters (Active High)
			Trigger:	in STD_LOGIC;	-- Reference signal (input)
			Pulse:		out STD_LOGIC);		-- Generated pulse (output)
	end component Pulse_gen;
	
	-- constant declarations
	constant DAC_A_SEL : std_logic := '0';
	constant DAC_B_SEL : std_logic := '1';
	
	constant CS_ADC_N : std_logic_vector((NB_SLAVES -1) downto 0) := "10";
	constant CS_DAC_N : std_logic_vector((NB_SLAVES -1) downto 0) := "01";
	
	type state is 
	(IDLE, MUX_SET, WAIT_STABLE, ADC_STB, ADC_GET, DTA_VALID, DAC_A_STB, DAC_A_SET, DAC_B_STB, DAC_B_SET);
	
	type MUX_select_SM_type is (Measure_0, Measure_1, Measure_2, Measure_3, Measure_4, Measure_5, Measure_6, Measure_7, Measure_8, Measure_9, Measure_10, Measure_11, Measure_12, Measure_13, Measure_14, Measure_15);
	
	-- signal declarations 
	
	signal MUX_select_SM : MUX_select_SM_type;
	
	signal Servo_1 	  : std_logic;	-- indicates the first servo loop should be adressed
	signal Servo_2 	  : std_logic;  -- indicates the second servo loop should be adressed	
	signal mux_rdy	  : std_logic;	-- indicates the mux address is ready
	
	signal cs_ctrl    : state;	-- current state 
	signal ns_ctrl    : state;	-- next state
	signal rst_sync   : std_logic;
	signal adc_data   : std_logic_vector(15 downto 0);
	signal dac_a_word : std_logic_vector(23 downto 0);
	signal dac_b_word : std_logic_vector(23 downto 0);
	signal pulse      : std_logic; 	
	signal start_stab : std_logic; 
	signal stab_pulse : std_logic;
	
	signal M0 : std_logic_vector(15 downto 0);	-- NTC measure zone 1 (for servo loop)
	signal M0_c : std_logic_vector(15 downto 0);
	signal M1 : std_logic_vector(15 downto 0);	-- NTC measure zone 2 (for servo loop)
	signal M1_c : std_logic_vector(15 downto 0);
	signal M2 : std_logic_vector(15 downto 0);	-- NTC measure (for Mon Instamb)
	signal M2_c : std_logic_vector(15 downto 0);
	signal M3 : std_logic_vector(15 downto 0);	-- NTC measure (for Mon zone 1)
	signal M3_c : std_logic_vector(15 downto 0);
	signal M4 : std_logic_vector(15 downto 0); 	-- NTC measure (for Mon zone 2)
	signal M4_c : std_logic_vector(15 downto 0);
	signal M5 : std_logic_vector(15 downto 0);	-- NTC measure (for Mon Intlens)
	signal M5_c : std_logic_vector(15 downto 0);
	signal M6 : std_logic_vector(15 downto 0);	-- NTC measure (for Mon Wind)
	signal M6_c : std_logic_vector(15 downto 0);
	signal M7 : std_logic_vector(15 downto 0);	-- NTC measure (for Mon Lens)
	signal M7_c : std_logic_vector(15 downto 0);
	signal M8 : std_logic_vector(15 downto 0);	-- NTC measure (for Mon Amb)
	signal M8_c : std_logic_vector(15 downto 0);
	signal M9 : std_logic_vector(15 downto 0); 	-- NTC measure (for Mon CF)	
	signal M9_c : std_logic_vector(15 downto 0);
	signal M10 : std_logic_vector(15 downto 0);	-- NTC measure (for Mon Cmp)
	signal M10_c : std_logic_vector(15 downto 0);	
	signal M11 : std_logic_vector(15 downto 0);	-- NTC measure (for Mon Beamspl)
	signal M11_c : std_logic_vector(15 downto 0);
	signal M12 : std_logic_vector(15 downto 0);	-- Current measure in zone 1 (for overcurrent check)
	signal M12_c : std_logic_vector(15 downto 0);
	signal M13 : std_logic_vector(15 downto 0);	-- Current measure in zone 2 (for overcurrent check)
	signal M13_c : std_logic_vector(15 downto 0);
	signal M14 : std_logic_vector(15 downto 0); -- Diode Voltage measure (option)
	signal M14_c : std_logic_vector(15 downto 0);
	signal M15 : std_logic_vector(15 downto 0);	-- Reference volatge measure (1.225V)
	signal M15_c : std_logic_vector(15 downto 0);
	
	signal ADC_meas : integer range 0 to 15 := 0;  
	signal A_sync : std_logic_vector(3 downto 0);	 -- synchronised address bus
	
	signal Current_control : std_logic_vector(15 downto 0); -- register to store overcurrent information for the PIC
	
begin 
	-- clock divider instantiation for temperature servo loop freq
	clk_div_inst : clk_divider_pulse
	generic map(
		FACTOR => DIV_RATIO)
	port map(
		CLOCK => CLK,
		RESET => RST,
		PULSE => pulse); 
	
	-- Pulse generator for analog filter stabilisation 
	stab_delay : Pulse_gen
	generic map(	
		Delay => STAB_RATIO,		-- Delay before pulse generation
		Duration => 1,				-- Pulse width
		Polarity => true)			-- Pulse Polarity  
	port map(		
		Clock => CLK,				-- Clock signal
		Reset => RST,				-- Resets all counters (Active High)
		Trigger => start_stab,		-- Reference signal (input)
		Pulse => stab_pulse);		-- Generated pulse (output)

	-- clock divider for SPI clock
	scl2xsrc_proc : process (clk)
		variable count : std_logic_vector(SCL_RATIO_BIT-2 downto 0);
	begin
		if (CLK'event and CLK = '1') then
			if (rst_sync = '1') then
				count := (others => '0');
			else
				count := count + 1;
			end if;
			SCL2XSRC <= count(SCL_RATIO_BIT-2);
		end if;
	end process scl2xsrc_proc; 
	
	-- double sync for vector instantiations
	data_double_sync_vect_inst : double_sync_vector
	port map(
		D => A,
		Q  => A_sync,
		CLK  => CLK );
	
	-- hardwire SPI polarity bits
	SPI_CPOL <= '0';
	SPI_CPHA <= '0';
	
	-- map the appropriate spi interface 16 output bits to adc_dat
	-- see data sheet (ADS8320) p.10 
	adc_data <= SPI_DIN(17 downto 2);
	
	-- map the appropriate DAC data to 24 bit dac_a_word for SPI transfer
	-- command bits are always set to "0011" which means write to and update (power up)n
	-- power down never occurs in this version!
	dac_a_word <= "0011000" & DAC_A_SEL & DAC_A_VAL;
	dac_b_word <= "0011000" & DAC_B_SEL & DAC_B_VAL;
	
	-- direct register for ADC Value
	adc_reg_proc : process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			if rst_sync = '1' then 
				ADC_VAL <= x"0000";
				M0 <= x"BBBB";
				M1 <= x"CCCC";
				M2 <= x"0002";
				M3 <= x"0003";
				M4 <= x"0004";
				M5 <= x"0005";
				M6 <= x"0006";
				M7 <= x"0007";
				M8 <= x"0008";
				M9 <= x"0009";
				M10 <= x"000a";
				M11 <= x"000b";
				M12 <= x"0000";
				M13 <= x"0000";
				M14 <= x"000e";
				M15 <= x"000f";											
			elsif (cs_ctrl = ADC_GET and SPI_DNE = '1') then    	--adc data received
				ADC_VAL <= adc_data;				
				case ADC_meas is
					when 0 => M0 <= adc_data;
					when 1 => M1 <= adc_data;
					when 2 => M2 <= adc_data;
					when 3 => M3 <= adc_data;
					when 4 => M4 <= adc_data;
					when 5 => M5 <= adc_data;
					when 6 => M6 <= adc_data;
					when 7 => M7 <= adc_data;
					when 8 => M8 <= adc_data;
					when 9 => M9 <= adc_data;
					when 10 => M10 <= adc_data;
					when 11 => M11 <= adc_data;
					when 12 => M12 <= adc_data;
					when 13 => M13 <= adc_data;	
					when 14 => M14 <= adc_data;
					when 15 => M15 <= adc_data;
				end case;
				
			end if;
		end if;
	end process adc_reg_proc;
	
	-- synchronous part of state machine for reading ADC values
	sync_sm_proc : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (rst_sync = '1') then
				cs_ctrl <= IDLE;
			else
				cs_ctrl <= ns_ctrl;
			end if;
		end if;  
	end process sync_sm_proc;
	
	-- Mux channel select state machine
	mux_select_proc : process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			if rst_sync = '1' then 
				ADR <= x"F";
				MUX_select_SM <= Measure_0;
				ADC_Meas <= 0;
				Servo_1 <= '0';
				Servo_2 <= '0';
			elsif mux_rdy = '1' then		
				case MUX_select_SM is
					when Measure_0 =>
						ADR <= x"0";
						--Servo_1 <= '1';
						MUX_select_SM <= Measure_1;
						ADC_meas <= 0; 
						
					when Measure_1 =>
						ADR <= x"1";
						--Servo_2 <= '1';	
						--Servo_1 <= '0';
						MUX_select_SM <= Measure_2;
						ADC_meas <= 1;
						
					when Measure_2 =>
						ADR <= x"2"; 
						MUX_select_SM <= Measure_3;
						ADC_meas <= 2; 
						--Servo_2 <= '0';
						
					when Measure_3 => 			--Servo1 et MonZone1 meme thermistor 
						ADR <= x"3";   
						Servo_1 <= '1';
						MUX_select_SM <= Measure_4;
						ADC_meas <= 3;
						
					when Measure_4 =>     		--Servo2 et MonZone2 meme thermistor
						ADR <= x"4"; 
						Servo_2 <= '1';	
						Servo_1 <= '0';
						MUX_select_SM <= Measure_5;
						ADC_meas <= 4;
						
					when Measure_5 =>
						ADR <= x"5";
						MUX_select_SM <= Measure_6;
						ADC_meas <= 5;	
						Servo_2 <= '0';
						
					when Measure_6 =>
						ADR <= x"6";
						MUX_select_SM <= Measure_7;
						ADC_meas <= 6;
						
					when Measure_7 =>
						ADR <= x"7";
						MUX_select_SM <= Measure_8;
						ADC_meas <= 7;
						
					when Measure_8 =>
						ADR <= x"8";
						MUX_select_SM <= Measure_9;
						ADC_meas <= 8;
						
					when Measure_9 =>
						ADR <= x"9";
						MUX_select_SM <= Measure_10;
						ADC_meas <= 9;	
						
					when Measure_10 =>
						ADR <= x"A";
						MUX_select_SM <= Measure_11;
						ADC_meas <= 10;
						
					when Measure_11 =>
						ADR <= x"B";
						MUX_select_SM <= Measure_12;
						ADC_meas <= 11;
						
					when Measure_12 =>
						ADR <= x"C";
						MUX_select_SM <= Measure_13;
						ADC_meas <= 12;
						
					when Measure_13 =>
						ADR <= x"D";
						MUX_select_SM <= Measure_14;
						ADC_meas <= 13;
						
					when Measure_14 =>
						ADR <= x"E";
						MUX_select_SM <= Measure_15;
						ADC_meas <= 14;
						
					when Measure_15 =>
						ADR <= x"F";
						MUX_select_SM <= Measure_0;
						ADC_meas <= 15;					
				end case;
			end if;
		end if;
	end process;
	
	--Feedback Temperatures to PIC
	
	-- When the ADC is reading and requested by PIC at the same time,
	-- the last value is saved in temporary register before sending
	process (CLK)		
		variable MX_tmp : std_logic_vector(15 downto 0); 	-- register to save the
															-- last value of before reading the ADC again
		variable MX_update : std_logic;						-- indicates if the
															-- temporary register MX_tmp is updated			
	begin
		if (CLK'event and CLK = '1') then
			if rst_sync = '1' then 
				DATA <= x"aaaa";
				MX_tmp := x"0000";
				MX_update := '0';
			else 
				case A_sync is
					when x"0" => 
						if ADC_meas = 0  then 				--ADC_meas is updated when MUX is selected
							if cs_ctrl = ADC_GET then 		--ADC is currently read by FPGA 
								DATA <= M0_c;				--Send last copy
							else
								DATA <= M0;
							end if;
						else 
							DATA <= M0;
						end if;
						
					when x"1" => 
						if ADC_meas = 1  then 
							if cs_ctrl = ADC_GET then 
								DATA <= M1_c;				--Send last copy
							else
								DATA <= M1;
							end if;	
						else
							DATA <= M1;
						end if;
						
					when x"2" => 
						if ADC_meas = 2  then 
							if cs_ctrl = ADC_GET then
								DATA <= M2_c;				--Send last copy
							else
								DATA <= M2;
							end if;
						else
							DATA <= M2;
						end if;
						
					when x"3" =>
						if ADC_meas = 3  then 
							if cs_ctrl = ADC_GET then
								DATA <= M3_c;				--Send last copy
							else
								DATA <= M3;
							end if;
						else
							DATA <= M3;
						end if;
						
					when x"4" => 
						if ADC_meas = 4  then 
							if cs_ctrl = ADC_GET then 
								DATA <= M4_c;				--Send last copy
							else
								DATA <= M4;
							end if;
						else
							DATA <= M4;
						end if;
						
					when x"5" =>
						if ADC_meas = 5  then 
							if cs_ctrl = ADC_GET then 
								DATA <= M5_c;				--Send last copy
							else
								DATA <= M5;
							end if;
						else
							DATA <= M5;
						end if;
						
					when x"6" =>
						if ADC_meas = 6  then 
							if cs_ctrl = ADC_GET then
								DATA <= M6_c;				--Send last copy
							else
								DATA <= M6;
							end if;
						else
							DATA <= M6;
						end if;
						
					when x"7" =>
						if ADC_meas = 7  then 
							if cs_ctrl = ADC_GET then
								DATA <= M7_c;				--Send last copy
							else
								DATA <= M7;
							end if;
						else
							DATA <= M7;
						end if;
						
					when x"8" =>
						if ADC_meas = 8  then 
							if cs_ctrl = ADC_GET then
								DATA <= M8_c;				--Send last copy
							else
								DATA <= M8;
							end if;
						else
							DATA <= M8;
						end if;
						
					when x"9" =>
						if ADC_meas = 9  then 
							if cs_ctrl = ADC_GET then
								DATA <= M9_c;				--Send last copy
							else
								DATA <= M9;
							end if;
						else
							DATA <= M9;
						end if;
						
					when x"A" =>
						if ADC_meas = 10  then 
							if cs_ctrl = ADC_GET then
								DATA <= M10_c;				--Send last copy
							else
								DATA <= M10;
							end if;
						else
							DATA <= M10;
						end if;
						
					when x"B" =>
						if ADC_meas = 11  then 
							if cs_ctrl = ADC_GET then
								DATA <= M11_c;				--Send last copy
							else
								DATA <= M11;
							end if;
						else
							DATA <= M11;
						end if;
						
					when x"C" =>
						if ADC_meas = 12  then 
							if cs_ctrl = ADC_GET then
								DATA <= M12_c;				--Send last copy
							else
								DATA <= M12;
							end if;
						else
							DATA <= M12;
						end if;
						
					when x"D" =>
						if ADC_meas = 13  then 
							if cs_ctrl = ADC_GET then
								DATA <= M13_c;				--Send last copy
							else
								DATA <= M13;
							end if;
						else
							DATA <= M13;
						end if;
						
					when x"E" => 
						if ADC_meas = 14  then 
							if cs_ctrl = ADC_GET then
								DATA <= M14_c;				--Send last copy
							else
								DATA <= M14;
							end if;
						else
							DATA <= M14;
						end if;
						
					when x"F" =>
						if ADC_meas = 15  then 
							if cs_ctrl = ADC_GET then
								DATA <= M15_c;				--Send last copy
							else
								DATA <= M15;
							end if;
						else
							DATA <= M15;
						end if;
						
					when others =>
				end case;
				
			end if;
		end if;
	end process;
	
	
	-- combinational part of state machine for peripherals communication
	comb_sm_proc : process (cs_ctrl, pulse, stab_pulse, SPI_DNE)
	begin
		case cs_ctrl is			
			when IDLE  =>
				if (pulse = '1') then
					ns_ctrl <= MUX_SET;
				else
					ns_ctrl <= IDLE;
				end if;
				
			when MUX_SET =>
				ns_ctrl <= WAIT_STABLE;
				
			--when MUX_SET =>
--				--if (SPI_DNE = '1') then
--					ns_ctrl <= WAIT_STABLE;
--				--else
--					--ns_ctrl <= MUX_SET;
--				--end if;
				
			when WAIT_STABLE =>
				if (stab_pulse = '1') then
					ns_ctrl <= ADC_STB;
				else
					ns_ctrl <= WAIT_STABLE;
				end if;
				
			when ADC_STB =>
				ns_ctrl <= ADC_GET;
				
			when ADC_GET =>
				if (SPI_DNE = '1') then
					ns_ctrl <= DTA_VALID;
				else
					ns_ctrl <= ADC_GET;
				end if;
				
			when DTA_VALID =>
				if ADC_meas = 15 then
					ns_ctrl <= DAC_A_STB;
				else
					ns_ctrl <= MUX_SET;
				end if;
				
					--if Servo_1 = '1' then
--						ns_ctrl <= DAC_A_STB;
--					elsif Servo_2 = '1'then 
--						ns_ctrl <= DAC_B_STB;
--					else
--						ns_ctrl <= MUX_SET;
--					end if ; 

			when DAC_A_STB =>    					--Strobe write to Heater DAC A
				ns_ctrl <= DAC_A_SET;
				
			when DAC_A_SET =>            	
				if (SPI_DNE = '1') then
					ns_ctrl <= DAC_B_STB;
				else
					ns_ctrl <= DAC_A_SET;
				end if;
				
			when DAC_B_STB =>                    	--Strobe write to Heater DAC B
				ns_ctrl <= DAC_B_SET;
				
			when DAC_B_SET =>
			if (SPI_DNE = '1') then
				ns_ctrl <= IDLE;
			else
				ns_ctrl <= DAC_B_SET;
			end if;
		end case;
		
	end process comb_sm_proc;
	
	-- registered outputs state machine for peripherals communication
	out_sm_proc : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (rst_sync = '1') then
				ADC_A_DVAL   <= '0';
				ADC_B_DVAL   <= '0';
				SPI_STB    <= '0';
				SPI_DOUT    <= x"000000";
				SPI_NBITS  <= "01000";
				SPI_EN_SSn <= "11";	
				start_stab <= '0';
				mux_rdy <= '0';
			else
				case ns_ctrl is
					when IDLE =>
						ADC_A_DVAL   <= '0';
						ADC_B_DVAL   <= '0';
						SPI_STB    <= '0';
						SPI_DOUT    <= x"000000";
						SPI_NBITS  <= "01000";
						SPI_EN_SSn <= "11";
						
					when MUX_SET =>
						mux_rdy <= '1';
						start_stab <= '1';
											
					when WAIT_STABLE =>
						mux_rdy <= '0';
						start_stab <= '0';
						
					when ADC_STB =>
						SPI_STB    <= '1';
						SPI_NBITS  <= "11000";
						SPI_EN_SSn <= CS_ADC_N;
						M0_c <= M0;      			--Save a copy of temperatures before update
						M1_c <= M1;
						M2_c <= M2;
						M3_c <= M3;
						M4_c <= M4;
						M5_c <= M5;
						M6_c <= M6;
						M7_c <= M7;
						M8_c <= M8;
						M9_c <= M9;
						M10_c <= M10;
						M11_c <= M11;
						M12_c <= M12;
						M13_c <= M13;
						M14_c <= M14;
						M15_c <= M15;
						
					when ADC_GET =>
						SPI_STB    <= '0';
						SPI_NBITS  <= "11000";
						SPI_EN_SSn <= CS_ADC_N;
						
					when DTA_VALID => 
						if Servo_1 = '1' then
							ADC_A_DVAL   <= '1';
							ADC_B_DVAL   <= '0';
						elsif Servo_2 = '1' then 
							ADC_A_DVAL   <= '0';
							ADC_B_DVAL   <= '1';
						end if; 
						SPI_EN_SSn <= "11";	 
						
					when DAC_A_STB =>    				--Initiate Write to SPI master register
						ADC_A_DVAL   <= '0';
						ADC_B_DVAL   <= '0';
						SPI_STB    <= '1';
						SPI_DOUT    <= dac_a_word;
						SPI_NBITS  <= "11000";
						SPI_EN_SSn <= CS_DAC_N;
						
					when DAC_A_SET =>    				--Wait state until SPI writing finished
						SPI_STB    <= '0';
						
					when DAC_B_STB =>
						ADC_A_DVAL   <= '0';
						ADC_B_DVAL   <= '0';
						SPI_STB    <= '1';
						SPI_DOUT    <= dac_b_word;
						SPI_NBITS  <= "11000";
						SPI_EN_SSn <= CS_DAC_N;
						
					when DAC_B_SET =>
						SPI_STB    <= '0';
					
				end case;
			end if;
		end if;
	end process out_sm_proc;
	
	
	-- overcurrent measure process
	-- if the current measured on the channel 12 or channel 13 of the multiplexer
	-- is superior than I1_max (I2_max)
	-- an error is generated and a flag is up in current control register
	overcurrent_proc : process(CLK)		
	begin  
		if rising_edge(CLK) then
			if rst_sync = '1' then
				Error_1 <= '0';
				Error_2 <= '0';
				Current_control <= x"0000";
			else
				If M12 > I1_max then
						Error_1 <= '1';
						Current_control(0) <= '1';
				end if;	
				If M13 > I2_max then
						Error_2 <= '1';
						Current_control(1) <= '1';
				end if;	
			end if;
		end if;	
	end process overcurrent_proc;
	
	-- Potentially asynchronous reset local double buffering
	rst_dbuf : process(CLK)
		variable rst_hist : std_logic_vector(1 downto 0);
	begin
		if (CLK'event and CLK = '1') then
			rst_hist(1) := rst_hist(0);
			rst_hist(0) := To_X01(RST);
			rst_sync <= rst_hist(1);
		end if;
	end process rst_dbuf;
	
end rtl;
