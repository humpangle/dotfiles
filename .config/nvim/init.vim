"""""""""""""""""""""""""""""""""""""
" SET UP PYTHON
"""""""""""""""""""""""""""""""""""""
let g:python_host_prog = expand('$PYTHON2')
let g:python3_host_prog = expand('$PYTHON3')
"""""""""""""""""""""""""""""""""""""
" END SET UP PYTHON
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START VIM PLUG
"""""""""""""""""""""""""""""""""""""
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
" typescript and other language server protocols - mimics VSCode.
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" syntax highlighting
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'
Plug 'cespare/vim-toml'
Plug 'evanleck/vim-svelte'
Plug 'elixir-editors/vim-elixir'

Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'ludovicchabant/vim-gutentags'
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
Plug 'godlygeek/tabular' " Align Markdown table
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
let g:mkdp_refresh_slow = 1
" Plug 'plasticboy/vim-markdown'

Plug 'neoclide/jsonc.vim'

call plug#end()
"""""""""""""""""""""""""""""""""""""
" END VIM PLUG
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" VIM SETTINGS
"""""""""""""""""""""""""""""""""""""
syntax enable
" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

" Remap esc key - if doing touch typing
" nmap JJ <esc>
" imap JJ <Esc>
" vmap JJ <Esc>
" nmap KK <esc>
" imap KK <Esc>
" vmap KK <Esc>

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
" toggle cursorcolumn
:nnoremap ,mc :set cursorline! cursorcolumn!<CR>

" Spell check
:setlocal spell spelllang=en

set foldmethod=indent
set foldnestmax=10
set nofoldenable " don't fold by default when opening a file.
set foldlevel=2

" reload a file if it is changed from outside vim
set autoread
set noswapfile
set undodir=$HOME/.vim/undodir/
set undofile

" Use Ripgrep for vimgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
"""""""""""""""""""""""""""""""""""""
" END VIM SETTINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START THEME SETTINGS
"""""""""""""""""""""""""""""""""""""
colorscheme one
set background=dark " for the dark version
" set background=light " for the light version
let g:airline_theme='one'
let g:one_allow_italics = 1 " I love italic for comments
"""""""""""""""""""""""""""""""""""""
" END THEME SETTINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START COC SETTINGS
"""""""""""""""""""""""""""""""""""""
" let g:coc_force_debug = 1
let g:coc_filetype_map = {
  \ 'htmldjango': 'html',
  \ '.eslintrc': 'json',
  \ 'jinja': 'html',
  \ 'eelixir': 'html',
\}

" CocInstall coc-elixir coc-spell-checker coc-cspell-dicts coc-yank coc-json coc-python coc-emmet coc-tsserver coc-snippets coc-css coc-html coc-eslint coc-pairs coc-prettier coc-svelte coc-docker https://github.com/kanmii/kanmii-coc-snippets coc-vetur
"""""""""""""""""""""""""""""""""""""
" END COC SETTINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" BETTER WHITE SPACE SETTINGS
"""""""""""""""""""""""""""""""""""""
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=0
"""""""""""""""""""""""""""""""""""""
" END BETTER WHITE SPACE SETTINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START GUTENTAGS SETTINGS
"""""""""""""""""""""""""""""""""""""
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
" let g:gutentags_cache_dir = expand('~/.tags_cache')
" let g:gutentags_trace = 1
" set statusline+=%{gutentags#statusline()}
"""""""""""""""""""""""""""""""""""""
" END GUTENTAGS SETTINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START LIGHTLINE SETTINGS
"""""""""""""""""""""""""""""""""""""
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
"""""""""""""""""""""""""""""""""""""
" END LIGHTLINE SETTINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START REST CONSOLE SETTINGS
"""""""""""""""""""""""""""""""""""""
let g:vrc_elasticsearch_support = 1 " bulk upload and external data file
let g:vrc_trigger = '<C-n>' " n = new request/ trigger is <C-J> by default
"""""""""""""""""""""""""""""""""""""
" END REST CONSOLE SETTINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" NON PLUGIN MAPPINGS
"""""""""""""""""""""""""""""""""""""
" Format paragraph (selected or not) to 80 character lines.
nnoremap <Leader>g gqap
xnoremap <Leader>g gqa
" Vim’s :help documentation
nmap <Leader>H :Helptags!<CR>
" Save file
nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wa :wa<CR>
nnoremap <Leader>wq :wq<cr>

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>qq :q<cr>
nnoremap <Leader>qa :qa<cr>

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

nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>tt :tab split<cr>
nnoremap <leader>dt :diffthis<cr>
nnoremap <leader>do :diffoff<cr>

" create the new directory am already working in
nnoremap ,md :!mkdir -p %:h<cr><cr>
nnoremap ,rm :call delete(expand('%:p')) <bar> bdelete! <cr>
nnoremap ,in :e ~/.config/nvim/init.vim<CR>
nnoremap ,so :so ~/.config/nvim/init.vim<CR>
nnoremap ,. :e ~/.bashrc<CR>
nnoremap <leader>nt :term<cr>

"""""""""""""""""""""""""""""""""""""
" MAPPINGS TO MOVE LINES
"""""""""""""""""""""""""""""""""""""
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
"""""""""""""""""""""""""""""""""""""
" END MAPPINGS TO MOVE LINES
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" EMBEDDED TERMINAL
"""""""""""""""""""""""""""""""""""""
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
"""""""""""""""""""""""""""""""""""""
" END EMBEDDED TERMINAL
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" COPY FILE PATH
"""""""""""""""""""""""""""""""""""""
nmap ,yr :let @+=expand("%")<CR>      " Mnemonic: yank relative File path
nmap ,yn :let @+=expand("%:t")<CR>    " Mnemonic: yank file name / not path
nmap ,yd :let @+=expand("%:p:h")<CR>  " Mnemonic: yank file parent directory
nmap ,yf :let @+=expand("%:p")<CR>    " Mnemonic: yank absolute File path

nmap ,cr :let @"=expand("%")<CR>      " Mnemonic: copy relative path
nmap ,cf :let @"=expand("%:p")<CR>    " Mnemonic: copy absolute path
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
nnoremap <leader>r :%s///g<left><left>
nnoremap <leader>rc :%s///gc<left><left><left>

" same as above but only visually selected range
xnoremap <leader>r :%s///g<left><left>
xnoremap <leader>rc :%s///gc<left><left><left>
"""""""""""""""""""""""""""""""""""""
" END SEARCH AND REPLACE
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" TOGGLE LINE NUMBERING
"""""""""""""""""""""""""""""""""""""
set number
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
"""""""""""""""""""""""""""""""""""""
" END TOGGLE LINE NUMBERING
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
function! DeleteAllBuffers()
  let buffers = range(1, bufnr('$'))
  exe 'bd '.join(buffers, ' ')
endfunction

