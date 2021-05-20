" unset default paths
set runtimepath-=~/.config/nvim
set runtimepath-=~/.config/nvim/after
set runtimepath-=~/.local/share/nvim/site
set runtimepath-=~/.local/share/nvim/site/after

" set custom paths
set runtimepath+=~/.config/nvim-vscode/after
set runtimepath^=~/.config/nvim-vscode
set runtimepath+=~/.local/share/nvim-vscode/nvim/site/after
set runtimepath^=~/.local/share/nvim-vscode/nvim/site

let &packpath = &runtimepath
" end path settings

" SETTINGS
set ignorecase   " Make searching case insensitive
set smartcase    " ... unless the query has capital letters

" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

" format paragraphs/lines to 80 chars
nnoremap <Leader>pp gqap
xnoremap <Leader>pp gqa

" Save file
nnoremap <Leader>ww :Write<CR>
nnoremap <Leader>wa :Wall<CR>
nnoremap <Leader>wq :Wq<cr>

" Quit vim
nnoremap <leader>qq <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <leader>qa <Cmd>call VSCodeNotify('workbench.action.closeWindow')<CR>

" better code indentations in visual mode.
vnoremap < <gv
vnoremap > >gv
" yank / Copy and paste from system clipboard (Might require xclip install)
vmap <Leader>Y "+y
vmap <Leader>x "+x
nmap <Leader>x "+x
nmap <Leader>P "+P
vmap <Leader>P "+P

" TABS

nnoremap <leader>ts :call VSCodeNotify('workbench.action.newWindow')<CR>

" Move between windows in a tab
nnoremap <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

" RESIZE WINDOW
nnoremap <c-left> :call VSCodeNotify('workbench.action.increaseViewSize')<CR>
nnoremap <c-right> :call VSCodeNotify('workbench.action.decreaseViewSize')<CR>

nnoremap ,rm :call VSCodeNotify('deleteFile')<cr>
nnoremap <leader>ee :call VSCodeNotify('workbench.files.action.focusFilesExplorer')<CR>
nnoremap ,ec :call VSCodeNotify('workbench.action.openSettings')<cr>

" TO MOVE LINES up/down
nnoremap <A-k> :call VSCodeNotify('editor.action.moveLinesUpAction')<CR>
nnoremap <A-j> :call VSCodeNotify('editor.action.moveLinesDownAction')<CR>
" nnoremap <A-k> :m .-2<CR>==
" nnoremap <A-j> :m .+1<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv

" TERMINAL

" COPY FILE PATH
" yank relative File path
nnoremap ,yr <Cmd>call VSCodeNotify('copyRelativeFilePath')<CR>
" yank absolute File path
nnoremap ,yf <Cmd>call VSCodeNotify('copyFilePath')<CR>

" SEARCH AND REPLACE
" remove highlight from search term
nnoremap <leader>nh :noh<CR>
" replace in entire file
nnoremap <leader>rr :%s///g
nnoremap <leader>rc :%s///gc

" BUFFERS
" Delete all buffers
nnoremap <leader>ba :call VSCodeNotify('workbench.action.closeOtherEditors')<cr>
" Delete current buffer
nnoremap <leader>bd :call VSCodeNotify('workbench.action.closeActiveEditor')<cr>
nnoremap <leader>bg :call VSCodeNotify('workbench.action.closeEditorsInGroup')<cr>

" Fugitive
nnoremap <leader>gg :call VSCodeNotify('workbench.view.scm')<cr>

" FZF
nnoremap <leader>ff :call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>/ <Cmd>call VSCodeNotify('workbench.action.replaceInFiles')<CR>
nnoremap <leader>bt <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap <leader>pt <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
" https://code.visualstudio.com/docs/editor/editingevolved#_how-can-i-configure-ctrltab-to-navigate-across-all-editors-of-all-groups
nnoremap <leader>fl :call VSCodeNotify('actions.find')<CR>
nnoremap <leader>fw :call VSCodeNotify('workbench.action.quickOpenPreviousRecentlyUsedEditor')<CR>
nnoremap <leader>fs <Cmd>call VSCodeNotify('workbench.action.selectTheme')<CR>

" START NEOFORMAT
nnoremap <leader>fc <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>

"""""""""""""""""""""""""""""""""""""
" COC START
"""""""""""""""""""""""""""""""""""""
nnoremap ]d <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nnoremap [d <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
nnoremap <leader>dd <Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>
nnoremap <leader>cx <Cmd>call VSCodeNotify('workbench.view.extensions')<CR>
nnoremap ,ac <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
nnoremap <leader>rn :call VSCodeNotify('editor.action.rename')<CR>
nnoremap ,o <Cmd>call VSCodeNotify('editor.action.organizeImports')<CR>
"""""""""""""""""""""""""""""""""""""
" END COC
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START EASY MOTION
"""""""""""""""""""""""""""""""""""""
let g:EasyMotion_smartcase = 1
"""""""""""""""""""""""""""""""""""""
" END EASY MOTION
"""""""""""""""""""""""""""""""""""""

" commentary
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" FOLDS
nnoremap zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
nnoremap zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>

" DEBUGGING
nnoremap <silent> <leader>dS <Cmd>:call VSCodeNotify('workbench.action.debug.start')<CR>
nnoremap <silent> <leader>db <Cmd>:call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>
nnoremap <silent> <leader>dc <Cmd>:call VSCodeNotify('workbench.action.debug.continue')<CR>
nnoremap <silent> <leader>ds <Cmd>:call VSCodeNotify('workbench.action.debug.stepOver')<CR>

augroup MyMiscGroup
  " highlight yank
  " :h lua-highlight
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

if empty(glob('~/.local/share/nvim-vscode/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim-vscode/nvim/site/autoload/plug.vim  --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source ~/.config/nvim-vscode/init-vscode.vim
endif

call plug#begin('~/.local/share/nvim-vscode/nvim/site/autoload')
  Plug 'asvetliakov/vim-easymotion'
  Plug 'tpope/vim-surround'
  Plug 'nelstrom/vim-visual-star-search'
call plug#end()
