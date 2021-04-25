local u = require("utils.core")

Cmd(
    [[ autocmd User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |   nnoremap <buffer> .. :edit %:h<CR> | endif ]])

u.map("n", "gst", [[:Git status<CR>]])
u.map("n", "gcm", [[:Git commit<CR>]])
-- vertical split (3 way merge) to resolve git merge conflict
u.map("n", "gvs", [[:Gvdiffsplit!<CR>]])
u.map("n", "gss", [[:Git<CR>]])
u.map("n", "<leader>st", [[:Git<CR>]])
u.map("n", "<leader>a.", [[:Git add .<CR>]])
u.map("n", "gpo", [[:Git push origin ]])
u.map("n", "<leader>pf", [[:Git push --force origin ]])
u.map("n", "gcma", [[:Git commit --ameend]])
u.map("n", "gcme", [[:Git commit --amend --no-edit]])
u.map("n", "ga%", [[:Git add %<CR>]])
u.map("n", "<leader>rb", [[:Git rebase -i HEAD~]])
u.map("n", "<leader>sp", [[:Git stash push -m ''<left>]])
u.map("n", "<leader>s%",
      [[:Git stash push -m '' -- %<left><left><left><left><left><left>]])
u.map("n", "<leader>sa", [[:Git stash apply stash@{}<left>]])
u.map("n", "<leader>sd", [[:Git stash drop stash@{}<left>]])
u.map("n", "<leader>sl", [[:Git stash list<CR>]])
u.map("n", "gsc", [[:Git stash clear<CR>]])
u.map("n", "<leader>gl", [[:Gllog!<CR>]])
u.map("n", "gl0", [[:0Gllog!<CR>]])
