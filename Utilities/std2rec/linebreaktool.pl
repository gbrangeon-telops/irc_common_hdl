#!/usr/bin/perl -w

# $Id: linebreaktool.pl,v 1.29.2.3 2003/02/19 13:29:53 gonzo Exp $
#
# LineBreakTool $Name: v0-2pre1 $ converts the linebreaks of text files
#
# Copyright (C) 2001 2002 2003 Sven Kleese, Hamburg (Germany)
#
# Credits:
# Jeffrey E.F. Friedl inspired me to implement the regex myself.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


use strict;
# binmode FH seems to be more compatible with DOS than O_BINARY:
use Fcntl qw{O_RDONLY O_WRONLY O_CREAT SEEK_SET};
# use File::Recurse;


my $debug = 0;


( my $VERSION = q$Name: v0-2pre1 $ ) =~ s/(?:^Name:\s*[a-z_-]*|\s*$)//g;
$VERSION =~ tr/-_/./d;
( $VERSION = lc( q$Revision: 1.29.2.3 $) ) =~ s/(?::\s*|\s*$)//g if $VERSION eq '';

( my $date	= q$Date: 2003/02/19 13:29:53 $ ) =~ s/(?:^Date:\s*|\s*$)//g;

my $versionstring = "LineBreakTool $VERSION"; # \n$date";


# Configuration of File::Recurse:

my $MAX_DEPTH		= 100;
my $FOLLOW_SYMLINKS	= 0;


# Configuration of LineBreakTool:

#	     | Unix | DOS  | Mac  |
#	---------------------------
#	\n   |  LF  |  LF  |  CR  |
#	\r   |  CR  |  CR  |  LF  |
#	\n * |  LF  | CRLF |  CR  |
#	\r * |  CR  |  CR  |  LF  |
#	---------------------------
#	* text-mode STDIO


# possible to-types:

my %linebreaks	= (	'dos'		=> [ 1, chr(0x0D).chr(0x0A)],		# CRLF
			'mac'		=> [ 2, chr(0x0D)],			# CR
			'unix'		=> [ 4, chr(0x0A)],			# LF
			'broken'	=> [ 8, chr(0x0D).chr(0x0D).chr(0x0A)]	# CRCRLF
		);


# detectable types:

my %filetypes	= (	1		=> [ 'dos'],
			2		=> [ 'mac'],
			4		=> [ 'unix'],
			8		=> [ 'broken'],
			0		=> [ 'none'],
			'binary'	=> [ 'binary'],
			undef		=> [ 'strange']
		);


parse_arguments();


sub parse_arguments
###################
{
	# getopt:declare?

	usage() if $#ARGV < 0;

	my $action_test		= 0;
	my $action_convert	= 0;
	my $verbose		= 0;

	my $filename	= undef;
	my $dirname	= undef;
	my $from_type	= undef;
	my $to_type	= undef;

	foreach my $argument ( @ARGV)
	{
		usage() if $argument =~ /^\s*[-\\\/]+(?:h(?:elp|ilfe)?|\?)\s*$/i;
		version() if $argument =~ /^\s*[-\\\/]*version\s*$/i;

		if( $argument =~ /^\s*[-\\\/]+t(?:est)?\s*$/i)
		{
			$action_test = 1;
		}
		elsif( $argument =~ /^\s*[-\\\/]+c(?:onvert)?\s*$/i)
		{
			$action_convert = 1;
		}
		elsif( $argument =~ /^\s*[-\\\/]+v(?:erbose)?\s*$/i)
		{
			$verbose = 1;
		}
		elsif( !defined $filename && !defined $dirname && -f $argument)
		{
			$filename = $argument;
		}
		elsif( !defined $filename && !defined $dirname && -d $argument)
		{
			$dirname = $argument;
		}
		elsif( !defined $from_type && defined $linebreaks{ $argument}->[ 1])
		{
			$from_type = $argument;
		}
		elsif( !defined $to_type && defined $linebreaks{ $argument}->[ 1])
		{
			$to_type = $argument;
		} else {
			usage();
		}
	}

	usage() if ( defined $filename == defined $dirname) || ( $action_test && $action_convert);

	if( $action_convert)
	{
		usage() if !defined $from_type;

		( $to_type, $from_type) = ( $from_type, undef) if !defined $to_type;

		if( defined $dirname)
		{
			recurse
			{
				if( -f $_)
				{
					convert_main( $from_type, $to_type, $verbose, $_);
				}
			} $dirname;
		} else {
			convert_main( $from_type, $to_type, $verbose, $filename);
		}
	} else {
		usage() if defined $to_type;
		my $filetype = test( $filename);
		print '' . ( defined $from_type ? ( $filetype eq $from_type ? 'yes' : 'no') : $filetype) . ($verbose ? "\t$filename" : '') . "\n";
	}
} # parse_arguments


