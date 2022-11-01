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
set wildoptions=pum             " use pop up menu for completion (vim 9)
set completeopt=menu,preview,longest
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
set ttymouse=sgr                " useful for using mouse to change window size when in tmux
set undofile                    " persistent undo history
set undodir=~/.vim/undodir      " don't clog working dir with undo history file (undodir must exist)
set wildignore+=tags            " ignore tags file when vimgrep'ing over **/*
set scrolloff=5                 " display some context lines when scrolling
set timeoutlen=1000                " remove esc delays
set ttimeoutlen=50                 " remove esc delays
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

" Quick open netrw in cwd
nnoremap <leader>n :Lexplore<CR>

" Quick open netrw in dir of current file
nnoremap <leader>m :Lexplore %:p:h<CR>

" Quick toggle spell check
nnoremap <leader>s :setlocal spell! spelllang=en_us<CR>

" Quick show buffers
nnoremap <leader>b :ls<CR>

" Highlight word under cursor (not search), and clear
nnoremap <leader>h :exec 'match Search /\V\<'.expand('<cword>').'\>/'<CR>
nnoremap <leader>c :exec 'match none'<CR>:exec 'noh'<CR>

" Popup the function args or tag definition under cursor
nnoremap <leader>] :call TagPopup()<CR>

" Easier format text with the gq operator
map Q gq

" Easier insert mode completion. See :h ins-completion. CTRL-N already works
" out of the box. CRTL-Y accepts a completion, CRTL-E cancels a completion.
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

" Maps normal mode S as 'search' which will grep for the current word under
" the cursor in the entire project (ignoring binary files and tags), and
" populate the quickfix list with results. Similarly for a visual mode
" selection with S.
" Tip: In the quickfix list, you can remove lines by doing :set modifiable,
" remove lines, then :cgetbuf. The quickfix list will then work as expected
if executable('rg')
    set grepprg=rg\ --vimgrep
    nnoremap S :Rg -w -s <C-R><C-W><CR>:cw<CR>
    command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Rg<SPACE>
    vnoremap S y:Rg -w \"<C-R>"\"<CR>:cw<CR>
else
    nnoremap S :grep! -RI --exclude=tags <C-R><C-W> .<CR>:cw<CR>
    nnoremap \ :grep!<SPACE>
    vnoremap S y:grep! -RI --exclude=tags \"<C-R>"\"<CR>:cw<CR>
endif

" The following provides nicer project browsing using the built-in netrw. See :h netrw
let g:netrw_banner = 0                  " Get rid of the default help banner at the top
let g:netrw_liststyle = 3               " Use the tree-style listing (can cycle with i)
let g:netrw_browse_split = 4            " When opening a file, use previous window
let g:netrw_altv = 1                    " Split on left
let g:netrw_winsize = 20                " Window size for left split
let g:netrw_fastbrowse = 0              " Never re-use directory listing
let g:netrw_special_syntax = 1          " Special highlighting in netrw based on filetype
autocmd FileType netrw setl bufhidden=wipe

" Use fzf to quickly find new files to open
if executable('fzf')
    source /usr/share/doc/fzf/examples/fzf.vim
    nnoremap <leader><SPACE> :FZF<CR>
endif

" Determines whether to use spaces or tabs on the current buffer.  Useful for
" projects where different files of the same filetype use different tab conventions
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
" it, used in conjunction with 'git review' as defined in .gitconfig. This is useful for
" code review. You can keep pressing CTRL-P to cycle through diffing or not.
function DiffMe()
    " Get filename, cur line number, base commit
    let fname = expand("<cWORD>")

    # This lets us toggle the view of the changed file window
    if !filereadable(fname)
        let winid = bufwinid(".review")
        if winid == -1
            " Buffer not loaded into window
            let splitheight = 8
            let branch_name = trim(system("git branch --show-current | tr '/' '_'"))
            let review_name = ".review_".branch_name.".txt"
            echo review_name
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

" Creates a popup with tag definition where the cursor is
func TagPopup()
    silent write
    " jump to tag under cursor
    silent execute "normal \<c-]>"
    " if there is '(' on the same line, it may be a function
    if search('(', "n") == winsaveview()["lnum"]
        " yank the function's name and parameters
        silent execute "normal v/)\<cr>y\<c-t>"
    else
        silent execute "normal vg_\<cr>y\<c-t>"
    endif
    " remove any previously present popup
    call popup_clear()
    " make the popup spawn above/below the cursor
    " TODO - what other options should I use?
    let winid = popup_atcursor(getreg('0')->split("\n"), #{padding: [0,1,1,1]})
    call win_execute(winid, 'set filetype='.&ft)
    call win_execute(winid, 'syntax enable')
endfunc

colorscheme solarized       " evening is also good (included in vim 9)
hi clear EndOfBuffer        " no gross two-tone background at end of buffer
hi clear NonText            " no gross two-tone background at end of buffer
hi Comment cterm=italic
hi statusline ctermbg=black ctermfg=white
hi CursorLine term=bold cterm=bold guibg=Grey20

hi Pmenu guifg=#ffffff guibg=#4d4d4d gui=NONE cterm=NONE
hi PmenuSbar guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi PmenuSel guifg=#000000 guibg=#ffffff gui=NONE cterm=NONE
hi PmenuThumb guifg=NONE guibg=#ffffff gui=NONE cterm=NONE

" Setting diff colors beacuse they're terrible by default
" Currently using the exact GitLab color scheme
hi DiffAdd      cterm=bold ctermbg=17 guibg=#1f3623
hi DiffDelete   cterm=bold ctermbg=17 guibg=#4a2324
hi DiffChange   cterm=bold ctermbg=17 guibg=#1f3623
hi DiffText     cterm=bold ctermbg=17 guibg=#235e26

set laststatus=2
set statusline+=%#statusline#
set statusline+=\ %f\ %m\ %r
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %l/%L\ %p%%\ 
