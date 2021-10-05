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
cmap W w !sudo tee > /dev/null %<CR>
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

nnoremap <leader>% :e %<CR>

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

" Some plugins change my CWD to currently opened file - I change it back
nnoremap <leader>cd
  \ :let @s=expand("%:p:h")<CR>
  \ :cd <C-r>s

nnoremap <leader>wd :pwd<CR>

" SEARCH AND REPLACE
" remove highlight from search term
nnoremap <leader>nh :noh<cr>

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

" mbbill/undotree
" nnoremap <A-u> :UndotreeToggle<CR>
" simnalamburt/vim-mundo
nnoremap <A-u> :MundoToggle<CR>

" Dump vim register into a buffer in vertical split.
nnoremap <leader>re :reg<CR>
nnoremap <localleader>re :VMessage reg<CR>

" vim-dadbod-ui
nnoremap <leader>du :tabnew<CR>:DBUI<CR>

" COMPLETION
" " <c-j> and <c-k> to navigate up and down
" inoremap <expr> <C-j> pumvisible() ? "<C-n>" : "<C-j>"
" inoremap <expr> <C-k> pumvisible() ? "<C-p>" : "<C-k>"
" " <cr> should behave like <c-y>: do not accept and place cursor on next line
" inoremap <expr> <CR> pumvisible() ? "<C-y>" : "<CR>"
" " right arrow also accepts suggestion
" inoremap <expr> <right> pumvisible() ? "<C-y>" : "<right>"

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
nnoremap <leader>gl  :Gclog! <right>
nnoremap <leader>g0  :0Gclog! <right>
nnoremap <leader>ge  :Gedit <right>
nnoremap <leader>gb  :Git blame<CR>

nnoremap <leader>gr  :Git rebase -

nnoremap <leader>sk  :Git stash push --keep-index -m ''<left>
nnoremap <leader>su  :Git stash -u push -m ''<left>
nnoremap <leader>sp  :Git stash push -m ''<left>
nnoremap <leader>s%  :Git stash push -m '' -- %<left><left><left><left><left><left>
nnoremap <leader>sa  :Git stash apply stash@{}<left>
nnoremap <leader>sd  :Git stash drop stash@{}<left>
nnoremap <leader>ss  :Git stash show -p stash@{}<left>
nnoremap <leader>sl  :Git stash list<CR>
nnoremap <leader>sP  :Git stash pop
nnoremap <leader>sc  :Git stash clear

nnoremap <leader>go  :Git push origin <right>
nnoremap <leader>gp  :Git push <right>
nnoremap <leader>gf  :Git push --force origin <right>
nnoremap <leader>ca  :Git commit --amend<cr>
nnoremap <leader>ce  :Git commit --amend --no-edit
nnoremap <leader>ct  :Git commit --allow-empty -m ""<left>

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
nnoremap <c-p> :FZFFiles!<CR>
" Search file from current directory
nnoremap <silent> <Leader>f. :FZFFiles! <C-r>=expand("%:h")<CR>/<CR>
" find open buffers
nnoremap <Leader>fb :Buffers!<CR>
" search buffers history
nnoremap <Leader>fh :FZFHistory!<CR>
" search for text in current buffer
nnoremap <Leader>fl :FZFBLines!<CR>
" search for text in loaded buffers
" nnoremap <Leader>L :Lines!<CR>
nnoremap <Leader>fm :FZFMarks!<CR>
nnoremap <leader>ft :Filetypes!<CR>
nnoremap <leader>fw :FZFWindows!<CR>
" Find color schemes
nnoremap <leader>fs :Colors!<CR>
" commands: user defined, plugin defined, or native commands
nnoremap <Leader>C :Commands!<CR>
" key mappings - find already mapped before defining new mappings
nnoremap <Leader>M :Maps!<CR>
" search in project - do not match filenames
nnoremap <Leader>/ :FZFRg!<CR>
" find symbols in current buffer (ctags -R)
nnoremap ,bt :FZFBTags!<CR>
" find symbols in project directory (ctags -R)
nnoremap ,pt :FZFTags!<CR>

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

nnoremap <leader>fq :FZFQuickFix!<CR>
nnoremap <leader>FL :FZFLocList!<CR>

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

