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
match Error /\s\+$/             " error-highlight trailing whitespace
set encoding=utf-8
set hlsearch                    " highlight search matches
set ignorecase                  " ignore case
set incsearch                   " show partial matches as typing
set smartcase                   " case-incensitive searching, unless there is a capital
if !has('nvim')
    set ttymouse=sgr            " useful for using mouse to change window size, etc. when in tmux
endif
set undofile                    " persistent undo history
set undodir=~/.vim/undodir      " don't clog working dir with undo history file (undodir must exist)
set wildignore+=tags            " ignore tags file when vimgrep'ing over **/*
set scrolloff=5                 " display some context lines when scrolling
set timeoutlen=1000             " remove esc delays
set ttimeoutlen=50              " remove esc delays
set backspace=indent,eol,start  " more powerful backspacing
if has('termguicolors')
    set termguicolors           " more colors (only available when configured +termguicolors)
    if exists('$TMUX')
        let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"  " see :h xterm-true-color
        let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"  " see :h xterm-true-color
    endif
endif
packadd! matchit                " nicer use of %

let mapleader=' '               " set space to leader key

"
" Normal mode keymappings
" =======================
" Esc / CAPS        Clear highlighting. Close quickfix, location list, help windows
" <leader>n         Open netrw in cwd
" <leader>m         Open netrw in dir of current file
" <leader>s         Toggle spell check
" <leader>b         List buffers
" CTRL-direction    Navigate between splits (with hjkl)
" Tab / Shift-Tab   Cycle forward / back through quickfix list
" <leader><SPACE>   Open fzf search for files (if installed)
" S                 Grep current word on cursor project-wide, populate quickfix list with results
" \                 Open project-wide search prompt, populate quickfix list with results
" <leader>y         Yank but for system clipboard
" <leader>d         Delete into null register, so don't overwrite yanked text
" <leader>S         Search/replace word under cursor for current buffer
"
" Insert mode keymappings
" =======================
" CTRL-]            Tag completion
" CTRL-f            Filename completion
" CTRL-d            Def/Macro completion
" CTRL-l            Line completion
" CTRL-o            Omni completion
" CTRL-n            Keywords completion (keywords in current file)
" CTRL-y / CTRL-e   Accept / Cancel completion
"
" Visual mode keymappings
" =======================
" S                 Grep current selection project-wide, populate quickfix list with results
" J / K             Move block up and down, auto-indenting along the way
" <leader>y         Yank but for system clipboard
" <leader>d         Delete into null register, so don't overwrite yanked text (technically X mode remap)
"
nnoremap <Esc>     :nohl \| cclose \| lclose \| helpclose<CR>
nnoremap <leader>n :Lexplore<CR>
nnoremap <leader>m :Lexplore %:p:h<CR>
nnoremap <leader>s :setlocal spell! spelllang=en_us<CR>
nnoremap <leader>b :ls<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> <Tab> :cnext<CR>zz
nnoremap <silent> <S-Tab> :cprev<CR>zz
nnoremap <leader>y "+y
nnoremap <leader>d "_d
nnoremap <leader>S :%s/\<<C-r><C-w>\>/
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
if executable('fzf')
    source ~/software/fzf/fzf-0.34.0/plugin/fzf.vim
    nnoremap <leader><SPACE> :FZF<CR>
endif
if executable('rg')
    set grepprg=rg\ --vimgrep
    nnoremap S :Rg -w -s <C-R><C-W><CR>:cw<CR>
    command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Rg<SPACE>
    vnoremap S y:Rg -w \"<C-R>"\"<CR>:cw<CR>
else
    nnoremap S :grep! -RI --exclude=tags <C-R><C-W> .<CR>:cw<CR>
    nnoremap \ :grep!<SPACE>
    vnoremap S y:grep! -RI --exclude=tags \"<C-R>"\"<CR>:cw<CR>
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

" The following allows you to CTRL-P on a filename and view a git diff split view of
" it, with source commit of REVIEW_BASE environment variable. This is useful for
" code review. For example, you can use `git diff --name-only COMMIT | column | expand > diff.txt`
" to generate the filename diff file, then REVIEW_BASE=COMMIT vim diff.txt, and CTRL-P
" the filenames as desired.
function! DiffMe()
    " Get filename, cur line number, base commit
    let fname = expand("<cWORD>")
    let splitheight = 8
    let branch_name = trim(system("git branch --show-current | tr '/' '_'"))
    let review_name = ".review_".branch_name.".txt"

    " This lets us toggle the view of the changed file window
    if !filereadable(fname)
        let winid = bufwinid(".review")
        if winid == -1
            " Buffer not loaded into window
            execute "bot ".splitheight."split ".review_name
        else
            " Buffer IS loaded into window, close it
            execute "bd .review"
        endif

        return
    endif

    let curline = line('.')
    let rbase = $REVIEW_BASE

    " Close all buffers but current (i.e. only diff file window is open)
    execute "w"
    execute "%bd! | e#"

    " Make backup in case we accidentally forget to git resume-review
    "execute "w " . review_name . ".bak"

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
    " TODO - first check if git show actually gives us anything. If not, it's
    " a new file, and we only need to show the one on the review branch
    execute "leftabove vnew | 0r ! git show ".rbase.":".fname
    execute "set filetype=".ft
    " Delete added newline at the end, get it ready for diff
    execute "normal Gddgg"
    execute "diffthis"
endfunction
nnoremap <C-P> :call DiffMe()<CR><C-W>l

" evening is also good, and included in vim. Also solarized
colorscheme onedark
hi Pmenu        guifg=#ffffff guibg=#4d4d4d gui=NONE cterm=NONE
hi PmenuSbar    guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi PmenuSel     guifg=#000000 guibg=#bebebe gui=NONE cterm=NONE
hi PmenuThumb   guifg=NONE guibg=#ffffff gui=NONE cterm=NONE
hi CursorLine   term=bold cterm=bold guibg=#383736
hi Comment      cterm=italic gui=italic

" Setting diff colors because they're terrible by default
" Currently using the exact GitLab color scheme
hi DiffAdd      cterm=bold ctermbg=17 guibg=#1f3623
hi DiffDelete   cterm=bold ctermbg=17 guibg=#4a2324
hi DiffChange   cterm=bold ctermbg=17 guibg=#1f3623
hi DiffText     cterm=bold ctermbg=17 guibg=#235e26

set statusline=\ %f\ %m\ %r
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %l/%L\ %p%%\ 
