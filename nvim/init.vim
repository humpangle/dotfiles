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

" search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Terminal wrapper
Plug 'kassio/neoterm'

" themes
Plug 'dracula/vim', { 'as': 'dracula' }

" elixir language syntax highlighting
Plug 'elixir-editors/vim-elixir'

" typescript and other language server protocols - mimics VSCode.
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
let g:coc_force_debug = 1
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-yank',
  \ 'coc-prettier'
\]

"  coc-snippets that I use
"  coc-emmet
"  coc-elixir
"  coc-css
"  coc-html
"  coc-tsserver
"  coc-python
"  https://github.com/kanmii/coc-snippets

let g:coc_filetype_map = {
  \ 'htmldjango': 'html',
  \ '.eslintrc': 'json',
\}

" syntax highlighting
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'

Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=0

Plug 'airblade/vim-gitgutter'

" syntax highlight toml file type
Plug 'cespare/vim-toml'

Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
"let g:gutentags_cache_dir = expand('~/.tags_cache')
"let g:gutentags_trace = 1
set statusline+=%{gutentags#statusline()}

Plug 'itchyny/lightline.vim' " cool status bar

" Surround text with quotes, parenthesis, brackets, and more.
Plug 'tpope/vim-surround'
" A git wrapper so awesome it should be illegal.
Plug 'tpope/vim-fugitive'

" syntax highlighting and indentation for Svelte 3 components.
Plug 'evanleck/vim-svelte'

Plug 'sbdchd/neoformat'
let g:neoformat_try_formatprg = 1

" Plug 'dense-analysis/ale'
" let g:ale_enabled = 0
" let g:ale_completion_enabled = 1
" let g:ale_fix_on_save = 1
" let g:ale_linters_explicit = 1

" let g:ale_linter_aliases = {
" \   'svelte': ['css', 'html', 'javascript', 'typescript']
" \}

" let g:ale_linters = {
"   \ 'svelte': ['eslint', 'typecheck']
" \}

" let g:ale_fixers = {
"   \ 'svelte': ['eslint']
" \}

Plug 'maximbaz/lightline-ale'

call plug#end()
" }}}
" == VIM PLUG END ==========================================================

" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================

" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

" checkhealth suggested
" checkhealth suggested
"if (has("termguicolors"))
" set termguicolors
"endif

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
set number " line numbering

" I disabled both because they were distracting and slow (according to docs)
" set cursorline " highlight cursor positions
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

" Use Ripgrep for vimgrep
" set grepprg=rg\ --vimgrep

" ============================================================================
" }}} END BASIC SETTINGS
" ============================================================================

" Vim’s :help documentation
nmap <Leader>H :Helptags!<CR>

" Save file
nnoremap <Leader>w :w<CR>

" Copy and paste from system clipboard (Might require xsel/xclip install)
vmap <Leader>Y "+y
vmap <Leader>d "+d
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
nnoremap <silent> <leader>\| :vnew<CR>
" remove all splt windows leaving the one I am on
nnoremap <silent> <leader>0 :only<CR>

" set relativenumber
" Relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

" Toggle between normal and relative numbering.
nnoremap <leader>ln :call NumberToggle()<cr>

" ================ Mappings to move lines =============================
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" ================== end Mappings to move lines ==========================

set background=dark
syntax enable
colorscheme dracula
" colorscheme OceanicNext

" =============================== AUTOCMD ==================================
au FocusGained * :checktime
au BufNewFile,BufRead *.html.django set filetype=htmldjango
au BufNewFile,BufRead *.eslintrc set filetype=json
" To get correct comment highlighting in jsonc file
autocmd FileType json syntax match Comment +\/\/.\+$+
" au BufNewFile,BufRead,BufReadPost *.svelte set syntax=html
" ================================ /AUTOCMD ==============================

" ============================== EMBEDED TERMINAL ======================
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
" ============================== /EMBEDED TERMINAL ======================

" ========================== FUZZY FIND FILES WITH FZF ==============
" https://medium.com/@jesseleite/its-dangerous-to-vim-alone-take-fzf-283bcff74d21
" search files from root directory where vim opened.
nnoremap <silent> <Leader><Space> :Files<CR>
" search files only in directory of currently open file
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
nmap <Leader>f :GFiles<CR>
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
" Fuzzy search through :command history:
nmap <Leader>: :History:<CR>
" Fuzzy search vim key mappings - useful to find what has already been mapped
" before defining new mappings
nmap <Leader>M :Maps<CR>

" Fuzzy search filetype syntaxes, and hit Enter on a result to set that syntax on the current buffer:
nmap <Leader>ss :Filetypes<CR>

" search in project
nmap <Leader>/ :Rg<CR>
" ==========================  END FUZZY FIND FILES WITH FZF ========

" =================== COC Plugin Vim settings ===========================
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Improve the completion experience
" Use <Tab> and <S-Tab> to navigate the completion list:
" Use <cr> to confirm completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" \Note: you have to remap <cr> to make sure it confirm completion when pum is visible.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" To make coc.nvim format your code on <cr>, use keymap:
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Remap to rename current word
nmap <leader>rn <Plug>(coc-rename)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>rs :<C-u>CocRestart<cr><cr>
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
" multiple cursor ( I can't figure how to use it yet)
nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-d> <Plug>(coc-cursors-word)
xmap <silent> <C-d> <Plug>(coc-cursors-range)
" use normal command like `<leader>xi(`
nmap <leader>x  <Plug>(coc-cursors-operator)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" scroll floating windows
nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
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

map <leader>n :call RenameFile()<cr>
""""""""""""" END RENAME CURRENT FILE """""""""""""""""""""""""""""""""""

" mappings with leader m
nnoremap <leader>mh :noh<CR>
nnoremap <leader>mo :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>mp :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>m. :e ~/.bashrc<CR>
nnoremap <leader>mt :term<cr>
nnoremap <leader>ms :mksession! <space>
" create the new directory am already working in
nnoremap <leader>md :!mkdir -p %:h<cr><cr>
nnoremap <leader>nt :tabnew<cr>
nnoremap <leader>tt :tab split<cr>

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>mq :qa!<cr>

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
" let g:lightline.colorscheme = 'darcula'
let g:lightline.component_function = {
  \ 'fugitive': 'LightlineFugitive',
  \ 'cocstatus': 'coc#status'
  \ }

" let g:lightline.component_expand = {
"   \  'linter_checking': 'lightline#ale#checking',
"   \  'linter_warnings': 'lightline#ale#warnings',
"   \  'linter_errors': 'lightline#ale#errors',
"   \  'linter_ok': 'lightline#ale#ok',
" \}

" let g:lightline.component_type = {
"   \ 'linter_checking': 'left',
"   \ 'linter_warnings': 'warning',
"   \ 'linter_errors': 'error',
"   \ 'linter_ok': 'left',
" \}


      " \[
      "   \ 'linter_checking',
      "   \ 'linter_errors',
      "   \ 'linter_warnings',
      "   \ 'linter_ok'
      " \],

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

" \['cocstatus'],

function! LightlineFugitive()
		if exists('*fugitive#head')
			let branch = fugitive#head()
			return branch !=# '' ? branch : ''
		endif
		return ''
endfunction

" Use auocmd to force lightline update with coc status - slows down vim
" autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
" ========================== end lightline settings ================ "

" ========================== fugitive ============================= "
" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
" ========================== end fugitive =========================== "

" ============================ Neoformat ===============================
nnoremap fd :Neoformat<CR>
" ============================ END Neoformat ===========================

" ======================== ALE KEY MAPS ===============================
" nmap <silent> grh <Plug>(ale_hover)
" nmap <silent> grp <Plug>(ale_previous_wrap)
" nmap <silent> grn <Plug>(ale_next_wrap)
" nmap <silent> grf <Plug>(ale_fix)
" nmap <silent> grb :!black %<cr><cr>
" nmap <silent> grr <Plug>(ale_find_references)
" nmap <silent> grt <Plug>(ale_reset)
" nnoremap <silent> grd  :<C-u>ALEGoToDefinition<cr>
" nnoremap <silent> grn  :<C-u>ALERename<cr>
" ======================== END ALE KEY MAPS ===========================
