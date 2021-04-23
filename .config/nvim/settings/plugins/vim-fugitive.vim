" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
" autocmd BufReadPost */.git/index set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

nnoremap gst  :Git status<CR>
nnoremap gcm  :Git commit<CR>
" vertical split (3 way merge) to resolve git merge conflict
nnoremap gvs  :Gvdiffsplit!<CR>
nnoremap gss  :Git<CR>
nnoremap <leader>st  :Git<CR>
nnoremap <leader>a.  :Git add .<CR>
nnoremap gpm  :Git push origin master<CR>
nnoremap gpd  :Git push origin dev<CR>
nnoremap gpo  :Git push origin <right>
nnoremap <leader>pf  :Git push --force origin <right>
nnoremap gcma :Git commit --amend
nnoremap gcme :Git commit --amend --no-edit
nnoremap ga%  :Git add %<CR>
nnoremap <leader>rb  :Git rebase -i HEAD~
nnoremap <leader>sp  :Git stash push -m ''<left>
nnoremap <leader>s%  :Git stash push -m '' -- %<left><left><left><left><left><left>
nnoremap <leader>sa  :Git stash apply stash@{}<left>
nnoremap <leader>sd  :Git stash drop stash@{}<left>
nnoremap <leader>sl  :Git stash list<CR>
nnoremap gsc  :Git stash clear<CR>
nnoremap <leader>gl  :Gllog!<CR>
nnoremap gl0  :0Gllog!<CR>
