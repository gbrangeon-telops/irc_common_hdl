------------------------------------------------------------------------------
-- "standard_textio_additions" package contains the additions to the built in
-- "standard.textio" package.
-- This package should be compiled into "ieee_proposed" and used as follows:
-- use ieee_proposed.standard_textio_additions.all;
-- Last Modified: $Date: 2005-07-22 14:29:19-04 $
-- RCS ID: $Id: standard_textio_additions_c.vhd,v 1.3 2005-07-22 14:29:19-04 l435385 Exp $
--
--  Created for VHDL-200X par, David Bishop (dbishop@vhdl.org)
------------------------------------------------------------------------------
use work.standard_additions.all;        -- %%% For testing only.
use std.textio.all;                     -- %%% For testing only.
package standard_textio_additions is
  -- pragma synthesis_off
  -- Writes L to a file and to the OUTPUT.  Similar to the UNIX tee command
  procedure tee (FILE F : TEXT; variable L : inout LINE);

  -- Read and Write procedure for strings
  -- token based string read.  STRLEN = 0 if the String read is bad
  procedure SREAD (L : inout LINE; VALUE : out STRING; STRLEN : out natural);
  --  alias SWRITE is WRITE [LINE, STRING, SIDE, WIDTH];
  procedure SWRITE (L : inout LINE; VALUE : in STRING;
                    JUSTIFIED : in SIDE := right; FIELD : in WIDTH := 0);

  -- Read and Write procedures for Hexadecimal values
  procedure HREAD (L : inout LINE; VALUE : out BIT_VECTOR; GOOD : out BOOLEAN);
  procedure HREAD (L : inout LINE; VALUE : out BIT_VECTOR);

  procedure HWRITE (L : inout LINE; VALUE : in BIT_VECTOR;
                    JUSTIFIED : in SIDE := right; FIELD : in WIDTH := 0);

  -- Read and Write procedures for Octal values
  procedure OREAD (L : inout LINE; VALUE : out BIT_VECTOR; GOOD : out BOOLEAN);
  procedure OREAD (L : inout LINE; VALUE : out BIT_VECTOR);

  procedure OWRITE (L : inout LINE; VALUE : in BIT_VECTOR;
                    JUSTIFIED : in SIDE := right; FIELD : in WIDTH := 0);

  -- Read and Write procedures for Binary values
