The spirit of these dotfiles is being able to quickly and efficiently work on different systems without getting too reliant on custom configs, tools, and plugins. Most dependencies and tools used or referenced in this repo are ones that can be obtained from the current `stable` Debian repo. Additionally, `vim` and `tmux` are kept minimal with no plugins, and not too many crazy key bindings. `nvim` relies just on treesitter and lspconfig, which appear to be "official" plugins that will hopefully be part of neovim core eventually.

Below are some various notes and tips for more efficiently working in bash and other tools.

## bash/command tips

* If editing a long command, `C-xC-e` will bring you into `$EDITOR` for editing the command!
* `$?` - previous command's exit code
* `$$` - current PID
* `$0` - 0th arg of the current process (i.e. name of shell being used, or name of calling script, ...)
* `!!` - repeat previous command (useful if you forgot to `sudo`)
* GNU Readline shortcuts
  * `Alt-b` - move cursor back one word
  * `Alt-f` - move cursor forward one word
  * `Ctrl-a` - move cursor to beginning of line
  * `Ctrl-e` - move cursor to end of line
  * `Ctrl-u` - delete from cursor to start of line
  * `Ctrl-k` - delete from cursor to end of line
  * `Alt-d` - delete to the next word
  * `Ctrl-r` - reverse command history search
  * `Ctrl-l` - clear screen
* `find . -type f -iname "blah*" -exec wc --lines {} \;` - execute a command on each match
* `df -h --total -T` - print info space taken up by mounted file systems
* `du -sh * | sort -h` - print total disk usage of current directory files and subdirs, sorted
* `du -h -d1 | sort -h` - print total disk usage of depth-1 directories, sorted
* Heredoc example [here](examples/heredoc.sh)
* Bash conditional examples [here](examples/conditionals.sh)

## `git` tips

* `git worktree add ../another-dir BRANCH` - makes another working tree for the same git repo (i.e. it is not checked out again). Also see `git worktree list` and `git worktree remove`. Can be a nice alternative to stashing your current progress on a branch if you don't feel like committing yet and need to context switch (say for a PR).

## `vim` tips
  * To open the tag under the cursor in a new split, use `CTRL-W ]` (can also search with `:stag funcname` with tab completion)
    * Can also use `CTRL-W f` to do the same thing for filenames, such as include files
  * To open the tag under the cursor in a preview window, use `CTRL-W }` (can also use `:ptag funcname`). Close with `:pclose` or `CTRL-W z`.
  * `:psearch funcname` is useful for opening previews of a function from an included header file
  * `Ctrl-o` and `Ctrl-i` cycle through `:jumps`, and likewise `g;` and `g,` through `:changes`
  * `]m` goes to next method (useful for python)
  * `[[` goes to beginning of current function, `][` goes to end. `[{` and `]}` do similar for code blocks.
    * `]]` goes to beginning of next function, `[]` goes to end of previous function
    * `[(` and `])` navigate similarly to the code blocks but for parentheses (can be on one line)
  * When cursor is on a word that might be from an #included file, use `[I` to open its def. `[i` does something similar
  * When quickfix window is open (say after using my binding `S` to search word), `CTRL-W <enter>` will open match in new split.
  * `Ctrl-W s` (and likewise for v) will split the window. Can do `:sf FILE` to split and find file, as well as put `:vert` in front of any splitting command to make it vertical split.
  * When using fzf - use `C-x` and `C-v` to open in splits

## `tmux` tips
  * `tmux new -s MySessionName` will create a named session
  * `tmux attach -t MySessionName` will attach to the session. If no name or number provided, defaults to most recently used session
  * Use `-t` for grouped sessions, which is useful for multi monitor setups. For example, if a session `MySess` exists and you want another "view" into it in your other monitor that can independently view windows, start a new session with `tmux new -s OtherSess -t MySess`. This actually creates a new group `MySess` based on the session `MySess`.

## Other tools I typically use

Definitely want to install `rg` (package name `ripgrep`), `tldr`, `bat`, `fd`, `universal-ctags`, `http` (package name `httpie`), `moreutils` (which contains `vidir`), `updatedb` and `locate`.

