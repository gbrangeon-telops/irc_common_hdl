------------------------------------------------------------------------------
-- "standard_additions" package contains the additions to the built in
-- "standard.std" package.  In the final version this package will be implicit.
-- This package should be compiled into "ieee_proposed" and used as follows:
-- use ieee_proposed.standard_additions.all;
-- Last Modified: $Date: 2006-03-09 11:19:36-05 $
-- RCS ID: $Id: standard_additions_c.vhd,v 1.5 2006-03-09 11:19:36-05 l435385 Exp $
--
--  Created for VHDL-200X par, David Bishop (dbishop@vhdl.org)
------------------------------------------------------------------------------
package standard_additions is
  -- OS dependant string, New Line
  impure function NL return STRING;     -- new LINE

  -- This constant gives you your simulator resolution
  -- pragma synthesis_off
  impure function Sim_Resolution return DELAY_LENGTH;
  -- pragma synthesis_on

  -- New type definitions from 1076.1, etc
  type REAL_VECTOR is array (NATURAL range <>) of REAL;
  type INTEGER_VECTOR is array (NATURAL range <>) of INTEGER;
  type TIME_VECTOR is array (NATURAL range <>) of TIME;
  type BOOLEAN_VECTOR is array (NATURAL range <>) of BOOLEAN;

  -----------------------------------------------------------------------------
  -- The minimum and maximum functions are implicit functions which are
  -- dependant on the ">" implicit function
  -----------------------------------------------------------------------------
  function minimum (L, R : BOOLEAN) return BOOLEAN;
  function maximum (L, R : BOOLEAN) return BOOLEAN;
  function minimum (arg  : BOOLEAN_VECTOR) return BOOLEAN;
  function maximum (arg  : BOOLEAN_VECTOR) return BOOLEAN;

  function minimum (L, R : BIT) return BIT;
  function maximum (L, R : BIT) return BIT;
  function minimum (arg  : BIT_VECTOR) return BIT;
  function maximum (arg  : BIT_VECTOR) return BIT;

  function minimum (L, R : CHARACTER) return CHARACTER;
  function maximum (L, R : CHARACTER) return CHARACTER;
  function minimum (arg  : STRING) return CHARACTER;
  function maximum (arg  : STRING) return CHARACTER;

  -- pragma synthesis_off
  function minimum (L, R : SEVERITY_LEVEL) return SEVERITY_LEVEL;
  function maximum (L, R : SEVERITY_LEVEL) return SEVERITY_LEVEL;
  -- pragma synthesis_on

  function minimum (L, R : INTEGER) return INTEGER;
  function maximum (L, R : INTEGER) return INTEGER;
  function minimum (arg  : INTEGER_VECTOR) return INTEGER;
  function maximum (arg  : INTEGER_VECTOR) return INTEGER;

  function minimum (L, R : REAL) return REAL;
  function maximum (L, R : REAL) return REAL;
  function minimum (arg  : REAL_VECTOR) return REAL;
  function maximum (arg  : REAL_VECTOR) return REAL;

  function minimum (L, R : TIME) return TIME;
  function maximum (L, R : TIME) return TIME;
  function minimum (arg  : TIME_VECTOR) return TIME;
  function maximum (arg  : TIME_VECTOR) return TIME;

  function minimum (L, R : STRING) return STRING;
  function maximum (L, R : STRING) return STRING;

  function minimum (L, R : BIT_VECTOR) return BIT_VECTOR;
  function maximum (L, R : BIT_VECTOR) return BIT_VECTOR;

  -- pragma synthesis_off
  function minimum (L, R : FILE_OPEN_KIND) return FILE_OPEN_KIND;
  function maximum (L, R : FILE_OPEN_KIND) return FILE_OPEN_KIND;

  function minimum (L, R : FILE_OPEN_STATUS) return FILE_OPEN_STATUS;
  function maximum (L, R : FILE_OPEN_STATUS) return FILE_OPEN_STATUS;
  -- pragma synthesis_on

  -- THESE SHOULD work, but they don't, so commented out.
  -- function minimum (L, R: BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  -- function maximum (L, R: BOOLEAN_VECTOR) return BOOLEAN_VECTOR;

  -- function minimum (L, R : INTEGER_VECTOR) return INTEGER_VECTOR;
  -- function maximum (L, R : INTEGER_VECTOR) return INTEGER_VECTOR;

  -- function minimum (L, R: REAL_VECTOR) return REAL_VECTOR;
  -- function maximum (L, R: REAL_VECTOR) return REAL_VECTOR;

  -- function minimum (L, R: TIME_VECTOR) return TIME_VECTOR;
  -- function maximum (L, R: TIME_VECTOR) return TIME_VECTOR;

  -----------------------------------------------------------------------------
  -- Reduction operations, these perform the boolean operation on all
  -- of the bits in a vector.  In the case of a NULL array, and returns '1'
  -- and or returns '0'.
  -----------------------------------------------------------------------------
  -- %%% Replace the following 6 functions with the new syntax
  function and_reduce (ARG  : BIT_VECTOR) return BIT;
  function nand_reduce (ARG : BIT_VECTOR) return BIT;
  function or_reduce (ARG   : BIT_VECTOR) return BIT;
  function nor_reduce (ARG  : BIT_VECTOR) return BIT;
  function xor_reduce (ARG  : BIT_VECTOR) return BIT;
  function xnor_reduce (ARG : BIT_VECTOR) return BIT;
  function and_reduce (ARG  : BOOLEAN_VECTOR) return BOOLEAN;
  function nand_reduce (ARG : BOOLEAN_VECTOR) return BOOLEAN;
  function or_reduce (ARG   : BOOLEAN_VECTOR) return BOOLEAN;
  function nor_reduce (ARG  : BOOLEAN_VECTOR) return BOOLEAN;
  function xor_reduce (ARG  : BOOLEAN_VECTOR) return BOOLEAN;
  function xnor_reduce (ARG : BOOLEAN_VECTOR) return BOOLEAN;
  -- %%% New syntax for reduction operators
  -- function "and"  (ARG  : BIT_VECTOR ) return BIT;
  -- function "nand" (ARG  : BIT_VECTOR ) return BIT;
  -- function "or"   (ARG  : BIT_VECTOR ) return BIT;
  -- function "nor"  (ARG  : BIT_VECTOR ) return BIT;
  -- function "xor"  (ARG  : BIT_VECTOR ) return BIT;
  -- function "xnor" (ARG  : BIT_VECTOR ) return BIT;
  -- function "and"  (ARG  : BOOLEAN_VECTOR ) return BOOLEAN;
  -- function "nand" (ARG  : BOOLEAN_VECTOR ) return BOOLEAN;
  -- function "or"   (ARG  : BOOLEAN_VECTOR ) return BOOLEAN;
  -- function "nor"  (ARG  : BOOLEAN_VECTOR ) return BOOLEAN;
  -- function "xor"  (ARG  : BOOLEAN_VECTOR ) return BOOLEAN;
  -- function "xnor" (ARG  : BOOLEAN_VECTOR ) return BOOLEAN;

  -- Function to convert a bit to a boolean, replace the following function
  function \??\ (arg : BIT) return BOOLEAN;
  -- %%% With this operator (new syntax)
  --  function "??" (arg : BIT) return BOOLEAN;
  function \?=\  (L, R : BIT) return BIT;
  function \?/=\ (L, R : BIT) return BIT;
  function \?=\  (L, R : BOOLEAN) return BOOLEAN;
  function \?/=\ (L, R : BOOLEAN) return BOOLEAN;
  function \?=\  (L, R : BIT_VECTOR) return BIT;
  function \?/=\ (L, R : BIT_VECTOR) return BIT;
  function \?>\  (L, R : BIT_VECTOR) return BIT;
  function \?>=\ (L, R : BIT_VECTOR) return BIT;
  function \?<\  (L, R : BIT_VECTOR) return BIT;
  function \?<=\ (L, R : BIT_VECTOR) return BIT;
  -- %%% Replace with the following (new syntax)
--  function "?="  (L, R : BIT) return BIT;
--  function "?/=" (L, R : BIT) return BIT;
--  function "?="  (L, R : BOOLEAN) return BOOLEAN;
--  function "?/=" (L, R : BOOLEAN) return BOOLEAN;
--  function "?="  (L, R : BIT_VECTOR) return BIT;
--  function "?/=" (L, R : BIT_VECTOR) return BIT;
--  function "?>"  (L, R : BIT_VECTOR) return BIT;
--  function "?>=" (L, R : BIT_VECTOR) return BIT;
--  function "?<"  (L, R : BIT_VECTOR) return BIT;
--  function "?<=" (L, R : BIT_VECTOR) return BIT;
  -----------------------------------------------------------------------------
  -- Vector and bit operations, these perform a boolean operation against
  -- every bit in a vector.
  -----------------------------------------------------------------------------
  function "and" (L  : BIT_VECTOR; R : BIT) return BIT_VECTOR;
  function "and" (L  : BIT; R : BIT_VECTOR) return BIT_VECTOR;
  function "nand" (L : BIT_VECTOR; R : BIT) return BIT_VECTOR;
  function "nand" (L : BIT; R : BIT_VECTOR) return BIT_VECTOR;
  function "or" (L   : BIT_VECTOR; R : BIT) return BIT_VECTOR;
  function "or" (L   : BIT; R : BIT_VECTOR) return BIT_VECTOR;
  function "nor" (L  : BIT_VECTOR; R : BIT) return BIT_VECTOR;
  function "nor" (L  : BIT; R : BIT_VECTOR) return BIT_VECTOR;
  function "xor" (L  : BIT_VECTOR; R : BIT) return BIT_VECTOR;
  function "xor" (L  : BIT; R : BIT_VECTOR) return BIT_VECTOR;
  function "xnor" (L : BIT_VECTOR; R : BIT) return BIT_VECTOR;
  function "xnor" (L : BIT; R : BIT_VECTOR) return BIT_VECTOR;
  function "and" (L  : BOOLEAN_VECTOR; R : BOOLEAN) return BOOLEAN_VECTOR;
  function "and" (L  : BOOLEAN; R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "nand" (L : BOOLEAN_VECTOR; R : BOOLEAN) return BOOLEAN_VECTOR;
  function "nand" (L : BOOLEAN; R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "or" (L   : BOOLEAN_VECTOR; R : BOOLEAN) return BOOLEAN_VECTOR;
  function "or" (L   : BOOLEAN; R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "nor" (L  : BOOLEAN_VECTOR; R : BOOLEAN) return BOOLEAN_VECTOR;
  function "nor" (L  : BOOLEAN; R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "xor" (L  : BOOLEAN_VECTOR; R : BOOLEAN) return BOOLEAN_VECTOR;
  function "xor" (L  : BOOLEAN; R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "xnor" (L : BOOLEAN_VECTOR; R : BOOLEAN) return BOOLEAN_VECTOR;
  function "xnor" (L : BOOLEAN; R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;

  -- BOOLEAN_VECTOR functions
  function "not" (L     : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "and" (L, R  : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "nand" (L, R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "or" (L, R   : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "nor" (L, R  : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "xor" (L, R  : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  function "xnor" (L, R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR;
  -----------------------------------------------------------------------------
  -- boolean and bit operations, returning type "BIT".
  -----------------------------------------------------------------------------
  function "and" (L     : BIT; R : BOOLEAN) return BIT;
  function "and" (L     : BOOLEAN; R : BIT) return BIT;
  function "or" (L      : BIT; R : BOOLEAN) return BIT;
  function "or" (L      : BOOLEAN; R : BIT) return BIT;
  function "xor" (L     : BIT; R : BOOLEAN) return BIT;
  function "xor" (L     : BOOLEAN; R : BIT) return BIT;
  function "nand" (L    : BIT; R : BOOLEAN) return BIT;
  function "nand" (L    : BOOLEAN; R : BIT) return BIT;
  function "nor" (L     : BIT; R : BOOLEAN) return BIT;
  function "nor" (L     : BOOLEAN; R : BIT) return BIT;
  function "xnor" (L    : BIT; R : BOOLEAN) return BIT;
  function "xnor" (L    : BOOLEAN; R : BIT) return BIT;

  -------------------------------------------------------------------    
  -- edge detection
  -------------------------------------------------------------------    
  function rising_edge (signal s  : BIT) return BOOLEAN;
  function falling_edge (signal s : BIT) return BOOLEAN;

end package standard_additions;

package body standard_additions is
  -- OS dependent constant to be LF on a UNIX machine
  -- purpose: returns the new line constant
  impure function NL
    return STRING is
    constant UNIX_NEWLINE : STRING := (1 => LF);
    constant PC_NEWLINE   : STRING := (1 => CR, 2 => LF);
  begin
    return UNIX_NEWLINE;
    -- If on a PC, return PC_NEWLINE
  end function NL;

  -- pragma synthesis_off
  constant BASE_TIME_ARRAY : time_vector :=
    (
      1 fs, 10 fs, 100 fs,
      1 ps, 10 ps, 100 ps,
      1 ns, 10 ns, 100 ns,
      1 us, 10 us, 100 us,
      1 ms, 10 ms, 100 ms,
      1 sec, 10 sec, 100 sec,
      1 min, 10 min, 100 min,
      1 hr, 10 hr, 100 hr
      ) ;

  impure function Sim_Resolution
    return DELAY_LENGTH is
  begin
    for i in BASE_TIME_ARRAY'range loop
      if BASE_TIME_ARRAY(i) > 0 hr then
        return BASE_TIME_ARRAY(i);
      end if;
    end loop;
    report "STANDATD.SIM_RESOLUTION: Simulator resolution not less than 100 hr"
      severity failure;
    return 1 ns;
  end function Sim_Resolution;
  -- pragma synthesis_on

  --%%% Examples of how the maximum and minimum funcitons work. REMOVE
  function minimum (L, R : BOOLEAN) return BOOLEAN is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : BOOLEAN) return BOOLEAN is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  function minimum (L, R : BIT) return BIT is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : BIT) return BIT is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  function maximum (L, R : INTEGER) return INTEGER is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  function minimum (L, R : INTEGER) return INTEGER is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;

  function maximum (L, R : BIT_VECTOR) return BIT_VECTOR is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  function minimum (L, R : BIT_VECTOR) return BIT_VECTOR is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;

  function minimum (L, R : CHARACTER) return CHARACTER is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : CHARACTER) return CHARACTER is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  -- pragma synthesis_off
  function minimum (L, R : SEVERITY_LEVEL) return SEVERITY_LEVEL is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : SEVERITY_LEVEL) return SEVERITY_LEVEL is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;
  -- pragma synthesis_on

  function minimum (L, R : STRING) return STRING is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : STRING) return STRING is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  function minimum (L, R : REAL) return REAL is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : REAL) return REAL is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  function minimum (L, R : TIME) return TIME is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : TIME) return TIME is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  -- pragma synthesis_off
  function minimum (L, R : FILE_OPEN_KIND) return FILE_OPEN_KIND is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : FILE_OPEN_KIND) return FILE_OPEN_KIND is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  function minimum (L, R : FILE_OPEN_STATUS) return FILE_OPEN_STATUS is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : FILE_OPEN_STATUS) return FILE_OPEN_STATUS is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;
  -- pragma synthesis_on

  -- THESE SHOULD work, but they don't, so commented out.
--  function minimum (L, R: REAL_VECTOR) return REAL_VECTOR is
--  begin
--    if L > R then return R;
--    else return L;
--    end if;
--  end function minimum;
--  function maximum (L, R: REAL_VECTOR) return REAL_VECTOR is
--  begin
--    if L > R then return L;
--    else return R;
--    end if;
--  end function maximum;
--  function minimum (L, R: INTEGER_VECTOR) return INTEGER_VECTOR is
--  begin
--    if L > R then return R;
--    else return L;
--    end if;
--  end function minimum;
--  function maximum (L, R: INTEGER_VECTOR) return INTEGER_VECTOR is
--  begin
--    if L > R then return L;
--    else return R;
--    end if;
--  end function maximum;
--  function minimum (L, R: TIME_VECTOR) return TIME_VECTOR is
--  begin
--    if L > R then return R;
--    else return L;
--    end if;
--  end function minimum;
--  function maximum (L, R: TIME_VECTOR) return TIME_VECTOR is
--  begin
--    if L > R then return L;
--    else return R;
--    end if;
--  end function maximum;
--  function minimum (L, R: BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
--  begin
--    if L > R then return R;
--    else return L;
--    end if;
--  end function minimum;
--  function maximum (L, R: BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
--  begin
--    if L > R then return L;
--    else return R;
--    end if;
--  end function maximum;

  function minimum (arg : BOOLEAN_VECTOR) return BOOLEAN is
    variable Upper, Lower : BOOLEAN;
    variable Half         : INTEGER;
    alias BUS_int         : boolean_vector (arg'length - 1 downto 0) is arg;
    variable Result       : BOOLEAN := BOOLEAN'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := minimum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := minimum (BUS_int (BUS_int'left downto Half));
        Lower  := minimum (BUS_int (Half - 1 downto BUS_int'right));
        Result := minimum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function minimum;

  function maximum (arg : BOOLEAN_VECTOR) return BOOLEAN is
    variable Upper, Lower : BOOLEAN;
    variable Half         : INTEGER;
    alias BUS_int         : boolean_vector (arg'length - 1 downto 0) is arg;
    variable Result       : BOOLEAN := BOOLEAN'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := maximum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := maximum (BUS_int (BUS_int'left downto Half));
        Lower  := maximum (BUS_int (Half - 1 downto BUS_int'right));
        Result := maximum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function maximum;

  function minimum (arg : BIT_VECTOR) return BIT is
    variable Upper, Lower : BIT;
    variable Half         : INTEGER;
    alias BUS_int         : BIT_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : BIT := BIT'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := minimum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := minimum (BUS_int (BUS_int'left downto Half));
        Lower  := minimum (BUS_int (Half - 1 downto BUS_int'right));
        Result := minimum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function minimum;

  function maximum (arg : BIT_VECTOR) return BIT is
    variable Upper, Lower : BIT;
    variable Half         : INTEGER;
    alias BUS_int         : BIT_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : BIT := BIT'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := maximum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := maximum (BUS_int (BUS_int'left downto Half));
        Lower  := maximum (BUS_int (Half - 1 downto BUS_int'right));
        Result := maximum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function maximum;

  function minimum (arg : STRING) return CHARACTER is
    variable Upper, Lower : CHARACTER;
    variable Half         : INTEGER;
    alias BUS_int         : STRING (arg'length downto 1) is arg;
    variable Result       : CHARACTER := CHARACTER'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := minimum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := minimum (BUS_int (BUS_int'left downto Half));
        Lower  := minimum (BUS_int (Half - 1 downto BUS_int'right));
        Result := minimum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function minimum;

  function maximum (arg : STRING) return CHARACTER is
    variable Upper, Lower : CHARACTER;
    variable Half         : INTEGER;
    alias BUS_int         : STRING (arg'length downto 1) is arg;
    variable Result       : CHARACTER := CHARACTER'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := maximum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := maximum (BUS_int (BUS_int'left downto Half));
        Lower  := maximum (BUS_int (Half - 1 downto BUS_int'right));
        Result := maximum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function maximum;

  function minimum (arg : INTEGER_VECTOR) return INTEGER is
    variable Upper, Lower : INTEGER;
    variable Half         : INTEGER;
    alias BUS_int         : INTEGER_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : INTEGER := INTEGER'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := minimum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := minimum (BUS_int (BUS_int'left downto Half));
        Lower  := minimum (BUS_int (Half - 1 downto BUS_int'right));
        Result := minimum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function minimum;

  function maximum (arg : INTEGER_VECTOR) return INTEGER is
    variable Upper, Lower : INTEGER;
    variable Half         : INTEGER;
    alias BUS_int         : INTEGER_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : INTEGER := INTEGER'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := maximum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := maximum (BUS_int (BUS_int'left downto Half));
        Lower  := maximum (BUS_int (Half - 1 downto BUS_int'right));
        Result := maximum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function maximum;

  function minimum (arg : REAL_VECTOR) return REAL is
    variable Upper, Lower : REAL;
    variable Half         : INTEGER;
    alias BUS_int         : REAL_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : REAL := REAL'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := minimum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := minimum (BUS_int (BUS_int'left downto Half));
        Lower  := minimum (BUS_int (Half - 1 downto BUS_int'right));
        Result := minimum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function minimum;

  function maximum (arg : REAL_VECTOR) return REAL is
    variable Upper, Lower : REAL;
    variable Half         : INTEGER;
    alias BUS_int         : REAL_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : REAL := REAL'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := maximum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := maximum (BUS_int (BUS_int'left downto Half));
        Lower  := maximum (BUS_int (Half - 1 downto BUS_int'right));
        Result := maximum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function maximum;

  function minimum (arg : TIME_VECTOR) return TIME is
    variable Upper, Lower : TIME;
    variable Half         : INTEGER;
    alias BUS_int         : TIME_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : TIME := TIME'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := minimum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := minimum (BUS_int (BUS_int'left downto Half));
        Lower  := minimum (BUS_int (Half - 1 downto BUS_int'right));
        Result := minimum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function minimum;

  function maximum (arg : TIME_VECTOR) return TIME is
    variable Upper, Lower : TIME;
    variable Half         : INTEGER;
    alias BUS_int         : TIME_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : TIME := TIME'low;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := maximum (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := maximum (BUS_int (BUS_int'left downto Half));
        Lower  := maximum (BUS_int (Half - 1 downto BUS_int'right));
        Result := maximum (Upper, Lower);
      end if;
    end if;
    return Result;
  end function maximum;
  ----------------------------------------------------------------------------
  -- Boolean_Vector array logical functions
  ----------------------------------------------------------------------------
  function "not" (l : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := not lv(i);
    end loop;
    return result;
  end function "not";
  function "and" (L, R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "standard.""and"" arguments are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := lv(i) and rv(i);
      end loop;
    end if;
    return result;
  end function "and";
  function "nand" (L, R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "standard.""nand"" arguments are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := lv(i) nand rv(i);
      end loop;
    end if;
    return result;
  end function "nand";
  function "or" (L, R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "standard.""or"" arguments are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := lv(i) or rv(i);
      end loop;
    end if;
    return result;
  end function "or";
  function "nor" (L, R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "standard.""nor"" arguments are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := lv(i) nor rv(i);
      end loop;
    end if;
    return result;
  end function "nor";
  function "xor" (L, R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "standard.""xor"" arguments are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := lv(i) xor rv(i);
      end loop;
    end if;
    return result;
  end function "xor";
  function "xnor" (L, R : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    if (l'length /= r'length) then
      assert false
        report "standard.""xnor"" arguments are not of the same length"
        severity failure;
    else
      for i in result'range loop
        result(i) := lv(i) xnor rv(i);
      end loop;
    end if;
    return result;
  end function "xnor";

  --%%% Uncomment the following functions (new syntax)
--  -------------------------------------------------------------------
--  -- and
--  -------------------------------------------------------------------
--  function "and" (arg : BIT_VECTOR) return BIT is
--    variable Upper, Lower : bit;
--    variable Half : integer;
--    alias BUS_int : bit_vector ( arg'length - 1 downto 0 ) is arg;
--    variable Result : bit := '1';    -- In the case of a NULL range
--  begin
--    if (arg'LENGTH >= 1) then
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := BUS_int(BUS_int'right) and BUS_int(BUS_int'left);
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := and ( BUS_int ( BUS_int'left downto Half ));
--        Lower := and ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := Upper and Lower;
--      end if;
--    end if;
--    return Result;
--  end function "and";

--  -------------------------------------------------------------------
--  -- nand
--  -------------------------------------------------------------------
--  function "nand" (arg : BIT_VECTOR) return BIT is
--  begin
--    return not and arg;
--  end function "nand";

--  -------------------------------------------------------------------
--  -- or
--  -------------------------------------------------------------------
--  function "or" (arg : BIT_VECTOR) return BIT is
--    variable Upper, Lower : bit;
--    variable Half : integer;
--    alias BUS_int : bit_vector ( arg'length - 1 downto 0 ) is arg;
--    variable Result : bit := '0';    -- In the case of a NULL range
--  begin
--    if (arg'LENGTH >= 1) then
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := BUS_int(BUS_int'right) or BUS_int(BUS_int'left);
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := or ( BUS_int ( BUS_int'left downto Half ));
--        Lower := or ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := Upper or Lower;
--      end if;
--    end if;
--    return Result;
--  end function "or";

--  -------------------------------------------------------------------
--  -- nor
--  -------------------------------------------------------------------
--  function nor (arg : BIT_VECTOR) return BIT is
--  begin
--    return not or arg;
--  end function nor;

--  -------------------------------------------------------------------
--  -- xor
--  -------------------------------------------------------------------
--  function "xor" (arg : BIT_VECTOR) return BIT is
--    variable Upper, Lower : bit;
--    variable Half : integer;
--    alias BUS_int : bit_vector ( arg'length - 1 downto 0 ) is arg;
--    variable Result : bit := '0';    -- In the case of a NULL range
--  begin
--    if (arg'LENGTH >= 1) then
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := BUS_int(BUS_int'right) xor BUS_int(BUS_int'left);
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := xor ( BUS_int ( BUS_int'left downto Half ));
--        Lower := xor ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := Upper xor Lower;
--      end if;
--    end if;
--    return Result;
--  end function "xor";
--
--  -------------------------------------------------------------------
--  -- xnor
--  -------------------------------------------------------------------
--  function "xnor" (arg : BIT_VECTOR) return BIT is
--  begin
--    return not xor arg;
--  end function "xnor";
--
--  -- BOOLEAN_VECTOR routines
--  -------------------------------------------------------------------
--  -- and
--  -------------------------------------------------------------------
--  function "and" (arg : BOOLEAN_VECTOR) return BOOLEAN is
--    variable Upper, Lower : bit;
--    variable Half : integer;
--    alias BUS_int : bit_vector ( arg'length - 1 downto 0 ) is arg;
--    variable Result : bit := '1';    -- In the case of a NULL range
--  begin
--    if (arg'LENGTH >= 1) then
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := BUS_int(BUS_int'right) and BUS_int(BUS_int'left);
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := and ( BUS_int ( BUS_int'left downto Half ));
--        Lower := and ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := Upper and Lower;
--      end if;
--    end if;
--    return Result;
--  end function "and";

--  -------------------------------------------------------------------
--  -- nand
--  -------------------------------------------------------------------
--  function "nand" (arg : BOOLEAN_VECTOR) return BOOLEAN is
--  begin
--    return not and arg;
--  end function "nand";

--  -------------------------------------------------------------------
--  -- or
--  -------------------------------------------------------------------
--  function "or" (arg : BOOLEAN_VECTOR) return BOOLEAN is
--    variable Upper, Lower : bit;
--    variable Half : integer;
--    alias BUS_int : bit_vector ( arg'length - 1 downto 0 ) is arg;
--    variable Result : bit := '0';    -- In the case of a NULL range
--  begin
--    if (arg'LENGTH >= 1) then
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := BUS_int(BUS_int'right) or BUS_int(BUS_int'left);
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := or ( BUS_int ( BUS_int'left downto Half ));
--        Lower := or ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := Upper or Lower;
--      end if;
--    end if;
--    return Result;
--  end function "or";

--  -------------------------------------------------------------------
--  -- nor
--  -------------------------------------------------------------------
--  function nor (arg : BOOLEAN_VECTOR) return BOOLEAN is
--  begin
--    return not or arg;
--  end function nor;

--  -------------------------------------------------------------------
--  -- xor
--  -------------------------------------------------------------------
--  function "xor" (arg : BOOLEAN_VECTOR) return BOOLEAN is
--    variable Upper, Lower : bit;
--    variable Half : integer;
--    alias BUS_int : bit_vector ( arg'length - 1 downto 0 ) is arg;
--    variable Result : bit := '0';    -- In the case of a NULL range
--  begin
--    if (arg'LENGTH >= 1) then
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := BUS_int(BUS_int'right) xor BUS_int(BUS_int'left);
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := xor ( BUS_int ( BUS_int'left downto Half ));
--        Lower := xor ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := Upper xor Lower;
--      end if;
--    end if;
--    return Result;
--  end function "xor";

--  -------------------------------------------------------------------
--  -- xnor
--  -------------------------------------------------------------------
--  function "xnor" (arg : BOOLEAN_VECTOR) return BOOLEAN is
--  begin
--    return not xor arg;
--  end function "xnor";
--%%% end uncomment
  --%%% REMOVE the following functions (old syntax)
  -------------------------------------------------------------------
  -- and
  -------------------------------------------------------------------
  function and_reduce (arg : BIT_VECTOR) return BIT is
    variable Upper, Lower : BIT;
    variable Half         : INTEGER;
    alias BUS_int         : BIT_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : BIT := '1';  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := BUS_int(BUS_int'right) and BUS_int(BUS_int'left);
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := and_reduce (BUS_int (BUS_int'left downto Half));
        Lower  := and_reduce (BUS_int (Half - 1 downto BUS_int'right));
        Result := Upper and Lower;
      end if;
    end if;
    return Result;
  end function and_reduce;

  -------------------------------------------------------------------
  -- nand
  -------------------------------------------------------------------
  function nand_reduce (arg : BIT_VECTOR) return BIT is
  begin
    return not and_reduce(arg);
  end function nand_reduce;

  -------------------------------------------------------------------
  -- or
  -------------------------------------------------------------------
  function or_reduce (arg : BIT_VECTOR) return BIT is
    variable Upper, Lower : BIT;
    variable Half         : INTEGER;
    alias BUS_int         : BIT_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : BIT := '0';  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := BUS_int(BUS_int'right) or BUS_int(BUS_int'left);
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := or_reduce (BUS_int (BUS_int'left downto Half));
        Lower  := or_reduce (BUS_int (Half - 1 downto BUS_int'right));
        Result := Upper or Lower;
      end if;
    end if;
    return Result;
  end function or_reduce;

  -------------------------------------------------------------------
  -- nor
  -------------------------------------------------------------------
  function nor_reduce (arg : BIT_VECTOR) return BIT is
  begin
    return not or_reduce(arg);
  end function nor_reduce;

  -------------------------------------------------------------------
  -- xor
  -------------------------------------------------------------------
  function xor_reduce (arg : BIT_VECTOR) return BIT is
    variable Upper, Lower : BIT;
    variable Half         : INTEGER;
    alias BUS_int         : BIT_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : BIT := '0';  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := BUS_int(BUS_int'right) xor BUS_int(BUS_int'left);
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := xor_reduce (BUS_int (BUS_int'left downto Half));
        Lower  := xor_reduce (BUS_int (Half - 1 downto BUS_int'right));
        Result := Upper xor Lower;
      end if;
    end if;
    return Result;
  end function xor_reduce;

  -------------------------------------------------------------------
  -- xnor
  -------------------------------------------------------------------
  function xnor_reduce (arg : BIT_VECTOR) return BIT is
  begin
    return not xor_reduce(arg);
  end function xnor_reduce;

  -- BOOLEAN_VECTOR routines
  -------------------------------------------------------------------
  -- and
  -------------------------------------------------------------------
  function and_reduce (arg : BOOLEAN_VECTOR) return BOOLEAN is
    variable Upper, Lower : BOOLEAN;
    variable Half         : INTEGER;
    alias BUS_int         : BOOLEAN_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : BOOLEAN := true;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := BUS_int(BUS_int'right) and BUS_int(BUS_int'left);
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := and_reduce (BUS_int (BUS_int'left downto Half));
        Lower  := and_reduce (BUS_int (Half - 1 downto BUS_int'right));
        Result := Upper and Lower;
      end if;
    end if;
    return Result;
  end function and_reduce;

  -------------------------------------------------------------------
  -- nand
  -------------------------------------------------------------------
  function nand_reduce (arg : BOOLEAN_VECTOR) return BOOLEAN is
  begin
    return not and_reduce(arg);
  end function nand_reduce;

  -------------------------------------------------------------------
  -- or
  -------------------------------------------------------------------
  function or_reduce (arg : BOOLEAN_VECTOR) return BOOLEAN is
    variable Upper, Lower : BOOLEAN;
    variable Half         : INTEGER;
    alias BUS_int         : BOOLEAN_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : BOOLEAN := false;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := BUS_int(BUS_int'right) or BUS_int(BUS_int'left);
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := or_reduce (BUS_int (BUS_int'left downto Half));
        Lower  := or_reduce (BUS_int (Half - 1 downto BUS_int'right));
        Result := Upper or Lower;
      end if;
    end if;
    return Result;
  end function or_reduce;

  -------------------------------------------------------------------
  -- nor
  -------------------------------------------------------------------
  function nor_reduce (arg : BOOLEAN_VECTOR) return BOOLEAN is
  begin
    return not or_reduce(arg);
  end function nor_reduce;

  -------------------------------------------------------------------
  -- xor
  -------------------------------------------------------------------
  function xor_reduce (arg : BOOLEAN_VECTOR) return BOOLEAN is
    variable Upper, Lower : BOOLEAN;
    variable Half         : INTEGER;
    alias BUS_int         : BOOLEAN_VECTOR (arg'length - 1 downto 0) is arg;
    variable Result       : BOOLEAN := false;  -- In the case of a NULL range
  begin
    if (arg'length >= 1) then
      if (BUS_int'length = 1) then
        Result := BUS_int (BUS_int'left);
      elsif (BUS_int'length = 2) then
        Result := BUS_int(BUS_int'right) xor BUS_int(BUS_int'left);
      else
        Half   := (BUS_int'length + 1) / 2 + BUS_int'right;
        Upper  := xor_reduce (BUS_int (BUS_int'left downto Half));
        Lower  := xor_reduce (BUS_int (Half - 1 downto BUS_int'right));
        Result := Upper xor Lower;
      end if;
    end if;
    return Result;
  end function xor_reduce;

  -------------------------------------------------------------------
  -- xnor
  -------------------------------------------------------------------
  function xnor_reduce (arg : BOOLEAN_VECTOR) return BOOLEAN is
  begin
    return not xor_reduce(arg);
  end function xnor_reduce;
--%%% end remove

  -- purpose: Converts a bit to a boolean
  -- %%% function "??" (arg : BIT) return BOOLEAN is
  function \??\ (arg : BIT) return BOOLEAN is
  begin
    return arg = '1';
  end function \??\;
  -- %%% end function "??";

  -- Implicit funcitons
  -- %%% function "?="  (L, R : BIT) return BIT is
  function \?=\  (L, R : BIT) return BIT is
  begin
    if L = R then
      return '1';
    else
      return '0';
    end if;
  end function \?=\;
  -- %%% end function "?=";
  -- %%% function "?/=" (L, R : BIT) return BIT is
  function \?/=\ (L, R : BIT) return BIT is
  begin
    if L /= R then
      return '1';
    else
      return '0';
    end if;
  end function \?/=\;
  -- %%% end function "?/=";
  -- %%% function "?="  (L, R : BOOLEAN) return BOOLEAN is
  function \?=\  (L, R : BOOLEAN) return BOOLEAN is
  begin
    return L = R;
  end function \?=\;
  -- %%% end function "?=";
  -- %%% function "?/=" (L, R : BOOLEAN) return BOOLEAN is
  function \?/=\ (L, R : BOOLEAN) return BOOLEAN is
  begin
    return L /= R;
  end function \?/=\;
  -- %%% end function "?/=";
  -- %%% function "?="  (L, R : BIT_VECTOR) return BIT is
  function \?=\  (L, R : BIT_VECTOR) return BIT is
  begin
    if L = R then
      return '1';
    else
      return '0';
    end if;
  end function \?=\;
  -- %%% end function "?=";
  -- %%% function "?/=" (L, R : BIT_VECTOR) return BIT is 
  function \?/=\ (L, R : BIT_VECTOR) return BIT is
  begin
    if L /= R then
      return '1';
    else
      return '0';
    end if;
  end function \?/=\;
  -- %%% end function "?/=";
  -- %%% function "?>"  (L, R : BIT_VECTOR) return BIT is
  function \?>\  (L, R : BIT_VECTOR) return BIT is
  begin
    if L > R then
      return '1';
    else
      return '0';
    end if;
  end function \?>\;
  -- %%% end function "?>";
  -- %%% function "?>=" (L, R : BIT_VECTOR) return BIT is
  function \?>=\ (L, R : BIT_VECTOR) return BIT is
  begin
    if L >= R then
      return '1';
    else
      return '0';
    end if;
  end function \?>=\;
  -- %%% end function "?>=";
  -- %%% function "?<"  (L, R : BIT_VECTOR) return BIT is
  function \?<\  (L, R : BIT_VECTOR) return BIT is
  begin
    if L < R then
      return '1';
    else
      return '0';
    end if;
  end function \?<\;
  -- %%% end function "?<";
  -- %%% function "?<=" (L, R : BIT_VECTOR) return BIT is
  function \?<=\ (L, R : BIT_VECTOR) return BIT is
  begin
    if L <= R then
      return '1';
    else
      return '0';
    end if;
  end function \?<=\;
  -- %%% end function "?<=";
  -------------------------------------------------------------------
  -- and
  -------------------------------------------------------------------
  function "and" (l : BIT_VECTOR; r : BIT) return BIT_VECTOR is
    alias lv        : BIT_VECTOR (1 to l'length) is l;
    variable result : BIT_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := lv(i) and r;
    end loop;
    return result;
  end function "and";
  -------------------------------------------------------------------
  function "and" (l : BIT; r : BIT_VECTOR) return BIT_VECTOR is
    alias rv        : BIT_VECTOR (1 to r'length) is r;
    variable result : BIT_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := l and rv(i);
    end loop;
    return result;
  end function "and";

  -------------------------------------------------------------------
  -- nand
  -------------------------------------------------------------------
  function "nand" (l : BIT_VECTOR; r : BIT) return BIT_VECTOR is
    alias lv        : BIT_VECTOR (1 to l'length) is l;
    variable result : BIT_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := not (lv(i) and r);
    end loop;
    return result;
  end function "nand";
  -------------------------------------------------------------------
  function "nand" (l : BIT; r : BIT_VECTOR) return BIT_VECTOR is
    alias rv        : BIT_VECTOR (1 to r'length) is r;
    variable result : BIT_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := not (l and rv(i));
    end loop;
    return result;
  end function "nand";

  -------------------------------------------------------------------
  -- or
  -------------------------------------------------------------------
  function "or" (l : BIT_VECTOR; r : BIT) return BIT_VECTOR is
    alias lv        : BIT_VECTOR (1 to l'length) is l;
    variable result : BIT_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := lv(i) or r;
    end loop;
    return result;
  end function "or";
  -------------------------------------------------------------------
  function "or" (l : BIT; r : BIT_VECTOR) return BIT_VECTOR is
    alias rv        : BIT_VECTOR (1 to r'length) is r;
    variable result : BIT_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := l or rv(i);
    end loop;
    return result;
  end function "or";

  -------------------------------------------------------------------
  -- nor
  -------------------------------------------------------------------
  function "nor" (l : BIT_VECTOR; r : BIT) return BIT_VECTOR is
    alias lv        : BIT_VECTOR (1 to l'length) is l;
    variable result : BIT_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := not (lv(i) or r);
    end loop;
    return result;
  end function "nor";
  -------------------------------------------------------------------
  function "nor" (l : BIT; r : BIT_VECTOR) return BIT_VECTOR is
    alias rv        : BIT_VECTOR (1 to r'length) is r;
    variable result : BIT_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := not (l or rv(i));
    end loop;
    return result;
  end function "nor";

  -------------------------------------------------------------------
  -- xor
  -------------------------------------------------------------------
  function "xor" (l : BIT_VECTOR; r : BIT) return BIT_VECTOR is
    alias lv        : BIT_VECTOR (1 to l'length) is l;
    variable result : BIT_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := lv(i) xor r;
    end loop;
    return result;
  end function "xor";
  -------------------------------------------------------------------
  function "xor" (l : BIT; r : BIT_VECTOR) return BIT_VECTOR is
    alias rv        : BIT_VECTOR (1 to r'length) is r;
    variable result : BIT_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := l xor rv(i);
    end loop;
    return result;
  end function "xor";

  -------------------------------------------------------------------
  -- xnor
  -------------------------------------------------------------------
  function "xnor" (l : BIT_VECTOR; r : BIT) return BIT_VECTOR is
    alias lv        : BIT_VECTOR (1 to l'length) is l;
    variable result : BIT_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := not (lv(i) xor r);
    end loop;
    return result;
  end function "xnor";
  -------------------------------------------------------------------
  function "xnor" (l : BIT; r : BIT_VECTOR) return BIT_VECTOR is
    alias rv        : BIT_VECTOR (1 to r'length) is r;
    variable result : BIT_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := not (l xor rv(i));
    end loop;
    return result;
  end function "xnor";
  -------------------------------------------------------------------
  -- and
  -------------------------------------------------------------------
  function "and" (l : BOOLEAN_VECTOR; r : BOOLEAN) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := lv(i) and r;
    end loop;
    return result;
  end function "and";
  -------------------------------------------------------------------
  function "and" (l : BOOLEAN; r : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := l and rv(i);
    end loop;
    return result;
  end function "and";

  -------------------------------------------------------------------
  -- nand
  -------------------------------------------------------------------
  function "nand" (l : BOOLEAN_VECTOR; r : BOOLEAN) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := not (lv(i) and r);
    end loop;
    return result;
  end function "nand";
  -------------------------------------------------------------------
  function "nand" (l : BOOLEAN; r : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := not (l and rv(i));
    end loop;
    return result;
  end function "nand";

  -------------------------------------------------------------------
  -- or
  -------------------------------------------------------------------
  function "or" (l : BOOLEAN_VECTOR; r : BOOLEAN) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := lv(i) or r;
    end loop;
    return result;
  end function "or";
  -------------------------------------------------------------------
  function "or" (l : BOOLEAN; r : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := l or rv(i);
    end loop;
    return result;
  end function "or";

  -------------------------------------------------------------------
  -- nor
  -------------------------------------------------------------------
  function "nor" (l : BOOLEAN_VECTOR; r : BOOLEAN) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := not (lv(i) or r);
    end loop;
    return result;
  end function "nor";
  -------------------------------------------------------------------
  function "nor" (l : BOOLEAN; r : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := not (l or rv(i));
    end loop;
    return result;
  end function "nor";

  -------------------------------------------------------------------
  -- xor
  -------------------------------------------------------------------
  function "xor" (l : BOOLEAN_VECTOR; r : BOOLEAN) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := lv(i) xor r;
    end loop;
    return result;
  end function "xor";
  -------------------------------------------------------------------
  function "xor" (l : BOOLEAN; r : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := l xor rv(i);
    end loop;
    return result;
  end function "xor";

  -------------------------------------------------------------------
  -- xnor
  -------------------------------------------------------------------
  function "xnor" (l : BOOLEAN_VECTOR; r : BOOLEAN) return BOOLEAN_VECTOR is
    alias lv        : BOOLEAN_VECTOR (1 to l'length) is l;
    variable result : BOOLEAN_VECTOR (1 to l'length);
  begin
    for i in result'range loop
      result(i) := not (lv(i) xor r);
    end loop;
    return result;
  end function "xnor";
  -------------------------------------------------------------------
  function "xnor" (l : BOOLEAN; r : BOOLEAN_VECTOR) return BOOLEAN_VECTOR is
    alias rv        : BOOLEAN_VECTOR (1 to r'length) is r;
    variable result : BOOLEAN_VECTOR (1 to r'length);
  begin
    for i in result'range loop
      result(i) := not (l xor rv(i));
    end loop;
    return result;
  end function "xnor";

  -- Function from Proposal FT18
  function "and" (L : BIT; R : BOOLEAN) return BIT is
  begin
    if R then
      return L;
    else
      return '0';
    end if;
  end function "and";
  function "and" (L : BOOLEAN; R : BIT) return BIT is
  begin
    if L then
      return R;
    else
      return '0';
    end if;
  end function "and";
  function "or" (L : BIT; R : BOOLEAN) return BIT is
  begin
    if R then
      return '1';
    else
      return L;
    end if;
  end function "or";
  function "or" (L : BOOLEAN; R : BIT) return BIT is
  begin
    if L then
      return '1';
    else
      return R;
    end if;
  end function "or";
  function "xor" (L : BIT; R : BOOLEAN) return BIT is
  begin
    if R then
      return not L;
    else
      return L;
    end if;
  end function "xor";
  function "xor" (L : BOOLEAN; R : BIT) return BIT is
  begin
    if L then
      return not R;
    else
      return R;
    end if;
  end function "xor";
  function "nand" (L : BIT; R : BOOLEAN) return BIT is
  begin
    if R then
      return not L;
    else
      return '1';
    end if;
  end function "nand";
  function "nand" (L : BOOLEAN; R : BIT) return BIT is
  begin
    if L then
      return not R;
    else
      return '1';
    end if;
  end function "nand";
  function "nor" (L : BIT; R : BOOLEAN) return BIT is
  begin
    if R then
      return '0';
    else
      return not L;
    end if;
  end function "nor";
  function "nor" (L : BOOLEAN; R : BIT) return BIT is
  begin
    if L then
      return '0';
    else
      return not R;
    end if;
  end function "nor";
  function "xnor" (L : BIT; R : BOOLEAN) return BIT is
  begin
    if R then
      return L;
    else
      return not L;
    end if;
  end function "xnor";
  function "xnor" (L : BOOLEAN; R : BIT) return BIT is
  begin
    if L then
      return R;
    else
      return not R;
    end if;
  end function "xnor";

  -------------------------------------------------------------------    
  -- edge detection
  -------------------------------------------------------------------    
  function rising_edge (signal s : BIT) return BOOLEAN is
  begin
    return (s'event and (s = '1') and (s'last_value = '0'));
  end function rising_edge;

  function falling_edge (signal s : BIT) return BOOLEAN is
  begin
    return (s'event and (s = '0') and (s'last_value = '1'));
  end function falling_edge;

end package body standard_additions;
