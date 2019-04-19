#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/uptime.pl
# Started On        - Wed 17 Apr 13:13:34 BST 2019
# Last Change       - Fri 19 Apr 19:21:56 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# A rewrite of the 'up' function in my .bash_functions file, in Perl.
#----------------------------------------------------------------------------------

use strict;
use warnings;

my $filename = "/proc/uptime";

if(-f $filename){
	open(my $file, '<', $filename);

	while(my $line = <$file>){
		my @array = split(" ", $line);
		my $hour = int($array[0] / 60 / 60);
		my $min = int($array[0] / 60 - ($hour * 60));

		my ($hour_s, $min_s);

		if($hour gt 1 || $hour eq 0){
			$hour_s = "s";
		}else{
			$hour_s = "";
		};

		if($min gt 1 || $min eq 0){
			$min_s = "s";
		}else{
			$min_s = "";
		};

		printf(
			"UP: %d hour%s and %d minute%s.\n",
			$hour, $hour_s, $min, $min_s
		);
	};

	close("$file");
}else{
	die "File '$filename' not found";
};
