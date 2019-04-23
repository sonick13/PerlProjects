#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/uptime.pl
# Started On        - Wed 17 Apr 13:13:34 BST 2019
# Last Change       - Tue 23 Apr 14:49:21 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# A rewrite of the 'up' function in my .bash_functions file, in Perl.
#----------------------------------------------------------------------------------

use strict;
use warnings;

if(open(my $FH, '<', '/proc/uptime')){
	while(<$FH>){
		my @ARRAY = split(" ", $_);
		my $HOUR = int($ARRAY[0] / 60 / 60);
		my $MIN = int($ARRAY[0] / 60 - ($HOUR * 60));

		# Use correct grammar.
		my $HOUR_S = "s";
		my $MIN_S = "s";
		if($HOUR <= 1){$HOUR_S = ""}
		if($MIN <= 1){$MIN_S = ""}

		printf(
			"UP: %d hour%s and %d minute%s.\n",
			$HOUR, $HOUR_S, $MIN, $MIN_S
		)
	}

	close($FH)
}else{
	die "ERROR: $!"
};
