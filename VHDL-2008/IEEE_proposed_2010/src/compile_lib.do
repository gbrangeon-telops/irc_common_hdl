@onerror
{
goto end
}          

setlibrarymode -rw IEEE_proposed_2010 

acom -work IEEE_proposed_2010 "D:\Telops\Common_HDL\VHDL-2008/standard_additions_c.vhd"
acom -work IEEE_proposed_2010 "D:\Telops\Common_HDL\VHDL-2008/standard_textio_additions_c.vhd"
acom -work IEEE_proposed_2010 "D:\Telops\Common_HDL\VHDL-2008/std_logic_1164_additions.vhd"
acom -work IEEE_proposed_2010 "D:\Telops\Common_HDL\VHDL-2008/numeric_std_additions.vhd"
acom -work IEEE_proposed_2010 "D:\Telops\Common_HDL\VHDL-2008/numeric_std_unsigned_c.vhd"
acom -work IEEE_proposed_2010 "D:\Telops\Common_HDL\VHDL-2008/fixed_float_types_c.vhd"
acom -work IEEE_proposed_2010 "D:\Telops\Common_HDL\VHDL-2008/fixed_pkg_c.vhd"
acom -work IEEE_proposed_2010 "D:\Telops\Common_HDL\VHDL-2008/float_pkg_c.vhd"

label end
