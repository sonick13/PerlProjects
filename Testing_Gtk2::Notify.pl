#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/Testing_Gtk2::Notify.pl
# Started On        - Mon  6 May 00:04:31 BST 2019
# Last Change       - Mon  6 May 00:17:21 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

use strict;
use warnings;
use autodie;
use Gtk2::Notify -init, 'Notification'; # <-- libgtk2-notify-perl

my $NOT = Gtk2::Notify->new('Test notification.');
$NOT->set_urgency('critical');
$NOT->show();
