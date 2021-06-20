" Set <leader> key to <Space>
nnoremap <Space> <Nop>
let mapleader=" "
let maplocalleader=","

" format paragraphs/lines to 80 chars
nnoremap <Leader>pp gqap
xnoremap <Leader>pp gqa
xnoremap <Leader>pn :call Renumber()<CR>
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
cmap ,, w !sudo tee > /dev/null %

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
nnoremap ,rm :!trash-put %:p<cr>:bdelete!<cr>
" edit .bashrc file
nnoremap ,. :e ~/.bashrc<CR>
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
nnoremap <leader>tt :tab split<cr> :term /usr/bin/fish<cr>
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
nnoremap <leader>ba :call DeleteAllBuffers('a')<cr>
" Delete empty buffers - not working
nnoremap <leader>be :call DeleteAllBuffers('e')<cr>
" Delete current buffer
nnoremap <leader>bd :bd%<cr>
" Delete current buffer force
nnoremap <leader>bD :bd!%<cr>
" Wipe current buffer
nnoremap <leader>bw :bw%<cr>
" go to buffer number - use like so gb34
nnoremap <leader>bl :ls<CR>:b
map <leader>bn :call RenameFile()<cr>

" COMPLETION
" <c-j> and <c-k> to navigate up and down
inoremap <expr> <C-j> pumvisible() ? "<C-n>" : "<C-j>"
inoremap <expr> <C-k> pumvisible() ? "<C-p>" : "<C-k>"
" <cr> should behave like <c-y>: do not accept and place cursor on next line
inoremap <expr> <CR> pumvisible() ? "<C-y>" : "<CR>"
" right arrow also accepts suggestion
inoremap <expr> <right> pumvisible() ? "<C-y>" : "<right>"

"""""""""""""""""""""""""""""""""""""
" START FUGITIVE
"""""""""""""""""""""""""""""""""""""
" git status
nnoremap <leader>gg  :Git<CR>
nnoremap <leader>gc  :Git commit<CR>
" vertical split (3 way merge) to resolve git merge conflict
nnoremap <leader>gd  :Gvdiffsplit!<CR>
nnoremap <leader>g.  :Git add .<CR>
nnoremap <leader>g%  :Git add %<CR>
nnoremap <leader>gl  :Gllog!<CR>
nnoremap <leader>g0  :0Gllog!<CR>

nnoremap <leader>gr  :Git rebase -i HEAD~

nnoremap <leader>sp  :Git stash push -m ''<left>
nnoremap <leader>s%  :Git stash push -m '' -- %<left><left><left><left><left><left>
nnoremap <leader>sa  :Git stash apply stash@{}<left>
nnoremap <leader>sd  :Git stash drop stash@{}<left>
nnoremap <leader>sl  :Git stash list<CR>
nnoremap <leader>sc  :Git stash clear<CR>

nnoremap <leader>go  :Git push origin <right>
nnoremap <leader>gp  :Git push <right>
nnoremap <leader>gf  :Git push --force origin <right>
nnoremap <leader>ca :Git commit --amend<cr>
nnoremap <leader>ce :Git commit --amend --no-edit<cr>
nnoremap <leader>ct :Git commit --allow-empty -m ""<left>

" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
"""""""""""""""""""""""""""""""""""""
" END fugitive
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START FZF
"""""""""""""""""""""""""""""""""""""
" Search file from root directory
nnoremap <Leader>ff :Files!<CR>
" Search file from current directory
nnoremap <silent> <Leader>f. :Files! <C-r>=expand("%:h")<CR>/<CR>
" find open buffers
nnoremap <Leader>fb :Buffers!<CR>
" search buffers history
nnoremap <Leader>fh :History!<CR>
" search for text in current buffer
nnoremap <Leader>fl :BLines!<CR>
" search for text in loaded buffers
" nnoremap <Leader>L :Lines!<CR>
nnoremap <Leader>fm :Marks!<CR>
nnoremap <leader>ft :Filetypes!<CR>
nnoremap <leader>fw :Windows!<CR>
nnoremap <leader>fs :Colors!<CR>
" commands: user defined, plugin defined, or native commands
nnoremap <Leader>C :Commands!<CR>
" key mappings - find already mapped before defining new mappings
nnoremap <Leader>M :Maps!<CR>
" search in project - do not match filenames
nnoremap <Leader>/ :Rrg!<CR>

