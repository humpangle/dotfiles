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
" gs = git set / reset
nnoremap <leader>gs  :Git reset --soft HEAD~
nnoremap <leader>gS  :Git reset --hard HEAD~
" gt = git take / pull
nnoremap <leader>gt :Git fetch<Cr>:execute 'Git pull origin ' . FugitiveHead()<Cr>
nnoremap <leader>gT  :Git pull <right>
nnoremap ,gf         :Git fetch<CR>
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
nnoremap <leader>gc  :tab new<CR>:Git commit<CR>
nnoremap <leader>ce  :Git commit --amend --no-edit
" -z means empty in bash - hence cz means allow empty
nnoremap <leader>cz  :Git commit --allow-empty -m ""<left>

nnoremap <leader>gu  :Git config user.name <right>

" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://*
  \ set bufhidden=delete |
  \ let b:coc_enabled = 0

" http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" git log --decorate=full
let g:fugitive_summary_format = '%d %s'
