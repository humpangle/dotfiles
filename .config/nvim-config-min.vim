nnoremap <Space> <Nop>
let mapleader=" "
let g:netrw_liststyle = 3
set splitright
set splitbelow
set smartcase
set ignorecase
set incsearch
set hlsearch
set number
set relativenumber
set hidden
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set encoding=utf8
set mouse=a
set autoread
set noswapfile
set undofile
set cc=80
set cursorline
augroup MyMiscGroup
  au!
  " Trim whitespace
  au BufWritePre * %s/\s\+$//e
  au BufWritePre * %s/\n\+\%$//e
  au BufWritePre *.[ch] *.[ch] %s/\%$/\r/e
augroup END
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
nmap <leader>Y "+y
vmap <leader>Y "+y
nmap <leader>x "+x
vmap <leader>x "+x
nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wa :wa<CR>
nnoremap <Leader>wq :wq<cr>
nnoremap <Leader>qq :q<cr>
nnoremap <Leader>qf :q!<cr>
nnoremap <Leader>qa :qa<cr>
nnoremap <Leader>qF :qa!<cr>
vnoremap < <gv
vnoremap > >gv
nmap <tab> <C-w>w
nnoremap <c-h> <C-w>h
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-l> <C-w>l
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>ts :tab split<cr>
nnoremap ,tc :tabclose<CR>
nnoremap <c-left> :vertical resize -2<CR>
nnoremap <c-right> :vertical resize +2<CR>
nnoremap <c-up> :resize +2<CR>
nnoremap <c-down> :resize -2<CR>
nnoremap ,md :!mkdir -p %:h<cr><cr>
nnoremap ,rm :!rm %:p<cr>:bdelete!<cr>
nnoremap <leader>ee :Vexplore<CR>
nnoremap ,ec :e $MYVIMRC<CR>
nnoremap ,sc :so $MYVIMRC<CR>
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
autocmd TermOpen * startinsert
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <A-r> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nmap ,yr :let @+=expand("%")<CR>
nmap ,yn :let @+=expand("%:t")<CR>
nmap ,yd :let @+=expand("%:p:h")<CR>
nnoremap <leader>nh :noh<cr>
nnoremap <leader>rr :%s///g<left><left>
nnoremap <leader>bd :bd%<cr>
nnoremap <leader>bD :bd!%<cr>
nnoremap <leader>bw :bw%<cr>
nnoremap <leader>bl :ls<CR>:b
map <leader>bn :call RenameFile()<cr>

" alias md='mkdir -p '
" alias vim=nvim
" alias svim='sudo nvim -u ~/.config/nvim/init.vim'
" alias eshell='exec $SHELL'
" # tmux
" alias ta='tmux a -t'
" alias tls='tmux ls'
" alias tn='tmux new -s '
" alias tks='tmux kill-session -t'
" alias tkss='tmux kill-server'
" alias ts='$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh'
" alias trs='$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh'
