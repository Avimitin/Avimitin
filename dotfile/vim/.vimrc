set number

set rnu
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

set smartcase
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

noremap J 5j
noremap K 5k
noremap H ^
noremap H ^
noremap L g_
noremap L g_
noremap W 5w
noremap B 5b
inoremap <C-e> <End>
inoremap <C-a> <Home>
nnoremap <leader>w :w!<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>q :Bclose<CR>:tabclose<CR>gT
nnoremap <ESC> :noh<CR>

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

hi clear

if exists("syntax on")
    syntax reset
endif

set t_Co=256
let g:colors_name = "undead"

" General
exe 'hi CursorLineNr ctermbg=0  ctermfg=15'
exe 'hi CursorColumn ctermbg=0'
exe 'hi ColorColumn  ctermbg=0'
exe 'hi Cursorline   ctermbg=0'
exe 'hi MatchParen   ctermbg=8  ctermfg=15   cterm=NONE'
exe 'hi WarningMsg   ctermbg=0  ctermfg=3'
exe 'hi Underlined              ctermfg=6'
exe 'hi VertSplit    ctermbg=0  ctermfg=0'
exe 'hi IncSearch    ctermbg=8  ctermfg=NONE cterm=NONE'
exe 'hi CurSearch    ctermbg=8  ctermfg=NONE cterm=NONE'
exe 'hi Directory               ctermfg=5'
exe 'hi PmenuSel     ctermbg=8  ctermfg=15   cterm=NONE'
exe 'hi Question                ctermfg=2'
exe 'hi ErrorMsg     ctermbg=0  ctermfg=1'
exe 'hi MoreMsg                 ctermfg=2'
exe 'hi NonText                 ctermfg=7'
exe 'hi Folded       ctermbg=7  ctermfg=0'
exe 'hi Search       ctermbg=8  ctermfg=NONE'
exe 'hi Normal                  ctermfg=15'
exe 'hi Visual       ctermbg=8  ctermfg=NONE'
exe 'hi Cursor       ctermbg=15 ctermfg=0'
exe 'hi LineNr       ctermbg=0  ctermfg=7'
exe 'hi Pmenu        ctermbg=8  ctermfg=7    cterm=NONE'

" Code syntax
exe 'hi Conditional             ctermfg=4'
exe 'hi StorageClass            ctermfg=6'
exe 'hi Identifier              ctermfg=6'
exe 'hi Character               ctermfg=5'
exe 'hi Statement               ctermfg=4'
exe 'hi Constant                ctermfg=5'
exe 'hi Function                ctermfg=1'
exe 'hi Operater                ctermfg=4'
exe 'hi Special                 ctermfg=7'
exe 'hi PreProc                 ctermfg=4'
exe 'hi Boolean                 ctermfg=5'
exe 'hi Keyword                 ctermfg=4'
exe 'hi Comment                 ctermfg=7'
exe 'hi Number                  ctermfg=5'
exe 'hi Define                  ctermfg=4'
exe 'hi String                  ctermfg=3'
exe 'hi Float                   ctermfg=5'
exe 'hi Label                   ctermfg=2'
exe 'hi Title                   ctermfg=15'
exe 'hi Todo         ctermbg=0  ctermfg=1'
exe 'hi Type                    ctermfg=6'
exe 'hi Tag                     ctermfg=4'

" Gutter
exe 'hi SignColumn      ctermbg=0  ctermfg=15'
exe 'hi GitGutterAdd    ctermbg=0  ctermfg=2'
exe 'hi GitGutterChange ctermbg=0  ctermfg=3'
exe 'hi GitGutterDelete ctermbg=0  ctermfg=1'

" Code diff
exe 'hi DiffAdd      ctermbg=0  ctermfg=2'
exe 'hi DiffChange   ctermbg=0  ctermfg=3'
exe 'hi DiffDelete   ctermbg=0  ctermfg=1'

" Menu for stuff like ':e <Completion>'
exe 'hi StatusLine   ctermbg=7  ctermfg=8'
exe 'hi WildMenu     ctermbg=9  ctermfg=0'

" Hide '~' beyond EOF
exe 'hi EndOfBuffer             ctermfg=0'

" Bold normal text, used by Denite
exe 'hi NormalBold              ctermfg=15 cterm=bold'
