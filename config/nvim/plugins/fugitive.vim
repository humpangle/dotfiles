nnoremap <leader>g.  :Git add .<CR>
nnoremap <leader>g0  :0Gclog! -
nnoremap <leader>g%  :Git add %<CR>
nnoremap <leader>gb  :Git blame<CR>
nnoremap <leader>gd  :Gvdiffsplit!<CR>
nnoremap <leader>ge  :Gedit <right>
nnoremap <leader>gf  :Git push --force-with-lease origin HEAD
nnoremap <leader>gF  :Git push --force-with-lease github HEAD
" git status
nnoremap <leader>gg  :Git<CR>
nnoremap <leader>gh  :Git push github HEAD
" vertical split (3 way merge) to resolve git merge conflict
nnoremap <leader>gl  :Gclog! -
nnoremap <leader>go  :Git push origin HEAD
nnoremap <leader>gp  :Git push  HEAD<left><left><left><left><left>
nnoremap <leader>gr  :Git rebase -
nnoremap <leader>gs  :Git reset --soft HEAD~
nnoremap <leader>gS  :Git reset --hard HEAD~
" gt = git take
nnoremap <leader>gt  :Git pull <right>
nnoremap <leader>gw  :Git worktree <right>

nnoremap <leader>s%  :Git stash push -m '' -- %<left><left><left><left><left><left>
nnoremap <leader>sa  :Git stash apply stash@{}<left>
nnoremap <leader>sc  :Git stash clear
nnoremap <leader>sd  :Git stash drop stash@{}<left>
nnoremap <leader>sk  :Git stash push --keep-index -m ''<left>
nnoremap <leader>sl  :Git stash list<CR>
nnoremap <leader>sp  :Git stash push -m ''<left>
nnoremap <leader>sP  :Git stash pop
nnoremap <leader>ss  :Git stash show -p stash@{}<left>
nnoremap <leader>su  :Git stash -u push -m ''<left>

nnoremap <leader>ca  :Git commit --amend
nnoremap <leader>gc  :Git commit<CR>
nnoremap <leader>ce  :Git commit --amend --no-edit
nnoremap <leader>cz  :Git commit --allow-empty -m ""<left>

" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://*
  \ set bufhidden=delete |
  \ let b:coc_enabled = 0

autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
