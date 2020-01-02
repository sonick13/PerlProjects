#!/usr/bin/env perl

#----------------------------------------------------------------------------------
# Project Name      - PerlProjects/TFL.pm
# Started On        - Mon  6 May 19:29:05 BST 2019
# Last Change       - Thu  2 Jan 18:59:38 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Perl module for key features for TFL programs and general Perl scripts.
#----------------------------------------------------------------------------------

use v5.22.1;
use strict;
use warnings;
use autodie;

package TFL;

my $CurVer = '2020-01-02';

# Example: my ($Year, $Month, $Day) = TFL::PKGVersion()
sub PKGVersion{
	return(split('-', $CurVer)) # <-- Year [0], Month [1], Day [2]
}

# Old method, as of 2019-12-14.
# Example: TFL::FAIL(1, __LINE__, "Text for error goes here.")
# $_[0] = Boolean integer for whether to exit 1 (1) or not (0).
# $_[1] = Line number; an integer, or, preferably, '__LINE__'.
# $_[2] = The error message string itself, sans newline character.
sub FAIL{
	printf("[L%0.4d] ERROR: %s\n", $_[1], $_[2]);
	exit(1) if $_[0]
}

# Example: TFL::Err(1, "Text for error goes here.")
# $_[0] = Boolean integer for whether to exit 1 (1) or not (0).
# $_[1] = The error message string itself, sans newline character.
sub Err{
	printf("ERROR: %s\n", $_[1]);
	exit(1) if $_[0]
}

# Example: TFL::KeyVal($ARGV[0], 0)
# $_[0] = String 'key=value' to split.
# $_[1] = Index to return; 0 (key) or 1 (value).
sub KeyVal{
	return(@{[split('=', $_[0])]}[$_[1]])
}

# Example: TFL::Defined(%KEYS)
# $_[0] = A hash reference whose keys are to be tested by defined().
# $_[1] = An array reference whose indices contain viable key choices.
sub Defined{
	my $Failed = 0;
	foreach my $KeyViable (@{($_[1])}){
		my $Count = 0;

		foreach my $Key (keys(%{$_[0]})){
			if($KeyViable eq $Key){
				$Count++;

				die("Value for '$Key' key not defined.")
					unless defined(${$_[0]}{$Key})
			}
		}

		if($Count == 0){
			die("Key '$KeyViable' not defined");
			$Failed++
		}
	}

	exit(1) if $Failed > 0
}

# Example_2: TFL::DepChk('man')
# Example_1: TFL::DepChk('/usr/bin/man')
# Example_3: TFL::DepChk(':', 'man') || print("Not found.\n")
# @_ = Executable file for which to search in PATH; basename or absolute path.
sub DepChk{
	my $Passive = 'false';
	if ($_[0] eq ':'){
		$Passive = 'true';
		shift(@_)
	}

	my $DepCount = 0;
	foreach my $CurDep (@_){
		my $Found = 'false';

		if ($CurDep !~ '/'){
			foreach my $CurDir (split(':', $ENV{'PATH'})){
				foreach my $CurFile (glob("$CurDir/*")){
					next unless -f -x $CurFile;

					if ($CurFile =~ "/$CurDep\$"){
						$Found = 'true';
						last
					}
				}
			}
		}else{
			$Found = 'true' if -f -x $CurDep
		}

		if ($Found ne 'true'){
			return(1) if $Passive eq 'true';
			printf(STDERR "ERROR: Dependency '%s' not met.\n", $CurDep);
			exit(1)
		}
	}
}

# Example: TFL::UnderLine('-', 'This is an underlined string.')
# $_[0] = A single character to repeat for each on the line above.
# $_[1] = The string to underline, such as an important message.
sub UnderLine{
	return($_[1] . "\n" . $_[0] x length($_[1]))
}

# Example: TFL::UsageCPU('cpu') | TFL::UsageCPU('cpu2')
# $_[0] = The CPU to grab the percentage (integer) of its usage. {cpu | cpu[INT]}
sub UsageCPU{
	my $StatFile = '/proc/stat';

	exit(1) unless -f -r $StatFile;

	open(my $FH, '<', $StatFile);
	my @StatData = <$FH>;
	close($FH);

	foreach (@StatData){
		chomp(my @Buf = split(' ', $_));
		next if $Buf[0] ne $_[0];

		my $Usage = ($Buf[1] + $Buf[3]) * 100 / ($Buf[1] + $Buf[3] + $Buf[4]);

		return(int($Usage))
	}
}

return(1)
