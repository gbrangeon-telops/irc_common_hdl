-------------------------------------------------------------------------------
--
-- Title       : LL_file_input_21
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Description : This module reads a file and outputs it on its LocalLink interface. 
--               Use \Common_HDL\Matlab\mat2vhdl.m to generate a compatible file.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;         
use IEEE.numeric_std.ALL;

library STD;
use STD.TEXTIO.all;

library Common_HDL;
use Common_HDL.Telops.all;     

entity LL_file_input_21 is
   generic(
      Signed_Data : boolean := false);
   port(                   
      FILENAME    : string(1 to 255);
      TX_MOSI     : out t_ll_mosi21;
      TX_MISO     : in  t_ll_miso;    
      STALL       : in STD_LOGIC; -- This is to introduce "stalling" or pause in the dataflow.
      RESET       : in std_logic; 
      CLK         : in STD_LOGIC
      );
end LL_file_input_21;

architecture SIM of LL_file_input_21 is
   
   file INFILE : TEXT;  
   signal read_again_next_time : std_logic;
   
begin          
   
   TX_MOSI.SUPPORT_BUSY <= '1';    
   
   MAIN_PROC: process(CLK, RESET)           
      
      variable IN_LINE : LINE;  		-- pointer to string 
      variable value : INTEGER;
      variable end_of_line : boolean := true;
      variable start_of_line : boolean := true;  
      variable file_opened : boolean := false;
      
   begin         
      if RESET = '1' then
         TX_MOSI.DVAL <= '0'; 
         read_again_next_time <= '0';
         if file_opened then
            FILE_CLOSE(INFILE); 
            file_opened := false;
         end if;
      elsif rising_edge(CLK) and TX_MISO.BUSY = '0' then -- BUSY acts as clock-enable
         
         if TX_MISO.AFULL = '0' and STALL = '0' then
            
            ---------------------------------
            -- Read one value from file
            --------------------------------- 
            if not file_opened then
               FILE_OPEN(INFILE, filename, READ_MODE); 
               file_opened := true;
               end_of_line := true;
            end if;
                        
            if endfile(INFILE) and end_of_line then
               --read_again_next_time <= '0';
               -- Close then reopen the file
               FILE_CLOSE(INFILE); 
               FILE_OPEN(INFILE, filename, READ_MODE);
               end_of_line := true;
            end if;       
            
            if end_of_line then
               readline(INFILE,IN_LINE);	-- read line of a file      
               start_of_line := true;
               end_of_line := false;
            end if;     
            
            read(IN_LINE,value);		   -- each READ procedure extracts data
            
            if IN_LINE'length = 0 then
               end_of_line := true;
            end if;   
            
--            if endfile(INFILE) and end_of_line then
--               read_again_next_time <= '1';
--               end_of_line := true;               
--            end if;            
            ---------------------------------
            
            if Signed_Data then
               TX_MOSI.DATA <= std_logic_vector(to_signed(value,TX_MOSI.DATA'LENGTH));
            else
               TX_MOSI.DATA <= std_logic_vector(to_unsigned(value,TX_MOSI.DATA'LENGTH));
            end if;
                        
            TX_MOSI.DVAL <= '1';  
            
            if start_of_line then
               TX_MOSI.SOF <= '1'; 
               start_of_line := false;
            else
               TX_MOSI.SOF <= '0';
            end if;   
            
            if end_of_line then
               TX_MOSI.EOF <= '1';              
            else
               TX_MOSI.EOF <= '0';
            end if;    
            
         else
            TX_MOSI.DVAL <= '0';  
         end if;                                          
         
      end if;  
   end process;   
   
end SIM;
