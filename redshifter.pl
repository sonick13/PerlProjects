#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/redshifter.pl
# Started On        - Fri 19 Apr 23:05:28 BST 2019
# Last Change       - Wed 24 Apr 13:43:09 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Perl rewrite of shell program redshifter.
#----------------------------------------------------------------------------------

#TODO - Add notification support?

use strict;
use warnings;
use autodie;

my $_VERSION_ = "2019-04-24";

sub FAIL{
	printf("[L%0.4d] ERROR: %s\n", $_[1], $_[2]);
	if($_[0] == 1){exit 1}
}

my $TEMP;
my $GAMMAS_NOW;
my $HOME = $ENV{HOME};
my $BUFFER = "$HOME/.config/redshifter.tmp";

unless(-d "$HOME/.config"){
	mkdir("$HOME/.config")
}

unless(-x '/usr/bin/redshift'){
	FAIL(1, __LINE__, "Unable to find the Redshift executable.")
}

sub MAIN{
	# For resetting the value, and reading the current value.
	if($_[0] eq '>'){
		if($_[2] eq "True"){
			$GAMMAS_NOW = $_[1]
		}

		open(my $FH, '>', $BUFFER);
		print($FH "$_[1]\n");
		close($FH)
	}elsif($_[0] eq '<'){
		open(my $FH, '<', $BUFFER);
		$GAMMAS_NOW = <$FH>;
		close($FH)
	}
}

# Get current value if file available, else set default value.
unless(-f $BUFFER && -r $BUFFER){
	MAIN('>', 6500, "True")
}else{
	MAIN('<')
}

# Implicit scaler conversion. Using simple argument processing, since it's run
# non-interactively, using a keyboard shortcut.
my $ARGV_LENGTH = @ARGV;
if($ARGV_LENGTH > 2 || $ARGV_LENGTH < 1){
	FAIL(1, __LINE__, "Too few or too many arguments.")
}

if($ARGV[0] =~ /^(--version|-v)$/){
	print("$_VERSION_\n")
}elsif($ARGV[0] =~ /^(--reset|-r)$/){
	MAIN('>', '6500', "False");
}elsif($ARGV[0] =~ /^(--increment|-i)$/){
	$TEMP = $GAMMAS_NOW + $ARGV[1];
	if($TEMP > 25000){
		FAIL(1, __LINE__, "Gamma setting '25000' is the highest.")
	}else{
		MAIN('>', $TEMP, "False")
	}

	system("/usr/bin/redshift -o -O ${TEMP}K")
}elsif($ARGV[0] =~ /^(--decrement|-d)$/){
	$TEMP = $GAMMAS_NOW - $ARGV[1];
	if($TEMP < 1000){
		FAIL(1, __LINE__, "Gamma setting '1000' is the lowest.")
	}else{
		MAIN('>', $TEMP, "False")
	}

	system("/usr/bin/redshift -o -O ${TEMP}K")
}

# vim: ft=perl noexpandtab colorcolumn=84 tabstop=8 noswapfile nobackup
