set nocompatible                " not vi compatible
set background=dark             " use brighter colors
syntax enable                   " syntax highlighting
filetype plugin indent on       " filetype-based indentation
set tabstop=4                   " width that a <TAB> char displays as
set softtabstop=4               " backspace after pressing <TAB> will remove up to this many spaces
set shiftwidth=4                " number of spaces to use for autoindent
set expandtab                   " convert <TAB> keypress to spaces
set autoindent                  " copy indent of current line when starting new line
set number                      " show line numbers
set relativenumber              " use relative line numbers for easier jumps
set cursorline                  " highlight current line
set showmatch                   " highlight matching parens/brackets
set lazyredraw                  " redraw screen only when needed
set wildmenu                    " autocomplete for commands
set wildmode=list:longest       " don't auto-fill the first match when tab completing buffer names
set splitbelow                  " default horizontal split is below
set splitright                  " default vertical split is right
set hidden                      " allow hidden buffers
set mouse=a                     " enable mouse support
match Error /\s\+$/             " error-highlight trailing whitespace
set encoding=utf-8
set hlsearch                    " highlight search matches
set ignorecase                  " ignore case
set incsearch                   " show partial matches as typing
set smartcase                   " case-incensitive searching, unless there is a capital
set ttymouse=xterm2             " useful for using mouse to change window size when in tmux
set undofile                    " persistent undo history
set undodir=~/.vim/undodir      " don't clog working dir with undo history file (undodir must exist)
set wildignore+=tags            " ignore tags file when vimgrep'ing over **/*
set scrolloff=5                 " display some context lines when scrolling
if has('termguicolors')
    set termguicolors           " more colors (only available when configured +termguicolors)
    if exists('$TMUX')
        let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"  " see :h xterm-true-color
        let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"  " see :h xterm-true-color
    endif
endif
packadd! matchit                " nicer use of %

" Use gtags if available. Note that gtags should be compiled from source
" --with-universal-ctags. When this is true and GTAGSCONF and GTAGSLABEL are
"  set appropriately in .bashrc, the below makes tag usage much more powerful
"  than ctags.
if executable('gtags')
    source /usr/local/share/gtags/gtags.vim
endif
if executable('gtags-cscope')
    source /usr/local/share/gtags/gtags-cscope.vim
    set cscopeprg=gtags-cscope
    set cscopeverbose
    set cscopetag
    if filereadable("GTAGS")
        silent! execute "cs add GTAGS"
    endif
endif

" Note: To change formatting options for a specific filetype, create a file
" ~/.vim/after/ftplugin/python.vim and add lines such as the following:
"   setlocal formatoptions=cqa  " Auto wrap on comments only, don't autoinsert comment leaders with o/r
"   setlocal textwidth=80       " Textwidth for comment autowrapping

" Easier format text with the gq operator
map Q gq

" The following provides NERDtree-like project browsing using the built-in
" netrw. See :h netrw for more usage info. Call :Vex(plore)
let g:netrw_banner = 0          " Get rid of the default help banner at the top
let g:netrw_liststyle = 3       " Use the tree-style listing (can cycle with i)
let g:netrw_browse_split = 4    " When opening a file, use previous window
let g:netrw_altv = 1            " Split on left
let g:netrw_winsize = 20        " Window size for left split

" The following is easier to switch from insert mode to normal mode
inoremap kj <Esc>

" The following makes insert mode completion easier. See :h ins-completion
" Note CTRL-N already works in insert mode out of the box. Also see the
" CleverTab function in help documentation. Note: CRTL-Y will accept a
" completion, CRTL-E will cancel completion. The order of the below are: tag,
" filename, def/macro, and line completion
inoremap <C-]> <C-X><C-]>
inoremap <C-F> <C-X><C-F>
inoremap <C-D> <C-X><C-D>
inoremap <C-L> <C-X><C-L>

