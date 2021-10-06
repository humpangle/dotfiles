let g:python3_host_prog = expand('$PYTHON3')

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
  \ 'vue',
  \ 'dart',
\]

syntax enable
" turn on detection for ftplugin/<filetype.vim>,indent/<filetype>.vim
filetype plugin on

if (has("termguicolors"))
 set termguicolors
endif

" Many plugins require update time shorter than default of 4000ms
set updatetime=100
" which-key plugin appears more quickly
set timeoutlen=500
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

" Tab Splits
set splitbelow
set splitright
set mouse=a

" autocompletion
set complete+=kspell
set completeopt-=preview
set completeopt+=menuone,longest,noselect

" I disabled both because they were distracting and slow (according to docs)
set cursorline " highlight cursor positions
" set cursorcolumn

" Spell check
set spelllang=en
" set spell
" ~/.config/nvim/spell/en.utf-7.add
set spellfile=~/.config/nvim/spell/en.utf-8.add

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

" LINE NUMBERING
set number " always show line numbers
" set relative numbering as default
set relativenumber

" Use Ripgrep for vimgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" START NATIVE FUZZY FIND SETTINGS
" set nocompatible " Limit search to project directory
" set path+=** " Search all subdirectories recursively
" set wildmenu " Show multiple matches on one line
" Search ignore path
" set wildignore+=*.zip,*.png,*.jpg,*.gif,*.pdf,*DS_Store*,*/.git/*,*/node_modules/*,*/build/*,package-lock.json,*/_build/*,*/deps/*,*/elixir_ls/*,yarn.lock,mix.lock,*/coverage/*

augroup MyMiscGroup
  au!
  au FocusGained * checktime

  " highlight yank
  " :h lua-highlight
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }

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
  " autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd TermOpen * startinsert
  " autocmd BufLeave term://* stopinsert

  " Ignore various filetypes as those will close terminal automatically
  " Ignore fzf, ranger, coc
  " autocmd TermClose term://*
  "   \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
  "   \   call nvim_input('<CR>')  |
  "   \ endif
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

" https://stackoverflow.com/a/2573758
function! RedirMessages(msgcmd, destcmd)
    " redir_messages.vim
    "
    " Inspired by the TabMessage function/command combo found
    " at <http://www.jukie.net/~bart/conf/vimrc>.
    "

    "
    " Captures the output generated by executing a:msgcmd, then places this
    " output in the current buffer.
    "
    " If the a:destcmd parameter is not empty, a:destcmd is executed
    " before the output is put into the buffer. This can be used to open a
    " new window, new tab, etc., before :put'ing the output into the
    " destination buffer.
    "
    " Examples:
    "
    "   " Insert the output of :registers into the current buffer.
    "   call RedirMessages('registers', '')
    "
    "   " Output :registers into the buffer of a new window.
    "   call RedirMessages('registers', 'new')
    "
    "   " Output :registers into a new vertically-split window.
    "   call RedirMessages('registers', 'vnew')
    "
    "   " Output :registers to a new tab.
    "   call RedirMessages('registers', 'tabnew')
    "
    " Commands for common cases are defined immediately after the
    " function; see below.
    "
    " Redirect messages to a variable.
    "
    redir => message

    " Execute the specified Ex command, capturing any messages
    " that it generates into the message variable.
    "
    silent execute a:msgcmd

    " Turn off redirection.
    "
    redir END

    " If a destination-generating command was specified, execute it to
    " open the destination. (This is usually something like :tabnew or
    " :new, but can be any Ex command.)
    "
    " If no command is provided, output will be placed in the current
    " buffer.
    "
    if strlen(a:destcmd) " destcmd is not an empty string
        silent execute a:destcmd
    endif

    " Place the messages in the destination buffer.
    "
    silent put=message
endfunction
" Create commands to make RedirMessages() easier to use interactively.
" Here are some examples of their use:
"
"   :BufMessage registers
"   :WinMessage ls
"   :TabMessage echo "Key mappings for Control+A:" | map <C-A>
"
command! -nargs=+ -complete=command BufMessage call RedirMessages(<q-args>, ''       )
command! -nargs=+ -complete=command WinMessage call RedirMessages(<q-args>, 'new'    )
command! -nargs=+ -complete=command TabMessage call RedirMessages(<q-args>, 'tabnew' )
command! -nargs=+ -complete=command VMessage call RedirMessages(<q-args>, 'vnew' )

" end redir_messages.vim

"""""""""""""""""""""""""""""""""""""
" START LIGHTLINE
"""""""""""""""""""""""""""""""""""""
let g:lightline = {}

let g:lightline.component_function = {
  \'fugitive': 'LightlineFugitive',
  \ 'filename': 'LightlineFilename',
  \ 'coc_status': 'LightlineCocStatus',
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
          \'fugitive',
          \'readonly',
          \'filename',
          \'modified',
      \],
      \[
          \'coc_status'
      \],
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

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? branch : ''
  endif
  return ''
endfunction

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

function! LightlineCocStatus() abort
  if winwidth(0) < 60
    return ''
  endif

  return coc#status()
endfunction

"""""""""""""""""""""""""""""""""""""
" END LIGHTLINE
"""""""""""""""""""""""""""""""""""""
