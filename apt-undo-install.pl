#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/apt-undo-install.pl
# Started On        - Tue 23 Apr 18:46:07 BST 2019
# Last Change       - Wed 24 Apr 15:05:14 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Perl rewrite which I hope will eventually replace the current apt-undo-install.
#
# NOTE: This seems to work nicely, but it does system() a few times, which I will
#       eventually do away with. You could probably use this just fine, but I
#       wouldn't recommend it, until it's been polished up and further tested.
#
# NOTE: You'll not be able to properly check THIS program for updates, yet.
#----------------------------------------------------------------------------------

use strict;
use warnings;
use autodie;

my $_VERSION_ = "2019-04-24";

sub FAIL{
	printf("[L%0.4d] ERROR: %s\n", $_[1], $_[2]);
	if($_[0] == 1){exit 1}
}

my $DOMAIN = 'https://github.com';
my $VERSION_URL = "$DOMAIN/terminalforlife/apt-undo-install/raw/master/version";
my $APT_LOGFILE = '/var/log/apt/history.log';
my $VIEW_LOGFILE = "False";
my $TIMES_TO_EXEC = 1;
my $TO_ROOT = "False"; #TODO - Set to True when finished.
my $TO_SIMULATE = "";
my $UPDATE = "False";
my $FILTADATE;
my $FILTATIME;
my $TO_AUTOREMOVE = "";
my $TO_ASSUME = "";
my $TO_PURGE = "";
my $OUTPUT_ONLY = "False";
my $OUTPUT_FORMAT;
my $TO_QUIET = "";

sub USAGE{
	my $HELP = qq{            APT-UNDO_INSTALL ($_VERSION_)
		            Written by terminalforlife (terminalforlife\@yahoo.com)

		            A Perl rewrite of the shell program, 'apt-undo-install'.

		SYNTAX:     apt-undo-install [OPTS]

		OPTS:       --help|-h|-?            - Displays this help information.
		            --version|-v            - Output only the version datestamp.
		            --quiet|-q              - Pass this flag over to apt-get.
		            --update|-U             - Check for updates to apt-undo-install.
		            --count|-c N            - Execute this N many of install undos. Will
		                                      work in reverse, from the latest to oldest.
		            --output-only:F         - Only show package name(s), if installed; -
		                                      don't uninstall. Where F is either :col, -
		                                      :list, or :desc, to choose how you'd like the
		                                      list formatted.
		            --logfile|-l FILE       - Use FILE instead of the default logfile.
		                                      But ensure it's the standard log formatting.
		                                      This will not be checked, so be careful!
		            --view                  - View the contents of the APT logfile.
		            --date|-d YYYY-MM-DD    - Specify the logged date to work with.
		            --time|-t HH:MM:SS      - Specify the logged date to work with.
		            --simulate|-s           - Use the 'simulate' option from apt-get.
		            --autoremove            - Use the 'autoremove' option from apt-get.
		            --purge                 - Use the 'purge' option from apt-get.
		            --assume-yes|-y         - Use the 'yes' option from apt-get.
		            --assume-no             - Use the 'no' option from apt-get. Takes
		                                      precedence over the 'yes' option.

		NOTE:       The standard alternative apt-get long-format flags for some of the
		            options listed above are also available with apt-undo-install.

		            The --date and --time flags may fail to work with your APT logfile if
		            you're using non-standard localisation settings for an English-speaker.
		            These flags should also not be used with the --count flag.

		EXAMPLE:    Remove, purge, and autoremove the package(s) from the last two apt-get
		            install commands as, described in the 'history.log' file, or another, -
		            same-format, file, such as a backed-up logfile.

		              apt-undo-install --purge --autoremove -c 2

		            Output the package(s), in list format, parsed from the specified
		            logfile, which were last installed with apt-get. Do not remove.

		              apt-undo-install --logfile /tmp/history.log --output-only:list

		            Simulate a removal of the package(s) installed on the given date and
		            time, as shown in the default APT logfile. Date is year-month-day.

		              apt-undo-install --date 2017-00-00 --time 20:00:00 --simulate

		FILE:       By default, the logfile parsed is '/var/log/apt/history.log'.
	};

	print(split("\t", $HELP))
}

