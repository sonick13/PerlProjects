#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/uptime.pl
# Started On        - Wed 17 Apr 13:13:34 BST 2019
# Last Change       - Wed 17 Apr 15:24:53 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# An attempt at rewriting the 'up' function in my .bash_functions file, in Perl.
#----------------------------------------------------------------------------------

# Open and output the contents of the given file.
open(file, '/proc/uptime') or die "File not found";

# This is effectively like the shell while read loop, but easier to read.
while(<file>){
	# $_ seems to store the currently iterated line. It's like a placeholder in
	# various areas of the Perl programming language.
	@array = split(" ", $_);
	$hour = $array[0] / 60 / 60;
	$min = $array[0] / 60 - ($hour * 60);

	# Check for and set the correct grammar for both hours and minutes.
	if($hour gt 1 || $hour eq 0){$hour_s = "s"}else{$hour_s = ""};
	if($min gt 1 || $min eq 0){$min_s = "s"}else{$min_s = ""};

	# Print the final, parsed output.
	printf("UP: %d hour%s and %d minute%s.\n", $hour, $hour_s, $min, $min_s);
};

close(file);
