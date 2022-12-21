#!/bin/bash

myvar=12

echo "[+] Making file based on heredoc..."

# Below is the heredoc usage. Heredocs essentially allow for a "file" to be
# created in a script without needing to reside on disk.  This example is a
# little strange though, given it *does* write it out to a file. But, this can
# be used to pass a "file" to a function, another script, some other command,
# etc.

# The << EOF signals a heredoc begins on the following line, and will end when
# the EOF literal is reached (this can be any string as a delimeter). The added
# dash to <<- EOF makes the heredoc ignore any leading whitespace (for example,
# if this nested in some conditional).

# In this example, I'm redirecting the result (the cat'd "file") to a new file
# on disk, but this doesn't need to be here (or, could be piped to something
# else)

cat <<- EOF > mynewfile.json
{
    "key1": "cool",
    "somenum": $myvar
}
EOF

echo "[+] Done"
