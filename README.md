This is a repo of my dotfiles, which are kept fairly minimal. In the spirit of being able to quickly and efficiently work on different systems without getting too reliant on custom configs and tools, the only dependencies and tools used or referenced in this repo are ones that can be obtained from the current `stable` Debian repo. Additionally, `vim` and `tmux` are kept minimal with no plugins, and not too many crazy key bindings.

Below, I'll also have various notes of tips and tricks for more efficiently working in the (bash) shell.

### bash/command tips

* `$!` - previous command's exit code
* `$$` - current PID
* `$0` - 0th arg of the current process (i.e. name of shell being used, or name of calling script, ...)
* `!!` - repeat previous command (useful if you forgot to `sudo`)
* `less -R` - keeps color
* GNU Readline (aka emacs style) shortcuts
  * `Alt-b` - move cursor back one word
  * `Alt-f` - move cursor forward one word
  * `Ctrl-a` - move cursor to beginning of line
  * `Ctrl-e` - move cursor to end of line
  * `Ctrl-u` - delete from cursor to start of line
  * `Ctrl-k` - delete from cursor to end of line
  * `Alt-d` - delete to the next word
  * `Ctrl-r` - reverse command history search
  * `Ctrl-l` - clear screen
* `find`
  * `find . -name "blah*.txt"` - search for matching filename in current dir
  * `find . -iname "blah*"` - same as before, but case insensitive
  * `find . -type f -iname "blah*"` - similar to before, but only matching *regular files* (similar flags for dirs, sockets, symlinks, etc.)
  * `find . -type f -iname "blah*" -exec wc --lines {} \;` - execute a command on each match
* `df -h --total -T` - print info space taken up by mounted file systems
* `du -sh * | sort -h` - print total disk usage of current directory files and subdirs, sorted
* `du -h -d1 | sort -h` - print total disk usage of depth-1 directories, sorted

### Git tips

* Install git hooks in specific repos to auto `ctags -R .` on new commits, pulls, checkouts, etc. (note this can be time consuming for large repos)

### Tools in Debian `stable` I typically install and use

* `vim`
* `tmux`
  * `tmux new -s MySessionName` will create a named session
  * `tmux ls` for listing sessions
  * `<prefix>-d` will detatch from session
  * `tmux attach -t MySessionName` will attach to the session. If no name or number provided, defaults to most recently used session
  * Use `-t` for grouped sessions, which is useful for multi monitor setups. For example, if a session `MySess` exists and you want another "view" into it in your other monitor that can independently view windows, start a new session with `tmux new -s OtherSess -t MySess`. This actually creates a new group `MySess` based on the session `MySess`.
* `ag` - like `grep` but much faster, and excellent for codebases (package name is `silversearcher-ag`)
* `tldr` - using `tldr <command>` gives you several examples of command usage
  * Also can visit https://tldr.sh
  * Note the `tldr` client may need to initially connect to a github repo to download the db
* `fzf` (*note* - autocompletion via `**` does not appear to be in version on Debian stable at the moment)
  * By default, outputs selected matches to stdout. You can do `fzf | xargs ls -l` for example, and use tab/shift-tab to select multiple matches
  * `ctrl-j` and `ctrl-k` move cursor up and down
  * Quick `cd` by doing `cd **<TAB>` if autocomplete enabled. Or, if just keybindings enabled, simply do `alt-c`.
  * If keybindings enabled, `ctrl-t` is a shortcut for pasting selected dir/files on command line (I find this quicker than autocomplete with `**`)
  * Autocomplete works with `ssh **<TAB>`
  * `kill <TAB>` to search pids to send signal to
  * `ctrl-r` is much nicer with key bindings enabled
  * Can pipe *into* fzf to search, say, history like `history | fzf`
  * Can take action on fzf match like ``wc --lines `fzf` `` (or, easier with autocomplete as `wc --lines **<TAB>`
  * For exact matches, either do `fzf -e` or prefix your search with `'`
  * Exclude matches with `!mystring`
  * Use `^` and `$` for beginning/end, such as `readme .md$`
  * There is a way to add a preview-window keybinding as well
  * There is also a way to use, say `ag` instead of `find` under the hood
* `locate` and `updatedb`
  * First `sudo updatedb` to build an index of your file system, then `locate my*pattern` to *very* quickly find them!
  * Much faster than `find`, `fzf`, etc. but requires periodic updating of the db
* `http` (package name is `httpie`)
  * Much nicer inspection into HTTP requests and responses, and easier usage than tools like curl
  * `http google.com --print=HB` will show the request headers and body. Likewise, using `hb` will show the response headers and body
* Heredoc example [here](bash_examples/heredoc.sh)
* Bash conditional examples [here](bash_examples/conditionals.sh)

### Tools making their way through Debian `testing`

* `bat` - a better `cat` (available in Ubuntu repos)

### TODO: tools/things yet to look into:

* Examples of loops (for i...print $i...), conditionals, `seq`, xargs
* better xclip usage, and perhaps an alias like `clip` to pipe things into
* alias for notify-send to do things like `my long running process && aliasname`
* rsync
* parallel
* tcpdump
