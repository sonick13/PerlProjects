#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/basic-rundown.pl
# Started On        - Wed 17 Apr 11:55:55 BST 2019
# Last Change       - Wed 17 Apr 16:25:46 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# Initial Notes: In Perl, much like C, a semi-colon is syntactically necessary at
#                the end of each line, with few exceptions, as you'll see below.
#
#                A common extension for Perl scripts is '.pl'. VIM picks Perl
#                scripts up as type 'perl', not too surprisingly.
#----------------------------------------------------------------------------------

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
say("Using say(), which is like the shell echo.");
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

# Open and output the contents of the given file.
open($file, '/proc/uptime');
print("This is the contents of /proc/uptime: " . <$file> . "\n");

# In-case the file isn't found or otherwise unable to be opened, you can use 'or'
# logic operator with 'die', which means kill the program and output the given
# error message, suffixed with 'at FILE line NUM'. Here, I'm just printing.
open($file, '/proc/nofile') or print("File not found\n");

# Declaring a variable array. @ is used only with declaration.
@array = ("Bob", "Tim", "Tom");

# Here, I'm using the first index of the variable array.
printf("The name I want is at index 0 (first): %s\n", $array[0]);

@string = qw/This is string split by whitespace into an array./;
print("I want the 2nd index (1) of \$string: $string[1]\n");

# Create a directory in the CWD. As it is, it seems to follow your umask. This is
# also a basic example of grabbing user input via STDIN.
print("Create a test directory? ");
$answer = <STDIN>;
if($answer =~ m{^[yY]{1}$}){
	mkdir("Directory_Name");
	print("Directory created.\n");

	# Now to demonstrate removing a directory, via user prompting.
	print("Remove created directory? ");
	$answer = <STDIN>;
	if($answer =~ m{^[yY]{1}$}){
		rmdir("Directory_Name");
		print("Directory removed.\n");
	}elsif($answer =~ m{^[nN]{1}$}){
		print("Not removing directory.\n");
	}else{
		# Output error message, with extra info, then exit.
		die "Incorrect response.\n";
	};
}elsif($answer =~ m{^[nN]{1}$}){
	print("Not creating directory.\n");
}else{
	# Output error message, with extra info, then exit.
	die "Incorrect response.\n";
};

printf("\n");

# Assign a value to $string, then print it with all upper- then lowercase.
$string = "Test String.";
printf(qq{Uppercase: "%s"\nLowercase: "%s"\n\n}, uc($string), lc($string));
