-------------------------------------------------------------------------------
--
-- Title       : LL_file_output_32
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

library Common_HDL;
use Common_HDL.Telops.all;
use Common_HDL.telops_testing.all;

entity LL_file_output_32 is
   generic(
      FORMAT : string := "BINARY");	-- ASCII, BINARY or BINARY_LE (little endian)
   port(                   
      FILENAME    : string(1 to 255);
      RX_MOSI     : in  t_ll_mosi32;
      RX_MISO     : out t_ll_miso;    
      RESET       : in std_logic; 
      CLK         : in STD_LOGIC
      );
end LL_file_output_32;

architecture SIM of LL_file_output_32 is
   
   file OUTFILE_TEXT : TEXT;  
   file OUTFILE_BIN : BINARY;  
   signal read_again_next_time : std_logic;
   
begin     
   
   RX_MISO.AFULL <= '0';            
   RX_MISO.BUSY <= '0';
   
   MAIN_PROC: process(CLK, RESET)           
      
      variable OUT_LINE : LINE;  		-- pointer to string 
      variable data : INTEGER;
      variable end_of_line : boolean := true;
      variable start_of_line : boolean := true;  
      variable file_opened : boolean := false;
      
   begin         
      if RESET = '1' then         
         read_again_next_time <= '0';
         if file_opened then
            if (FORMAT = "ASCII") then
               FILE_CLOSE(OUTFILE_TEXT);
            elsif (FORMAT = "BINARY") then
               FILE_CLOSE(OUTFILE_BIN);
            else
               FILE_CLOSE(OUTFILE_BIN);
            end if;
            file_opened := false;
         end if;
      elsif rising_edge(CLK) and RX_MOSI.DVAL = '1' then        
         
         ---------------------------------
         -- Open the file
         --------------------------------- 
         if not file_opened then
            if (FORMAT = "ASCII") then
               FILE_OPEN(OUTFILE_TEXT, filename, WRITE_MODE);
            else
               FILE_OPEN(OUTFILE_BIN, filename, WRITE_MODE);
            end if;   
            file_opened := true;
            end_of_line := true;
         end if;  
         
         --         if Signed_Data then
         --            data := to_integer(signed(RX_MOSI.DATA));
         --         else
         --            data := to_integer(unsigned(RX_MOSI.DATA));
         --         end if;
         
         if (FORMAT = "ASCII") then
            write(OUT_LINE,to_integer(unsigned(RX_MOSI.DATA)));         
            if RX_MOSI.EOF = '1' then
               writeline(OUTFILE_TEXT,OUT_LINE);	-- write line to a file      
            else
               write(OUT_LINE," ");
            end if;
         elsif (FORMAT = "BINARY") then
            write(OUTFILE_BIN, RX_MOSI.DATA(23 downto 16)); -- Pixel A lsb
            write(OUTFILE_BIN, RX_MOSI.DATA(31 downto 24)); -- Pixel A msb
            write(OUTFILE_BIN, RX_MOSI.DATA(7 downto 0));   -- Pixel B lsb
            write(OUTFILE_BIN, RX_MOSI.DATA(15 downto 8));  -- Pixel B msb
	      elsif (FORMAT = "BINARY_LE") then
            write(OUTFILE_BIN, RX_MOSI.DATA(7 downto 0));   
            write(OUTFILE_BIN, RX_MOSI.DATA(15 downto 8));             
            write(OUTFILE_BIN, RX_MOSI.DATA(23 downto 16)); 
            write(OUTFILE_BIN, RX_MOSI.DATA(31 downto 24));  
         end if;         
      end if;  
   end process;   
   
end SIM;
