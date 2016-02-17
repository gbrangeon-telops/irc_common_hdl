---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;

package Telops is
   ------------------------------------------
   -- Types used in entity ports
   ------------------------------------------
   
   -- Wishbone ports
   type t_wb_miso is record
      DAT : std_logic_vector(15 downto 0);
      ACK : std_logic;
   end record;
   
   type t_wb_mosi is record
      DAT : std_logic_vector(15 downto 0);
      WE  : std_logic;
      ADR : std_logic_vector(11 downto 0);
      CYC : std_logic;
      STB : std_logic;
   end record;
   
   -- Wishbone ports
   type t_wb_miso32 is record
      DAT : std_logic_vector(31 downto 0);
      ACK : std_logic;
   end record;
   
   type t_wb_mosi32 is record
      DAT : std_logic_vector(31 downto 0);
      SEL : std_logic_vector(3 downto 0); 
      -- SEL="1111" => All DAT bytes valid. 
      -- SEL="1110" => DAT(31:8) valid,  DAT(7:0) invalid
      -- SEL="1100" => DAT(31:16) valid, DAT(15:0) invalid.
      -- SEL="1000" => DAT(31:24) valid, DAT(23:0) invalid.
      -- SEL="0100" => DAT(23:16) valid, others invalid.
      -- SEL="0010" => DAT(15:8) valid, others invalid.
      -- SEL="0001" => DAT(7:0) valid, others invalid.
      WE  : std_logic;
      ADR : std_logic_vector(15 downto 0);
      CYC : std_logic;
      STB : std_logic;
   end record;   
   
   -- for coding generic wishbone muxes and intercon
   type t_wb_miso_v is array(natural range <>) of t_wb_miso;
   type t_wb_mosi_v is array(natural range <>) of t_wb_mosi;
   
   -- Telops Memory Interface ports     
   type t_tmi_mosi_a6_d32 is record
      ADD	   : std_logic_vector(5 downto 0);
      RNW	   : std_logic;
      DVAL	   : std_logic;
      BWE      : std_logic_vector(3 downto 0); -- Byte Write Enable
      WR_DATA  : std_logic_vector(31 downto 0);
   end record;
      
   type t_tmi_mosi_a10_d2 is record
      ADD	   : std_logic_vector(9 downto 0);
      RNW	   : std_logic;
      DVAL	   : std_logic;
      WR_DATA  : std_logic_vector(1 downto 0);
   end record; 

   type t_tmi_mosi_a10_d21 is record
      ADD	   : std_logic_vector(9 downto 0);
      RNW	   : std_logic;
      DVAL	   : std_logic;
      WR_DATA  : std_logic_vector(20 downto 0);
   end record; 
     
   type t_tmi_mosi_a10_d24 is record
      ADD	   : std_logic_vector(9 downto 0);
      RNW	   : std_logic;
      DVAL	   : std_logic;
      WR_DATA  : std_logic_vector(23 downto 0);
   end record; 
   
   type t_tmi_mosi_a21_d24 is record
      ADD	   : std_logic_vector(20 downto 0);
      RNW	   : std_logic;
      DVAL	   : std_logic;
      WR_DATA  : std_logic_vector(23 downto 0);
   end record;

   type t_tmi_mosi_a21_d32 is record
      ADD	   : std_logic_vector(20 downto 0);
      RNW	   : std_logic;
      DVAL	   : std_logic;
      WR_DATA  : std_logic_vector(31 downto 0);
   end record;    
                   
   type t_tmi_miso_d2 is record
      BUSY     : std_logic;
      RD_DATA  : std_logic_vector(1 downto 0);           
      RD_DVAL  : std_logic;
      IDLE     : std_logic;
      ERROR    : std_logic;
   end record;   
   
   type t_tmi_miso_d21 is record
      BUSY     : std_logic;
      RD_DATA  : std_logic_vector(20 downto 0);           
      RD_DVAL  : std_logic;
      IDLE     : std_logic;
      ERROR    : std_logic;
   end record;   
   
   type t_tmi_miso_d24 is record
      BUSY     : std_logic;
      RD_DATA  : std_logic_vector(23 downto 0);           
      RD_DVAL  : std_logic;
      IDLE     : std_logic;
      ERROR    : std_logic;
   end record;  
   
   type t_tmi_miso_d32 is record
      BUSY     : std_logic;
      RD_DATA  : std_logic_vector(31 downto 0);           
      RD_DVAL  : std_logic;
      IDLE     : std_logic;
      ERROR    : std_logic;
   end record;      
  
   
   -- LocalLink ports
   type t_ll_mosi1 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA	: std_logic;
      DVAL	: std_logic;
      SUPPORT_BUSY : std_logic;
   end record;   
   
   type t_ll_mosi8 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA	: std_logic_vector(7 downto 0);
      DVAL	: std_logic;
      SUPPORT_BUSY : std_logic;
   end record;
   
   type t_ll_mosi10 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA	: std_logic_vector(9 downto 0);
      DVAL	: std_logic;
      SUPPORT_BUSY : std_logic;
   end record;
   
   type t_ll_mosi is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA	: std_logic_vector(15 downto 0);
      DVAL	: std_logic;
      SUPPORT_BUSY : std_logic;
   end record;   
   
   type t_ll_mosi17 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA	: std_logic_vector(16 downto 0);
      DVAL	: std_logic;
      SUPPORT_BUSY : std_logic;
   end record;    
   
   type t_ll_mosi19 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA	: std_logic_vector(18 downto 0);
      DVAL	: std_logic;
      SUPPORT_BUSY : std_logic;
   end record;   
   
   type t_ll_mosi21 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA	: std_logic_vector(20 downto 0);
      DVAL	: std_logic;
      SUPPORT_BUSY : std_logic;
   end record;
   
   type t_ll_mosi24 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA	: std_logic_vector(23 downto 0);
      DVAL	: std_logic;
      SUPPORT_BUSY : std_logic;
   end record;   
   
   type t_ll_mosi32 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA : std_logic_vector(31 downto 0);
      DREM : std_logic_vector(1 downto 0); 
      -- DREM IS VALID ONLY DURING EOF. The logic should assume that all data is valid when EOF=0, regardless of the value of DREM.
      -- DREM=3 => All bytes valid. 
      -- DREM=2 => (31:8) valid, (7:0) invalid
      -- DREM=1 => (31:16) valid, (15:0) invalid.
      -- DREM=0 => (31:24) valid, (23:0) invalid.
      DVAL : std_logic;
      SUPPORT_BUSY : std_logic;
   end record; 
   
   type t_ll_mosi36 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA  : std_logic_vector(35 downto 0); 
      --DREM  : std_logic_vector(1 downto 0); -- byte data remaining
      DVAL  : std_logic;
      SUPPORT_BUSY : std_logic;
   end record;   
   
   type t_ll_mosi64 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA : std_logic_vector(63 downto 0);
      DREM : std_logic_vector(2 downto 0); -- byte data remaining
      -- DREM IS VALID ONLY DURING EOF. The logic should assume that all data is valid when EOF=0, regardless of the value of DREM.
      -- DREM="111"=7 =>  All bytes valid. 
      -- DREM="101"=5 => (63:16) valid, (15:0) invalid
      -- DREM="011"=3 => (63:32) valid, (31:0) invalid
      -- DREM="001"=1 => (63:48) valid, (47:0) invalid.    
      DVAL : std_logic;
      SUPPORT_BUSY : std_logic;
   end record;
   
   type t_ll_mosi85 is record
      SOF	: std_logic;
      EOF	: std_logic;
      DATA : std_logic_vector(84 downto 0);
      DVAL : std_logic;
      SUPPORT_BUSY : std_logic;
   end record;
   
   type t_ll_miso is record
      AFULL	: std_logic;
      BUSY  : std_logic;
   end record;        
   
   -- Aurora simulation
   type t_aurora_channel is 
   record
      DATA : std_logic_vector(0 to 31);
      DREM : std_logic_vector(1 downto 0);
      DVAL_N : std_logic;
      SOF_N : std_logic;
      EOF_N : std_logic;
      DST_RDY_N : std_logic;	 
   end record;          
   
   constant XOFF : std_logic_vector(0 to 3) := "1111";
   constant XON : std_logic_vector(0 to 3) := "0000";
   
   ------------------------------------------
   -- General functions
   ------------------------------------------
   function log2 (x : unsigned) return natural;
   function log2 (x : positive) return natural;
   function FixedDivider(dividend : unsigned; divisor : integer) return unsigned;
   function Adder_Sat (a,b : signed) return signed;
   function Uto0 (a: std_logic_vector) return std_logic_vector;
   function Uto0 (a: std_logic) return std_logic;
   function CRC (a: std_logic_vector; length: integer) return std_logic_vector;
   function CRC (a: std_logic_vector) return std_logic; 
   function Round(x : signed; OutputWidth : integer) return signed;
   function BooltoStd(x:boolean) return std_logic; 
   function maximum (l, r : integer)return integer;
   function Synth_Log2(x:unsigned) return  integer;
   --BooltoStd converts any boolean expression to std_logic; BooltoStd(true condition) ='1' and BooltoStd(false condition) ='0' 
   
