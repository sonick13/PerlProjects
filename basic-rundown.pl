#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/basic-rundown.pl
# Started On        - Wed 17 Apr 11:55:55 BST 2019
# Last Change       - Mon 22 Apr 18:14:46 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Initial Notes: In Perl, much like C, a semi-colon is syntactically necessary at
#                the end of each line, with few exceptions, as you'll see below.
#
#                A common extension for Perl scripts is '.pl'. VIM picks Perl
#                scripts up as type 'perl', not too surprisingly.
#----------------------------------------------------------------------------------

# The former is for catching and stopping at certain errors. The latter merely
# warns of certain errors, but proccesses the code none-the-less. Recommended.
# These seem very useful until experienced enough, but even then, worth using?
use strict;
use warnings;

printf("Using printf(), like in many other languages.\n");
printf("The addition of 1 and 4 is equal to %d.\n", 1 + 4);
printf("\n");

print("Using print(). Seems to be a basic version of printf().\n");
printf("\n");

printf("Let's concatenate words %s and %s, using printf().\n", "one", "two");
print("Now, as above, but using print() and '.': " . "One " . "two.\n");
printf("\n");

# The use command is like import in Python.
use feature "say";
say("Using say(), which is like the shell echo; it includes newline.");
say("Say() needs: use feature \"say\".");
printf("\n");

# Setting a variable in Perl. The dollar sign is used to declaring and for calling.
$A = "true";
# Alternatively, prefix the above, as below, but it may only work locally.
my $A = "true";

# If statements in Perl go by 'if(condition){commands};'; they can be one-lined, -
# as in shell and python. You don't need spacing between {}, unlike in shell. The
# use of ($A) is like [ 1 ] in shell; the value is true because there's a value.
if($A){print("This one-line if statement is true, because \$A is.\n")};
# This would be false because there is no value.
#if($A){print("true\n")};

# This would be a traditional if block. In place of '==', either '=' or 'eq' can
# also be used, but I imagine, like shell, 'eq' is for integer comparison.
if($A == "true"){
	# Using qq{} is like '' to avoid having to escape double-quotes. Using q{}
	# works the other way around.
	print(qq{Logic dictates that A is equal to string, "true."\n});
} elsif($A eq "false"){
	print("Logic has failed me.\n");
} else {
	print("I don't know.\n");
};

printf("\nUsing substr(\$A, 1, 2), \$A is %s.\n", substr($A, 1, 2));

# Seems rand() only generates floating numbers up to the provided integer. Doesn't
# look like you can set a range, or if you can, I have no idea how. I put this
# through printf so I could format it how I like.
printf("Can also generate random numbers with rand(), like %.1f.\n\n", rand(1));

print <<EOF;
	A heredoc, as in shell. Very similar syntax, but sadly
	the use of '-' to ignore tabs doesn't work in Perl.
	I'm sure there's another way though.\n
EOF

print("Interestingly, the EOF doesn't need a suffixed semi-colon.\n");

# Define a function, which I'm guessing is called a subroutine in Perl.
sub up(){
	print("The 'up' function (sub) was called.\n\n");
};

# Call the function like this.
up();

# Open and output the contents of the given file. The < is read, > is write, >> is
# append. The encoding part is pretty self-explanatory, but apparently optional.
open(my $file, '<:encoding(UTF-8)', '/proc/uptime');
print("This is the contents of /proc/uptime: " . <$file> . "\n");

# In-case the file isn't found or otherwise unable to be opened, you can use 'or'
# logic operator with 'die', which means kill the program and output the given
# error message, suffixed with 'at FILE line NUM'. Here, I'm just printing.
open(my $file, '<:encoding(UTF-8)', '/proc/nofile') or print("File not found\n");

# Similar to die, warn() outputs the same, but without exiting.
warn "Demonstrational error detected"

# Declaring a variable array. @ is used only with declaration. Using my() is proper
# form, but depends on the situation. It's a 'scope' thing, like local or not.
my(@array = ("Bob", "Tim", "Tom"));

# Here, I'm using the first index of the variable array.
printf("The name I want is at index 0 (first): %s\n", $array[0]);

@string = qw/This is string split by whitespace into an array./;
print("I want the 2nd index (1) of \$string: $string[1]\n");

# Read from standard input, which works with pipes in shell. Pipe something into
# this Perl script to then output what went in. Commented out though, because it
# for some reason breaks the below code.
#print(<STDIN> . "\n");

# Create a directory in the CWD. As it is, it seems to follow your umask. This is
# also a basic example of grabbing user input via STDIN.
print("Create a test directory? ");
my $answer = <STDIN>;
if($answer =~ m{^[yY]{1}$}){
	mkdir("Directory_Name");
	print("Directory created.\n");

	# Now to demonstrate removing a directory, via user prompting.
	print("Remove created directory? ");
	my $answer = <STDIN>;
	if($answer =~ m{^[yY]{1}$}){
		rmdir("Directory_Name");
		print("Directory removed.\n");
	}elsif($answer =~ m{^[nN]{1}$}){
		print("Not removing directory.\n");
	}else{
		# Output error message, with extra info, then exit.
		die "Incorrect response";
	};
}elsif($answer =~ m{^[nN]{1}$}){
	print("Not creating directory.\n");
}else{
	# Output error message, with extra info, then exit.
	die "Incorrect response";
};

printf("\n");

# Assign a value to $string, then print it with all upper- then lowercase.
$string = "Test String.";
printf(qq{Uppercase: "%s"\nLowercase: "%s"\n\n}, uc($string), lc($string));

