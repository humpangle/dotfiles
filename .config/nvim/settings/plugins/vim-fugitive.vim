" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
" autocmd BufReadPost */.git/index set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

map gst         :Git st<CR>
map gcm         :Git commit<CR>
map gvs         :Gvdiffsplit<CR>
" vertical split to resolve git merge conflict
map gvc         :Gvdiffsplit!<CR>
map gss         :Gstatus<CR>
map ga.         :Git add .<CR>
map gpgm        :Git push github master<CR>
map gpgd        :Git push github dev<CR>
map ga%         :Git add %<CR>
map grb         :Grebase -i HEAD~
map gst         :Git stash<CR>
map gsp         :Git stash pop<CR>
map gsl         :Git stash list<CR>
map glo         :Glog <CR>
map gl0         :0Glog <CR>
