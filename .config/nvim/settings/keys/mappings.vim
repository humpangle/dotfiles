" Format paragraph (selected or not) to 80 character lines.
nnoremap <Leader>g gqap
xnoremap <Leader>g gqa
" Vim’s :help documentation
nmap <Leader>H :Helptags!<CR>
" Save file
nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wa :wa<CR>
nnoremap <Leader>wq :wq<cr>
" Save non user file i.e. file that requires root permission by typing :w!!
" NOTE: you may need to install a utility such as `askpass` in order to input
" password. On ubuntu, run:
" sudo apt install ssh-askpass-gnome ssh-askpass -y && \
"  echo "export SUDO_ASKPASS=$(which ssh-askpass)" >> ~/.bashrc
cmap w!! w !sudo tee > /dev/null %

" Quit vim
inoremap <C-Q>     <esc>:q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>qq :q<cr>
nnoremap <Leader>qf :q!<cr>
nnoremap <Leader>qa :qa<cr>
nnoremap <Leader>qF :qa!<cr>

" better code indentations in visual mode.
vnoremap < <gv
vnoremap > >gv

" yank / Copy and paste from system clipboard (Might require xclip install)
vmap <Leader>Y "+y
vmap <Leader>x "+x
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
" go to buffer number - use like so gb34
nnoremap gb :ls<CR>:b
" Move between windows in a tab
nmap <tab> <C-w>w
" nnoremap ,h <C-w>h
" nnoremap ,j <C-w>j
" nnoremap ,k <C-w>k
" nnoremap ,l <C-w>l

" Go to tab by number
" noremap <leader>1 1gt
" noremap <leader>2 2gt
" noremap <leader>3 3gt
" noremap <leader>4 4gt
" noremap <leader>5 5gt
" noremap <leader>6 6gt
" noremap <leader>7 7gt
" noremap <leader>8 8gt
" noremap <leader>9 9gt
" nnoremap <silent> <leader>_ :split<CR> " split window bottom
" nnoremap <silent> <leader>\| :vsp<CR> " split window right
" nnoremap <silent> <leader>0 :only<CR> " remove all but current window
" nnoremap <leader>tn :tabnew<cr> " new tab
" nnoremap <leader>ts :tab split<cr>

" mappings in unimpaired.vim
" nnoremap [od :diffthis<cr> " diff this add file to diffs
" nnoremap ]od :diffoff<cr> " remove file from diffs

" create the new directory am already working in
nnoremap ,md :!mkdir -p %:h<cr><cr> " mkdir - create directory
nnoremap ,rm :!trash-put %:p<cr>:bdelete!<cr>
nnoremap ,. :e ~/.bashrc<CR>  " edit .bashrc file
nnoremap <leader>nh :noh<CR> " no highlight
nnoremap <leader>ee :Vexplore<CR>

let my_config_path =  "~/.config/nvim/init.vim"
" edit init.vim
nnoremap ,ec :execute "e " . g:my_config_path<CR>
" source init.vim
nnoremap ,sc :execute "so " . g:my_config_path <CR>

"""""""""""""""""""""""""""""""""""""
" TO MOVE LINES
"""""""""""""""""""""""""""""""""""""
nnoremap <A-k> :m .-2<CR>==                   " Move line up normal mode
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi            " Move line up insert mode
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv               " Move line up visual mode
vnoremap <A-k> :m '<-2<CR>gv=gv
"""""""""""""""""""""""""""""""""""""
" END TO MOVE LINES
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" EMBEDDED TERMINAL
"""""""""""""""""""""""""""""""""""""
" launch terminal
" nnoremap ,tn :term<cr>
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <A-r> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

" exit insert mode
" tnoremap <A-e> <C-\><C-n>
"""""""""""""""""""""""""""""""""""""
" END EMBEDDED TERMINAL
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" COPY FILE PATH
"""""""""""""""""""""""""""""""""""""
nmap ,yr :let @+=expand("%")<CR>      " yank relative File path
nmap ,yn :let @+=expand("%:t")<CR>    " yank file name / not path
nmap ,yd :let @+=expand("%:p:h")<CR>  " yank file parent directory
nmap ,yf :let @+=expand("%:p")<CR>    " yank absolute File path
nmap ,cr :let @"=expand("%")<CR>      " copy relative path
nmap ,cf :let @"=expand("%:p")<CR>    " copy absolute path
"""""""""""""""""""""""""""""""""""""
" END COPY FILE PATH
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" SEARCH AND REPLACE: NOT VERY GOOD
"""""""""""""""""""""""""""""""""""""
" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn

