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
nnoremap gss  :Gstatus<CR>
nnoremap ga.  :Git add .<CR>
nnoremap gpm  :Git push origin master<CR>
nnoremap gpd  :Git push origin dev<CR>
nnoremap gpo  :Git push origin <right>
nnoremap gpf  :Git push --force origin <right>
nnoremap gcma :Git commit --amend
nnoremap gcme :Git commit --amend --no-edit
nnoremap ga%  :Git add %<CR>
nnoremap grb  :Git rebase -i HEAD~
nnoremap gsp  :Git stash push -m ''<left>
nnoremap gs%  :Git stash push -m '' -- %<left><left><left><left><left><left>
nnoremap gsa  :Git stash apply stash@{}<left>
nnoremap gsd  :Git stash drop stash@{}<left>
nnoremap gsl  :Git stash list<CR>
nnoremap gsc  :Git stash clear<CR>
nnoremap glo  :Glog <CR>
nnoremap gl0  :0Glog <CR>
