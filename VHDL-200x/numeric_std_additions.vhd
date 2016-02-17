------------------------------------------------------------------------------
-- "numeric_std_additions" package contains the additions to the standard
-- "numeric_std" package proposed by the VHDL-200X-ft working group.
-- This package should be compiled into "ieee_proposed" and used as follows:
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use ieee_proposed.numeric_std_additions.all;
-- (this package is independant of "std_logic_1164_additions")
-- Last Modified: $Date: 2006-03-22 16:28:26-05 $
-- RCS ID: $Id: numeric_std_additions.vhd,v 1.6 2006-03-22 16:28:26-05 l435385 Exp $
--
--  Created for VHDL-200X par, David Bishop (dbishop@vhdl.org)
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package numeric_std_additions is
  -- Id: A.3R
  function "+"(L : UNSIGNED; R : STD_ULOGIC) return UNSIGNED;
  -- Result subtype: UNSIGNED(L'RANGE)
  -- Result: Similar to A.3 where R is a one bit UNSIGNED

  -- Id: A.3L
  function "+"(L : STD_ULOGIC; R : UNSIGNED) return UNSIGNED;
  -- Result subtype: UNSIGNED(R'RANGE)
  -- Result: Similar to A.3 where L is a one bit UNSIGNED

  -- Id: A.4R
  function "+"(L : SIGNED; R : STD_ULOGIC) return SIGNED;
  -- Result subtype: SIGNED(L'RANGE)
  -- Result: Similar to A.4 where R is bit 0 of a non-negative
  --         SIGNED

  -- Id: A.4L
  function "+"(L : STD_ULOGIC; R : SIGNED) return SIGNED;
  -- Result subtype: UNSIGNED(R'RANGE)
  -- Result: Similar to A.4 where L is bit 0 of a non-negative
  --         SIGNED
  -- Id: A.9R
  function "-"(L : UNSIGNED; R : STD_ULOGIC) return UNSIGNED;
  -- Result subtype: UNSIGNED(L'RANGE)
  -- Result: Similar to A.9 where R is a one bit UNSIGNED

  -- Id: A.9L
  function "-"(L : STD_ULOGIC; R : UNSIGNED) return UNSIGNED;
  -- Result subtype: UNSIGNED(R'RANGE)
  -- Result: Similar to A.9 where L is a one bit UNSIGNED

  -- Id: A.10R
  function "-"(L : SIGNED; R : STD_ULOGIC) return SIGNED;
  -- Result subtype: SIGNED(L'RANGE)
  -- Result: Similar to A.10 where R is bit 0 of a non-negative
  --         SIGNED

  -- Id: A.10L
  function "-"(L : STD_ULOGIC; R : SIGNED) return SIGNED;
  -- Result subtype: UNSIGNED(R'RANGE)
  -- Result: Similar to A.10 where R is bit 0 of a non-negative
  --         SIGNED

  function RESIZE (ARG, SIZE_RES : SIGNED) return SIGNED;
  -- size_res version, uses the size of the "size_res" input
  -- to resize the output

  function RESIZE (ARG, SIZE_RES : UNSIGNED) return UNSIGNED;
  -- size_res version, uses the size of the "size_res" input
  -- to resize the output
  function TO_UNSIGNED (ARG : NATURAL; SIZE_RES : UNSIGNED) return UNSIGNED;
  -- size_res version, uses the size of the "size_res" input
  -- to resize the output
  function TO_SIGNED (ARG : INTEGER; SIZE_RES : SIGNED) return SIGNED;
  -- size_res version, uses the size of the "size_res" input
  -- to resize the output

  -- Id: M.2B
  -- %%% function "?=" (L, R : UNSIGNED) return std_ulogic;
  -- %%% function "?/=" (L, R : UNSIGNED) return std_ulogic;
  -- %%% function "?>" (L, R : UNSIGNED) return std_ulogic;
  -- %%% function "?>=" (L, R : UNSIGNED) return std_ulogic;
  -- %%% function "?<" (L, R : UNSIGNED) return std_ulogic;
  -- %%% function "?<=" (L, R : UNSIGNED) return std_ulogic;
  function \?=\ (L, R : UNSIGNED) return std_ulogic;
  function \?/=\ (L, R : UNSIGNED) return std_ulogic;
  function \?>\ (L, R : UNSIGNED) return std_ulogic;
  function \?>=\ (L, R : UNSIGNED) return std_ulogic;
  function \?<\ (L, R : UNSIGNED) return std_ulogic;
  function \?<=\ (L, R : UNSIGNED) return std_ulogic;
  -- Result subtype: STD_ULOGIC
  -- Result: terms compared per STD_LOGIC_1164 intent,
  -- returns an 'X' if a metavalue is passed

  -- Id: M.3B
  -- %%% function "?=" (L, R : SIGNED) return std_ulogic;
  -- %%% function "?/=" (L, R : SIGNED) return std_ulogic;
  -- %%% function "?>" (L, R : SIGNED) return std_ulogic;
  -- %%% function "?>=" (L, R : SIGNED) return std_ulogic;
  -- %%% function "?<" (L, R : SIGNED) return std_ulogic;
  -- %%% function "?<=" (L, R : SIGNED) return std_ulogic;
  function \?=\ (L, R : SIGNED) return std_ulogic;
  function \?/=\ (L, R : SIGNED) return std_ulogic;
  function \?>\ (L, R : SIGNED) return std_ulogic;
  function \?>=\ (L, R : SIGNED) return std_ulogic;
  function \?<\ (L, R : SIGNED) return std_ulogic;
  function \?<=\ (L, R : SIGNED) return std_ulogic;
  -- Result subtype: std_ulogic
  -- Result: terms compared per STD_LOGIC_1164 intent,
  -- returns an 'X' if a metavalue is passed

  -----------------------------------------------------------------------------
  -- New/updated funcitons for VHDL-200X fast track
  -----------------------------------------------------------------------------
  -- add_carry procedures, to provide a carry in and a carry out
  procedure add_carry (
    L, R   : in  UNSIGNED;
    c_in   : in  STD_ULOGIC;
    result : out UNSIGNED;
    c_out  : out STD_ULOGIC);
  -- Result subtype: UNSIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Procedure takes a carry in into the adder, and provides a carry out.

   procedure add_carry (
    L, R   : in  SIGNED;
    c_in   : in  STD_ULOGIC;
    result : out SIGNED;
    c_out  : out STD_ULOGIC);
  -- Result subtype: SIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Procedure takes a carry in into the adder, and provides a carry out.

  -- Overloaded functions from "std_logic_1164"
  function To_X01 (s : UNSIGNED) return UNSIGNED;
  function To_X01 (s : SIGNED) return SIGNED;

  function To_X01Z (s : UNSIGNED) return UNSIGNED;
  function To_X01Z (s : SIGNED) return SIGNED;

  function To_UX01 (s : UNSIGNED) return UNSIGNED;
  function To_UX01 (s : SIGNED) return SIGNED;

  function Is_X (s : UNSIGNED) return BOOLEAN;
  function Is_X (s : SIGNED) return BOOLEAN;

  function "sla" (ARG : SIGNED; COUNT : INTEGER) return SIGNED;
  function "sla" (ARG : UNSIGNED; COUNT : INTEGER) return UNSIGNED;

  function "sra" (ARG : SIGNED; COUNT : INTEGER) return SIGNED;
  function "sra" (ARG : UNSIGNED; COUNT : INTEGER) return UNSIGNED;

  -- New conversion functions, these drop or add sign bits only
  function remove_sign (arg : SIGNED) return UNSIGNED;
  function add_sign (arg : UNSIGNED) return SIGNED;

  -- Returns the maximum (or minimum) of the two numbers provided.
  -- All types (both inputs and the output) must be the same.
  -- These override the implicit funcitons, using the local ">" operator
  function maximum (
    l, r : UNSIGNED)                    -- inputs
    return UNSIGNED;

  function maximum (
    l, r : SIGNED)                      -- inputs
    return SIGNED;

  function minimum (
    l, r : UNSIGNED)                    -- inputs
    return UNSIGNED;

  function minimum (
    l, r : SIGNED)                      -- inputs
    return SIGNED;

  -- Finds the first "Y" in the input string. Returns an integer index
  -- into that string.  If "Y" does not exist in the string, then the
  -- "find_lsb" returns arg'low -1, and "find_msb" returns -1
  function find_lsb (
    arg : UNSIGNED;                     -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER;
  
  function find_lsb (
    arg : SIGNED;                       -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER;
  
  function find_msb (
    arg : UNSIGNED;                     -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER;
  
  function find_msb (
    arg : SIGNED;                       -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER;

  -- L.15 
  function "and" (L : STD_ULOGIC; R : UNSIGNED) return UNSIGNED;

-- L.16 
  function "and" (L : UNSIGNED; R : STD_ULOGIC) return UNSIGNED;

-- L.17 
  function "or" (L : STD_ULOGIC; R : UNSIGNED) return UNSIGNED;

-- L.18 
  function "or" (L : UNSIGNED; R : STD_ULOGIC) return UNSIGNED;

-- L.19 
  function "nand" (L : STD_ULOGIC; R : UNSIGNED) return UNSIGNED;

-- L.20 
  function "nand" (L : UNSIGNED; R : STD_ULOGIC) return UNSIGNED;

-- L.21 
  function "nor" (L : STD_ULOGIC; R : UNSIGNED) return UNSIGNED;

-- L.22 
  function "nor" (L : UNSIGNED; R : STD_ULOGIC) return UNSIGNED;

-- L.23 
  function "xor" (L : STD_ULOGIC; R : UNSIGNED) return UNSIGNED;

-- L.24 
  function "xor" (L : UNSIGNED; R : STD_ULOGIC) return UNSIGNED;

-- L.25 
  function "xnor" (L : STD_ULOGIC; R : UNSIGNED) return UNSIGNED;

-- L.26 
  function "xnor" (L : UNSIGNED; R : STD_ULOGIC) return UNSIGNED;

-- L.27 
  function "and" (L : STD_ULOGIC; R : SIGNED) return SIGNED;

-- L.28 
  function "and" (L : SIGNED; R : STD_ULOGIC) return SIGNED;

-- L.29 
  function "or" (L : STD_ULOGIC; R : SIGNED) return SIGNED;

-- L.30 
  function "or" (L : SIGNED; R : STD_ULOGIC) return SIGNED;

-- L.31 
  function "nand" (L : STD_ULOGIC; R : SIGNED) return SIGNED;

-- L.32 
  function "nand" (L : SIGNED; R : STD_ULOGIC) return SIGNED;

-- L.33 
  function "nor" (L : STD_ULOGIC; R : SIGNED) return SIGNED;

-- L.34 
  function "nor" (L : SIGNED; R : STD_ULOGIC) return SIGNED;

-- L.35 
  function "xor" (L : STD_ULOGIC; R : SIGNED) return SIGNED;

-- L.36 
  function "xor" (L : SIGNED; R : STD_ULOGIC) return SIGNED;

-- L.37 
  function "xnor" (L : STD_ULOGIC; R : SIGNED) return SIGNED;

-- L.38 
  function "xnor" (L : SIGNED; R : STD_ULOGIC) return SIGNED;

  -- %%% remove 12 functions (old syntax)
  function and_reduce(arg : SIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of and'ing all of the bits of the vector. 

  function nand_reduce(arg : SIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of nand'ing all of the bits of the vector. 

  function or_reduce(arg : SIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of or'ing all of the bits of the vector. 

  function nor_reduce(arg : SIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of nor'ing all of the bits of the vector. 

  function xor_reduce(arg : SIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of xor'ing all of the bits of the vector. 

  function xnor_reduce(arg : SIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of xnor'ing all of the bits of the vector. 

  function and_reduce(arg : UNSIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of and'ing all of the bits of the vector. 

  function nand_reduce(arg : UNSIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of nand'ing all of the bits of the vector. 

  function or_reduce(arg : UNSIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of or'ing all of the bits of the vector. 

  function nor_reduce(arg : UNSIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of nor'ing all of the bits of the vector. 

  function xor_reduce(arg : UNSIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of xor'ing all of the bits of the vector. 

  function xnor_reduce(arg : UNSIGNED) return STD_ULOGIC;
  -- Result subtype: STD_LOGIC. 
  -- Result: Result of xnor'ing all of the bits of the vector.

  -- %%% Uncomment the following 12 functions (new syntax)
  -- function "and" ( arg  : SIGNED ) RETURN std_ulogic;
  -- function "nand" ( arg  : SIGNED ) RETURN std_ulogic;
  -- function "or" ( arg  : SIGNED ) RETURN std_ulogic;
  -- function "nor" ( arg  : SIGNED ) RETURN std_ulogic;
  -- function "xor" ( arg  : SIGNED ) RETURN std_ulogic;
  -- function "xnor" ( arg  : SIGNED ) RETURN std_ulogic;
  -- function "and" ( arg  : UNSIGNED ) RETURN std_ulogic;
  -- function "nand" ( arg  : UNSIGNED ) RETURN std_ulogic;
  -- function "or" ( arg  : UNSIGNED ) RETURN std_ulogic;
  -- function "nor" ( arg  : UNSIGNED ) RETURN std_ulogic;
  -- function "xor" ( arg  : UNSIGNED ) RETURN std_ulogic;
  -- function "xnor" ( arg  : UNSIGNED ) RETURN std_ulogic;

  -- rtl_synthesis off
  -- pragma synthesis_off
  -------------------------------------------------------------------    
  -- string functions
  -------------------------------------------------------------------   
  function to_string (
    value     : in SIGNED;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING;

  function to_bstring (
    value     : in SIGNED;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;
  
  function to_hstring (
    value     : in SIGNED;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING;

  function to_ostring (
    value     : in SIGNED;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING;

  function to_string (
    value     : in UNSIGNED;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING;

  function to_bstring (
    value     : in UNSIGNED;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;
  
  function to_hstring (
    value     : in UNSIGNED;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING;

  function to_ostring (
    value     : in UNSIGNED;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING;

  -----------------------------------------------------------------------------
  -- Read and Write routines
  -----------------------------------------------------------------------------
  procedure WRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    SIGNED;           -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure READ(L     : inout LINE;
                 VALUE : out   SIGNED);

  procedure READ(L     : inout LINE;
                 VALUE : out   SIGNED;
                 GOOD  : out   BOOLEAN);

  procedure WRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    UNSIGNED;         -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure READ(L     : inout LINE;
                 VALUE : out   UNSIGNED);

  procedure READ(L     : inout LINE;
                 VALUE : out   UNSIGNED;
                 GOOD  : out   BOOLEAN);

--  alias bread is read [line, SIGNED, BOOLEAN] ;
--  alias bread is read [line, SIGNED] ;
--  alias bwrite is write [line, SIGNED, side, width];
--  alias bread is read [line, UNSIGNED, BOOLEAN] ;
--  alias bread is read [line, UNSIGNED] ;
--  alias bwrite is write [line, UNSIGNED, side, width];

  procedure BWRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    SIGNED;           -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure BREAD(L     : inout LINE;
                 VALUE : out   SIGNED);

  procedure BREAD(L     : inout LINE;
                 VALUE : out   SIGNED;
                 GOOD  : out   BOOLEAN);

  procedure BWRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    UNSIGNED;         -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure BREAD(L     : inout LINE;
                 VALUE : out   UNSIGNED);

  procedure BREAD(L     : inout LINE;
                 VALUE : out   UNSIGNED;
                 GOOD  : out   BOOLEAN);
  
  -- Hex and Octal read and write, originally from "std_logic_textio",
  -- these procedures have been modified to be more forgiving.
  procedure HWRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    SIGNED;           -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure HREAD(L     : inout LINE;
                  VALUE : out   SIGNED);

  procedure HREAD(L     : inout LINE;
                  VALUE : out   SIGNED;
                  GOOD  : out   BOOLEAN);

  procedure HWRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    UNSIGNED;         -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure HREAD(L     : inout LINE;
                  VALUE : out   UNSIGNED);

  procedure HREAD(L     : inout LINE;
                  VALUE : out   UNSIGNED;
                  GOOD  : out   BOOLEAN);
  procedure OWRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    SIGNED;           -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure OREAD(L     : inout LINE;
                  VALUE : out   SIGNED);

  procedure OREAD(L     : inout LINE;
                  VALUE : out   SIGNED;
                  GOOD  : out   BOOLEAN);

  procedure OWRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    UNSIGNED;         -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure OREAD(L     : inout LINE;
                  VALUE : out   UNSIGNED);

  procedure OREAD(L     : inout LINE;
                  VALUE : out   UNSIGNED;
                  GOOD  : out   BOOLEAN);

  -- rtl_synthesis on 
  -- pragma synthesis_on
end package numeric_std_additions;

package body numeric_std_additions is
  constant NAU : UNSIGNED(0 downto 1) := (others => '0');
  constant NAS : SIGNED(0 downto 1)   := (others => '0');
  constant NO_WARNING : BOOLEAN := FALSE;  -- default to emit warnings
  function MAX (LEFT, RIGHT : INTEGER) return INTEGER is
  begin
    if LEFT > RIGHT then return LEFT;
    else return RIGHT;
    end if;
  end function MAX;

  -- Id: A.3R
  function "+"(L : UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
    variable XR : UNSIGNED(L'LENGTH-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L + XR);
  end function "+";

  -- Id: A.3L
  function "+"(L : STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
    variable XL : UNSIGNED(R'LENGTH-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL + R);
  end function "+";

  -- Id: A.4R
  function "+"(L : SIGNED; R: STD_ULOGIC) return SIGNED is
    variable XR : SIGNED(L'LENGTH-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L + XR);
  end function "+";

  -- Id: A.4L
  function "+"(L : STD_ULOGIC; R: SIGNED) return SIGNED is
    variable XL : SIGNED(R'LENGTH-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL + R);
  end function "+";

  -- Id: A.9R
  function "-"(L : UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
    variable XR : UNSIGNED(L'LENGTH-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L - XR);
  end function "-";

  -- Id: A.9L
  function "-"(L : STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
    variable XL : UNSIGNED(R'LENGTH-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL - R);
  end function "-";

  -- Id: A.10R
  function "-"(L : SIGNED; R: STD_ULOGIC) return SIGNED is
    variable XR : SIGNED(L'LENGTH-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L - XR);
  end function "-";

  -- Id: A.10L
  function "-"(L : STD_ULOGIC; R: SIGNED) return SIGNED is
    variable XL : SIGNED(R'LENGTH-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL - R);
  end function "-";

  function RESIZE (ARG, SIZE_RES : SIGNED) return SIGNED is
  begin
    if (SIZE_RES'length = 0) then
      return NAS;
    else
      return resize (ARG, SIZE_RES'length);
    end if;
  end function RESIZE;

  function RESIZE (ARG, SIZE_RES : UNSIGNED) return UNSIGNED is
  begin
    if (SIZE_RES'length = 0) then
      return NAU;
    else
      return resize (ARG, SIZE_RES'length);
    end if;
  end function RESIZE;
  
  function TO_UNSIGNED (ARG : NATURAL; SIZE_RES : UNSIGNED) return UNSIGNED is
  begin
    if (SIZE_RES'length = 0) then
      return NAU;
    else
      return TO_UNSIGNED (ARG, SIZE_RES'length);
    end if;
  end function TO_UNSIGNED;
  
  function TO_SIGNED (ARG : INTEGER; SIZE_RES : SIGNED) return SIGNED is
    begin
    if (SIZE_RES'length = 0) then
      return NAS;
    else
      return TO_SIGNED (ARG, SIZE_RES'length);
    end if;
  end function TO_SIGNED;

  TYPE stdlogic_table IS ARRAY(std_ulogic, std_ulogic) OF std_ulogic;
  CONSTANT match_logic_table : stdlogic_table := (
    -----------------------------------------------------
    -- U    X    0    1    Z    W    L    H    -         |   |  
    -----------------------------------------------------
    ( 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', '1' ),  -- | U |
    ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1' ),  -- | X |
    ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', '1' ),  -- | 0 |
    ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', '1' ),  -- | 1 |
    ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1' ),  -- | Z |
    ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1' ),  -- | W |
    ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', '1' ),  -- | L |
    ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', '1' ),  -- | H |
    ( '1', '1', '1', '1', '1', '1', '1', '1', '1' )   -- | - |
    );
  constant no_match_logic_table : stdlogic_table := (
    -----------------------------------------------------
    -- U    X    0    1    Z    W    L    H    -         |   |  
    -----------------------------------------------------
    ('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', '0'),  -- | U |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '0'),  -- | X |
    ('U', 'X', '0', '1', 'X', 'X', '0', '1', '0'),  -- | 0 |
    ('U', 'X', '1', '0', 'X', 'X', '1', '0', '0'),  -- | 1 |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '0'),  -- | Z |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '0'),  -- | W |
    ('U', 'X', '0', '1', 'X', 'X', '0', '1', '0'),  -- | L |
    ('U', 'X', '1', '0', 'X', 'X', '1', '0', '0'),  -- | H |
    ('0', '0', '0', '0', '0', '0', '0', '0', '0')   -- | - |
    );

-- %%% FUNCTION "?=" ( l, r : std_ulogic ) RETURN std_ulogic IS
  FUNCTION \?=\ ( l, r : std_ulogic ) RETURN std_ulogic IS
    VARIABLE value : std_ulogic;
  BEGIN
    RETURN match_logic_table (l, r);
  END FUNCTION \?=\;
  function \?/=\ (l, r : STD_ULOGIC) return STD_ULOGIC is
  begin
    return no_match_logic_table (l, r);
  end function \?/=\;

  -- "?=" operator is similar to "std_match", but returns a std_ulogic..
  -- Id: M.2B
  function \?=\ (L, R: UNSIGNED) return STD_ULOGIC is
    constant L_LEFT : INTEGER := L'LENGTH-1;
    constant R_LEFT : INTEGER := R'LENGTH-1;
    alias XL        : UNSIGNED(L_LEFT downto 0) is L;
    alias XR        : UNSIGNED(R_LEFT downto 0) is R;
    constant SIZE   : NATURAL := MAX(L'LENGTH, R'LENGTH);
    variable LX     : UNSIGNED(SIZE-1 downto 0);
    variable RX     : UNSIGNED(SIZE-1 downto 0);
    variable result, result1 : STD_ULOGIC;          -- result
  begin
    -- Logically identical to an "=" operator.
    if ((L'LENGTH < 1) or (R'LENGTH < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?="": null detected, returning X"
        severity warning;
      return 'X';
    else
      LX := RESIZE(XL, SIZE);
      RX := RESIZE(XR, SIZE);
      result := '1';
      for i in LX'low to LX'high loop
        result1 := \?=\(LX(i), RX(i));
        if result1 = 'U' then
          return 'U';
        elsif result1 = 'X' or result = 'X' then
          result := 'X';
        else
          result := result and result1;
        end if;
      end loop;
      return result;
    end if;
  end function \?=\;

  -- %%% Replace with the following function
  -- function "?=" (L, R: UNSIGNED) return std_ulogic is
  -- end function "?=";
  
  -- Id: M.3B
  function \?=\ (L, R: SIGNED) return std_ulogic is
    constant L_LEFT : INTEGER := L'LENGTH-1;
    constant R_LEFT : INTEGER := R'LENGTH-1;
    alias XL        : SIGNED(L_LEFT downto 0) is L;
    alias XR        : SIGNED(R_LEFT downto 0) is R;
    constant SIZE   : NATURAL := MAX(L'LENGTH, R'LENGTH);
    variable LX     : SIGNED(SIZE-1 downto 0);
    variable RX     : SIGNED(SIZE-1 downto 0);
    variable result, result1 : STD_ULOGIC;          -- result
  begin                                 -- ?=
    if ((L'LENGTH < 1) or (R'LENGTH < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?="": null detected, returning X"
        severity warning;
      return 'X';
    else
      LX := RESIZE(XL, SIZE);
      RX := RESIZE(XR, SIZE);
      result := '1';
      for i in LX'low to LX'high loop
        result1 := \?=\ (LX(i), RX(i));
        if result1 = 'U' then
          return 'U';
        elsif result1 = 'X' or result = 'X' then
          result := 'X';
        else
          result := result and result1;
        end if;
      end loop;
      return result;
    end if;
  end function \?=\;
  -- %%% Replace with the following function
--  function "?=" (L, R: signed) return std_ulogic is
--  end function "?=";

  function \?/=\ (L, R : UNSIGNED) return std_ulogic is
    constant L_LEFT : INTEGER := L'LENGTH-1;
    constant R_LEFT : INTEGER := R'LENGTH-1;
    alias XL        : UNSIGNED(L_LEFT downto 0) is L;
    alias XR        : UNSIGNED(R_LEFT downto 0) is R;
    constant SIZE   : NATURAL := MAX(L'LENGTH, R'LENGTH);
    variable LX     : UNSIGNED(SIZE-1 downto 0);
    variable RX     : UNSIGNED(SIZE-1 downto 0);
    variable result, result1 : STD_ULOGIC;             -- result
  begin                                 -- ?=
    if ((L'LENGTH < 1) or (R'LENGTH < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?/="": null detected, returning X"
        severity warning;
      return 'X';
    else
      LX := RESIZE(XL, SIZE);
      RX := RESIZE(XR, SIZE);
      result := '0';
      for i in LX'low to LX'high loop
        result1 := \?/=\ (LX(i), RX(i));
        if result1 = 'U' then
          return 'U';
        elsif result1 = 'X' or result = 'X' then
          result := 'X';
        else
          result := result or result1;
        end if;
      end loop;
      return result;
    end if;
  end function \?/=\;
  -- %%% function "?/=" (L, R : UNSIGNED) return std_ulogic is
  -- %%% end function "?/=";
  function \?/=\ (L, R : SIGNED) return std_ulogic is
    constant L_LEFT : INTEGER := L'LENGTH-1;
    constant R_LEFT : INTEGER := R'LENGTH-1;
    alias XL        : SIGNED(L_LEFT downto 0) is L;
    alias XR        : SIGNED(R_LEFT downto 0) is R;
    constant SIZE   : NATURAL := MAX(L'LENGTH, R'LENGTH);
    variable LX     : SIGNED(SIZE-1 downto 0);
    variable RX     : SIGNED(SIZE-1 downto 0);
    variable result, result1 : STD_ULOGIC;                   -- result
  begin                                 -- ?=
    if ((L'LENGTH < 1) or (R'LENGTH < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?/="": null detected, returning X"
        severity warning;
      return 'X';
    else
      LX := RESIZE(XL, SIZE);
      RX := RESIZE(XR, SIZE);
      result := '0';
      for i in LX'low to LX'high loop
        result1 := \?/=\ (LX(i), RX(i));
        if result1 = 'U' then
          return 'U';
        elsif result1 = 'X' or result = 'X' then
          result := 'X';
        else
          result := result or result1;
        end if;
      end loop;
      return result;
    end if;
  end function \?/=\;
  -- %%% function "?/=" (L, R : SIGNED) return std_ulogic is
  -- %%% end function "?/=";
  function \?>\ (L, R : UNSIGNED) return std_ulogic is
  begin
    if ((l'length < 1) or (r'length < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?>"": null detected, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "NUMERIC_STD.""?>"": '-' found in compare string"
        severity error;
      return 'X';
    else
      if is_x(l) or is_x(r) then
        return 'X';
      elsif l > r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>\;
  -- %%% function "?>" (L, R : UNSIGNED) return std_ulogic is
  -- %%% end function "?>"\;
  function \?>\ (L, R : SIGNED) return std_ulogic is
  begin
    if ((l'length < 1) or (r'length < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?>"": null detected, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "NUMERIC_STD.""?>"": '-' found in compare string"
        severity error;
      return 'X';
    else
      if is_x(l) or is_x(r) then
        return 'X';
      elsif l > r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>\;
  -- %%% function "?>" (L, R : SIGNED) return std_ulogic is
  -- %%% end function "?>";
  function \?>=\ (L, R : UNSIGNED) return std_ulogic is
  begin
    if ((l'length < 1) or (r'length < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?>="": null detected, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "NUMERIC_STD.""?>="": '-' found in compare string"
        severity error;
      return 'X';
    else
      if is_x(l) or is_x(r) then
        return 'X';
      elsif l >= r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>=\;
  -- %%% function "?>=" (L, R : UNSIGNED) return std_ulogic is
  -- %%% end function "?>=";
  function \?>=\ (L, R : SIGNED) return std_ulogic is
  begin
    if ((l'length < 1) or (r'length < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?>="": null detected, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "NUMERIC_STD.""?>="": '-' found in compare string"
        severity error;
      return 'X';
    else
      if is_x(l) or is_x(r) then
        return 'X';
      elsif l >= r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>=\;
  -- %%% function "?>=" (L, R : SIGNED) return std_ulogic is
  -- %%% end function "?>=";
  function \?<\ (L, R : UNSIGNED) return std_ulogic is
  begin
    if ((l'length < 1) or (r'length < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?<"": null detected, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "NUMERIC_STD.""?<"": '-' found in compare string"
        severity error;
      return 'X';
    else
      if is_x(l) or is_x(r) then
        return 'X';
      elsif l < r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<\;
  -- %%% function "?<" (L, R : UNSIGNED) return std_ulogic is
  -- %%% end function "?<";
  function \?<\ (L, R : SIGNED) return std_ulogic is
  begin
    if ((l'length < 1) or (r'length < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?<"": null detected, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "NUMERIC_STD.""?<"": '-' found in compare string"
        severity error;
      return 'X';
    else
      if is_x(l) or is_x(r) then
        return 'X';
      elsif l < r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<\;
  -- %%% function "?<" (L, R : SIGNED) return std_ulogic is
  -- %%% end function "?<";
  function \?<=\ (L, R : UNSIGNED) return std_ulogic is
  begin
    if ((l'length < 1) or (r'length < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?<="": null detected, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "NUMERIC_STD.""?<="": '-' found in compare string"
        severity error;
      return 'X';
    else
      if is_x(l) or is_x(r) then
        return 'X';
      elsif l <= r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<=\;
  -- %%% function "?<=" (L, R : UNSIGNED) return std_ulogic is
  -- %%% end function "?<=";
  function \?<=\ (L, R : SIGNED) return std_ulogic is
  begin
    if ((l'length < 1) or (r'length < 1)) then
      assert NO_WARNING
        report "NUMERIC_STD.""?<="": null detected, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "NUMERIC_STD.""?<="": '-' found in compare string"
        severity error;
      return 'X';
    else
      if is_x(l) or is_x(r) then
        return 'X';
      elsif l <= r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<=\;
  -- %%% function "?<=" (L, R : SIGNED) return std_ulogic is
  -- %%% end function "?<=";

    -- Result subtype: UNSIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Procedure takes a carry in into the adder, and provides a carry out.
  procedure add_carry (
    L, R   : in  UNSIGNED;
    c_in   : in  STD_ULOGIC;
    result : out UNSIGNED;
    c_out  : out STD_ULOGIC) is
    constant SIZE : NATURAL := MAX(L'LENGTH, R'LENGTH);
    variable L01  : UNSIGNED(SIZE downto 0);
    variable R01  : UNSIGNED(SIZE downto 0);
    variable res_big : UNSIGNED (SIZE downto 0);  -- one bit too bit
  begin
    c_out := 'X';                       -- default to X
    if ((L'LENGTH < 1) or (R'LENGTH < 1)) then
      result := NAU;
      return;
    end if;
    L01 := TO_01(RESIZE(L, SIZE+1), 'X');
    R01 := TO_01(RESIZE(R, SIZE+1), 'X');
    if (to_X01(c_in) = 'X')
      or (L01(L01'LEFT) = 'X') or (R01(R01'LEFT) = 'X') then
      result (SIZE-1 downto 0) := (others => 'X');
      return;
    end if;
    res_big := L01 + R01 + c_in;
    c_out := res_big(SIZE);
    result := res_big(SIZE-1 downto 0);
  end procedure add_carry;

  -- Result subtype: SIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Procedure takes a carry in into the adder, and provides a carry out.
  procedure add_carry (
    L, R   : in  SIGNED;
    c_in   : in  STD_ULOGIC;
    result : out SIGNED;
    c_out  : out STD_ULOGIC) is
    constant SIZE : NATURAL := MAX(L'LENGTH, R'LENGTH);
    variable L01  : SIGNED(SIZE downto 0);
    variable R01  : SIGNED(SIZE downto 0);
    variable res_big : SIGNED (SIZE downto 0);
  begin
    c_out := 'X';                       -- default to X
    if ((L'LENGTH < 1) or (R'LENGTH < 1)) then
      result := NAS;
      return;
    end if;
    L01 := TO_01(RESIZE(L, SIZE+1), 'X');
    R01 := TO_01(RESIZE(R, SIZE+1), 'X');
    if (to_X01(c_in) = 'X')
      or (L01(L01'LEFT) = 'X') or (R01(R01'LEFT) = 'X') then
      result (SIZE-1 downto 0) := (others => 'X');
      return;
    end if;
    res_big := L01 + R01 + c_in;
    c_out := res_big(size) xor res_big(size-1);
    result := res_big(size-1 downto 0);
  end procedure add_carry;
  -- These functions are in std_logic_1164 and are defined for
  -- std_logic_vector.  They are overloaded here.
  FUNCTION To_X01 ( s : UNSIGNED ) RETURN UNSIGNED is
  BEGIN
    return UNSIGNED (To_X01 (std_logic_vector (s)));
  end function To_X01;
  
  FUNCTION To_X01 ( s : SIGNED ) RETURN SIGNED is
  BEGIN
    return SIGNED (To_X01 (std_logic_vector (s)));
  end function To_X01;
  
  FUNCTION To_X01Z ( s : UNSIGNED ) RETURN UNSIGNED is
  BEGIN
    return UNSIGNED (To_X01Z (std_logic_vector (s)));
  end function To_X01Z;

  FUNCTION To_X01Z ( s : SIGNED ) RETURN SIGNED is
  BEGIN
    return SIGNED (To_X01Z (std_logic_vector (s)));
  end function To_X01Z;
  
  FUNCTION To_UX01 ( s : UNSIGNED ) RETURN UNSIGNED is
  BEGIN
    return UNSIGNED (To_UX01 (std_logic_vector (s)));
  end function To_UX01;
  
  FUNCTION To_UX01 ( s : SIGNED ) RETURN SIGNED is
  BEGIN
    return SIGNED (To_UX01 (std_logic_vector (s)));
  end function To_UX01;

  FUNCTION Is_X ( s : UNSIGNED ) RETURN BOOLEAN is
  BEGIN
    return Is_X (std_logic_vector (s));
  end function Is_X;
  
  FUNCTION Is_X ( s : SIGNED ) RETURN BOOLEAN is
  BEGIN
    return Is_X (std_logic_vector (s));
  end function Is_X;

  -- Arithmetic shifts
  -- Functionality NOT the same as the std_logic_vector or bit vector version
  function "sla" (ARG : SIGNED; COUNT : INTEGER) RETURN SIGNED is
  begin
    if (COUNT >= 0) then
      return SHIFT_LEFT(ARG, COUNT);
    else
      return SHIFT_RIGHT(ARG, -COUNT);
    end if;
  end function "sla";
  
  -- Functionality NOT the same as the std_logic_vector or bit vector version
  function "sla" (ARG : UNSIGNED; COUNT : INTEGER) RETURN UNSIGNED is
  begin
    if (COUNT >= 0) then
      return SHIFT_LEFT(ARG, COUNT);
    else
      return SHIFT_RIGHT(ARG, -COUNT);
    end if;
  end function "sla";

  -- Functionality NOT the same as the std_logic_vector or bit vector version
  function "sra" (ARG : SIGNED; COUNT : INTEGER) RETURN SIGNED is
  begin
    if (COUNT >= 0) then
      return SHIFT_RIGHT(ARG, COUNT);
    else
      return SHIFT_LEFT(ARG, -COUNT);
    end if;
  end function "sra";
  
  -- Functionality NOT the same as the std_logic_vector or bit vector version
  function "sra" (ARG : UNSIGNED; COUNT : INTEGER) RETURN UNSIGNED is
  begin
    if (COUNT >= 0) then
      return SHIFT_RIGHT(ARG, COUNT);
    else
      return SHIFT_LEFT(ARG, -COUNT);
    end if;
  end function "sra";

  -----------------------------------------------------------------------------
  -- New/updated functions for VHDL-200X fast track
  -----------------------------------------------------------------------------
  -- New conversion functions, these drop or add sign bits only
  function remove_sign (arg : SIGNED) return UNSIGNED is
    variable result : unsigned (arg'length-1 downto 0);
    alias XARG        : SIGNED(arg'length-1 downto 0) is ARG;
    variable yarg : SIGNED (XARG'range);
  begin
    if arg'length < 1 then
      return NAU;
    end if;
    if (to_x01(XARG(XARG'high)) = '1') then
      yarg := abs (xarg);
    else
      yarg := to_x01(xarg);
    end if;
    result := unsigned(yarg);
    return result;
  end function remove_sign;
  
  function add_sign (arg : UNSIGNED) return SIGNED is
    variable result : signed (arg'length downto 0);
    alias XARG        : UNSIGNED(arg'length-1 downto 0) is ARG;
  begin
    if arg'length < 1 then
      return NAS;
    end if;
    result := "0" & SIGNED (to_x01(XARG));
    return result;
  end function add_sign;

  -- Returns the maximum (or minimum) of the two numbers provided.
  -- All types (both inputs and the output) must be the same.
  -- These override the implicit functions, using the local ">" operator
  -- UNSIGNED output
  function maximum (
    l, r : UNSIGNED)                    -- inputs
    return UNSIGNED is
  begin  -- function max
    if l > r then return l;
    else return r;
    end if;
  end function maximum;

  -- signed output
  function maximum (
    l, r : signed)                      -- inputs
    return signed is
  begin  -- function max
    if l > r then return l;
    else return r;
    end if;
  end function maximum;

  -- UNSIGNED output
  function minimum (
    l, r : UNSIGNED)                    -- inputs
    return UNSIGNED is
  begin  -- function minimum
    if l < r then return l;
    else return r;
    end if;
  end function minimum;

  -- signed output
  function minimum (
    l, r : signed)                      -- inputs
    return signed is
  begin  -- function minimum
    if l < r then return l;
    else return r;
    end if;
  end function minimum;

  function find_lsb (
    arg : UNSIGNED;                         -- vector argument
    y   : std_ulogic)                       -- look for this bit
    return integer is
    alias xarg : UNSIGNED(arg'length-1 downto 0) is arg;
  begin
    for_loop: for i in xarg'reverse_range loop
      if xarg(i) = y then
        return i;
      end if;
    end loop;
    return -1;
  end function find_lsb;

  function find_lsb (
    arg : signed;                           -- vector argument
    y   : std_ulogic)                       -- look for this bit
    return integer is
    alias xarg : SIGNED(arg'length-1 downto 0) is arg;
  begin
    for_loop: for i in xarg'reverse_range loop
      if xarg(i) = y then
        return i;
      end if;
    end loop;
    return -1;
  end function find_lsb;

  function find_msb (
    arg : UNSIGNED;                        -- vector argument
    y   : std_ulogic)                      -- look for this bit
    return integer is
    alias xarg : UNSIGNED(arg'length-1 downto 0) is arg;
  begin
    for_loop: for i in xarg'range loop
      if xarg(i) = y then
        return i;
      end if;
    end loop;
    return -1;
  end function find_msb;

  function find_msb (
    arg : signed;                          -- vector argument
    y   : std_ulogic)                      -- look for this bit
    return integer is
    alias xarg : SIGNED(arg'length-1 downto 0) is arg;
  begin
    for_loop: for i in xarg'range loop
      if xarg(i) = y then
        return i;
      end if;
    end loop;
    return -1;
  end function find_msb;

  -- Performs the boolean operation on every bit in the vector
-- L.15 
  function "and" (L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
    ALIAS rv        : UNSIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : UNSIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "and" (l, rv(i));
    END LOOP;
    RETURN result;
  end function "and";

-- L.16 
  function "and" (L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
    ALIAS lv        : UNSIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : UNSIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "and" (lv(i), r);
    END LOOP;
    RETURN result;
  end function "and";

-- L.17 
  function "or" (L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
    ALIAS rv        : UNSIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : UNSIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "or" (l, rv(i));
    END LOOP;
    RETURN result;
  end function "or";

-- L.18 
  function "or" (L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
    ALIAS lv        : UNSIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : UNSIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "or" (lv(i), r);
    END LOOP;
    RETURN result;
  end function "or";

-- L.19 
  function "nand" (L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
    ALIAS rv        : UNSIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : UNSIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("and" (l, rv(i)));
    END LOOP;
    RETURN result;
  end function "nand";

-- L.20 
  function "nand" (L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
    ALIAS lv        : UNSIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : UNSIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("and" (lv(i), r));
    END LOOP;
    RETURN result;
  end function "nand";

-- L.21 
  function "nor" (L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
    ALIAS rv        : UNSIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : UNSIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("or" (l, rv(i)));
    END LOOP;
    RETURN result;
  end function "nor";

-- L.22 
  function "nor" (L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
    ALIAS lv        : UNSIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : UNSIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("or" (lv(i), r));
    END LOOP;
    RETURN result;
  end function "nor";

-- L.23 
  function "xor" (L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
    ALIAS rv        : UNSIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : UNSIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "xor" (l, rv(i));
    END LOOP;
    RETURN result;
  end function "xor";

-- L.24 
  function "xor" (L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
    ALIAS lv        : UNSIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : UNSIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "xor" (lv(i), r);
    END LOOP;
    RETURN result;
  end function "xor";

-- L.25 
  function "xnor" (L: STD_ULOGIC; R: UNSIGNED) return UNSIGNED is
    ALIAS rv        : UNSIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : UNSIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("xor" (l, rv(i)));
    END LOOP;
    RETURN result;
  end function "xnor";

-- L.26 
  function "xnor" (L: UNSIGNED; R: STD_ULOGIC) return UNSIGNED is
    ALIAS lv        : UNSIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : UNSIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("xor" (lv(i), r));
    END LOOP;
    RETURN result;
  end function "xnor";

-- L.27 
  function "and" (L: STD_ULOGIC; R: SIGNED) return SIGNED is
    ALIAS rv        : SIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : SIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "and" (l, rv(i));
    END LOOP;
    RETURN result;
  end function "and";

-- L.28 
  function "and" (L: SIGNED; R: STD_ULOGIC) return SIGNED is
    ALIAS lv        : SIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : SIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "and" (lv(i), r);
    END LOOP;
    RETURN result;
  end function "and";

-- L.29 
  function "or" (L: STD_ULOGIC; R: SIGNED) return SIGNED is
    ALIAS rv        : SIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : SIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "or" (l, rv(i));
    END LOOP;
    RETURN result;
  end function "or";

-- L.30 
  function "or" (L: SIGNED; R: STD_ULOGIC) return SIGNED is
    ALIAS lv        : SIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : SIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "or" (lv(i), r);
    END LOOP;
    RETURN result;
  end function "or";

-- L.31 
  function "nand" (L: STD_ULOGIC; R: SIGNED) return SIGNED is
    ALIAS rv        : SIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : SIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("and" (l, rv(i)));
    END LOOP;
    RETURN result;
  end function "nand";

-- L.32 
  function "nand" (L: SIGNED; R: STD_ULOGIC) return SIGNED is
    ALIAS lv        : SIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : SIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("and" (lv(i), r));
    END LOOP;
    RETURN result;
  end function "nand";

-- L.33 
  function "nor" (L: STD_ULOGIC; R: SIGNED) return SIGNED is
    ALIAS rv        : SIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : SIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("or" (l, rv(i)));
    END LOOP;
    RETURN result;
  end function "nor";

-- L.34 
  function "nor" (L: SIGNED; R: STD_ULOGIC) return SIGNED is
    ALIAS lv        : SIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : SIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("or" (lv(i), r));
    END LOOP;
    RETURN result;
  end function "nor";

-- L.35 
  function "xor" (L: STD_ULOGIC; R: SIGNED) return SIGNED is
    ALIAS rv        : SIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : SIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "xor" (l, rv(i));
    END LOOP;
    RETURN result;
  end function "xor";

-- L.36 
  function "xor" (L: SIGNED; R: STD_ULOGIC) return SIGNED is
    ALIAS lv        : SIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : SIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "xor" (lv(i), r);
    END LOOP;
    RETURN result;
  end function "xor";

-- L.37 
  function "xnor" (L: STD_ULOGIC; R: SIGNED) return SIGNED is
    ALIAS rv        : SIGNED ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : SIGNED ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("xor" (l, rv(i)));
    END LOOP;
    RETURN result;
  end function "xnor";

-- L.38 
  function "xnor" (L: SIGNED; R: STD_ULOGIC) return SIGNED is
    ALIAS lv        : SIGNED ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : SIGNED ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("xor" (lv(i), r));
    END LOOP;
    RETURN result;
  end function "xnor";
  
  --------------------------------------------------------------------------
  -- Reduction operations
  --------------------------------------------------------------------------
  -- %%% Remove the following 12 funcitons (old syntax)
  function and_reduce (arg : SIGNED ) return std_ulogic is
  begin
    return and_reduce (UNSIGNED ( arg ));
  end function and_reduce;

  FUNCTION and_reduce ( arg : UNSIGNED ) RETURN std_ulogic IS
    variable Upper, Lower : std_ulogic;
    variable Half : integer;
    variable BUS_int : UNSIGNED ( arg'length - 1 downto 0 );
    variable Result : std_ulogic := '1';    -- In the case of a NULL range
  BEGIN
    if (arg'LENGTH >= 1) then
      BUS_int := to_ux01 (arg);
      if ( BUS_int'length = 1 ) then
        Result := BUS_int ( BUS_int'left );
      elsif ( BUS_int'length = 2 ) then
        Result := "and" (BUS_int(BUS_int'right),BUS_int(BUS_int'left));
      else
        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
        Upper := and_reduce ( BUS_int ( BUS_int'left downto Half ));
        Lower := and_reduce ( BUS_int ( Half - 1 downto BUS_int'right ));
        Result := "and" (Upper, Lower);
      end if;
    end if;
    return Result;
  END FUNCTION and_reduce;

  function nand_reduce (arg : SIGNED ) return std_ulogic is
  begin
    return "not" (and_reduce ( arg ));
  end function nand_reduce;

  function nand_reduce (arg : UNSIGNED ) return std_ulogic is
  begin
    return "not" (and_reduce (arg ));
  end function nand_reduce;
  
  function or_reduce (arg : SIGNED ) return std_ulogic is
  begin
    return or_reduce (UNSIGNED ( arg ));
  end function or_reduce;

  function or_reduce (arg : UNSIGNED ) return std_ulogic is
    variable Upper, Lower : std_ulogic;
    variable Half : integer;
    variable BUS_int : UNSIGNED ( arg'length - 1 downto 0 );
    variable Result : std_ulogic := '0';    -- In the case of a NULL range
  BEGIN
    if (arg'LENGTH >= 1) then
      BUS_int := to_ux01 (arg);
      if ( BUS_int'length = 1 ) then
        Result := BUS_int ( BUS_int'left );
      elsif ( BUS_int'length = 2 ) then
        Result := "or" (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
        Upper := or_reduce ( BUS_int ( BUS_int'left downto Half ));
        Lower := or_reduce ( BUS_int ( Half - 1 downto BUS_int'right ));
        Result := "or" (Upper, Lower);
      end if;
    end if;
    return Result;
  end function or_reduce;

  function nor_reduce (arg : SIGNED ) return std_ulogic is
  begin
    RETURN "not"(or_reduce(arg));
  end function nor_reduce;

  function nor_reduce (arg : UNSIGNED ) return std_ulogic is
  begin
    RETURN "not"(or_reduce(arg));
  end function nor_reduce;

  function xor_reduce (arg : SIGNED ) return std_ulogic is
  begin
    return xor_reduce (UNSIGNED ( arg ));
  end function xor_reduce;

  function xor_reduce (arg : UNSIGNED ) return std_ulogic is
    variable Upper, Lower : std_ulogic;
    variable Half : integer;
    variable BUS_int : UNSIGNED ( arg'length - 1 downto 0 );
    variable Result : std_ulogic := '0';    -- In the case of a NULL range
  BEGIN
    if (arg'LENGTH >= 1) then
      BUS_int := to_ux01 (arg);
      if ( BUS_int'length = 1 ) then
        Result := BUS_int ( BUS_int'left );
      elsif ( BUS_int'length = 2 ) then
        Result := "xor" (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
      else
        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
        Upper := xor_reduce ( BUS_int ( BUS_int'left downto Half ));
        Lower := xor_reduce ( BUS_int ( Half - 1 downto BUS_int'right ));
        Result := "xor" (Upper, Lower);
      end if;
    end if;
    return Result;
  end function xor_reduce;

  function xnor_reduce (arg : SIGNED ) return std_ulogic is
  begin
    RETURN "not"(xor_reduce(arg));
  end function xnor_reduce;

  function xnor_reduce (arg : UNSIGNED ) return std_ulogic is
  begin
    RETURN "not"(xor_reduce(arg));
  end function xnor_reduce;

  -- %%% Replace the above with the following 12 functions (New syntax)
--  function "and" ( arg  : SIGNED ) return std_ulogic is
--  begin
--    return and (std_logic_vector ( arg ));
--  end function "and";

--  function "and" ( arg  : UNSIGNED ) return std_ulogic is
--  begin
--    return and (std_logic_vector ( arg ));
--  end function "and";

--  function "nand" ( arg  : SIGNED ) return std_ulogic is
--  begin
--    return nand (std_logic_vector ( arg ));
--  end function "nand";

--  function "nand" ( arg  : UNSIGNED ) return std_ulogic is
--  begin
--    return nand (std_logic_vector ( arg ));
--  end function "nand";
  
--  function "or" ( arg  : SIGNED ) return std_ulogic is
--  begin
--    return or (std_logic_vector ( arg ));
--  end function "or";

--  function "or" ( arg  : UNSIGNED ) return std_ulogic is
--  begin
--    return or (std_logic_vector ( arg ));
--  end function "or";

--  function "nor" ( arg  : SIGNED ) return std_ulogic is
--  begin
--    return nor (std_logic_vector ( arg ));
--  end function "nor";

--  function "nor" ( arg  : UNSIGNED ) return std_ulogic is
--  begin
--    return nor (std_logic_vector ( arg ));
--  end function "nor";

--  function "xor" ( arg  : SIGNED ) return std_ulogic is
--  begin
--    return xor (std_logic_vector ( arg ));
--  end function "xor";

--  function "xor" ( arg  : UNSIGNED ) return std_ulogic is
--  begin
--    return xor (std_logic_vector ( arg ));
--  end function "xor";

--  function "xnor" ( arg  : SIGNED ) return std_ulogic is
--  begin
--    return xnor (std_logic_vector ( arg ));
--  end function "xnor";

--  function "xnor" ( arg  : UNSIGNED ) return std_ulogic is
--  begin
--    return xnor (std_logic_vector ( arg ));
--  end function "xnor";
  
  -- rtl_synthesis off
  -- pragma synthesis_off
  -------------------------------------------------------------------    
  -- TO_STRING
  -------------------------------------------------------------------
  -- Type and constant definitions used to map STD_ULOGIC values 
  -- into/from character values.
  type     MVL9plus is ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-', ERROR);
  type     char_indexed_by_MVL9 is array (STD_ULOGIC) of character;
  type     MVL9_indexed_by_char is array (character) of STD_ULOGIC;
  type     MVL9plus_indexed_by_char is array (character) of MVL9plus;
  constant MVL9_to_char : char_indexed_by_MVL9 := "UX01ZWLH-";
  constant char_to_MVL9 : MVL9_indexed_by_char :=
    ('U' => 'U', 'X' => 'X', '0' => '0', '1' => '1', 'Z' => 'Z',
     'W' => 'W', 'L' => 'L', 'H' => 'H', '-' => '-', others => 'U');
  constant char_to_MVL9plus : MVL9plus_indexed_by_char :=
    ('U' => 'U', 'X' => 'X', '0' => '0', '1' => '1', 'Z' => 'Z',
     'W' => 'W', 'L' => 'L', 'H' => 'H', '-' => '-', others => ERROR);

  constant NBSP : character := character'val(160);  -- space character
  constant NUS : string(2 to 1)   := (others => ' ');  -- NULL array

  function justify (
    value     : STRING;
    justified : SIDE  := right;
    field     : width := 0)
    return STRING is
    constant VAL_LEN : INTEGER             := value'length;
    variable result  : STRING (1 to field) := (others => ' ');
  begin  -- function justify
    -- return value if field is too small
    if VAL_LEN >= field then
      return value;
    end if;
    if justified = left then
      result(1 to VAL_LEN) := value;
    elsif justified = right then
      result(field - VAL_LEN + 1 to field) := value;
    end if;
    return result;
  end function justify;
  
  function to_string (
    value     : in signed;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
    alias ivalue    : signed(1 to value'length) is value;
    variable result : string(1 to value'length);
  begin
    if value'length < 1 then
      return NUS;
    else
      for i in ivalue'range loop
        result(i) := MVL9_to_char( iValue(i) );
      end loop;
      return justify(result, justified, field);
    end if;
  end function to_string;

  function to_bstring (
    value     : in SIGNED;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return STRING is
  begin
    return to_string (value, justified, field);
  end function to_bstring;
  
  function to_hstring (
    value     : in signed;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
    constant ne     : integer  := (value'length+3)/4;
    variable pad    : std_logic_vector(0 to (ne*4 - value'length) - 1);
    variable ivalue : std_logic_vector(0 to ne*4 - 1);
    variable result : string(1 to ne);
    variable quad   : std_logic_vector(0 to 3);
  begin
    if value'length < 1 then
      return NUS;
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => value(value'high));  -- Extend sign bit
      end if;
      ivalue := pad & std_logic_vector (value);
      for i in 0 to ne-1 loop
        quad := To_X01Z(ivalue(4*i to 4*i+3));
        case quad is
          when x"0"   => result(i+1) := '0';
          when x"1"   => result(i+1) := '1';
          when x"2"   => result(i+1) := '2';
          when x"3"   => result(i+1) := '3';
          when x"4"   => result(i+1) := '4';
          when x"5"   => result(i+1) := '5';
          when x"6"   => result(i+1) := '6';
          when x"7"   => result(i+1) := '7';
          when x"8"   => result(i+1) := '8';
          when x"9"   => result(i+1) := '9';
          when x"A"   => result(i+1) := 'A';
          when x"B"   => result(i+1) := 'B';
          when x"C"   => result(i+1) := 'C';
          when x"D"   => result(i+1) := 'D';
          when x"E"   => result(i+1) := 'E';
          when x"F"   => result(i+1) := 'F';
          when "ZZZZ" => result(i+1) := 'Z';
          when others => result(i+1) := 'X';
        end case;
      end loop;
      return justify(result, justified, field);
    end if;
  end function to_hstring;

  function to_ostring (
    value     : in signed;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
    constant ne     : integer := (value'length+2)/3;
    variable pad    : std_logic_vector(0 to (ne*3 - value'length) - 1);
    variable ivalue : std_logic_vector(0 to ne*3 - 1);
    variable result : string(1 to ne);
    variable tri    : std_logic_vector(0 to 2);
  begin
    if value'length < 1 then
      return NUS;
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => value (value'high));  -- Extend sign bit
      end if;
      ivalue := pad & std_logic_vector (value);
      for i in 0 to ne-1 loop
        tri := To_X01Z(ivalue(3*i to 3*i+2));
        case tri is
          when o"0"   => result(i+1) := '0';
          when o"1"   => result(i+1) := '1';
          when o"2"   => result(i+1) := '2';
          when o"3"   => result(i+1) := '3';
          when o"4"   => result(i+1) := '4';
          when o"5"   => result(i+1) := '5';
          when o"6"   => result(i+1) := '6';
          when o"7"   => result(i+1) := '7';
          when "ZZZ"  => result(i+1) := 'Z';
          when others => result(i+1) := 'X';
        end case;
      end loop;
      return justify(result, justified, field);
    end if;
  end function to_ostring;

  function to_string (
    value     : in UNSIGNED;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
  begin
    return to_string(
      value     => SIGNED (value),
      justified => justified,
      field     => field);
  end function to_string;

  function to_bstring (
    value     : in UNSIGNED;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return STRING is
  begin
    return to_string (value, justified, field);
  end function to_bstring;
  
  function to_hstring (
    value     : in UNSIGNED;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
    constant ne     : integer  := (value'length+3)/4;
    variable pad    : std_logic_vector(0 to (ne*4 - value'length) - 1);
    variable ivalue : std_logic_vector(0 to ne*4 - 1);
    variable result : string(1 to ne);
    variable quad   : std_logic_vector(0 to 3);
  begin
    if value'length < 1 then
      return NUS;
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => '0');
      end if;
      ivalue := pad & std_logic_vector (value);
      for i in 0 to ne-1 loop
        quad := To_X01Z(ivalue(4*i to 4*i+3));
        case quad is
          when x"0"   => result(i+1) := '0';
          when x"1"   => result(i+1) := '1';
          when x"2"   => result(i+1) := '2';
          when x"3"   => result(i+1) := '3';
          when x"4"   => result(i+1) := '4';
          when x"5"   => result(i+1) := '5';
          when x"6"   => result(i+1) := '6';
          when x"7"   => result(i+1) := '7';
          when x"8"   => result(i+1) := '8';
          when x"9"   => result(i+1) := '9';
          when x"A"   => result(i+1) := 'A';
          when x"B"   => result(i+1) := 'B';
          when x"C"   => result(i+1) := 'C';
          when x"D"   => result(i+1) := 'D';
          when x"E"   => result(i+1) := 'E';
          when x"F"   => result(i+1) := 'F';
          when "ZZZZ" => result(i+1) := 'Z';
          when others => result(i+1) := 'X';
        end case;
      end loop;
      return justify(result, justified, field);
    end if;
  end function to_hstring;

  function to_ostring (
    value     : in UNSIGNED;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
    constant ne     : integer := (value'length+2)/3;
    variable pad    : std_logic_vector(0 to (ne*3 - value'length) - 1);
    variable ivalue : std_logic_vector(0 to ne*3 - 1);
    variable result : string(1 to ne);
    variable tri    : std_logic_vector(0 to 2);
  begin
    if value'length < 1 then
      return NUS;
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => '0');
      end if;
      ivalue := pad & std_logic_vector (value);
      for i in 0 to ne-1 loop
        tri := To_X01Z(ivalue(3*i to 3*i+2));
        case tri is
          when o"0"   => result(i+1) := '0';
          when o"1"   => result(i+1) := '1';
          when o"2"   => result(i+1) := '2';
          when o"3"   => result(i+1) := '3';
          when o"4"   => result(i+1) := '4';
          when o"5"   => result(i+1) := '5';
          when o"6"   => result(i+1) := '6';
          when o"7"   => result(i+1) := '7';
          when "ZZZ"  => result(i+1) := 'Z';
          when others => result(i+1) := 'X';
        end case;
      end loop;
      return justify(result, justified, field);
    end if;
  end function to_ostring;

  -----------------------------------------------------------------------------
  -- Read and Write routines
  -----------------------------------------------------------------------------
  procedure WRITE (
    L         : inout line;             -- input line
    VALUE     : in    signed;           -- fixed point input
    JUSTIFIED : in    SIDE  := RIGHT;
    FIELD     : in    WIDTH := 0) is
    variable s : string(1 to value'length);
    variable m : signed(1 to value'length) := value;
  begin
    for i in 1 to value'length loop
      s(i) := MVL9_to_char(m(i));
    end loop;
    write(l, s, justified, field);
  end procedure WRITE;
  
  procedure READ(L     : inout LINE;
                 VALUE : out   signed) is
    variable m    : STD_ULOGIC;
    variable c    : character;
    variable readOk : BOOLEAN;
    variable s    : string(1 to value'length-1);
    variable mv   : STD_LOGIC_VECTOR(0 to value'length-1);
  begin
    VALUE (VALUE'range) := (others => 'U');
    loop                                -- skip white space
      read(l, c, readOk);
      exit when ((readOk = false) or ((c /= ' ') and (c /= CR) and (c /= HT)));
    end loop;
    if readOk = false then            -- Bail out if there was a bad read
      report "STD_LOGIC_1164.READ(STD_ULOGIC_VECTOR) "
        & "Error end of string encountered"
        severity error;
      return;
    elsif char_to_MVL9plus(c) = ERROR then
      report
        "STD_LOGIC_1164.READ(STD_ULOGIC_VECTOR) Error: Character '" & 
        c & "' read, expected STD_ULOGIC literal."
        severity error;
      return;
    end if;
    read(l, s, readOk);
    if readOk then
    for i in 1 to value'length-1 loop
      if char_to_MVL9plus(s(i)) = ERROR then
        report
          "STD_LOGIC_1164.READ(STD_ULOGIC_VECTOR) Error: Character '" &
          s(i) & "' read, expected STD_ULOGIC literal."
          severity error;
        return;
      end if;
    end loop;
   else
      report "STD_LOGIC_1164.READ(STD_ULOGIC_VECTOR) "
        & "Error end of string encountered"
        severity error;
      return;
    end if;
    mv(0) := char_to_MVL9(c);
    for i in 1 to value'length-1 loop
      mv(i) := char_to_MVL9(s(i));
    end loop;
    value := signed(mv);
  end procedure READ;

  procedure READ(L     : inout LINE;
                 VALUE : out   signed;
                 GOOD  : out   BOOLEAN) is
    variable m    : STD_ULOGIC;
    variable c    : character;
    variable s    : string(1 to value'length-1);
    variable mv   : STD_LOGIC_VECTOR(0 to value'length-1);
    variable readOk : BOOLEAN;
  begin
    VALUE (VALUE'range) := (others => 'U');
    loop                                -- skip white space
      read(l, c, readOk);
      exit when (readOk = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not readOk then
      good := FALSE;
      return;
    end if;
    if char_to_MVL9plus(c) = ERROR then
      good  := FALSE;
      return;
    end if;
    read(l, s, readOk);
    -- Bail out if there was a bad read
    if not readOk then
      good := FALSE;
      return;
    end if;
    for i in 1 to value'length-1 loop
      if char_to_MVL9plus(s(i)) = ERROR then
        good  := FALSE;
        return;
      end if;
    end loop;
    mv(0) := char_to_MVL9(c);
    for i in 1 to value'length-1 loop
      mv(i) := char_to_MVL9(s(i));
    end loop;
    value := signed(mv);
    good  := TRUE;
  end procedure READ;

  procedure WRITE (
    L         : inout line;             -- input line
    VALUE     : in    UNSIGNED;         -- fixed point input
    JUSTIFIED : in    SIDE  := RIGHT;
    FIELD     : in    WIDTH := 0) is
    variable s : string(1 to value'length);
    variable m : UNSIGNED(1 to value'length) := value;
  begin
    for i in 1 to value'length loop
      s(i) := MVL9_to_char(m(i));
    end loop;
    write(l, s, justified, field);
  end procedure WRITE;
  
  procedure READ(L     : inout LINE;
                 VALUE : out   UNSIGNED) is
    variable m    : STD_LOGIC;
    variable c    : character;
    variable readOk : BOOLEAN;
    variable s    : string(1 to value'length-1);
    variable mv   : STD_LOGIC_VECTOR(0 to value'length-1);
  begin
    VALUE (VALUE'range) := (others => 'U');
    loop                                -- skip white space
      read(l, c, readOk);
      exit when ((readOk = false) or ((c /= ' ') and (c /= CR) and (c /= HT)));
    end loop;
    if readOk = false then            -- Bail out if there was a bad read
      report "STD_LOGIC_1164.READ(STD_ULOGIC_VECTOR) "
        & "Error end of string encountered"
        severity error;
      return;
    elsif char_to_MVL9plus(c) = ERROR then
      report
        "STD_LOGIC_1164.READ(STD_ULOGIC_VECTOR) Error: Character '" & 
        c & "' read, expected STD_ULOGIC literal."
        severity error;
      return;
    end if;
    read(l, s, readOk);
    if readOk then
    for i in 1 to value'length-1 loop
      if char_to_MVL9plus(s(i)) = ERROR then
        report
          "STD_LOGIC_1164.READ(STD_ULOGIC_VECTOR) Error: Character '" &
          s(i) & "' read, expected STD_ULOGIC literal."
          severity error;
        return;
      end if;
    end loop;
   else
      report "STD_LOGIC_1164.READ(STD_ULOGIC_VECTOR) "
        & "Error end of string encountered"
        severity error;
      return;
    end if;
    mv(0) := char_to_MVL9(c);
    for i in 1 to value'length-1 loop
      mv(i) := char_to_MVL9(s(i));
    end loop;
    value := UNSIGNED(mv);
  end procedure READ;

  procedure READ(L     : inout LINE;
                 VALUE : out   UNSIGNED;
                 GOOD  : out   BOOLEAN) is
    variable m    : STD_LOGIC;
    variable c    : character;
    variable s    : string(1 to value'length-1);
    variable mv   : STD_LOGIC_VECTOR(0 to value'length-1);
    variable readOk : BOOLEAN;
  begin
    VALUE (VALUE'range) := (others => 'U');
    loop                                -- skip white space
      read(l, c, readOk);
      exit when (readOk = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not readOk then
      good := FALSE;
      return;
    end if;
    if char_to_MVL9plus(c) = ERROR then
      good  := FALSE;
      return;
    end if;
    read(l, s, readOk);
    -- Bail out if there was a bad read
    if not readOk then
      good := FALSE;
      return;
    end if;
    for i in 1 to value'length-1 loop
      if char_to_MVL9plus(s(i)) = ERROR then
        good  := FALSE;
        return;
      end if;
    end loop;
    mv(0) := char_to_MVL9(c);
    for i in 1 to value'length-1 loop
      mv(i) := char_to_MVL9(s(i));
    end loop;
    value := UNSIGNED(mv);
    good  := TRUE;
  end procedure READ;

  procedure BWRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    SIGNED;           -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0) is
  begin
    WRITE (L, VALUE, JUSTIFIED, FIELD);
  end procedure BWRITE;

  procedure BREAD(L     : inout LINE;
                 VALUE : out   SIGNED) is
  begin
    READ (L, VALUE);
  end procedure BREAD;

  procedure BREAD(L     : inout LINE;
                 VALUE : out   SIGNED;
                 GOOD  : out   BOOLEAN) is
  begin
    READ (L, VALUE, GOOD);
  end procedure BREAD;

  procedure BWRITE (
    L         : inout LINE;             -- input line
    VALUE     : in    UNSIGNED;         -- fixed point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0) is
  begin
    WRITE (L, VALUE, JUSTIFIED, FIELD);
  end procedure BWRITE;

  procedure BREAD(L     : inout LINE;
                 VALUE : out   UNSIGNED) is
  begin
    READ (L, VALUE);
  end procedure BREAD;

  procedure BREAD(L     : inout LINE;
                 VALUE : out   UNSIGNED;
                 GOOD  : out   BOOLEAN) is
  begin
    READ (L, VALUE, GOOD);
  end procedure BREAD;
  -- Hex Read and Write procedures for STD_ULOGIC_VECTOR.
  -- Modified from the original to be more forgiving.

  procedure Char2QuadBits (C           :     Character;
                           RESULT      : out std_ulogic_vector(3 downto 0);
                           GOOD        : out Boolean;
                           ISSUE_ERROR : in  Boolean) is
  begin
    case c is
      when '0'       => result := x"0"; good := TRUE;
      when '1'       => result := x"1"; good := TRUE;
      when '2'       => result := x"2"; good := TRUE;
      when '3'       => result := x"3"; good := TRUE;
      when '4'       => result := x"4"; good := TRUE;
      when '5'       => result := x"5"; good := TRUE;
      when '6'       => result := x"6"; good := TRUE;
      when '7'       => result := x"7"; good := TRUE;
      when '8'       => result := x"8"; good := TRUE;
      when '9'       => result := x"9"; good := TRUE;
      when 'A' | 'a' => result := x"A"; good := TRUE;
      when 'B' | 'b' => result := x"B"; good := TRUE;
      when 'C' | 'c' => result := x"C"; good := TRUE;
      when 'D' | 'd' => result := x"D"; good := TRUE;
      when 'E' | 'e' => result := x"E"; good := TRUE;
      when 'F' | 'f' => result := x"F"; good := TRUE;
      when 'Z'       => result := "ZZZZ"; good := TRUE;
      when 'X'       => result := "XXXX"; good := TRUE;
      when others    =>
        assert not ISSUE_ERROR
          report
            "STD_LOGIC_1164.OREAD Error: Read a '" & c &
            "', expected an Octal character (0-7)."
            severity error;
        good := FALSE;
    end case;
  end procedure Char2QuadBits;
  
  procedure HWRITE (
    L         : inout line;             -- input line
    VALUE     : in    signed;
    JUSTIFIED : in    SIDE  := RIGHT;
    FIELD     : in    WIDTH := 0) is
  begin
    WRITE ( L         => L,
             VALUE     => to_hstring(VALUE),
             JUSTIFIED => JUSTIFIED,
             FIELD     => FIELD);
  end procedure HWRITE;
  
  procedure HREAD(L     : inout LINE;
                  VALUE : out   signed) is
    constant ne : INTEGER := (value'length+3)/4;
    constant pad : INTEGER := ne*4 - value'length;
    variable ivalue : unsigned(0 to ne*4-1);
  begin
    HREAD ( L     => L,
            VALUE => ivalue);           -- Read padded string
    if (pad > 0) then
      if (to_X01(ivalue(0)) = '0') then  -- positive
        if to_X01(ivalue(0)) = or_reduce(ivalue(0 to pad)) then
          VALUE := SIGNED (ivalue (pad to ivalue'high));
        else
          assert false
            report "NUMERIC_STD.HREAD Error: Signed vector truncated"
            severity error;
        end if;
      else        -- negative
        if to_X01(ivalue(0)) = and_reduce(ivalue(0 to pad)) then
          VALUE := SIGNED (ivalue (pad to ivalue'high));
        else
          assert false
            report "NUMERIC_STD.HREAD Error: Signed vector truncated"
            severity error;
        end if;
      end if;
    else
      VALUE := signed (ivalue);
    end if;
  end procedure HREAD;

  procedure HREAD(L     : inout LINE;
                  VALUE : out   signed;
                  GOOD  : out   BOOLEAN) is
    constant ne : INTEGER := (value'length+3)/4;
    constant pad : INTEGER := ne*4 - value'length;
    variable ivalue : UNSIGNED(0 to ne*4-1);
    variable ok : BOOLEAN;
  begin
    HREAD ( L     => L,
            VALUE => ivalue,           -- Read padded STRING
            good => ok);
    if not ok then
      good := FALSE;
      return;
    end if;
    if (pad > 0) then
      if (to_X01(ivalue(0)) = '0') then  -- positive
        if to_X01(ivalue(0)) = or_reduce(ivalue(0 to pad)) then
          GOOD := true;
          VALUE := SIGNED (ivalue (pad to ivalue'high));
        else
          GOOD := false;
        end if;
      else        -- negative
        if to_X01(ivalue(0)) = and_reduce(ivalue(0 to pad)) then
          GOOD := true;
          VALUE := SIGNED (ivalue (pad to ivalue'high));
        else
          GOOD := false;
        end if;
      end if;
    else
      GOOD := true;
      VALUE := signed (ivalue);
    end if;
  end procedure HREAD;

  procedure HWRITE (
    L         : inout line;             -- input line
    VALUE     : in    UNSIGNED;
    JUSTIFIED : in    SIDE  := RIGHT;
    FIELD     : in    WIDTH := 0) is
  begin
    WRITE ( L         => L,
             VALUE     => to_hstring(VALUE),
             JUSTIFIED => JUSTIFIED,
             FIELD     => FIELD);
  end procedure HWRITE;
  
  procedure HREAD(L     : inout LINE;
                  VALUE : out   UNSIGNED) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (value'length+3)/4;
    constant pad : INTEGER := ne*4 - value'length;
    variable sv : std_ulogic_vector(0 to ne*4 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');
    loop                                -- skip white space
      read(l, c, ok);
      exit when (ok = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
      report "STD_LOGIC_1164.HREAD Error: Failed skipping white space"
        severity error;
      return;
    end if;
    Char2QuadBits(c, sv(0 to 3), ok, TRUE);
    if not ok then
      return;
    end if;
    read(L, s, ok);
    if not ok then
      report "STD_LOGIC_1164.HREAD Error: Failed to read the STRING"
        severity error;
      return;
    end if;
    for i in 1 to ne-1 loop
      Char2QuadBits(s(i), sv(4*i to 4*i+3), ok, TRUE);
      if not ok then
        return;
      end if;
    end loop;
    value := UNSIGNED(to_StdLogicVector(sv (pad to sv'high)));
    if or_reduce (UNSIGNED(sv (0 to pad-1))) = '1' then  -- %%% replace with "or"
      report "STD_LOGIC_1164.HREAD Error: Vector truncated"
        severity error;
    end if;
  end procedure HREAD;

  procedure HREAD(L     : inout LINE;
                  VALUE : out   UNSIGNED;
                  GOOD  : out   BOOLEAN) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (value'length+3)/4;
    constant pad : INTEGER := ne*4 - value'length;
    variable sv : std_ulogic_vector(0 to ne*4 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');
    loop                                -- skip white space
      read(l, c, ok);
      exit when (ok = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
      good := FALSE;
      return;
    end if;
    Char2QuadBits(c, sv(0 to 3), ok, FALSE);
    if not ok then
      good := FALSE;
      return;
    end if;
    read(L, s, ok);
    if not ok then
      good := FALSE;
      return;
    end if;
    for i in 1 to ne-1 loop
      Char2QuadBits(s(i), sv(4*i to 4*i+3), ok, FALSE);
      if not ok then
        good := FALSE;
        return;
      end if;
    end loop;
    if or_reduce (unsigned(sv (0 to pad-1))) = '1' then  -- %%% replace with "or"
      good := false;                    -- vector was truncated.
    else
      value := unsigned(to_stdlogicvector(sv (pad to sv'high)));
      good := true;
    end if;
  end procedure HREAD;

    -- Octal Read and Write procedures for STD_ULOGIC_VECTOR.
  -- Modified from the original to be more forgiving.

  procedure Char2TriBits (C           :     Character;
                          RESULT      : out std_ulogic_vector(2 downto 0);
                          GOOD        : out Boolean;
                          ISSUE_ERROR : in  Boolean) is
  begin
    case c is
      when '0'    => result := o"0"; good := TRUE;
      when '1'    => result := o"1"; good := TRUE;
      when '2'    => result := o"2"; good := TRUE;
      when '3'    => result := o"3"; good := TRUE;
      when '4'    => result := o"4"; good := TRUE;
      when '5'    => result := o"5"; good := TRUE;
      when '6'    => result := o"6"; good := TRUE;
      when '7'    => result := o"7"; good := TRUE;
      when 'Z'    => result := "ZZZ"; good := TRUE;
      when 'X'    => result := "XXX"; good := TRUE;
      when others =>
        assert not ISSUE_ERROR
          report
            "STD_LOGIC_1164.OREAD Error: Read a '" & c &
            "', expected an Octal character (0-7)."
          severity error;
        good := FALSE;
    end case;
  end procedure Char2TriBits;

  procedure OWRITE (
    L         : inout line;             -- input line
    VALUE     : in    signed;
    JUSTIFIED : in    SIDE  := RIGHT;
    FIELD     : in    WIDTH := 0) is
  begin
    WRITE ( L         => L,
             VALUE     => to_ostring(VALUE),
             JUSTIFIED => JUSTIFIED,
             FIELD     => FIELD);
  end procedure OWRITE;
  
  procedure OREAD(L     : inout LINE;
                  VALUE : out   signed) is
    constant ne : INTEGER := (value'length+2)/3;
    constant pad : INTEGER := ne*3 - value'length;
    variable ivalue : UNSIGNED (0 to ne*3-1);
  begin
    OREAD ( L     => L,
            VALUE => ivalue);           -- Read padded string
    if (pad > 0) then
      if (to_X01(ivalue(0)) = '0') then  -- positive
        if to_X01(ivalue(0)) = or_reduce(ivalue(0 to pad)) then
          VALUE := SIGNED (ivalue (pad to ivalue'high));
        else
          report "NUMERIC_STD.OREAD Error: Signed vector truncated"
            severity error;
        end if;
      else        -- negative
        if to_X01(ivalue(0)) = and_reduce(ivalue(0 to pad)) then
          VALUE := SIGNED (ivalue (pad to ivalue'high));
        else
          report "NUMERIC_STD.OREAD Error: Signed vector truncated"
            severity error;
        end if;
      end if;
    else
      VALUE := signed (ivalue);
    end if;
  end procedure OREAD;

  procedure OREAD(L     : inout LINE;
                  VALUE : out   signed;
                  GOOD  : out   BOOLEAN) is
    constant ne : INTEGER := (value'length+2)/3;
    constant pad : INTEGER := ne*3 - value'length;
    variable ivalue : UNSIGNED (0 to ne*3-1);
    variable ok : BOOLEAN;
  begin
    OREAD ( L     => L,
            VALUE => ivalue,           -- Read padded STRING
            good => ok);
    -- Bail out if there was a bad read
    if not ok then
      good := FALSE;
      return;
    end if;
    if (pad > 0) then
      if (to_X01(ivalue(0)) = '0') then  -- positive
        if to_X01(ivalue(0)) = or_reduce(ivalue(0 to pad)) then
          VALUE := SIGNED (ivalue (pad to ivalue'high));
          good := true;
        else
          good := false;
        end if;
      else        -- negative
        if to_X01(ivalue(0)) = and_reduce(ivalue(0 to pad)) then
          VALUE := SIGNED (ivalue (pad to ivalue'high));
          good := true;
        else
          good := false;
        end if;
      end if;
    else
      good := true;
      VALUE := signed (ivalue);
    end if;
  end procedure OREAD;

  procedure OWRITE (
    L         : inout line;             -- input line
    VALUE     : in    UNSIGNED;
    JUSTIFIED : in    SIDE  := RIGHT;
    FIELD     : in    WIDTH := 0) is
  begin
    WRITE ( L         => L,
             VALUE     => to_ostring(VALUE),
             JUSTIFIED => JUSTIFIED,
             FIELD     => FIELD);
  end procedure OWRITE;
  
  procedure OREAD(L     : inout LINE;
                  VALUE : out   UNSIGNED) is
    variable c  : character;
    variable ok : boolean;
    constant ne : INTEGER := (value'length+2)/3;
    constant pad : INTEGER := ne*3 - value'length;
    variable sv : std_ulogic_vector(0 to ne*3 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');
    loop                                -- skip white space
      read(l, c, ok);
      exit when (ok = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
        report "STD_LOGIC_1164.OREAD Error: Failed skipping white space"
        severity error;
      return;
    end if;
    Char2TriBits(c, sv(0 to 2), ok, TRUE);
    if not ok then
      return;
    end if;
    read(L, s, ok);
    if not ok then
        report "STD_LOGIC_1164.OREAD Error: Failed to read the STRING"
        severity error;
      return;
    end if;
    for i in 1 to ne-1 loop
      Char2TriBits(s(i), sv(3*i to 3*i+2), ok, TRUE);
      if not ok then
        return;
      end if;
    end loop;
    value := unsigned (to_stdlogicvector (sv (pad to sv'high)));
    if or_reduce (unsigned(sv (0 to pad-1))) = '1' then -- %%% replace with "or"
        report "STD_LOGIC_1164.OREAD Error: Vector truncated"
        severity error;
    end if;
  end procedure OREAD;

  procedure OREAD(L     : inout LINE;
                  VALUE : out   UNSIGNED;
                  GOOD  : out   BOOLEAN) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (value'length+2)/3;
    constant pad : INTEGER := ne*3 - value'length;
    variable sv : std_ulogic_vector(0 to ne*3 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE(VALUE'range) := (others => 'U');
    loop                                -- skip white space
      read(l, c, ok);
      exit when (ok = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
      good := FALSE;
      return;
    end if;
    Char2TriBits(c, sv(0 to 2), ok, FALSE);
    if not ok then
      good := FALSE;
      return;
    end if;
    read(L, s, ok);
    if not ok then
      good := FALSE;
      return;
    end if;
    for i in 1 to ne-1 loop
      Char2TriBits(s(i), sv(3*i to 3*i+2), ok, FALSE);
      if not ok then
        good := FALSE;
        return;
      end if;
    end loop;
    value := unsigned (to_stdlogicvector (sv (pad to sv'high)));
    if or_reduce (unsigned(sv (0 to pad-1))) = '1' then -- %%% replace with "or"
      good := false;                    -- vector was truncated.
    else
      good := true;
    end if;
  end procedure OREAD;

  -- rtl_synthesis on
  -- pragma synthesis_on
end package body numeric_std_additions;
