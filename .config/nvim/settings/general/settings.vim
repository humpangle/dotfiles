let g:python_host_prog = expand('$PYTHON2')
let g:python3_host_prog = expand('$PYTHON3')

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
" don't fold by default when opening a file.
set nofoldenable
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

" START NATIVE FUZZY FIND SETTINGS
" set nocompatible " Limit search to project directory
" set path+=** " Search all subdirectories recursively
" set wildmenu " Show multiple matches on one line

" AUTOCMD
au FocusGained * :checktime
au BufNewFile,BufRead *.html.django set filetype=htmldjango
au BufNewFile,BufRead *.eslintrc set filetype=json
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set filetype=jinja
au BufNewFile,BufRead .env* set filetype=sh
au BufNewFile,BufRead *.psql set filetype=sql
au BufNewFile,BufRead Dockerfile* set filetype=dockerfile
au BufNewFile,BufRead *wsl.conf set filetype=config
" To get correct comment highlighting in jsonc file
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd! FileType json set filetype=jsonc
autocmd! FileType *vifm set filetype=vim
" open help file in vertical split
autocmd FileType help wincmd H
" au BufNewFile,BufRead,BufReadPost *.svelte set syntax=html
