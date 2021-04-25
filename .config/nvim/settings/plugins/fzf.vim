" Search file from root directory
nnoremap <Leader>ff :Files<CR>
" Search file from current directory
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
" find open buffers
nnoremap <Leader>fb :Buffers<CR>
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
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fs :Colors<CR>

" Tags
" find symbols in current buffer (fzf-lsp.nvim)
nnoremap <leader>bt :DocumentSymbols<CR>
" find tags in entire project directory (fzf-lsp.nvim)
nnoremap <leader>pt :WorkspaceSymbols<CR>
nnoremap <leader>fa :CodeActions<CR>
nnoremap <leader>fd :Diagnostics<CR>

" GIT
" Files managed by git
nnoremap <Leader>fg :GFiles<CR>
" Git commits
nnoremap <leader>cm :Commits<CR>
" Git commits for the current buffer
nnoremap <leader>bc :BCommits<CR>
" fzf-checkout
" find git branch:
" checkout = <CR>
" rebase = <C-r>
" delete = <C-d>
" merge = <C-e>
" track remote = <a-cr>
nnoremap <leader>cb :GBranches<CR>

" search in project - match file names first
nnoremap ,/ :Rg<CR>
" nnoremap <leader>sn :Snippets<CR>
" Vim’s :help documentation
nmap <Leader>H :Helptags!<CR>

" Advanced ripgrep integration
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --hidden --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=* Rrg
  \ call fzf#vim#grep(
  \   "rg --hidden --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
  \   1,
  \   {'options': '--delimiter : --nth 4..'},
  \   <bang>0
  \ )

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

" scroll the fzf vim listing buffer
autocmd FileType fzf tnoremap <buffer> <C-j> <Down>
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>
