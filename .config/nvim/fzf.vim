" Search file from root directory
nnoremap <c-p> :FZFFiles!<CR>
" Search file from current directory
nnoremap <silent> <Leader>f. :FZFFiles! <C-r>=expand("%:h")<CR>/<CR>
" find open buffers
nnoremap <Leader>fb :Buffers!<CR>
" search buffers history
nnoremap <Leader>fh :FZFHistory!<CR>
" search for text in current buffer
nnoremap <Leader>fl :FZFBLines!<CR>
" search for text in loaded buffers
" nnoremap <Leader>L :Lines!<CR>
nnoremap <Leader>fm :FZFMarks!<CR>
nnoremap <leader>ft :Filetypes!<CR>
nnoremap <leader>fw :FZFWindows!<CR>
" Find color schemes
nnoremap <leader>fs :Colors!<CR>
" commands: user defined, plugin defined, or native commands
nnoremap <Leader>C :Commands!<CR>
" key mappings - find already mapped before defining new mappings
nnoremap <Leader>M :Maps!<CR>
" search in project - do not match filenames
nnoremap <Leader>/ :FZFRg!<CR>
" find symbols in current buffer (ctags -R)
nnoremap ,bt :FZFBTags!<CR>
" find symbols in project directory (ctags -R)
nnoremap ,pt :FZFTags!<CR>

if !g:can_use_coc
  " Tags
  " find symbols in current buffer (fzf-lsp.nvim)
  nnoremap <leader>bt :DocumentSymbols!<CR>
  " find tags in entire project directory (fzf-lsp.nvim)
  nnoremap <leader>pt :WorkspaceSymbols!<CR>
  nnoremap <leader>fa :CodeActions!<CR>
  nnoremap <leader>fd :Diagnostics!<CR>
endif

" GIT
" Files managed by git
nnoremap <Leader>fg :GFiles!<CR>
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

nnoremap <leader>fq :FZFQuickFix!<CR>
nnoremap <leader>FL :FZFLocList!<CR>

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