--  alias BREAD is READ [LINE, BIT_VECTOR, BOOLEAN];
--  alias BREAD is READ [LINE, BIT_VECTOR];
--  alias BWRITE is WRITE [LINE, BIT_VECTOR, SIDE, WIDTH];
  procedure BREAD (L : inout LINE; VALUE : out BIT_VECTOR; GOOD : out BOOLEAN);
  procedure BREAD (L : inout LINE; VALUE : out BIT_VECTOR);
  procedure BWRITE (L : inout LINE; VALUE : in BIT_VECTOR;
                    JUSTIFIED : in SIDE := right; FIELD : in WIDTH := 0);

  -- read and write for vector versions
  -- These versions produce "value1, value2, value3 ...."
  procedure read (L : inout LINE; VALUE : out boolean_vector;
                  GOOD : out BOOLEAN);
  procedure read (L : inout LINE; VALUE : out boolean_vector);
  procedure write (L : inout LINE; VALUE : in boolean_vector;
                   JUSTIFIED : in SIDE := right; FIELD : in WIDTH := 0);
  procedure read (L : inout LINE; VALUE : out integer_vector;
                  GOOD : out BOOLEAN);
  procedure read (L : inout LINE; VALUE : out integer_vector);
  procedure write (L : inout LINE; VALUE : in integer_vector;
                   JUSTIFIED : in SIDE := right; FIELD : in WIDTH := 0);
  procedure read (L : inout LINE; VALUE : out real_vector;
                  GOOD : out BOOLEAN);
  procedure read (L : inout LINE; VALUE : out real_vector);
  procedure write (L : inout LINE; VALUE : in real_vector;
                   JUSTIFIED : in SIDE := right; FIELD : in WIDTH := 0;
                   DIGITS : in NATURAL := 0);
  procedure read (L : inout LINE; VALUE : out time_vector;
                  GOOD : out BOOLEAN);
  procedure read (L : inout LINE; VALUE : out time_vector);
  procedure write (L : inout LINE; VALUE : in time_vector;
                   JUSTIFIED : in SIDE := right; FIELD : in WIDTH := 0;
                   UNIT : in TIME := ns);

  -- to_string routines
  -- Justify a string left or right, for a given width
  function justify (
    VALUE     : in STRING;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0)
    return STRING;
  -- Bit vector to string
  function to_string (
    VALUE     : in BIT_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  -- bit_vector to binary string (alias)
  alias to_bstring is to_string [BIT_VECTOR, SIDE, WIDTH return STRING];
  -- bit_vector to Hex string
  function to_hstring (
    VALUE     : in BIT_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  -- bit_vector to Octal string
  function to_ostring (
    VALUE     : in BIT_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;

  -- to_string functions for the type from std.standard
  function to_string (
    VALUE     : in INTEGER;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  function to_string (
    VALUE     : in BIT;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  function to_string (
    VALUE     : in BOOLEAN;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  function to_string (
    VALUE     : in SEVERITY_LEVEL;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  function to_string (
    VALUE     : in FILE_OPEN_KIND;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  function to_string (
    VALUE     : in FILE_OPEN_STATUS;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  function to_string (
    VALUE     : in SIDE;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  -- returns number of digits, similar to write (REAL, SIDE, FIELD, DIGITS)
  function to_string (
    VALUE     : in REAL;
    JUSTIFIED : in SIDE    := right;
    FIELD     : in WIDTH   := 0;
    DIGITS    : in NATURAL := 0
    ) return STRING ;
  -- Format is similar to the C printf format " " means real'image
  -- Example to_string (3.14159, "%5.3f") returns "3.142"
  function to_string (
    VALUE  : in REAL;
    format : in STRING
    ) return STRING ;
  -- Returns the time in the units specified.
  -- similar to write (TIME, SIDE, FIELD, UNIT);
  function to_string (
    VALUE     : in TIME;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0;
    UNIT      : in TIME  := ns
    ) return STRING ;

  -- vector versions
  function to_string (
    VALUE     : in BOOLEAN_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  function to_string (
    VALUE     : in INTEGER_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING ;
  function to_string (
    VALUE     : in REAL_VECTOR;
    JUSTIFIED : in SIDE    := right;
    FIELD     : in WIDTH   := 0;
    DIGITS    : in NATURAL := 0
    ) return STRING ;
  function to_string (
    VALUE  : in REAL_VECTOR;
    format : in STRING
    ) return STRING ;
  function to_string (
    VALUE     : in TIME_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0;
    UNIT      : in TIME  := ns
    ) return STRING ;

-- pragma synthesis_on
  -- Will be implicit
  function minimum (L, R : SIDE) return SIDE;
  function maximum (L, R : SIDE) return SIDE;
end package standard_textio_additions;

package body standard_textio_additions is
-- pragma synthesis_off
  constant NUS  : STRING(2 to 1) := (others => ' ');     -- NULL array
  constant NBSP : CHARACTER      := CHARACTER'val(160);  -- space character

  -- Writes L to a file without modifying the contents of the line
  procedure tee (file F : TEXT; variable L : inout LINE) is
  begin
    write (OUTPUT, L.all & NL);
    writeline(F, L);
  end procedure tee;

  -- Read and Write procedure for strings
  procedure SREAD (L      : inout LINE;
                   VALUE  : out   STRING;
                   STRLEN : out   natural) is
    variable ok     : BOOLEAN;
    variable c      : CHARACTER;
    -- Result is padded with space characters
    variable result : STRING (1 to VALUE'length) := (others => ' ');
  begin
    VALUE := result;
    loop                                -- skip white space
      read(L, c, ok);
      exit when (ok = false) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
      STRLEN := 0;
      return;
    end if;
    result (1) := c;
    STRLEN     := 1;
    for i in 2 to VALUE'length loop
      read(L, c, ok);
      if (ok = false) or ((c = ' ') or (c = NBSP) or (c = HT)) then
        exit;
      else
        result (i) := c;
      end if;
      STRLEN := i;
    end loop;
    VALUE := result;
  end procedure SREAD;

  -- alias SWRITE is WRITE [LINE, STRING, SIDE, WIDTH];
  procedure SWRITE (L         : inout LINE;
                    VALUE     : in    STRING;
                    JUSTIFIED : in    SIDE  := right;
                    FIELD     : in    WIDTH := 0) is
  begin
    WRITE (L         => L,
           VALUE     => VALUE,
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD);
  end procedure SWRITE;
  -- Hex Read and Write procedures for bit_vector.
  -- Procedure only visible internally.
  procedure Char2QuadBits (C           :     CHARACTER;
                           RESULT      : out BIT_VECTOR(3 downto 0);
                           GOOD        : out BOOLEAN;
                           ISSUE_ERROR : in  BOOLEAN) is
  begin
    case c is
      when '0'       => result := x"0"; good := true;
      when '1'       => result := x"1"; good := true;
      when '2'       => result := x"2"; good := true;
      when '3'       => result := x"3"; good := true;
      when '4'       => result := x"4"; good := true;
      when '5'       => result := x"5"; good := true;
      when '6'       => result := x"6"; good := true;
      when '7'       => result := x"7"; good := true;
      when '8'       => result := x"8"; good := true;
      when '9'       => result := x"9"; good := true;
      when 'A' | 'a' => result := x"A"; good := true;
      when 'B' | 'b' => result := x"B"; good := true;
      when 'C' | 'c' => result := x"C"; good := true;
      when 'D' | 'd' => result := x"D"; good := true;
      when 'E' | 'e' => result := x"E"; good := true;
      when 'F' | 'f' => result := x"F"; good := true;
      when others    =>
        assert not ISSUE_ERROR report
          "TEXTIO.HREAD Error: Read a '" & c &
          "', expected a Hex character (0-F)." severity error;
        GOOD := false;
    end case;
  end procedure Char2QuadBits;

  procedure HREAD (L     : inout LINE;
                   VALUE : out   BIT_VECTOR;
                   GOOD  : out   BOOLEAN) is
    variable ok  : BOOLEAN;
    variable c   : CHARACTER;
    constant ne  : INTEGER                    := (VALUE'length+3)/4;
    constant pad : INTEGER                    := ne*4 - VALUE'length;
    variable sv  : BIT_VECTOR (0 to ne*4 - 1) := (others => '0');
    variable s   : STRING(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => '0');
    loop                                -- skip white space
      read(l, c, ok);
      exit when (ok = false) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
      GOOD := false;
      return;
    end if;
    Char2QuadBits(c, sv(0 to 3), ok, false);
    if not ok then
      GOOD := false;
      return;
    end if;
    read(L, s, ok);
    if not ok then
      GOOD := false;
      return;
    end if;
    for i in 1 to ne-1 loop
      Char2QuadBits(s(i), sv(4*i to 4*i+3), ok, false);
      if not ok then
        GOOD := false;
        return;
      end if;
    end loop;
    if or_reduce (sv (0 to pad-1)) = '1' then
      GOOD := false;                    -- vector was truncated.
    else
      GOOD  := true;
      VALUE := sv (pad to sv'high);
    end if;
  end procedure HREAD;

  procedure HREAD (L     : inout LINE;
                   VALUE : out   BIT_VECTOR) is
    variable ok  : BOOLEAN;
    variable c   : CHARACTER;
    constant ne  : INTEGER                   := (VALUE'length+3)/4;
    constant pad : INTEGER                   := ne*4 - VALUE'length;
    variable sv  : BIT_VECTOR(0 to ne*4 - 1) := (others => '0');
    variable s   : STRING(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => '0');
    loop                                -- skip white space
      read(l, c, ok);
      exit when (ok = false) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
      report "TEXTIO.HREAD Error: Failed skipping white space"
        severity error;
      return;
    end if;
    Char2QuadBits(c, sv(0 to 3), ok, true);
    if not ok then
      return;
    end if;
    read(L, s, ok);
    if not ok then
      report "TEXTIO.HREAD Error: Failed to read the STRING"
        severity error;
      return;
    end if;
    for i in 1 to ne-1 loop
      Char2QuadBits(s(i), sv(4*i to 4*i+3), ok, true);
      if not ok then
        return;
      end if;
    end loop;
    if or_reduce (sv (0 to pad-1)) = '1' then
      report "TEXTIO.HREAD Error: Vector truncated"
        severity error;
    else
      VALUE := sv (pad to sv'high);
    end if;
  end procedure HREAD;

  procedure HWRITE (L         : inout LINE;
                    VALUE     : in    BIT_VECTOR;
                    JUSTIFIED : in    SIDE  := right;
                    FIELD     : in    WIDTH := 0) is
  begin
    write (L         => L,
           VALUE     => to_hstring(VALUE),
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD);
  end procedure HWRITE;

  -- Procedure only visible internally.
  procedure Char2TriBits (C           :     CHARACTER;
                          RESULT      : out BIT_VECTOR(2 downto 0);
                          GOOD        : out BOOLEAN;
                          ISSUE_ERROR : in  BOOLEAN) is
  begin
    case c is
      when '0'    => result := o"0"; good := true;
      when '1'    => result := o"1"; good := true;
      when '2'    => result := o"2"; good := true;
      when '3'    => result := o"3"; good := true;
      when '4'    => result := o"4"; good := true;
      when '5'    => result := o"5"; good := true;
      when '6'    => result := o"6"; good := true;
      when '7'    => result := o"7"; good := true;
      when others =>
        assert not ISSUE_ERROR
          report
          "TEXTIO.OREAD Error: Read a '" & c &
          "', expected an Octal character (0-7)."
          severity error;
        GOOD := false;
    end case;
  end procedure Char2TriBits;

  -- Read and Write procedures for Octal values
  procedure OREAD (L     : inout LINE;
                   VALUE : out   BIT_VECTOR;
                   GOOD  : out   BOOLEAN) is
    variable ok  : BOOLEAN;
    variable c   : CHARACTER;
    constant ne  : INTEGER                   := (VALUE'length+2)/3;
    constant pad : INTEGER                   := ne*3 - VALUE'length;
    variable sv  : BIT_VECTOR(0 to ne*3 - 1) := (others => '0');
    variable s   : STRING(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => '0');
    loop                                -- skip white space
      read(l, c, ok);
      exit when (ok = false) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
      GOOD := false;
      return;
    end if;
    Char2TriBits(c, sv(0 to 2), ok, false);
    if not ok then
      GOOD := false;
      return;
    end if;
    read(L, s, ok);
    if not ok then
      GOOD := false;
      return;
    end if;
    for i in 1 to ne-1 loop
      Char2TriBits(s(i), sv(3*i to 3*i+2), ok, false);
      if not ok then
        GOOD := false;
        return;
      end if;
    end loop;
    if or_reduce (sv (0 to pad-1)) = '1' then
      GOOD := false;                    -- vector was truncated.
    else
      GOOD  := true;
      VALUE := sv (pad to sv'high);
    end if;
  end procedure OREAD;

  procedure OREAD (L     : inout LINE;
                   VALUE : out   BIT_VECTOR) is
    variable c   : CHARACTER;
    variable ok  : BOOLEAN;
    constant ne  : INTEGER                   := (VALUE'length+2)/3;
    constant pad : INTEGER                   := ne*3 - VALUE'length;
    variable sv  : BIT_VECTOR(0 to ne*3 - 1) := (others => '0');
    variable s   : STRING(1 to ne-1);
  begin
    VALUE (VALUE'range) := (others => '0');
    loop                                -- skip white space
      read(l, c, ok);
      exit when (ok = false) or ((c /= ' ') and (c /= NBSP) and (c /= HT));
    end loop;
    -- Bail out if there was a bad read
    if not ok then
      report "TEXTIO.OREAD Error: Failed skipping white space"
        severity error;
      return;
    end if;
    Char2TriBits(c, sv(0 to 2), ok, true);
    if not ok then
      return;
    end if;
    read(L, s, ok);
    if not ok then
      report "TEXTIO.OREAD Error: Failed to read the STRING"
        severity error;
      return;
    end if;
    for i in 1 to ne-1 loop
      Char2TriBits(s(i), sv(3*i to 3*i+2), ok, true);
      if not ok then
        return;
      end if;
    end loop;
    if or_reduce (sv (0 to pad-1)) = '1' then
      report "TEXTIO.OREAD Error: Vector truncated"
        severity error;
    else
      VALUE := sv (pad to sv'high);
    end if;
  end procedure OREAD;

  procedure OWRITE (L         : inout LINE;
                    VALUE     : in    BIT_VECTOR;
                    JUSTIFIED : in    SIDE  := right;
                    FIELD     : in    WIDTH := 0) is
  begin
    write (L         => L,
           VALUE     => to_ostring(VALUE),
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD);
  end procedure OWRITE;

  -- Read and Write procedures for Binary values
  -- alias BREAD is READ [LINE, BIT_VECTOR, BOOLEAN];
  -- alias BREAD is READ [LINE, BIT_VECTOR];
  -- alias BWRITE is WRITE [LINE, BIT_VECTOR, SIDE, WIDTH];
  procedure BREAD (L     : inout LINE;
                   VALUE : out   BIT_VECTOR;
                   GOOD  : out   BOOLEAN) is
  begin
    read (L     => L,
          VALUE => VALUE,
          GOOD  => GOOD);
  end procedure BREAD;
  procedure BREAD (L     : inout LINE;
                   VALUE : out   BIT_VECTOR) is
  begin
    read (L     => L,
          VALUE => VALUE);
  end procedure BREAD;
  -- alias BWRITE
  procedure BWRITE (L         : inout LINE;
                    VALUE     : in    BIT_VECTOR;
                    JUSTIFIED : in    SIDE  := right;
                    FIELD     : in    WIDTH := 0) is
  begin
    write (L         => L,
           VALUE     => VALUE,
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD);
  end procedure BWRITE;

  -- read and write for vector versions
  -- These versions produce "value1, value2, value3 ...."
  procedure read (L     : inout LINE;
                  VALUE : out   boolean_vector;
                  GOOD  : out   BOOLEAN) is
    variable dummy : CHARACTER;
    variable igood : BOOLEAN := true;
  begin
    for i in VALUE'range loop
      read (L     => L,
            VALUE => VALUE(i),
            GOOD  => igood);
      if (igood) and (i /= value'right) then
        read (L     => L,
              VALUE => dummy,           -- Toss the comma or seperator
              good  => igood);
      end if;
      if (not igood) then
        good := false;
        return;
      end if;
    end loop;
    good := true;
  end procedure read;
  procedure read (L     : inout LINE;
                  VALUE : out   boolean_vector) is
    variable dummy : CHARACTER;
    variable igood : BOOLEAN;
  begin
    for i in VALUE'range loop
      read (L     => L,
            VALUE => VALUE(i),
            good  => igood);
      if (igood) and (i /= value'right) then
        read (L     => L,
              VALUE => dummy,           -- Toss the comma or seperator
              good  => igood);
      end if;
      if (not igood) then
        report "STANDARD.STD_TEXTIO(BOOLEAN_VECTOR) "
          & "Read error ecounted during vector read" severity error;
        return;
      end if;
    end loop;
  end procedure read;
  procedure write (L         : inout LINE;
                   VALUE     : in    boolean_vector;
                   JUSTIFIED : in    SIDE  := right;
                   FIELD     : in    WIDTH := 0) is
  begin
    for i in VALUE'range loop
      write (L         => L,
             VALUE     => VALUE(i),
             JUSTIFIED => JUSTIFIED,
             FIELD     => FIELD);
      if (i /= value'right) then
        swrite (L, ", ");
      end if;
    end loop;
  end procedure write;
  procedure read (L     : inout LINE;
                  VALUE : out   integer_vector;
                  GOOD  : out   BOOLEAN) is
    variable dummy : CHARACTER;
    variable igood : BOOLEAN := true;
  begin
    for i in VALUE'range loop
      read (L     => L,
            VALUE => VALUE(i),
            GOOD  => igood);
      if (igood) and (i /= value'right) then
        read (L     => L,
              VALUE => dummy,           -- Toss the comma or seperator
              good  => igood);
      end if;
      if (not igood) then
        good := false;
        return;
      end if;
    end loop;
    good := true;
  end procedure read;
  procedure read (L     : inout LINE;
                  VALUE : out   integer_vector) is
    variable dummy : CHARACTER;
    variable igood : BOOLEAN;
  begin
    for i in VALUE'range loop
      read (L     => L,
            VALUE => VALUE(i),
            good  => igood);
      if (igood) and (i /= value'right) then
        read (L     => L,
              VALUE => dummy,           -- Toss the comma or seperator
              good  => igood);
      end if;
      if (not igood) then
        report "STANDARD.STD_TEXTIO(INTEGER_VECTOR) "
          & "Read error ecounted during vector read" severity error;
        return;
      end if;
    end loop;
  end procedure read;
  procedure write (L         : inout LINE;
                   VALUE     : in    integer_vector;
                   JUSTIFIED : in    SIDE  := right;
                   FIELD     : in    WIDTH := 0) is
  begin
    for i in VALUE'range loop
      write (L         => L,
             VALUE     => VALUE(i),
             JUSTIFIED => JUSTIFIED,
             FIELD     => FIELD);
      if (i /= value'right) then
        swrite (L, ", ");
      end if;
    end loop;
  end procedure write;
  procedure read (L     : inout LINE;
                  VALUE : out   real_vector;
                  GOOD  : out   BOOLEAN) is
    variable dummy : CHARACTER;
    variable igood : BOOLEAN := true;
  begin
    for i in VALUE'range loop
      read (L     => L,
            VALUE => VALUE(i),
            GOOD  => igood);
      if (igood) and (i /= value'right) then
        read (L     => L,
              VALUE => dummy,           -- Toss the comma or seperator
              good  => igood);
      end if;
      if (not igood) then
        good := false;
        return;
      end if;
    end loop;
    good := true;
  end procedure read;
  procedure read (L     : inout LINE;
                  VALUE : out   real_vector) is
    variable dummy : CHARACTER;
    variable igood : BOOLEAN;
  begin
    for i in VALUE'range loop
      read (L     => L,
            VALUE => VALUE(i),
            good  => igood);
      if (igood) and (i /= value'right) then
        read (L     => L,
              VALUE => dummy,           -- Toss the comma or seperator
              good  => igood);
      end if;
      if (not igood) then
        report "STANDARD.STD_TEXTIO(REAL_VECTOR) "
          & "Read error ecounted during vector read" severity error;
        return;
      end if;
    end loop;
  end procedure read;
  procedure write (L         : inout LINE;
                   VALUE     : in    real_vector;
                   JUSTIFIED : in    SIDE    := right;
                   FIELD     : in    WIDTH   := 0;
                   DIGITS    : in    NATURAL := 0) is
  begin
    for i in VALUE'range loop
      write (L         => L,
             VALUE     => VALUE(i),
             JUSTIFIED => JUSTIFIED,
             FIELD     => FIELD,
             DIGITS    => DIGITS);
      if (i /= value'right) then
        swrite (L, ", ");
      end if;
    end loop;
  end procedure write;
  procedure read (L     : inout LINE;
                  VALUE : out   time_vector;
                  GOOD  : out   BOOLEAN) is
    variable dummy : CHARACTER;
    variable igood : BOOLEAN := true;
  begin
    for i in VALUE'range loop
      read (L     => L,
            VALUE => VALUE(i),
            GOOD  => igood);
      if (igood) and (i /= value'right) then
        read (L     => L,
              VALUE => dummy,           -- Toss the comma or seperator
              good  => igood);
      end if;
      if (not igood) then
        good := false;
        return;
      end if;
    end loop;
    good := true;
  end procedure read;
  procedure read (L     : inout LINE;
                  VALUE : out   time_vector) is
    variable dummy : CHARACTER;
    variable igood : BOOLEAN;
  begin
    for i in VALUE'range loop
      read (L     => L,
            VALUE => VALUE(i),
            good  => igood);
      if (igood) and (i /= value'right) then
        read (L     => L,
              VALUE => dummy,           -- Toss the comma or seperator
              good  => igood);
      end if;
      if (not igood) then
        report "STANDARD.STD_TEXTIO(TIME_VECTOR) "
          & "Read error ecounted during vector read" severity error;
        return;
      end if;
    end loop;
  end procedure read;
  procedure write (L         : inout LINE;
                   VALUE     : in    time_vector;
                   JUSTIFIED : in    SIDE  := right;
                   FIELD     : in    WIDTH := 0;
                   UNIT      : in    TIME  := ns) is
  begin
    for i in VALUE'range loop
      write (L         => L,
             VALUE     => VALUE(i),
             JUSTIFIED => JUSTIFIED,
             FIELD     => FIELD,
             UNIT      => UNIT);
      if (i /= value'right) then
        swrite (L, ", ");
      end if;
    end loop;
  end procedure write;

-------------------------------------------------------------------    
-- TO_STRING
-------------------------------------------------------------------   
  function justify (
    value     : in STRING;
    justified : in SIDE  := right;
    field     : in width := 0)
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
  -- to_string funcitons for bit_vector
  -----------------------------------------------------------------------------
  function to_string (
    value     : in BIT_VECTOR;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING is
    alias ivalue    : BIT_VECTOR(1 to value'length) is value;
    variable result : STRING(1 to value'length);
  begin
    if value'length < 1 then
      return NUS;
    else
      for i in ivalue'range loop
        if iValue(i) = '0' then
          result(i) := '0';
        else
          result(i) := '1';
        end if;
      end loop;
      return justify(result, justified, field);
    end if;
  end function to_string;

  -- alias to_bstring is to_string [BIT_VECTOR, SIDE, WIDTH return STRING];
  -------------------------------------------------------------------    
  -- TO_HSTRING
  -------------------------------------------------------------------   
  function to_hstring (
    value     : in BIT_VECTOR;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING is
    constant ne     : INTEGER                                    := (value'length+3)/4;
    constant pad    : BIT_VECTOR(0 to (ne*4 - value'length) - 1) := (others => '0');
    variable ivalue : BIT_VECTOR(0 to ne*4 - 1);
    variable result : STRING(1 to ne);
    variable quad   : BIT_VECTOR(0 to 3);
  begin
    if value'length < 1 then
      return NUS;
    end if;
    ivalue := pad & value;
    for i in 0 to ne-1 loop
      quad := ivalue(4*i to 4*i+3);
      case quad is
        when x"0" => result(i+1) := '0';
        when x"1" => result(i+1) := '1';
        when x"2" => result(i+1) := '2';
        when x"3" => result(i+1) := '3';
        when x"4" => result(i+1) := '4';
        when x"5" => result(i+1) := '5';
        when x"6" => result(i+1) := '6';
        when x"7" => result(i+1) := '7';
        when x"8" => result(i+1) := '8';
        when x"9" => result(i+1) := '9';
        when x"A" => result(i+1) := 'A';
        when x"B" => result(i+1) := 'B';
        when x"C" => result(i+1) := 'C';
        when x"D" => result(i+1) := 'D';
        when x"E" => result(i+1) := 'E';
        when x"F" => result(i+1) := 'F';
      end case;
    end loop;
    return justify(result, justified, field);
  end function to_hstring;

  -------------------------------------------------------------------    
  -- TO_OSTRING
  -------------------------------------------------------------------   
  function to_ostring (
    value     : in BIT_VECTOR;
    justified : in SIDE  := right;
    field     : in width := 0
    ) return STRING is
    constant ne     : INTEGER                                    := (value'length+2)/3;
    constant pad    : BIT_VECTOR(0 to (ne*3 - value'length) - 1) := (others => '0');
    variable ivalue : BIT_VECTOR(0 to ne*3 - 1);
    variable result : STRING(1 to ne);
    variable tri    : BIT_VECTOR(0 to 2);
  begin
    if value'length < 1 then
      return NUS;
    end if;
    ivalue := pad & value;
    for i in 0 to ne-1 loop
      tri := ivalue(3*i to 3*i+2);
      case tri is
        when o"0" => result(i+1) := '0';
        when o"1" => result(i+1) := '1';
        when o"2" => result(i+1) := '2';
        when o"3" => result(i+1) := '3';
        when o"4" => result(i+1) := '4';
        when o"5" => result(i+1) := '5';
        when o"6" => result(i+1) := '6';
        when o"7" => result(i+1) := '7';
      end case;
    end loop;
    return justify(result, justified, field);
  end function to_ostring;

  -----------------------------------------------------------------------------
  -- To_string for integer, real, boolean, etc.
  -----------------------------------------------------------------------------
  function to_string (
    VALUE     : in INTEGER;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
  begin
    return justify (value     => INTEGER'image(VALUE),
                    justified => JUSTIFIED,
                    field     => FIELD);
  end function to_string;

  function to_string (
    VALUE     : in BIT;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
    variable result : STRING(1 to 1);
  begin
    if (value = '0') then
      result := "0";
    else
      result := "1";
    end if;
    return justify(value     => result,
                   justified => JUSTIFIED,
                   field     => FIELD);
  end function to_string;

  function to_string (
    VALUE     : in BOOLEAN;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
  begin
    return justify(value     => BOOLEAN'image(VALUE),
                   justified => JUSTIFIED,
                   field     => FIELD);
  end function to_string;

  function to_string (
    VALUE     : in SEVERITY_LEVEL;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
  begin
    return justify(value     => SEVERITY_LEVEL'image(VALUE),
                   justified => JUSTIFIED,
                   field     => FIELD);
  end function to_string;
  
  function to_string (
    VALUE     : in FILE_OPEN_KIND;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
  begin
    return justify(value     => FILE_OPEN_KIND'image(VALUE),
                   justified => JUSTIFIED,
                   field     => FIELD);
  end function to_string;
  
  function to_string (
    VALUE     : in FILE_OPEN_STATUS;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
  begin
    return justify(value     => FILE_OPEN_STATUS'image(VALUE),
                   justified => JUSTIFIED,
                   field     => FIELD);
  end function to_string;

  function to_string (
    VALUE     : in SIDE;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
  begin
    return justify(value     => SIDE'image(VALUE),
                   justified => JUSTIFIED,
                   field     => FIELD);
  end function to_string;

  function to_string (
    VALUE     : in REAL;
    JUSTIFIED : in SIDE    := right;
    FIELD     : in WIDTH   := 0;
    DIGITS    : in NATURAL := 0
    ) return STRING is
  begin
    if (DIGITS /= 0) then
      return justify (value => to_string (VALUE, "%1."
                                          & integer'image(DIGITS)
                                          & "f"),
                      JUSTIFIED => JUSTIFIED,
                      FIELD     => FIELD);
    else
      return justify (value     => REAL'image(VALUE),
                      JUSTIFIED => JUSTIFIED,
                      FIELD     => FIELD);
    end if;
  end function to_string;

  -- %%% Remove this funciton (will be implicit in vhdl 200x
  function maximum (l, r : integer)
    return integer is
  begin  -- function maximum
    if L > R then return L;
    else return R;
    end if;
  end function maximum;
  
  function to_string (
    VALUE  : in REAL;
--    JUSTIFIED : SIDE   := right;
--    FIELD     : WIDTH  := 0;
    format : in STRING                  -- %f6.2
    ) return STRING is
    constant czero      : CHARACTER := '0';   -- zero
    constant half       : REAL      := 0.4999999999;  -- almost 0.5
    -- Log10 funciton
    function log10 (arg : real) return integer is
      variable i : integer := 1;
    begin
      if ((arg = 0.0)) then
        return 0;
      elsif arg >= 1.0 then
        while arg >= 10.0**i loop
          i := i + 1;
        end loop;
        return (i-1);
      else
        while arg < 10.0**i loop
          i := i - 1;
        end loop;
        return i;
      end if;
    end function log10;
    -- purpose: writes a fractional real number into a line
    procedure writefrc (
      variable L         : inout LINE;  -- LINE
      variable cdes      : in    CHARACTER;
      variable precision : in    INTEGER;     -- number of decimal places
      variable value     : in    REAL) is     -- real value
      variable rvar  : REAL;            -- temp variable
      variable xint  : INTEGER;
      variable xreal : REAL;
    begin
      xreal := (10.0**(-precision));
      write (L, '.');
      rvar  := value;
      for i in 1 to precision loop
        rvar  := rvar * 10.0;
        xint  := integer(rvar-0.49999999999);         -- round
        write (L, xint);
        rvar  := rvar - real(xint);
        xreal := xreal * 10.0;
        if (cdes = 'g') and (rvar < xreal) then
          exit;
        end if;
      end loop;
    end procedure writefrc;
    -- purpose: replace the "." with a "@", and "e" with "j" to get around
    -- read ("6.") and read ("2e") issues.
    function subdot (
      constant format : STRING)
      return STRING is
      variable result : STRING (format'range);
    begin
      for i in format'range loop
        if (format(i) = '.') then
          result(i) := '@';             -- Because the parser reads 6.2 as REAL
        elsif (format(i) = 'e') then
          result(i) := 'j';             -- Because the parser read 2e as REAL
        elsif (format(i) = 'E') then
          result(i) := 'J';             -- Because the parser reads 2E as REAL
        else
          result(i) := format(i);
        end if;
      end loop;
      return result;
    end function subdot;
    -- purpose: find a . in a STRING
    function isdot (
      constant format : STRING)
      return BOOLEAN is
    begin
      for i in format'range loop
        if (format(i) = '@') then
          return true;
        end if;
      end loop;
      return false;
    end function isdot;
    variable exp            : INTEGER;  -- integer version of baseexp
    variable bvalue         : REAL;     -- base value
    variable roundvar, tvar : REAL;     -- Rounding values
    variable frcptr         : INTEGER;  -- integer version of number
    variable fwidth, dwidth : INTEGER;  -- field width and decimal width
    variable dash, dot      : BOOLEAN   := false;
    variable cdes, ddes     : CHARACTER := ' ';
    variable L              : LINE;     -- line type
  begin
    -- Perform the same function that "printf" does
    -- examples "%6.2f" "%-7e" "%g"
    if not (format(format'left) = '%') then
      report "to_string: Illegal format string """ & format & '"'
        severity error;
      return "";
    end if;
    L := new string'(subdot(format));
    read (L, ddes);                     -- toss the '%'
    case L.all(1) is
      when '-'                                     => dash := true;
      when '@'                                     => dash := true;  -- in FP, a "-" and a "." are the same
      when 'f'                                     => cdes := 'f';
      when 'F'                                     => cdes := 'F';
      when 'g'                                     => cdes := 'g';
      when 'G'                                     => cdes := 'G';
      when 'j'                                     => cdes := 'e';  -- parser reads 5e as real, thus we sub j
      when 'J'                                     => cdes := 'E';
      when '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' => null;
      when others                                  =>
        report "to_string: Illegal format string """ & format & '"'
          severity error;
        return "";
    end case;
    if (dash or (cdes /= ' ')) then
      read (L, ddes);                   -- toss the next character
    end if;
    if (cdes = ' ') then
      if (isdot(L.all)) then            -- if you see a . two numbers
        read (L, fwidth);               -- read field width
        read (L, ddes);                 -- toss the next character .
        read (L, dwidth);               -- read decimal width       
      else
        read (L, fwidth);               -- read field width
        dwidth := 6;                    -- the default decimal width is 6
      end if;
      read (L, cdes);
      if (cdes = 'j') then
        cdes := 'e';                    -- because 2e reads as "REAL".
      elsif (cdes = 'J') then
        cdes := 'E';
      end if;
    else
      if (cdes = 'E' or cdes = 'e') then
        fwidth := 10;                   -- default for e and E is %10.6e
      else
        fwidth := 0;                    -- default for f and g is %0.6f
      end if;
      dwidth := 6;
    end if;
    deallocate (L);                     -- reclame the pointer L.
--      assert (not debug) report "Format: " & format & " "
--        & INTEGER'image(fwidth) & "." & INTEGER'image(dwidth) & cdes
--        severity note;
    if (not (cdes = 'f' or cdes = 'F' or cdes = 'g' or cdes = 'G'
             or cdes = 'e' or cdes = 'E')) then
      report "to_string: Illegal format """ & format & '"' severity error; 
      return "";
    end if;
    if (VALUE < 0.0) then
      bvalue := -value;
      write (L, '-');
    else
      bvalue := value;
    end if;
    case cdes is
      when 'e' | 'E' =>                 -- 7.000E+01
        exp      := log10(bvalue);
        roundvar := half*(10.0**(exp-dwidth));
        bvalue   := bvalue + roundvar;  -- round
        exp      := log10(bvalue);      -- because we CAN overflow
        bvalue   := bvalue * (10.0**(-exp));  -- result is D.XXXXXX
        frcptr   := integer(bvalue-half);     -- Write a single digit.
        write (L, frcptr);
        bvalue   := bvalue - real(frcptr);
        writefrc (                      -- Write out the fraction
          L         => L,
          cdes      => cdes,
          precision => dwidth,
          value     => bvalue);
        write (L, cdes);                -- e or E
        if (exp < 0) then
          write (L, '-');
        else
          write (L, '+');
        end if;
        exp := abs(exp);
        if (exp < 10) then              -- we need another "0".
          write (L, czero);
        end if;
        write (L, exp);
      when 'f' | 'F' =>                 -- 70.0
        exp      := log10(bvalue);
        roundvar := half*(10.0**(-dwidth));
        bvalue   := bvalue + roundvar;  -- round
        exp      := log10(bvalue);      -- because we CAN overflow
        if (exp < 0) then               -- 0.X case
          write (L, czero);
        else                            -- loop because real'high > integer'high
          while (exp >= 0) loop
            frcptr := integer(bvalue * (10.0**(-exp)) - half);
            write (L, frcptr);
            bvalue := bvalue - (real(frcptr) * (10.0**exp));
            exp    := exp-1;
          end loop;
        end if;
        writefrc (
          L         => L,
          cdes      => cdes,
          precision => dwidth,
          value     => bvalue);
      when 'g' | 'G' =>                 -- 70
        exp      := log10(bvalue);
        roundvar := half*(10.0**(exp-dwidth));        -- small number
        bvalue   := bvalue + roundvar;  -- round
        exp      := log10(bvalue);      -- because we CAN overflow
        frcptr   := integer(bvalue-half);
        tvar     := bvalue-roundvar - real(frcptr);   -- even smaller number
        if (exp < dwidth)
          and (tvar < roundvar and tvar > -roundvar) then
--            and ((bvalue-roundvar) = real(frcptr)) then
          write (L, frcptr);            -- Just a short integer, write it.
        elsif (exp >= dwidth) or (exp < -4) then
          -- in "e" format (modified)
          bvalue := bvalue * (10.0**(-exp));  -- result is D.XXXXXX
          frcptr := integer(bvalue-half);
          write (L, frcptr);
          bvalue := bvalue - real(frcptr);
          if (bvalue > (10.0**(1-dwidth))) then
            dwidth := dwidth - 1;
            writefrc (
              L         => L,
              cdes      => cdes,
              precision => dwidth,
              value     => bvalue);              
          end if;
          if (cdes = 'G') then
            write (L, 'E');
          else
            write (L, 'e');
          end if;
          if (exp < 0) then
            write (L, '-');
          else
            write (L, '+');
          end if;
          exp := abs(exp);
          if (exp < 10) then
            write (L, czero);
          end if;
          write (L, exp);
        else
          -- in "f" format (modified)
          if (exp < 0) then
            write (L, czero);
            dwidth   := maximum (dwidth, 4);  -- if exp < -4 or > precision.
            bvalue   := bvalue - roundvar;    -- recalculate rounding
            roundvar := half*(10.0**(-dwidth));
            bvalue   := bvalue + roundvar;
          else
            write (L, frcptr);          -- integer part (always small)
            bvalue := bvalue - (real(frcptr));
            dwidth := dwidth - exp - 1;
          end if;
          if (bvalue > roundvar) then
            writefrc (
              L         => L,
              cdes      => cdes,
              precision => dwidth,
              value     => bvalue);
          end if;
        end if;
      when others => return "";
    end case;
    -- You don't truncate real numbers.
--      if (dot) then                 -- truncate
--        if (L.all'length > fwidth) then
--          return justify (value => L.all (1 to fwidth),
--                          justified => RIGHT,
--                          field => fwidth);         
--        else
--          return justify (value => L.all,
--                          justified => RIGHT,
--                          field => fwidth); 
--        end if;
    if (dash) then                      -- fill to fwidth
      return justify (value     => L.all,
                      justified => LEFT,
                      field     => fwidth);
    else
      return justify (value     => L.all,
                      justified => RIGHT,
                      field     => fwidth);
    end if;
  end function to_string;

  -- if the time is 1 ns, and the unit is 1 ps,
  -- then to_string(now) = 1000.0 ps;
  function to_string (
    VALUE     : in TIME;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0;
    UNIT      : in TIME  := ns
    ) return STRING is
    variable L : LINE;                  -- pointer
  begin
    deallocate (L);
    write (L         => L,
           VALUE     => VALUE,
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD,
           UNIT      => UNIT);
    return L.all;
  end function to_string;

  -- vector versions
  function to_string (
    VALUE     : in BOOLEAN_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
    variable L : LINE;
  begin
    deallocate (L);
    write (L         => L,
           VALUE     => VALUE,
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD);
    return L.all;
  end function to_string;
  function to_string (
    VALUE     : in INTEGER_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0
    ) return STRING is
    variable L : LINE;
  begin
    deallocate (L);
    write (L         => L,
           VALUE     => VALUE,
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD);
    return L.all;
  end function to_string;
  function to_string (
    VALUE     : in REAL_VECTOR;
    JUSTIFIED : in SIDE    := right;
    FIELD     : in WIDTH   := 0;
    DIGITS    : in NATURAL := 0
    ) return STRING is
    variable L : LINE;
  begin
    deallocate (L);
    write (L         => L,
           VALUE     => VALUE,
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD,
           DIGITS    => DIGITS);
    return L.all;
  end function to_string;
  function to_string (
    VALUE  : in REAL_VECTOR;
    format : in STRING
    ) return STRING is
    variable L : LINE;
  begin
    deallocate (L);
    for i in VALUE'range loop
      write (L      => L,
             VALUE  => to_string (VALUE => VALUE(i),
             format => format));
      if (i /= VALUE'right) then
        SWRITE (L     => L,
                VALUE => ", ");
      end if;
    end loop;
    return L.all;
  end function to_string;
  function to_string (
    VALUE     : in TIME_VECTOR;
    JUSTIFIED : in SIDE  := right;
    FIELD     : in WIDTH := 0;
    UNIT      : in TIME  := ns
    ) return STRING is
    variable L : LINE;
  begin
    deallocate (L);
    write (L         => L,
           VALUE     => VALUE,
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD,
           UNIT      => UNIT);
    return L.all;
  end function to_string;

  -- pragma synthesis_on
  -- Will be implicit
  function minimum (L, R : SIDE) return SIDE is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;
  function maximum (L, R : SIDE) return SIDE is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

end package body standard_textio_additions;
