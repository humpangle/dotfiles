" Search file from root directory
nnoremap <c-p> :Files!<CR>
" Search file from current directory
nnoremap <Leader>f. :Files! <C-r>=expand("%:h")<CR>/<CR>
" find open buffers
nnoremap <Leader>fb :Buffers!<CR>
" search buffers history
nnoremap <Leader>fh :History!<CR>
" search for text in current buffer
nnoremap <Leader>fl :BLines!<CR>
" search for text in loaded buffers
" nnoremap <Leader>L :Lines!<CR>
nnoremap <Leader>fm :Marks!<CR>
nnoremap <leader>ft :Filetypes!<CR>
nnoremap <leader>fw :Windows!<CR>
" Find color schemes
nnoremap <leader>fs :Colors!<CR>
" commands: user defined, plugin defined, or native commands
nnoremap <Leader>C :Commands!<CR>
" key mappings - find already mapped before defining new mappings
nnoremap <Leader>M :Maps!<CR>
" search in project - do not match filenames
nnoremap <Leader>/ :RgNf!<CR>

" GIT
" Files managed by git
nnoremap <Leader>fg :GFiles!<CR>
" Search file from current directory
nnoremap <silent> <Leader>f, :GFiles! <C-r>=expand("%:h")<CR>/<CR>
" Git commits
nnoremap <leader>cm :Commits!<CR>
" Git commits for the current buffer
nnoremap <leader>c% :BCommits!<CR>
" fzf-checkout
" find git branch:
" checkout = <CR>
" rebase = <C-r>
" delete = <C-d>
" merge = <C-e>
" track remote = <a-cr>
nnoremap <leader>cb :GBranches!<CR>

" search in project - match file names first
nnoremap ,/ :Rg!<CR>
" nnoremap <leader>sn :Snippets<CR>
" Vim’s :help documentation
nmap <Leader>H :Helptags!<CR>

nnoremap <leader>fq :QuickFix!<CR>
nnoremap <leader>FL :LocList!<CR>

command! -bang -nargs=* RgNf
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

function! s:copy_fzf_results(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @+ = joined_lines
endfunction

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': function('s:copy_fzf_results'),
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ }

let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']

" scroll the fzf vim listing buffer
autocmd FileType fzf tnoremap <buffer> <C-j> <Down>
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>
