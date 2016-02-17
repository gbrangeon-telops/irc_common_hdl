#!/usr/local/bin/perl

if ( (@ARGV != 2)  or ($ARGV[0] eq '-h') or ($ARGV[0] eq 'h') or ($ARGV[0] eq 'help')) 
{
  die <<EOF;

 xmddump2bin
 This tool converts a XMD memory dump to a binary file.
 This is useful to compare to the input file that we wanted
 to write to the flash.
  
 Usage:
 xmddump2bin flash_dump.raw bin_file.bin

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

my $ignore_bytes = 6;
my $i = 0;

foreach my $line (<HEXFILE>) {
   chomp($line);              # remove the newline from $line.
   
   #Extract each byte from the file
   $i = 0;
   while ($line =~ /(..)/g) 
   { 
      $i++;
      # Ignore first $ignore_bytes
      if ($i > $ignore_bytes)
      {
         $byte = $1;
         #print "byte = 0x$byte\n";
         print BINFILE chr(hex($byte));      
      }      
   }         
}
close(HEXFILE);
close(BINFILE);