map <leader>db :call DeleteAllBuffers()<cr>
"""""""""""""""""""""""""""""""""""""
" END MANAGE BUFFERS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" END NON PLUGIN MAPPINGS
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
" To get correct comment highlighting in jsonc file
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd! FileType json set filetype=jsonc
" open help file in vertical split
autocmd FileType help wincmd H
" au BufNewFile,BufRead,BufReadPost *.svelte set syntax=html
"""""""""""""""""""""""""""""""""""""
" END AUTOCMD
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START FUZZY FIND FILES WITH FZF
" https://medium.com/@jesseleite/its-dangerous-to-vim-alone-take-fzf-283bcff74d21
"""""""""""""""""""""""""""""""""""""
" search files from root directory where vim opened.
nmap <Leader>f :Files<CR>
" search files only in directory of currently open file
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
" nmap <Leader>f :GFiles<CR>
nmap <Leader>b :Buffers<CR>
" search buffers history
nmap <Leader>h :History<CR>
" search for tags without ctags (method names etc) or special package
nmap <Leader>t :BTags<CR>
" use with gutentags package
nmap <Leader>T :Tags<CR>
" search for text in current buffer
nmap <Leader>l :BLines<CR>
" search for text in all buffers
nmap <Leader>L :Lines<CR>
nmap <Leader>m :Marks<CR>
" Fuzzy search defined commands, whether they be user defined, plugin
" defined, or native commands:
nmap <Leader>C :Commands<CR>
" Fuzzy search vim key mappings - useful to find what has already been mapped
" before defining new mappings
nmap <Leader>M :Maps<CR>
" Fuzzy search filetype syntaxes, and hit Enter on a result to set that syntax on the current buffer:
nmap <leader>ss :Filetypes<CR>
" search in project - do not match filenames
nmap <Leader>/ :Rrg<CR>
" search in project - match file names first
nmap ,/ :Rg<CR>
nmap ,cm :Commits<CR>

" Advanced ripgrep integration
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --hidden --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=* Rrg call fzf#vim#grep("rg --hidden --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
"""""""""""""""""""""""""""""""""""""
" END START FUZZY FIND FILES WITH FZF
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START COC PLUGIN MAPPINGS AND SETTINGS
"""""""""""""""""""""""""""""""""""""
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" don't give |ins-completion-menu| messages.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-leader> (ctrl+leader) to trigger completion
inoremap <silent><expr> <c-leader> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap to rename current word
nmap <leader>n <Plug>(coc-rename)

" Formatting selected code.
xmap fc  <Plug>(coc-format-selected)
nmap fc  <Plug>(coc-format-selected)

augroup coc_grp_1
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Show `code action` window for currently selected region. Following actions
" are availbale: 1. Extract Function 2. Move to a new file 3. Extract constant
xmap ,ac  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap ,ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap ,qf  <Plug>(coc-fix-current)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
nnoremap fc :Format<CR>

" use ``:Prettier` to format current buffer.
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
nmap ,o :OR<CR>

nnoremap <silent> <leader>rs :<C-u>CocRestart<cr><cr>
" yank
nnoremap <silent> <leader>y :<C-u>CocList -A --normal yank<cr>
nmap <Leader>cs :CocSearch <Right>

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent> <leader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <leader>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>s  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>S  :<C-u>CocList -I symbols<cr>
"""""""""""""""""""""""""""""""""""""
" END COC PLUGIN VIM SETTINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START MHINZ/VIM-GREPPER MAPPINGS
"""""""""""""""""""""""""""""""""""""
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
"""""""""""""""""""""""""""""""""""""
" END MHINZ/VIM-GREPPER MAPPINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" FUGITIVE MAPPINGS
"""""""""""""""""""""""""""""""""""""
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
map gpgm        :Git push github master<CR>
map gpgd        :Git push github dev<CR>
"""""""""""""""""""""""""""""""""""""
" END FUGITIVE MAPPINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START EASYMOTION MAPPINGS
"""""""""""""""""""""""""""""""""""""
nmap <leader><leader>2s <Plug>(easymotion-overwin-f2)
"""""""""""""""""""""""""""""""""""""
" END EASYMOTION MAPPINGS
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" REST CONSOLE MAPPINGS
"""""""""""""""""""""""""""""""""""""
" make new rest
nnoremap ,nr :tabe .rest<Left><Left><Left><Left><Left>
" map rest rest
nnoremap ,mr :let b:vrc_output_buffer_name = '__-Rest__'<Left><Left><Left><Left><Left><Left><Left><Left>

nmap ta :Tabularize /
vmap ta :Tabularize /
nmap tb :Tabularize /\zs<Left><Left><Left>
vmap tb :Tabularize /\zs<Left><Left><Left>
"""""""""""""""""""""""""""""""""""""
" END REST CONSOLE
"""""""""""""""""""""""""""""""""""""
