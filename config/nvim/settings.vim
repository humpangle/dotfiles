" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

"{{ Builtin variables
" Disable Python2 support
let g:loaded_python_provider = 0

" Disable perl provider
let g:loaded_perl_provider = 0

" Disable ruby provider
let g:loaded_ruby_provider = 0

" Disable node provider
let g:loaded_node_provider = 0

let g:python3_host_prog = expand('$PYTHON3')

" https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
" Always show in tree view
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

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

" Line numbering
let g:netrw_bufsettings = 'noma nomod rnu nobl nowrap ro'

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
  \ 'elixir',
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
" set hidden " close unsaved buffer with 'q' without needing 'q!' - now the
" default in nvim 0.6.0
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

" autocompletion
set complete+=kspell
set completeopt-=preview
set completeopt+=menuone,longest,noselect

" I disabled both because they were distracting and slow (according to docs)
set cursorline " highlight cursor positions
" set cursorcolumn

" Spell check
set spelllang=en
set nospell
" Don't underline first word of a sentence that is not capitalized
set spellcapcheck=
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
  autocmd! FileType json set filetype=jsonc
  autocmd! FileType vifm set filetype=vim
  " autocmd! FileType mysql set filetype=sql
  au BufNewFile,BufRead *.html.django set filetype=htmldjango
  au BufNewFile,BufRead *.eslintrc set filetype=json
  au BufNewFile,BufRead *.code-snippets set filetype=json
  au BufNewFile,BufRead *.code-workspace set filetype=json
  au BufNewFile,BufRead .babelrc set filetype=json
  au BufNewFile,BufRead .env* set filetype=sh
  au BufNewFile,BufRead *.psql set filetype=sql
  au BufNewFile,BufRead Dockerfile* set filetype=dockerfile
  au BufNewFile,BufRead *.docker set filetype=dockerfile
  au BufNewFile,BufRead *config set filetype=gitconfig
  au BufRead,BufNewFile *.heex,*.leex,*.sface,*.lexs set filetype=eelixir
  au BufNewFile,BufRead rebar.config,*/src/*.app.src set filetype=erlang
  au BufNewFile,BufRead erlang_ls.config set filetype=yaml
  au BufNewFile,BufRead *.service set filetype=systemd
  " autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()

  autocmd FileType eelixir nnoremap <buffer> <leader>fc :w! %<cr>:!mix format %<CR><cr>
  autocmd FileType eelixir nnoremap <buffer> <leader>N :w! %<cr>:!mix format %<CR><cr>
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

" Save key strokes (now we do not need to press shift to enter command mode).
" Vim-sneak has also mapped `;`, so using the below mapping will break the map
" used by vim-sneak
" nnoremap ; :
" xnoremap ; :

" format paragraphs/lines to 80 chars
nnoremap <Leader>pp gqap
xnoremap <Leader>pp gqa
xnoremap <Leader>pn :call Renumber()<CR>
" Save file
nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wa :wa<CR>
nnoremap <Leader>wq :wq<cr>
nnoremap <Leader>w! :w!<cr>
" when you need to make changes to a system file, you can override the
" read-only permissions by typing :w!!, vim will ask for your sudo password
" and save your changes
" NOTE: you may need to install a utility such as `askpass` in order to input
" password. On ubuntu, run:
" sudo apt install ssh-askpass-gnome ssh-askpass -y && \
"  echo "export SUDO_ASKPASS=$(which ssh-askpass)" >> ~/.bashrc
cmap ,, w !sudo tee > /dev/null %<CR>

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
nmap <Leader>x "+x
nmap <Leader>P "+P
vmap <Leader>P "+P
" Yank all
nnoremap <Leader>ya ggVG"+y

" https://vi.stackexchange.com/a/17757
" To share register between editor instances
" Write shada
nnoremap ,ws :wsh<cr>
" Read shada
nnoremap ,rs :rsh<cr>

" TABS
" Move between windows in a tab
nmap <tab> <C-w>w
nnoremap <c-h> <C-w>h
" use <c-b>
" inoremap <c-h> <Left>
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-l> <C-w>l
" use <c-f>
" inoremap <c-l> <Right>
" split windows
" split window bottom
" nnoremap <silent> <leader>th :split<CR>
" split window right
" nnoremap <silent> <leader>tv :vsp<CR>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>ts :tab split<cr>
nnoremap ,tc :tabclose<CR>
nnoremap ,vn :vnew<cr>
nnoremap ,sn :new<cr>

" Reorder tabs
noremap <A-Left>  :-tabmove<cr>
noremap <A-Right> :+tabmove<cr>

" Switch between last active and current tab
" https://stackoverflow.com/a/2120168
if !exists('g:lasttab')
  let g:lasttab = 1
endif
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" RESIZE WINDOW
nnoremap <c-left> :vertical resize -2<CR>
nnoremap <c-right> :vertical resize +2<CR>
nnoremap <c-up> :resize +2<CR>
nnoremap <c-down> :resize -2<CR>

" QuickFix and Location list
nnoremap yol :lclose<CR>
nnoremap yoq :cclose<cr>

nnoremap <leader>% :e %<CR>

" create the new directory am already working in
nnoremap ,md :!mkdir -p %:h<cr>
" edit .bashrc file
nnoremap ,. :tab split<cr>:e ~/.bashrc<CR>

" Netrw
" https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/

function! NetrwMapping()
  nmap <buffer> <c-E> :Vexplore<CR>
  " Show a list of marked files.
  nmap <buffer> fl :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
  autocmd BufEnter * if strlen(&ft) < 1 | call NetrwMapping()
augroup END

" Open Netrw in current working directory
nnoremap <c-E>
  \ :let @s=getcwd()<cr>
  \ :Vexplore <c-r>s<CR>

" Open Netrw in current file's directory
nnoremap <leader>dd :Lexplore %:p:h<CR>

" END Netrw

" edit init.vim
nnoremap ,ec :tab split<cr>:e $MYVIMRC<CR>
" source init.vim
nnoremap ,sc :so $MYVIMRC<CR>
" source lua file
nnoremap ,ss :source %<CR>
" Check file in shellcheck
" nnoremap <leader>sc, :!clear && shellcheck -x %<CR>

" TO MOVE LINES up/down
" Use unimpaired's [e and ]e
" nnoremap <A-k> :m .-2<CR>==
" nnoremap <A-j> :m .+1<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv

" TERMINAL
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <A-r> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
" exit insert mode
" tnoremap <ESC><ESC> <C-\><C-n>
" launch terminal in new spit
nnoremap <leader>tt :tab split<cr>:term <right>
nnoremap <leader>tv :vsplit<cr>:term <right>

" Clear terminal buffer: https://superuser.com/a/1485854
nnoremap <c-w><c-l> :call ClearTerminal()<cr>

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
nmap ,cn :let @"=expand("%:t")<CR>
" Yank current git branch
nnoremap ,yg :execute "let @+=FugitiveHead()"<CR>
" Yank current working directory
nnoremap ywd :let @+=trim(execute(":pwd"))<CR>
nnoremap ,yw :let @+=trim(execute(":pwd"))<CR>

" Some plugins change my CWD to currently opened file - I change it back
nnoremap <leader>cd
  \ :let @s=expand("%:p:h")<CR>
  \ :cd <C-r>s

nnoremap <leader>wd :pwd<CR>

" SEARCH AND REPLACE
" remove highlight from search term
" Use yoh (as defined in vim unimpaired)
" nnoremap <leader>nh :noh<cr>
nnoremap yoh :noh<cr>

vnoremap <leader>*
  \ :let @+=

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
" Delete all empty buffers
nnoremap <leader>be :call DeleteAllBuffers('e')<cr>
" Delete all terminal buffers
nnoremap <leader>bT :call DeleteAllBuffers('t')<cr>
" Delete current buffer
nnoremap <leader>bd :bd%<cr>
" Delete current buffer force
nnoremap <leader>bD :bd!%<cr>
" Wipe current buffer
nnoremap <leader>bw :bw%<cr>
" go to buffer number - use like so gb34
nnoremap <leader>bl :VMessage ls<CR>
map <leader>bn :call RenameFile()<cr>
" Remove contents of current file
nnoremap d] :w!<CR>:e %<CR>:%delete<cr>:w!<cr>
" Remove contents of current file and enter insert mode
nnoremap c] :%delete<cr>i

" Dump vim register into a buffer in vertical split.
nnoremap <leader>re :reg<CR>
nnoremap <localleader>re :VMessage reg<CR>
"""""""""""""""""""""""""""""""""""""

nnoremap ,rm :!trash-put "%:p"<cr>:bdelete!<cr>
nnoremap <Leader>ps :PackerSync<CR>

"""""""""""""""""""" Functions """"""""""""""""""""

" RENAME CURRENT FILE
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
    exec ':bdelete #'
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
  let dbui_buffers = []

  while index <= last_b_num
    let b_name = bufname(index)
    if bufexists(index)
      if a:f == 'dbui' && (b_name =~ '.dbout' || b_name =~ 'share/db_ui/')
        call add(dbui_buffers, index)
      else
        if  (b_name == '' || b_name == ',' )
          call add(no_name_buffers, index)
        endif

        if  (b_name =~ 'term://')
          call add(terminal_buffers, index)
        else
          call add(normal_buffers, index)
        endif
      endif
    endif

    let index += 1
  endwhile

  if a:f == 'a'
    if len(no_name_buffers) > 0
      silent execute 'bwipeout! '.join(no_name_buffers)
    endif

    if len(terminal_buffers) > 0
      silent execute 'bwipeout! '.join(terminal_buffers)
    endif

    if len(normal_buffers) > 0
      silent execute 'bd ' .join(normal_buffers)
    endif
  elseif a:f == 'e'
    if len(no_name_buffers) > 0
      silent execute 'bwipeout! '.join(no_name_buffers)
    endif
  elseif a:f == 't'
    if len(terminal_buffers) > 0
      silent execute 'bwipeout! '.join(terminal_buffers)
    endif
  elseif a:f == 'dbui'
    if len(dbui_buffers) > 0
      silent execute 'bwipeout! '.join(dbui_buffers)
    endif
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

" https://kba49.wordpress.com/2013/03/21/clear-all-registers-and-macros-in-vim/
function! ClearRegisters()
    let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-="*+'
    let i=0
    while (i<strlen(regs))
        exec 'let @'.regs[i].'=""'
        let i=i+1
    endwhile
endfunction

command! ClearRegisters call ClearRegisters()
command! DeleteDbUi call DeleteAllBuffers('dbui')

" Clear terminal buffer: https://superuser.com/a/1485854
let s:scroll_value = 3000000
function! ClearTerminal()
  set scrollback=1
  let &g:scrollback=1
  echo &scrollback
  call feedkeys("\i")
  call feedkeys("clear\<CR>")
  call feedkeys("\<C-\>\<C-n>")
  call feedkeys("\i")
  sleep 100m
  let &scrollback=s:scroll_value
endfunction

" === UN COMMENT ON SERVER === "
" colorscheme desert
" let g:maximizer_set_default_mapping = 0
" nnoremap mm :MaximizerToggle!<CR>
" xnoremap mm :MaximizerToggle!<CR>

" PLUGIN_PATH="vim-maximizer"
" PLUGIN_OWNER="szw"
" mkdir -p ~/.local/share/nvim/site/pack/$PLUGIN_PATH/start \
"   && git clone https://github.com/$PLUGIN_OWNER/$PLUGIN_PATH \
        " ~/.local/share/nvim/site/pack/$PLUGIN_PATH/start/$PLUGIN_PATH

" PLUGIN_PATH="vim-obsession"
" PLUGIN_OWNER="tpope"
