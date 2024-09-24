@onerror
{
goto end
}          

setlibrarymode -rw IEEE_proposed 

acom -work IEEE_proposed "$COMMON_HDL/VHDL-200x/standard_additions_c.vhd"
acom -work IEEE_proposed "$COMMON_HDL/VHDL-200x/standard_textio_additions_c.vhd"
acom -work IEEE_proposed "$COMMON_HDL/VHDL-200x/std_logic_1164_additions.vhd"
acom -work IEEE_proposed "$COMMON_HDL/VHDL-200x/numeric_std_additions.vhd"
acom -work IEEE_proposed "$COMMON_HDL/VHDL-200x/numeric_std_unsigned_c.vhd"
acom -work IEEE_proposed "$COMMON_HDL/VHDL-200x/fixed_pkg_c.vhd"
acom -work IEEE_proposed "$COMMON_HDL/VHDL-200x/float_pkg_c.vhd"

label end
