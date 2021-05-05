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

" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

nnoremap <leader>nh :noh<CR>
" Save file/Quit
nnoremap <Leader>ww :Write<CR>
nnoremap <Leader>wa :Wall<CR>
nnoremap <silent> <Leader>wq :Wq<cr>
nnoremap <leader>qq <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <leader>qq <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

" nnoremap <silent> <leader>ba :call VSCodeNotify('openEditors.closeAll')<cr>
nnoremap <silent> <leader>ba :call VSCodeNotify('workbench.action.closeOtherEditors')<cr>
nnoremap <silent> <leader>bd :call VSCodeNotify('workbench.action.closeActiveEditor')<cr>
nnoremap ,rm :call VSCodeNotify('deleteFile')<cr>
nnoremap <silent> <leader>ee :call VSCodeNotify('workbench.files.action.focusFilesExplorer')<CR>
nnoremap <silent> <leader>ff :call VSCodeNotify('workbench.action.quickOpen')<CR>

nnoremap <leader>fc <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>
nnoremap <leader>dd <Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>
nnoremap ,ac <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>

nnoremap ,o <Cmd>call VSCodeNotify('editor.action.organizeImports')<CR>

nnoremap ]d <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nnoremap [d <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>

nnoremap ,yf <Cmd>call VSCodeNotify('copyFilePath')<CR>

" yank / Copy and paste from system clipboard (Might require xclip install)
vmap <Leader>Y "+y
vmap <Leader>x "+x
nmap <Leader>x "+x
nmap <Leader>P "+P
vmap <Leader>P "+P

nnoremap <c-left> :call VSCodeNotify('workbench.action.increaseViewSize')<CR>
nnoremap <c-right> :call VSCodeNotify('workbench.action.decreaseViewSize')<CR>

" commentary
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" Better Navigation
nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

" easy motion
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

if empty(glob('~/.local/share/nvim-vscode/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim-vscode/nvim/site/autoload/plug.vim  --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source ~/.config/nvim-vscode/init-vscode.vim
endif

call plug#begin('~/.local/share/nvim-vscode/nvim/site/autoload')
  Plug 'asvetliakov/vim-easymotion'
  Plug 'tpope/vim-surround'
call plug#end()
