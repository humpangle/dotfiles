let g:ale_enabled = 0 " Use :ALEEnable/:ALEToggle to enable
let g:ale_linters = {
\  'sh': ['shell', 'shellcheck'],
\}

map <leader>at :ALEToggle<cr>
map <leader>ae :ALEEnable<cr>
