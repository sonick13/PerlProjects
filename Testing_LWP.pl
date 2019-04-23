#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/Testing_LWP.pl
# Started On        - Mon 22 Apr 16:57:23 BST 2019
# Last Change       - Tue 23 Apr 18:04:10 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Testing grounds for viewing files from the WWW, using Perl itself.
#----------------------------------------------------------------------------------

use strict;
use warnings;
use LWP::UserAgent;
use feature 'say';

my $SITE = $ARGV[0];

my $UA = LWP::UserAgent->new();
$UA->agent('Mozilla/5.0');
my $DATA = $UA->get($SITE)->decoded_content;

print($DATA);