sub version
###########
{
	print <<"EOT";
$versionstring
Copyright (C) 2001 2002 2003 Sven Kleese, Hamburg (Germany)\n
    This program comes with ABSOLUTELY NO WARRANTY.
    You may redistribute copies of this program
    under the terms of the GNU General Public License.
    For more information about these matters, see the file named COPYING.\n
EOT
	exit;
} # version


sub usage
#########
{
	print "\nDebug: usage() called in line " . (caller())[2] . "\n\n" if $debug;
	print <<"EOT";
$versionstring\n
Usage:
$0 -h|--help|--version
$0 [-t|--test] [-v|--verbose] FILENAME [TYPE]
$0 (-c|--convert) [-v|--verbose] FILENAME [<TYPE>] <TYPE>
EOT
	exit;
} # usage


sub help
########
{
	print "\nDebug: help() called in line " . (caller())[2] . "\n\n" if $debug;
	print <<"EOT";
$versionstring\n

Ausführlichere Hilfe

Usage:
$0 -h|--help|--version
$0 [-t|--test] [-v|--verbose] FILENAME [TYPE]
$0 (-c|--convert) [-v|--verbose] FILENAME [<TYPE>] <TYPE>

Report bugs to gonzo\@cpan.org
EOT
	exit;
} # help


sub test
########
{
	my ( $filename) = @_;

	sysopen( FH, $filename, O_RDONLY) or die "file '$filename': $!\n";
	binmode FH;		# binmode FH seems to be more compatible with DOS than O_BINARY:

	my $result = 0;
	if( -B FH)
	{
		$result = 'binary';
	} else {
		sysseek( FH, 0, SEEK_SET) or die "Couldn't seek start of file '$filename': $!\n";
		while( sysread( FH, my $byte, 1) )
		{
			if( $byte eq chr( 0x0D) )
			{
				sysread( FH, $byte, 1) or last;

				if( $byte eq chr( 0x0A) )
				{
					$result |= $linebreaks{ 'dos'}->[ 0];
				} elsif( $byte eq chr( 0x0D) )
				{
					sysread( FH, $byte, 1) or last;

					if( $byte eq chr( 0x0A) )
					{
						$result |= $linebreaks{ 'broken'}->[ 0];
					} else {
						$result |= $linebreaks{ 'mac'}->[ 0];
					}
				} else {
					$result |= $linebreaks{ 'mac'}->[ 0];
				}
			} elsif( $byte eq chr( 0x0A) )
			{
				$result |= $linebreaks{ 'unix'}->[ 0];
			}
		}
	}
	close FH;

	my $filetype;
	if( defined( $filetypes{ $result}->[ 0]))
	{
		$filetype = $filetypes{ $result}->[ 0];
	} else {
		$filetype = $filetypes{ undef}->[ 0];
	}

	return $filetype;
} # test


sub convert_main
################
{
	my ( $from_type, $to_type, $verbose, $filename) = @_;

	my $filetype = test( $filename);

	if( defined $from_type)
	{
		if( $filetype eq $from_type)
		{
			convert_sub( $to_type, $filename, $filetype);
		} else {
			print '' . ( $verbose ? "$filetype doesn't match <from> type $from_type\t$filename\n" : '');
		}
	} elsif( $filetype ne 'binary')
	{
		convert_sub( $to_type, $filename, $filetype);
	} else {
		print '' . ( $verbose ? "$filetype files will not be converted\t$filename\n" : '');
	}
} # convert_main