end Telops;

package body Telops is
   
   function log2 (x : unsigned) return natural is 
      -- Author : Tuukka Toivonen 
      -- Modified by PDU to support operand larger than 32 bits
   begin
      if x <= 1 then
         return 0;
      else
         return log2 (x / 2) + 1;
      end if;
   end function log2; 
   
   function log2 (x : positive) return natural is 
   begin
      return log2(to_unsigned(x,32));
   end function log2;
   
   function FixedDivider(dividend : unsigned; divisor : integer) return unsigned is
      -- This fixed divisor divider is implemented through multiplication by the reciprocand.
      -- It was debuged with Matlab to ensure that the result is always accurate.
      -- Testbench: F:\Projets\FIRST\Technique\Electronic\CAMEL\Data_Processing_Board\Matlab\FixedDivider_debug.m
      -- For best efficiency, if you divisor contains a factor of 2, you should shift
      -- your dividend to divide it by this factor before calling FixedDivider.
      -- Author : Patrick Dubois, March 2006
      constant dividend_len : integer := dividend'LENGTH;
      constant divisor_len : integer := log2(divisor) + 1;
      constant den : unsigned(dividend_len+divisor_len+1 downto 0) := to_unsigned(2**(dividend_len + divisor_len + 1), dividend_len+divisor_len + 2);
      constant num_len : integer := dividend_len+2;
      constant num : unsigned(num_len-1 downto 0) := resize((den/divisor) + 1, num_len);               
      
      constant quot_len : integer := dividend_len - divisor_len + 1; 
      variable quot  : unsigned(quot_len-1 downto 0); 
      
      constant m_len : integer := dividend_len+num_len;
      variable m : unsigned(m_len-1 downto 0);  
      
      constant bits_to_crop : integer := dividend_len + divisor_len + 1;
      
   begin 
      m := resize(dividend * num, m_len);
      quot := m(m_len-1 downto bits_to_crop); 
      return quot;
   end function FixedDivider;
   
   function Adder_Sat (a,b : signed) return signed is
      variable aext :   signed(a'length downto 0);
      variable bext :   signed(b'length downto 0);
      variable lcl_sum: signed(a'length downto 0);
      variable s :   signed(a'length-1 downto 0);
   begin
      aext := resize(a,a'length+1);
      bext := resize(b,b'length+1);
      lcl_sum := aext + bext;
      if(lcl_sum(a'length) = lcl_sum(a'length-1) ) then -- No saturation
         s := lcl_sum(a'length-1 downto 0);
      else
         s:= (lcl_sum(a'length),others=>not lcl_sum(a'length));
      end if;
      return s;
   end function Adder_Sat;
   
   function Uto0 (a: std_logic_vector) return std_logic_vector is
      variable y: std_logic_vector(a'length-1 downto 0);
   begin
      for i in 0 to (a'length-1) loop
         if (a(i) = 'U' or a(i) = 'X') then
            y(i) := '0';
         else
            y(i) := a(i);
         end if;
      end loop;
      return y;
   end Uto0;
   
   function Uto0 (a: std_logic) return std_logic is
      variable y: std_logic;
   begin
      if (a = 'U' or a = 'X') then
         y := '0';
      else
         y := a;
      end if;
      return y;
   end Uto0;               
   
   function CRC (a: std_logic_vector; length: integer) return std_logic_vector is
      variable y: unsigned(length-1 downto 0);
      variable i: integer range 0 to 255;
   begin                                   
      i := 0;
      y := (others => '0');   
      while i < a'length loop
         y := resize(y + unsigned(a(i+length-1+a'LOW downto i+a'LOW)), length);
         i := i + length;
      end loop;        
      return std_logic_vector(y);      
   end CRC; 
   
   function CRC (a: std_logic_vector) return std_logic is
      variable y: unsigned(0 downto 0);
      variable i: integer range 0 to 255;
   begin                                   
      i := 0;
      y := (others => '0');   
      while i < a'length loop
         y := resize(y + unsigned(a(i+a'LOW downto i+a'LOW)), 1);
         i := i + 1;
      end loop;        
      return std_logic(y(0));      
   end CRC;         
   
   function Round(x : signed; OutputWidth : integer) return signed is
      -- Author : Patrick Dubois, March 2007
      -- There is a slight risk of overflow if the input data is already saturated.
      variable x_plus_one_half : signed(x'LENGTH-1 downto 0);
      variable y : signed(OutputWidth-1 downto 0); 
      constant BitsToChop : integer := x'LENGTH - OutputWidth;
   begin 
      if BitsToChop < 1 then
         assert FALSE report "OutputWidth must be smaller than input width by at least 1 bit" severity ERROR;
      elsif BitsToChop > 1 then
         x_plus_one_half := x + signed(std_logic_vector(to_unsigned(0, x'LENGTH-BitsToChop)) & '1' & std_logic_vector(to_unsigned(0,BitsToChop-1)));
      else
         x_plus_one_half := x + signed( std_logic_vector(to_unsigned(0, x'LENGTH-BitsToChop)) & '1' );
      end if;
      y := x_plus_one_half(x'LENGTH-1 downto BitsToChop);
      return y;
   end function Round;  
   
   function BooltoStd(x:boolean) return std_logic is 
      -- author: ENO et JPA
      --   
      variable	y : std_logic;
   begin
      if x then
         y := '1';
      else
         y := '0';
      end if;
      return y;
   end BooltoStd; 
   
   -- signed output
   function maximum (
      l, r : integer)                      -- inputs
      return integer is
   begin  -- function max
      if l > r then return l;
      else return r;
      end if;
   end function maximum;  
   --Synth. logarithm  func.
   function Synth_Log2(x:unsigned) return  integer  is
      variable log2x: integer; 
   begin
      log2x := -1; -- valeur negative insistante lorsque le log n'est pas trouvé
      for i in 0 to x'LENGTH -1  loop
         if x(i) ='1'  then
            log2x := i;
         end if;
      end loop; 
      return  log2x;      
   end Synth_Log2; 
   
   
   
   
end package body Telops;