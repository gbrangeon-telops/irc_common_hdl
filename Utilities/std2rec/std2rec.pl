#                     if ($record_ports{$record_name}{ARRAY}{$record_type} =~ /signed/i)
#                     {
#                        print TOTO! \n
#                     }#                     if ($record_ports{$record_name}{ARRAY}{$record_type} =~ /signed/i)
#                     {
#                        print TOTO! \n
#                     }#                     if ($record_ports{$record_name}{ARRAY}{$record_type} =~ /signed/i)
#                     {
#                        print TOTO! \n
#                     }#!/usr/bin/perl
# Copyright (c) 2007 Patrick Dubois, COPL - Universite Laval
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

use Tie::File;
use File::Copy;
#use strict;
use POSIX qw(ceil floor);
use Data::Dumper;
$Data::Dumper::Indent--;
$Data::Dumper::Terse++;

if ( (@ARGV != 2)  or ($ARGV[0] eq '-h') or ($ARGV[0] eq 'h') or ($ARGV[0] eq 'help'))
{
  die <<EOF;

 std2rec : "std_logic to records".

 This tool is a post-processor to Xilinx netgen. Netgen unfortunately breaks
 VHDL records and expands them into simple std_logic_vectors. std2rec restores
 the netgen entity ports that it matches the original source file.

 The tool assumes that the first entity present in the original file is the one
 to use. It also assumes that all ports which are not std_logic_vectors or
 std_logic are records.

 Usage:
 std2rec original_file.vhd netgen_file.vhd

 Patrick Dubois
 prdubois_gmail.com (Drop me an e-mail if you find this tool useful or have comments!)
 Quebec, Canada
 Version 1.0, January 2007
EOF
}

my $source_name = $ARGV[0];
my $sim_name = $ARGV[1];

#-----------------------------------------------------------------------------------
# Open original vhdl source file, and puts its whole content into a single variable
#-----------------------------------------------------------------------------------
#open SRCFILE, '<', $source_name || die "Can't open: $!\n";
#
## Undefine the end of record character
#undef $/;
#$complete_src_content = <SRCFILE>;
#
#close SRCFILE;
#$/ = "\n";     #Restore for normal behaviour later in script
#-----------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------
# Open original vhdl source file
#-----------------------------------------------------------------------------------
open(SRCFILE,  "<$source_name") or die "Can't open $source_name: $!";
close SRCFILE;

my @src_file_array;
tie @src_file_array, 'Tie::File', $source_name || die "Can't open: $!\n";
#-----------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Find all record ports (and library/use declarations)
#------------------------------------------------------------------------------
my %record_ports; # This is a hash of arrays
my $line = 0;
my @lib_array;
my @generics_array;
my $entity_name;

