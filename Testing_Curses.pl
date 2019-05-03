#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/Testing_Curses.pl
# Started On        - Thu  2 May 16:33:38 BST 2019
# Last Change       - Thu  2 May 18:05:52 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

use strict;
use warnings;
use autodie;
#use Curses; # <-- libcurses-perl
use Curses::UI; # <-- libcurses-ui-perl (widgets: libcurses-widgets-perl)

my $UI = Curses::UI->new(
	-clear_on_exit => 0,
	-color_support => 1,
	-mouse_support => 0
);

#my @MENU = (
#	{
#		-label => 'File',
#		-submenu => [
#			{
#				-label  => 'Exit',
#				-value => \&EXIT_DIALOG
#			}
#		]
#	}
#);

#sub QUIT_DIALOG{
#	my $VALUE = $UI->dialog(
#		-message => 'Do you really want to quit?',
#		-title => 'Are you sure?',
#		-buttons => ['yes', 'no']
#	);
#
#	exit(0) if $VALUE
#}

sub QUIT_DIALOG{
	my $YESNO = $UI->dialog(
		-message => 'Are you sure you want to quit?',
		-title => "Dialog",
		-buttons => ['yes', 'no']
	);

	exit(0) if $YESNO
}

#my $MENU = $UI->add(
#	'menu', 'Menubar',
#	-menu => \@MENU,
#	-fg => 'blue'
#);

my $WINDOW = $UI->add(
	'window', 'Window',
	-border => 1,
	-y => 1, -x => 1,
	-bfg => 'white'
	#-bbg => 'white'
);

#my $TEXT_EDITOR = $WINDOW->add(
#	'text', 'TextEditor',
#	-text => "Here is some text.\n"
#);

#$UI->set_binding(sub{$MENU->focus()}, "\cX");
#$UI->set_binding(sub{exit(0)}, "\cQ");
$UI->set_binding(\&QUIT_DIALOG, "\cQ");

my $TEXT_TO_VIEW = "Test";

my $TEXT_VIEWER = $WINDOW->add(
	'test', 'TextViewer',
	-text => $TEXT_TO_VIEW
);

$TEXT_VIEWER->focus();
#$TEXT_EDITOR->focus();

$UI->mainloop()
