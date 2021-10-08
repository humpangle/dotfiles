" postgres — postgresql://user1:userpwd@localhost:5432/testdb

" mysql — mysql://user1:userpwd@127.0.0.1:3306/testdb

" nnoremap <leader>du :tabnew<CR>:DBUI<CR>
" nnoremap <leader>du :DBUIToggle<CR>
nnoremap <leader>du :DBUI<CR>
nnoremap <leader>df :DBUIFindBuffer<CR>
nnoremap <leader>dr :DBUIRenameBuffer<CR>
nnoremap <leader>dl :DBUILastQueryInfo<CR>
