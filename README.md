This is a repo of my dotfiles, which are kept fairly minimal. In the spirit of being able to quickly and efficiently work on different systems without getting too reliant on custom configs and tools, the only dependencies and tools used or referenced in this repo are ones that can be obtained from the current `stable` Debian repo. Additionally, `vim` and `tmux` are kept minimal with no plugins, and not too many crazy key bindings.

Below, I'll also have various notes of tips and tricks for more efficiently working in the (bash) shell.

## bash/command tips

* If editing a long command and readline is still using the default emacs bindings, `C-xC-e` will bring you into `$EDITOR` for editing the command!
* `$?` - previous command's exit code
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
* Heredoc example [here](bash_examples/heredoc.sh)
* Bash conditional examples [here](bash_examples/conditionals.sh)

## Git tips

* Install git hooks in specific repos to auto `ctags -R .` on new commits, pulls, checkouts, etc. (note this can be time consuming for large repos)
* `git rebase BRANCH` - rebase your current branch on top of BRANCH
* `git rebase -i HEAD~num` - view previous num commits interactively for squashing, changing commit messages, etc.
* `git reset --hard origin/BRANCH` - forcibly make the state of your current BRANCH match the remote BRANCH (say if you've made terrible changes you want to discard)

## Other tools I typically use

### `vim`
  * When installing `ctags`, be sure to install `ctags-universal` (apt defaults to exuberant, which is no longer maintained)
  * To open the tag under the cursor in a new split, use `CTRL-W ]` (can also search with `:stag funcname` with tab completion)
    * Can also use `CTRL-W f` to do the same thing for filenames, such as include files
  * To open the tag under the cursor in a preview window, use `CTRL-W }` (can also use `:ptag funcname`). Close with `:pclose` or `CTRL-W z`.
  * If an ambiguous tag with multiple options, use `g C-]` to see them all
  * `:psearch funcname` is useful for opening previews of a function from an included header file
  * `*` search forward word under cursor, `#` same but backwards
  * `Ctrl-o` and `Ctrl-i` cycle through `:jumps`, and likewise `g;` and `g,` through `:changes`
  * `Ctrl-y` and `Ctrl-e` scroll without moving cursor
  * `]m` goes to next method (useful for python)
  * `[[` goes to beginning of current function, `][` goes to end. `[{` and `]}` do similar for code blocks.
    * `]]` goes to beginning of next function, `[]` goes to end of previous function
    * `[(` and `])` navigate similarly to the code blocks but for parentheses (can be on one line)
  * When cursor is on a word that might be from an #included file, use `[I` to open its def. `[i` does something similar
  * `gD` will go to definition in current local file only. `gd` will do the same but within the current function.
  * `K` will bring up manpage on current word under cursor.
  * When quickfix window is open (say after using my binding `S` to search word), `CTRL-W <enter>` will open match in new split.
    * Can move splits with `CTRL-W L` (or H, J, K)
    * `:cclose` will close quickfix window
  * `Ctrl-W s` (and likewise for v) will split the window. Can do `:sf FILE` to split and find file, as well as put `:vert` in front of any splitting command to make it vertical split.
  * When using netrw (say via `:Vex`), my bindings have <enter> open in a new window
  * SPACE is mapped to fzf - use `C-x` and `C-v` to open in splits
  * **TODO**: Filtering text to external commands, writing, reading, etc.

### `tmux`
  * `tmux new -s MySessionName` will create a named session
  * `tmux ls` for listing sessions
  * `<prefix>-d` will detatch from session
  * `tmux attach -t MySessionName` will attach to the session. If no name or number provided, defaults to most recently used session
  * Use `-t` for grouped sessions, which is useful for multi monitor setups. For example, if a session `MySess` exists and you want another "view" into it in your other monitor that can independently view windows, start a new session with `tmux new -s OtherSess -t MySess`. This actually creates a new group `MySess` based on the session `MySess`.

### `rg` (package name is `ripgrep`)
  * Like `grep` but much faster, and excellent for codebases

### `tldr`
  * Using `tldr <command>` gives you several examples of command usage
  * Also can visit https://tldr.sh
  * Note the `tldr` client may need to initially connect to a github repo to download the db. `tldr --update` can be used to update the db.

### `fzf`
  * By default, outputs selected matches to stdout. You can do `fzf | xargs ls -l` for example, and use tab/shift-tab to select multiple matches
  * `ctrl-j` and `ctrl-k` move cursor up and down
  * Quick `cd` by doing `cd **<TAB>` if autocomplete enabled. Or, if just keybindings enabled, simply do `alt-c`.
  * If keybindings enabled, `ctrl-t` is a shortcut for pasting selected dir/files on command line (I find this quicker than autocomplete with `**`)
  * Autocomplete works with `ssh **<TAB>`
    * *Note* - autocompletion via `**` does not appear to be in version on Debian stable at the moment...
  * `kill <TAB>` to search pids to send signal to
  * `ctrl-r` is much nicer with key bindings enabled
  * Can pipe *into* fzf to search, say, history like `history | fzf`
  * Can take action on fzf match like ``wc --lines `fzf` `` (or, easier with autocomplete as `wc --lines **<TAB>`
  * For exact matches, either do `fzf -e` or prefix your search with `'`
  * Exclude matches with `!mystring`
  * Use `^` and `$` for beginning/end, such as `readme .md$`
  * There is a way to add a preview-window keybinding as well

### `locate` and `updatedb`
  * First `sudo updatedb` to build an index of your file system, then `locate my*pattern` to *very* quickly find them!
  * Much faster than `find`, `fzf`, etc. but requires periodic updating of the db

### `http` (package name is `httpie`)
  * Much nicer inspection into HTTP requests and responses, and easier usage than tools like curl
  * `http google.com --print=HB` will show the request headers and body. Likewise, using `hb` will show the response headers and body

### `tcpdump`
  * `-D` lists available network interfaces, and then use `-i` to capture on one
  * Can do `tcpdump src 192.168.10.5 and dst some.hostname.com and dst port 5421` as a filter example (can also use 'not' keyword). Also can use `less 1024`, `greater 1024`, `<= 1024`, etc. to filter by packet size
  * Use `-w file.pcap` to write out to a pcap file, and `-r file.pcap` to read that back in for display
  * Can also do `tcpdump host www.example.com` for all traffic to or from that host (can use IP as well)
  * `-X` is a nice hex display, `-n` doesn't convert addresses to names
  * Use single quotes for complex queries that may use parentheses. Can also use things like `'tcp[13] & 16 != 0'` to filter by specific values in tcp headers.
  * Can use `-l` for line-readable output, useful for piping to grep if `-A` is also used
   
### GNU `global` (with `universal-ctags` and `cscope` integrations)
   * To get started, you'll likely have to build `global` package from src, and configure `--with-universal-ctags`, then make and make install.
     * Once this is complete, the `.bashrc` and `.vimrc` in this repo have several environment variables and settings that will make the integration work (as in, can be used just like `ctags`, but it's more powerful
   * Run `gtags` in your project root and you're ready. You can also update from within vim using `:GtagsUpdate` and `:cs reset`
   * *NOTE: Unfortunately, `global` support for cross-references (and hence `gtags-cscope`/`cscope` integration) is limited to the core 5 languages `gtags` supports without the universal-ctags additions (i.e., really just C). In order to get that cross-reference support for C, you'll have to `unset` the `GTAGSLABEL` environment variable set in the `.bashrc` before making your tags files.*
   * References
     * `:h cscope` (includes suggested mappings)
     * https://www.gnu.org/software/global/globaldoc_toc.html#Vim-editor
     * `man gtags` and `man gtags-cscope`

### `Docker`
  * Install via the `docker-ce` or `docker.io` package. You will also need to add yourself to the docker group, and then start the docker service.
  * `docker images` and `docker ps` show images and running containers, respectively. Use `docker ps -a` to see all containers that have been run.
    * `docker stop CONTAINER_ID` and `docker rm CONTAINER_ID` will stop and rm containers.
    * `docker rmi IMAGE_ID` will remove images
  * Can use `docker run -it IMAGE_NAME` to drop into a shell, which enables tty and interactive (i.e. stdin)
    * Alternatively, and more likely, run something like `docker run -d -p 8080:8080 --name my_container_name IMAGE_NAME` to run a container. It will be in detatched mode so you have your shell back, will connect ports 8080 of host to container, and give it a name.
    * `-P` will select random host ports for everything the container opens, and then do `docker port NAME` to see the exposed container ports.
  * To remove all stale containers, you can do `docker rm $(docker ps -a -q)`
  * When you have a Dockerfile, you can build the image with `docker build -t image_name:optional_tag .`
    * Note, when building an image with a Dockerfile, you always need to do a `RUN apt update` before you can `RUN apt -y -q install some_package`.
    * Additional directives that are useful/needed in Dockerfiles are `FROM`, `WORKDIR` to set your apps working dir, `COPY . .` to copy everything in current dir to the image/containers WORKDIR, `EXPOSE` to note any exposed ports by the app, and `CMD` to finally say what command will be run when a container from this image is run.

## Tools making their way through Debian `testing`

* `bat` - a better `cat` (available in Ubuntu repos)

## TODO: tools/things yet to look into:

* Use C++ more: https://berthub.eu/articles/posts/c++-1/
   * https://www.amazon.com/Tour-2nd-Depth-Bjarne-Stroustrup/dp/0134997832
* QEMU emulation, both in qemu-user and qemu-system
* Terminal debugging with GDB in Vim 8. See `:h terminal-debug`
* coc.vim, ale, vim-lsp...? Ale seems best...
* `inoremap {<CR> {<CR>}<Esc>ko`?
* Make tutorial: https://makefiletutorial.com/#getting-started
* Examples of loops (for i...print $i...), conditionals, `seq`, xargs / GNU parallel, rsync
* git worktree
* https://github.com/jlevy/the-art-of-command-line
* https://will-keleher.com/posts/5-Useful-Bash-Patterns.html
   
## TODO: more vim resources
   
* https://github.com/mhinz/vim-galore
* https://github.com/ibhagwan/vim-cheatsheet
* http://vimcasts.org/episodes/page/8/
* https://vimmer.io/