""""""""""""""""" find and replace in file """""""""""""""""""""""""""""""""
" press * {shift 8) to search for word under cursor and key combo below to
" replace in entire file
nnoremap <leader>rr :%s///g<left><left>
nnoremap <leader>rc :%s///gc<left><left><left>

" same as above but only visually selected range
xnoremap <leader>r :%s///g<left><left>
xnoremap <leader>rc :%s///gc<left><left><left>
"""""""""""""""""""""""""""""""""""""
" END SEARCH AND REPLACE
"""""""""""""""""""""""""""""""""""""

" toggle cursorcolumn
nnoremap ,tc :set cursorline! cursorcolumn!<CR>

"""""""""""""""""""""""""""""""""""""
" LINE NUMBERING
"""""""""""""""""""""""""""""""""""""
set number " always show line numbers
" set relativenumber " set relative numbering as default
set relativenumber " set none relative numbering as default

" toggle relative line number
nmap ,tl :set invrelativenumber<CR>
"""""""""""""""""""""""""""""""""""""
" END LINE NUMBERING
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
"""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

map <leader>nf :call RenameFile()<cr>
"""""""""""""""""""""""""""""""""""""
" END RENAME CURRENT FILE
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" MANAGE BUFFERS
"""""""""""""""""""""""""""""""""""""
"https://tech.serhatteker.com/post/2020-06/how-to-delete-multiple-buffers-in-vim/
function! DeleteAllBuffers() abort
  let [i, last_b_num, regular, terminals] = [1, bufnr("$"), [], []]
  while i <= last_b_num
    let b_name = bufname(i)
    if bufexists(i)
      if  (b_name == '' || b_name =~ 'term://')
        call add(terminals, i)
      else
        call add(regular, i)
      endif
    endif
    let i += 1
  endwhile
  if len(terminals) > 0
    let cmd = 'bwipeout! '.join(terminals)
    exe cmd
  endif
  if len(regular) > 0
    let delete_cmd = 'bd ' .join(regular)
    exe delete_cmd
  endif
endfunction

map <leader>ba :call DeleteAllBuffers()<cr>   " Delete all buffers
map <leader>bd :bd%<cr>                       " Delete current buffer
map <leader>be :bd!%<cr>                      " Delete current buffer force
map <leader>bw :bw%<cr>                       " Wipe current buffer
"""""""""""""""""""""""""""""""""""""
" END MANAGE BUFFERS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START FORMAT ELIXIR
"""""""""""""""""""""""""""""""""""""
function! FormatElixir()
  w
  silent execute "!mix format %:p"
  e %
endfunction
command! FormatElixir call FormatElixir()
nmap <leader>fe  :FormatElixir<CR>            " Format elixir file
"""""""""""""""""""""""""""""""""""""
" END FORMAT ELIXIR
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" RESIZE WINDOW
"""""""""""""""""""""""""""""""""""""
nnoremap <A-h> :vertical resize -2<CR>
nnoremap <A-l> :vertical resize +2<CR>
nnoremap <A-u> :resize +2<CR>
nnoremap <A-m> :resize -2<CR>
"""""""""""""""""""""""""""""""""""""
" END RESIZE WINDOW
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" AUTOCMD
"""""""""""""""""""""""""""""""""""""
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
"""""""""""""""""""""""""""""""""""""
" END AUTOCMD
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START TOGGLE BACKGROUND COLOR
"""""""""""""""""""""""""""""""""""""
function! BackgroundToggle()
  if(&background == 'dark')
    set background=light
  else
    set background=dark
  endif
endfunc
nnoremap <leader>tb :call BackgroundToggle()<cr>
"""""""""""""""""""""""""""""""""""""
" END TOGGLE BACKGROUND COLOR
"""""""""""""""""""""""""""""""""""""
