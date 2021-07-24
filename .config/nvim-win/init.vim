" language en_US
set fileformat=unix

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
set undodir=$HOME/.vim/undodir/

" format paragraphs/lines to 80 chars
nnoremap <Leader>pp gqap
xnoremap <Leader>pp gqa

" better code indentations in visual mode.
vnoremap < <gv
vnoremap > >gv
" yank / Copy and paste from system clipboard (Might require xclip install)
vmap <Leader>Y "+y
vmap <Leader>x "+x
nmap <Leader>x "+x
nmap <Leader>P "+P
vmap <Leader>P "+P

" SEARCH AND REPLACE
" remove highlight from search term
nnoremap <leader>nh :noh<CR>
" replace in entire file
nnoremap <leader>rr :%s///g
nnoremap <leader>rc :%s///gc

"""""""""""""""""""""""""""""""""""""
" START EASY MOTION
"""""""""""""""""""""""""""""""""""""
" let g:EasyMotion_smartcase = 1
"""""""""""""""""""""""""""""""""""""
" END EASY MOTION
"""""""""""""""""""""""""""""""""""""

augroup MyMiscGroup
  " highlight yank
  " :h lua-highlight
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

let autoload_path_set_from_env = !empty($CALLMIY_WIN_VIM_AUTOLOAD_PATH)

let plugins_path = '~\AppData\Local\nvim\autoload'

if(autoload_path_set_from_env)
  let plugins_path = $CALLMIY_WIN_VIM_PLUG_PATH

  if !filereadable($CALLMIY_WIN_VIM_PLUG_VIM_PATH)
    silent execute '!curl -fLo ' . $CALLMIY_WIN_VIM_PLUG_VIM_PATH . ' --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    autocmd VimEnter * PlugInstall | source $MYVIMRC
  endif
endif

call plug#begin(plugins_path)
  Plug 'tpope/vim-surround'
  Plug 'nelstrom/vim-visual-star-search'

  if !exists('g:vscode')
    Plug 'lifepillar/vim-solarized8'
    " A number of useful motions for the quickfix list, pasting and more.
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-commentary'
    Plug 'itchyny/lightline.vim'
    Plug 'sbdchd/neoformat'
    Plug 'easymotion/vim-easymotion'
    Plug 'windwp/nvim-autopairs'
    " Quickly toggle maximaize a tab
    Plug 'szw/vim-maximizer'
    Plug 'vim-scripts/AutoComplPop'
  else
    Plug 'asvetliakov/vim-easymotion', { 'as': 'vim-easymotion-vscode' }
  endif
call plug#end()


if !exists('g:vscode')
  so ~\AppData\Local\nvim\regular.vim
else
  if (autoload_path_set_from_env)
    so ~/.config/nvim-win/vscode.vim
  else
    so ~\AppData\Local\nvim\vscode.vim
endif
