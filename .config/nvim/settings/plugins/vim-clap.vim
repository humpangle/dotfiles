" Search file from root directory
nnoremap <Leader>ff :Clap files<CR>
" Search file from current directory
nnoremap <silent> <Leader>. :Clap files <C-r>=expand("%:h")<CR>/<CR>
" find open buffers
nnoremap <Leader>fb :Clap buffers<CR>
" Files managed by git
nnoremap <Leader>fg :Clap git_files<CR>
" search buffers history
nnoremap <Leader>hh :Clap command_history<CR>
" search for text in current buffer
nnoremap <Leader>bl :Clap blines<CR>
" search for text in loaded buffers
nnoremap <Leader>L :Clap lines<CR>
nnoremap <Leader>mm :Clap marks<CR>
" commands: user defined, plugin defined, or native commands
nnoremap <Leader>C :Clap command<CR>
" key mappings - find already mapped before defining new mappings
nnoremap <Leader>M :Clap maps<CR>
nnoremap <leader>ft :Clap filetypes<CR>
" search in project
nnoremap <Leader>/ :Clap grep2<CR>
" Git commits
nnoremap <leader>cm :Clap commits<CR>
" Git commits for the current buffer
nnoremap <leader>bc :Clap bcommits<CR>
nnoremap fww :Clap windows<CR>
nnoremap fcs :Clap colors<CR>
" find tags in current buffer: requires liuchengxu/vista.vim
nnoremap fbt :Clap tags<CR>
" find tags in entire project directory
nnoremap fpt :Clap proj_tags<CR>
" Ivy-like file explorer - use tab to enter directory
nnoremap <Leader>fe :Clap filer<CR>
nnoremap fyy :Clap yanks<CR>
nnoremap fqf :Clap quickfix<CR>

let g:clap_theme = 'material_design_dark'

let g:clap_layout = {
  \ 'relative': 'editor'
  \ }