#TODO - Use Perl equivalent of case statement.
while($ARGV[0]){
	if($ARGV[0] =~ /^(--help|-h|-\?)$/){
		USAGE;
		exit 0
	}elsif($ARGV[0] =~ /^(--version|-v)$/){
		print("$_VERSION_" . "\n");
		exit 0
	}elsif($ARGV[0] =~ /^(--quiet|-q)$/){
		$TO_QUIET = "--quiet"
	}elsif($ARGV[0] =~ /^(--update|-U)$/){
		$UPDATE = "True"
	}elsif($ARGV[0] =~ /^(--logfile|-l)$/){
		shift(@ARGV);
		$APT_LOGFILE = $ARGV[0];

		unless(-f $APT_LOGFILE && -r $APT_LOGFILE){
			FAIL(1, __LINE__, "Unable to find or read APT's logfile.")
		}
	}elsif($ARGV[0] =~ /^--autoremove$/){
		$TO_AUTOREMOVE = "--autoremove"
	}elsif($ARGV[0] =~ /^--view$/){
		$VIEW_LOGFILE = "True"
	}elsif($ARGV[0] =~ /^--assume-yes$/){
		$TO_ASSUME = "--assume-yes"
	}elsif($ARGV[0] =~ /^--assume-no$/){
		$TO_ASSUME = "--assume-no"
	}elsif($ARGV[0] =~ /^--purge$/){
		$TO_PURGE = "--purge"
	}elsif($ARGV[0] =~ /^(--date|-d)$/){
		shift(@ARGV);

		if($ARGV[0] =~ /^[0-9]+-[0-9]+-[0-9]+$/){
			$FILTADATE = $ARGV[0]
		}else{
			FAIL(1, __LINE__, "Invalid date specified.")
		}
	}elsif($ARGV[0] =~ /^(--time|-t)$/){
		shift(@ARGV);

		if($ARGV[0] =~ /^[0-9]+:[0-9]+:[0-9]+$/){
			$FILTATIME = $ARGV[0]
		}else{
			FAIL(1, __LINE__, "Invalid time specified.")
		}
	}elsif($ARGV[0] =~ /^(--count|-c)$/){
		shift(@ARGV);

		if($ARGV[0] =~ /^[0-9]+$/){
			$TIMES_TO_EXEC = $ARGV[0]
		}else{
			FAIL(1, __LINE__, "Invalid count specified.")
		}
	}elsif($ARGV[0] =~ /^(--simulate|-s)$/){
		$TO_SIMULATE = "--simulate"; $TO_ROOT = "False"
	}elsif($ARGV[0] =~ /^--output-only:(desc|list|col)/){
		$OUTPUT_ONLY = "True";
		$TO_ROOT = "False"; #TODO - Already the default, but just in-case?
		$OUTPUT_FORMAT = substr($ARGV[0], 14)
	}else{
		FAIL(1, __LINE__, "Incorrect argument(s) given")
	}

	shift(@ARGV)
}

if($UPDATE eq "True"){
	use LWP::Simple;

	my $LATEST = get($VERSION_URL);

	#TODO - Ridiculous approach. Find a better way.
	my $LATEST_CAT = join("", split('-', $LATEST));
	my $VERSION_CAT = join("", split('-', $_VERSION_));

	if($LATEST_CAT =~ /^[0-9]{8}$/){
		if($LATEST_CAT > $VERSION_CAT){
			print(
				"New version available:    $LATEST" .
				"Current version:          $_VERSION_\n"
			)
		}
	}else{
		FAIL(1, __LINE__, "Failed to check for available updates.")
	}

	exit 0
}

if($VIEW_LOGFILE eq "True"){
	#TODO - Need a better approach than system().
	system(qq{less "$APT_LOGFILE"});
	exit 0
}

