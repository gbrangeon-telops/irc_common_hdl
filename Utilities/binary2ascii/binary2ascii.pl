#!/usr/local/bin/perl

if ( (@ARGV != 1)  or ($ARGV[0] eq '-h') or ($ARGV[0] eq 'h') or ($ARGV[0] eq 'help')) 
{
  die <<EOF;

 binary2ascii
 This tool reads a file which contains binary data and sends it to the console.
 It can be useful to convert data sniffed from a RS-232 communication by RealTerm
 for example.
  
 Usage:
 binary2ascii binary_file.bin
 or
 binary2ascii binary_file.bin > ascii_file.txt

 Patrick Dubois
 prdubois_gmail.com (Drop me an e-mail if you find this tool useful or have comments!)
 Quebec, Canada
 Version 1.0, February 2007
EOF
}

my $source_name = $ARGV[0];


$buffer = "";


open(FILE, "<$source_name");

binmode(FILE); 

read(FILE, $buffer, 2000000, 0);

close(FILE);


foreach (split(//, $buffer)) {

    printf("%02x ", ord($_));

    print "\n" if $_ eq "\n";

}