if !g:can_use_coc
  " Tags
  " find symbols in current buffer (fzf-lsp.nvim)
  nnoremap <leader>bt :DocumentSymbols!<CR>
  " find tags in entire project directory (fzf-lsp.nvim)
  nnoremap <leader>pt :WorkspaceSymbols!<CR>
  nnoremap <leader>fa :CodeActions!<CR>
  nnoremap <leader>fd :Diagnostics!<CR>
endif

" GIT
" Files managed by git
nnoremap <Leader>fg :GFiles!<CR>
" Git commits
nnoremap <leader>cm :Commits!<CR>
" Git commits for the current buffer
nnoremap <leader>c% :BCommits!<CR>
" fzf-checkout
" find git branch:
" checkout = <CR>
" rebase = <C-r>
" delete = <C-d>
" merge = <C-e>
" track remote = <a-cr>
nnoremap <leader>cb :GBranches!<CR>

" search in project - match file names first
nnoremap ,/ :Rg!<CR>
" nnoremap <leader>sn :Snippets<CR>
" Vim’s :help documentation
nmap <Leader>H :Helptags!<CR>

" Advanced ripgrep integration
command! -bang -nargs=* Rrg
  \ call fzf#vim#grep(
  \   "rg --hidden --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
  \   <bang>0
  \ )

function! s:copy_fzf_results(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @+ = joined_lines
endfunction

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': function('s:copy_fzf_results'),
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ }

" scroll the fzf vim listing buffer
autocmd FileType fzf tnoremap <buffer> <C-j> <Down>
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>
"""""""""""""""""""""""""""""""""""""
" END FZF
"""""""""""""""""""""""""""""""""""""

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
" COC START
"""""""""""""""""""""""""""""""""""""
if g:can_use_coc
" Use tab and shift tab to move to next/previous placeholders in snippets
imap <tab> <Plug>(coc-snippets-expand)

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter
" <cr> may have been remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in
" location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
" Show all diagnostics: COC errors in CoCList
nnoremap <silent> <leader>dd  :<C-u>CocList diagnostics<cr>
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Remap to rename current symbol
nmap <leader>rn <Plug>(coc-rename)
" Show `code action` window for currently selected region. Following actions
" are availbale: 1. Extract Function 2. Move to a new file 3. Extract constant
" 4. spelling suggestion
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
" nnoremap fc :Format<CR>
xmap <leader>fc :Format<CR>
nmap <leader>fc :Format<CR>
" sort import
nmap ,o :OR<CR>
nnoremap <silent> <leader>rs :<C-u>CocRestart<cr><cr>
nmap <Leader>ch :CocSearch <Right>

" Mappings for CoCList
" Manage extensions.
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <leader>bt  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>pt  :<C-u>CocList -I symbols<cr>

" nmap <leader>ee :CocCommand explorer<CR>
endif
"""""""""""""""""""""""""""""""""""""
" END COC
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START EASY MOTION
"""""""""""""""""""""""""""""""""""""
let g:EasyMotion_smartcase = 1

nmap <leader><leader>2 <Plug>(easymotion-overwin-f2)
"""""""""""""""""""""""""""""""""""""
" END EASY MOTION
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START FLOATERM
"""""""""""""""""""""""""""""""""""""
let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_next   = '<F2>'
let g:floaterm_keymap_prev   = '<F3>'
let g:floaterm_keymap_new    = '<F4>'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.999999
let g:floaterm_height=0.999999
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1
let g:floaterm_position='topright'
let g:floaterm_shell='/usr/bin/fish'
nmap <Leader>FF :FloatermNew <right>
nmap <Leader>FT :FloatermToggle <right>
nmap <Leader>FS :FloatermNew --wintype='split' <cr>
nmap <Leader>FK :FloatermKill!<CR>
" make width 50% of tab
nmap <Leader>F5 :FloatermUpdate --width=0.5<CR>
"""""""""""""""""""""""""""""""""""""
" END FLOATERM
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START LIGHTLINE
"""""""""""""""""""""""""""""""""""""
let g:lightline = {}

let g:lightline.component_function = {
  \'fugitive': 'LightlineFugitive',
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
          \'fugitive',
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

"""""""""""""""""""""""""""""""""""""
" START vCoolor
"""""""""""""""""""""""""""""""""""""
" Disable default mappings
let g:vcoolor_disable_mappings = 1

" insert hex color
let g:vcoolor_map = '<a-c>'
" Insert rgb color
let g:vcool_ins_rgb_map = '<a-r>'
" Insert rgba color
let g:vcool_ins_rgba_map = '<a-z>'
" Insert hsl color
let g:vcool_ins_hsl_map = '<a-h>'
"""""""""""""""""""""""""""""""""""""
" END vCoolor
"""""""""""""""""""""""""""""""""""""
