-------------------------------------------------------------------------------
--
-- Title       : LL_file_input_bfp
-- Author      : KBE
-- Date        : 05/2010
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Description : This module reads a file and outputs it on its LocalLink interface.
--               It's the same as LL_file_input.vhd except that it have an exponent
--               output port for block floating point support. The first data in each
--                line is output to this port.
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

entity LL_file_input_bfp is
   generic(
      C_DLEN        : integer :=32;
      C_FRAME_BREAK : integer :=6; -- Number of clock cycle to be idle between two successif frames. Max = 8
      C_FORMAT      : string := "ASCII";	-- ASCII or BINARY
      C_SIGNED_DATA : boolean := false);
   port(
      FILENAME    : string(1 to 255);
      TX_MOSI     : out t_ll_mosi32;
      TX_MISO     : in  t_ll_miso;
      TX_EXP      : out std_logic_vector(31 downto 0);
      ---
      STALL       : in STD_LOGIC; -- This is to introduce "stalling" or pause in the dataflow.
      RESET       : in std_logic;
      CLK         : in STD_LOGIC
      );
end LL_file_input_bfp;

architecture SIM of LL_file_input_bfp is

signal FoundGenCase : boolean := FALSE;
signal tx_mosi_sof_dly : std_logic;


begin

   TX_MOSI.SUPPORT_BUSY <= '1';

   ------------------------------------------------------
   -- Conditional code for ASCII input file support
   ------------------------------------------------------
   Ascii_gen: if C_FORMAT = "ASCII" generate

   file INFILE : TEXT;
   signal read_again_next_time : std_logic;

   begin

      TX_MOSI.DREM <= "11";

      MAIN_PROC: process(CLK, RESET)

         variable IN_LINE : LINE;  		-- pointer to string
         variable value : INTEGER;
         variable end_of_line : boolean := true;
         variable start_of_line : boolean := true;
         variable file_opened : boolean := false;
         variable tx_mosi_data_var : std_logic_vector(C_DLEN-1 downto 0);
         variable tx_exp_var       : std_logic_vector(TX_EXP'range);
         variable frame_break_cnt  :unsigned(2 downto 0):= (others=>'0');
         variable next_frame_go  : boolean := false;


      begin
         if RESET = '1' then
            TX_MOSI.DVAL <= '0';
            read_again_next_time <= '0';
            frame_break_cnt := (others=>'0');
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
                  --start_of_line := true;
                  end_of_line := false;
               end if;

               if (not next_frame_go) then
                  read(IN_LINE,value);		   -- each READ procedure extracts data
               end if;

               if IN_LINE'length = 0 then
                  end_of_line := true;
               end if;

--               if endfile(INFILE) and end_of_line then
--                  read_again_next_time <= '1';
--                  end_of_line := true;
--               end if;
               ---------------------------------TX_MOSI.DATA'LENGTH

               if next_frame_go then
                  frame_break_cnt := frame_break_cnt + 1;
                  if (frame_break_cnt = to_unsigned((C_FRAME_BREAK),frame_break_cnt'high+1)) then
                     read(IN_LINE,value);		   -- each READ procedure extracts data
                     frame_break_cnt := (others=>'0');
                     next_frame_go := false;
                     start_of_line := true;

                  end if;
               end if;

               ----------------------------------------------------------------------------------------
               --- Output data handling: First data of each line is output at the TX_EXP port for the
               -- exponent, the reste of data are output as usual.
               ----------------------------------------------------------------------------------------
               if start_of_line then
                  start_of_line := false;
                  tx_exp_var := std_logic_vector(to_signed(value,tx_exp_var'length));
                  TX_EXP <= tx_exp_var;                  
                  TX_MOSI.DVAL <= '0';
                  tx_mosi_sof_dly <= '1';
               else
                  TX_MOSI.DVAL <= '1';
                  tx_mosi_sof_dly <= '0';
                  if C_SIGNED_DATA then
                     tx_mosi_data_var := std_logic_vector(to_signed(value,C_DLEN));
                     TX_MOSI.DATA(C_DLEN-1 downto 0) <= tx_mosi_data_var;
                     TX_MOSI.DATA(31 downto C_DLEN) <= (others=> tx_mosi_data_var(tx_mosi_data_var'high));
                  else
                     TX_MOSI.DATA(C_DLEN-1 downto 0) <= std_logic_vector(to_unsigned(value,C_DLEN));
                     TX_MOSI.DATA(31 downto C_DLEN) <= (others=>'0');
                  end if;
               end if;

               TX_MOSI.SOF <= tx_mosi_sof_dly;


               if next_frame_go then
                  TX_MOSI.DVAL <= '0';
               end if;

               if end_of_line then
                  TX_MOSI.EOF <= '1';
                  next_frame_go := true;
               else
                  TX_MOSI.EOF <= '0';
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
   Bin_gen: if (C_FORMAT = "BINARY" and C_DLEN = 8 )generate

   file INFILE : BINARY;

   begin

      MAIN_PROC: process(CLK, RESET)

         variable data : std_logic_vector(C_DLEN-1 downto 0);
         variable file_opened : BOOLEAN := false;

      begin
         if RESET = '1' then
            TX_MOSI.DVAL <= '0';
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

            if TX_MISO.AFULL = '0' and STALL = '0' then
               if file_opened then
                  read(INFILE,data);
                  TX_MOSI.DATA(C_DLEN-1 downto 0) <= data;
                  TX_MOSI.DATA(31 downto C_DLEN) <= (others=>'0');
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
      end process;
      ---
      FoundGenCase <= true;
   end generate Bin_gen;


   process (CLK)
   begin
      if rising_edge(CLK) then
            assert (FoundGenCase) report "Invalid C_DLEN value for parameter C_FORMAT = BINARY, BINARY is allowed only for C_DLEN = 8" severity FAILURE;
        end if;
   end process;

end SIM;
