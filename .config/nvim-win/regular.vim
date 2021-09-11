" set shell=pwsh.exe

if has("gui_running")
  "so $VIMRUNTIME/mswin.vim
endif

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


" LINE NUMBERING
set number " always show line numbers
" set relative numbering as default
set relativenumber

" Spell check
set spelllang=en
" set spell
" ~/.config/nvim/spell/en.utf-8.add
set spellfile=~/.config/nvim/spell/en.utf-8.add

set foldmethod=indent
set foldnestmax=10
" don't fold by default when opening a file.
set nofoldenable
set foldlevel=2

set completeopt=menuone,noinsert,noselect

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

" COMPLETION
" <c-j> and <c-k> to navigate up and down
inoremap <expr> <C-j> pumvisible() ? "<C-n>" : "<C-j>"
inoremap <expr> <C-k> pumvisible() ? "<C-p>" : "<C-k>"
" <cr> should behave like <c-y>: do not accept and place cursor on next line
inoremap <expr> <CR> pumvisible() ? "<C-y>" : "<CR>"
" right arrow also accepts suggestion
inoremap <expr> <right> pumvisible() ? "<C-y>" : "<right>"

" dos line endings to unix
" https://sourceforge.net/projects/dos2unix
nnoremap ,du :!dos2unix % %<cr>

"""""""""""""""""""""""""""""""""""""
" START NEOFORMAT
"""""""""""""""""""""""""""""""""""""
nnoremap <leader>fc :Neoformat<CR>
nnoremap <leader>N :Neoformat<CR>

" Install binaries for formatting

" javascript, typescript, svelte, graphql, Vue, html, YAML, SCSS, Less, JSON,
" npm install -g prettier prettier-plugin-svelte

" shell
" wget -O $HOME/.local/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.2.4/shfmt_v3.2.4_linux_amd64 && chmod ugo+x $HOME/.local/bin/shfmt

" sjl
" wget -O pgFormatter-5.0.tar.gz \
"   https://github.com/darold/pgFormatter/archive/refs/tags/v5.0.tar.gz && \
"   tar xzf pgFormatter-5.0.tar.gz && \
"   cd pgFormatter-5.0/ && \
"   perl Makefile.PL && \
"   make && sudo make install && \
"   pg_format --version

" SETTINGS
" Shell
let g:shfmt_opt = '-ci'

" jsonc
let g:neoformat_jsonc_prettier = {
  \ 'exe': 'prettier',
  \ 'args': ['--stdin-filepath', '"%:p"', '--parser', 'json'],
  \ 'stdin': 1,
\ }

let g:neoformat_enabled_jsonc = ['prettier']

" format on save
" augroup fmt
"   autocmd!
"   " if file not changed and saved (e.g. to trigger test run), error is thrown: use try/catch to suppress
"   au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
" augroup END
"""""""""""""""""""""""""""""""""""""
" END NEOFORMAT
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START LIGHTLINE
"""""""""""""""""""""""""""""""""""""
let g:lightline = {}

let g:lightline.component_function = {
  \ 'filename': 'LightlineFilename',
\}

let g:lightline.component = {
  \'filename': '%f',
\}

let g:lightline.active = {
  \'left': [
      \[
          \'mode',
          \'paste'
      \],
      \[
          \'readonly',
          \'filename',
          \'modified',
      \]
  \],
\}

let g:lightline.tab_component_function = {
  \ 'filename_active': 'LightlineFilenameTab',
\}

let g:lightline.tab = {
  \ 'active': [
      \ 'tabnum',
      \ 'filename',
      \ 'modified'
  \],
  \ 'inactive': [
      \ 'tabnum',
      \ 'filename_active',
      \ 'modified'
  \],
\}

function! LightlineFilename()
  return luaeval('require("util").get_file_name(2)')
endfunction

function! LightlineFilenameTab(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let filename = expand('#'.buflist[winnr - 1].':f')
  let sf = substitute(filename, '\', '/', 'g')
  let lua_func = 'require("util").get_file_name("' . sf . '")'
  return luaeval(lua_func)
endfunction
"""""""""""""""""""""""""""""""""""""
" END LIGHTLINE
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START VIM-MAXIMIZER
"""""""""""""""""""""""""""""""""""""
let g:maximizer_set_default_mapping = 0

nnoremap mm :MaximizerToggle!<CR>
"""""""""""""""""""""""""""""""""""""
" END VIM-MAXIMIZER
"""""""""""""""""""""""""""""""""""""

augroup MyMiscGroupRegular
  au!

  " Trim whitespace
  au BufWritePre * %s/\s\+$//e
  au BufWritePre * %s/\n\+\%$//e
  au BufWritePre *.[ch] *.[ch] %s/\%$/\r/e
  " autocmd FileType help wincmd H
  " autocmd! FileType json set filetype=jsonc
  autocmd! FileType vifm set filetype=vim
  au BufNewFile,BufRead *.html.django set filetype=htmldjango
  au BufNewFile,BufRead *.eslintrc set filetype=json
  au BufNewFile,BufRead *.code-snippets set filetype=json
  " au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set filetype=jinja
  au BufNewFile,BufRead .env* set filetype=sh
  au BufNewFile,BufRead *.psql set filetype=sql
  au BufNewFile,BufRead Dockerfile* set filetype=dockerfile
  au BufNewFile,BufRead *config set filetype=gitconfig
augroup END

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

" MANAGE BUFFERS
" https://tech.serhatteker.com/post/2020-06/how-to-delete-multiple-buffers-in-vim/
function! DeleteAllBuffers(f) abort
  let index = 1
  let last_b_num = bufnr("$")
  let normal_buffers = []
  let terminal_buffers = []
  let no_name_buffers = []

  while index <= last_b_num
    let b_name = bufname(index)
    if bufexists(index)
      if  (b_name == '' )
        call add(no_name_buffers, index)
      endif

      if a:f == 'a'
        if  (b_name =~ 'term://')
          call add(terminal_buffers, index)
        else
          call add(normal_buffers, index)
        endif
     endif
    endif
    let index += 1
  endwhile

  if len(no_name_buffers) > 0
    silent execute 'bwipeout! '.join(no_name_buffers)
  endif

  if len(terminal_buffers) > 0
    silent execute 'bwipeout! '.join(terminal_buffers)
  endif

  if len(normal_buffers) > 0
    silent execute 'bd ' .join(normal_buffers)
  endif
endfunction

" https://github.com/clarke/vim-renumber
function! Renumber() range
  let n=1

  " E486 Pattern not found
  for linenum in range(a:firstline, a:lastline)
    try
      " execute linenum . 's/\([\s\t])\d\+/' . n . '/'
      execute linenum . 's/^\([ 	]\+\)\?\([0-9]\+\)/\1' . n . '/'
      let n=n+1
    catch "Pattern not found"
      " Skipping lines that don't match our pattern
    endtry
  endfor
endfunction

"""""""""""""""""""""""""""""""""""""
" START THEME
"""""""""""""""""""""""""""""""""""""
set background=light
colorscheme solarized8
"""""""""""""""""""""""""""""""""""""
" END THEME
"""""""""""""""""""""""""""""""""""""
