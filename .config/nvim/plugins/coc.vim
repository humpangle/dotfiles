let g:coc_global_extensions = [
  \ 'coc-elixir',
  \ 'coc-spell-checker',
  \ 'coc-cspell-dicts',
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
  \ 'coc-svg',
  \ 'coc-vimlsp',
  \ 'coc-lua',
  \ 'coc-sh',
  \ '@yaegassy/coc-intelephense',
  \ 'coc-blade-formatter',
  \ 'coc-flutter',
  \ '@yaegassy/coc-volar',
  \ ]
  " \ 'coc-yank',
  " \ 'coc-vetur',
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
