" Remap esc
inoremap jk <esc>
inoremap kj <esc>
" Format paragraph (selected or not) to 80 character lines.
nnoremap <Leader>g gqap
xnoremap <Leader>g gqa
" Save file
nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wa :wa<CR>
nnoremap <Leader>wq :wq<cr>
" when you need to make changes to a system file, you can override the
" read-only permissions by typing :w!!, vim will ask for your sudo password
" and save your changes
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
nnoremap <c-h> <C-w>h
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-l> <C-w>l

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
" nnoremap [od :diffthis<cr>
" nnoremap ]od :diffoff<cr>

" create the new directory am already working in
nnoremap ,md :!mkdir -p %:h<cr><cr>
nnoremap ,rm :!trash-put %:p<cr>:bdelete!<cr>
" edit .bashrc file
nnoremap ,. :e ~/.bashrc<CR>
nnoremap <leader>nh :noh<CR>
nnoremap <leader>ee :Vexplore<CR>

let my_config_path =  "~/.config/nvim/init.vim"
" edit init.vim
nnoremap ,ec :execute "e " . g:my_config_path<CR>
" source init.vim
nnoremap ,sc :execute "so " . g:my_config_path <CR>

" TO MOVE LINES up/down
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" EMBEDDED TERMINAL
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

" SEARCH AND REPLACE: NOT VERY GOOD
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
xnoremap <leader>r :%s///g<left><left>
xnoremap <leader>rc :%s///gc<left><left><left>

" toggle cursorcolumn
nnoremap ,tc :set cursorline! cursorcolumn!<CR>

" LINE NUMBERING
set number " always show line numbers
" set relativenumber " set relative numbering as default
set relativenumber " set none relative numbering as default
" toggle relative line number
nmap ,tl :set invrelativenumber<CR>

" RENAME CURRENT FILE
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

" MANAGE BUFFERS
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

" Delete all buffers
nnoremap <leader>ba :call DeleteAllBuffers()<cr>
" Delete current buffer
nnoremap <leader>bd :bd%<cr>
" Delete current buffer force
nnoremap <leader>be :bd!%<cr>
" Wipe current buffer
nnoremap <leader>bw :bw%<cr>

" START FORMAT ELIXIR
function! FormatElixir()
  w
  silent execute "!mix format %:p"
  e %
endfunction
command! FormatElixir call FormatElixir()
nmap <leader>fe  :FormatElixir<CR>            " Format elixir file

" RESIZE WINDOW
nnoremap <A-h> :vertical resize -2<CR>
nnoremap <A-l> :vertical resize +2<CR>
nnoremap <A-u> :resize +2<CR>
nnoremap <A-m> :resize -2<CR>

" START TOGGLE BACKGROUND COLOR
function! BackgroundToggle()
  if(&background == 'dark')
    set background=light
  else
    set background=dark
  endif
endfunc
nnoremap <leader>tb :call BackgroundToggle()<cr>
