#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/libtfl.pm
# Started On        - Mon  6 May 19:29:05 BST 2019
# Last Change       - Tue  7 May 15:05:44 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Perl module for key features for TFL programs and general Perl scripts.
#----------------------------------------------------------------------------------

use strict;
use warnings;
use autodie;

package TFL;

my $_VERSION_ = "2019-05-07";

# Example: TFL::_ArgChk('FAIL', 2)
# $_[0] = Function name to display in die() message.
# $_[1] = Integer for the required number of function arguments.
sub _ArgChk{die "TFL::$_[0]() requires $_[1] arguments" if not $#_ == $_[1]}

# Example: TFL::FAIL(1, __LINE__, "Text for error goes here.")
# $_[0] = Boolean integer for whether to exit 1 (1) or not (0).
# $_[1] = Line number; an integer, or, preferably, '__LINE__'.
sub FAIL{
	_ArgChk('FAIL', 2);

	printf("[L%0.4d] ERROR: %s\n", $_[1], $_[2]);
	exit(1) if $_[0]
}

# Example: TFL::UpdChk($UPDATE, $GH_URL, $_VERSION_)
# $_[0] = Boolean integer for whether an update check should commence.
# $_[1] = A URL string recognisable by 'LWP::Simple'.
# $_[2] = The program's current version, preferably 0000-00-00 format.
sub UpdChk{
	_ArgChk('UpdChk', 3);

	if($_[0]){
		use LWP::Simple;

		my $REMOTE = get($_[1]);
		if(defined($REMOTE)){
			if($_VERSION_ ne $REMOTE){
				print(
					"Remote:     @{[$REMOTE =~ tr/\n//dr]}\n" .
					"Local:      $_VERSION_\n"
				)
			}
		}else{
			FAIL(1, __LINE__, "Failed to check for available updates.")
		}

		exit 0
	}
}

# Example: KeyVal($ARGV[0], 0)
# $_[0] = String 'key=value' to split.
# $_[1] = Index to return; 0 (key) or 1 (value).
sub KeyVal{
	_ArgChk('KeyVal', 2);

	return(@{[split('=', $_[0])]}[$_[1]])
}

# Example: DepChk()
# $_[0] = Executable file path for which to be checked.
# $_[1] = Same as first argument in FAIL().
# $_[2] = Same as second argument in FAIL().
sub DepChk{
	_ArgChk('DepChk', 3);

	FAIL($_[1], $_[2], "Missing required '$_[0]' executable.")
		unless -f $_[0] and -x $_[0];
}

return(1)
