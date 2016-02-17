-------------------------------------------------------------------------------
--
-- Title       : LL_file_output_8
-- Author      : Patrick Daraiche
-- Company     : Telops
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Description : This module takes a LocalLink input and saves the content to
--               an output file. The resulting file can then be analyzed by
--               the Matlab function vhdl2mat.m
--             : Support two Architectures. ASCII and BIN
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;         
use IEEE.numeric_std.ALL;

library STD;
use STD.TEXTIO.all;

library Common_HDL;
use Common_HDL.Telops.all;     
use Common_HDL.telops_testing.all;

entity LL_file_output_8 is
   generic(
      Signed_Data : boolean := false
      );
   port(                   
      FILENAME    : string(1 to 255);
      RX_MOSI     : in  t_ll_mosi8;
      RX_MISO     : out t_ll_miso;    
      RESET       : in std_logic; 
      CLK         : in STD_LOGIC
      );
end LL_file_output_8;

architecture ASCII of LL_file_output_8 is
   
   file OUTFILE : TEXT;
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
            FILE_CLOSE(OUTFILE);
            file_opened := false;
         end if;
      elsif rising_edge(CLK) and RX_MOSI.DVAL = '1' then        
         
         ---------------------------------
         -- Open the file
         --------------------------------- 
         if not file_opened then
            FILE_OPEN(OUTFILE, filename, WRITE_MODE); 
            file_opened := true;
            end_of_line := true;
         end if;  
         
         if Signed_Data then
            data := to_integer(signed(RX_MOSI.DATA));
         else
            data := to_integer(unsigned(RX_MOSI.DATA));
         end if;
         
         write(OUT_LINE,data);         
         
         if RX_MOSI.EOF = '1' then
            writeline(OUTFILE,OUT_LINE);	-- write line to a file      
         else
            write(OUT_LINE," ");
         end if;
      end if;  
   end process;   
   
end ASCII;

architecture BIN of LL_file_output_8 is
   
   file OUTFILE : BINARY;
   signal read_again_next_time : std_logic;
   
begin     
   
   RX_MISO.AFULL <= '0';            
   RX_MISO.BUSY <= '0';
   
   MAIN_PROC: process(CLK, RESET)           
      
      variable file_opened : boolean := false;
      
   begin         
      if RESET = '1' then         
         if file_opened then
            FILE_CLOSE(OUTFILE);
            file_opened := false;
         end if;
      elsif rising_edge(CLK) and RX_MOSI.DVAL = '1' then        
         
         ---------------------------------
         -- Open the file
         --------------------------------- 
         if not file_opened then
            FILE_OPEN(OUTFILE, filename, WRITE_MODE);
            file_opened := true;
         end if;  
         
         write(OUTFILE, RX_MOSI.DATA);
      end if;
   end process;   
   
end BIN;
