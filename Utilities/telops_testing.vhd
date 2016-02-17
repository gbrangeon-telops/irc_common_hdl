---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: telops_testing.vhd
--  Use:  Package for writing fancy test benches
--  Features: RS-232 stimuli, Wishbone stimuli, Binary File access
--  By: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Notes: two testbench entity/architecture pairs are included as examples of usage of the
--  of the functions for generating test benches.  Waveforms can be examined for understanding
--  of these protocols
---------------------------------------------------------------------------------------------------
-- translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use standard.all;

library common_hdl;
use common_hdl.telops.all;

package telops_testing is
   ---------------------------
   -- RS-232 Testing features
   ---------------------------
   type byte_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
   
   -- prototypes for simple std_logic_vector(7 downto 0) transmision functions
   procedure tx_uart(data : in  std_logic_vector(7 downto 0); bps : integer; signal tx : out std_logic);
   procedure rx_uart(data : out std_logic_vector(7 downto 0); bps : integer; signal rx : in std_logic);
   -- prototypes for simple ASCII character transmision functions
   procedure tx_uart(data : in  character; bps : integer; signal tx : out std_logic);
   procedure rx_uart(data : out character; bps : integer; signal rx : in std_logic);
   -- prototypes for more complex byte array transmission functions
   procedure tx_uart(data : in  byte_array_t; bps : integer; signal tx : out std_logic);
   procedure rx_uart(data : out byte_array_t; bps : integer; signal rx : in std_logic);
   -- prototypes for more complex ASCII string transmission functions
   procedure tx_uart(data : in  string; bps : integer; signal tx : out std_logic);
   procedure rx_uart(data : out string; bps : integer; signal rx : in std_logic);  
   
   -- prototypes for simple std_logic_vector(7 downto 0) transmision functions
   procedure tx_uart(data : in  std_logic_vector(7 downto 0); bps : real; signal tx : out std_logic);
   procedure rx_uart(data : out std_logic_vector(7 downto 0); bps : real; signal rx : in std_logic);
   -- prototypes for more complex byte array transmission functions
   procedure tx_uart(data : in  byte_array_t; bps : real; signal tx : out std_logic);
   procedure rx_uart(data : out byte_array_t; bps : real; signal rx : in std_logic);   
   
   ---------------------------
   -- WishBone Testing features
   ---------------------------
   -- prototypes for simple std_logic_vector(16 downto 0) transmision functions
   procedure wr_wb(signal clk : in std_logic; addr : in std_logic_vector(11 downto 0); data : in  std_logic_vector(15 downto 0); signal wb_mosi : out t_wb_mosi; signal wb_miso : in t_wb_miso);
   procedure rd_wb(signal clk : in std_logic; addr : in std_logic_vector(11 downto 0); data : out  std_logic_vector(15 downto 0); signal wb_mosi : out t_wb_mosi; signal wb_miso : in t_wb_miso);
   
   ---------------------------
   -- Binary file access features
   ---------------------------
   subtype byte is integer range 0 to 255;
   type BYTE_ACC is access character;
   type BINARY is file of character;
   
   -- * Once the character access type is defined VHDL has the following implicit procedures *
   -- procedure read(file f: binary; value: out character);
   -- procedure write(file f: binary; value: in character);
   -- function endfile(file f: binary) return boolean;
   
   -- we now define overloaded procedures which use our basic "character" access type
   procedure write(file F : Binary; I: in byte);
   procedure write(file F : Binary; V: in std_logic_vector(7 downto 0));
   procedure read(file F : Binary; I: out byte);
   procedure read(file F : Binary; V: out std_logic_vector(7 downto 0));
   
   -- other overloaded functions may be added later as needed
end package telops_testing;

