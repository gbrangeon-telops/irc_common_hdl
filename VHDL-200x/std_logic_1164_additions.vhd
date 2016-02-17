------------------------------------------------------------------------------
-- "std_logic_1164_additions" package contains the additions to the standard
-- "std_logic_1164" package proposed by the VHDL-200X-ft working group.
-- This package should be compiled into "ieee_proposed" and used as follows:
-- use ieee.std_logic_1164.all;
-- use ieee_proposed.std_logic_1164_additions.all;
-- Last Modified: $Date: 2006-03-22 15:52:00-05 $
-- RCS ID: $Id: std_logic_1164_additions.vhd,v 1.7 2006-03-22 15:52:00-05 l435385 Exp $
--
--  Created for VHDL-200X par, David Bishop (dbishop@vhdl.org)
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
package std_logic_1164_additions is

  -- new aliases
--  alias to_bv is ieee.std_logic_1164.To_bitvector [std_logic_vector, bit return bit_vector] ;
--  alias to_bv is ieee.std_logic_1164.To_bitvector [std_ulogic_vector, bit return bit_vector] ;
--  alias to_bit_vector is ieee.std_logic_1164.To_bitvector [std_logic_vector, bit return bit_vector] ;
--  alias to_bit_vector is ieee.std_logic_1164.To_bitvector [std_ulogic_vector, bit return bit_vector] ;
--    alias to_slv is ieee.std_logic_1164.To_StdLogicVector [BIT_VECTOR return std_logic_vector] ;
--  alias to_slv is ieee.std_logic_1164.To_StdLogicVector [std_ulogic_vector return std_logic_vector] ;
--  alias to_std_logic_vector is ieee.std_logic_1164.To_StdLogicVector [BIT_VECTOR return std_logic_vector] ;
--  alias to_std_logic_vector is ieee.std_logic_1164.To_StdLogicVector [std_ulogic_vector return std_logic_vector] ;
--  alias to_sulv is ieee.std_logic_1164.To_StdULogicVector [BIT_VECTOR return std_ulogic_vector] ;
--  alias to_sulv is ieee.std_logic_1164.To_StdULogicVector [std_logic_vector return std_ulogic_vector] ;
--  alias to_std_ulogic_vector is ieee.std_logic_1164.To_StdULogicVector [BIT_VECTOR return std_ulogic_vector] ;
--  alias to_std_ulogic_vector is ieee.std_logic_1164.To_StdULogicVector [std_logic_vector return std_ulogic_vector] ;
  
  -- Done as functions because some tools don't like the alias syntax
  function to_bv ( s : std_logic_vector; xmap : BIT  := '0') RETURN BIT_VECTOR;
  function to_bv ( s : std_ulogic_vector; xmap : BIT := '0') RETURN BIT_VECTOR ;
  function to_bit_vector ( s : std_logic_vector; xmap : BIT := '0') RETURN BIT_VECTOR;
  function to_bit_vector ( s : std_ulogic_vector; xmap : BIT := '0') RETURN BIT_VECTOR;
  function to_slv ( b  : BIT_VECTOR ) RETURN std_logic_vector;
  function to_slv ( s  : std_ulogic_vector ) RETURN std_logic_vector ;
  function to_std_logic_vector ( b  : BIT_VECTOR ) RETURN std_logic_vector;
  function to_std_logic_vector ( s  : std_ulogic_vector ) RETURN std_logic_vector ;
  function to_sulv ( b : BIT_VECTOR ) RETURN std_ulogic_vector;
  function to_sulv ( s : std_logic_vector ) RETURN std_ulogic_vector ;
  function to_std_ulogic_vector ( b : BIT_VECTOR ) RETURN std_ulogic_vector;
  function to_std_ulogic_vector ( s : std_logic_vector ) RETURN std_ulogic_vector;
  -------------------------------------------------------------------    
  -- overloaded shift operators
  ------------------------------------------------------------------- 

  function "sll" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector;
  function "sll" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector;

  function "srl" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector;
  function "srl" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector;

  function "rol" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector;
  function "rol" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector;

  function "ror" ( l  : std_logic_vector;  r : integer ) RETURN std_logic_vector;
  function "ror" ( l  : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector;
  -------------------------------------------------------------------
  -- vector/scalar overloaded logical operators
  -------------------------------------------------------------------
  FUNCTION "and"  ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector;
  FUNCTION "and"  ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector;
  FUNCTION "and"  ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector;
  FUNCTION "and"  ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector;
  FUNCTION "nand" ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector;
  FUNCTION "nand" ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector;
  FUNCTION "nand" ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector;
  FUNCTION "nand" ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector;
  FUNCTION "or"   ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector;
  FUNCTION "or"   ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector;
  FUNCTION "or"   ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector;
  FUNCTION "or"   ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector;
  FUNCTION "nor"  ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector;
  FUNCTION "nor"  ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector;
  FUNCTION "nor"  ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector;
  FUNCTION "nor"  ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector;
  FUNCTION "xor"  ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector;
  FUNCTION "xor"  ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector;
  FUNCTION "xor"  ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector;
  FUNCTION "xor"  ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector;
  FUNCTION "xnor" ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector;
  FUNCTION "xnor" ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector;
  FUNCTION "xnor" ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector;
  FUNCTION "xnor" ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector;
  -----------------------------------------------------------------------------
  -- std_ulogic and boolean functions
  -----------------------------------------------------------------------------
  function "and"  (L: std_ulogic; R: boolean) return std_ulogic;
  function "and"  (L: boolean; R: std_ulogic) return std_ulogic;
  function "or"   (L: std_ulogic; R: boolean) return std_ulogic;
  function "or"   (L: boolean; R: std_ulogic) return std_ulogic;
  function "xor"  (L: std_ulogic; R: boolean) return std_ulogic;
  function "xor"  (L: boolean; R: std_ulogic) return std_ulogic;
  function "nand" (L: std_ulogic; R: boolean) return std_ulogic;
  function "nand" (L: boolean; R: std_ulogic) return std_ulogic;
  function "nor"  (L: std_ulogic; R: boolean) return std_ulogic;
  function "nor"  (L: boolean; R: std_ulogic) return std_ulogic;
  function "xnor" (L: std_ulogic; R: boolean) return std_ulogic;
  function "xnor" (L: boolean; R: std_ulogic) return std_ulogic;
  -------------------------------------------------------------------
  -- vector-reduction functions.
  -- "and" functions default to "1", or defaults to "0"
  -------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- %%% Replace the "_reduce" functions with the ones commented out below.
  -----------------------------------------------------------------------------
  -- function "and" ( arg  : std_logic_vector ) RETURN std_ulogic;
  -- function "and" ( arg  : std_ulogic_vector ) RETURN std_ulogic; 
  -- function "nand" ( arg  : std_logic_vector ) RETURN std_ulogic;
  -- function "nand" ( arg  : std_ulogic_vector ) RETURN std_ulogic;
  -- function "or" ( arg  : std_logic_vector ) RETURN std_ulogic;
  -- function "or" ( arg  : std_ulogic_vector ) RETURN std_ulogic;
  -- function "nor" ( arg  : std_logic_vector ) RETURN std_ulogic;
  -- function "nor" ( arg  : std_ulogic_vector ) RETURN std_ulogic;
  -- function "xor" ( arg  : std_logic_vector ) RETURN std_ulogic;
  -- function "xor" ( arg  : std_ulogic_vector ) RETURN std_ulogic;
  -- function "xnor" ( arg  : std_logic_vector ) RETURN std_ulogic;
  -- function "xnor" ( arg  : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION and_reduce ( arg  : std_logic_vector ) RETURN std_ulogic;
  FUNCTION and_reduce ( arg  : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION nand_reduce ( arg : std_logic_vector ) RETURN std_ulogic;
  FUNCTION nand_reduce ( arg : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION or_reduce ( arg   : std_logic_vector ) RETURN std_ulogic;
  FUNCTION or_reduce ( arg   : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION nor_reduce ( arg  : std_logic_vector ) RETURN std_ulogic;
  FUNCTION nor_reduce ( arg  : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION xor_reduce ( arg  : std_logic_vector ) RETURN std_ulogic;
  FUNCTION xor_reduce ( arg  : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION xnor_reduce ( arg : std_logic_vector ) RETURN std_ulogic;
  FUNCTION xnor_reduce ( arg : std_ulogic_vector ) RETURN std_ulogic;
  -------------------------------------------------------------------
  -- ?= operators, same functionality as 1076.3 1994 std_match
  -------------------------------------------------------------------
--  FUNCTION "?=" ( l, r : std_ulogic ) RETURN std_ulogic;
--  FUNCTION "?=" ( l, r : std_logic_vector ) RETURN std_ulogic;
--  FUNCTION "?=" ( l, r : std_ulogic_vector ) RETURN std_ulogic;
--  FUNCTION "?/=" ( l, r : std_ulogic ) RETURN std_ulogic;
--  FUNCTION "?/=" ( l, r : std_logic_vector ) RETURN std_ulogic;
--  FUNCTION "?/=" ( l, r : std_ulogic_vector ) RETURN std_ulogic;
--  FUNCTION "?>" ( l, r : std_ulogic ) RETURN std_ulogic;
--  FUNCTION "?>" ( l, r : std_logic_vector ) RETURN std_ulogic;
--  FUNCTION "?>" ( l, r : std_ulogic_vector ) RETURN std_ulogic;
--  FUNCTION "?>=" ( l, r : std_ulogic ) RETURN std_ulogic;
--  FUNCTION "?>=" ( l, r : std_logic_vector ) RETURN std_ulogic;
--  FUNCTION "?>=" ( l, r : std_ulogic_vector ) RETURN std_ulogic;
--  FUNCTION "?<" ( l, r : std_ulogic ) RETURN std_ulogic;
--  FUNCTION "?<" ( l, r : std_logic_vector ) RETURN std_ulogic;
--  FUNCTION "?<" ( l, r : std_ulogic_vector ) RETURN std_ulogic;
--  FUNCTION "?<=" ( l, r : std_ulogic ) RETURN std_ulogic;
--  FUNCTION "?<=" ( l, r : std_logic_vector ) RETURN std_ulogic;
--  FUNCTION "?<=" ( l, r : std_ulogic_vector ) RETURN std_ulogic;

  FUNCTION \?=\ ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION \?=\ ( l, r : std_logic_vector ) RETURN std_ulogic;
  FUNCTION \?=\ ( l, r : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION \?/=\ ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION \?/=\ ( l, r : std_logic_vector ) RETURN std_ulogic;
  FUNCTION \?/=\ ( l, r : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION \?>\ ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION \?>\ ( l, r : std_logic_vector ) RETURN std_ulogic;
  FUNCTION \?>\ ( l, r : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION \?>=\ ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION \?>=\ ( l, r : std_logic_vector ) RETURN std_ulogic;
  FUNCTION \?>=\ ( l, r : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION \?<\ ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION \?<\ ( l, r : std_logic_vector ) RETURN std_ulogic;
  FUNCTION \?<\ ( l, r : std_ulogic_vector ) RETURN std_ulogic;
  FUNCTION \?<=\ ( l, r : std_ulogic ) RETURN std_ulogic;
  FUNCTION \?<=\ ( l, r : std_logic_vector ) RETURN std_ulogic;
  FUNCTION \?<=\ ( l, r : std_ulogic_vector ) RETURN std_ulogic;
  
  -- "??" operator, converts a std_ulogic to a boolean.
  --%%% Uncomment the following operators
  -- FUNCTION "??" (S : STD_ULOGIC) RETURN BOOLEAN;
  --%%% REMOVE the following funciton (for testing only)
  FUNCTION \??\ (S : STD_ULOGIC) RETURN BOOLEAN;

  -- rtl_synthesis off
  -- synthesis translate_off
  -----------------------------------------------------------------------------
  -- Read and Write functions copied from "std_logic_textio"
  -----------------------------------------------------------------------------
  -- Read and Write procedures for STD_ULOGIC and STD_ULOGIC_VECTOR

  procedure READ (L : inout LINE; VALUE : out STD_ULOGIC; GOOD : out BOOLEAN);
  procedure READ (L : inout LINE; VALUE : out STD_ULOGIC);

  procedure READ (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  procedure READ (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR);

  procedure WRITE (L : inout LINE; VALUE : in STD_ULOGIC;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

  procedure WRITE (L : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

  -- Read and Write procedures for STD_LOGIC_VECTOR

  procedure READ (L : inout LINE; VALUE : out STD_LOGIC_VECTOR; GOOD : out BOOLEAN);
  procedure READ (L : inout LINE; VALUE : out STD_LOGIC_VECTOR);

  procedure WRITE (L : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

--  alias bread is read [line, STD_ULOGIC, BOOLEAN] ;
--  alias bread is read [line, STD_ULOGIC] ;
--  alias bread is read [line, STD_ULOGIC_VECTOR, BOOLEAN] ;
--  alias bread is read [line, STD_ULOGIC_VECTOR] ;
--  alias bread is read [line, STD_LOGIC_VECTOR, BOOLEAN] ;
--  alias bread is read [line, STD_LOGIC_VECTOR] ;
--  alias bwrite is write [line, STD_ULOGIC, side, width] ;
--  alias bwrite is write [line, STD_ULOGIC_VECTOR, side, width] ;
--  alias bwrite is write [line, STD_LOGIC_VECTOR, side, width] ;

  procedure BREAD (L : inout LINE; VALUE : out STD_ULOGIC; GOOD : out BOOLEAN);
  procedure BREAD (L : inout LINE; VALUE : out STD_ULOGIC);

  procedure BREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  procedure BREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR);
  procedure BREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR; GOOD : out BOOLEAN);
  procedure BREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR);
  procedure BWRITE (L : inout LINE; VALUE : in STD_ULOGIC;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

  procedure BWRITE (L : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0);
  procedure BWRITE (L : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

  -- Read and Write procedures for Hex values

  procedure HREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR; GOOD : out BOOLEAN);
  procedure HREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR);

  procedure HWRITE (L : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
  JUSTIFIED           : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

  procedure HREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR;
  GOOD : out BOOLEAN);
  procedure HREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR);

  procedure HWRITE (L : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  JUSTIFIED           : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

  -- Read and Write procedures for Octal values

  procedure OREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR;
  GOOD : out BOOLEAN);
  procedure OREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR);

  procedure OWRITE (L : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
  JUSTIFIED           : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

  procedure OREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR;
  GOOD : out BOOLEAN);
  procedure OREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR);

  procedure OWRITE (L : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  JUSTIFIED           : in    SIDE := RIGHT; FIELD : in WIDTH := 0);

  --------------------------------------------------------------------------
  -- Converts a std_logic_vector or std_ulogic vector to a string.
  --------------------------------------------------------------------------
  function to_string (
    value     : in STD_ULOGIC;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;

  function to_string (
    value     : in std_ulogic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;

  -- alias to_bstring is to_string [std_ulogic_vector, side, width return string];
  function to_bstring (
    value     : in std_ulogic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;

  function to_hstring (
    value     : in std_ulogic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;

  function to_ostring (
    value     : in std_ulogic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string ;

  function to_string (
    value     : in std_logic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;

  -- alias to_bstring is to_string [std_logic_vector, side, width return string];
  function to_bstring (
    value     : in std_logic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;
  
  function to_hstring (
    value     : in std_logic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string;

  function to_ostring (
    value     : in std_logic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string ;
    
   -- rtl_synthesis on
   -- synthesis translate_on

end package std_logic_1164_additions;

package body std_logic_1164_additions is
  -- alias done as functions
  function to_bv ( s : std_logic_vector; xmap : BIT  := '0')
    RETURN BIT_VECTOR is
  begin
    return To_bitvector (s, xmap);
  end function to_bv;
  function to_bv ( s : std_ulogic_vector; xmap : BIT := '0')
    RETURN BIT_VECTOR is
  begin
    return To_bitvector (s, xmap);
  end function to_bv;
  function to_bit_vector ( s : std_logic_vector; xmap : BIT := '0')
    RETURN BIT_VECTOR is
  begin
    return To_bitvector (s, xmap);
  end function to_bit_vector;
  function to_bit_vector ( s : std_ulogic_vector; xmap : BIT := '0')
    RETURN BIT_VECTOR is
  begin
    return To_bitvector (s, xmap);
  end function to_bit_vector;
  function to_slv ( b  : BIT_VECTOR )
    RETURN STD_LOGIC_VECTOR is
  begin
    return to_StdLogicVector (b);
  end function to_slv;
  function to_slv ( s  : std_ulogic_vector )
    RETURN std_logic_vector  is
  begin
    return to_StdLogicVector (s);
  end function to_slv;
  function to_std_logic_vector ( b  : BIT_VECTOR )
    RETURN std_logic_vector is
  begin
    return to_StdLogicVector (b);
  end function to_std_logic_vector;
  function to_std_logic_vector ( s  : std_ulogic_vector )
    RETURN std_logic_vector  is
  begin
    return to_StdLogicVector (s);
  end function to_std_logic_vector;
  function to_sulv ( b : BIT_VECTOR )
    RETURN std_ulogic_vector is
  begin
    return to_StdULogicVector (b);
  end function to_sulv;
  function to_sulv ( s : std_logic_vector )
    RETURN std_ulogic_vector  is
  begin
    return to_StdULogicVector (s);
  end function to_sulv;
  function to_std_ulogic_vector ( b : BIT_VECTOR )
    RETURN std_ulogic_vector is
  begin
    return to_StdULogicVector (b);
  end function to_std_ulogic_vector;
  function to_std_ulogic_vector ( s : std_logic_vector )
    RETURN std_ulogic_vector is
  begin
    return to_StdULogicVector (s);
  end function to_std_ulogic_vector;

  TYPE stdlogic_table IS ARRAY(std_ulogic, std_ulogic) OF std_ulogic;
  -----------------------------------------------------------------------------
  -- New/updated funcitons for VHDL-200X fast track
  -----------------------------------------------------------------------------
  -------------------------------------------------------------------    
  -- overloaded shift operators
  ------------------------------------------------------------------- 

  -------------------------------------------------------------------    
  -- sll
  -------------------------------------------------------------------    
  FUNCTION "sll" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( l'RANGE ) := (OTHERS => '0');
    ALIAS resultv   : std_logic_vector ( 1 TO l'LENGTH ) IS result;
  BEGIN
    IF r = 0 OR l'LENGTH = 0 THEN
      RETURN l;
    ELSIF r > 0 THEN
      IF r < l'LENGTH THEN
        resultv(1 TO l'LENGTH - r) := lv(r+1 TO l'LENGTH);
      END IF;
      RETURN result;
    ELSE
      RETURN l SRL (-r);
    END IF;
  END FUNCTION "sll";
  -------------------------------------------------------------------    
  FUNCTION "sll" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( l'RANGE ) := (OTHERS => '0');
    ALIAS resultv   : std_ulogic_vector ( 1 TO l'LENGTH ) IS result;
  BEGIN
    IF r = 0 OR l'LENGTH = 0 THEN
      RETURN l;
    ELSIF r > 0 THEN
      IF r < l'LENGTH THEN
        resultv(1 TO l'LENGTH - r) := lv(r+1 TO l'LENGTH);
      END IF;
      RETURN result;
    ELSE
      RETURN l SRL (-r);
    END IF;
  END FUNCTION "sll";

  -------------------------------------------------------------------    
  -- srl
  -------------------------------------------------------------------    
  FUNCTION "srl" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( l'RANGE ) := (OTHERS => '0');
    ALIAS resultv   : std_logic_vector ( 1 TO l'LENGTH ) IS result;
  BEGIN
    IF r = 0 OR l'LENGTH = 0 THEN
      RETURN l;
    ELSIF r > 0 THEN
      IF r < l'LENGTH THEN
        resultv(r+1 TO l'LENGTH) := lv(1 TO l'LENGTH - r);
      END IF;
      RETURN result;
    ELSE
      RETURN l SLL (-r);
    END IF;
  END FUNCTION "srl";
  -------------------------------------------------------------------    
  FUNCTION "srl" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( l'RANGE ) := (OTHERS => '0');
    ALIAS resultv   : std_ulogic_vector ( 1 TO l'LENGTH ) IS result;
  BEGIN
    IF r = 0 OR l'LENGTH = 0 THEN
      RETURN l;
    ELSIF r > 0 THEN
      IF r < l'LENGTH THEN
        resultv(r+1 TO l'LENGTH) := lv(1 TO l'LENGTH - r);
      END IF;
      RETURN result;
    ELSE
      RETURN l SLL (-r);
    END IF;
  END FUNCTION "srl";

  -------------------------------------------------------------------    
  -- rol
  -------------------------------------------------------------------    
  FUNCTION "rol" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( l'RANGE );
    ALIAS resultv   : std_logic_vector ( 1 TO l'LENGTH ) IS result;
    VARIABLE rv     : integer;
  BEGIN
    IF r = 0 OR l'LENGTH = 0 THEN
      RETURN l;
    ELSIF r > 0 THEN
      rv                                     := r MOD l'length;
      resultv(1 TO l'LENGTH - rv )           := lv(rv+1 TO l'LENGTH);
      resultv(l'LENGTH - rv + 1 TO l'length) := lv(1 TO rv);
      RETURN result;
    ELSE
      RETURN l ROR (-r);
    END IF;
  END FUNCTION "rol";
  -------------------------------------------------------------------    
  FUNCTION "rol" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( l'RANGE );
    ALIAS resultv   : std_ulogic_vector ( 1 TO l'LENGTH ) IS result;
    VARIABLE rv     : integer;
  BEGIN
    IF r = 0 OR l'LENGTH = 0 THEN
      RETURN l;
    ELSIF r > 0 THEN
      rv                                     := r MOD l'length;
      resultv(1 TO l'LENGTH - rv )           := lv(rv+1 TO l'LENGTH);
      resultv(l'LENGTH - rv + 1 TO l'LENGTH) := lv(1 TO rv);
      RETURN result;
    ELSE
      RETURN l ROR (-r);
    END IF;
  END FUNCTION "rol";

  -------------------------------------------------------------------    
  -- ror
  -------------------------------------------------------------------    
  FUNCTION "ror" ( l : std_logic_vector;  r : integer ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( l'RANGE );
    ALIAS resultv   : std_logic_vector ( 1 TO l'LENGTH ) IS result;
    VARIABLE rv     : integer;
  BEGIN
    IF r = 0 OR l'LENGTH = 0 THEN
      RETURN l;
    ELSIF r > 0 THEN
      rv                        := r MOD l'length;
      resultv(rv+1 TO l'LENGTH) := lv(1 TO l'LENGTH - rv);
      resultv(1 TO rv)          := lv(l'LENGTH - rv + 1 TO l'LENGTH);
      RETURN result;
    ELSE
      RETURN l ROL (-r);
    END IF;
  END FUNCTION "ror";
  -------------------------------------------------------------------    
  FUNCTION "ror" ( l : std_ulogic_vector; r : integer ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( l'RANGE );
    ALIAS resultv   : std_ulogic_vector ( 1 TO l'LENGTH ) IS result;
    VARIABLE rv     : integer;
  BEGIN
    IF r = 0 OR l'LENGTH = 0 THEN
      RETURN l;
    ELSIF r > 0 THEN
      rv                        := r MOD l'length;
      resultv(rv+1 TO l'LENGTH) := lv(1 TO l'LENGTH - rv);
      resultv(1 TO rv)          := lv(l'LENGTH - rv + 1 TO l'LENGTH);
      RETURN result;
    ELSE
      RETURN l ROL (-r);
    END IF;
  END FUNCTION "ror";

  -------------------------------------------------------------------
  -- vector/scalar overloaded logical operators
  -------------------------------------------------------------------

  -------------------------------------------------------------------
  -- and
  -------------------------------------------------------------------
  FUNCTION "and"  ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "and" (lv(i), r);
    END LOOP;
    RETURN result;
  END FUNCTION "and";
  -------------------------------------------------------------------
  FUNCTION "and"  ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "and" (lv(i), r);
    END LOOP;
    RETURN result;
  END FUNCTION "and";
  -------------------------------------------------------------------
  FUNCTION "and"  ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector IS
    ALIAS rv        : std_logic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_logic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "and" (l, rv(i));
    END LOOP;
    RETURN result;
  END FUNCTION "and";
  -------------------------------------------------------------------
  FUNCTION "and"  ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector IS
    ALIAS rv        : std_ulogic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_ulogic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "and" (l, rv(i));
    END LOOP;
    RETURN result;
  END FUNCTION "and";

  -------------------------------------------------------------------
  -- nand
  -------------------------------------------------------------------
  FUNCTION "nand" ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("and" (lv(i), r));
    END LOOP;
    RETURN result;
  END FUNCTION "nand";
  -------------------------------------------------------------------
  FUNCTION "nand" ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("and" (lv(i), r));
    END LOOP;
    RETURN result;
  END FUNCTION "nand";
  -------------------------------------------------------------------
  FUNCTION "nand" ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector IS
    ALIAS rv        : std_logic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_logic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("and" (l, rv(i)));
    END LOOP;
    RETURN result;
  END FUNCTION "nand";
  -------------------------------------------------------------------
  FUNCTION "nand" ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector IS
    ALIAS rv        : std_ulogic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_ulogic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("and" (l, rv(i)));
    END LOOP;
    RETURN result;
  END FUNCTION "nand";

  -------------------------------------------------------------------
  -- or
  -------------------------------------------------------------------
  FUNCTION "or"   ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "or" (lv(i), r);
    END LOOP;
    RETURN result;
  END FUNCTION "or";
  -------------------------------------------------------------------
  FUNCTION "or"   ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "or" (lv(i), r);
    END LOOP;
    RETURN result;
  END FUNCTION "or";
  -------------------------------------------------------------------
  FUNCTION "or"   ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector IS
    ALIAS rv        : std_logic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_logic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "or" (l, rv(i));
    END LOOP;
    RETURN result;
  END FUNCTION "or";
  -------------------------------------------------------------------
  FUNCTION "or"   ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector IS
    ALIAS rv        : std_ulogic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_ulogic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "or" (l, rv(i));
    END LOOP;
    RETURN result;
  END FUNCTION "or";

  -------------------------------------------------------------------
  -- nor
  -------------------------------------------------------------------
  FUNCTION "nor"  ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("or" (lv(i), r));
    END LOOP;
    RETURN result;
  END FUNCTION "nor";
  -------------------------------------------------------------------
  FUNCTION "nor"  ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("or" (lv(i), r));
    END LOOP;
    RETURN result;
  END FUNCTION "nor";
  -------------------------------------------------------------------
  FUNCTION "nor"  ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector IS
    ALIAS rv        : std_logic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_logic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("or" (l, rv(i)));
    END LOOP;
    RETURN result;
  END FUNCTION "nor";
  -------------------------------------------------------------------
  FUNCTION "nor"  ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector IS
    ALIAS rv        : std_ulogic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_ulogic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("or" (l, rv(i)));
    END LOOP;
    RETURN result;
  END FUNCTION "nor";

  -------------------------------------------------------------------
  -- xor
  -------------------------------------------------------------------
  FUNCTION "xor"  ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "xor" (lv(i), r);
    END LOOP;
    RETURN result;
  END FUNCTION "xor";
  -------------------------------------------------------------------
  FUNCTION "xor"  ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "xor" (lv(i), r);
    END LOOP;
    RETURN result;
  END FUNCTION "xor";
  -------------------------------------------------------------------
  FUNCTION "xor"  ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector IS
    ALIAS rv        : std_logic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_logic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "xor" (l, rv(i));
    END LOOP;
    RETURN result;
  END FUNCTION "xor";
  -------------------------------------------------------------------
  FUNCTION "xor"  ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector IS
    ALIAS rv        : std_ulogic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_ulogic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "xor" (l, rv(i));
    END LOOP;
    RETURN result;
  END FUNCTION "xor";

  -------------------------------------------------------------------
  -- xnor
  -------------------------------------------------------------------
  FUNCTION "xnor" ( l : std_logic_vector;  r : std_ulogic ) RETURN std_logic_vector IS
    ALIAS lv        : std_logic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_logic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("xor" (lv(i), r));
    END LOOP;
    RETURN result;
  END FUNCTION "xnor";
  -------------------------------------------------------------------
  FUNCTION "xnor" ( l : std_ulogic_vector; r : std_ulogic ) RETURN std_ulogic_vector IS
    ALIAS lv        : std_ulogic_vector ( 1 TO l'LENGTH ) IS l;
    VARIABLE result : std_ulogic_vector ( 1 TO l'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("xor" (lv(i), r));
    END LOOP;
    RETURN result;
  END FUNCTION "xnor";
  -------------------------------------------------------------------
  FUNCTION "xnor" ( l : std_ulogic; r : std_logic_vector  ) RETURN std_logic_vector IS
    ALIAS rv        : std_logic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_logic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("xor" (l, rv(i)));
    END LOOP;
    RETURN result;
  END FUNCTION "xnor";
  -------------------------------------------------------------------
  FUNCTION "xnor" ( l : std_ulogic; r : std_ulogic_vector ) RETURN std_ulogic_vector IS
    ALIAS rv        : std_ulogic_vector ( 1 TO r'LENGTH ) IS r;
    VARIABLE result : std_ulogic_vector ( 1 TO r'LENGTH );
  BEGIN
    FOR i IN result'RANGE LOOP
      result(i) := "not"("xor" (l, rv(i)));
    END LOOP;
    RETURN result;
  END FUNCTION "xnor";

  -------------------------------------------------------------------
  -- vector-reduction functions
  -------------------------------------------------------------------
  -- %%% Uncomment the new syntax functions below
--  -------------------------------------------------------------------
--  -- and
--  -------------------------------------------------------------------
--  FUNCTION and ( arg : std_logic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN and (to_StdULogicVector (arg));
--  END FUNCTION and;
--  -------------------------------------------------------------------
--  FUNCTION and ( arg : std_ulogic_vector ) RETURN std_ulogic IS
--    variable Upper, Lower : std_ulogic;
--    variable Half : integer;
--    variable BUS_int : std_ulogic_vector ( arg'length - 1 downto 0 );
--    variable Result : std_ulogic := '1';    -- In the case of a NULL range
--  BEGIN
--    if (arg'LENGTH >= 1) then
--      BUS_int := to_ux01 (arg);
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := "and" (BUS_int(BUS_int'right),BUS_int(BUS_int'left));
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := and ( BUS_int ( BUS_int'left downto Half ));
--        Lower := and ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := "and" (Upper, Lower);
--      end if;
--    end if;
--    return Result;
--  END FUNCTION and;

--  -------------------------------------------------------------------
--  -- nand
--  -------------------------------------------------------------------
--  FUNCTION nand ( arg : std_logic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN "not"(and(to_StdULogicVector(arg)));
--  END FUNCTION nand;
--  -------------------------------------------------------------------
--  FUNCTION nand ( arg : std_ulogic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN "not"(and(arg));
--  END FUNCTION nand;

--  -------------------------------------------------------------------
--  -- or
--  -------------------------------------------------------------------
--  FUNCTION or ( arg : std_logic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN or (to_StdULogicVector (arg));
--  END FUNCTION or;
--  -------------------------------------------------------------------
--  FUNCTION or ( arg : std_ulogic_vector ) RETURN std_ulogic IS
--    variable Upper, Lower : std_ulogic;
--    variable Half : integer;
--    variable BUS_int : std_ulogic_vector ( arg'length - 1 downto 0 );
--    variable Result : std_ulogic := '0';    -- In the case of a NULL range
--  BEGIN
--    if (arg'LENGTH >= 1) then
--      BUS_int := to_ux01 (arg);
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := "or" (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := or ( BUS_int ( BUS_int'left downto Half ));
--        Lower := or ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := "or" (Upper, Lower);
--      end if;
--    end if;
--    return Result;
--  END FUNCTION or;

--  -------------------------------------------------------------------
--  -- nor
--  -------------------------------------------------------------------
--  FUNCTION nor ( arg : std_logic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN "not"(or(To_StdULogicVector(arg)));
--  END FUNCTION nor;
--  -------------------------------------------------------------------
--  FUNCTION nor ( arg : std_ulogic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN "not"(or(arg));
--  END FUNCTION nor;

--  -------------------------------------------------------------------
--  -- xor
--  -------------------------------------------------------------------
--  FUNCTION xor ( arg : std_logic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN xor (to_StdULogicVector (arg));
--  END FUNCTION xor;
--  -------------------------------------------------------------------
--  FUNCTION xor ( arg : std_ulogic_vector ) RETURN std_ulogic IS
--    variable Upper, Lower : std_ulogic;
--    variable Half : integer;
--    variable BUS_int : std_ulogic_vector ( arg'length - 1 downto 0 );
--    variable Result : std_ulogic := '0';    -- In the case of a NULL range
--  BEGIN
--    if (arg'LENGTH >= 1) then
--      BUS_int := to_ux01 (arg);
--      if ( BUS_int'length = 1 ) then
--        Result := BUS_int ( BUS_int'left );
--      elsif ( BUS_int'length = 2 ) then
--        Result := "xor" (BUS_int(BUS_int'right), BUS_int(BUS_int'left));
--      else
--        Half := ( BUS_int'length + 1 ) / 2 + BUS_int'right;
--        Upper := xor ( BUS_int ( BUS_int'left downto Half ));
--        Lower := xor ( BUS_int ( Half - 1 downto BUS_int'right ));
--        Result := "xor" (Upper, Lower);
--      end if;
--    end if;
--    return Result;
--  END FUNCTION xor;

--  -------------------------------------------------------------------
--  -- xnor
--  -------------------------------------------------------------------
--  FUNCTION xnor ( arg : std_logic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN "not"(xor(To_StdULogicVector(arg)));
--  END FUNCTION xnor;
--  -------------------------------------------------------------------
--  FUNCTION xnor ( arg : std_ulogic_vector ) RETURN std_ulogic IS
--  BEGIN
--    RETURN "not"(xor(arg));
--  END FUNCTION xnor;
  ----------------------------------------------------------------------------
  -- %%% Remove the following funcitons (new syntax is above)
  ----------------------------------------------------------------------------
  -------------------------------------------------------------------
  -- and
  -------------------------------------------------------------------
  FUNCTION and_reduce ( arg : std_logic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN and_reduce (to_StdULogicVector (arg));
  END FUNCTION and_reduce;
  -------------------------------------------------------------------
  FUNCTION and_reduce ( arg : std_ulogic_vector ) RETURN std_ulogic IS
    variable Upper, Lower : std_ulogic;
    variable Half : integer;
    variable BUS_int : std_ulogic_vector ( arg'length - 1 downto 0 );
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

  -------------------------------------------------------------------
  -- nand
  -------------------------------------------------------------------
  FUNCTION nand_reduce ( arg : std_logic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN "not"(and_reduce(to_StdULogicVector(arg)));
  END FUNCTION nand_reduce;
  -------------------------------------------------------------------
  FUNCTION nand_reduce ( arg : std_ulogic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN "not"(and_reduce(arg));
  END FUNCTION nand_reduce;

  -------------------------------------------------------------------
  -- or
  -------------------------------------------------------------------
  FUNCTION or_reduce ( arg : std_logic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN or_reduce (to_StdULogicVector (arg));
  END FUNCTION or_reduce;
  -------------------------------------------------------------------
  FUNCTION or_reduce ( arg : std_ulogic_vector ) RETURN std_ulogic IS
    variable Upper, Lower : std_ulogic;
    variable Half : integer;
    variable BUS_int : std_ulogic_vector ( arg'length - 1 downto 0 );
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
  END FUNCTION or_reduce;

  -------------------------------------------------------------------
  -- nor
  -------------------------------------------------------------------
  FUNCTION nor_reduce ( arg : std_logic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN "not"(or_reduce(To_StdULogicVector(arg)));
  END FUNCTION nor_reduce;
  -------------------------------------------------------------------
  FUNCTION nor_reduce ( arg : std_ulogic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN "not"(or_reduce(arg));
  END FUNCTION nor_reduce;

  -------------------------------------------------------------------
  -- xor
  -------------------------------------------------------------------
  FUNCTION xor_reduce ( arg : std_logic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN xor_reduce (to_StdULogicVector (arg));
  END FUNCTION xor_reduce;
  -------------------------------------------------------------------
  FUNCTION xor_reduce ( arg : std_ulogic_vector ) RETURN std_ulogic IS
    variable Upper, Lower : std_ulogic;
    variable Half : integer;
    variable BUS_int : std_ulogic_vector ( arg'length - 1 downto 0 );
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
  END FUNCTION xor_reduce;

  -------------------------------------------------------------------
  -- xnor
  -------------------------------------------------------------------
  FUNCTION xnor_reduce ( arg : std_logic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN "not"(xor_reduce(To_StdULogicVector(arg)));
  END FUNCTION xnor_reduce;
  -------------------------------------------------------------------
  FUNCTION xnor_reduce ( arg : std_ulogic_vector ) RETURN std_ulogic IS
  BEGIN
    RETURN "not"(xor_reduce(arg));
  END FUNCTION xnor_reduce;
  -- %%% End "remove the following functions"
  
  -- Function from Proposal FT18
  function "and"  (L: std_ulogic; R: boolean) return std_ulogic is
  begin
    if R then
      return to_X01(L);
    else
      return '0';
    end if;
  end function "and";
  function "and"  (L: boolean; R: std_ulogic) return std_ulogic is
  begin
    if L then
      return to_X01(R);
    else
      return '0';
    end if;
  end function "and";
  function "or"   (L: std_ulogic; R: boolean) return std_ulogic is
  begin
    if R then
      return '1';
    else
      return to_X01(L);
    end if;
  end function "or";
  function "or"   (L: boolean; R: std_ulogic) return std_ulogic is
  begin
    if L then
      return '1';
    else
      return to_X01(R);
    end if;
  end function "or";
  function "xor"  (L: std_ulogic; R: boolean) return std_ulogic is
  begin
    if R then
      return not to_X01(L);
    else
      return to_X01(L);
    end if;
  end function "xor";
  function "xor"  (L: boolean; R: std_ulogic) return std_ulogic is
  begin
    if L then
      return not to_X01(R);
    else
      return to_X01(R);
    end if;
  end function "xor";
  function "nand" (L: std_ulogic; R: boolean) return std_ulogic is
  begin
    if R then
      return not to_X01(L);
    else
      return '1';
    end if;
  end function "nand";
  function "nand" (L: boolean; R: std_ulogic) return std_ulogic is
  begin
    if L then
      return not to_X01(R);
    else
      return '1';
    end if;
  end function "nand";
  function "nor"  (L: std_ulogic; R: boolean) return std_ulogic is
  begin
    if R then
      return '0';
    else
      return not to_X01(L);
    end if;
  end function "nor";
  function "nor"  (L: boolean; R: std_ulogic) return std_ulogic is
  begin
    if L then
      return '0';
    else
      return not to_X01(R);
    end if;
  end function "nor";
  function "xnor" (L: std_ulogic; R: boolean) return std_ulogic is
  begin
    if R then
      return to_X01(L);
    else
      return not to_X01(L);
    end if;
  end function "xnor";
  function "xnor" (L: boolean; R: std_ulogic) return std_ulogic is
  begin
    if L then
      return to_X01(R);
    else
      return not to_X01(R);
    end if;
  end function "xnor";

    -- Used internally by the ?= operators
  function find_msb (
    arg : STD_ULOGIC_VECTOR;            -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER is
    alias xarg : STD_ULOGIC_VECTOR(arg'length-1 downto 0) is arg;
  begin
    for_loop : for i in xarg'range loop
      if xarg(i) = y then
        return i;
      end if;
    end loop;
    return -1;
  end function find_msb;

  function find_msb (
    arg : STD_LOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER is
  begin
    return find_msb (STD_ULOGIC_VECTOR (arg), y);
  end function find_msb;

  -- The following functions are implicity in 1076-2006
  -- truth table for "?=" function
  constant match_logic_table : stdlogic_table := (
    -----------------------------------------------------
    -- U    X    0    1    Z    W    L    H    -         |   |  
    -----------------------------------------------------
    ('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', '1'),  -- | U |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | X |
    ('U', 'X', '1', '0', 'X', 'X', '1', '0', '1'),  -- | 0 |
    ('U', 'X', '0', '1', 'X', 'X', '0', '1', '1'),  -- | 1 |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | Z |
    ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | W |
    ('U', 'X', '1', '0', 'X', 'X', '1', '0', '1'),  -- | L |
    ('U', 'X', '0', '1', 'X', 'X', '0', '1', '1'),  -- | H |
    ('1', '1', '1', '1', '1', '1', '1', '1', '1')   -- | - |
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

  -------------------------------------------------------------------
  -- ?= functions, Similar to "std_match", but returns "std_ulogic".
  -------------------------------------------------------------------
  -- %%% FUNCTION "?=" ( l, r : std_ulogic ) RETURN std_ulogic IS
  function \?=\ (l, r : STD_ULOGIC) return STD_ULOGIC is
  begin
    return match_logic_table (l, r);
  end function \?=\;
  -- %%% END FUNCTION "?=";
  -------------------------------------------------------------------
  -- %%% FUNCTION "?=" ( l, r : std_logic_vector ) RETURN std_ulogic IS
  function \?=\ (l, r : STD_LOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_LOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_LOGIC_VECTOR(1 to r'length) is r;
    variable result, result1 : STD_ULOGIC;       -- result
  begin
    -- Logically identical to an "=" operator.
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?="": null detected, returning X"
        severity warning;
      return 'X';
    end if;
    if lv'length /= rv'length then
      report "STD_LOGIC_1164.""?="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    else
      result := '1';
      for i in lv'low to lv'high loop
        result1 := match_logic_table(lv(i), rv(i));
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
  -- %%% END FUNCTION "?=";
  -------------------------------------------------------------------
  -- %%% FUNCTION "?=" ( l, r : std_ulogic_vector ) RETURN std_ulogic IS
  function \?=\ (l, r : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_ULOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_ULOGIC_VECTOR(1 to r'length) is r;
    variable result, result1 : STD_ULOGIC;
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?="": null detected, returning X"
        severity warning;
      return 'X';
    end if;
    if lv'length /= rv'length then
      report "STD_LOGIC_1164.""?="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    else
      result := '1';
      for i in lv'low to lv'high loop
        result1 := match_logic_table(lv(i), rv(i));
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
  -- %%% END FUNCTION "?=";
  -- %%% FUNCTION "?/=" ( l, r : std_ulogic ) RETURN std_ulogic is
  function \?/=\ (l, r : STD_ULOGIC) return STD_ULOGIC is
  begin
    return no_match_logic_table (l, r);
  end function \?/=\;
  -- %%% END FUNCTION "?/=";
  -- %%% FUNCTION "?/=" ( l, r : std_logic_vector ) RETURN std_ulogic is
  function \?/=\ (l, r : STD_LOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_LOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_LOGIC_VECTOR(1 to r'length) is r;
    variable result, result1 : STD_ULOGIC;       -- result
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?/="": null detected, returning X"
        severity warning;
      return 'X';
    end if;
    if lv'length /= rv'length then
      report "STD_LOGIC_1164.""?/="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    else
      result := '0';
      for i in lv'low to lv'high loop
        result1 := no_match_logic_table(lv(i), rv(i));
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
  -- %%% END FUNCTION "?/=";
  -- %%% FUNCTION "?/=" ( l, r : std_ulogic_vector ) RETURN std_ulogic is
  function \?/=\ (l, r : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_ULOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_ULOGIC_VECTOR(1 to r'length) is r;
    variable result, result1 : STD_ULOGIC; 
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?/="": null detected, returning X"
        severity warning;
      return 'X';
    end if;
    if lv'length /= rv'length then
      report "STD_LOGIC_1164.""?/="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    else
      result := '0';
      for i in lv'low to lv'high loop
        result1 := no_match_logic_table(lv(i), rv(i));
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
  -- %%% END FUNCTION "?/=";
  -- %%% FUNCTION "?>" ( l, r : std_ulogic ) RETURN std_ulogic is
  function \?>\ (l, r : STD_ULOGIC) return STD_ULOGIC is
    variable lx, rx : STD_ULOGIC;
  begin
    if (l = '-') or (r = '-') then
      report "STD_LOGIC_1164.""?>"": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01 (l);
      rx := to_x01 (r);
      if lx = 'X' or rx = 'X' then
        return 'X';
      elsif lx > rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>\;
  -- %%% END FUNCTION "?>";
  -- %%% FUNCTION "?>" ( l, r : std_logic_vector ) RETURN std_ulogic is
  function \?>\ (l, r : STD_LOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_LOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_LOGIC_VECTOR(1 to r'length) is r;
    variable lx, rx : STD_LOGIC_VECTOR (l'range);
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?>"": null detected, returning X"
        severity warning;
      return 'X';
    elsif lv'length /= rv'length then
      report "STD_LOGIC_1164.""?>"": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "STD_LOGIC_1164.""?>"": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01(lv);
      rx := to_x01(rv);
      if is_x(lx) or is_x(rx) then
        return 'X';
      elsif lx > rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>\;
  -- %%% END FUNCTION "?/>";
  -- %%% FUNCTION "?>" ( l, r : std_ulogic_vector ) RETURN std_ulogic is
  function \?>\ (l, r : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_ULOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_ULOGIC_VECTOR(1 to r'length) is r;
    variable lx, rx : STD_ULOGIC_VECTOR (l'range);
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?>"": null detected, returning X"
        severity warning;
      return 'X';
    elsif lv'length /= rv'length then
      report "STD_LOGIC_1164.""?>"": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "STD_LOGIC_1164.""?>"": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01(lv);
      rx := to_x01(rv);
      if is_x(lx) or is_x(rx) then
        return 'X';
      elsif lx > rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>\;
  -- %%% END FUNCTION "?/>";
  -- %%% FUNCTION "?>=" ( l, r : std_ulogic ) RETURN std_ulogic is
  function \?>=\ (l, r : STD_ULOGIC) return STD_ULOGIC is
    variable lx, rx : STD_ULOGIC;
  begin
    if (l = '-') or (r = '-') then
      report "STD_LOGIC_1164.""?>="": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01 (l);
      rx := to_x01 (r);
      if lx = 'X' or rx = 'X' then
        return 'X';
      elsif lx >= rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>=\;
  -- %%% END FUNCTION "?/>=";
  -- %%% FUNCTION "?>=" ( l, r : std_logic_vector ) RETURN std_ulogic is
  function \?>=\ (l, r : STD_LOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_LOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_LOGIC_VECTOR(1 to r'length) is r;
    variable lx, rx : STD_LOGIC_VECTOR (l'range);
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?>="": null detected, returning X"
        severity warning;
      return 'X';
    elsif lv'length /= rv'length then
      report "STD_LOGIC_1164.""?>="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "STD_LOGIC_1164.""?>="": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01(lv);
      rx := to_x01(rv);
      if is_x(lx) or is_x(rx) then
        return 'X';
      elsif lx >= rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>=\;
  -- %%% END FUNCTION "?/>=";
  -- %%% FUNCTION "?>=" ( l, r : std_ulogic_vector ) RETURN std_ulogic is
  function \?>=\ (l, r : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_ULOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_ULOGIC_VECTOR(1 to r'length) is r;
    variable lx, rx : STD_ULOGIC_VECTOR (l'range);
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?>="": null detected, returning X"
        severity warning;
      return 'X';
    elsif lv'length /= rv'length then
      report "STD_LOGIC_1164.""?>="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "STD_LOGIC_1164.""?>="": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01(lv);
      rx := to_x01(rv);
      if is_x(lx) or is_x(rx) then
        return 'X';
      elsif lx >= rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?>=\;
  -- %%% END FUNCTION "?/>=";
  -- %%% FUNCTION "?<" ( l, r : std_ulogic ) RETURN std_ulogic is
  function \?<\ (l, r : STD_ULOGIC) return STD_ULOGIC is
    variable lx, rx : STD_ULOGIC;
  begin
    if (l = '-') or (r = '-') then
      report "STD_LOGIC_1164.""?<"": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01 (l);
      rx := to_x01 (r);
      if lx = 'X' or rx = 'X' then
        return 'X';
      elsif lx < rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<\;
  -- %%% END FUNCTION "?/<";
  -- %%% FUNCTION "?<" ( l, r : std_logic_vector ) RETURN std_ulogic is
  function \?<\ (l, r : STD_LOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_LOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_LOGIC_VECTOR(1 to r'length) is r;
    variable lx, rx : STD_LOGIC_VECTOR (l'range);
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?<"": null detected, returning X"
        severity warning;
      return 'X';
    elsif lv'length /= rv'length then
      report "STD_LOGIC_1164.""?<"": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "STD_LOGIC_1164.""?<"": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01(lv);
      rx := to_x01(rv);
      if is_x(lx) or is_x(rx) then
        return 'X';
      elsif lx < rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<\;
  -- %%% END FUNCTION "?/<";
  -- %%% FUNCTION "?<" ( l, r : std_ulogic_vector ) RETURN std_ulogic is
  function \?<\ (l, r : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_ULOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_ULOGIC_VECTOR(1 to r'length) is r;
    variable lx, rx : STD_ULOGIC_VECTOR (l'range);
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?<"": null detected, returning X"
        severity warning;
      return 'X';
    elsif lv'length /= rv'length then
      report "STD_LOGIC_1164.""?<"": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "STD_LOGIC_1164.""?<"": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01(lv);
      rx := to_x01(rv);
      if is_x(lx) or is_x(rx) then
        return 'X';
      elsif lx < rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<\;
  -- %%% END FUNCTION "?/<";
  -- %%% FUNCTION "?<=" ( l, r : std_ulogic ) RETURN std_ulogic is
  function \?<=\ (l, r : STD_ULOGIC) return STD_ULOGIC is
    variable lx, rx : STD_ULOGIC;
  begin
    if (l = '-') or (r = '-') then
      report "STD_LOGIC_1164.""?<="": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01 (l);
      rx := to_x01 (r);
      if lx = 'X' or rx = 'X' then
        return 'X';
      elsif lx <= rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<=\;
  -- %%% END FUNCTION "?/<=";
  -- %%% FUNCTION "?<=" ( l, r : std_logic_vector ) RETURN std_ulogic is
  function \?<=\ (l, r : STD_LOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_LOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_LOGIC_VECTOR(1 to r'length) is r;
    variable lx, rx : STD_LOGIC_VECTOR (l'range);
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?<="": null detected, returning X"
        severity warning;
      return 'X';
    elsif lv'length /= rv'length then
      report "STD_LOGIC_1164.""?<="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "STD_LOGIC_1164.""?<="": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01(lv);
      rx := to_x01(rv);
      if is_x(lx) or is_x(rx) then
        return 'X';
      elsif lx <= rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<=\;
  -- %%% END FUNCTION "?/<=";
  -- %%% FUNCTION "?<=" ( l, r : std_ulogic_vector ) RETURN std_ulogic is
  function \?<=\ (l, r : STD_ULOGIC_VECTOR) return STD_ULOGIC is
    alias lv        : STD_ULOGIC_VECTOR(1 to l'length) is l;
    alias rv        : STD_ULOGIC_VECTOR(1 to r'length) is r;
    variable lx, rx : STD_ULOGIC_VECTOR (l'range);
  begin
    if ((l'length < 1) or (r'length < 1)) then
      report "STD_LOGIC_1164.""?<="": null detected, returning X"
        severity warning;
      return 'X';
    elsif lv'length /= rv'length then
      report "STD_LOGIC_1164.""?<="": L'LENGTH /= R'LENGTH, returning X"
        severity warning;
      return 'X';
    elsif (find_msb (l, '-') /= -1) or (find_msb (r, '-') /= -1) then
      report "STD_LOGIC_1164.""?<="": '-' found in compare string"
        severity error;
      return 'X';
    else
      lx := to_x01(lv);
      rx := to_x01(rv);
      if is_x(lx) or is_x(rx) then
        return 'X';
      elsif lx <= rx then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function \?<=\;
  -- %%% END FUNCTION "?/<=";

  -- "??" operator, converts a std_ulogic to a boolean.
-- %%% FUNCTION "??"
  function \??\ (S : STD_ULOGIC) return BOOLEAN is
  begin
    return  S = '1' or S = 'H';
  end function \??\;
-- %%% END FUNCTION "??";

  -- rtl_synthesis off
  -- synthesis translate_off
  -----------------------------------------------------------------------------
  -- This section copied from "std_logic_textio"
  -----------------------------------------------------------------------------
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
  constant NUS : string(2 to 1)   := (others => ' ');  -- null string

  procedure READ (L : inout LINE; VALUE : out STD_ULOGIC;
  GOOD : out BOOLEAN) is
    variable c      : character;
    variable readOk : BOOLEAN;
  begin
    VALUE := 'U';                       -- initialize to a "U"
    loop                                -- skip white space
      read(l, c, readOk);               -- but also exit on a bad read
      exit when (readOk = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    if not readOk then
      good := FALSE;
    else
      if char_to_MVL9plus(c) = ERROR then
        good  := FALSE;
      else
        VALUE := char_to_MVL9(c);
        good  := TRUE;
      end if;
    end if;
  end procedure READ;

  procedure READ (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR;
  GOOD : out BOOLEAN) is
    variable m    : STD_ULOGIC;
    variable c    : character;
    variable s    : string(1 to VALUE'length-1);
    variable mv   : STD_ULOGIC_VECTOR(0 to VALUE'length-1);
    variable readOk : BOOLEAN;
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, readOk);
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
    read(L, s, readOk);
    -- Bail out if there was a bad read
    if not readOk then
      good := FALSE;
      return;
    end if;
    for i in 1 to VALUE'length-1 loop
      if char_to_MVL9plus(s(i)) = ERROR then
        good  := FALSE;
        return;
      end if;
    end loop;
    mv(0) := char_to_MVL9(c);
    for i in 1 to VALUE'length-1 loop
      mv(i) := char_to_MVL9(s(i));
    end loop;
    VALUE := mv;
    good  := TRUE;
  end procedure READ;

  procedure READ (L : inout LINE; VALUE : out STD_ULOGIC) is
    variable c : character;
    variable readOk : BOOLEAN;
  begin
    VALUE := 'U';                       -- initialize to a "U"
    loop                                -- skip white space
      read(l, c, readOk);
      exit when (readOk = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    if not readOk then
      report "STD_LOGIC_1164.READ(STD_ULOGIC) "
        & "Error end of string encountered"
        severity error;
      return;
    elsif char_to_MVL9plus(c) = ERROR then
      report
        "STD_LOGIC_1164.READ(STD_ULOGIC) Error: Character '" &
        c & "' read, expected STD_ULOGIC literal."
        severity error;
    else
      VALUE := char_to_MVL9(c);
    end if;
  end procedure READ;

  procedure READ (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR) is
    variable m    : STD_ULOGIC;
    variable c    : character;
    variable readOk : BOOLEAN;
    variable s    : string(1 to VALUE'length-1);
    variable mv   : STD_ULOGIC_VECTOR(0 to VALUE'length-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, readOk);
      exit when (readOk = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
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
    read(L, s, readOk);
    if readOk then
    for i in 1 to VALUE'length-1 loop
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
    for i in 1 to VALUE'length-1 loop
      mv(i) := char_to_MVL9(s(i));
    end loop;
    VALUE := mv;
  end procedure READ;

  procedure WRITE (L : inout LINE; VALUE : in STD_ULOGIC;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0) is
  begin
    write(l, MVL9_to_char(VALUE), justified, field);
  end procedure WRITE;

  procedure WRITE (L : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0) is
    variable s : string(1 to VALUE'length);
    variable m : STD_ULOGIC_VECTOR(1 to VALUE'length) := VALUE;
  begin
    for i in 1 to VALUE'length loop
      s(i) := MVL9_to_char(m(i));
    end loop;
    write(l, s, justified, field);
  end procedure WRITE;

  -- Read and Write procedures for STD_LOGIC_VECTOR

  procedure READ (L : inout LINE; VALUE : out STD_LOGIC_VECTOR;
  GOOD : out BOOLEAN) is
    variable m    : STD_LOGIC;
    variable c    : character;
    variable s    : string(1 to VALUE'length-1);
    variable mv   : STD_LOGIC_VECTOR(0 to VALUE'length-1);
    variable readOk : BOOLEAN;
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, readOk);
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
    read(L, s, readOk);
    -- Bail out if there was a bad read
    if not readOk then
      good := FALSE;
      return;
    end if;
    for i in 1 to VALUE'length-1 loop
      if char_to_MVL9plus(s(i)) = ERROR then
        good  := FALSE;
        return;
      end if;
    end loop;
    mv(0) := char_to_MVL9(c);
    for i in 1 to VALUE'length-1 loop
      mv(i) := char_to_MVL9(s(i));
    end loop;
    VALUE := mv;
    good  := TRUE;
  end procedure READ;

  procedure READ (L : inout LINE; VALUE : out STD_LOGIC_VECTOR) is
    variable m    : STD_LOGIC;
    variable c    : character;
    variable readOk : BOOLEAN;
    variable s    : string(1 to VALUE'length-1);
    variable mv   : STD_LOGIC_VECTOR(0 to VALUE'length-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, readOk);
      exit when (readOk = FALSE) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    if readOk = false then            -- Bail out if there was a bad read
      report "STD_LOGIC_1164.READ(STD_LOGIC_VECTOR) "
        & "Error end of string encountered"
        severity error;
      return;
    elsif char_to_MVL9plus(c) = ERROR then
      report
        "STD_LOGIC_1164.READ(STD_LOGIC_VECTOR) Error: Character '" & 
        c & "' read, expected STD_ULOGIC literal."
        severity error;
      return;
    end if;
    read(L, s, readOk);
    if readOk then
      for i in 1 to VALUE'length-1 loop
        if (char_to_MVL9plus(s(i)) = ERROR) then
          report
            "STD_LOGIC_1164.READ(STD_LOGIC_VECTOR) Error: Character '" &
            s(i) & "' read, expected STD_ULOGIC literal."
            severity error;
          return;
        end if;
      end loop;
    else
      report "STD_LOGIC_1164.READ(STD_LOGIC_VECTOR) "
        & "Error end of string encountered"
        severity error;
      return;
    end if;
    mv(0) := char_to_MVL9(c);
    for i in 1 to VALUE'length-1 loop
      mv(i) := char_to_MVL9(s(i));
    end loop;
    VALUE := mv;
  end procedure READ;

  procedure WRITE (L : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0) is
    variable s : string(1 to VALUE'length);
    variable m : STD_LOGIC_VECTOR(1 to VALUE'length) := VALUE;
  begin
    for i in 1 to VALUE'length loop
      s(i) := MVL9_to_char(m(i));
    end loop;
    write(L, s, justified, field);
  end procedure WRITE;

  -----------------------------------------------------------------------
  -- Alias for bread and bwrite are provided with call out the read and
  -- write functions.
  -----------------------------------------------------------------------

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
            "STD_LOGIC_1164.HREAD Error: Read a '" & c &
            "', expected a Hex character (0-F)."
            severity error;
        good := FALSE;
    end case;
  end procedure Char2QuadBits;

  procedure HREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR;
  GOOD : out BOOLEAN) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (VALUE'length+3)/4;
    constant pad : INTEGER := ne*4 - VALUE'length;
    variable sv : std_ulogic_vector(0 to ne*4 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, ok);
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
    if or_reduce (sv (0 to pad-1)) = '1' then  -- %%% replace with "or"
      good := false;                    -- vector was truncated.
    else
      good := true;
      VALUE := sv (pad to sv'high);
    end if;
  end procedure HREAD;

  procedure HREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (VALUE'length+3)/4;
    constant pad : INTEGER := ne*4 - VALUE'length;
    variable sv : std_ulogic_vector(0 to ne*4 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, ok);
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
    if or_reduce (sv (0 to pad-1)) = '1' then  -- %%% replace with "or"
        report "STD_LOGIC_1164.HREAD Error: Vector truncated"
        severity error;
    else
      VALUE := sv (pad to sv'high);
    end if;
  end procedure HREAD;

  procedure HWRITE (L : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
  JUSTIFIED           : in    SIDE := RIGHT; FIELD : in WIDTH := 0) is
  begin
    write (L, to_hstring (VALUE), JUSTIFIED, FIELD); 
  end procedure HWRITE;


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

  procedure OREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR;
  GOOD : out BOOLEAN) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (VALUE'length+2)/3;
    constant pad : INTEGER := ne*3 - VALUE'length;
    variable sv : std_ulogic_vector(0 to ne*3 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, ok);
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
    if or_reduce (sv (0 to pad-1)) = '1' then -- %%% replace with "or"
      good := false;                    -- vector was truncated.
    else
      good := true;
      VALUE := sv (pad to sv'high);
    end if;
  end procedure OREAD;

  procedure OREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR) is
    variable c  : character;
    variable ok : boolean;
    constant ne : INTEGER := (VALUE'length+2)/3;
    constant pad : INTEGER := ne*3 - VALUE'length;
    variable sv : std_ulogic_vector(0 to ne*3 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, ok);
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
    if or_reduce (sv (0 to pad-1)) = '1' then  -- %%% replace with "or"
      report "STD_LOGIC_1164.OREAD Error: Vector truncated"
        severity error;
    else
      VALUE := sv (pad to sv'high);
    end if;
  end procedure OREAD;

  procedure OWRITE (L : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
  JUSTIFIED           : in    SIDE := RIGHT; FIELD : in WIDTH := 0) is
  begin
    write (L, to_ostring(VALUE), JUSTIFIED, FIELD);
  end procedure OWRITE;

  -- Hex Read and Write procedures for STD_LOGIC_VECTOR

  procedure HREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR;
  GOOD : out BOOLEAN) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (VALUE'length+3)/4;
    constant pad : INTEGER := ne*4 - VALUE'length;
    variable sv : std_ulogic_vector(0 to ne*4 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
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
    if or_reduce (sv (0 to pad-1)) = '1' then  -- %%% replace with "or"
      good := false;                    -- vector was truncated.
    else
      VALUE := to_stdlogicvector(sv (pad to sv'high));
      good := true;
    end if;
  end procedure HREAD;

  procedure HREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (VALUE'length+3)/4;
    constant pad : INTEGER := ne*4 - VALUE'length;
    variable sv : std_ulogic_vector(0 to ne*4 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');   -- initialize to a "U"
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
    VALUE := to_stdlogicvector(sv (pad to sv'high));
    if or_reduce (sv (0 to pad-1)) = '1' then  -- %%% replace with "or"
      report "STD_LOGIC_1164.HREAD Error: Vector truncated"
        severity error;
    end if;
  end procedure HREAD;

  procedure HWRITE (L : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  JUSTIFIED           : in    SIDE := RIGHT; FIELD : in WIDTH := 0) is
  begin
    write (L, to_hstring(VALUE), JUSTIFIED, FIELD);
  end procedure HWRITE;

  -- Octal Read and Write procedures for STD_LOGIC_VECTOR

  procedure OREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR;
  GOOD : out BOOLEAN) is
    variable ok : boolean;
    variable c  : character;
    constant ne : INTEGER := (VALUE'length+2)/3;
    constant pad : INTEGER := ne*3 - VALUE'length;
    variable sv : std_ulogic_vector(0 to ne*3 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, ok);
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
    VALUE := to_stdlogicvector (sv (pad to sv'high));
    if or_reduce (sv (0 to pad-1)) = '1' then -- %%% replace with "or"
      good := false;                    -- vector was truncated.
    else
      good := true;
    end if;
  end procedure OREAD;

  procedure OREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR) is
    variable c  : character;
    variable ok : boolean;
    constant ne : INTEGER := (VALUE'length+2)/3;
    constant pad : INTEGER := ne*3 - VALUE'length;
    variable sv : std_ulogic_vector(0 to ne*3 - 1);
    variable s  : string(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => 'U');           -- initialize to a "U"
    loop                                -- skip white space
      read(L, c, ok);
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
    VALUE := to_stdlogicvector (sv (pad to sv'high));
    if or_reduce (sv (0 to pad-1)) = '1' then -- %%% replace with "or"
      report "STD_LOGIC_1164.OREAD Error: Vector truncated"
        severity error;
    end if;
  end procedure OREAD;

  procedure OWRITE (L : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  JUSTIFIED           : in    SIDE := RIGHT; FIELD : in WIDTH := 0) is
  begin
    write (L, to_ostring(VALUE), JUSTIFIED, FIELD);
  end procedure OWRITE;

  -----------------------------------------------------------------------------
  -- New string functions for vhdl-200x fast track
  -----------------------------------------------------------------------------

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

  -----------------------------------------------------------------------------
  -- New string functions for vhdl-200x fast track
  -----------------------------------------------------------------------------
  function to_string (
    value     : in STD_ULOGIC;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return STRING is
    variable result : STRING (1 to 1);
  begin
    result (1) := MVL9_to_char (value);
    return justify (result, justified, field);
  end function to_string;
  -------------------------------------------------------------------    
  -- TO_STRING (an alias called "to_bstring" is provide)
  -------------------------------------------------------------------   
  function to_string (
    value     : in std_ulogic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
    alias ivalue    : std_ulogic_vector(1 to value'length) is value;
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

  -------------------------------------------------------------------    
  -- TO_HSTRING
  -------------------------------------------------------------------   
  function to_hstring (
    value     : in std_ulogic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
    constant ne     : integer  := (value'length+3)/4;
    variable pad    : std_ulogic_vector(0 to (ne*4 - value'length) - 1);
    variable ivalue : std_ulogic_vector(0 to ne*4 - 1);
    variable result : string(1 to ne);
    variable quad   : std_ulogic_vector(0 to 3);
  begin
    if value'length < 1 then
      return NUS;
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => '0');
      end if;
      ivalue := pad & value;
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

  -------------------------------------------------------------------    
  -- TO_OSTRING
  -------------------------------------------------------------------   
  function to_ostring (
    value     : in std_ulogic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
    constant ne     : integer := (value'length+2)/3;
    variable pad    : std_ulogic_vector(0 to (ne*3 - value'length) - 1);
    variable ivalue : std_ulogic_vector(0 to ne*3 - 1);
    variable result : string(1 to ne);
    variable tri    : std_ulogic_vector(0 to 2);
  begin
    if value'length < 1 then
      return NUS;
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => '0');
      end if;
      ivalue := pad & value;
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
    value     : in std_logic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
  begin
    return to_string (to_stdulogicvector (value), justified, field);
  end function to_string;

  function to_hstring (
    value     : in std_logic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string is
  begin
    return to_hstring (to_stdulogicvector (value), justified, field);
  end function to_hstring;

  function to_ostring (
    value     : in std_logic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return string  is
  begin
    return to_ostring (to_stdulogicvector (value), justified, field);
  end function to_ostring;

  -----------------------------------------------------------------------
  -- Alias for bread and bwrite are provided with call out the read and
  -- write functions.
  -----------------------------------------------------------------------
  function to_bstring (
    value     : in std_ulogic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return STRING is
  begin
    return to_string (value, justified, field);
  end function to_bstring;

  function to_bstring (
    value     : in std_logic_vector;
    justified : in side  := RIGHT;
    field     : in width := 0
    ) return STRING is
  begin
    return to_string (value, justified, field);
  end function to_bstring;

  procedure BREAD (L : inout LINE; VALUE : out STD_ULOGIC; GOOD : out BOOLEAN)
    is
  begin
    READ (L, VALUE, GOOD);
  end procedure BREAD;
  procedure BREAD (L : inout LINE; VALUE : out STD_ULOGIC)
    is
  begin
    READ (L, VALUE);
  end procedure BREAD;

  procedure BREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR; GOOD : out BOOLEAN)
    is
  begin
    READ (L, VALUE, GOOD);
  end procedure BREAD;
  procedure BREAD (L : inout LINE; VALUE : out STD_ULOGIC_VECTOR)
    is
  begin
    READ (L, VALUE);
  end procedure BREAD;
  procedure BREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR; GOOD : out BOOLEAN)
    is
  begin
    READ (L, VALUE, GOOD);
  end procedure BREAD;
  procedure BREAD (L : inout LINE; VALUE : out STD_LOGIC_VECTOR)
    is
  begin
    READ (L, VALUE);
  end procedure BREAD;
  procedure BWRITE (L : inout LINE; VALUE : in STD_ULOGIC;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0)
    is
  begin
    WRITE (L, VALUE, JUSTIFIED, FIELD);
  end procedure BWRITE;

  procedure BWRITE (L : inout LINE; VALUE : in STD_ULOGIC_VECTOR;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0)
    is
  begin
    WRITE (L, VALUE, JUSTIFIED, FIELD);
  end procedure BWRITE;
  procedure BWRITE (L : inout LINE; VALUE : in STD_LOGIC_VECTOR;
  JUSTIFIED          : in    SIDE := RIGHT; FIELD : in WIDTH := 0)
    is
  begin
    WRITE (L, VALUE, JUSTIFIED, FIELD);
  end procedure BWRITE;
  -- rtl_synthesis on
  -- synthesis translate_on
end package body std_logic_1164_additions;
