#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/Testing_LWP.pl
# Started On        - Mon 22 Apr 16:57:23 BST 2019
# Last Change       - Mon 22 Apr 17:57:57 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Testing grounds for viewing files from the WWW, using Perl itself.
#----------------------------------------------------------------------------------

use strict;
use warnings;
use LWP::Simple;

my $_VERSION_ = "2019-04-22";

my $TARG = $ARGV[0]; # Target URL of the file.
my $DEST = $ARGV[1]; # Destination for the file.

print(get($TARG))
