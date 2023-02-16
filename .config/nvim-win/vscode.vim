" Save file
nnoremap <Leader>ww :Write<CR>
nnoremap <Leader>wa :Wall<CR>
nnoremap <Leader>wq :Wq<cr>

" Quit vim
nnoremap <leader>qq <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <leader>qa <Cmd>call VSCodeNotify('workbench.action.closeWindow')<CR>

" TABS
nnoremap <leader>ts :call VSCodeNotify('workbench.action.newWindow')<CR>

" Move between windows in a tab
nnoremap <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

" RESIZE WINDOW
nnoremap <c-left> :call VSCodeNotify('workbench.action.increaseViewSize')<CR>
nnoremap <c-right> :call VSCodeNotify('workbench.action.decreaseViewSize')<CR>

nnoremap <c-w>w :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

nnoremap ,rm :call VSCodeNotify('deleteFile')<cr>
nnoremap ,ec :Edit $MYVIMRC<cr>

" TO MOVE LINES up/down
nnoremap <A-k> :call VSCodeNotify('editor.action.moveLinesUpAction')<CR>
nnoremap <A-j> :call VSCodeNotify('editor.action.moveLinesDownAction')<CR>

" TERMINAL
nnoremap <silent> <leader>tt <Cmd>:call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>

" COPY FILE PATH
" yank relative File path
nnoremap ,yr <Cmd>call VSCodeNotify('copyRelativeFilePath')<CR>
" yank absolute File path
nnoremap ,yf <Cmd>call VSCodeNotify('copyFilePath')<CR>

" BUFFERS
" Delete all buffers
nnoremap <leader>ba :call VSCodeNotify('workbench.action.closeOtherEditors')<cr>
nnoremap <leader>bA :call VSCodeNotify('workbench.action.closeAllEditors')<cr>
" Delete current buffer
nnoremap <leader>bd :call VSCodeNotify('workbench.action.closeActiveEditor')<cr>
nnoremap <leader>bg :call VSCodeNotify('workbench.action.closeEditorsInGroup')<cr>
nnoremap <leader>bo :call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')<cr>
nnoremap <silent> <leader>fv <Cmd>:call VSCodeNotify('workbench.action.toggleFullScreen')<CR>
nnoremap <silent> <leader>ll <Cmd>:call VSCodeNotify('editor.action.openLink')<CR>

" Fugitive
nnoremap <leader>gg :call VSCodeNotify('workbench.view.scm')<cr>

" FZF
nnoremap <leader>ff :call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>/ <Cmd>call VSCodeNotify('workbench.action.replaceInFiles')<CR>
nnoremap <leader>bt <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap <leader>pt <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>

" https://code.visualstudio.com/docs/editor/editingevolved#_how-can-i-configure-ctrltab-to-navigate-across-all-editors-of-all-groups
nnoremap <leader>fl :call VSCodeNotify('actions.find')<CR>
nnoremap <leader>fw :call VSCodeNotify('workbench.action.quickOpenPreviousRecentlyUsedEditor')<CR>
nnoremap <leader>fs <Cmd>call VSCodeNotify('workbench.action.selectTheme')<CR>

" START NEOFORMAT
nnoremap <leader>fc <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>

"""""""""""""""""""""""""""""""""""""
" COC START
"""""""""""""""""""""""""""""""""""""
nnoremap ]d <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nnoremap [d <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
nnoremap <leader>dd <Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>
nnoremap <leader>cx <Cmd>call VSCodeNotify('workbench.view.extensions')<CR>
" use built-in <c-.>
" nnoremap <leader>ac <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
nnoremap <leader>rn :call VSCodeNotify('editor.action.rename')<CR>
nnoremap ,o <Cmd>call VSCodeNotify('editor.action.organizeImports')<CR>
nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
" gD = editor.action.peekDefinition/declaration
" <C-w>gd = editor.action.revealDefinitionAside
"""""""""""""""""""""""""""""""""""""
" END COC
"""""""""""""""""""""""""""""""""""""

" commentary
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" FOLDS
nnoremap zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
nnoremap zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>

" DEBUGGING
nnoremap <silent> <leader>dS <Cmd>:call VSCodeNotify('workbench.action.debug.start')<CR>
nnoremap <silent> <leader>db <Cmd>:call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>
nnoremap <silent> <leader>dc <Cmd>:call VSCodeNotify('workbench.action.debug.continue')<CR>
nnoremap <silent> <leader>ds <Cmd>:call VSCodeNotify('workbench.action.debug.stepOver')<CR>
nnoremap <silent> <leader>do <Cmd>:call VSCodeNotify('workbench.debug.action.toggleRepl')<CR>
