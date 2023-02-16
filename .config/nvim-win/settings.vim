" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

" Many plugins require update time shorter than default of 4000ms
set updatetime=100
set hidden " close unsaved buffer with 'q' without needing 'q!'
set tabstop=2
set softtabstop=2
set expandtab " converts tabs to white space
set shiftwidth=2 " default indent = 2 spaces
set encoding=utf8
set cc=80  " column width
set incsearch    " Incremental search, search as you type
set ignorecase   " Make searching case insensitive
set smartcase    " ... unless the query has capital letters
set gdefault     " Use 'g' flag by default with :s/foo/bar/.
set hlsearch

" Tab Splits
set splitbelow
set splitright
set mouse=a

" I disabled both because they were distracting and slow (according to docs)
set cursorline " highlight cursor positions

" reload a file if it is changed from outside vim
set autoread
set noswapfile
set undofile
set undodir=$HOME/.vim-win/undodir/

augroup MyMiscGroup
  " highlight yank
  " :h lua-highlight
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
