set nocompatible                " not vi compatible
syntax enable                   " syntax highlighting
filetype plugin indent on       " filetype-based syntax highlighting
set tabstop=4                   " width that a <TAB> char displays as
set softtabstop=4               " backspace after pressing <TAB> will remove up to this many spaces
set shiftwidth=4                " number of spaces to use for autoindent
set expandtab                   " convert <TAB> keypress to spaces
set autoindent                  " copy indent of current line when starting new line
set smartindent                 " better autoindent (e.g. after parens...)
set number                      " show line numbers
set cursorline                  " show cursor line
set showmatch                   " highlight matching parens/brackets
set lazyredraw                  " redraw screen only when needed
set wildmenu                    " autocomplete for commands
set wildmode=list:longest       " Don't auto-fill the first match when tab completing buffer names
set splitbelow                  " default horizontal split is below
set splitright                  " default vertical split is right
set hidden                      " allow hidden buffers
set mouse=a                     " enable mouse support
match Error /\s\+$/             " error-highlight trailing whitespace
set background=dark             " use brighter colors
set ruler                       " show file stats
set encoding=utf-8
set hlsearch                    " highlight search matches
set ignorecase                  " ignore case
set incsearch                   " show partial matches as typing
set smartcase                   " case-incensitive searching, unless there is a capital
set ttymouse=xterm2             " Useful for using mouse to change window size when in tmux
set undofile                    " Persistent undo history
set undodir=~/.vim/undodir      " Don't clog working dir with undo history file (undodir must exist)
set wildignore+=tags            " ignore tags file when vimgrep'ing over **/*
set scrolloff=10                " Display some context lines when scrolling

" Note: To change formatting options for a specific filetype, create a file
" ~/.vim/after/ftplugin/python.vim and add lines such as the following:
"   setlocal formatoptions=cqa  " Auto wrap on comments only, don't autoinsert comment leaders with o/r
"   setlocal textwidth=80       " Textwidth for comment autowrapping


" The following provides NERDtree-like project browsing using the
" built-in netrw. See :h netrw for more usage info. Call :Vex(plore)
let g:netrw_banner = 0          " Get rid of the default help banner at the top
let g:netrw_liststyle = 3       " Use the tree-style listing (can cycle with i)
let g:netrw_browse_split = 4    " When opening a file, use previous window
let g:netrw_altv = 1            " Split on left
let g:netrw_winsize = 20        " Window size for left split


" The following makes insert mode completion easier. See :h ins-completion
" Note CTRL-N already works in insert mode out of the box.
" Also see the CleverTab function in help documentation.
" Note: CRTL-Y will accept a completion, CRTL-E will cancel completion
" The order of the below are: tag, filename, def/macro, and line completion
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

" The following maps S (redundent due to cc) as 'search' which will
" grep for the current word under the cursor in the entire project
" (ignoring binary files and tags), and populate the quickfix list
" with results. Note vimgrep was too slow...
"
" Tip: In the quickfix list, you can remove non-interesting lines by
" doing :set modifiable, remove lines, then :cgetbuf. The quickfix
" list will then work as expected
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    " Note ag will respect .gitignore, so make sure tags file is in there!
    nnoremap S :grep! <C-R><C-W><CR>:cw<CR>
    " Binds \ to ag shortcut
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
else
    nnoremap S :grep! -RI --exclude=tags <C-R><C-W> .<CR>:cw<CR>
endif

" Determines whether to use spaces or tabs on the current buffer.
" Useful for projects where different files of the same filetype use
" different tab conventions (ugh)
function TabsOrSpaces()
     if getfsize(bufname("%")) > 256000
         " File is very large, just use the default.
         return
     endif
    let numTabs=len(filter(getbufline(bufname("%"),1, 250), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"),1, 250), 'v:val =~ "^ "'))
    if numTabs > numSpaces
        setlocal noexpandtab
    endif
endfunction

" Call the function after opening a buffer
autocmd BufReadPost * call TabsOrSpaces()


" The following plugins may be useful, but remember to look
" for vim built-in functionality first...
"       fugitive
"       NERD tree
"       vim-gitgutter
"       Tagbar
"       undotree
