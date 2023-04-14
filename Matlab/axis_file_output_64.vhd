-------------------------------------------------------------------------------
--
-- Title       : LL_file_output_64
-- Author      : Patrick Dubois
-- Company     : Telops
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Description : This module takes a LocalLink input and saves the content to
--               an output file. The resulting file can then be analyzed by
--               the Matlab function vhdl2mat.m
--
--
-- 2009-10-23  : Signed Data Generic not supported anymore (problem)
--   by PDA    : Generic Format Added (BINARY or ASCII).
--             : In ASCII mode, the data is converted in integer
--             : In BINARY mode, the data is sent byte by byte in hex (little endian)
-------------------------------------------------------------------------------


library IEEE;
library STD;
use IEEE.STD_LOGIC_1164.all;         
use IEEE.numeric_std.ALL;
use IEEE.std_logic_textio.all;

library STD;
use STD.TEXTIO.all;


--library Common_HDL;
--use Common_HDL.Telops.all;
--use Common_HDL.telops_testing.all;
use work.tel2000.all;

entity AXIS_file_output_64 is
   port(                   
      FILENAME    : string(1 to 255);
      RX_MOSI     : in t_axi4_stream_mosi64;
      RX_MISO     : in t_axi4_stream_miso;    
      RESET       : in std_logic; 
      CLK         : in STD_LOGIC
      );
end AXIS_file_output_64;

architecture SIM of AXIS_file_output_64 is
   
   file OUTFILE_TEXT : TEXT;  
   signal data_valid :std_logic;
   
begin     
    
  data_valid <= RX_MISO.TREADY and RX_MOSI.TVALID;
  
  U1 : process(CLK) 
     variable OUT_LINE : LINE;  		-- pointer to string  
     variable data : INTEGER;
     variable file_opened : boolean := false;
     variable end_of_line : boolean := true;  
begin
	if RESET = '1' then 
		if file_opened then
			FILE_CLOSE(OUTFILE_TEXT);
		end if;
		file_opened := false;
	elsif rising_edge(CLK) and data_valid = '1'	then  
			  
		if not file_opened then
			FILE_OPEN(OUTFILE_TEXT, FILENAME, WRITE_MODE);
			file_opened := true;
			end_of_line := true;
		end if;
	
		write(OUT_LINE,to_integer(unsigned(RX_MOSI.TDATA(63 downto 48))));
		write(OUT_LINE,".");
		write(OUT_LINE,to_integer(unsigned(RX_MOSI.TDATA(47 downto 32)))); 
		write(OUT_LINE,".");
		write(OUT_LINE,to_integer(unsigned(RX_MOSI.TDATA(31 downto 16))));
		write(OUT_LINE,".");
		write(OUT_LINE,to_integer(unsigned(RX_MOSI.TDATA(15 downto 0)))); 
		write(OUT_LINE,".");
		
		if RX_MOSI.TLAST = '1' then
			writeline(OUTFILE_TEXT,OUT_LINE);	-- write line to a file 
		
--			if(RX_MOSI.TID(0) = '1') then
--				write(OUT_LINE,"End of header");
--				writeline(OUTFILE_TEXT,OUT_LINE);	-- write line to a file
--			else
--				write(OUT_LINE,"End of frame");
--				writeline(OUTFILE_TEXT,OUT_LINE);	-- write line to a file
--			end if;
--	
--		else
--			write(OUT_LINE," / ");
		end if;
	
	end if;

end process; 
  
end SIM;
