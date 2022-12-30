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
