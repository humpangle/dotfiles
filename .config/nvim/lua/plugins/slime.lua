---@diagnostic disable: inject-field

local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local keymap = utils.map_key

-- Key to show slime config for the first time - <C-c><C-c>
-- Key to update slime config after starting - <C-c>v
-- Vim slime will prompt you for some config the first time it is ran.
-- You will be presented with string of the form:
--     tmux_session:
-- after the semicolon, type `w.p`, where
--     w = window number
--     p = pane number
-- E.g. if terminal is on 6th window, 4th pane, and session is `dot` you
-- should have
--     dot:6.4

local slime_config = {
  socket_name = "default",
  target_pane = "dot:",
}

vim.g.slime_default_config = slime_config

-- Some REPLs can interfere with your text pasting. The
-- [bracketed-paste](https://cirw.in/blog/bracketed-paste) mode exists to allow
-- raw pasting.

vim.g.slime_bracketed_paste = 1

local helper_func = function(target)
  -- https://github.com/jpalardy/vim-slime/blob/main/assets/doc/targets/neovim.md
  if target == "neovim" then
    vim.g.slime_input_pid = false
    vim.g.slime_suggest_default = false
    vim.g.slime_menu_config = true
    vim.g.slime_neovim_ignore_unlisted = false -- true
  end

  vim.b.slime_target = target
  vim.b.slime_config = slime_config

  -- Both of the below work 😀
  -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeConfig", true, true, true), "")
  vim.cmd(":SlimeConfig")
end

keymap("n", ",sln", function()
  helper_func("neovim")
end, { noremap = true, desc = "Slime config neovim" })

keymap("n", ",slt", function()
  helper_func("tmux")
end, { noremap = true, desc = "Slime config tmux" })

local slime_default_input_file_directory_path = vim.fn.expand("$HOME")
  .. "/.bash_histories"
vim.fn.mkdir(slime_default_input_file_directory_path, "p")

vim.api.nvim_create_user_command("SlimeFileTerminal", function()
  local timestamp = os.date("%s")

  local filename = slime_default_input_file_directory_path
    .. "/--vim-slime--"
    .. timestamp

  local file = io.open(filename, "w")
  if file then
    file:write("") -- Ensure the file is created empty.
    file:close()
  else
    print("Error: Unable to create file at " .. filename)
    return
  end

  vim.cmd("tabnew")

  -- Open the created file in the new tab
  vim.cmd("edit " .. filename)

  vim.cmd("vsplit")

  -- Move to the right window (which is now the new vertical split)
  vim.cmd("wincmd l")

  -- Open a terminal in the right window
  vim.cmd("term")

  -- Set the filetype to unix for the left window
  vim.cmd("wincmd h")
  vim.cmd("set filetype=unix")
end, {
  force = true,
  desc = "Create a text buffer for vim slime and a terminal at the same time.",
})

vim.api.nvim_create_user_command("SlimeFileDirectory", function()
  vim.fn.setreg("+", slime_default_input_file_directory_path)
  vim.cmd(utils.clip_cmd)
  print(slime_default_input_file_directory_path)
end, { force = true, desc = "" })
