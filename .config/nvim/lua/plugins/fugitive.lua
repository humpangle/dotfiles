local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local keymap = utils.map_key

keymap("n", "<leader>g.", ":Git add .<CR>", { noremap = true })
keymap("n", "<leader>gd", ":Gvdiffsplit!<CR>", { noremap = true })

keymap("n", "<leader>gf", function()
  utils.write_to_command_mode(
    "Git push --force-with-lease origin " .. vim.fn.FugitiveHead()
  )
end, { noremap = true })

keymap(
  "n",
  "<leader>gF",
  ":Git push --force-with-lease github HEAD<CR>",
  { noremap = true }
)

keymap("n", "<leader>go", function()
  utils.write_to_command_mode("Git push origin " .. vim.fn.FugitiveHead())
end, { noremap = true })

-- gt = git take / pull
keymap("n", "<leader>gt", function()
  vim.cmd("Git fetch")

  utils.write_to_command_mode("Git pull origin " .. vim.fn.FugitiveHead())
end, { noremap = true })

-- Git stash related mappings

-- Git stash list inspired by
--   https://github.com/tpope/vim-fugitive/issues/236#issuecomment-1737935479
local git_stash_list_fn = function(callback)
  return function()
    local handle = io.popen("git stash list")
    local result = nil

    if handle ~= nil then
      result = handle:read("*a")
      handle:close()
    end

    if result and result ~= "" then
      local cmd =
        ":G --paginate stash list '--pretty=format:%h %as %<(10)%gd %<(76,trunc)%s'<CR>"

      if callback then
        callback(cmd)
      else
        vim.cmd(cmd)
      end
    else
      print("No stashes found")
    end
  end
end

keymap(
  "n",
  "czl",
  git_stash_list_fn(),
  { noremap = true, silent = true, desc = "Git stash list" }
)

keymap(
  "n",
  "czd",
  git_stash_list_fn(function(list_stash_cmd)
    vim.cmd(list_stash_cmd)

    vim.fn.feedkeys(
      vim.api.nvim_replace_termcodes(
        ":G stash drop stash@{}<left>",
        true,
        true,
        true
      ),
      "t"
    )
  end),
  { noremap = true, desc = "Git stash drop" }
)

keymap("n", "<Leader>czz", function()
  -- Get the latest Git commit hash
  local latest_commit = vim.fn.systemlist("git rev-parse --short HEAD")[1]

  local count = vim.v.count
  local cmd = "Git stash push"

  if count == 1 then
    cmd = cmd .. " --include-untracked"
  elseif count > 1 then
    cmd = cmd .. " --all"
  end

  -- Append text for custom message with the latest commit hash and place cursor between quotes
  cmd = cmd .. " -m '" .. latest_commit .. ": '"

  -- Move the cursor back by one position to place it after the commit hash and before the end quote
  vim.fn.feedkeys(
    ":" .. cmd .. vim.api.nvim_replace_termcodes("<Left>", true, true, true),
    "t"
  )
end, {
  noremap = true,
  desc = "G stash push --include-untracked/--all -m 'GITHEAD: '",
})
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

-- Rebase keymaps
keymap("n", "<Leader>r<Space>", function()
  utils.write_to_command_mode("G rebase ")
end, { noremap = true, desc = [[Populate command line with :Git rebase .]] })

keymap("n", "<Leader>rr", function()
  utils.write_to_command_mode("G rebase --continue")
end, { noremap = true, desc = [[Continue the current rebase.]] })

keymap("n", "<Leader>ra", function()
  utils.write_to_command_mode("G rebase --abort")
end, { noremap = true, desc = [[Abort the current rebase.]] })

keymap("n", "<Leader>re", function()
  utils.write_to_command_mode("G rebase --edit-todo")
end, { noremap = true, desc = [[Edit the current rebase todo list.]] })
-- /END Rebase keymaps

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
