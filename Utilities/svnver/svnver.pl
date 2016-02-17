#!/usr/local/bin/perl

use strict;
use warnings;
use File::Basename;
use File::Compare;

if ( (@ARGV != 1)  or ($ARGV[0] eq '-h') or ($ARGV[0] eq 'h') or ($ARGV[0] eq 'help')) 
{
  die <<EOF;

 svnver
 This tool simply returns the SVN file version. It returns 0 if the file is not up to date with the server (red exclamation mark in Tortoise).
  
 Usage:
 svnver thefile.ext

 Patrick Dubois
 Version 1.1, January 2009
EOF
}

my $fullpath = $ARGV[0];

my $filename = basename($fullpath);
my $filedir = dirname($fullpath);

#print "filename = $filename\n";
#print "filedir = $filedir\n";

my $wcprops_name;
my $base_name;
if ($filedir)
{
   $wcprops_name = "$filedir\\.svn\\all-wcprops";
   $base_name = "$filedir\\.svn\\text-base\\$filename.svn-base";   
}
else
{
   $wcprops_name = ".\\.svn\\all-wcprops";
   $base_name = ".\\.svn\\text-base\\$filename.svn-base";
}
#print "wcprops_name = $wcprops_name";
#print "full path = $fullpath\n";
#print "base name = $base_name\n";

open(WCPROPS, "<$wcprops_name") or die("Could not open all-wcprops subversion file.");
my @raw_content=<WCPROPS>;
close(WCPROPS);

my $line;
my $version;
foreach $line (@raw_content)
{
   chomp($line);
   if ( $line =~ /!svn\/ver\/(\d+)\/.*\/$filename/i ) # The i is for case-insensitive
   {
      $version = $1;        
      last;
   }      
} 

if (compare($fullpath,$base_name) == 0) # compare returns 0 if files are equal
{
   print "$version";
}
else
{
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
   my $temp = sprintf("5%02d%02d",($mon+1),$mday);
   print "$temp";
}


