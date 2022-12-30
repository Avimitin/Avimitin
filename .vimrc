set number
filetype plugin indent on
syntax enable
set backspace=indent,eol,start
set complete-=i

set smarttab
set expandtab

set shiftwidth=2
set tabstop=2

set ai
set si
set wrap

set nrformats-=octal

set ttimeout
set ttimeoutlen=100

set hlsearch
set incsearch

set laststatus=2

set ruler
set wildmenu

set scrolloff=1
set sidescrolloff=5

set display+=lastline
set encoding=utf-8

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

set formatoptions+=j

set autoread
set history=1000
set tabpagemax=50
set sessionoptions-=options
set viewoptions-=options
set t_Co=16
set cmdheight=1
set hid
set whichwrap+=<,>,h,l

set smartcasae
set ignorecase

set lazyredraw

set magic

set noerrorbells
set novisualbell
set t_vb=
set tm=500

set ffs=unix,dos,mac

set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

let mapleader=";"

nnoremap J 5j
nnoremap K 5k
nnoremap H ^
nnoremap L g_
nnoremap W 5w
nnoremap B 5b
inoremap <C-e> <End>
inoremap <C-a> <Home>
nnoremap <leader>w :w!<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>q :Bclose<CR>:tabclose<CR>gT

au InsertEnter * set nornu
au InsertLeave * set rnu

" last line
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

map <tab> :bnext<cr>
map <s-tab> :bprevious<cr>
