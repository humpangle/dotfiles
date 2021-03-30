" Search file from root directory
nnoremap <Leader>ff :Files<CR>
" Search file from current directory
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
" find open buffers
nnoremap <Leader>fb :Buffers<CR>
" Files managed by git
nnoremap <Leader>fg :GFiles<CR>
" search buffers history
nnoremap <Leader>hh :History<CR>
" search for text in current buffer
nnoremap <Leader>bl :BLines<CR>
" search for text in loaded buffers
nnoremap <Leader>L :Lines<CR>
nnoremap <Leader>mm :Marks<CR>
" commands: user defined, plugin defined, or native commands
nnoremap <Leader>C :Commands<CR>
" key mappings - find already mapped before defining new mappings
nnoremap <Leader>M :Maps<CR>
nnoremap <leader>ft :Filetypes<CR>
" search in project - do not match filenames
nnoremap <Leader>/ :Rrg<CR>
" Git commits
nnoremap <leader>cm :Commits<CR>
" Git commits for the current buffer
nnoremap <leader>bc :BCommits<CR>
nnoremap fww :Windows<CR>
nnoremap fcs :Colors<CR>
" search in project - match file names first
nnoremap ,/ :Rg<CR>
" search for tags without ctags (method names etc) or special package
" nnoremap <Leader>tg :BTags<CR>
" use with gutentags package
" nnoremap <Leader>T :Tags<CR>

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
