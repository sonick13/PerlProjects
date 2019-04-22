#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/reviewer.pl
# Started On        - Mon 22 Apr 01:30:36 BST 2019
# Last Change       - Mon 22 Apr 15:08:23 BST 2019
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

sub USAGE{
	my $HELP = qq{
		            REVIEWER ($_VERSION_)
		            Written by terminalforlife (terminalforlife\@yahoo.com)

		            Perl rewrite of the slow, inefficient shell counterpart.

		SYNTAX:     reviewer [OPTS] PACKAGE RATING

		OPTS:       --help|-h|-?            - Displays this help information.
		            --version|-v            - Output only the version datestamp.
		            --summary|-S            - Conclude the reviews with a summary.

		FILE:       The database file used is:

		              \$HOME/.config/reviewer.db
	};

	print(split("\t", $HELP));
}

my $SHOW_STATS = "False";

if(@ARGV){
	while($ARGV[0]){
		if($ARGV[0] =~ /^(--help|-h|-\?)$/){
			USAGE
			exit 0
		}elsif($ARGV[0] =~ /^(--version|-v)$/){
			print("$_VERSION_\n");
			exit 0
		}elsif($ARGV[0] =~ /^(--summary|-S)$/){
			$SHOW_STATS = "True"
		}elsif($ARGV[0] =~ /^-.*/){
			XERR(__LINE__, "Incorrect argument(s) specified.")
		}else{
			last
		}

		shift(@ARGV)
	}

	if(! $ARGV[0]){
		XERR(__LINE__, "A package name must be provided.")
	}elsif(! $ARGV[1]){
		XERR(__LINE__, "A rating must be provided.")
	}elsif(! $ARGV[1] =~ /^[1-5]$/){
		XERR(__LINE__, "Invalid rating specified.")
	}
}else{
	XERR(__LINE__, "One or more arguments are required.")
}

if(! -x "/usr/bin/tput"){
	XERR(__LINE__, "Dependency '/usr/bin/tput' not met.")
}

my $DATABASE = "$ENV{HOME}/.config/reviewer.db";
unless(-f $DATABASE && -r $DATABASE){
	XERR(__LINE__, "File '$DATABASE' not found.")
}

$Text::Wrap::columns = `/usr/bin/tput cols`;

open(my $FH, '<', $DATABASE);

my $STAR1_COUNT = 0;
my $STAR2_COUNT = 0;
my $STAR3_COUNT = 0;
my $STAR4_COUNT = 0;
my $STAR5_COUNT = 0;
my $TTL_COUNT = 0;
my $COUNT = 0;
while(<$FH>){
	my @LINE = split("~~~", $_);

	my $PACK = $LINE[0];
	my $RATE = $LINE[3];
	my $SAID = $LINE[4];
	my $USER = $LINE[2];

	if($PACK eq $ARGV[0]){
		$TTL_COUNT += 1;

		my @DATA = ($RATE, $SAID, $USER);
		if($DATA[0] == $ARGV[1]){
			$COUNT++;

			printf(
				"%d/5 ('%s')\n -\n%s -\n",
				$DATA[0], $DATA[2],
				wrap(" | ", " | ", $DATA[1])
			)
		}
	}
}

close($FH);

if($SHOW_STATS eq "True"){
	print("\n   +----------/");
	printf("\n   | Reviews:     %d/%d\n   |", $COUNT, $TTL_COUNT);
	printf("\n   | Total 1/5:   %d", $STAR1_COUNT);
	printf("\n   | Total 2/5:   %d", $STAR2_COUNT);
	printf("\n   | Total 3/5:   %d", $STAR3_COUNT);
	printf("\n   | Total 4/5:   %d", $STAR4_COUNT);
	printf("\n   | Total 5/5:   %d\n", $STAR5_COUNT);
	print("   +----------------------/\n\n");
}
