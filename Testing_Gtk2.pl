#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/GUI-test.pl
# Started On        - Wed 17 Apr 23:52:06 BST 2019
# Last Change       - Thu 18 Apr 00:11:13 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

# Tells Perl you want to use the Gtk2 module. -init (synonymous to ->init) is very
# important, setting up GLIB and GTK+. Seems like it should near-always be used.
use Gtk2 -init;

# For some reason -> is needed here and below, whereas above, -init is required.
my $window = Gtk2::Window ->new('toplevel');

# Show the window.
$window ->show_all;

# Begin the loop. (basically, start the whole GTK thing, until closed)
Gtk2 ->main;