FIND_SRC_ENTITY : for ($line=0; $line <= $#src_file_array; $line++)
{
   # Find and store libraries
   if ( $src_file_array[$line] =~ /^\s*library/i or $src_file_array[$line] =~ /^\s*use/i )
   {
      # Store the whole line in the library array
      push(@lib_array, $src_file_array[$line]);
   }
   # Find entity name
   elsif ( $src_file_array[$line] =~ /entity\s+(\w+)\s+is/i ) # The i is for case-insensitive
   {
      $entity_name = $1;
      print "Found entity $entity_name at line $line...\n";
   }
   # Find and store generics
   elsif ( $src_file_array[$line] =~ /\s+generic\W+/i ) # The i is for case-insensitive
   {
      # Start looking for generics until we find ); or )); but not ...downto 0);
      print "Found generic statement at line $line, storing generics...\n";
      FIND_GENERICS : for ($line; $line <= $#src_file_array; $line++)
      {
         if ($src_file_array[$line] =~ /[:]/)
         {
            my $generic_line = $src_file_array[$line];
            # Remove ); from line if necessary
            if ($generic_line !~ /\d+\s*[)]\s*[;]/)
            {
               #print "Need to remove ); from $generic_line\n";
               $generic_line =~ s/[)]\s*[;]//;
            }
            else
            {
               $generic_line =~ s/[)]\s*[)]\s*[;]/)/;
            }
            push(@generics_array, $generic_line);
         }
         if ($src_file_array[$line] =~ /\D+\s*[)]\s*[;]/ or # [non-digits]);
             $src_file_array[$line] =~ /[)]\s*[)]\s*[;]/)   # ));
         {
            last FIND_GENERICS;
         }

      }
   }
   elsif ( $src_file_array[$line] =~ /\s+port\W+/i ) # The i is for case-insensitive
   {
      #print "Found port statement at line $line...\n";
      # Start looking for port names until we find ); or )); but not ...downto 0);
      while ($src_file_array[$line] !~ /\D+\s*[)]\s*[;]/ and   # while not [non-digits]);
             $src_file_array[$line] !~ /[)]\s*[)]\s*[;]/)      # not ));
      {
         # We found a port that is not std_logic
         if (($src_file_array[$line] =~ /(in)/i or $src_file_array[$line] =~ /(out)/i) and ($src_file_array[$line] !~ /std_logic/i))
         {
            # Look for exactly:
            # 0 or more whitespace
            # 1 or more alphanumeric characters (the record name)
            # 0 or more whitespace
            # The character :
            # 0 or more whitespace
            # 1 or more alphanumeric characters (direction)
            # 1 or more whitespace
            # 1 or more alphanumeric characters (record_type)
            if ($src_file_array[$line] =~ /\s*(\w+)\s*:\s*(\w+)\s+(\w+)/)
            {
               my $record_name = $1;
               my $direction = $2;
               my $record_type = $3;

               $record_ports{$record_name}{"DIR"} = $direction;
               $record_ports{$record_name}{"RECORD_TYPE"} = $record_type;
            }
         }
         $line++;
      }
      last FIND_SRC_ENTITY;
   }
}
untie @src_file_array;
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Let's print all generics found
#------------------------------------------------------------------------------
#print "Generics found:\n";
#print Dumper \@generics_array;
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Allright, let's print all record_ports found
#------------------------------------------------------------------------------
#print Dumper \%record_ports;
#foreach $record_name (keys %record_ports)
#{
#   $direction = $record_ports{$record_name}{"DIR"};
#   $record_type = $record_ports{$record_name}{"RECORD_TYPE"};
#   print "$record_name : $direction $record_type\n";
#}
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Convert UNIX eol to DOS eol
#------------------------------------------------------------------------------
# First let's make a backup
my @args;
if (-e "$sim_name.bak")
{
   print "Deleting old backup file $sim_name.bak\n";
   @args = ("del", "$sim_name.bak");
   system(@args);
}

copy( $sim_name, "$sim_name.bak") || die "Unable to copy $sim_name\n$!\n";

