#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/GUI-test.pl
# Started On        - Wed 17 Apr 23:52:06 BST 2019
# Last Change       - Thu 25 Apr 14:12:58 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# NOTE: When referencing a function (\&FUNC), it doesn't require prior loading.
#
# NOTE: Available arguments to methods are sometimes shown in C format.
#
# NOTE: Where function references can also be in-line code: sub{command}
#
# NOTE: Event types used in this script:
#
#         destroy          - When the window manager closes the window.
#         clicked          - When a button is clicked. (on release)
#
# NOTE: A HBox is horizontal, whereas VBox is vertical.
#----------------------------------------------------------------------------------

use strict;
use warnings;
use autodie;
use Gtk2 '-init';
use Glib qw/TRUE FALSE/;

#-----------------------------------------------------------------------MAIN WINDOW

my $MAIN_WINDOW = Gtk2::Window->new('toplevel');
$MAIN_WINDOW->signal_connect(destroy => sub{Gtk2->main_quit()});
$MAIN_WINDOW->set_title("InfoBox");
$MAIN_WINDOW->set_border_width(10);
#$MAIN_WINDOW->set_default_size(300,150);
$MAIN_WINDOW->set_resizable(FALSE);
$MAIN_WINDOW->set_focus();

#-------------------------------------------------------------------------CONTAINER

my $BOX = Gtk2::HBox->new(FALSE, 10);

#-------------------------------------------------------------------------OK BUTTON

my $OK_BUTTON = Gtk2::Button->new("OK");
$OK_BUTTON->signal_connect(clicked => \&OK_BUTTON_CLICK);

$MAIN_WINDOW->add($BOX);

#--------------------------------------------------------------------------TEXT BOX

my $LONG_STRING = 'This is to demonstrate the effects of a really long string.';
my $LABEL = Gtk2::Label->new("$LONG_STRING");

#---------------------------------------------------------------------------PACKING

$BOX->pack_start($LABEL, FALSE, FALSE, 4);
$BOX->pack_start($OK_BUTTON, FALSE, FALSE, 0);
#$BOX->reorder_child($OK_BUTTON, 1); # Arg 2: 0 is left, 1 is right.

#---------------------------------------------------------FUNCTIONS FOR REFERENCING

sub OK_BUTTON_CLICK{
	print("EVENT: Button 'OK' clicked.\n");
	Gtk2->main_quit()

}

#-----------------------------------------------------------------------------BEGIN

foreach($BOX, $LABEL, $OK_BUTTON, $MAIN_WINDOW){
	$_->show()
}

Gtk2->main();
