---@diagnostic disable: inject-field

local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local PlenaryPath = require("plenary.path")

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

local is_only = function(text)
  return text == "o" or text == "on" or text == "only"
end

vim.api.nvim_create_user_command("Slime0", function(opts)
  -- opts.fargs[1] = nil | hist_dir | local | global
  --    hist_dir: query for the global history directory only and copy the path to system clipboard .
  --    local: create the slime input file in the current working directory.
  --    nil: implies local.
  --    global: create the slime input file in the global bash history directory.
  --
  -- opts.fargs[2] = nil | o | on | only --> create input file only, do not create terminal.

  local arg_size = #opts.fargs
  local action
  local only = false

  if arg_size == 0 then
    action = "local"
  elseif arg_size == 1 then
    if is_only(opts.fargs[1]) then
      action = "local"
      only = true
    end
  else
    action = opts.fargs[1]
    only = is_only(opts.fargs[2])
  end

  local slime_dir
  local timestamp = os.date("%s")

  if action == "local" then
    slime_dir = vim.fn.getcwd() .. "/.___scratch"
    local slime_dir_obj = PlenaryPath:new(slime_dir)

    -- if there is a file (not directory) at this path, rename it so we can create a directory with same name below.
    if slime_dir_obj:is_file() then
      os.rename(slime_dir, slime_dir .. "--" .. timestamp)
    end
  else
    slime_dir = vim.fn.expand("$HOME") .. "/.bash_histories"
  end

  -- Create the directory if it does not exist already.
  vim.fn.mkdir(slime_dir, "p")

  -- We merely want to query for the history directory.
  if action == "hist_dir" then
    vim.fn.setreg("+", slime_dir)
    vim.cmd(utils.clip_cmd)
    print(slime_dir)
    return
  end

  local name_affix = "~slime" .. timestamp
  local filename = slime_dir .. "/" .. name_affix

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

  if only then
    return
  end

  vim.cmd("vsplit")

  -- Move to the right window (which is now the new vertical split)
  vim.cmd("wincmd l")

  -- Open a terminal in the right window
  vim.cmd("terminal bash;" .. name_affix)

  -- Set the filetype to unix for the left window
  vim.cmd("wincmd h")
  vim.cmd("set filetype=unix")
end, {
  nargs = "*",
  force = true,
  desc = "Create a text buffer for vim slime and a terminal at the same time.",
  complete = function()
    -- return completion candidates as a list-like table
    return {
      "hist_dir",
      "local",
      "global",
      "only",
      "o",
      "on",
    }
  end,
})