### `fzf`
  * By default, outputs selected matches to stdout. You can do `fzf | xargs ls -l` for example, and use tab/shift-tab to select multiple matches
  * `ctrl-j` and `ctrl-k` move cursor up and down
  * Quick `cd` by doing `cd **<TAB>` if autocomplete enabled. Or, if just keybindings enabled, simply do `alt-c`.
  * If keybindings enabled, `ctrl-t` is a shortcut for pasting selected dir/files on command line (I find this quicker than autocomplete with `**`)
  * Autocomplete works with `ssh **<TAB>`
  * `kill <TAB>` to search pids to send signal to
  * `ctrl-r` is much nicer with key bindings enabled
  * Can pipe *into* fzf to search, say, history like `history | fzf`
  * Can take action on fzf match like ``wc --lines `fzf` `` (or, easier with autocomplete as `wc --lines **<TAB>`
  * Use `^` and `$` for beginning/end, such as `readme .md$`
  * There is a way to add a preview-window keybinding as well

### `tcpdump`
  * `-D` lists available network interfaces, and then use `-i` to capture on one
  * Can do `tcpdump src 192.168.10.5 and dst some.hostname.com and dst port 5421` as a filter example (can also use 'not' keyword). Also can use `less 1024`, `greater 1024`, `<= 1024`, etc. to filter by packet size
  * Use `-w file.pcap` to write out to a pcap file, and `-r file.pcap` to read that back in for display
  * Can also do `tcpdump host www.example.com` for all traffic to or from that host (can use IP as well)
  * `-X` is a nice hex display, `-n` doesn't convert addresses to names
  * Use single quotes for complex queries that may use parentheses. Can also use things like `'tcp[13] & 16 != 0'` to filter by specific values in tcp headers.
  * Can use `-l` for line-readable output, useful for piping to grep if `-A` is also used

### `gdb`
  * To build GDB 11.X for remote cross-arch debugging, extract the GDB source and then alongside the src dir, create `gdb-multitarget-host` and (say) `gdbserver-armv7l` directories. Make sure you have the cross compiler toolchain (i.e. `apt install binutils-arm-linux-gnueabi`). Then run the following two builds:
    * In `gdb-multitarget-host` do: `../gdb-src/configure --srcdir=../gdb-src --enable-targets=all && make`
    * In `gdbserver-armv7l` do: `../gdb-src/configure --srcdir=../gdb-src --host=arm-linux-gnueabi && make all-gdbserver`
  * To actually do the remote debugging, on the target machine do `gdbserver localhost:1234 myprog`. On the host machine, do `gdb myprog` (yes the same binary), and then `target remote remotehost:1234`. Note if using gef, can just start gdb then `gef-remote remotehost:1234`.
  * GEF is awesome! Use it with the `tmux-setup` command
  * Commands of interest are: fin, watch, break, next, step, continue, print, bt, info, display, set, up/down, checkpoint/restart, where

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

## Neovim plugins currently in use

* diffview
    * plenary is a dependency
* gitsigns
* nightfox
* nvim-autopairs
* nvim-lspconfig
* nvim-tree
* nvim-treesitter
* nvim-web-devicons
* vim-illuminate

## Potential nvim plugins to use

* `nvim-dap`? Or just `termdebug`
* `octo.nvim`: Waiting on gitlab support!

## TODO:

* Improve treesitter settings. Maybe turn `indent` on. Also, there is more treesitter functionality available via https://github.com/nvim-treesitter/nvim-treesitter-textobjects. For example, moving to functions, visually selecting a parsed object and increasing/decreasing scope, etc.
* Vim filtering text to external commands, writing, reading, etc.
* Examples of loops (for i...print $i...), conditionals, `seq`, xargs / GNU parallel, rsync
* Check out `run-one`, looks neat
* Try out `fzf-lua`: https://github.com/ibhagwan/fzf-lua (read wiki page too)
* Figure out new MR review workflow. See https://www.reddit.com/r/neovim/comments/11ls23z/what_is_your_nvim_workflow_for_reviewing_prs/

## More vim resources

* https://github.com/mhinz/vim-galore
* https://github.com/ibhagwan/vim-cheatsheet
* http://vimcasts.org/episodes/page/8/
