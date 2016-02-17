#!/usr/local/bin/perl

if ( (@ARGV != 2)  or ($ARGV[0] eq '-h') or ($ARGV[0] eq 'h') or ($ARGV[0] eq 'help')) 
{
  die <<EOF;

 asciihex2bin
 This tool converts a file which contains hexadecimal ASCII data (such as a
 memory dump for example, or a VHDL generated hex file) to a binary file.
 The file should NOT containt 0x prefix for the data. 
  
 Usage:
 asciihex2bin asciihex_file.raw bin_file.bin

 Patrick Dubois
 prdubois_gmail.com (Drop me an e-mail if you find this tool useful or have comments!)
 Quebec, Canada
 Version 1.0, May 2007
EOF
}

my $source_name = $ARGV[0];
my $dest_name = $ARGV[1];


open(HEXFILE, "<$source_name") or die("Could not open source file.");

open(BINFILE, ">$dest_name") or die("Could not open destination file.");
binmode BINFILE;

foreach my $line (<HEXFILE>) {
   chomp($line);              # remove the newline from $line.
   
   #Extract each byte from the file
   while ($line =~ /(..)/g) 
   { 
      $byte = $1;
      #print "byte = 0x$byte\n";
      print BINFILE chr(hex($byte));      
   }   
      
}
close(HEXFILE);
close(BINFILE);
