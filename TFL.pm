#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - PerlProjects/TFL.pm
# Started On        - Mon  6 May 19:29:05 BST 2019
# Last Change       - Thu 16 May 12:27:48 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Perl module for key features for TFL programs and general Perl scripts.
#----------------------------------------------------------------------------------

use strict;
use warnings;
use autodie;

package TFL;

my $_VERSION_ = "2019-05-16";

# Example: TFL::_ArgChk('FAIL', 2)
# $_[0] = Function name to display in die() message.
# $_[1] = Integer (expected $#_) for the current total number of arguments.
# $_[2] = Integer for the required number of function arguments.
sub _ArgChk{die("TFL::$_[0]() requires $_[2] arguments") if $_[1] + 1 != $_[2]}

# Example: my ($Year, $Month, $Day) = TFL::PKGVersion()
sub PKGVersion{
	_ArgChk('PKGVersion', $#_, 0);

	return(split('-', $_VERSION_)) # <-- Year [0], Month [1], Day [2]
}

# Example: TFL::FAIL(1, __LINE__, "Text for error goes here.")
# $_[0] = Boolean integer for whether to exit 1 (1) or not (0).
# $_[1] = Line number; an integer, or, preferably, '__LINE__'.
# $_[2] = The error message string itself, sans newline character.
sub FAIL{
	_ArgChk('FAIL', $#_, 3);

	printf("[L%0.4d] ERROR: %s\n", $_[1], $_[2]);
	exit(1) if $_[0]
}

# Example: TFL::UpdChk($UPDATE, $GH_URL, $_VERSION_)
# $_[0] = Boolean integer for whether an update check should commence.
# $_[1] = A URL string recognisable by 'LWP::Simple'.
# $_[2] = The program's current version, preferably 0000-00-00 format.
sub UpdChk{
	_ArgChk('UpdChk', $#_, 3);

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
			die("Failed to check for updates")
		}

		exit(0)
	}
}

# Example: TFL::KeyVal($ARGV[0], 0)
# $_[0] = String 'key=value' to split.
# $_[1] = Index to return; 0 (key) or 1 (value).
sub KeyVal{
	_ArgChk('KeyVal', $#_, 2);

	return(@{[split('=', $_[0])]}[$_[1]])
}

# Example: TFL::Defined(%KEYS)
# $_[0] = A hash reference whose keys are to be tested by defined().
# $_[1] = An array reference whose indices contain viable key choices.
sub Defined{
	_ArgChk('Defined', $#_, 2);

	my $FAILED = 0;
	foreach my $KEY_VIABLE (@{($_[1])}){
		my $COUNT = 0;

		foreach my $KEY (keys(%{$_[0]})){
			if($KEY_VIABLE eq $KEY){
				$COUNT++;

				die("Value for '$KEY' key not defined.")
					unless defined(${$_[0]}{$KEY})
			}
		}

		if($COUNT == 0){
			die("Key '$KEY_VIABLE' not defined");
			$FAILED++
		}
	}

	exit(1) if $FAILED
}

# Example: TFL::DepChk('/usr/bin/man')
# $_[0] = Executable file path for which to be checked.
sub DepChk{
	_ArgChk('DepChk', $#_, 1);

	die("Dependency '$_[0]' not met.")
		unless -f $_[0] and -x $_[0];
}

# Example: TFL::DepChkPortable('/usr/bin/man')
# $_[0] = Executable file name for which to be checked.
sub DepChkPortable{
	_ArgChk('DepChkPortable', $#_, 1);

	use File::Basename 'basename';

	my $COUNT;
	foreach(split(':', $ENV{PATH})){
		foreach(glob($_ . '/*')){
			if($_[0] eq basename($_) and -x $_){
				$COUNT++; return(1)
			}
		};
	}

	die("Dependency '$_[0]' not met") unless $COUNT
}

# Example: TFL::UnderLine('This is an underlined string.')
# $_[0] = The string to underline, such as an important message.
sub UnderLine{
	_ArgChk('UnderLine', $#_, 1);

	return($_[0] . "\n" . '-' x length($_[0]))
}

# Example: TFL::i3Do(100000, 'workspace 1')
# $_[0] = Microseconds pause before the command.
# $_[1] = The 'TYPE_COMMAND' (akin to i3-msg) for i3-wm to execute.
sub i3Do{
	_ArgChk('i3Do', $#_, 2);

	use Time::HiRes 'usleep';
	use AnyEvent::I3 qw{TYPE_COMMAND i3}; # <-- libanyevent-i3-perl

	my $I3 = AnyEvent::I3->new();
	die "Unable to estalish a connection to i3-wm"
		if not $I3->connect->recv;

	die "Invalid usleep() argument -- integer required."
		if $_[0] !~ /^[0-9]+$/;

	usleep($_[0]);

	$I3->message(TYPE_COMMAND, $_[1])
}

return(1)
