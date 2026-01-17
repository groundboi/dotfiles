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
set wildmode=longest:full       " don't auto-fill the first match when tab completing buffer names
set completeopt=menu,longest
set wildoptions=pum             " use popup menu for completion (vim 9)
set splitbelow                  " default horizontal split is below
set splitright                  " default vertical split is right
set hidden                      " allow hidden buffers
set mouse=a                     " enable mouse support
set encoding=utf-8
set hlsearch                    " highlight search matches
set ignorecase                  " ignore case
set incsearch                   " show partial matches as typing
set smartcase                   " case-incensitive searching, unless there is a capital
if !has('nvim')
    set ttymouse=sgr            " useful for using mouse to change window size, etc. when in tmux
endif

" Persistent undo: ensure undodir exists
set undofile                    " persistent undo history
let s:undodir = expand('~/.vim/undodir')
if !isdirectory(s:undodir)
  silent! call mkdir(s:undodir, 'p', 0700)
endif
set undodir=~/.vim/undodir      " don't clog working dir with undo history file (undodir must exist)

set wildignore+=tags            " ignore tags file when vimgrep'ing over **/*
set scrolloff=5                 " display some context lines when scrolling
set timeoutlen=1000             " remove esc delays
set ttimeoutlen=50              " remove esc delays
set backspace=indent,eol,start  " more powerful backspacing
set list
set listchars=trail:␣
if has('termguicolors')
    set termguicolors           " more colors (only available when configured +termguicolors)
    if exists('$TMUX')
        let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"  " see :h xterm-true-color
        let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"  " see :h xterm-true-color
    endif
endif
packadd! matchit                " nicer use of %

let mapleader=' '               " set space to leader key

nnoremap <Esc>     :nohl \| cclose \| lclose \| helpclose<CR>
nnoremap <leader>n :Lexplore<CR>
nnoremap <leader>m :Lexplore %:p:h<CR>
nnoremap <leader>c :setlocal spell! spelllang=en_us<CR>
nnoremap <leader>b :ls<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-X> :close<CR>
nnoremap <silent> <Tab> :cnext<CR>zz
nnnoremap <silent> <S-Tab> :cprev<CR>zz
nnnoremap <leader>y "+y
nnnoremap <leader>d "_d
nnnoremap <leader>s :%s/\<<C-r><C-w>\>/
nnoremap <C-d> <C-d>zz
nnnoremap <C-u> <C-u>zz
if executable('fzf')
    " Note - will need to fix the below up for your system
    " Eventually, this will be done smarter
    " source /home/user/software/fzf/fzf-0.35.1/plugin/fzf.vim
    if isdirectory('/opt/homebrew/opt/fzf')
        set rtp+=/opt/homebrew/opt/fzf
    endif
    nnoremap <leader><SPACE> :FZF<CR>
endif
if executable('rg')
    set grepprg=rg\ --vimgrep
    nnoremap S :Rg -w -s <C-R><C-W><CR>:cw<CR>
    command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Rg<SPACE>
    vnoremap S y:Rg -w \"<C-R>\"\<CR>:cw<CR>
else
    nnoremap S :grep! -RI --exclude=tags <C-R><C-W> .<CR>:cw<CR>
    nnoremap \ :grep!<SPACE>
    vnoremap S y:grep! -RI --exclude=tags \"<C-R>\"\<CR>:cw<CR>
endif

inoremap <C-]> <C-X><C-]>
inoremap <C-F> <C-X><C-F>
inoremap <C-D> <C-X><C-D>
inoremap <C-L> <C-X><C-L>
inoremap <C-O> <C-X><C-O>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap <leader>y "+y
xnoremap <leader>d "_d

" Better looking file/dir browsing via built-in netrw
let g:netrw_banner = 0                  " Get rid of the default help banner at the top
let g:netrw_liststyle = 3               " Use the tree-style listing (can cycle with i)
let g:netrw_browse_split = 4            " When opening a file, use previous window
let g:netrw_altv = 1                    " Split on left
let g:netrw_winsize = 20                " Window size for left split
let g:netrw_fastbrowse = 0              " Never re-use directory listing
let g:netrw_special_syntax = 1          " Special highlighting in netrw based on filetype
autocmd FileType netrw setl bufhidden=wipe

" Only showing one cursorline for active window
autocmd WinLeave * setl nocursorline
autocmd WinEnter * setl cursorline

inoremap <tab> <c-r>=Smart_TabComplete()<CR>
function! Smart_TabComplete()
  if (pumvisible())
    return "\<C-N>"
  endif

  let line = getline('.');

  let substr = strpart(line, -1, col('.'))
  let substr = matchstr(substr, "[^ \t]*$")

  if (strlen(substr)==0)
    return "\<tab>"
  endif

  let has_slash = match(substr, '\/') != -1;

  if (has_slash)
    return "\<C-X>\<C-F>";
  elseif (!empty(&omnifunc))
    return "\<C-X>\<C-O>";
  else
    return "\<C-X>\<C-N>";
  endif
endfunction

colorscheme evening

set statusline=%#MatchParen#%{get(b:,'gitsigns_head','')}%*
set statusline+=\ %f\ %m\ %r
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %l/%L\ %p%%\  
