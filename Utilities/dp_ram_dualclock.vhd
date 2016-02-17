-------------------------------------------------------------------------------
--
-- Title       : dp_ram_dualclock
-- Author      : Benjamin Couillard
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Dual-port ram avec 2 clocks indépendantes
--               Selon le XST user guide.
--
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;	


entity dp_ram_dualclock is
	 generic(
      D_WIDTH : integer := 16;
      A_WIDTH : integer := 8);
	port (
		clka : in std_logic;
		clkb : in std_logic;
		wea : in std_logic;
		addra : in std_logic_vector(A_WIDTH-1 downto 0);
		addrb : in std_logic_vector(A_WIDTH-1 downto 0);
		dia : in std_logic_vector(D_WIDTH-1 downto 0);
		dob : out std_logic_vector(D_WIDTH-1 downto 0));
end dp_ram_dualclock;

architecture RTL of dp_ram_dualclock is
	type ram_type is array (2**A_WIDTH-1 downto 0) of std_logic_vector (D_WIDTH-1  downto 0);
	signal ram : ram_type;
	attribute block_ram : boolean;
	attribute block_ram of RAM : signal is TRUE;
	
	signal u_addra : unsigned(addra'range);
	signal u_addrb : unsigned(addrb'range);

	
	begin
		
	u_addra <= unsigned(addra);
	u_addrb <= unsigned(addrb);
		
	write: process (clka)
	begin
		if (clka'event and clka = '1') then
			if (wea = '1') then
				ram(to_integer(u_addra)) <= dia;
			end if;
		end if;
	end process write;
	
	read: process (clkb)
		begin
			if (clkb'event and clkb = '1') then
				dob <= ram(to_integer(u_addrb));
			end if;
	end process read;


end RTL;