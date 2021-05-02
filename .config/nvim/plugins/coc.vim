let g:coc_global_extensions = [
  \ 'coc-elixir',
  \ 'coc-spell-checker',
  \ 'coc-cspell-dicts',
  \ 'coc-yank',
  \ 'coc-json',
  \ 'coc-jedi',
  \ 'coc-emmet',
  \ 'coc-tsserver',
  \ 'coc-snippets',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-eslint',
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-svelte',
  \ 'coc-docker',
  \ 'coc-vetur',
  \ 'coc-svg',
  \ 'coc-vimlsp',
  \ 'coc-lua',
  \ ]
  " \ 'coc-emoji',
  " \ 'coc-sh',
  " \ 'coc-lists',
  " \ 'coc-tasks',
  " \ 'coc-fzf-preview',
  " \ 'coc-marketplace',
  " \ 'coc-pyright',
  " \ 'coc-explorer',

" let g:coc_force_debug = 1
let g:coc_filetype_map = {
  \ 'htmldjango': 'html',
  \ '.eslintrc': 'json',
  \ 'jinja': 'html',
  \ 'eelixir': 'html',
\}

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

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

function! s:show_documentation()
  if (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup coc_grp_1
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" use ``:Prettier` to format current buffer.
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" automatically close coc-explorer if it's the last buffer
" autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
