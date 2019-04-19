#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/redshifter.pl
# Started On        - Fri 19 Apr 23:05:28 BST 2019
# Last Change       - Sat 20 Apr 00:16:49 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Perl rewrite of shell program redshifter.
#----------------------------------------------------------------------------------

use strict;
use warnings;

my $_VERSION_ = "2019-04-19";

my $HOME = $ENV{HOME};
my $BUFFER = "$HOME/.config/redshifter.tmp";
unless(-d "$HOME/.config"){ mkdir("$HOME/.config"); };

if(!( -f $BUFFER && -r $BUFFER)){
	my $GAMMAS_NOW = 6500;

	if(open(my $FILE, '>', $BUFFER)){
		print("6500\n");
		close("$FILE");
	};
}else{
	if(open(my $FILE, '<', $BUFFER)){
		my $GAMMAS_NOW = <$BUFFER>;
		close("$FILE");
	};
};

while("$ARGV[0]"){
	if($ARGV[0] =~ /^(--version|-v)$/){
		print("$_VERSION_\n");
		exit 0;
	}elsif($ARGV[0] =~ /^(--reset|-r)$/){
		open(my $FILE, '>', $BUFFER);
		select $FILE;
			print("6500\n");
		close("$FILE");

		system('/usr/bin/redshift -o -O 6500K');
	}elsif($ARGV[0] =~ /^(--increment|-i)$/){
		my $TEMP = $GAMMAS_NOW + $ARGV[1];
		if($TEMP gt 25000){ exit 0; };

		open(my $FILE, '>', $BUFFER);
		select $FILE;
			print("$TEMP\n");
		close("$FILE");

		system('/usr/bin/redshift -o -O ${TEMP}K');
	}elsif($ARGV[0] =~ /^(--decrement|-d)$/){
		my $TEMP = $GAMMAS_NOW - $ARGV[1];
		if($TEMP lt 1000){ exit 0; }:

		open(my $FILE, '>', $BUFFER);
		select $FILE;
			print("$TEMP\n");
		close("$FILE");

		system('/usr/bin/redshift -o -O ${TEMP}K');
	}else{
		last;
	};

	shift(@ARGV);
};

# vim: ft=sh noexpandtab colorcolumn=84 tabstop=8 noswapfile nobackup