package body telops_testing is   
   
   procedure tx_uart(data : in  std_logic_vector(7 downto 0); bps : integer; signal tx : out std_logic) is
   begin              
      tx_uart(data, real(bps), tx);
   end procedure tx_uart;
   
   procedure rx_uart(data : out std_logic_vector(7 downto 0); bps : integer; signal rx : in std_logic) is
   begin    
      rx_uart(data, real(bps), rx);
   end procedure rx_uart;   
   
   procedure tx_uart(data : in  byte_array_t; bps : integer; signal tx : out std_logic) is
   begin              
      tx_uart(data, real(bps), tx);
   end procedure tx_uart;
   
   procedure rx_uart(data : out byte_array_t; bps : integer; signal rx : in std_logic) is
   begin    
      rx_uart(data, real(bps), rx);
   end procedure rx_uart;     
   
   -- basic byte type data transmition procedures
   procedure tx_uart(data : in  std_logic_vector(7 downto 0); bps : real; signal tx : out std_logic) is
      variable bit_time : time;
      variable byte : std_logic_vector(7 downto 0);
   begin
      bit_time := 1ns*(1.0E9/real(bps));
      byte := data;
      
      wait for 2*bit_time; -- 2 stop bits for previous transfer (don't stick in procedure after last transition)
      tx <= '0';           -- start bit
      wait for bit_time;
      
      for i in 7 downto 0 loop
         tx <= byte(0);
         byte(6 downto 0) := byte(7 downto 1);
         wait for bit_time;
      end loop;
      tx <= '1';            -- return to idle level
      
   end procedure tx_uart;
   
   procedure rx_uart(data : out std_logic_vector(7 downto 0); bps : real; signal rx : in std_logic) is
      variable bit_time : time;
      variable byte : std_logic_vector(7 downto 0);
   begin
      bit_time := 1ns*(1.0E9/real(bps));
      wait until rx = '0';          -- start bit
      wait for 1.5*bit_time;        -- align with middle of MSBit
      
      for i in 7 downto 0 loop
         byte(6 downto 0) := byte(7 downto 1);
         byte(7) := rx;
         wait for bit_time;
      end loop;
      
      data := byte;
      
   end procedure rx_uart;
   
   -- Ascii character type data transmission procedures
   procedure tx_uart(data : in  character; bps : integer; signal tx : out std_logic) is
      variable byte : std_logic_vector(7 downto 0);
   begin
      byte := conv_std_logic_vector(character'pos(data),8);
      tx_uart(byte, bps, tx);
   end procedure tx_uart;
   
   procedure rx_uart(data : out character; bps : integer; signal rx : in std_logic) is
      variable byte : std_logic_vector(7 downto 0);
   begin
      rx_uart(byte, bps, rx);
      data := character'val(conv_integer(byte));
   end procedure rx_uart;
   
   -- Byte array type data transmission procedures
   procedure tx_uart(data : in  byte_array_t; bps : real; signal tx : out std_logic) is
      variable i : integer;
   begin
      for i in data'range loop
         tx_uart(data(i), bps, tx);
      end loop;
   end procedure tx_uart;
   
   procedure rx_uart(data : out byte_array_t; bps : real; signal rx : in std_logic) is  
      variable i : integer;
   begin
      for i in data'range loop
         rx_uart(data(i), bps, rx);
      end loop;
   end procedure rx_uart;
   
   -- Ascii string type data transmission procedures
   procedure tx_uart(data : in  string; bps : integer; signal tx : out std_logic) is
      variable byte : std_logic_vector(7 downto 0);
   begin
      for i in data'range loop
         byte:= conv_std_logic_vector(character'pos(data(i)),8);
         tx_uart(byte, bps, tx);
      end loop;
   end procedure tx_uart;
   
   procedure rx_uart(data : out string; bps : integer; signal rx : in std_logic) is
      variable byte : std_logic_vector(7 downto 0);
   begin
      for i in data'range loop
         rx_uart(byte, bps, rx);
         data(i) := character'val(conv_integer(byte));
      end loop;
   end procedure rx_uart;             
   
   -- WishBone data transmition procedures
   procedure wr_wb(signal clk : in std_logic; addr : in std_logic_vector(11 downto 0); data : in  std_logic_vector(15 downto 0); signal wb_mosi : out t_wb_mosi; signal wb_miso : in t_wb_miso) is
   begin
      wb_mosi.DAT <= data;
      wb_mosi.ADR <= addr;
      wb_mosi.CYC <= '1';
      wb_mosi.STB <= '1';
      wb_mosi.WE  <= '1';
      wait until rising_edge(clk);
      while wb_miso.ACK /= '1' loop
         wait until rising_edge(clk);
      end loop;
      wb_mosi.DAT <= (others => '0');
      wb_mosi.ADR <= (others => '0');
      wb_mosi.CYC <= '0';
      wb_mosi.STB <= '0';
      wb_mosi.WE  <= '0';
   end procedure wr_wb;
   
   procedure rd_wb(signal clk : in std_logic; addr : in std_logic_vector(11 downto 0); data : out  std_logic_vector(15 downto 0); signal wb_mosi : out t_wb_mosi; signal wb_miso : in t_wb_miso) is
   begin
      wb_mosi.DAT <= (others => '0');
      wb_mosi.ADR <= addr;
      wb_mosi.CYC <= '1';
      wb_mosi.STB <= '1';
      wb_mosi.WE  <= '0';
      wait until rising_edge(clk);
      while wb_miso.ACK /= '1' loop
         wait until rising_edge(clk);
      end loop;
      data := wb_miso.DAT;
      wb_mosi.DAT <= (others => '0');
      wb_mosi.ADR <= (others => '0');
      wb_mosi.CYC <= '0';
      wb_mosi.STB <= '0';
      wb_mosi.WE  <= '0';
   end procedure rd_wb;
   
   -- package private lookup tables
   
   type char_array is array(byte range <>) of character;
   constant	char_lookup : char_array :=(
   nul, soh, stx, etx, eot, enq, ack, bel, bs, ht,  lf,  vt,  ff,  cr,  so,  si, 
   dle, dc1, dc2, dc3, dc4, nak, syn, etb,	can, em,  sub, esc, fsp, gsp, rsp, usp, 
   ' ', '!', '"', '#', '$', '%', '&', ''', '(', ')', '*', '+', ',', '-', '.', '/', 
   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', 
   '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 
   'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\', ']', '^', '_', 
   '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 
   'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~', del,
   c128, c129, c130, c131, c132, c133, c134, c135,	c136, c137, c138, c139, c140, c141, c142, c143,
   c144, c145, c146, c147, c148, c149, c150, c151,	c152, c153, c154, c155, c156, c157, c158, c159,
   ' ', '¡', '¢', '£', '¤', '¥', '¦', '§',	'¨', '©', 'ª', '«', '¬', '­', '®', '¯',
   '°', '±', '²', '³', '´', 'µ', '¶', '·',	'¸', '¹', 'º', '»', '¼', '½', '¾', '¿',
   'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Æ', 'Ç',	'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï',
   'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', '×',	'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'Þ', 'ß',
   'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç',	'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï',
   'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷',	'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ' );
   
   type std_logic_vector_array is array(byte range <>) of std_logic_vector(7 downto 0);
   constant std_logic_vector_lookup : std_logic_vector_array :=(
   X"00", X"01", X"02", X"03", X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F",
   X"10", X"11", X"12", X"13", X"14", X"15", X"16", X"17", X"18", X"19", X"1A", X"1B", X"1C", X"1D", X"1E", X"1F",
   X"20", X"21", X"22", X"23", X"24", X"25", X"26", X"27", X"28", X"29", X"2A", X"2B", X"2C", X"2D", X"2E", X"2F",
   X"30", X"31", X"32", X"33", X"34", X"35", X"36", X"37", X"38", X"39", X"3A", X"3B", X"3C", X"3D", X"3E", X"3F",
   X"40", X"41", X"42", X"43", X"44", X"45", X"46", X"47", X"48", X"49", X"4A", X"4B", X"4C", X"4D", X"4E", X"4F",
   X"50", X"51", X"52", X"53", X"54", X"55", X"56", X"57", X"58", X"59", X"5A", X"5B", X"5C", X"5D", X"5E", X"5F",
   X"60", X"61", X"62", X"63", X"64", X"65", X"66", X"67", X"68", X"69", X"6A", X"6B", X"6C", X"6D", X"6E", X"6F",
   X"70", X"71", X"72", X"73", X"74", X"75", X"76", X"77", X"78", X"79", X"7A", X"7B", X"7C", X"7D", X"7E", X"7F",
   X"80", X"81", X"82", X"83", X"84", X"85", X"86", X"87", X"88", X"89", X"8A", X"8B", X"8C", X"8D", X"8E", X"8F",
   X"90", X"91", X"92", X"93", X"94", X"95", X"96", X"97", X"98", X"99", X"9A", X"9B", X"9C", X"9D", X"9E", X"9F",
   X"A0", X"A1", X"A2", X"A3", X"A4", X"A5", X"A6", X"A7", X"A8", X"A9", X"AA", X"AB", X"AC", X"AD", X"AE", X"AF",
   X"B0", X"B1", X"B2", X"B3", X"B4", X"B5", X"B6", X"B7", X"B8", X"B9", X"BA", X"BB", X"BC", X"BD", X"BE", X"BF",
   X"C0", X"C1", X"C2", X"C3", X"C4", X"C5", X"C6", X"C7", X"C8", X"C9", X"CA", X"CB", X"CC", X"CD", X"CE", X"CF",
   X"D0", X"D1", X"D2", X"D3", X"D4", X"D5", X"D6", X"D7", X"D8", X"D9", X"DA", X"DB", X"DC", X"DD", X"DE", X"DF",
   X"E0", X"E1", X"E2", X"E3", X"E4", X"E5", X"E6", X"E7", X"E8", X"E9", X"EA", X"EB", X"EC", X"ED", X"EE", X"EF",
   X"F0", X"F1", X"F2", X"F3", X"F4", X"F5", X"F6", X"F7", X"F8", X"F9", X"FA", X"FB", X"FC", X"FD", X"FE", X"FF");
   
   type byte_array is array(character range <>) of byte;
   constant	byte_lookup : byte_array :=(
   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15, 
   16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,
   32,  33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,
   48,  49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,  63,
   64,  65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
   80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90,  91,  92,  93,  94,  95,
   96,  97,  98,  99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
   112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127,
   128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
   144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159,
   160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
   176, 177, 178, 179,	180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191,
   192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207,
   208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223,
   224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
   240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255);
   
   -- package public procedures and functions
   procedure write(file F : Binary; I: in byte) is
      variable C: character;
   begin
      C := char_lookup(I);
      write(F,C);   
   end procedure write;
   
   procedure write(file F : Binary; V: in std_logic_vector(7 downto 0)) is
      variable C: character;
      variable I: integer;
   begin
      C := char_lookup(conv_integer(V));
      write(F,C);   
   end procedure write;
   
   procedure read(file F : Binary; I: out byte) is
      variable C : character;
   begin
      read(F,C);
      I := byte_lookup(C);
   end procedure read;
   
   procedure read(file F : Binary; V: out std_logic_vector(7 downto 0)) is
      variable C : character;
   begin
      read(F,C);
      V := std_logic_vector_lookup(byte_lookup(C));
   end procedure read;
   
end package body telops_testing;
-- translate_on

---------------------------------------------------------------------------------------------------
-- Example RS-232 testbench:
-- Text strings are transmitted serially using tx_uart function in rs232_stimulus process.
-- Then they are read back and logged to a text file using rx_uart function.
---------------------------------------------------------------------------------------------------
-- translate_off
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_textio.all;
use work.telops_testing.all;

entity uart_example_tb is
   generic(
      bps : integer := 6520000;             -- speed at which to operate the uart
      logfile : string := "$DSN/log/rs232_test.log");    -- output vector file
end entity uart_example_tb;

architecture asim of uart_example_tb is
   
   signal TX_PIN : std_logic;
   signal RX_PIN : std_logic;
   
begin
   
   -- dumb RS-232 loopback
   RX_PIN <= TX_PIN;
   
   -- an RS_232 stimulus process
   rs232_stimulus : process
   begin
      tx_uart("This is an example test bench   ", bps, TX_PIN);
      tx_uart("The following text has been     ", bps, TX_PIN);
      tx_uart("transmitted serially...         ", bps, TX_PIN);
      wait; --eternally
   end process rs232_stimulus;
   
   -- an RS-232 monitoring process 
   rs232_monitor : process
      variable char_data : character;
      variable str_data : string(1 to 32);
      variable L : line;
      file out_vect : text open write_mode is logfile;
   begin
      -- print a header to the log file
      write(L, "LOGING of RS-232 RX activity:");
      writeline(out_vect,L);
      writeline(out_vect,L);
      
      -- receive and print the serial data
      rx_uart(str_data, bps, RX_PIN);
      write(L, str_data);
      writeline(out_vect,L);
      rx_uart(str_data, bps, RX_PIN);
      write(L, str_data);
      writeline(out_vect,L);
      rx_uart(str_data, bps, RX_PIN);
      write(L, str_data);
      writeline(out_vect,L);
      wait; --eternally
   end process rs232_monitor;
   
end asim;
-- translate_on

---------------------------------------------------------------------------------------------------
-- Example wishbone testbench:
-- A ram is writen out of order using wr_wb function and read back in order using rd_wb function
---------------------------------------------------------------------------------------------------
-- translate_off
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library common_hdl;
use common_hdl.telops.all;
use work.telops_testing.all;

entity wishbone_example_tb is
   generic(
      logfile : string := "$DSN/log/wishbone_test.log");    -- output vector file
end entity wishbone_example_tb;

architecture asim of wishbone_example_tb is
   
   -- top level signals
   signal WB_MOSI : t_wb_mosi;
   signal WB_MISO : t_wb_miso;
   signal CLK : std_logic;
   
   -- signals for faking wishbone ram storage
   type ram_w16_t is array (0 to 15) of std_logic_vector (15 downto 0);
   signal ram_w16 : ram_w16_t;
   
begin
   
   -- generate a clock source
   clock : process
   begin
      CLK <= '0';
      loop
         wait for 5 ns;
         CLK <= not CLK;
      end loop;
   end process clock;
   
   -- fake a wishbone ram
   wb_ram16_fake : process (CLK)
      variable ack_i : std_logic;
   begin
      if (CLK'event and CLK = '1') then
         if (WB_MOSI.WE = '1' and WB_MOSI.STB = '1') then
            ram_w16(conv_integer(WB_MOSI.ADR(3 downto 0))) <= WB_MOSI.DAT;  
         end if;
         ack_i := WB_MOSI.STB and (not ack_i);
         WB_MISO.ACK <= ack_i;
      end if;
   end process wb_ram16_fake;
   WB_MISO.DAT <= ram_w16(conv_integer(WB_MOSI.ADR(3 downto 0)));
   
   -- a wishbone stimulus process
   wb_stimulus : process
      variable data : std_logic_vector(15 downto 0);
   begin
      -- initial bus levels
      WB_MOSI.DAT <= (others => '0');
      WB_MOSI.ADR <= (others => '0');
      WB_MOSI.STB <= '0';
      WB_MOSI.CYC <= '0';
      WB_MOSI.WE  <= '0';
      wait until rising_edge(CLK);
      
      -- write out of order
      wr_wb(CLK, x"000", x"0000", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"002", x"0002", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"004", x"0004", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"006", x"0006", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"008", x"0008", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"00A", x"000A", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"00C", x"000C", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"00E", x"000E", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"001", x"0001", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"003", x"0003", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"005", x"0005", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"007", x"0007", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"009", x"0009", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"00B", x"000B", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"00D", x"000D", WB_MOSI, WB_MISO);
      wr_wb(CLK, x"00F", x"000F", WB_MOSI, WB_MISO);
      
      -- pause for 1 clock time
      wait until rising_edge(CLK);
      
      -- read back in order
      rd_wb(CLK, x"000", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"001", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"002", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"003", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"004", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"005", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"006", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"007", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"008", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"009", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"00A", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"00B", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"00C", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"00D", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"00E", data, WB_MOSI, WB_MISO);
      rd_wb(CLK, x"00F", data, WB_MOSI, WB_MISO);
      wait; --eternally
      
   end process wb_stimulus;
   
end asim;
-- translate_on