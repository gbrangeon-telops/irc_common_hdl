------------------------------------------------------------------------------
-- "numeric_std_unsigned" package contains functions that treat
-- "std_logic_vector" like an "unsigned" from "numeric_std".
-- There is a dependancey on this package with "numeric_std_additions.vhd".
-- This package should be compiled into "ieee_proposed" and used as follows:
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use ieee_proposed.numeric_std_unsigned.all;
-- Last Modified: $Date: 2006-03-14 12:34:06-05 $
-- RCS ID: $Id: numeric_std_unsigned_c.vhd,v 1.2 2006-03-14 12:34:06-05 l435385 Exp l435385 $
--
--  Created for VHDL-200X par, David Bishop (dbishop@vhdl.org)
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
package NUMERIC_STD_UNSIGNED is
  -- Id: A.3
  function "+" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Result: Adds two UNSIGNED vectors that may be of different lengths.

  -- Id: A.3R
  function "+"(L : STD_LOGIC_VECTOR; R : STD_ULOGIC) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'RANGE)
  -- Result: Similar to A.3 where R is a one bit std_logic_vector

  -- Id: A.3L
  function "+"(L : STD_ULOGIC; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'RANGE)
  -- Result: Similar to A.3 where L is a one bit UNSIGNED

  -- Id: A.5
  function "+" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0).
  -- Result: Adds an UNSIGNED vector, L, with a non-negative INTEGER, R.

  -- Id: A.6
  function "+" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0).
  -- Result: Adds a non-negative INTEGER, L, with an UNSIGNED vector, R.

  --============================================================================

  -- Id: A.9
  function "-" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: UNSIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Result: Subtracts two UNSIGNED vectors that may be of different lengths.

  -- Id: A.9R
  function "-"(L : STD_LOGIC_VECTOR; R : STD_ULOGIC) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'RANGE)
  -- Result: Similar to A.9 where R is a one bit UNSIGNED

  -- Id: A.9L
  function "-"(L : STD_ULOGIC; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'RANGE)
  -- Result: Similar to A.9 where L is a one bit UNSIGNED

  -- Id: A.11
  function "-" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0).
  -- Result: Subtracts a non-negative INTEGER, R, from an UNSIGNED vector, L.

  -- Id: A.12
  function "-" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0).
  -- Result: Subtracts an UNSIGNED vector, R, from a non-negative INTEGER, L.

  --============================================================================

  -- Id: A.15
  function "*" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector((L'LENGTH+R'LENGTH-1) downto 0).
  -- Result: Performs the multiplication operation on two UNSIGNED vectors
  --         that may possibly be of different lengths.

  -- Id: A.17
  function "*" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector((L'LENGTH+L'LENGTH-1) downto 0).
  -- Result: Multiplies an UNSIGNED vector, L, with a non-negative
  --         INTEGER, R. R is converted to an UNSIGNED vector of
  --         SIZE L'LENGTH before multiplication.

  -- Id: A.18
  function "*" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector((R'LENGTH+R'LENGTH-1) downto 0).
  -- Result: Multiplies an UNSIGNED vector, R, with a non-negative
  --         INTEGER, L. L is converted to an UNSIGNED vector of
  --         SIZE R'LENGTH before multiplication.

  --============================================================================
  --
  -- NOTE: If second argument is zero for "/" operator, a severity level
  --       of ERROR is issued.

  -- Id: A.21
  function "/" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Divides an UNSIGNED vector, L, by another UNSIGNED vector, R.

  -- Id: A.23
  function "/" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Divides an UNSIGNED vector, L, by a non-negative INTEGER, R.
  --         If NO_OF_BITS(R) > L'LENGTH, result is truncated to L'LENGTH.

  -- Id: A.24
  function "/" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Divides a non-negative INTEGER, L, by an UNSIGNED vector, R.
  --         If NO_OF_BITS(L) > R'LENGTH, result is truncated to R'LENGTH.

  --============================================================================
  --
  -- NOTE: If second argument is zero for "rem" operator, a severity level
  --       of ERROR is issued.

  -- Id: A.27
  function "rem" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where L and R are UNSIGNED vectors.

  -- Id: A.29
  function "rem" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where L is an UNSIGNED vector and R is a
  --         non-negative INTEGER.
  --         If NO_OF_BITS(R) > L'LENGTH, result is truncated to L'LENGTH.

  -- Id: A.30
  function "rem" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where R is an UNSIGNED vector and L is a
  --         non-negative INTEGER.
  --         If NO_OF_BITS(L) > R'LENGTH, result is truncated to R'LENGTH.

  --============================================================================
  --
  -- NOTE: If second argument is zero for "mod" operator, a severity level
  --       of ERROR is issued.

  -- Id: A.33
  function "mod" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L and R are UNSIGNED vectors.

  -- Id: A.35
  function "mod" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L is an UNSIGNED vector and R
  --         is a non-negative INTEGER.
  --         If NO_OF_BITS(R) > L'LENGTH, result is truncated to L'LENGTH.

  -- Id: A.36
  function "mod" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where R is an UNSIGNED vector and L
  --         is a non-negative INTEGER.
  --         If NO_OF_BITS(L) > R'LENGTH, result is truncated to R'LENGTH.

  --============================================================================
  -- Comparison Operators
  --============================================================================

  -- Id: C.1
  function ">" (L, R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.3
  function ">" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.5
  function ">" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.7
  function "<" (L, R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.9
  function "<" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.11
  function "<" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.13
  function "<=" (L, R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.15
  function "<=" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.17
  function "<=" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.19
  function ">=" (L, R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.21
  function ">=" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.23
  function ">=" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.25
  function "=" (L, R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.27
  function "=" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.29
  function "=" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.31
  function "/=" (L, R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.33
  function "/=" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.35
  function "/=" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  -- Id: M.2B
  -- %%% function "?=" (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  -- %%% function "?/=" (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  -- %%% function "?>" (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  -- %%% function "?>=" (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  -- %%% function "?<" (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  -- %%% function "?<=" (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  function \?=\ (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  function \?/=\ (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  function \?>\ (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  function \?>=\ (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  function \?<\ (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  function \?<=\ (L, R : STD_LOGIC_VECTOR) return std_ulogic;
  --============================================================================
  -- Shift and Rotate Functions
  --============================================================================

  -- Id: S.1
  function SHIFT_LEFT (ARG : STD_LOGIC_VECTOR; COUNT : NATURAL)
    return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(ARG'LENGTH-1 downto 0)
  -- Result: Performs a shift-left on an UNSIGNED vector COUNT times.
  --         The vacated positions are filled with '0'.
  --         The COUNT leftmost elements are lost.

  -- Id: S.2
  function SHIFT_RIGHT (ARG : STD_LOGIC_VECTOR; COUNT : NATURAL)
    return STD_LOGIC_VECTOR;
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a shift-right on an UNSIGNED vector COUNT times.
  --         The vacated positions are filled with '0'.
  --         The COUNT rightmost elements are lost.
  --============================================================================

  -- Id: S.5
  function ROTATE_LEFT (ARG : STD_LOGIC_VECTOR; COUNT : NATURAL)
    return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(ARG'LENGTH-1 downto 0)
  -- Result: Performs a rotate-left of an UNSIGNED vector COUNT times.

  -- Id: S.6
  function ROTATE_RIGHT (ARG : STD_LOGIC_VECTOR; COUNT : NATURAL)
    return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(ARG'LENGTH-1 downto 0)
  -- Result: Performs a rotate-right of an UNSIGNED vector COUNT times.


  --============================================================================
  --   RESIZE Functions
  --============================================================================

  -- Id: R.2
  function RESIZE (ARG : STD_LOGIC_VECTOR; NEW_SIZE : NATURAL)
    return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(NEW_SIZE-1 downto 0)

  -- size_res version, uses the size of the "size_res" input
  -- to resize the output
  function RESIZE (ARG, SIZE_RES : STD_LOGIC_VECTOR)
    return STD_LOGIC_VECTOR;

  --============================================================================
  -- Conversion Functions
  --============================================================================

  -- Id: D.1
  function TO_INTEGER (ARG : STD_LOGIC_VECTOR) return NATURAL;
  -- Result subtype: NATURAL. Value cannot be negative since parameter is an
  --             UNSIGNED vector.
  -- Result: Converts the UNSIGNED vector to an INTEGER.

  -- Id: D.3
  function To_StdLogicVector (ARG, SIZE : NATURAL) return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(SIZE-1 downto 0)
  -- Result: Converts a non-negative INTEGER to an UNSIGNED vector with
  --         the specified SIZE.
--  alias to_slv is
--    To_StdLogicVector [NATURAL, NATURAL return STD_LOGIC_VECTOR];
--  alias to_std_logic_vector is
--    To_StdLogicVector [NATURAL, NATURAL return STD_LOGIC_VECTOR];
  function to_slv (ARG, SIZE : NATURAL) return STD_LOGIC_VECTOR;
  function to_std_logic_vector (ARG, SIZE : NATURAL) return STD_LOGIC_VECTOR;
  
  -- size_res version, uses size_res to define the size of the output
  function To_StdLogicVector (ARG : NATURAL; SIZE_RES : STD_LOGIC_VECTOR)
    return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(SIZE-1 downto 0)
  -- Result: Converts a non-negative INTEGER to an UNSIGNED vector with
  --         the specified SIZE.
--  alias to_slv is
--    To_StdLogicVector [NATURAL, STD_LOGIC_VECTOR return STD_LOGIC_VECTOR];
--  alias to_std_logic_vector is
--    To_StdLogicVector [NATURAL, STD_LOGIC_VECTOR return STD_LOGIC_VECTOR];
  function to_slv (ARG : NATURAL; SIZE_RES : STD_LOGIC_VECTOR)
    return STD_LOGIC_VECTOR;
  function to_std_logic_vector (ARG : NATURAL; SIZE_RES : STD_LOGIC_VECTOR)
    return STD_LOGIC_VECTOR;

  --============================================================================
  -- Translation Functions
  --============================================================================

  -- Id: T.1
  function TO_01 (S : STD_LOGIC_VECTOR; XMAP : STD_LOGIC := '0')
    return STD_LOGIC_VECTOR;
  -- Result subtype: std_logic_vector(S'RANGE)
  -- Result: Termwise, 'H' is translated to '1', and 'L' is translated
  --         to '0'. If a value other than '0'|'1'|'H'|'L' is found,
  --         the array is set to (others => XMAP), and a warning is
  --         issued.

  -- add_carry procedures, to provide a carry in and a carry out
  procedure add_carry (
    L, R   : in  STD_LOGIC_VECTOR;
    c_in   : in  STD_ULOGIC;
    result : out STD_LOGIC_VECTOR;
    c_out  : out STD_ULOGIC);
  -- Result subtype: STD_LOGIC_VECTOR(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Procedure takes a carry in into the adder, and provides a carry out.

  -- These are here to override the defaults for these functions
  function "sra" (ARG : STD_LOGIC_VECTOR; COUNT : INTEGER)
    return STD_LOGIC_VECTOR;
  function "sla" (ARG : STD_LOGIC_VECTOR; COUNT : INTEGER)
    return STD_LOGIC_VECTOR;

  -- Returns the maximum (or minimum) of the two numbers provided.
  -- All types (both inputs and the output) must be the same.
  function maximum (
    L, R : STD_LOGIC_VECTOR)            -- inputs
    return STD_LOGIC_VECTOR;

  function minimum (
    L, R : STD_LOGIC_VECTOR)            -- inputs
    return STD_LOGIC_VECTOR;

  -- Finds the first "Y" in the input string. Returns an integer index
  -- into that string.  If "Y" does not exist in the string, then the
  -- "find_lsb" returns arg'low -1, and "find_msb" returns -1
  function find_lsb (
    arg : STD_LOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER;
  
  function find_msb (
    arg : STD_LOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER;

  -- Repeat the same functions for STD_ULOGIC_VECTOR
  -- Id: A.3
  function "+" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Result: Adds two UNSIGNED vectors that may be of different lengths.

  -- Id: A.3R
  function "+"(L : STD_ULOGIC_VECTOR; R : STD_ULOGIC) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Similar to A.3 where R is a one bit std_logic_vector

  -- Id: A.3L
  function "+"(L : STD_ULOGIC; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Similar to A.3 where L is a one bit UNSIGNED

  -- Id: A.5
  function "+" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0).
  -- Result: Adds an UNSIGNED vector, L, with a non-negative INTEGER, R.

  -- Id: A.6
  function "+" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0).
  -- Result: Adds a non-negative INTEGER, L, with an UNSIGNED vector, R.

  --============================================================================

  -- Id: A.9
  function "-" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: UNSIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Result: Subtracts two UNSIGNED vectors that may be of different lengths.

  -- Id: A.9R
  function "-"(L : STD_ULOGIC_VECTOR; R : STD_ULOGIC) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Similar to A.9 where R is a one bit UNSIGNED

  -- Id: A.9L
  function "-"(L : STD_ULOGIC; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Similar to A.9 where L is a one bit UNSIGNED

  -- Id: A.11
  function "-" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0).
  -- Result: Subtracts a non-negative INTEGER, R, from an UNSIGNED vector, L.

  -- Id: A.12
  function "-" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0).
  -- Result: Subtracts an UNSIGNED vector, R, from a non-negative INTEGER, L.

  --============================================================================

  -- Id: A.15
  function "*" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector((L'LENGTH+R'LENGTH-1) downto 0).
  -- Result: Performs the multiplication operation on two UNSIGNED vectors
  --         that may possibly be of different lengths.

  -- Id: A.17
  function "*" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector((L'LENGTH+L'LENGTH-1) downto 0).
  -- Result: Multiplies an UNSIGNED vector, L, with a non-negative
  --         INTEGER, R. R is converted to an UNSIGNED vector of
  --         SIZE L'LENGTH before multiplication.

  -- Id: A.18
  function "*" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector((R'LENGTH+R'LENGTH-1) downto 0).
  -- Result: Multiplies an UNSIGNED vector, R, with a non-negative
  --         INTEGER, L. L is converted to an UNSIGNED vector of
  --         SIZE R'LENGTH before multiplication.

  --============================================================================
  --
  -- NOTE: If second argument is zero for "/" operator, a severity level
  --       of ERROR is issued.

  -- Id: A.21
  function "/" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Divides an UNSIGNED vector, L, by another UNSIGNED vector, R.

  -- Id: A.23
  function "/" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Divides an UNSIGNED vector, L, by a non-negative INTEGER, R.
  --         If NO_OF_BITS(R) > L'LENGTH, result is truncated to L'LENGTH.

  -- Id: A.24
  function "/" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Divides a non-negative INTEGER, L, by an UNSIGNED vector, R.
  --         If NO_OF_BITS(L) > R'LENGTH, result is truncated to R'LENGTH.

  --============================================================================
  --
  -- NOTE: If second argument is zero for "rem" operator, a severity level
  --       of ERROR is issued.

  -- Id: A.27
  function "rem" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where L and R are UNSIGNED vectors.

  -- Id: A.29
  function "rem" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where L is an UNSIGNED vector and R is a
  --         non-negative INTEGER.
  --         If NO_OF_BITS(R) > L'LENGTH, result is truncated to L'LENGTH.

  -- Id: A.30
  function "rem" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Computes "L rem R" where R is an UNSIGNED vector and L is a
  --         non-negative INTEGER.
  --         If NO_OF_BITS(L) > R'LENGTH, result is truncated to R'LENGTH.

  --============================================================================
  --
  -- NOTE: If second argument is zero for "mod" operator, a severity level
  --       of ERROR is issued.

  -- Id: A.33
  function "mod" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L and R are UNSIGNED vectors.

  -- Id: A.35
  function "mod" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(L'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where L is an UNSIGNED vector and R
  --         is a non-negative INTEGER.
  --         If NO_OF_BITS(R) > L'LENGTH, result is truncated to L'LENGTH.

  -- Id: A.36
  function "mod" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(R'LENGTH-1 downto 0)
  -- Result: Computes "L mod R" where R is an UNSIGNED vector and L
  --         is a non-negative INTEGER.
  --         If NO_OF_BITS(L) > R'LENGTH, result is truncated to R'LENGTH.

  --============================================================================
  -- Comparison Operators
  --============================================================================

  -- Id: C.1
  function ">" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.3
  function ">" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.5
  function ">" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L > R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.7
  function "<" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.9
  function "<" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.11
  function "<" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L < R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.13
  function "<=" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.15
  function "<=" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.17
  function "<=" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L <= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.19
  function ">=" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.21
  function ">=" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.23
  function ">=" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L >= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.25
  function "=" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.27
  function "=" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.29
  function "=" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L = R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  --============================================================================

  -- Id: C.31
  function "/=" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L and R are UNSIGNED vectors possibly
  --         of different lengths.

  -- Id: C.33
  function "/=" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L is a non-negative INTEGER and
  --         R is an UNSIGNED vector.

  -- Id: C.35
  function "/=" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN;
  -- Result subtype: BOOLEAN
  -- Result: Computes "L /= R" where L is an UNSIGNED vector and
  --         R is a non-negative INTEGER.

  -- Id: M.2B
  -- %%% function "?=" (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  -- %%% function "?/=" (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  -- %%% function "?>" (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  -- %%% function "?>=" (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  -- %%% function "?<" (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  -- %%% function "?<=" (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  function \?=\ (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  function \?/=\ (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  function \?>\ (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  function \?>=\ (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  function \?<\ (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  function \?<=\ (L, R : STD_ULOGIC_VECTOR) return std_ulogic;
  --============================================================================
  -- Shift and Rotate Functions
  --============================================================================

  -- Id: S.1
  function SHIFT_LEFT (ARG : STD_ULOGIC_VECTOR; COUNT : NATURAL)
    return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(ARG'LENGTH-1 downto 0)
  -- Result: Performs a shift-left on an UNSIGNED vector COUNT times.
  --         The vacated positions are filled with '0'.
  --         The COUNT leftmost elements are lost.

  -- Id: S.2
  function SHIFT_RIGHT (ARG : STD_ULOGIC_VECTOR; COUNT : NATURAL)
    return STD_ULOGIC_VECTOR;
  -- Result subtype: UNSIGNED(ARG'LENGTH-1 downto 0)
  -- Result: Performs a shift-right on an UNSIGNED vector COUNT times.
  --         The vacated positions are filled with '0'.
  --         The COUNT rightmost elements are lost.
  --============================================================================

  -- Id: S.5
  function ROTATE_LEFT (ARG : STD_ULOGIC_VECTOR; COUNT : NATURAL)
    return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(ARG'LENGTH-1 downto 0)
  -- Result: Performs a rotate-left of an UNSIGNED vector COUNT times.

  -- Id: S.6
  function ROTATE_RIGHT (ARG : STD_ULOGIC_VECTOR; COUNT : NATURAL)
    return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(ARG'LENGTH-1 downto 0)
  -- Result: Performs a rotate-right of an UNSIGNED vector COUNT times.


  --============================================================================
  --   RESIZE Functions
  --============================================================================

  -- Id: R.2
  function RESIZE (ARG : STD_ULOGIC_VECTOR; NEW_SIZE : NATURAL)
    return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(NEW_SIZE-1 downto 0)

  -- size_res version, uses the size of the "size_res" input
  -- to resize the output
  function RESIZE (ARG, SIZE_RES : STD_ULOGIC_VECTOR)
    return STD_ULOGIC_VECTOR;

  --============================================================================
  -- Conversion Functions
  --============================================================================

  -- Id: D.1
  function TO_INTEGER (ARG : STD_ULOGIC_VECTOR) return NATURAL;
  -- Result subtype: NATURAL. Value cannot be negative since parameter is an
  --             UNSIGNED vector.
  -- Result: Converts the UNSIGNED vector to an INTEGER.

  -- Id: D.3
  function To_StdULogicVector (ARG, SIZE : NATURAL) return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(SIZE-1 downto 0)
  -- Result: Converts a non-negative INTEGER to an UNSIGNED vector with
  --         the specified SIZE.
--  alias to_sulv is
--    To_StdULogicVector [NATURAL, NATURAL return STD_ULOGIC_VECTOR];
--  alias to_std_ulogic_vector is
--    To_StdULogicVector [NATURAL, NATURAL return STD_ULOGIC_VECTOR];
  function to_sulv (ARG, SIZE : NATURAL) return STD_ULOGIC_VECTOR;
  function to_std_ulogic_vector (ARG, SIZE : NATURAL) return STD_ULOGIC_VECTOR;

  -- size_res version, uses size_res to define the size of the output
  function To_StdULogicVector (ARG : NATURAL; SIZE_RES : STD_ULOGIC_VECTOR)
    return STD_ULOGIC_VECTOR;
  -- Result subtype: STD_ULOGIC_VECTOR(SIZE_RES'length-1 downto 0)
  -- Result: Converts a non-negative INTEGER to an STD_ULOGIC_VECTOR with
  --         the same size as SIZE_RES.
--  alias to_sulv is
--    To_StdULogicVector [NATURAL, STD_ULOGIC_VECTOR return STD_ULOGIC_VECTOR];
--  alias to_std_ulogic_vector is
--    To_StdULogicVector [NATURAL, STD_ULOGIC_VECTOR return STD_ULOGIC_VECTOR];
  function to_sulv (ARG : NATURAL; SIZE_RES : STD_ULOGIC_VECTOR)
    return STD_ULOGIC_VECTOR;
  function to_std_ulogic_vector (ARG : NATURAL; SIZE_RES : STD_ULOGIC_VECTOR)
    return STD_ULOGIC_VECTOR;

  --============================================================================
  -- Translation Functions
  --============================================================================

  -- Id: T.1
  function TO_01 (S : STD_ULOGIC_VECTOR; XMAP : STD_LOGIC := '0')
    return STD_ULOGIC_VECTOR;
  -- Result subtype: std_logic_vector(S'RANGE)
  -- Result: Termwise, 'H' is translated to '1', and 'L' is translated
  --         to '0'. If a value other than '0'|'1'|'H'|'L' is found,
  --         the array is set to (others => XMAP), and a warning is
  --         issued.

  -- add_carry procedures, to provide a carry in and a carry out
  procedure add_carry (
    L, R   : in  STD_ULOGIC_VECTOR;
    c_in   : in  STD_ULOGIC;
    result : out STD_ULOGIC_VECTOR;
    c_out  : out STD_ULOGIC);
  -- Result subtype: STD_ULOGIC_VECTOR(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Procedure takes a carry in into the adder, and provides a carry out.

  -- These are here to override the defaults for these functions
  function "sra" (ARG : STD_ULOGIC_VECTOR; COUNT : INTEGER)
    return STD_ULOGIC_VECTOR;
  function "sla" (ARG : STD_ULOGIC_VECTOR; COUNT : INTEGER)
    return STD_ULOGIC_VECTOR;

  -- Returns the maximum (or minimum) of the two numbers provided.
  -- All types (both inputs and the output) must be the same.
  function maximum (
    L, R : STD_ULOGIC_VECTOR)            -- inputs
    return STD_ULOGIC_VECTOR;

  function minimum (
    L, R : STD_ULOGIC_VECTOR)            -- inputs
    return STD_ULOGIC_VECTOR;

  -- Finds the first "Y" in the input string. Returns an integer index
  -- into that string.  If "Y" does not exist in the string, then a
  -- -1 is returned.
  function find_lsb (
    arg : STD_ULOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER;
  
  function find_msb (
    arg : STD_ULOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER;
end package NUMERIC_STD_UNSIGNED;

library ieee;
use ieee.numeric_std.all;
use work.numeric_std_additions.all;
package body NUMERIC_STD_UNSIGNED is

  -- Id: A.3
  function "+" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) + UNSIGNED(R));
  end function "+";

  -- Id: A.5
  function "+" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) + R);
  end function "+";

  -- Id: A.6
  function "+" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (L + UNSIGNED(R));
  end function "+";

  --============================================================================

  -- Id: A.9
  function "-" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) - UNSIGNED(R));
  end function "-";

  -- Id: A.11
  function "-" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) - R);
  end function "-";

  -- Id: A.12
  function "-" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (L - UNSIGNED(R));
  end function "-";

  --============================================================================

  -- Id: A.15
  function "*" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) * UNSIGNED(R));
  end function "*";

  -- Id: A.17
  function "*" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) * R);
  end function "*";

  -- Id: A.18
  function "*" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (L * UNSIGNED(R));
  end function "*";

  --============================================================================

  -- Id: A.21
  function "/" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) / UNSIGNED(R));
  end function "/";

  -- Id: A.23
  function "/" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) / R);
  end function "/";

  -- Id: A.24
  function "/" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (L / UNSIGNED(R));
  end function "/";

  --============================================================================

  -- Id: A.27
  function "rem" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) rem UNSIGNED(R));
  end function "rem";

  -- Id: A.29
  function "rem" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) rem R);
  end function "rem";

  -- Id: A.30
  function "rem" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (L rem UNSIGNED(R));
  end function "rem";

  --============================================================================

  -- Id: A.33
  function "mod" (L, R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) mod UNSIGNED(R));
  end function "mod";

  -- Id: A.35
  function "mod" (L : STD_LOGIC_VECTOR; R : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (UNSIGNED(L) mod R);
  end function "mod";

  -- Id: A.36
  function "mod" (L : NATURAL; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (L mod UNSIGNED(R));
  end function "mod";

  --============================================================================

  -- Id: C.1
  function ">" (L, R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return UNSIGNED(L) > UNSIGNED(R);
  end function ">";

  -- Id: C.3
  function ">" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return L > UNSIGNED(R);
  end function ">";

  -- Id: C.5
  function ">" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return UNSIGNED(L) > R;
  end function ">";

  --============================================================================

  -- Id: C.7
  function "<" (L, R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return UNSIGNED(L) < UNSIGNED(R);
  end function "<";

  -- Id: C.9
  function "<" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return L < UNSIGNED(R);
  end function "<";

  -- Id: C.11
  function "<" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return UNSIGNED(L) < R;
  end function "<";

  --============================================================================

  -- Id: C.13
  function "<=" (L, R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return UNSIGNED(L) <= UNSIGNED(R);
  end function "<=";

  -- Id: C.15
  function "<=" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return L <= UNSIGNED(R);
  end function "<=";

  -- Id: C.17
  function "<=" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return UNSIGNED(L) <= R;
  end function "<=";

  --============================================================================

  -- Id: C.19
  function ">=" (L, R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return UNSIGNED(L) >= UNSIGNED(R);
  end function ">=";

  -- Id: C.21
  function ">=" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return L >= UNSIGNED(R);
  end function ">=";

  -- Id: C.23
  function ">=" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return UNSIGNED(L) >= R;
  end function ">=";

  --============================================================================

  -- Id: C.25
  function "=" (L, R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return UNSIGNED(L) = UNSIGNED(R);
  end function "=";

  -- Id: C.27
  function "=" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return L = UNSIGNED(R);
  end function "=";

  -- Id: C.29
  function "=" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return UNSIGNED(L) = R;
  end function "=";

  --============================================================================

  -- Id: C.31
  function "/=" (L, R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return UNSIGNED(L) /= UNSIGNED(R);
  end function "/=";

  -- Id: C.33
  function "/=" (L : NATURAL; R : STD_LOGIC_VECTOR) return BOOLEAN is
  begin
    return L /= UNSIGNED(R);
  end function "/=";

  -- Id: C.35
  function "/=" (L : STD_LOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return UNSIGNED(L) /= R;
  end function "/=";

  --============================================================================

  -- Id: S.1
  function SHIFT_LEFT (ARG : STD_LOGIC_VECTOR; COUNT : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (SHIFT_LEFT(unsigned(ARG), COUNT));
  end function SHIFT_LEFT;

  -- Id: S.2
  function SHIFT_RIGHT (ARG : STD_LOGIC_VECTOR; COUNT : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (SHIFT_RIGHT(unsigned(ARG), COUNT));
  end function SHIFT_RIGHT;

  --============================================================================

  -- Id: S.5
  function ROTATE_LEFT (ARG : STD_LOGIC_VECTOR; COUNT : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (ROTATE_LEFT(unsigned(ARG), COUNT));
  end function ROTATE_LEFT;

  -- Id: S.6
  function ROTATE_RIGHT (ARG : STD_LOGIC_VECTOR; COUNT : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (ROTATE_RIGHT(unsigned(ARG), COUNT));
  end function ROTATE_RIGHT;

  --============================================================================

  -- Id: D.1
  function TO_INTEGER (ARG : STD_LOGIC_VECTOR) return NATURAL is
  begin
    return TO_INTEGER(UNSIGNED(ARG));
  end function TO_INTEGER;

  -- Id: D.3
  function To_StdLogicVector (ARG, SIZE : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (to_unsigned(ARG  => ARG,
                                         SIZE => SIZE));
  end function To_StdLogicVector;

  -- size_res version, uses size_res to define the size of the output
  function To_StdLogicVector (ARG : NATURAL; SIZE_RES : STD_LOGIC_VECTOR)
    return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (to_unsigned(ARG      => ARG,
                                         SIZE_RES => unsigned(SIZE_RES)));
  end function To_StdLogicVector;

  function To_slv (ARG, SIZE : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (to_unsigned(ARG  => ARG,
                                         SIZE => SIZE));
  end function To_slv;

  -- size_res version, uses size_res to define the size of the output
  function To_slv (ARG : NATURAL; SIZE_RES : STD_LOGIC_VECTOR)
    return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (to_unsigned(ARG      => ARG,
                                         SIZE_RES => unsigned(SIZE_RES)));
  end function To_slv;

  function To_Std_Logic_Vector (ARG, SIZE : NATURAL) return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (to_unsigned(ARG  => ARG,
                                         SIZE => SIZE));
  end function To_Std_Logic_Vector;

  -- size_res version, uses size_res to define the size of the output
  function To_Std_Logic_Vector (ARG : NATURAL; SIZE_RES : STD_LOGIC_VECTOR)
    return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (to_unsigned(ARG      => ARG,
                                         SIZE_RES => unsigned(SIZE_RES)));
  end function To_Std_Logic_Vector;

  --============================================================================

  -- function TO_01 is used to convert vectors to the
  --          correct form for exported functions,
  --          and to report if there is an element which
  --          is not in (0, 1, H, L).

  -- Id: T.1
  function TO_01 (S : STD_LOGIC_VECTOR; XMAP : STD_LOGIC := '0')
    return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (
      to_01 (S    => unsigned(S),
             XMAP => XMAP));
  end function TO_01;

  -- Id: R.2
  function RESIZE (ARG : STD_LOGIC_VECTOR; NEW_SIZE : NATURAL)
    return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector (
      RESIZE (ARG      => unsigned(ARG),
              NEW_SIZE => NEW_SIZE));
  end function RESIZE;

  -- size_res version, uses the size of the "size_res" input
  -- to resize the output
  function RESIZE (ARG, SIZE_RES : STD_LOGIC_VECTOR)
    return STD_LOGIC_VECTOR is
  begin
    return STD_LOGIC_VECTOR (
      RESIZE (ARG      => unsigned(ARG),
              SIZE_RES => unsigned(SIZE_RES)));
  end function RESIZE;
--==============================================================================
--============================= New subprograms ================================
--==============================================================================

  -- Id: A.3R
  function "+"(L : STD_LOGIC_VECTOR; R : STD_ULOGIC) return STD_LOGIC_VECTOR is
    variable XR : STD_LOGIC_VECTOR(L'length-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L + XR);
  end function "+";

  -- Id: A.3L
  function "+"(L : STD_ULOGIC; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
    variable XL : STD_LOGIC_VECTOR(R'length-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL + R);
  end function "+";

  -- Id: A.9R
  function "-"(L : STD_LOGIC_VECTOR; R : STD_ULOGIC) return STD_LOGIC_VECTOR is
    variable XR : STD_LOGIC_VECTOR(L'length-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L - XR);
  end function "-";

  -- Id: A.9L
  function "-"(L : STD_ULOGIC; R : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
    variable XL : STD_LOGIC_VECTOR(R'length-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL - R);
  end function "-";

  -- Result subtype: UNSIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Procedure takes a carry in into the adder, and provides a carry out.
  procedure add_carry (
    L, R   : in  STD_LOGIC_VECTOR;
    c_in   : in  STD_ULOGIC;
    result : out STD_LOGIC_VECTOR;
    c_out  : out STD_ULOGIC) is
    variable result_i : UNSIGNED (L'length-1 downto 0);
  begin
    add_carry (L      => unsigned(L),
               R      => unsigned(R),
               c_in   => c_in,
               result => result_i,
               c_out  => c_out);
    result := STD_LOGIC_VECTOR (result_i);
  end procedure add_carry;

    -- These are here to override the defaults for these functions
  function "sra" (ARG : STD_LOGIC_VECTOR; COUNT : INTEGER)
    RETURN STD_LOGIC_VECTOR is
    variable result_i : UNSIGNED (ARG'length-1 downto 0);  -- unsigned version of arg
  begin
    result_i := UNSIGNED (arg);
    result_i := result_i sra COUNT;
    return STD_LOGIC_VECTOR (result_i);
  end function "sra";
  
  function "sla" (ARG : STD_LOGIC_VECTOR; COUNT : INTEGER)
    RETURN STD_LOGIC_VECTOR is
    variable result_i : UNSIGNED (ARG'length-1 downto 0);  -- unsigned version of arg
  begin
    result_i := UNSIGNED (arg);
    result_i := result_i sla COUNT;
    return STD_LOGIC_VECTOR (result_i);
  end function "sla";
  
  -----------------------------------------------------------------------------
  -- New/updated functions for VHDL-200X fast track
  -----------------------------------------------------------------------------
  -- These override the implicit functions.
  function maximum (
    L, R : STD_LOGIC_VECTOR)            -- inputs
    return STD_LOGIC_VECTOR is
  begin  -- function maximum
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  -- std_logic_vector output
  function minimum (
    L, R : STD_LOGIC_VECTOR)            -- inputs
    return STD_LOGIC_VECTOR is
  begin  -- function minimum
    if L > R then return R;
    else return L;
    end if;
  end function minimum;

  function find_lsb (
    arg : STD_LOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER is
  begin
    return find_lsb (arg => unsigned(arg),
                     y   => y);
  end function find_lsb;

  function find_msb (
    arg : STD_LOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER is
  begin
    return find_msb (arg => unsigned(arg),
                     y   => y);
  end function find_msb;

  -- These need to be overloaded because the meaning of the compare operators
  -- has changed.
  -- %%% Replace with the following (new syntax)
  -- %%% function "?="  (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC;
  function \?=\ (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?=\ (UNSIGNED (L), UNSIGNED (R));
  end function \?=\;
  -- %%% end function "?=";

  -- %%% function "?/=" (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  function \?/=\ (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?/=\ (UNSIGNED (L), UNSIGNED (R));
  end function \?/=\;
  -- %%% end function "?/=";

  -- %%% function "?>" (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  function \?>\ (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?>\ (UNSIGNED (L), UNSIGNED (R));
  end function \?>\;
  -- %%% end function "?>";

  -- %%% function "?>=" (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  function \?>=\ (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?>=\ (UNSIGNED (L), UNSIGNED (R));
  end function \?>=\;
  -- %%% end function "?>=";

  -- %%% function "?<" (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  function \?<\ (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?<\ (UNSIGNED (L), UNSIGNED (R));
  end function \?<\;
  -- %%% end function "?<";

  -- %%% function "?<=" (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  function \?<=\ (L, R : STD_LOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?<=\ (UNSIGNED (L), UNSIGNED (R));
  end function \?<=\;
  -- %%% end function "?<=";
  ----------------------------------------------------------------------------
  -- Std_Ulogic_Vector versions
  ----------------------------------------------------------------------------
  -- Conversion functions, these are needed because the base type of "UNSIGNED"
  -- is std_logic, not STD_ULOGIC
  -- purpose: Converts a std_ulogic_vector to an unsigned
  function to_unsigned (
    arg : STD_ULOGIC_VECTOR)
    return UNSIGNED is
  begin
    return UNSIGNED (to_stdlogicvector (arg));
  end function to_unsigned;

  -- purpose: Converts an unsiged to a std_ulogic_vector
  function to_sulv (
    arg : UNSIGNED)
    return STD_ULOGIC_VECTOR is
  begin
    return to_stdulogicvector (STD_LOGIC_VECTOR (arg));
  end function to_sulv;
  -- 
  -- Id: A.3
  function "+" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) + to_unsigned(R));
  end function "+";

  -- Id: A.5
  function "+" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) + R);
  end function "+";

  -- Id: A.6
  function "+" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (L + to_unsigned(R));
  end function "+";

  --============================================================================

  -- Id: A.9
  function "-" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) - to_unsigned(R));
  end function "-";

  -- Id: A.11
  function "-" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) - R);
  end function "-";

  -- Id: A.12
  function "-" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (L - to_unsigned(R));
  end function "-";

  --============================================================================

  -- Id: A.15
  function "*" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) * to_unsigned(R));
  end function "*";

  -- Id: A.17
  function "*" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) * R);
  end function "*";

  -- Id: A.18
  function "*" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (L * to_unsigned(R));
  end function "*";

  --============================================================================

  -- Id: A.21
  function "/" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) / to_unsigned(R));
  end function "/";

  -- Id: A.23
  function "/" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) / R);
  end function "/";

  -- Id: A.24
  function "/" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (L / to_unsigned(R));
  end function "/";

  --============================================================================

  -- Id: A.27
  function "rem" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) rem to_unsigned(R));
  end function "rem";

  -- Id: A.29
  function "rem" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) rem R);
  end function "rem";

  -- Id: A.30
  function "rem" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (L rem to_unsigned(R));
  end function "rem";

  --============================================================================

  -- Id: A.33
  function "mod" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) mod to_unsigned(R));
  end function "mod";

  -- Id: A.35
  function "mod" (L : STD_ULOGIC_VECTOR; R : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(L) mod R);
  end function "mod";

  -- Id: A.36
  function "mod" (L : NATURAL; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (L mod to_unsigned(R));
  end function "mod";

  --============================================================================

  -- Id: C.1
  function ">" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return to_unsigned(L) > to_unsigned(R);
  end function ">";

  -- Id: C.3
  function ">" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return L > to_unsigned(R);
  end function ">";

  -- Id: C.5
  function ">" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return to_unsigned(L) > R;
  end function ">";

  --============================================================================

  -- Id: C.7
  function "<" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return to_unsigned(L) < to_unsigned(R);
  end function "<";

  -- Id: C.9
  function "<" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return L < to_unsigned(R);
  end function "<";

  -- Id: C.11
  function "<" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return to_unsigned(L) < R;
  end function "<";

  --============================================================================

  -- Id: C.13
  function "<=" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return to_unsigned(L) <= to_unsigned(R);
  end function "<=";

  -- Id: C.15
  function "<=" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return L <= to_unsigned(R);
  end function "<=";

  -- Id: C.17
  function "<=" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return to_unsigned(L) <= R;
  end function "<=";

  --============================================================================

  -- Id: C.19
  function ">=" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return to_unsigned(L) >= to_unsigned(R);
  end function ">=";

  -- Id: C.21
  function ">=" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return L >= to_unsigned(R);
  end function ">=";

  -- Id: C.23
  function ">=" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return to_unsigned(L) >= R;
  end function ">=";

  --============================================================================

  -- Id: C.25
  function "=" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return to_unsigned(L) = to_unsigned(R);
  end function "=";

  -- Id: C.27
  function "=" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return L = to_unsigned(R);
  end function "=";

  -- Id: C.29
  function "=" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return to_unsigned(L) = R;
  end function "=";

  --============================================================================

  -- Id: C.31
  function "/=" (L, R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return to_unsigned(L) /= to_unsigned(R);
  end function "/=";

  -- Id: C.33
  function "/=" (L : NATURAL; R : STD_ULOGIC_VECTOR) return BOOLEAN is
  begin
    return L /= to_unsigned(R);
  end function "/=";

  -- Id: C.35
  function "/=" (L : STD_ULOGIC_VECTOR; R : NATURAL) return BOOLEAN is
  begin
    return to_unsigned(L) /= R;
  end function "/=";

  --============================================================================

  -- Id: S.1
  function SHIFT_LEFT (ARG : STD_ULOGIC_VECTOR; COUNT : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (SHIFT_LEFT(unsigned(ARG), COUNT));
  end function SHIFT_LEFT;

  -- Id: S.2
  function SHIFT_RIGHT (ARG : STD_ULOGIC_VECTOR; COUNT : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (SHIFT_RIGHT(unsigned(ARG), COUNT));
  end function SHIFT_RIGHT;

  --============================================================================

  -- Id: S.5
  function ROTATE_LEFT (ARG : STD_ULOGIC_VECTOR; COUNT : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (ROTATE_LEFT(unsigned(ARG), COUNT));
  end function ROTATE_LEFT;

  -- Id: S.6
  function ROTATE_RIGHT (ARG : STD_ULOGIC_VECTOR; COUNT : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (ROTATE_RIGHT(unsigned(ARG), COUNT));
  end function ROTATE_RIGHT;

  --============================================================================

  -- Id: D.1
  function TO_INTEGER (ARG : STD_ULOGIC_VECTOR) return NATURAL is
  begin
    return TO_INTEGER(to_unsigned(ARG));
  end function TO_INTEGER;

  -- Id: D.3
  function To_StdULogicVector (ARG, SIZE : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(ARG  => ARG,
                                         SIZE => SIZE));
  end function To_StdULogicVector;

  -- size_res version, uses size_res to define the size of the output
  function To_StdULogicVector (ARG : NATURAL; SIZE_RES : STD_ULOGIC_VECTOR)
    return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(ARG      => ARG,
                                         SIZE_RES => unsigned(SIZE_RES)));
  end function To_StdULogicVector;

  function To_sulv (ARG, SIZE : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return To_sulv (to_unsigned(ARG  => ARG,
                                         SIZE => SIZE));
  end function To_sulv;

  -- size_res version, uses size_res to define the size of the output
  function To_sulv (ARG : NATURAL; SIZE_RES : STD_ULOGIC_VECTOR)
    return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (to_unsigned(ARG      => ARG,
                                SIZE_RES => to_unsigned(SIZE_RES)));
  end function To_sulv;

  function To_Std_ULogic_Vector (ARG, SIZE : NATURAL) return STD_ULOGIC_VECTOR is
  begin
    return To_sulv (to_unsigned(ARG  => ARG,
                                SIZE => SIZE));
  end function To_Std_ULogic_Vector;

  -- size_res version, uses size_res to define the size of the output
  function To_Std_ULogic_Vector (ARG : NATURAL; SIZE_RES : STD_ULOGIC_VECTOR)
    return STD_ULOGIC_VECTOR is
  begin
    return To_sulv (to_unsigned(ARG      => ARG,
                                SIZE_RES => to_unsigned(SIZE_RES)));
  end function To_Std_ULogic_Vector;

  --============================================================================

  -- function TO_01 is used to convert vectors to the
  --          correct form for exported functions,
  --          and to report if there is an element which
  --          is not in (0, 1, H, L).

  -- Id: T.1
  function TO_01 (S : STD_ULOGIC_VECTOR; XMAP : STD_LOGIC := '0')
    return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (
      to_01 (S    => unsigned(S),
             XMAP => XMAP));
  end function TO_01;

  -- Id: R.2
  function RESIZE (ARG : STD_ULOGIC_VECTOR; NEW_SIZE : NATURAL)
    return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (
      RESIZE (ARG      => unsigned(ARG),
              NEW_SIZE => NEW_SIZE));
  end function RESIZE;

  -- size_res version, uses the size of the "size_res" input
  -- to resize the output
  function RESIZE (ARG, SIZE_RES : STD_ULOGIC_VECTOR)
    return STD_ULOGIC_VECTOR is
  begin
    return to_sulv (
      RESIZE (ARG      => unsigned(ARG),
              SIZE_RES => unsigned(SIZE_RES)));
  end function RESIZE;
--==============================================================================
--============================= New subprograms ================================
--==============================================================================

  -- Id: A.3R
  function "+"(L : STD_ULOGIC_VECTOR; R : STD_ULOGIC) return STD_ULOGIC_VECTOR is
    variable XR : STD_ULOGIC_VECTOR(L'length-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L + XR);
  end function "+";

  -- Id: A.3L
  function "+"(L : STD_ULOGIC; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
    variable XL : STD_ULOGIC_VECTOR(R'length-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL + R);
  end function "+";

  -- Id: A.9R
  function "-"(L : STD_ULOGIC_VECTOR; R : STD_ULOGIC) return STD_ULOGIC_VECTOR is
    variable XR : STD_ULOGIC_VECTOR(L'length-1 downto 0) := (others => '0');
  begin
    XR(0) := R;
    return (L - XR);
  end function "-";

  -- Id: A.9L
  function "-"(L : STD_ULOGIC; R : STD_ULOGIC_VECTOR) return STD_ULOGIC_VECTOR is
    variable XL : STD_ULOGIC_VECTOR(R'length-1 downto 0) := (others => '0');
  begin
    XL(0) := L;
    return (XL - R);
  end function "-";

  -- Result subtype: UNSIGNED(MAX(L'LENGTH, R'LENGTH)-1 downto 0).
  -- Procedure takes a carry in into the adder, and provides a carry out.
  procedure add_carry (
    L, R   : in  STD_ULOGIC_VECTOR;
    c_in   : in  STD_ULOGIC;
    result : out STD_ULOGIC_VECTOR;
    c_out  : out STD_ULOGIC) is
    variable result_i : UNSIGNED (L'length-1 downto 0);
  begin
    add_carry (L      => to_unsigned(L),
               R      => to_unsigned(R),
               c_in   => c_in,
               result => result_i,
               c_out  => c_out);
    result := to_sulv (result_i);
  end procedure add_carry;

    -- These are here to override the defaults for these functions
  function "sra" (ARG : STD_ULOGIC_VECTOR; COUNT : INTEGER)
    RETURN STD_ULOGIC_VECTOR is
    variable result_i : UNSIGNED (ARG'length-1 downto 0);  -- unsigned version of arg
  begin
    result_i := to_unsigned (arg);
    result_i := result_i sra COUNT;
    return to_sulv (result_i);
  end function "sra";
  
  function "sla" (ARG : STD_ULOGIC_VECTOR; COUNT : INTEGER)
    RETURN STD_ULOGIC_VECTOR is
    variable result_i : UNSIGNED (ARG'length-1 downto 0);  -- unsigned version of arg
  begin
    result_i := to_unsigned (arg);
    result_i := result_i sla COUNT;
    return to_sulv (result_i);
  end function "sla";
  
  -----------------------------------------------------------------------------
  -- New/updated functions for VHDL-200X fast track
  -----------------------------------------------------------------------------
  -- These override the implicit functions.
  function maximum (
    L, R : STD_ULOGIC_VECTOR)            -- inputs
    return STD_ULOGIC_VECTOR is
  begin  -- function maximum
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  -- std_ulogic_vector output
  function minimum (
    L, R : STD_ULOGIC_VECTOR)            -- inputs
    return STD_ULOGIC_VECTOR is
  begin  -- function minimum
    if L > R then return R;
    else return L;
    end if;
  end function minimum;

  function find_lsb (
    arg : STD_ULOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER is
  begin
    return find_lsb (arg => to_unsigned(arg),
                     y   => y);
  end function find_lsb;

  function find_msb (
    arg : STD_ULOGIC_VECTOR;             -- vector argument
    y   : STD_ULOGIC)                   -- look for this bit
    return INTEGER is
  begin
    return find_msb (arg => to_unsigned(arg),
                     y   => y);
  end function find_msb;

  -- These need to be overloaded because the meaning of the compare operators
  -- has changed.
  -- %%% Replace with the following (new syntax)
  -- %%% function "?="  (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC;
  function \?=\ (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?=\ (to_unsigned (L), to_unsigned (R));
  end function \?=\;
  -- %%% end function "?=";

  -- %%% function "?/=" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  function \?/=\ (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?/=\ (to_unsigned (L), to_unsigned (R));
  end function \?/=\;
  -- %%% end function "?/=";

  -- %%% function "?>" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  function \?>\ (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?>\ (to_unsigned (L), to_unsigned (R));
  end function \?>\;
  -- %%% end function "?>";

  -- %%% function "?>=" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  function \?>=\ (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?>=\ (to_unsigned (L), to_unsigned (R));
  end function \?>=\;
  -- %%% end function "?>=";

  -- %%% function "?<" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  function \?<\ (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?<\ (to_unsigned (L), to_unsigned (R));
  end function \?<\;
  -- %%% end function "?<";

  -- %%% function "?<=" (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  function \?<=\ (L, R : STD_ULOGIC_VECTOR) return STD_ULOGIC is
  begin
    return  \?<=\ (to_unsigned (L), to_unsigned (R));
  end function \?<=\;
  -- %%% end function "?<=";
end package body NUMERIC_STD_UNSIGNED;
