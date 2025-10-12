local utils = require("utils")
local keymap = utils.map_key

keymap("n", "<leader>gd", function()
  local count = vim.v.count

  if count == 0 then
    vim.cmd("Gvdiffsplit!")
    return
  end

  if count == 1 then
    vim.cmd("Ghdiffsplit!")
    return
  end
end, {
  noremap = true,
  desc = "0/v 1/h",
})

keymap("n", "<leader>gp", function()
  local count = vim.v.count
  if count == 0 then
    utils.write_to_command_mode("Git push origin " .. vim.fn.FugitiveHead())
    return
  end

  if count == 1 then
    utils.write_to_command_mode(
      "Git push --force-with-lease origin " .. vim.fn.FugitiveHead()
    )
    return
  end
end, { noremap = true, desc = "Git push 0/ 1/force" })

local git_commit_mappings_opts = {
  noremap = true,
  desc = "Git commit 0/fzf 1/cm 11/cm-amend 12/cm-amend-no-edit 13/cm-empty",
}

local function git_commit_mappings_fn()
  utils.create_fzf_key_maps(require("plugins.fugitive.commit_options"), {
    prompt = "Git Commit Options>  ",
    header = "Select a git commit option",
  })
end

keymap("n", "<leader>gc", git_commit_mappings_fn, git_commit_mappings_opts)

-- Git config.user
keymap("n", "<leader>gu", function()
  local cmd = ""
  local count = vim.v.count

  if count == 0 then
    cmd = ":Git config user.name <right>"
  elseif count == 1 then
    cmd = ":Git config user.email <right>"
  elseif count == 2 then
    local git_user = utils.get_os_env_or_nil("GIT_USER")

    local git_user_email = utils.get_os_env_or_nil("GIT_USER_EMAIL")

    if git_user ~= nil and git_user_email ~= nil then
      cmd = ":Git config user.name "
        .. git_user
        .. "<bar>"
        .. ":Git config user.email "
        .. git_user_email
    end
  end

  if cmd == "" then
    vim.cmd.echo(
      '"We can not set git user/email.Set GIT_USER/GIT_USER_EMAIL Aborting!"'
    )
    return
  end

  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(cmd, true, true, true), "t")
end, { noremap = true, desc = "Git config user name. 1=email 2=env defaults" })

keymap("n", "<Leader>rr", function()
  local count = vim.v.count

  if count == 0 then
    utils.write_to_command_mode("G rebase --continue")
    return
  end

  if count == 1 then
    utils.write_to_command_mode("G rebase --edit-todo")
    return
  end

  if count == 2 then
    utils.write_to_command_mode("G rebase --abort")
    return
  end
end, { noremap = true, desc = [[Git rebase 0/continue 1/edit 2/abort]] })
-- /END Rebase keymaps

keymap("n", "<leader>gg", function()
  utils.create_fzf_key_maps(require("plugins.fugitive.log-options"), {
    prompt = "Git Log Options>  ",
    header = "Select a git log option",
  })
end, {
  noremap = true,
  desc = "Git commit 1/all 2/file% 3/all-",
})

-- git blame
keymap({ "n", "x" }, "<leader>gb", function()
  local count = vim.v.count

  if count == 0 then
    vim.cmd("Git blame")
    return
  end

  utils.write_to_command_mode("GBrowse")
end, { desc = "G blame/GBrowse" })

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    keymap("n", "cc", git_commit_mappings_fn, {
      buffer = true,
      noremap = true,
      desc = "Git commit options (fzf)",
    })
  end,
})

vim.g.fugitive_summary_format = "%d %s"
