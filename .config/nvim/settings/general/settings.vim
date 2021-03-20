let g:python_host_prog = expand('$PYTHON2')
let g:python3_host_prog = expand('$PYTHON3')
" let g:node_host_prog = expand("~/.nvm/versions/node/v12.16.1/bin/node")

" Disable netrw
" let g:loaded_netrw       = 0
" let g:loaded_netrwPlugin = 0
" Always show in tree view
let g:netrw_liststyle = 3
" Open file by default in new tab
" let g:netrw_browse_split = 3

syntax enable
" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

" Remap esc key - if doing touch typing
" nmap JJ <esc>
" imap JJ <Esc>
" vmap JJ <Esc>
" nmap KK <esc>
" imap KK <Esc>
" vmap KK <Esc>

if (has("termguicolors"))
 set termguicolors
endif

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
" set nohlsearch
" Search ignore path
set wildignore+=*.zip,*.png,*.jpg,*.gif,*.pdf,*DS_Store*,*/.git/*,*/node_modules/*,*/build/*,package-lock.json,*/_build/*,*/deps/*,*/elixir_ls/*,yarn.lock,mix.lock,*/coverage/*

" Tab Splits
set splitbelow
set splitright
set mouse=a

" I disabled both because they were distracting and slow (according to docs)
set cursorline " highlight cursor positions

" Spell check
setlocal spell spelllang=en

set foldmethod=indent
set foldnestmax=10
set nofoldenable " don't fold by default when opening a file.
set foldlevel=2

" reload a file if it is changed from outside vim
set autoread
set noswapfile

if has('nvim-0.5')
  set undodir=$HOME/.vim/undodir/
else
  set undodir=$HOME/.vim/undodir-0.4/
endif

set undofile

" Use Ripgrep for vimgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

"""""""""""""""""""""""""""""""""""""
" START NATIVE FUZZY FIND SETTINGS
"""""""""""""""""""""""""""""""""""""
" set nocompatible " Limit search to project directory
" set path+=** " Search all subdirectories recursively
" set wildmenu " Show multiple matches on one line
"""""""""""""""""""""""""""""""""""""
" END NATIVE FUZZY FIND SETTINGS
"""""""""""""""""""""""""""""""""""""

" when you need to make changes to a system file, you can override the
" read-only permissions by typing :w!!, vim will ask for your sudo password
" and save your changes
" NOTE: you may need to install a utility such as `askpass` in order to input
" password. On ubuntu, run:
" sudo apt install ssh-askpass-gnome ssh-askpass -y && \
"  echo "export SUDO_ASKPASS=$(which ssh-askpass)" >> ~/.bashrc
cmap w!! w !sudo tee > /dev/null %
