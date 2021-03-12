" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
" autocmd BufReadPost */.git/index set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

nnoremap gst         :Git st<CR>
nnoremap gcm         :Git commit<CR>
nnoremap gv         :Gvdiffsplit<CR>
" vertical split (3 way merge) to resolve git merge conflict
nnoremap gv!         :Gvdiffsplit!<CR>
nnoremap gss         :Gstatus<CR>
nnoremap ga.         :Git add .<CR>
nnoremap gpgm        :Git push github master<CR>
nnoremap gpgd        :Git push github dev<CR>
nnoremap ga%         :Git add %<CR>
nnoremap grb         :Git rebase -i HEAD~
nnoremap gst         :Git stash<CR>
nnoremap gsp         :Git stash pop<CR>
nnoremap gsl         :Git stash list<CR>
nnoremap glo         :Glog <CR>
nnoremap gl0         :0Glog <CR>