" Map CTRL-h, j, k, l to navigate between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Map tab, shift-tab to cycle buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Cycle through quickfix list with left/right arrows
nnoremap <silent> <RIGHT> :cnext<CR>
nnoremap <silent> <LEFT> :cprev<CR>

" The following maps normal mode S (redundent due to cc) as 'search' which
" will grep for the current word under the cursor in the entire project
" (ignoring binary files and tags), and populate the quickfix list with
" results. Similarly for a visual mode selection with S
"
" Tip: In the quickfix list, you can remove non-interesting lines by doing
" :set modifiable, remove lines, then :cgetbuf. The quickfix list will then
" work as expected
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    nnoremap S :grep! --ignore=tags -s <C-R><C-W><CR>:cw<CR>
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
    vnoremap S y:Ag --ignore=tags \"<C-R>"\"<CR>:cw<CR>
else
    nnoremap S :grep! -RI --exclude=tags <C-R><C-W> .<CR>:cw<CR>
    nnoremap \ :grep!<SPACE>
    vnoremap S y:grep! -RI --exclude=tags \"<C-R>"\"<CR>:cw<CR>
endif

if executable('fzf')
    source /usr/share/doc/fzf/examples/fzf.vim
    nnoremap <SPACE> :FZF<CR>
endif

" Determines whether to use spaces or tabs on the current buffer.  Useful for
" projects where different files of the same filetype use different tab
" conventions (ugh)
function TabsOrSpaces()
     if getfsize(bufname("%")) > 256000
         return
     endif
    let numTabs=len(filter(getbufline(bufname("%"),1, 250), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"),1, 250), 'v:val =~ "^ "'))
    if numTabs > numSpaces
        setlocal noexpandtab
    endif
endfunction
autocmd BufReadPost * call TabsOrSpaces()

" The following allows you to CTRL-P on a filename and view a git diff split view of
" it, with source commit of REVIEW_BASE environment variable. This is useful for
" code review. For example, you can use `git diff --name-only COMMIT | column | expand > diff.txt`
" to generate the filename diff file, then REVIEW_BASE=COMMIT vim diff.txt, and CTRL-P
" the filenames as desired.
function DiffMe()
    " Get filename, cur line number, base commit
    let fname = expand("<cWORD>")
    " TODO - verify fname exists, bail if not
    let curline = line('.')
    let rbase = $REVIEW_BASE

    " Close all buffers but current (i.e. only diff file window is open)
    execute "%bd! | e#"

    " Jump back to stored line
    execute curline

    " Save a few lines for the filename file
    let splitheight = winheight(0)-8

    " Open fname in split, get it ready for diff
    execute "above ".splitheight."split " . fname
    execute "diffthis"
    " Save off filetype for setting in in-memory git revision
    let ft = &filetype

    " Open new vertical split buffer with old version, set filetype
    execute "leftabove vnew | 0r ! git show ".rbase.":".fname
    execute "set filetype=".ft
    " Delete added newline at the end, get it ready for diff
    execute "normal Gddgg"
    execute "diffthis"
endfunction
nnoremap <C-P> :call DiffMe()<CR><C-W>l

" Gets the current branch of the buffer, even if it's in an entirely different
" git repo. Designed to avoid a system() call on each keystroke...
"function StatuslineBranch(...)
"    if a:0 == 1
"        let b:bname = system("git -C ".expand('%:p:h')." branch --show-current 2>/dev/null | tr -d '\n'")
"    endif
"    return get(b:, 'bname', '')
"endfunction
"autocmd BufEnter * call StatuslineBranch(1)

" Note: See :h highlight-groups, and checkout :runtime syntax/colortest.vim
hi statusline ctermbg=black ctermfg=white
hi CursorLine term=bold cterm=bold guibg=Grey20
hi gitbranchhl ctermbg=white ctermfg=darkblue
set laststatus=2
set statusline=\ %#gitbranchhl#
"set statusline+=%{StatuslineBranch()}
set statusline+=%#statusline#
set statusline+=\ %f\ %m\ %r
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %l/%L\ %p%%\ 
