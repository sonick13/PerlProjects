#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/setup.pl
# Started On        - Fri 19 Apr 16:14:05 BST 2019
# Last Change       - Fri 19 Apr 18:45:29 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# In my vimconfig setup, I have a ,setup snippet, which reads into the file text
# like the following, but in shell. This is a test of the Perl equivalent.
#----------------------------------------------------------------------------------

use feature say;
use strict;
use warnings;

my $_VERSION_ = "2019-04-19";

sub USAGE(){
	my $help = qq{
		            EXAMPLE ($_VERSION_)
		            Written by terminalforlife (terminalforlife\@yahoo.com)

		            Dummy description for this template.

		SYNTAX:     example [OPTS]

		OPTS:       --help|-h|-?            - Displays this help information.
		            --version|-v            - Output only the version datestamp.
	};

	say split("\t", $help);
};

while($ARGV[0]){
	if($ARGV[0] =~ /^(--help|-h|-\?)$/){
		USAGE; exit 0;
	}elsif($ARGV[0] =~ /^(--version|-v)$/){
		say "$_VERSION_"; exit 0;
	}else{
		die "Incorrect argument(s) specified";
	};

	shift @ARGV;
};

my $DEPCOUNT = 0;
for my $DEP ("/usr/bin/apt-get", "/bin/ls", "/bin/sleep"){
	unless(-x $DEP){
		warn "Dependency '$DEP' not met";
		my $DEPCOUNT += 1;
	};
};

if($DEPCOUNT != 0){ exit 255; };

#unless($ENV{"UID"} = 0){
#	die "Root access is required";
#};
