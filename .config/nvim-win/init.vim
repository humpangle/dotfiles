if has('win32')
  language en_US
  set fileformat=unix
  let s:plugins_path = '~\AppData\Local\nvim\autoload'
else
  " unset default paths of regular nvim in unix
  set runtimepath-=~/.config/nvim
  set runtimepath-=~/.config/nvim/after
  set runtimepath-=~/.local/share/nvim/site
  set runtimepath-=~/.local/share/nvim/site/after

  " set custom paths for use in vscode nvim
  set runtimepath+=~/.config/nvim-win/after
  set runtimepath^=~/.config/nvim-win
  set runtimepath+=~/.local/share/nvim-win/site/after
  set runtimepath^=~/.local/share/nvim-win/site

  let &packpath = &runtimepath

  let $MYVIMRC = "$HOME/.config/nvim-win/init.vim"

  let s:plugins_path = "$HOME/.local/share/nvim-win/site/autoload"
  let s:plug_install_path = s:plugins_path . '/plug.vim'
  let s:plugins_path = s:plugins_path . '/plug'

  if !filereadable(s:plug_install_path)
     silent execute '!curl -fLo ' . s:plug_install_path . ' --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    autocmd VimEnter * PlugInstall | source $MYVIMRC
  endif
endif

augroup MyMiscGroup
  " highlight yank
  " :h lua-highlight
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

call plug#begin(s:plugins_path)
" Surround text with quotes, parenthesis, brackets, and more.
Plug 'tpope/vim-surround'
Plug 'nelstrom/vim-visual-star-search'

call plug#end()

nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

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
" :%s/term/sub will be highlighted as sub is typed
set inccommand=nosplit
" sub will be opened in split window
" set inccommand=split

" Tab Splits
set splitbelow
set splitright
set mouse=a

set foldmethod=indent
set foldnestmax=10
" don't fold by default when opening a file.
set nofoldenable
set foldlevel=2

" reload a file if it is changed from outside vim
set autoread
set noswapfile

" persist undo history even when I quit vim
set undofile
set undodir=$HOME/.vim/undodir/

" Paste text unmodified from other applications.
" https://vim.fandom.com/wiki/Toggle_auto-indenting_for_code_paste
set paste
set nopaste

nnoremap <leader>fc <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>

" format paragraphs/lines to 80 chars
nnoremap <Leader>pp gqap
xnoremap <Leader>pp gqa

" Save file
nnoremap <Leader>ww :Write<CR>
nnoremap <Leader>wa :Wall<CR>
nnoremap <Leader>wq :Wq<cr>

" Quit vim
nnoremap <leader>qq <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <leader>qA <Cmd>call VSCodeNotify('workbench.action.closeWindow')<CR>

" better code indentations in visual mode.
vnoremap < <gv
vnoremap > >gv
" yank / Copy and paste from system clipboard (Might require xclip install)
nmap "+yy 0"+yg_
vmap <Leader>Y "+y
vmap <Leader>x "+x
nmap <Leader>x "+x
nmap <Leader>P "+P
vmap <Leader>P "+P
" Yank all
nnoremap <Leader>y+ :%y<bar>:let @+=@"<CR>
nnoremap <Leader>YY :%y<bar>:let @+=@"<CR>
nnoremap <Leader>ya :%y<bar>:let @a=@"<CR>
nnoremap ,yy vgny<bar>:let @+=@"<CR> <bar>" yank highlighted
nnoremap ,cc vgny<bar>:let @a=@"<CR> <bar>" yank highlighted

" COPY FILE PATH
" yank relative File path
nnoremap ,yr <Cmd>call VSCodeNotify('copyRelativeFilePath')<CR>
" yank absolute File path
nnoremap ,yf <Cmd>call VSCodeNotify('copyFilePath')<CR>

" Dump vim register into a buffer in vertical split.
nnoremap <leader>re :reg<CR>
