#!/usr/bin/env perl
#cito M:644 O:0 G:0 T:/usr/share/perl5/TFL.pm
#----------------------------------------------------------------------------------
# Project Name      - PerlProjects/TFL.pm
# Started On        - Mon  6 May 19:29:05 BST 2019
# Last Change       - Fri  3 Jan 13:06:17 GMT 2020
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

package TFL;

=encoding utf8

=head1 NAME

TFL -- key features for TFL programs and general Perl scripts.

=head1 DESCRIPTION

The TFL module provides features written for and used by TFL programs
and general Perl scripts.

=head1 AUTHORS

terminalforlife <terminalforlife@yahoo.com>

=cut

require v5.22.1;
require Exporter;

use strict;
use warnings;
use vars '@ISA', '@EXPORT', '$VERSION';

@ISA = 'Exporter';

@EXPORT = (
	'$PROGNAME', '$AUTHOR', '$GITHUB', 'FErr', 'Err', 'KeyVal',
	'DepChk', 'KeyDef', 'UsageCPU', 'UnderLine'
);

$VERSION = '2020-01-02';

our ($PROGNAME) = $0 =~ m{(?:.*/)?([^/]*)};
our $AUTHOR = 'written by terminalforlife <terminalforlife@yahoo.com>';
our $GITHUB = 'https://github.com/terminalforlife';

=head1 VARIABLES

=over 4

=item $TFL::PROGNAME

Contains the name of the current program.

=item $TFL::AUTHOR

Contains the author and E-Mail string for all TFL code.

=item $TFL::GITHUB

Contains the URL for the TFL author's GitHub repositories.

=cut

=back

=head1 FUNCTIONS

=over 4

=item FErr()

Example: FErr(1, __LINE__, "Text for error goes here.")
$_[0] = Boolean integer for whether to exit 1 (1) or not (0).
$_[1] = Line number; an integer, or, preferably, '__LINE__'.
$_[2] = The error message string itself, sans newline character.

=cut

sub FErr{
	printf("[L%0.4d] ERROR: %s\n", $_[1], $_[2]);
	exit(1) if $_[0]
}

=item Err()

Example: Err(1, "Text for error goes here.")
$_[0] = Boolean integer for whether to exit 1 (1) or not (0).
$_[1] = The error message string itself, sans newline character.

=cut

sub Err{
	printf("ERROR: %s\n", $_[1]);
	exit(1) if $_[0]
}

=item KeyVal()

Example: KeyVal($ARGV[0], 0)
$_[0] = String 'key=value' to split.
$_[1] = Index to return; 0 (key) or 1 (value).

=cut

sub KeyVal{
	return(@{[split('=', $_[0])]}[$_[1]])
}

=item KeyDef()

Example: KeyDef(%KEYS)
$_[0] = A hash reference of keys whose existence are to be tested.
$_[1] = An array reference whose indices contain viable key choices.

=cut

sub KeyDef{
	my $Failed = 0;
	foreach my $KeyViable (@{($_[1])}){
		my $Count = 0;

		foreach my $Key (keys(%{$_[0]})){
			if($KeyViable eq $Key){
				$Count++;

				die("Value for '$Key' key not defined.")
					unless defined(${$_[0]}{$Key})
			}
		}

		if($Count == 0){
			die("Key '$KeyViable' not defined");
			$Failed++
		}
	}

	exit(1) if $Failed > 0
}

=item DepChk()

Example_2: DepChk('man')
Example_1: DepChk('/usr/bin/man')
Example_3: DepChk(':', 'man') || print("Not found.\n")
@_ = Executable file for which to search in PATH; basename or absolute path.

=cut

sub DepChk{
	my $Passive = 'false';
	if ($_[0] eq ':'){
		$Passive = 'true';
		shift(@_)
	}

	my $DepCount = 0;
	foreach my $CurDep (@_){
		my $Found = 'false';

		if ($CurDep !~ '/'){
			foreach my $CurDir (split(':', $ENV{'PATH'})){
				foreach my $CurFile (glob("$CurDir/*")){
					next unless -f -x $CurFile;

					if ($CurFile =~ "/$CurDep\$"){
						$Found = 'true';
						last
					}
				}
			}
		}else{
			$Found = 'true' if -f -x $CurDep
		}

		if ($Found ne 'true'){
			return(1) if $Passive eq 'true';
			printf(STDERR "ERROR: Dependency '%s' not met.\n", $CurDep);
			exit(1)
		}
	}
}

=item UnderLine()

Example: UnderLine('-', 'This is an underlined string.')
$_[0] = A single character to repeat for each on the line above.
$_[1] = The string to underline, such as an important message.

=cut

sub UnderLine{
	return($_[1] . "\n" . $_[0] x length($_[1]))
}

=item UsageCPU()

Example: UsageCPU('cpu') | TFL::UsageCPU('cpu2')
$_[0] = The CPU to grab the percentage (integer) of its usage. {cpu | cpu[INT]}

=cut

sub UsageCPU{
	my $StatFile = '/proc/stat';

	exit(1) unless -f -r $StatFile;

	open(my $FH, '<', $StatFile);
	my @StatData = <$FH>;
	close($FH);

	foreach (@StatData){
		chomp(my @Buf = split(' ', $_));
		next if $Buf[0] ne $_[0];

		my $Usage = ($Buf[1] + $Buf[3]) * 100 / ($Buf[1] + $Buf[3] + $Buf[4]);

		return(int($Usage))
	}
}

=back

=head1 CHANGES

=over 4

=item 2020-01-02

Removed PKGVersion().

Allowed for the exportation of almost all subroutines.

Renamed Defined() to KeyDef(), and FAIL() to FErr().

=item 2019-12-14

Removed i3Do(), DepChkPortable(), _ArgChk(), and UpdChk().

Added Err().

=item 2019-05-16

Added DepChkPortable() and PKGVersion().

=item 2019-05-12

Added i3Do() and UnderLine().

=item 2019-05-07

Added KeyVal(), _ArgChk(), and DepChk().

=item 2019-05-06

TFL module development began.

=back

=cut

return(1)
