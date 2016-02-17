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
--
---------------------------------------------------------------------------------------------------
--
-- Title       : Reader
-- Design      : Aurora
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\GBHSI\Aurora\src\Reader.vhd
-- Generated   : Wed Mar  3 09:02:31 2004
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Reader is
	port (
		--------------------------------
		-- Aurora IO
		--------------------------------	
		Rx_Src_Rdy_N 	: in 	std_logic; -- Message is being received
		Rx_D				: in 	std_logic_vector(0 to 23);
		Rx_Eof_N 		: in 	std_logic;
		Rx_Sof_N 		: in 	std_logic;
		Rx_Rem 			: in 	std_logic_vector(0 to 1);
		Channel_UP		: in 	std_logic;
		NFC_ACK_N 		: in 	std_logic;
		NFC_REQ_N 		: out std_logic;
		NFC_NB 			: out std_logic_vector(0 to 3);
		--------------------------------
		-- User IO
		--------------------------------
		D_OUT 			: out std_logic_vector(15 downto 0);
		D_VALID			: out std_logic;
		EN					: in	std_logic;
		SOF_N				: out std_logic;
		EOF_N				: out std_logic;
		--------------------------------
		-- Other IOs
		--------------------------------	
		CLK 				: in 	std_logic;		-- System Clock
		RESET 			: in 	std_logic	-- External push-button SW2
		);
end Reader;

architecture Untested of Reader is																	
	
	signal Counter : integer range 0 to 255;		-- Counts the received Word
	signal Rst_Count : integer range 0 to 7;
	constant XOFF : std_logic_vector(0 to 3) := "1111";
	constant XON : std_logic_vector(0 to 3) := "0000";
	
	
begin
	
	Output_data_control : process (RESET, CLK)
	begin									
		if rising_edge(CLK) then
			if (RESET = '1') then
				D_OUT <= (others => '0');
				D_VALID <= '0';
				SOF_N <= '1';
				EOF_N <= '1';
			else
				-- Data buffering
				D_OUT <= Rx_D(8 to 23);
				SOF_N <= Rx_Sof_N;
				EOF_N <= Rx_Eof_N;
				-- Flow control for FIFO
				if (Rx_Src_Rdy_N = '0' and Channel_UP = '1') then
					D_VALID <= '1';
				else					
					D_VALID <= '0';
				end if;						
			end if; 
		end if;
	end process;
	
	NFC_machine : entity work.Aurora_NFC
	port map (
		CHANNEL_UP 	=> CHANNEL_UP,
		CLK 			=> CLK,
		EN				=> EN,
		NFC_ACK_N	=> NFC_ACK_N,
		RESET			=> RESET,
		NFC_NB		=> NFC_NB,
		NFC_REQ_N	=> NFC_REQ_N);
	
end Untested;
