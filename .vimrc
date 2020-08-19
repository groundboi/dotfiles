set nocompatible            " not vi compatible
syntax enable               " syntax highlighting
filetype plugin indent on   " filetype-based syntax highlighting
set tabstop=4               " width that a <TAB> char displays as
set softtabstop=4           " backspace after pressing <TAB> will remove up to this many spaces
set shiftwidth=4            " number of spaces to use for autoindent
set expandtab               " convert <TAB> keypress to spaces
set autoindent              " copy indent of current line when starting new line
set smartindent             " better autoindent (e.g. after parens...)
set number                  " show line numbers
set cursorline              " show cursor line
set showmatch               " highlight matching parens/brackets
set lazyredraw              " redraw screen only when needed
set wildmenu                " autocomplete for commands
set splitbelow              " default horizontal split is below
set splitright              " default vertical split is right
set hidden                  " allow hidden buffers
set mouse=a                 " enable mouse support
match Error /\s\+$/         " error-highlight trailing whitespace
set background=dark         " use brighter colors
" set showcmd               " show partial commands in last line
set ruler                   " show file stats
set encoding=utf-8
set hlsearch                " highlight search matches
set ignorecase              " ignore case
set incsearch               " show partial matches as typing
set smartcase               " case-incensitive searching, unless there is a capital
" set showmode              " show current mode


" Useful plugins:
"   fugitive
"   NERD tree
"   vim-gitgutter
"   Tagbar
