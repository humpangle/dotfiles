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

if has('win32')
  let g:floaterm_shell= 'pwsh.exe'
else
  let g:floaterm_shell= $SHELL
endif

nmap <Leader>FF :FloatermNew <right>
nmap <Leader>FT :FloatermToggle <right>
nmap <Leader>FS :FloatermNew --wintype='split' <cr>
nmap <Leader>FK :FloatermKill!<CR>
nnoremap <Leader>vi :FloatermNew vifm <CR>
" make width 50% of tab
nmap <Leader>F5 :FloatermUpdate --width=0.5<CR>