# Call the script unix2dos
print "Converting UNIX file type to DOS type... \n";
#@args = ("unix2dos", "$sim_name");
@args = ("linebreaktool", "-c", "$sim_name", "dos");
system(@args);
print "unix2dos DONE.\n";
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Open sim (netgen) vhdl source file
#------------------------------------------------------------------------------
my @sim_file_array;
tie @sim_file_array, 'Tie::File', $sim_name, memory => 50_000_000 || die "Can't open: $!\n";
(tied @sim_file_array)->defer; # Do all data manipulation in memory instead of directly on the file (MIGHT improve performance).
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Let's parse the simulation file
#------------------------------------------------------------------------------
$line = 0;
my $deleted_last_port = 0;
print "Looking for entity $entity_name in file $sim_name...\n";
my $percent = 0;
my $increment = ceil($#sim_file_array/100);
print "\r $percent \%";
@lib_array = reverse @lib_array;

FIND_SIM_ENTITY : for (; $line < $#sim_file_array; $line++)
{

   if (($line % $increment) == 0)
   {
      print "\r $percent \%";
      $percent++;
   }

   #----------------------------------------
   # First, find any entity declaration
   #----------------------------------------

   # Add all libraries
   if ( $sim_file_array[$line] =~ /entity\s+/i)
   {
      #print "Adding libraries...\n";
      my $i = 0;
      foreach my $lib_element ( @lib_array )
      {
         splice @sim_file_array, $line-1, 0, $lib_element;
         $i++;
      }
      splice @sim_file_array, $line-1, 0, "-- Library elements added by std2rec from file $source_name";
      $i++;
   #----------------------------------------

      $line = $line + $i;

      # If this is THE entity we're looking for
      if ( $sim_file_array[$line] =~ /entity\s+$entity_name\s+is/i ) # The i is for case-insensitive
      {
         $line++;
         print "\n";

         #----------------------------------
         # Now, let's add generics
         #----------------------------------
         if (@generics_array > 0)
         {
            splice @sim_file_array, $line, 0, "   -- Generics added by std2rec from file $source_name";
            $line++;
            splice @sim_file_array, $line, 0, "   generic(";
            $line++;
            print "Adding generics...\n";
            foreach my $generic ( @generics_array )
            {
               splice @sim_file_array, $line, 0, $generic;
               $line++;
            }
            splice @sim_file_array, $line, 0, "   );";
            $line++;
         }
         #----------------------------------


         # Start looking for port names until we find );
         while ($sim_file_array[$line] !~ /^\s*[)]\s*[;]/ and $line<$#sim_file_array)
         {
            #print "Parsing line $line...\n";
            if ($sim_file_array[$line] =~ /\s*(\w+)\s*:\s*\w+\s+(.+):=/ or
                $sim_file_array[$line] =~ /\s*(\w+)\s*:\s*\w+\s+(.+)[;]/ or
                $sim_file_array[$line] =~ /\s*(\w+)\s*:\s*\w+\s+(.+)/)
            {
               my $sim_port = $1;
               my $port_type = $2;
               # Loop through all record_ports to find a match (I know, it's slow...)
               foreach my $record_name (keys %record_ports)
               {
                  if ($sim_port =~ /$record_name/)
                  {
                     $record_type = $record_ports{$record_name}{"RECORD_TYPE"};
                     #print "Record type $record_type \n";
                     if ($record_type =~ /signed/i or $record_type =~ /unsigned/i)
                     {
                        #print "TOTO! \n";
                        # Replace std_logic_vector by signed or unsigned
                        $sim_file_array[$line] =~ s/std_logic_vector/$record_type/i;
                        # Delete the hash element
                        delete $record_ports{$record_name};
                     }
                     else
                     {
                        #print "sim_port = $sim_port, record_name = $record_name\n";
                        $sim_port =~ s/$record_name[_]//; # Remove the record name from the sim_port
                        # We have a match, now we need to store the sim_port name and its type
                        $record_ports{$record_name}{ARRAY}{$sim_port} = $port_type;

                        # Check to see if we're deleting the last port
                        if ($sim_file_array[$line] !~ /[;]/) # No semi-column?
                        {
                           $deleted_last_port = 1;
                        }

                        # Now comment the current line
                        #delete($sim_file_array[$line]);
                        $sim_file_array[$line] =~ s/^ /--/;
                     }
                  }
               }
            }
            $line++;
         }
         $line--;

   #      # We now need to add ; to the current line(last port), if not already there
   #      print "Last port : $sim_file_array[$line-1]\n";
   #      $sim_file_array[$line-1] =~ s/;{0}\s*$/;/;

         # Now let's add the record ports
         my $i = 0;
         foreach my $record_name (keys %record_ports)
         {
            $i++;
            my $direction = $record_ports{$record_name}{"DIR"};
            my $record_type = $record_ports{$record_name}{"RECORD_TYPE"};
            my $new_line = "    $record_name : $direction $record_type;";
            splice @sim_file_array, $line, 0, $new_line;
         }
         if ($deleted_last_port)
         {
            # Remove the ;
            $sim_file_array[$line+$i-1] =~ s/[;]//;
         }
         last FIND_SIM_ENTITY;
      }
   }
}
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Now let's add the aliases in the architecture.
#------------------------------------------------------------------------------
# Look for architecture body
while ($sim_file_array[$line] !~ /architecture/ )
{
   $line++;
}
$line++;

# Add aliases
foreach my $record_name (keys %record_ports)
{
   my $record_type = $record_ports{$record_name}{"RECORD_TYPE"};
   foreach my $signal_name (keys %{$record_ports{$record_name}{ARRAY}})
   {
      my $signal_type = $record_ports{$record_name}{ARRAY}{$signal_name};
      my $new_line = "   alias $record_name\_$signal_name : $signal_type is $record_name.$signal_name;";
      splice @sim_file_array, $line, 0, $new_line;
   }
}
splice @sim_file_array, $line, 0, "   -- Aliases added by std2rec.";

#------------------------------------------------------------------------------
# Allright, let's print all record_ports found
#------------------------------------------------------------------------------
print "\nRecords found: \n";
foreach my $record_name (keys %record_ports)
{
   print "$record_name\n";
   foreach my $signal_name (keys %{$record_ports{$record_name}{ARRAY}})
   {
      my $type = $record_ports{$record_name}{ARRAY}{$signal_name};
      print "   $signal_name : $type\n";
   }
}

(tied @sim_file_array)->flush; # Write all changes to the file.
untie @sim_file_array;

print "\nAll done.\n\n";
