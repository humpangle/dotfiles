" https://medium.com/@jesseleite/its-dangerous-to-vim-alone-take-fzf-283bcff74d21

" Search file from root directory
nmap <Leader>ff :Files<CR>

" Search file from current directory
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>

" nmap <Leader>f :GFiles<CR>
nmap <Leader>bb :Buffers<CR>
" search buffers history
nmap <Leader>h :History<CR>
" search for tags without ctags (method names etc) or special package
" nmap <Leader>tg :BTags<CR>
" use with gutentags package
" nmap <Leader>T :Tags<CR>
" search for text in current buffer
nmap <Leader>l :BLines<CR>
" search for text in all buffers
nmap <Leader>L :Lines<CR>
nmap <Leader>m :Marks<CR>
" Fuzzy search defined commands, whether they be user defined, plugin
" defined, or native commands:
nmap <Leader>C :Commands<CR>
" Fuzzy search vim key mappings - useful to find what has already been mapped
" before defining new mappings
nmap <Leader>M :Maps<CR>
" Fuzzy search filetype syntaxes, and hit Enter on a result to set that syntax on the current buffer:
nmap <leader>ft :Filetypes<CR>
" search in project - do not match filenames
nmap <Leader>/ :Rrg<CR>
" search in project - match file names first
nmap ,/ :Rg<CR>
nmap <leader>cm :Commits<CR>

" Advanced ripgrep integration
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --hidden --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=* Rrg call fzf#vim#grep("rg --hidden --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

function! s:copy_fzf_results(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @+ = joined_lines
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': function('s:copy_fzf_results'),
  \ }
