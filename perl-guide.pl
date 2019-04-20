#!/usr/bin/perl

#----------------------------------------------------------------------------------
# Project Name      - perlmisc/perl-guide.pl
# Started On        - Sat 20 Apr 13:07:54 BST 2019
# Last Change       - Sat 20 Apr 15:54:12 BST 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------
# I'm following the YouTuber 'The Bad Tutorials' who has a series of Perl
# tutorials. In this script, I'll be documenting, taking notes, and showing
# examples of what I learn from the series of videos, plus other things.
#
# This script is good to both execute and read.
#----------------------------------------------------------------------------------

use strict;
use warnings;

print("Perl Tutorial - 2 - Comments & Quotes\n");
print("-------------------------------------\n");
print(split("\t", qq{
	He talks about quotation. Like in many languages, '' (single-quotes) is literal, -
	meaning that escape sequences and variables will not be expanded, only shown
	literally.

	However, "" (double-quotes) will allow such expansion.
\n}));

print("Perl Tutorial - 3 - Escape Sequences\n");
print("------------------------------------\n");

print(split("\t", qq{
	In Perl, there are some awesome escape sequences I've yet to ever see in shell. For
	example, you can use an escape sequence to convert the following character (letter)
	to upper- or lowercase, depending on whether you use \\u or \\l, respectively.
\n}));

print("\t" . 'print("\tThis is some random text.\n");' . "\n");
print("\t>>> This is some random text.\n\n");

print("\t" . 'print("\t\lThis is \uso\ume random t\uext.\n");' . "\n");
print("\t>>> \lThis is \uso\ume random t\uext.\n");

print(split("\t", qq{
	As in shell, you can use the \\a escape sequence to sound the X11 bell, and will
	probably also sound some sort of 'bell' in M\$ Windows. You should have heard a
	bell now, if it's enabled and available on your system.

	You should see no output, or potentially only a caret (^).
\n}));

print("\t" . 'print("\a");' . "\n");
print("\t>>> \a\n\n");

print("Perl Tutorial - 4 - Scalar Variables\n");
print("------------------------------------\n");

print(split("\t", qq{
	Perl has something called 'scaler variables', as well as associate variable arrays
	and standard variables arrays.

	It looks like the syntax for setting a variable can be both:
\n}));

print("\t" . '$rank=1' . "\n");
print("\t" . '$rank = 1' . "\n");

print(split("\t", qq{
	Whereas in shell, this is strictly NAME=DATA. Perl seems more flexible in this way.
\n}));

print("Perl Tutorial - 5 - Arrays\n");
print("--------------------------\n");

print(split("\t", qq{
	In Perl, variable arrays are assigned by using \@NAME instead of \$NAME.
\n}));

print("\t" . '@ranks=(1,2,3);' . "\n");

print(split("\t", qq{
	In the above example, a variable array with 3 indices of integers 1, 2, and 3 is
	declared. However, I believe the preferable and proper way to write this is:
\n}));

print("\t" . 'my @ranks = (1, 2, 3);' . "\n");
my @ranks = (1, 2, 3);

print(split("\t", qq{
	As in shell, the first index in a variable array is 0. To call for a certain index
	in a variable array, you would do as follows:
\n}));

print("\t" . 'print("Value in the first index of variable array is $ranks[1].\n");' . "\n");
print("\t" . '>>> ' . "Value in the first index of variable array is $ranks[1]." . "\n");

print(split("\t", qq{
	Notice how \$ was used when calling the variable, instead of \@? This seems to be a
	quirk of Perl, in that you sometimes need only use \@ (when calling) if you're to
	process it as a variable array, not just calling it to, for example, print out.

	An example of when you need to use \@ when calling a variable array:
\n}));

print("\t" . 'shift(@ARGV);' . "\n");

print(split("\t", qq{
ARGV is a special variable array built into Perl, which stores the arguments given
to the Perl program. The shift() function just shifts the positioning of the
indices, much like the bash builtin, shift.
\n}));

print("Perl Tutorial - 6 - Array Operations\n");
print("------------------------------------\n");

print(split("\t", qq{
	He talks about sequential data in this video. If you're familiar with shell, as I
	am, you'll know of bash brace expansion. Rather than inconveniently typing out
	numbers 1 to 10, you can have shell do the work for you, using braces.

	Perl allows for the same functionalty, but instead of braces, it's parentheses:

	For example:
\n}));

print("\t" . 'my @ranks = (1..10);' . "\n");
print("\t" . 'print("Numbers 1-10 are as follows: @ranks\n");' . "\n");
@ranks = (1..10);
print("\t>>> Numbers 1-10 are as follows: @ranks\n");

print(split("\t", qq{
	The same approach can be done with the alphabet, from A-Z, using (A..Z).

	If you want to know the length of a variable array, one approach is to assign a
	scaler variable the value of the variable array. This doesn't look to be possible
	on-the-fly, without first making the assignment.

	Here is an example:
\n}));

