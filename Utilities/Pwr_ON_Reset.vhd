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

--  Destination: General VHDL code
--
--
--  Title   : Power ON Reset
--
--  File    : Pwr_ON_Reset
--  By      : Jean-Pierre Allard
--  Date    : 26 octobre 2004
--
--******************************************************************************
--Description
--******************************************************************************
-- This Entity makes sure that the Reset will occur at the FPGA power-up.
--
--
--******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Pwr_ON_Rst is
	generic (
		DELAY_ON : boolean := FALSE);
	port (
		CLK : in std_logic;				-- System Clock
		IN_RESET_N : in std_logic;		-- Active LOW  - Directly from the input pin
		OUT_RESET_N : out std_logic	-- Active LOW - Circuit Reset (with a power-on pulse)
		);
end Pwr_ON_Rst;

architecture RTU of Pwr_ON_Rst is
	
	signal Reset_sr : std_logic_vector(1 downto 0) := "00"; -- for initial reset at bootup
	signal Reset_n_s : std_logic;
	constant Cnt_width : integer := 16;
	
begin
	
	Reset_Reg : process(CLK)
	begin
		if rising_edge(CLK) then
			Reset_sr <= Reset_sr(0) & IN_RESET_N;
			Reset_n_s <= Reset_sr(0) and Reset_sr(1);
		end if;
	end process;
	
	Delay_Disable : if not DELAY_ON generate
		
		OUT_RESET_N <= Reset_n_s;
		
	end generate;
	
	Delay_Enable : if DELAY_ON generate
		
		Reset_Delay : process(CLK)
			variable Count : unsigned(Cnt_width-1 downto 0) := to_unsigned(0,Cnt_width);
		begin
			if rising_edge(CLK) then
				if Reset_sr(0) = '1' and Reset_sr(1) = '1' then
        -- synopsys translate_off
		  OUT_RESET_N <= '1';
		  -- synopsys translate_on
					
					if Count = to_unsigned(0,Cnt_width) then
						OUT_RESET_N <= '1';
					else
						if Count = (Cnt_width-1 downto 0 => '1') then
							Count := to_unsigned(0,Cnt_width);
						else
							Count := Count + 1;
						end if;
					end if;
				else
					Count := to_unsigned(1,Cnt_width);
					OUT_RESET_N <= '0';
				end if;
			end if;
		end process;
		
	end generate;
	
end RTU;