# Grabbing and storing STDOUT from a shell command is incredibly easy in Perl.
# Also, since the newline character is included in the grabbed output, you needn't
# append it to the print() function.
$output = readpipe('/bin/ls $HOME');
print($output);

# Renaming a file is also stupidly easy in Perl. Commented out, as it just shows
# the expected syntax. I imagine it works for directories, too.
#rename('OLD', 'NAME')

# String substitition is simple enough in Perl.
$string = "This is a test.";
say(s/a test\./cool./);

# Change the CWD. I get a message saying this is deprecated. No clue what to use.
chdir("$HOME");

# Create and open a new file in the CWD, overwriting existing one, then close it.
#open(my $file, '>', 'filename_test.tmp')
#close("$file");

# Open and append to given filename, then close it.
#open(file, '>>filename_test.tmp');
#close("$file");

# Pipe file contents into the STDIN of supplied shell command or program. Doesn't
# seem to create an actual file. Perhaps this mimics a simple pipe, allowing you to
# choose what is piped into the given program.
open(file, '| /bin/grep "1"');
# This does as above, but the other way around.
open(file, '/bin/ls |');
# To demonstrate:
print(<file>);
close("$file");
# It seems to closely replicate readpipe(), but I think this is better, as it will
# leave the 'file' open (until closed), making for easy processing, without having
# to explicitly set a variable with the contents of readpipe().

# Consise example of the above approach to getting output from shell command into
# a Perl script. This is a one-liner.
open(file, "/usr/bin/uptime |") or die "File not found";
@A = split(" ", <file>);
say($A[0]);
close("$file");

# The stat() function, much like in Python, shell, and likely C, allows you to get
# various important values related to files, such as their UID. However, stat() is
# a list (like in Python), so, lists must be contained in parentheses and to call
# a specific index within that list, you'd use syntax similar to calling an index
# in a variable array, like shell. [4] is UID, [5] is GID. There are 13 in total, -
# but seem to be platform-dependent. In Linux, in order, they are as follows:
#
# dev, ino, mode, nlink, uid, gid, rdev, size, atime, mtime, ctime, blksize, blocks
printf("The UID of /home is: %d\n", (stat("/home"))[4]);

# Like in Python, you can straight-out execute a program, as if by shell. This also
# demonstrates using special file testing flags. In this case, -e, like in shell, -
# is testing with the following file exists. The rest of the flags are pretty much
# as they are in shell.
#
# -e exists, -f is file, -r is readable, -x is executable, -w is writable
# -z file is empty, -d file is directory, -S is socket, -p is named pipe
# -c character special file, -b block special file, -k file has sticky bit set
# -B file is binary, -s file isn't empty
if(-e "/usr/bin/firefox"){
	print("Run /usr/bin/firefox? ");
	$answer = <STDIN>;
	if($answer =~ m{^[yY]$}){
		system("/usr/bin/firefox") or die "Failed to load Firefox";
		say("Firefox launched.");
	};
};

# This variable array stores arguments handed to the Perl script, akin to $@. It
# must be uppercase; that is not a typo. Remember, @ when declaring an array, $
# when calling for its contents, unless it needs to be processed as an array, such
# as with shift(). Array elements can still be isolated via [x] syntax.
print("$ARGV\n");

# Logical operators to compare operands in, for example, an if statement, are not
# as they are in shell programming. For example '==' will NOT compare strings. You
# have to use '=' to compare strings in Perl. Even lt, eq, and gt can be used, for
# string comparisons.

# If the first index within the builtin ARGV variable array detects the REGEX match
# within the '/'s, then proceed to say "Help". The =~ is apparently a substr test.
if($ARGV[0] =~ /^(--help|-h|-\?)$/){ say "Help"; };

# For loop syntax in Perl:
for my $VAR ("list", "to", "iterative", "over"){
	say "Command(s) to execute per list item.";
};

# The syntax for associative arrays (variable arrays with named keys, not numbered
# indices) in Perl is as follows. This also shows a very useful associative array
# built into Perl, which holds environment variables.
say "$ENV{"USER"}";

# This is effectively like the shell while read loop, but easier to read.
# $line resembles each line from the file, as with the default of $REPLY in
# a shell while read loop. While each line is true, effectively, continue
# through the loop, until there's nothing left.
open(my $file, '<', '/proc/uptime');
while(my $line = <$file>){ say "$line"; };

# Causes Perl to 'die' if a file is unable to be read from or written to.
use autodie;

# As with shell, variable names may be wrapped in braces to protect them from
# neighbouring characters being interpreted as part of the variable name. But, -
# as shown here, the environment variable doesn't get expanded and so USER is
# printed. Special exception?
print("USER:$ENV{'USER'}!\n");

# All output within the select psuedo-block (up until close) is written to the
# provided file. Created if doesn't exist. Not appended. It looks like the file
# MUST be closed afterwards, otherwise you risk doing all sorts to the file.
open(my $FH, ">:encoding(UTF-8)", "$HOME/Desktop/new_file.txt");
select $FH;
	print("test\n");
close("$FH");

# Hashes in Perl are basically associative arrays. This is how to assign a hash:
my %hash = (value1=>"green", value2=>"blue", value3=>"red");

# Demonstration of writing print's contents to a specified Filehandle. For some
# reason, print() understands these two as separate arguments (?) without actually
# separating them as such, with commas; weird.
open($FH, ">", "./file_test_1232.txt");
print($FH "This works!\n");
close($FH)
