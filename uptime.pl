#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/uptime.pl
# Started On        - Wed 17 Apr 13:13:34 BST 2019
# Last Change       - Thu 18 Apr 01:01:14 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# A rewrite of the 'up' function in my .bash_functions file, in Perl.
#----------------------------------------------------------------------------------

# The former is for catching and stopping at certain errors. The latter merely
# warns of certain errors, but proccesses the code none-the-less. Recommended.
# These seem very useful until experienced enough, but even then, worth using?
use strict;
use warnings;

my $filename = "/proc/uptime";

# Open and output the contents of the given file, if found.
if(-e "$filename"){
	# Open file for reading (> is writing). The :encoding(UTF-8) part can be
	# omited, but it seems it's not recommended.
	open(my $file, '<:encoding(UTF-8)', "$filename");

	# This is effectively like the shell while read loop, but easier to read.
	# $line resembles each line from the file, as with the default of $REPLY in
	# a shell while read loop. While each line is true, effectively, continue
	# through the loop, until there's nothing left.
	while(my $line = <file>){
		# $_ seems to store the currently iterated line. It's like a
		# placeholder in various areas of the Perl programming language.
		my(@array = split(" ", $line));
		my($hour = $array[0] / 60 / 60);
		my($min = $array[0] / 60 - ($hour * 60));

		# Within {}, even in if statements, it's local not global, so my()
		# has no effect. You must first declare (not necessarily set) the
		# variable outside of {}.
		my($hour_s, $min_s);

		# Check for and set the correct grammar for both hours and minutes.
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

		# Print the final, parsed output.
		printf("UP: %d hour%s and %d minute%s.\n", $hour, $hour_s, $min, $min_s);
	};
}else{
	die "File '$filename' not found";
};

close("file");
