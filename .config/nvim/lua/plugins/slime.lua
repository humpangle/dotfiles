---@diagnostic disable: inject-field

local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local keymap = utils.map_key

vim.g.slime_last_channel = {}

vim.b.slime_target = "neovim"
-- let g:slime_target = "tmux"

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
  jobid = "",
}

vim.g.slime_default_config = slime_config

-- Some REPLs can interfere with your text pasting. The
-- [bracketed-paste](https://cirw.in/blog/bracketed-paste) mode exists to allow
-- raw pasting.

vim.g.slime_bracketed_paste = 1

local helper_func = function(target)
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
