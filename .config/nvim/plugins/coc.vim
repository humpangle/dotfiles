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
  \ 'coc-sh',
  \ '@yaegassy/coc-intelephense',
  \ 'coc-blade-formatter',
  \ ]
  " \ 'coc-php-cs-fixer',
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
set signcolumn=auto


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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup coc_grp_1
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" automatically close coc-explorer if it's the last buffer
" autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
