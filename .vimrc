set number
filetype plugin indent on
syntax enable
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set ttimeout
set ttimeoutlen=100
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

nnoremap J 5j
nnoremap K 5k
nnoremap H ^
nnoremap L g_
nnoremap W 5w
nnoremap B 5b
inoremap <C-e> <End>
inoremap <C-a> <Home>
nnoremap ;w :w<CR>
nnoremap ;x :x<CR>
