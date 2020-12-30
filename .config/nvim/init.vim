" set up python
let g:python_host_prog = expand('$PYTHON2')
let g:python3_host_prog = expand('$PYTHON3')
" === /PYTHON ==========

" == VIM PLUG ==============================================================
call plug#begin('~/.vim/plugged')

" Handle multi-file find and replace.
Plug 'mhinz/vim-grepper'
let g:grepper={}
let g:grepper.tools=["rg"]

" Modify * to also work with visual selections.
Plug 'nelstrom/vim-visual-star-search'
" Toggle comments in various ways.
Plug 'tpope/vim-commentary'
" A number of useful motions for the quickfix list, pasting and more.
Plug 'tpope/vim-unimpaired'
" Better manage Vim sessions - prosession depends on obsession
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-surround'
" Connect to database use vim
Plug 'tpope/vim-dadbod'
" A git wrapper so awesome it should be illegal.
Plug 'tpope/vim-fugitive'
" search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Terminal wrapper
Plug 'kassio/neoterm'
" themes
Plug 'rakr/vim-one'
" elixir language syntax highlighting
Plug 'elixir-editors/vim-elixir'
" typescript and other language server protocols - mimics VSCode.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" let g:coc_force_debug = 1
" CocInstall coc-elixir coc-spell-checker coc-cspell-dicts coc-yank coc-json coc-python coc-emmet coc-tsserver coc-snippets coc-css coc-html coc-eslint coc-pairs coc-prettier coc-svelte coc-docker https://github.com/kanmii/kanmii-coc-snippets

let g:coc_filetype_map = {
  \ 'htmldjango': 'html',
  \ '.eslintrc': 'json',
  \ 'jinja': 'html',
  \ 'eelixir': 'html',
\}

" syntax highlighting
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'
Plug 'cespare/vim-toml'
" syntax highlighting and indentation for Svelte 3 components.
Plug 'evanleck/vim-svelte'

Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=0

Plug 'airblade/vim-gitgutter'

Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" let g:gutentags_cache_dir = expand('~/.tags_cache')
" let g:gutentags_trace = 1
" set statusline+=%{gutentags#statusline()}

Plug 'itchyny/lightline.vim' " cool status bar
" Surround text with quotes, parenthesis, brackets, and more.
Plug 'easymotion/vim-easymotion'
Plug 'will133/vim-dirdiff'
" python syntax highlighting - adds highlighting to other file types too
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
" modifies Vim’s indentation behavior to comply with PEP8
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'lepture/vim-jinja'

Plug 'diepm/vim-rest-console'
let g:vrc_elasticsearch_support = 1 " bulk upload and external data file
let g:vrc_trigger = '<C-n>' " n = new request/ trigger is <C-J> by default

Plug 'godlygeek/tabular'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
let g:mkdp_refresh_slow = 1
" Plug 'plasticboy/vim-markdown'

call plug#end()
" == VIM PLUG END ==========================================================

syntax enable

colorscheme one
set background=dark " for the light version
" set background=light " for the light version
let g:airline_theme='one'
let g:one_allow_italics = 1 " I love italic for comments

" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================

" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

if (has("termguicolors"))
 set termguicolors
endif