print("\t" . 'my @alpha = (\'A\'..\'Z\');' . "\n");
print("\t" . 'print("@alpha\n");' . "\n");
my @alpha = ('A'..'Z');
print("\t>>> @alpha\n");

print(split("\t", qq{
	However, in the above example, you'll notice one, big difference. A and Z are
	quoted to keep strict happy. I couldn't tell you why, but it looks to be required.

	One useful thing you can do in Perl, is to reassign \@array as a scaler variable.
	This allows you to mimic the length() functions, in this case.

	For example, if I now reassign then then print the above variable array:
\n}));

print("\t" . '$alpha_scaler = @alpha;' . "\n");
print("\t" . 'print("$alpha_scaler\n");' . "\n");
my $alpha_scaler = @alpha;
print("\t>>> $alpha_scaler\n\n");

print(split("\t", qq{
	This can be achieved in a much easier way, of course, much like in shell:
\n}));

print("\t" . 'print("$#alpha\n");' . "\n");
print("\t>>> $#alpha\n\n");

print(split("\t", qq{
	The drawback here, is that the use of # only shows 25, instead of 26, which is
	because there are 25 indices, beginner with 0, not 1. If you're basically looking
	for a human-readable number, you'd want to add 1 to it in-place.

	For example:
\n}));

print("\t" . 'printf("%d\n", $#alpha + 1);' . "\n");
printf("\t>>> %d\n\n", $#alpha + 1);

print(split("\t", qq{
	Instead of using ' + 1', you can actually use an incremental, for the same result:
\n}));

print("\t" . 'printf("%d\n", ++$#alpha);' . "\n\n");

print(split("\t", qq{
Note that the ++ is placed before the variable, not after. After merely sets it, -
but will not output the new value after it's set; prepending the ++ does both.
\n}));

print("Perl Tutorial - 7 - Adding & Removing Array Elements\n");
print("----------------------------------------------------\n");

print(split("\t", qq{
	Variable arrays can be manipulated in various ways in Perl. In this video, he talks
	about a few operations which can be done.

	He begins with the assignment, and printing out the contents of the new array.
\n}));

print("\t" . 'my @players = ("Roger, "Andy");' . "\n");
print("\t" . 'print("@players\n");' . "\n");
my @players = ('Roger', "Andy");
print("\t>>> @players\n");

print(split("\t", qq{
	At some point, you will probably want to add an index to a variable array. This can
	be done with the built-in push() function, as follows:
\n}));

print("\t" . 'push(@players, "Rafa");' . "\n");
print("\t" . 'print("@players\n");' . "\n");
push(@players, "Rafa");
print("\t>>> @players\n");

print(split("\t", qq{
	Notice how the array needn't have been reassigned? It was merely modified. It's
	also important to note that push() effectively amends the value, not prepends.

	The push() functions takes two arguments: the first is the array into which a value
	is to be inserted, and the second argument is the value itself of the new index.

	To prepend, you'd use the unshift() function, with the same syntax:
\n}));

print("\t" . 'unshift(@players, "Novak");' . "\n");
print("\t" . 'print("@players\n");' . "\n");
unshift(@players, "Novak");
print("\t>>> @players\n");

print(split("\t", qq{
In contrast to unshift() and push(), there's also the pop() and shift() functions.

The pop() function will remove an index from the end:
\n}));

print("\t" . 'pop(@players);' . "\n");
pop(@players);
print("\t>>> @players\n");

print(split("\t", qq{
Whereas shift() will remove an index from the beginning, like the shift bultin
available in shell, leaving us with the original \@players array:
\n}));

print("\t" . 'shift(@players);' . "\n");
shift(@players);
print("\t>>> @players\n");

print(split("\t", qq{
Both of these functions take only the one argument, which is the variable array.
\n}));

print("Perl Tutorial - 8 - Slicing Arrays\n");
print("----------------------------------\n");

print(split("\t", qq{
Array slicing seems to be what has already been covered in this script. The use of
the brackets wrapped around one or more comma-separated integers suffixed to a
variable array call, simply calls for chosen indices.

For example:
\n}));

print("\t" . 'my @months = ("Jan", "Feb", "Mar", "Apr");' . "\n");
print("\t" . 'print("@months[0,3]\n");' . "\n");
my @months = ("Jan", "Feb", "Mar", "Apr");
print("\t>>> @months[0,3]\n");

print(split("\t", qq{
As you can see, only the first and last indices were printed; sliced.

You can also provide a range of indices:
\n}));

print("\t" . 'print("@months[0..3]\n");' . "\n");
print("\t>>> @months[1..3]\n");

print(split("\t", qq{
Only the first to last indices are printed.
\n}));

print("Perl Tutorial - 9 - Replacing Array Elements\n");
print("--------------------------------------------\n");

print(split("\t", qq{
...
\n}));
