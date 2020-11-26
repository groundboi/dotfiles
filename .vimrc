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
set ttymouse=xterm2         " Useful for using mouse to change window size when in tmux
" set showmode              " show current mode
set undofile                " Persistent undo history
set undodir=~/.vim/undodir  " Don't clog working dir with undo history file (undodir must exist)


" The following makes insert mode completion easier. See :h ins-completion
" Though note, ^n already works in insert mode out of the box...
" Also see the CleverTab function in help documentation
" Note: CRTL-Y will accept a completion, CRTL-E will cancel completion
"
" inoremap ^] ^X^]          " tag-based completion
" inoremap ^F ^X^F          " filename-based completion
" inoremap ^D ^X^D          " definition/macro-based completion
" inoremap ^L ^X^L          " line-based completion


" Determines whether to use spaces or tabs on the current buffer.
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


" Potentially useful plugins:
"   fugitive
"   NERD tree
"   vim-gitgutter
"   Tagbar
"   undotree?