let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']

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

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

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
" format on enter
" <cr> may have been remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in
" location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
" Show all diagnostics: COC errors in CoCList
nnoremap <C-M> :<c-u>CocList diagnostics<cr>
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap to rename current symbol
nmap <leader>rn <Plug>(coc-rename)
" Show `code action` window for currently selected region. Following actions
" are availbale: 1. Extract Function 2. Move to a new file 3. Extract constant
" 4. spelling suggestion
nmap ,ac  <Plug>(coc-codeaction)
xmap ,ac  <Plug>(coc-codeaction-selected)
" Apply AutoFix to problem on the current line.
nmap ,qf  <Plug>(coc-fix-current)
" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use `:Format` to format current buffer using LSP
command! -nargs=0 Format :call CocAction('format')
" nnoremap fc :Format<CR>
xmap <leader>fc :Format<CR>
nmap <leader>fc :Format<CR>

" Use ``:Prettier` to format current buffer.
" If there is a formatter registered with the LSP, prettier has lower
" priority and thus using `:Format` will not invoke prettier. Use the mapping
" below to explicitly invoke prettier.
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <leader>fp :Prettier<CR>

" Sort import
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
nmap ,o :OR<CR>

nnoremap <silent> <leader>rs :<C-u>CocRestart<cr><cr>
nmap <Leader>ch :CocSearch <Right>

" Mappings for CoCList
" Manage extensions.
nnoremap <C-X>  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <leader>bt  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>pt  :<C-u>CocList -I symbols<cr>

" nmap <leader>ee :CocCommand explorer<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup coc_grp_1
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,vue setl formatexpr=CocAction('formatSelected')

  " Format vue with prettier on write
  " autocmd BufWritePre *.vue Prettier

  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" automatically close coc-explorer if it's the last buffer
" autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

endif
"""""""""""""""""""""""""""""""""""""
" END COC
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START EASY MOTION
"""""""""""""""""""""""""""""""""""""
let g:EasyMotion_smartcase = 1

nmap <leader>2 <Plug>(easymotion-overwin-f2)
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
let g:floaterm_shell= $SHELL
nmap <Leader>FF :FloatermNew <right>
nmap <Leader>FT :FloatermToggle <right>
nmap <Leader>FS :FloatermNew --wintype='split' <cr>
nmap <Leader>FK :FloatermKill!<CR>
nnoremap <Leader>vi :FloatermNew vifm <CR>
" make width 50% of tab
nmap <Leader>F5 :FloatermUpdate --width=0.5<CR>
"""""""""""""""""""""""""""""""""""""
" END FLOATERM
"""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""
" START VIM-MAXIMIZER
"""""""""""""""""""""""""""""""""""""
nnoremap mm :MaximizerToggle!<CR>
xnoremap mm :MaximizerToggle!<CR>
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

"""""""""""""""""""""""""""""""""""""
" START DEBUGGING
"""""""""""""""""""""""""""""""""""""
fun! GotoWindow(id)
    call win_gotoid(a:id)
endfun

" When debugging, continue. Otherwise start debugging.
" <F5>
nmap <C-Y> :call vimspector#Launch()<CR>

" Close the debugger
nmap <leader>dR :VimspectorReset<CR>

" Stop debugging.
" <F3>
nmap <leader>ds <Plug>VimspectorStop

" Pause debuggee.
" <F6>
nmap <leader>dp <Plug>VimspectorPause

" Restart debugging with the same configuration.
" <F4>
nmap <leader>dr <Plug>VimspectorRestart

nmap <leader>de :VimspectorEval
nmap <leader>dw :VimspectorWatch

" nmap <C-U> :VimspectorShowOutput

" Toggle line breakpoint on the current line.
" <F9>
nmap <leader>db <Plug>VimspectorToggleBreakpoint

" Toggle conditional line breakpoint on the current line.
" <leader>F9
nmap <leader>dc <Plug>VimspectorToggleConditionalBreakpoint

" Step Into
nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dh <Plug>VimspectorStepOut
nmap <leader>dk <Plug>VimspectorStepOver
nmap <leader>dj <Plug>VimspectorStepOver

nmap <leader>di <Plug>VimspectorBalloonEval
xmap <leader>di <Plug>VimspectorBalloonEval

" up/down the stack
nmap ,dk <Plug>VimspectorUpFrame
nmap ,dj <Plug>VimspectorDownFrame

nnoremap ,dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap ,dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap ,dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap ,dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap ,ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap ,do :call GotoWindow(g:vimspector_session_windows.output)<CR>

" `:VimspectorInstall` to install
" `:VimspectorToggleLog` to see location of VIMSPECTOR_HOME and gadgetDir.
let g:vimspector_install_gadgets = [
  \'debugpy',
  \'vscode-go',
  \'CodeLLDB',
  \'vscode-node-debug2',
  \'vscode-php-debug',
  \'debugger-for-chrome',
\]
"""""""""""""""""""""""""""""""""""""
" END DEBUGGING
"""""""""""""""""""""""""""""""""""""

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
