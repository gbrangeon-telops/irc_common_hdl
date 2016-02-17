-- -----------------------------------------
-- Simple PWM ! (and One-Bit DAC)
-- -----------------------------------------
-- http://www.alse-fr.com
-- B. Cuzeau
-- PDU comment: Code extracted from http://www.alse-fr.com/English/ApNote204189.pdf
-- Modif PDU:  Added Enable and CycleDone ports.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- -----------------------------------------
Entity PWM is
	-- -----------------------------------------
	Port ( Rst : In std_logic;
		Clk : In std_logic;
		En	: in std_logic;
		Din : In std_logic_vector (8 downto 0);
		Done : out std_logic;
		PWMout : Out std_logic );
end PWM;
-- -----------------------------------------
Architecture RTL_Accum of PWM is
	-- -----------------------------------------
	-- AKA "One-Bit DAC". Not suitable for motor control.
	-- can be used for audio signals synthesis for example,
	-- by driving a simple RC filter...
	signal Accum : unsigned (8 downto 0);
begin
	U1: process (Clk,Rst)
	begin
		if Rst='1' then
			Accum <= (others=>'0');
		elsif rising_edge(Clk) then
			Accum <= '0' & Accum(7 downto 0) + unsigned('0' & Din(7 downto 0));
		end if;
	end process U1;
	U2: PWMout <= Accum(8) or Din(8);
end RTL_Accum;
-- -----------------------------------------
Architecture RTL_Comparator of PWM is
	-- -----------------------------------------
	-- Simple PWM, counter + comparator solution.
	-- do NOT use without registering PWM_out !!!
	signal Cnt : unsigned (7 downto 0) := to_unsigned(0,8);
	signal PWMout_buf : std_logic;
begin
	
	U1: process (Clk,Rst)
	begin
		if Rst='1' then
			Cnt <= (others=>'0');
		elsif rising_edge(Clk) then
			if En = '1' then
				Cnt <= Cnt + 1;
				PWMout <= PWMout_buf;
				if Cnt = "11111111" then
					Done <= '1';
				else
					Done <= '0';
				end if;			 
			end if;
		end if;
	end process U1;
	
	U2: PWMout_buf <= '1' when unsigned(Din(7 downto 0)) >= Cnt or Din(8)='1'
	else '0';		
end RTL_Comparator;