-------------------------------------------------------------------------------
--
-- Title       : LL_file_input
-- Author      : KBE
-- Date        : 05/2010
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
use IEEE.std_logic_textio.all;

library STD;
use STD.TEXTIO.all;

library Common_HDL;
use Common_HDL.Telops.all;
use Common_HDL.telops_testing.all;

entity LL_file_input is
   generic(
      C_DLEN        : integer :=32;
      C_FORMAT      : string := "ASCII";	-- ASCII or BINARY
      C_SIGNED_DATA : boolean := false;
      C_LOOP        : boolean := true;
      C_STALL_RND_SEED : std_logic_vector(3 downto 0) := x"2");
   port(
      FILENAME    : string(1 to 255);
      TX_MOSI     : out t_ll_mosi32;
      TX_MISO     : in  t_ll_miso;
      STALL       : in STD_LOGIC; -- This is to introduce "stalling" or pause in the dataflow.
      RESET       : in std_logic;
      CLK         : in STD_LOGIC
      );
end LL_file_input;

architecture SIM of LL_file_input is

signal FoundGenCase : boolean := FALSE; 
signal stall_sig : std_logic;
signal lfsr       : std_logic_vector(15 downto 0) := (others => '0');   -- To avoid X in simulation
signal lfsr_in    : std_logic;


