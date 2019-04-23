#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/Testing_AptPkg.pl
# Started On        - Tue 23 Apr 14:52:56 BST 2019
# Last Change       - Tue 23 Apr 17:16:19 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Experimenting and learning this module. If you see some grave errors in the code
# or explanations, please feel free to correct me.
#----------------------------------------------------------------------------------

use strict;
use warnings;
use AptPkg::Cache;
use feature 'say';

# The '{}' indicates it's a hash reference, and can standalone, right after '->'. I
# think '->' indicates a method (or object?), whereas '::' indicates a class.
#
# Using this over and over again, with a different hash would, I think, be
# terrible, because a new object would be created each and every time; it would
# probably a serious memory-hog.
#say("NAME:     " . AptPkg::Cache->new->get("vim")->{"FullName"});

# This is why a variable (scaler?) should be set and used as an object. If you need
# to reuse an object, create a variable assigned to it.
my $CACHE = AptPkg::Cache->new();
say("PACKAGE NAME:        " . $CACHE->get("vim")->{"FullName"});
say("CURRENT STATE:       " . $CACHE->get("vim")->{"CurrentState"});

my $DESCRIBE = AptPkg::Cache->new->packages("DescriptionList");

# I was confused about the documentation (perldoc) and what on Earth you're meant
# to do with the above assigned object. This command told me what it was referring
# to and so I needed only to look up: perldoc AptPkg::PkgRecords
#print ref($REF);

# This isn't necessary, but it is self-demonstrating.
my $KEYS = $DESCRIBE->lookup("vim");

say("MAINTAINER:          " . $KEYS->{"Maintainer"});
say("FILE PATH:           " . $KEYS->{"FileName"});
say("MD5 HASH:            " . $KEYS->{"MD5Hash"});
say("DESCRIPTION:         " . $KEYS->{"LongDesc"});
