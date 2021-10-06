source $VIMRUNTIME/mswin.vim
GuiFont! Cascadia\ Mono:h12
call GuiWindowMaximized(1)

let s:ismaximised = 0
function! MaximizeToggle()
  let s:ismaximised = !s:ismaximised
  call GuiWindowFullScreen(s:ismaximised)
endfunction

nnoremap <F11> :call MaximizeToggle()<CR>
let g:can_use_coc = 1
let $FZF_DEFAULT_OPTS="--layout=reverse --border"


" Use neovim terminal UI for tabs instead of Qt. This is to allow
" lightline work properly for tab titles.
:GuiTabline 0

"""""""""""""""""""""""""""""""""""""
" START THEME
"""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme one
"""""""""""""""""""""""""""""""""""""
" END THEME
"""""""""""""""""""""""""""""""""""""

so ~\AppData\Local\nvim\lightline.vim
so ~\AppData\Local\nvim\functions.vim

if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility with HiDPI hints...
    " if g:fvim_os == 'windows' || g:fvim_render_scale > 1.0
    "   set guifont=Iosevka\ Slab:h14
    " else
    "   set guifont=Iosevka\ Slab:h28
    " endif

    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
endif

let g:python3_host_prog = '~\.pyenv\pyenv-win\versions\3.9.6\python.exe\'

" https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
" Always show in tree view
let g:netrw_liststyle = 3

" Open file by default in new tab
" let g:netrw_browse_split = 3
let g:netrw_list_hide= '.*\.swp$,.*\.pyc'

" Keep the current directory and the browsing directory synced. This helps you
" avoid the move files error. --- I think without this setting, if you try to
" move file from one directory to another, vim will error. This setting
" prevents this error - setting always changing pwd, which breaks some plugins
" let g:netrw_keepdir = 0

" let g:netrw_winsize = 30
let g:netrw_banner = 0
" Change the copy command. Mostly to enable recursive copy of directories.
let g:netrw_localcopydircmd = 'cp -r'

" Highlight marked files in the same way search matches are. - seems to make
" no difference.
" hi! link netrwMarkFile Search

let g:markdown_fenced_languages = [
  \ 'html',
  \ 'python',
  \ 'bash=sh',
  \ 'lua',
  \ 'vim',
  \ 'help',
  \ 'javascript',
  \ 'typescript',
  \ 'css',
  \ 'dart',
\]

syntax enable
" turn on detection for ftplugin/<filetype.vim>,indent/<filetype>.vim
filetype plugin on

" Spell check
set spelllang=en
" set spell
" ~/.config/nvim/spell/en.utf-8.add
" set spellfile=~/.config/nvim/spell/en.utf-8.add

set foldmethod=indent
set foldnestmax=10
" don't fold by default when opening a file.
set nofoldenable
set foldlevel=2

" autocompletion
set complete+=kspell
set completeopt-=preview
set completeopt+=menuone,longest,noselect

" reload a file if it is changed from outside vim
set autoread
set noswapfile

" LINE NUMBERING
set number " always show line numbers
" set relative numbering as default
set relativenumber

augroup MyGvimMiscGroup
  au!
  au FocusGained * checktime

  " Trim whitespace
  au BufWritePre * %s/\s\+$//e
  au BufWritePre * %s/\n\+\%$//e
  au BufWritePre *.[ch] *.[ch] %s/\%$/\r/e
  " autocmd FileType help wincmd H
augroup END

augroup filetypes
  au!
  " autocmd! FileType json set filetype=jsonc
  autocmd! FileType vifm set filetype=vim
  " autocmd! FileType mysql set filetype=sql
  au BufNewFile,BufRead *.html.django set filetype=htmldjango
  au BufNewFile,BufRead *.eslintrc set filetype=json
  au BufNewFile,BufRead *.code-snippets set filetype=json
  au BufNewFile,BufRead *.code-workspace set filetype=json
  au BufNewFile,BufRead .babelrc set filetype=json
  " au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set filetype=jinja
  au BufNewFile,BufRead .env* set filetype=sh
  au BufNewFile,BufRead *.psql set filetype=sql
  au BufNewFile,BufRead Dockerfile* set filetype=dockerfile
  au BufNewFile,BufRead *config set filetype=gitconfig
augroup END

augroup terminal_settings
  autocmd!

  " start terminal in insert mode
  autocmd TermOpen * startinsert
augroup END

" Save file
nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wa :wa<CR>
nnoremap <Leader>wq :wq<cr>

" Quit vim
inoremap <C-Q>     <esc>:q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>qq :q<cr>
nnoremap <Leader>qf :q!<cr>
nnoremap <Leader>qa :qa<cr>
nnoremap <Leader>qF :qa!<cr>

" TABS
" Move between windows in a tab
nmap <tab> <C-w>w
nnoremap <c-h> <C-w>h
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-l> <C-w>l
" split windows
" split window bottom
" nnoremap <silent> <leader>th :split<CR>
" split window right
" nnoremap <silent> <leader>tv :vsp<CR>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>ts :tab split<cr>
nnoremap ,tc :tabclose<CR>

" Reorder tabs
noremap <A-Left>  :-tabmove<cr>
noremap <A-Right> :+tabmove<cr>

" RESIZE WINDOW
nnoremap <c-left> :vertical resize -2<CR>
nnoremap <c-right> :vertical resize +2<CR>
nnoremap <c-up> :resize +2<CR>
nnoremap <c-down> :resize -2<CR>

" QuickFix and Location list
nnoremap <leader>lc :lclose<CR>
nnoremap yoq :cclose<cr>

" create the new directory am already working in
nnoremap ,md :!mkdir -p %:h<cr><cr>
nnoremap ,rm :!pwsh.exe -Command rm %:p<cr>:bdelete!<cr>
" edit .bashrc file
nnoremap ,. :e ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1<CR>
nnoremap <c-E> :Vexplore<CR>

" edit init.vim
nnoremap ,ec :e $MYVIMRC<CR>
" source init.vim
nnoremap ,sc :so $MYVIMRC<CR>
" source lua file
nnoremap ,sl :luafile %<CR>
" Check file in shellcheck
" nnoremap <leader>sc, :!clear && shellcheck -x %<CR>

" TO MOVE LINES up/down
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" TERMINAL
" start terminal in insert mode
autocmd TermOpen * startinsert
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <A-r> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
" exit insert mode
tnoremap <ESC><ESC> <C-\><C-n>
" launch terminal in new spit
nnoremap <leader>tt :tab split<cr> :term pwsh.exe<cr>
nnoremap <leader>tv :vsplit<cr> :term /usr/bin/fish<cr>

" COPY FILE PATH
" yank relative File path
nmap ,yr :let @+=expand("%")<CR>
" yank file name / not path
nmap ,yn :let @+=expand("%:t")<CR>
" yank file parent directory
nmap ,yd :let @+=expand("%:p:h")<CR>
" yank absolute File path
nmap ,yf :let @+=expand("%:p")<CR>
" copy relative path
nmap ,cr :let @"=expand("%")<CR>
" copy absolute path
nmap ,cf :let @"=expand("%:p")<CR>

" Some plugins change my CWD to currently opened file - I change it back
nnoremap <leader>cd
  \ :let @s=expand("%:p:h")<CR>
  \ :cd <C-r>s

nnoremap <leader>wd :pwd<CR>

" SEARCH AND REPLACE
" remove highlight from search term
nnoremap <leader>nh :noh<cr>
" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn
"find and replace in file
" press * {shift 8) to search for word under cursor and key combo below to
" replace in entire file
nnoremap <leader>rr :%s///g<left><left>
nnoremap <leader>rc :%s///gc<left><left><left>
" same as above but only visually selected range
xnoremap <leader>rr :%s///g<left><left>
xnoremap <leader>rc :%s///gc<left><left><left>
" Search for the strings using `fzf`, press <tab> to select multiple (<s-tab> to deselect) and <cr> to populate QuickFix list
" After searching for strings, press this mapping to do a project wide find and
" replace. It's similar to <leader>r except this one applies to all matches
" across all files instead of just the current file.
nnoremap <Leader>RR :cfdo %s///g \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" The same as above except it works with a visual selection.
xmap <Leader>RR :cfdo %s/<C-r>s//g \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" BUFFERS
" Delete all buffers
nnoremap <leader>bA :call DeleteAllBuffers('a')<cr>
" Delete empty buffers - not working
nnoremap <leader>be :call DeleteAllBuffers('e')<cr>
" Delete current buffer
nnoremap <leader>bd :bd%<cr>:call DeleteAllBuffers('e')<CR>
" Delete current buffer force
nnoremap <leader>bD :bd!%<cr>:call DeleteAllBuffers('e')<CR>
" Wipe current buffer
nnoremap <leader>bw :bw%<cr>:call DeleteAllBuffers('e')<CR>
" go to buffer number - use like so gb34
nnoremap <leader>bl :VMessage ls<CR>
map <leader>bn :call RenameFile()<cr>

" dos line endings to unix
" https://sourceforge.net/projects/dos2unix
nnoremap ,du :!dos2unix % %<cr>

so ~\AppData\Local\nvim\fugitive.vim
so ~\AppData\Local\nvim\fzf.vim
so ~\AppData\Local\nvim\neoformat.vim
so ~\AppData\Local\nvim\coc.vim
so ~\AppData\Local\nvim\floaterm.vim

"""""""""""""""""""""""""""""""""""""
" START EASY MOTION
"""""""""""""""""""""""""""""""""""""
let g:EasyMotion_smartcase = 1

nmap <leader>2 <Plug>(easymotion-overwin-f2)
"""""""""""""""""""""""""""""""""""""
" END EASY MOTION
"""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""
" START VIM-MAXIMIZER
"""""""""""""""""""""""""""""""""""""
nnoremap mm :MaximizerToggle!<CR>
xnoremap mm :MaximizerToggle!<CR>
"""""""""""""""""""""""""""""""""""""
" END VIM-MAXIMIZER
"""""""""""""""""""""""""""""""""""""

so ~\AppData\Local\nvim\vcoolor.vim
so ~\AppData\Local\nvim\vimspector.vim
