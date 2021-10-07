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

nnoremap <Leader>FF :FloatermNew <right>
nnoremap <Leader>FT :FloatermToggle<CR>
nnoremap <Leader>__FloatermNewVSplit :FloatermNew --wintype='vsplit'
nnoremap <Leader>FK :FloatermKill!
nnoremap <Leader>vi :FloatermNew vifm <CR>
nnoremap <Leader>__Floaterms :Floaterms

" :FloatermUpdate
" --title=a
" --width=0.5
" --wintype='vsplit' / 'split'
nnoremap <Leader>__FloatermUpdate :FloatermUpdate --
