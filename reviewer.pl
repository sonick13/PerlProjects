#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/reviewer.pl
# Started On        - Mon 22 Apr 01:30:36 BST 2019
# Last Change       - Mon 22 Apr 03:23:41 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Perl rewrite of the reviewer shell program. Far faster and more efficient.
#----------------------------------------------------------------------------------

use strict;
use warnings;
use Text::Wrap;

my $_VERSION_ = "2019-04-22";

sub XERR{ printf("[L%0.4d] ERROR: %s\n", $_[0], "$_[1]"); exit 1; }
sub ERR{ printf("[L%0.4d] ERROR: %s\n", "$1", "$2"); }

my $DATABASE = "$ENV{HOME}/.config/reviewer.db";

sub USAGE{
	my $HELP = qq{
		            REVIEWER ($_VERSION_)
		            Written by terminalforlife (terminalforlife\@yahoo.com)

		            Perl rewrite of the slow, inefficient shell counterpart.

		SYNTAX:     reviewer [OPTS] PACKAGE RATING

		OPTS:       --help|-h|-?            - Displays this help information.
		            --version|-v            - Output only the version datestamp.

		FILE:       The database file used is:

		              \$HOME/.config/reviewer.db
	};

	print(split("\t", $HELP));
}

if(@ARGV){
	while($ARGV[0]){
		if($ARGV[0] =~ /^(--help|-h|-\?)$/){
			USAGE; exit 0;
		}elsif($ARGV[0] =~ /^(--version|-v)$/){
			print("$_VERSION_\n");
			exit 0;
		}else{
			last;
		}

		shift(@ARGV);
	}

	if(! $ARGV[0]){
		XERR(__LINE__, "A package name must be provided.");
	}elsif(! $ARGV[1]){
		XERR(__LINE__, "A rating must be provided.");
	}elsif(! $ARGV[1] =~ /^[1-5]$/){
		XERR(__LINE__, "Invalid rating specified.");
	}
}else{
	XERR(__LINE__, "One or more arguments are required.");
}

if(-f $DATABASE && -r $DATABASE){
	open(my $FH, '<', $DATABASE);

	my $COUNT = 0;
	while(<$FH>){
		my @LINE = split("~~~", $_);

		my $PACK = $LINE[0];
		my $RATE = $LINE[3];
		my $SAID = $LINE[4];
		my $USER = $LINE[2];

		if($PACK eq $ARGV[0]){
			my @DATA = ($RATE, $SAID, $USER);

			if($DATA[0] == $ARGV[1]){
				$COUNT++;

				sub RESULT{
					printf(
						"%d/5 ('%s')\n\n%s\n\n",
						$DATA[0], $DATA[2], $DATA[1]
					);
				}

				$Text::Wrap::columns = 80;
				wrap(" ", RESULT);
				#TODO - Why won't this wrap() work?
			}
		}
	}

	close($FH);

	printf("\nTTL: %d\n", $COUNT);
}else{
	XERR(__LINE__, "File '$DATABASE' not found.");
}
