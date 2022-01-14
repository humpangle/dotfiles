" git status
nnoremap <leader>gg  :Git<CR>
nnoremap <leader>gc  :Git commit<CR>
" vertical split (3 way merge) to resolve git merge conflict
nnoremap <leader>gd  :Gvdiffsplit!<CR>
nnoremap <leader>g.  :Git add .<CR>
nnoremap <leader>g%  :Git add %<CR>
nnoremap <leader>gl  :Gclog! -
nnoremap <leader>g0  :0Gclog! -
nnoremap <leader>ge  :Gedit <right>
nnoremap <leader>gb  :Git blame<CR>

nnoremap <leader>gr  :Git rebase -

nnoremap <leader>sk  :Git stash push --keep-index -m ''<left>
nnoremap <leader>su  :Git stash -u push -m ''<left>
nnoremap <leader>sp  :Git stash push -m ''<left>
nnoremap <leader>s%  :Git stash push -m '' -- %<left><left><left><left><left><left>
nnoremap <leader>sa  :Git stash apply stash@{}<left>
nnoremap <leader>sd  :Git stash drop stash@{}<left>
nnoremap <leader>ss  :Git stash show -p stash@{}<left>
nnoremap <leader>sl  :Git stash list<CR>
nnoremap <leader>sP  :Git stash pop
nnoremap <leader>sc  :Git stash clear

nnoremap <leader>go  :Git push origin HEAD
nnoremap <leader>gh  :Git push github HEAD
nnoremap <leader>gp  :Git push  HEAD<left><left><left><left><left>
nnoremap <leader>gf  :Git push --force-with-lease origin HEAD
nnoremap <leader>gF  :Git push --force-with-lease github HEAD
nnoremap <leader>ca  :Git commit --amend<cr>
nnoremap <leader>ce  :Git commit --amend --no-edit
nnoremap <leader>ct  :Git commit --allow-empty -m ""<left>
nnoremap <leader>gw  :Git worktree <right>

" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
