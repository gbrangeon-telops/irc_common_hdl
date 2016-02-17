-------------------------------------------------------------------------------
--
-- Title       : LL_file_output
-- Author      : Patrick Dubois
-- Company     : Telops
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Description : This module takes a LocalLink input and saves the content to
--               an output file. The resulting file can then be analyzed by
--               the Matlab function vhdl2mat.m
-- Auther      : KBE
-- Date        : 05/2010

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

entity LL_file_output is
   generic(
      C_DLEN      : integer :=32;
      C_FORMAT      : string := "BINARY");	-- ASCII, BINARY or BINARY_LE (little endian)
   port(
      FILENAME    : string(1 to 255);
      RX_MOSI     : in  t_ll_mosi32;
      RX_MISO     : out t_ll_miso;
      RESET       : in std_logic;
      CLK         : in STD_LOGIC
      );
end LL_file_output;

architecture SIM of LL_file_output is

   signal FoundGenCase : boolean := FALSE;    

begin

   RX_MISO.AFULL <= '0';
   RX_MISO.BUSY <= '0';

   ------------------------------------------------------
   -- Conditional code for ASCII input file support
   ------------------------------------------------------
   Ascii_gen: if C_FORMAT = "ASCII" generate

   file OUTFILE_TEXT : TEXT;

   begin
      MAIN_PROC: process(CLK, RESET)

         variable OUT_LINE : LINE;  		-- pointer to string
         variable data : INTEGER;
         variable end_of_line : boolean := true;
         variable file_opened : boolean := false; 
         variable File_Status : FILE_OPEN_STATUS;

      begin
         if RESET = '1' then
            if file_opened then
               FILE_CLOSE(OUTFILE_TEXT);
            end if;
            file_opened := false;
         elsif rising_edge(CLK) and RX_MOSI.DVAL = '1' then

            ---------------------------------
            -- Open the file
            ---------------------------------
            if not file_opened then
               FILE_OPEN(File_Status, OUTFILE_TEXT, filename, WRITE_MODE);
               assert (File_Status = OPEN_OK) report "Error opening file" severity FAILURE;
               file_opened := true;
               end_of_line := true;
            end if;

            --         if Signed_Data then
            --            data := to_integer(signed(RX_MOSI.DATA));
            --         else
            --            data := to_integer(unsigned(RX_MOSI.DATA));
            --         end if;

            write(OUT_LINE,to_integer(unsigned(RX_MOSI.DATA)));
            if RX_MOSI.EOF = '1' then
               writeline(OUTFILE_TEXT,OUT_LINE);	-- write line to a file
            else
               write(OUT_LINE," ");
            end if;
         end if;
      end process;
      ----
      FoundGenCase <= true;
   end generate Ascii_gen;

   ------------------------------------------------------
   -- Conditional code for BINARY input file support
   ------------------------------------------------------
   Bin_gen: if (C_FORMAT = "BINARY" and (C_DLEN mod(8))=0)generate

   file OUTFILE_BIN : BINARY;

   begin
   MAIN_PROC: process(CLK, RESET)

         variable OUT_LINE : LINE;  		-- pointer to string
         variable data : INTEGER;
         variable end_of_line : boolean := true;
         variable file_opened : boolean := false;
         variable File_Status : FILE_OPEN_STATUS;

      begin
         if RESET = '1' then
            if file_opened then
               FILE_CLOSE(OUTFILE_BIN);
               file_opened := false;
            end if;
         elsif rising_edge(CLK) and RX_MOSI.DVAL = '1' then

            ---------------------------------
            -- Open the file
            ---------------------------------
            if not file_opened then
               FILE_OPEN(File_Status, OUTFILE_BIN, filename, WRITE_MODE);  
               assert (File_Status = OPEN_OK) report "Error opening file" severity FAILURE;
               file_opened := true;
               end_of_line := true;
            end if;

            --         if Signed_Data then
            --            data := to_integer(signed(RX_MOSI.DATA));
            --         else
            --            data := to_integer(unsigned(RX_MOSI.DATA));
            --         end if;

	            for byte_index in 0 to (C_DLEN/8)-1 loop
	               write(OUTFILE_BIN, RX_MOSI.DATA(byte_index*8+7 downto byte_index*8));
	            end loop;

         end if;
      end process;
      -----
      FoundGenCase <= true;
   end generate Bin_gen;

   process (CLK)
   begin
      if rising_edge(CLK) then
            assert (FoundGenCase) report "Parameter C_DLEN sould be a multiple of 8 to use BINARY output file format" severity FAILURE;
        end if;
   end process;


end SIM;
