local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local keymap = utils.map_key

local function write_to_command_mode(string)
  -- Prepend ':' to enter command mode, don't append '<CR>' to avoid executing
  -- Use 't' flag in feedkeys to interpret keys as if typed by the user
  vim.fn.feedkeys(
    vim.api.nvim_replace_termcodes(":" .. string, true, false, true),
    "t"
  )
end

keymap("n", "<leader>g.", ":Git add .<CR>", { noremap = true })
keymap("n", "<leader>gd", ":Gvdiffsplit!<CR>", { noremap = true })

keymap("n", "<leader>gf", function()
  write_to_command_mode(
    "Git push --force-with-lease origin " .. vim.fn.FugitiveHead()
  )
end, { noremap = true })

keymap(
  "n",
  "<leader>gF",
  ":Git push --force-with-lease github HEAD<CR>",
  { noremap = true }
)

vim.keymap.set("n", "<leader>go", function()
  write_to_command_mode("Git push origin " .. vim.fn.FugitiveHead())
end, { noremap = true })

-- gt = git take / pull
vim.keymap.set("n", "<leader>gt", function()
  vim.cmd("Git fetch")

  local fugitiveHead = vim.fn.FugitiveHead()
  vim.cmd("Git pull origin " .. fugitiveHead)
end, { noremap = true })

-- Git stash related mappings
-- Inspired by
--    https://github.com/tpope/vim-fugitive/issues/236#issuecomment-1737935479
keymap(
  "n",
  "czl",
  ":Git<CR>:G --paginate stash list '--pretty=format:%h %as %<(10)%gd %<(76,trunc)%s'<CR>",
  { noremap = true, silent = true, desc = "Git stash list" }
)
-- END Git stash related mappings

-- Git commit mappings
keymap("n", "<leader>gcc", ":Git commit<CR>", { noremap = true })
keymap("n", "<leader>gca", ":Git commit --amend<CR>", { noremap = true })

keymap(
  "n",
  "<leader>gce",
  ":Git commit --amend --no-edit",
  { noremap = true, desc = "Git commit amend no edit" }
)

keymap("n", "<leader>gcz", ":Git commit --allow-empty ", {
  noremap = true,
  desc = 'Git commit allow empty. Pass -m "message" to pass message on cmd.',
})

-- Git config.user
keymap(
  "n",
  "<leader>gu",
  ":Git config user.name <right>",
  { noremap = true, desc = "Git config user name" }
)

keymap(
  "n",
  "<leader>gU",
  ":Git config user.email <right>",
  { noremap = true, desc = "Git config user email" }
)

-- Auto-clean Fugitive Buffers
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "fugitive://*",
  callback = function()
    vim.opt_local.bufhidden = "delete"
  end,
})

-- http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
-- Fugitive Browsing Git Object Database
vim.api.nvim_create_autocmd("User", {
  pattern = "fugitive",
  callback = function()
    vim.cmd([[
        if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
          keymap("n", "<buffer> .. :edit %:h<CR> |
        endif
      ]])
  end,
})

--  Remapping in Gitcommit FileType
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    keymap("n", "<leader>wq", utils.ebnis_save_commit_buffer, {
      noremap = true,
      buffer = true,
    })
  end,
})

vim.g.fugitive_summary_format = "%d %s"