#TODO - Have a UID numeric check, instead of the less reliable LOGNAME.
if($TO_ROOT ne "False" && $ENV{LOGNAME} ne "root"){
	FAIL(1, __LINE__, "Root access is required.")
}

open(my $FH, '<', $APT_LOGFILE);
my @DATA = <$FH>;
close($FH);

# This loop is an improvement over the shell version; it's more concise.
my $INSTALLWC = 0;
my @INSTALL_ONLY_LINES;
foreach (@DATA){
	# Put only the install lines into the above array.
	if($_ =~ /^Install:/){
		push(@INSTALL_ONLY_LINES, $_);
		$INSTALLWC += 1
	}

	shift(@_)
}

if($TIMES_TO_EXEC > $INSTALLWC){
	FAIL(1, __LINE__, "Cannot undo greater than the available $INSTALLWC time(s).")
}

my @INSTALLED_PKGS;
if($FILTADATE && $FILTATIME){
	my $SEEN_DATE = "False";
	my $COUNT = 0;
	my @LINE;

	foreach my $BUFFER (@DATA){
		if(length($BUFFER) <= 1){next}
		@LINE = split(" ", $BUFFER);

		if($LINE[0] eq "Start-Date:"){
			if($LINE[1] eq $FILTADATE && $LINE[2] eq $FILTATIME){
				$SEEN_DATE = "True";
				$COUNT = 0
			}
		}

		if($SEEN_DATE eq "True"){$COUNT += 1}

		#TODO - See if this $COUNT default set is even needed.
		$COUNT //= 5; # Mimics the shell: ${COUNT:-5}
		if($COUNT == 4 && $LINE[0] eq "Install:"){
			foreach my $WORD (@LINE){
				unless($WORD =~ /^(Install:|.*[\(\)].*)/){
					push(@INSTALLED_PKGS, $WORD);
				}
			}

			last
		}
	}

	if(not @INSTALLED_PKGS){
		FAIL(1, __LINE__, "Invalid --time and/or --date specified.")
	}
}elsif(not($FILTADATE && $FILTATIME) and ($FILTADATE || $FILTATIME)){
	FAIL(1, __LINE__, "Flags --date and --time must be used together.")
}else{
	my $DESIRED_INDICES = $INSTALLWC - $TIMES_TO_EXEC;
	foreach my $INDEX ($DESIRED_INDICES..$INSTALLWC){
		if($INSTALL_ONLY_LINES[$INDEX]){ # <-- Avoids empty line errors.
			foreach my $WORD (split(" ", $INSTALL_ONLY_LINES[$INDEX])){
				if($WORD !~ /^(Install:|.*[\)\(].*|automatic)$/){
					push(@INSTALLED_PKGS, $WORD)
				}
			}
		}
	}
}

if($OUTPUT_ONLY ne "True"){
	#TODO - Temporary?
	system(
		qq{/usr/bin/apt-get $TO_QUIET $TO_SIMULATE $TO_ASSUME remove } .
		qq{$TO_PURGE $TO_AUTOREMOVE -o Dpkg::Progress-Fancy=true -o } .
		qq{Dpkg::Progress=true @INSTALLED_PKGS}
	)
}else{
	if($OUTPUT_FORMAT =~ /^desc$/){
		use AptPkg::Cache;

		my $CACHE = AptPkg::Cache->new();
		my $DESCS = $CACHE->packages("DescriptionList");
		foreach(@INSTALLED_PKGS){
			my $GETS = $CACHE->get("$_");
			my $NAME = $GETS->{"FullName"};
			my $DESC = $DESCS->lookup("$_")->{"ShortDesc"};
			printf("%s - %s\n", $NAME, $DESC)
		}
	}elsif($OUTPUT_FORMAT =~ /^col$/){
		#TODO - Temporary.
		system(qq{printf "%s\n" @INSTALLED_PKGS | /usr/bin/column})
	}elsif($OUTPUT_FORMAT =~ /^list$/){
		foreach(@INSTALLED_PKGS){
			print("$_\n")
		}
	}
}