sub convert_sub
###############
{
	my ( $to_type, $filename, $filetype) = @_;

	rename( $filename, "$filename,bak") or die "rename '$filename' to '$filename,bak' failed: $!\n";

	sysopen( FH, "$filename,bak", O_RDONLY) or die "file '$filename,bak': $!\n";
	binmode FH;		# binmode FH seems to be more compatible with DOS than O_BINARY

	sysopen( OF, $filename, O_WRONLY | O_CREAT) or die "file '$filename': $!\n";
	binmode OF;		# binmode FH seems to be more compatible with DOS than O_BINARY

	while( sysread( FH, my $byte, 1) )
	{
		if( $byte eq chr( 0x0D) )
		{
			if( !sysread( FH, $byte, 1) )
			{
				syswrite( OF, $linebreaks{ $to_type}->[ 1] ) if( $filetype =~ /^(?:mac|strange)$/);	# Was ist mit dem Rückgabewert?
				last;
			}

			if( $byte eq chr( 0x0A) )
			{
				# dos
				syswrite( OF, $linebreaks{ $to_type}->[ 1] );	# Was ist mit dem Rückgabewert?
			} elsif( $byte eq chr( 0x0D) )
			{
				if( !sysread( FH, $byte, 1) )
				{
					syswrite( OF, $linebreaks{ $to_type}->[ 1] x 2 ) if( $filetype =~ /^(?:mac|strange)$/);	# Was ist mit dem Rückgabewert?
					last;
				}

				if( $byte eq chr( 0x0A) )
				{
					# broken
					syswrite( OF, $linebreaks{ $to_type}->[ 1] );	# Was ist mit dem Rückgabewert?
				} else {
					# mac
					syswrite( OF, $linebreaks{ $to_type}->[ 1] x 2 );	# Was ist mit dem Rückgabewert?
					syswrite( OF, $byte);
				}
			} else {
				# mac
				syswrite( OF, $linebreaks{ $to_type}->[ 1] );	# Was ist mit dem Rückgabewert?
				syswrite( OF, $byte);
			}
		} elsif( $byte eq chr( 0x0A) )
		{
			# unix
			syswrite( OF, $linebreaks{ $to_type}->[ 1] );	# Was ist mit dem Rückgabewert?
		} else {
			syswrite( OF, $byte);	# Was ist mit dem Rückgabewert?
		}
	}

	close FH;
	close OF;
} # convert_sub


__END__


=head1 NAME

LineBreakTool - convert linebreaks of text files


=head1 SYNOPSIS

B<linebreaktool> -h|--help|--version

B<linebreaktool> [-t|--test] [-v|--verbose] F<FILE> [TYPE]

B<linebreaktool> (-c|--convert) [-v|--verbose] F<FILE> [TYPE] TYPE


=head1 README

With this script you can check if a text file is of
a specific type and convert it to a different type.

Special feature is the ability of fixing files that were
broken by wrong ftp upload and download mode (ascii/bin).

Supported file types are dos, mac, unix and broken.

It also runs under DOS.

(unix2dos dos2unix fixeol newline linebreak)


=head1 DESCRIPTION

=over 4

=item B<-h,  --help>

Output usage information and exit.

=item B<--version>

Output version information and exit.

=item B<-v, --verbose>

Be verbose about what happens.

=item F<FILE>

The name of the file or directory to treat.

If you give a directory name all files will recursively be treated.

=item B<-t, --test>

Test the type of file.

If TYPE is given it prints if the type of the file matches TYPE.

=item TYPE

The type of the file will be compared with TYPE.

=item B<-c, --convert>

Convert the file to the given type (<to>).

=item TYPE

The file will only be converted if its type matches <from>.

=item TYPE

The file will be converted to the type <to>.

=back


=head1 SCRIPT CATEGORIES

UNIX/System_administration

Win32


=head1 WARRANTY

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.


=head1 COPYING

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.


=head1 CREDITS

Jeffrey E.F. Friedl inspired me to implement the regex myself.


=head1 AUTHOR

Copyright (C) 2001 2002 2003 Sven Kleese, Hamburg (Germany)

GONZO <gonzo@cpan.org>


$Name: v0-2pre1 $ $Date: 2003/02/19 13:29:53 $

