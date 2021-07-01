#!/bin/bash

#########################################################################

# This first method of using an if conditional just uses the exit code of
# commands. It is simple, but you will have to manually silence output of
# statements in the conditionals.

myvar="/home/"

# Note the below syntax of &> is only supported in bash 4+.  See the first elif
# for the more portable method.
if ls someFakeDir &> /dev/null; then
    echo "hmmm";
elif ls $myvar > /dev/null 2>&1; then
    echo "$myvar exists";
# Note $0 is the name of the "first" arg, which is the name of this script
elif grep -q "first method" $0; then
    echo "Grepped myself"
else
    echo "*shrug*";
fi


#########################################################################

# This next method uses 'test' (i.e. single brackets). Fun fact, [ is valid sh
# command (try `which [`).  You can either use `test EXPRESSION` or
# `[ EXPRESSION ]` (see man test).

# TODO


#########################################################################

# The final method for if uses double brackets, which is more powerful than the
# previous `test` method, but is not as portable (i.e. not POSIX).  Will not
# work on `sh`.

# TODO


#########################################################################

# TODO - case statements