set hidden " close unsaved buffer with 'q' without needing 'q!'
set tabstop=2
set softtabstop=2
set expandtab " converts tabs to white space
set shiftwidth=2 " default indent = 2 spaces
set encoding=utf8
set cc=80  " column width
set ignorecase
set smartcase
set incsearch    " Incremental search, search as you type
set ignorecase   " Make searching case insensitive
set smartcase    " ... unless the query has capital letters
set gdefault     " Use 'g' flag by default with :s/foo/bar/.
set hlsearch
" set nohlsearch
" Search ignore path
set wildignore+=*.zip,*.png,*.jpg,*.gif,*.pdf,*DS_Store*,*/.git/*,*/node_modules/*,*/build/*,package-lock.json,*/_build/*,*/deps/*,*/elixir_ls/*,yarn.lock,mix.lock,*/coverage/*

" Tab Splits
set splitbelow
set splitright
set mouse=a

" I disabled both because they were distracting and slow (according to docs)
set cursorline " highlight cursor positions
" set cursorcolumn
:nnoremap <Leader>mc :set cursorline! cursorcolumn!<CR>

" Spell check
:setlocal spell spelllang=en

" ================================== Folding ===============================
set foldmethod=indent
set foldnestmax=10
set nofoldenable " don't fold by default when opening a file.
set foldlevel=2
" =============================== /Folding ================================

" reload a file if it is changed from outside vim
set autoread
set noswapfile
set undodir=$HOME/.vim/undodir//
set undofile

" Use Ripgrep for vimgrep
" set grepprg=rg\ --vimgrep

" ===========================END BASIC SETTINGS=====================
" Format paragraph (selected or not) to 80 character lines.
nnoremap <Leader>g gqap
xnoremap <Leader>g gqa
" Vim’s :help documentation
nmap <Leader>H :Helptags!<CR>
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
" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
" split tabs bottom
nnoremap <silent> <leader>_ :split<CR>
" split right
nnoremap <silent> <leader>\| :vsp<CR>
" remove all split windows leaving the one I am on
nnoremap <silent> <leader>0 :only<CR>
set number

" Toggle between normal and relative numbering.
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc
" nnoremap <leader>ln :call NumberToggle()<cr>

" toggle line numbering
" nnoremap ln :set nornu number<CR>
" nnoremap Ln :set nonumber nornu<CR>
" nnoremap eb :e %<CR>

" ================ Mappings to move lines =============================
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" ================== end Mappings to move lines ==========================
" =============================== AUTOCMD ==================================
au FocusGained * :checktime
au BufNewFile,BufRead *.html.django set filetype=htmldjango
au BufNewFile,BufRead *.eslintrc set filetype=json
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set filetype=jinja
au BufNewFile,BufRead .env* set filetype=sh
au BufNewFile,BufRead *.psql set filetype=sql
" au BufNewFile,BufRead .env-cmdrc* set filetype=json
au BufNewFile,BufRead Dockerfile* set filetype=dockerfile
" To get correct comment highlighting in jsonc file
autocmd FileType json syntax match Comment +\/\/.\+$+
" open help file in vertical split
autocmd FileType help wincmd H
" au BufNewFile,BufRead,BufReadPost *.svelte set syntax=html
" ================================ /AUTOCMD ==============================
" ============================== EMBEDDED TERMINAL ======================
:tnoremap <C-h> <C-\><C-N><C-w>h
:tnoremap <C-j> <C-\><C-N><C-w>j
:tnoremap <C-k> <C-\><C-N><C-w>k
:tnoremap <C-l> <C-\><C-N><C-w>l
:inoremap <A-r> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <C-h> <C-w>h
:nnoremap <C-j> <C-w>j
:nnoremap <C-k> <C-w>k
:nnoremap <C-l> <C-w>l
" Press escape twice to exit insert mode in embedded terminal
tnoremap <Esc><Esc> <C-\><C-n>
" ============================== /EMBEDDED TERMINAL ======================
" ========================== FUZZY FIND FILES WITH FZF ==============
" https://medium.com/@jesseleite/its-dangerous-to-vim-alone-take-fzf-283bcff74d21
" search files from root directory where vim opened.
nmap <Leader>f :Files<CR>
" search files only in directory of currently open file
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
" nmap <Leader>f :GFiles<CR>
nmap <Leader>b :Buffers<CR>
" search buffer history
nmap <Leader>h :History<CR>
" search for tags without ctags (method names etc) or special package
nmap <Leader>t :BTags<CR>
" use with gutentags package
nmap <Leader>T :Tags<CR>
" search for text in current buffer
nmap <Leader>l :BLines<CR>
nmap <Leader>L :Lines<CR>
nmap <Leader>' :Marks<CR>
" Fuzzy search defined commands, whether they be user defined, plugin
" defined, or native commands:
nmap <Leader>C :Commands<CR>
nmap <Leader>cs :CocSearch <Right>
" Fuzzy search through :command history:
nmap <Leader>: :History:<CR>
" Fuzzy search vim key mappings - useful to find what has already been mapped
" before defining new mappings
nmap <Leader>M :Maps<CR>
" Fuzzy search filetype syntaxes, and hit Enter on a result to set that syntax on the current buffer:
nmap <Leader>ss :Filetypes<CR>
" search in project
nmap <Leader>/ :Rg<CR>

" Advanced ripgrep integration
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" ==========================  END FUZZY FIND FILES WITH FZF ========
" =================== COC Plugin Vim settings ===========================
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=100
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Better display for messages
set cmdheight=2
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Remap to rename current word
nmap <leader>n <Plug>(coc-rename)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>rs :<C-u>CocRestart<cr><cr>
" show correction suggestions
vmap <leader>a <Plug>(coc-codeaction-selected)
" yank
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
nnoremap fc :Format<CR>

" use ``:Prettier` to format current buffer.
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" multiple cursor ( I can't figure how to use it yet)
nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-d> <Plug>(coc-cursors-word)
xmap <silent> <C-d> <Plug>(coc-cursors-range)
" use normal command like `<leader>xi(`
nmap <leader>x  <Plug>(coc-cursors-operator)
" Remap keys for goto's
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" enter floating window in order to scroll it
nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
" exit floating window
nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" ===================== END COC PLUGIN SETTINGS =====================

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

map <leader>rn :call RenameFile()<cr>
""""""""""""" END RENAME CURRENT FILE """""""""""""""""""""""""""""""""""
nnoremap <leader>nt :tabnew<cr>
nnoremap <leader>tt :tab split<cr>
nnoremap <leader>dt :diffthis<cr>
nnoremap <leader>do :diffoff<cr>

""""""""""""" MAPPINGS WITH COMMA,""""""""""""""""""""""""""""""""
" create the new directory am already working in
nnoremap ,md :!mkdir -p %:h<cr><cr>
nnoremap ,rm :call delete(expand('%:p')) <bar> bdelete! <cr>
nnoremap ,in :e ~/.config/nvim/init.vim<CR>
nnoremap ,so :so ~/.config/nvim/init.vim<CR>
nnoremap ,. :e ~/.bashrc<CR>
nnoremap ,t :term<cr>

" better code indentations in visual mode.
vnoremap < <gv
vnoremap > >gv

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn

""""""""""""""""" find and replace in file """""""""""""""""""""""""""""""""
" press * {shift 8) to search for word under cursor and key combo below to
" replace in entire file
nnoremap <leader>r :%s///g<left><left>
nnoremap <leader>rc :%s///gc<left><left><left>

" same as above but only visually selected range
xnoremap <leader>r :%s///g<left><left>
xnoremap <leader>rc :%s///gc<left><left><left>

" .............................................................................
" mhinz/vim-grepper
" .............................................................................
xmap gr <plug>(GrepperOperator)

" After searching for text, press this mapping to do a project wide find and
" replace. It's similar to <leader>r except this one applies to all matches
" across all files instead of just the current file.
nnoremap <Leader>R
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" The same as above except it works with a visual selection.
xmap <Leader>R
    \ "sy
    \ gvgr
    \ :cfdo %s/<C-r>s//g \| update
     \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" ========================== lightline settings ==================== "
let g:lightline = {}

let g:lightline.component_function = {
  \ 'fugitive': 'LightlineFugitive',
  \ }

let g:lightline.component = {
    \ 'filename': '%f',
  \}

let g:lightline.active = {
  \ 'left': [
      \[ 'mode', 'paste' ],
      \[
        \'fugitive',
        \'readonly',
        \'filename',
        \'modified'
      \]
    \],
  \ 'right': [
      \[ 'lineinfo' ],
      \[ 'percent' ],
      \['fileformat', 'fileencoding', 'filetype']
    \]
  \ }

function! LightlineFugitive()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? branch : ''
  endif
  return ''
endfunction
" ========================== end lightline settings ================ "

" ========================== fugitive ============================= "
" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

map gst         :Git st<CR>
map gcm         :Gcommit<CR>
map gvs         :Gvdiffsplit<CR>
map gss         :Gstatus<CR>
map ga.         :Git add .<CR>
map ,gpm        :Git push github master<CR>
" ========================== end fugitive =========================== "

"https://tech.serhatteker.com/post/2020-06/how-to-delete-multiple-buffers-in-vim/
function! DeleteAllBuffers()
  let buffers = range(1, bufnr('$'))
  exe 'bd '.join(buffers, ' ')
endfunction

map <leader>db :call DeleteAllBuffers()<cr>
" ========================== easymotion =========================== "
nmap <leader><leader>2s <Plug>(easymotion-overwin-f2)
" ========================== end easymotion =========================== "

" ========================== copy file path ==============================
nmap ,yr :let @+=expand("%")<CR>      " Mnemonic: yank relative File path
nmap ,yn :let @+=expand("%:t")<CR>    " Mnemonic: yank file name / not path
nmap ,yd :let @+=expand("%:p:h")<CR>  " Mnemonic: yank file parent directory
nmap ,yf :let @+=expand("%:p")<CR>    " Mnemonic: yank absolute File path

nmap ,cr :let @"=expand("%")<CR>      " Mnemonic: copy relative path
nmap ,cf :let @"=expand("%:p")<CR>    " Mnemonic: copy absolute path
" ========================== end copy file path ===========================

" ========================== REST CONSOLE ===========================
" make new rest
nnoremap ,nr :tabe .rest<Left><Left><Left><Left><Left>
" map rest rest
nnoremap ,mr :let b:vrc_output_buffer_name = '__-Rest__'<Left><Left><Left><Left><Left><Left><Left><Left>

nmap ta :Tabularize /
vmap ta :Tabularize /
nmap tb :Tabularize /\zs<Left><Left><Left>
vmap tb :Tabularize /\zs<Left><Left><Left>