begin

   TX_MOSI.SUPPORT_BUSY <= '1';
   TX_MOSI.DREM <= "11";

   ------------------------------------------------------
   -- Conditional code for ASCII input file support
   ------------------------------------------------------
   Ascii_gen: if C_FORMAT = "ASCII" generate

   file INFILE : TEXT;
   signal read_again_next_time : std_logic;

   begin
      
      MAIN_PROC: process(CLK, RESET)

         variable IN_LINE : LINE;  		-- pointer to string
         variable value : INTEGER;
         variable end_of_line : boolean := true;
         variable end_of_file : boolean := false;
         --variable done : boolean := false;
         variable start_of_line : boolean := true;
         variable file_opened : boolean := false;
         variable tx_mosi_data_var : std_logic_vector(C_DLEN-1 downto 0);

      begin
         if RESET = '1' then
            TX_MOSI.DVAL <= '0';
            read_again_next_time <= '0';
            --done := false;       
            end_of_file := false;
            if file_opened then
               FILE_CLOSE(INFILE);
               file_opened := false;
            end if;
         elsif rising_edge(CLK) and TX_MISO.BUSY = '0' then -- BUSY acts as clock-enable

            if TX_MISO.AFULL = '0' and stall_sig = '0' and not end_of_file then

               ---------------------------------
               -- Read one value from file
               ---------------------------------
               if not file_opened then
                  FILE_OPEN(INFILE, filename, READ_MODE);
                  file_opened := true;
                  end_of_line := true; 
                  end_of_file := false;
               end if;

               if endfile(INFILE) and end_of_line then
                  -- Close then reopen the file
                  FILE_CLOSE(INFILE);   
                  if C_LOOP then 
                     FILE_OPEN(INFILE, filename, READ_MODE); 
                  else          
                     end_of_file := true;                     
                  end if;
                  end_of_line := true;
               end if;       
               
               if not end_of_file then

                  if end_of_line then
                     readline(INFILE,IN_LINE);	-- read line of a file
                     start_of_line := true;
                     end_of_line := false;                  
                  end if;
   
                  read(IN_LINE,value);		   -- each READ procedure extracts data
   
                  if IN_LINE'length = 0 then
                     end_of_line := true;
                  end if;  
   
                  ---------------------------------TX_MOSI.DATA'LENGTH
   
                  if C_SIGNED_DATA then
                     tx_mosi_data_var := std_logic_vector(to_signed(value,C_DLEN));
                     TX_MOSI.DATA(C_DLEN-1 downto 0) <= tx_mosi_data_var;
                     TX_MOSI.DATA(31 downto C_DLEN) <= (others=> tx_mosi_data_var(tx_mosi_data_var'high));
                  else
                     TX_MOSI.DATA(C_DLEN-1 downto 0) <= std_logic_vector(to_unsigned(value,C_DLEN));
                     TX_MOSI.DATA(31 downto C_DLEN) <= (others=>'0');
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

            else
               TX_MOSI.DVAL <= '0';
            end if;

         end if;
      end process;
      --
      FoundGenCase <= true;
   end generate Ascii_gen;

   ------------------------------------------------------
   -- Conditional code for BINARY input file support
   ------------------------------------------------------
   Bin_gen: if (C_FORMAT = "BINARY" and (C_DLEN mod(8))=0)generate

   file INFILE : BINARY;

   begin

      MAIN_PROC: process(CLK, RESET)

         variable data : std_logic_vector(7 downto 0);
         variable file_opened : BOOLEAN := false;

      begin
         if RESET = '1' then
            TX_MOSI.DVAL <= '0';
            TX_MOSI.DATA <= (others => '0');
            --         read_again_next_time <= '0';
            if file_opened then
               FILE_CLOSE(INFILE);
               file_opened := false;
            end if;
         elsif rising_edge(CLK) and TX_MISO.BUSY = '0' then -- BUSY acts as clock-enable
            if not file_opened then
               FILE_OPEN(INFILE, filename, READ_MODE);
               file_opened := true;
            end if;

            if TX_MISO.AFULL = '0' and stall_sig = '0' then

            if endfile(INFILE) then
               -- Close then reopen the file
               FILE_CLOSE(INFILE);
               FILE_OPEN(INFILE, filename, READ_MODE);
            end if;

            if TX_MISO.AFULL = '0' and STALL = '0' then
               if file_opened and not endfile(INFILE) then
   	            for byte_index in 0 to (C_DLEN/8)-1 loop
                     read(INFILE,data);
                     TX_MOSI.DATA(byte_index*8+7 downto byte_index*8) <= data;
   	            end loop;
                  TX_MOSI.DVAL <= '1';
                  TX_MOSI.SOF <= '0'; -- not supported
                  TX_MOSI.EOF <= '0'; -- not supported
               else
                  TX_MOSI.DVAL <= '0';
                  TX_MOSI.SOF <= '0';  --not supported
                  TX_MOSI.EOF <= '0';  --not supported
               end if;
            else
               TX_MOSI.DVAL <= '0';
               TX_MOSI.SOF <= '0';  --not supported
               TX_MOSI.EOF <= '0';  --not supported
            end if;
         end if;
         end if;
      end process;
      ---
      FoundGenCase <= true;
   end generate Bin_gen;
   
   ------------------------
   -- STALL Random gen
   ------------------------ 
   lfsr_in <= lfsr(1) xor lfsr(2) xor lfsr(4) xor lfsr(15);
   process(CLK)
   begin
           
      if rising_edge(CLK) then
         lfsr(0) <= lfsr_in;
         lfsr(15 downto 2) <= lfsr(14 downto 1);
         
         if STALL = '1' then         
            stall_sig <= lfsr(15);             
         else
            stall_sig <= '0';                   
         end if;
         
         if RESET = '1' then
            lfsr(0) <= C_STALL_RND_SEED(0); -- We need at least one '1' in the LFSR to activate it.
            lfsr(2) <= C_STALL_RND_SEED(1);
            lfsr(3) <= C_STALL_RND_SEED(2); 
            lfsr(5) <= C_STALL_RND_SEED(3);
         else
            lfsr(1) <= lfsr(0);   
         end if;
      end if; 
          
   end process;      


   process (CLK)
   begin
      if rising_edge(CLK) then
            assert (FoundGenCase) report "Invalid C_DLEN value for parameter C_FORMAT = BINARY, BINARY is allowed only for C_DLEN  multiple of 8" severity FAILURE;
        end if;
   end process;

end SIM;
