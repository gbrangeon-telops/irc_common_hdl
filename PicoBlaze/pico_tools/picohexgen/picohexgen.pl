#!/usr/bin/perl
use strict;

if ( (@ARGV != 2)  or ($ARGV[0] eq '-h') or ($ARGV[0] eq 'h') or ($ARGV[0] eq 'help')) 
{
  die <<EOF;

bla bla bla bla

EOF
}

my $source_name = $ARGV[0];
my $dest_name = $ARGV[1];

#-----------------------------------------------------------------------------------
# Open originalsource file
#-----------------------------------------------------------------------------------

$/ = " ";     #Redefine eol
open SRCFILE, '<', $source_name || die "Can't open: $!\n";

open DSTFILE, '>', $dest_name || die "Can't open: $!\n";

my $line;
 

while ($line = <SRCFILE>)
{
   if ($line =~ /\d{3}(\w{5})/)
   {
      my $digits = $1;
      print DSTFILE "$digits\n";
      
   }  
}

close SRCFILE;
close DSTFILE;
