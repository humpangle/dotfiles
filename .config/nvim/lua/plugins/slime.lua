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
-- A very useful syntax (used below) is
--      :.
-- Nothing before `:` means use current session.
-- Nothing before `.` means use current window.
-- All that is left is a number after `.` for the required pane number.

local default_target_pane = ":."
local slime_config = {
  socket_name = "default",
  target_pane = default_target_pane, -- This means: current session and current window. All that is left to fill is pane number.
}

-- Some REPLs can interfere with your text pasting. The
-- [bracketed-paste](https://cirw.in/blog/bracketed-paste) mode exists to allow
-- raw pasting.

vim.g.slime_bracketed_paste = 1

vim.g.slime_neovim_menu_order = {
  { jobid = "" },
  { name = "" },
}

keymap("n", "<localleader>sl", function()
  local count = vim.v.count

  -- https://github.com/jpalardy/vim-slime/blob/main/assets/doc/targets/neovim.md

  if count == 0 then
    vim.b.slime_target = "neovim"

    vim.g.slime_input_pid = false
    vim.g.slime_suggest_default = false
    -- prompt for menu to show which terminal to select
    vim.g.slime_menu_config = true
    vim.g.slime_neovim_ignore_unlisted = true

    -- Both of the below work 😀
    -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>SlimeConfig", true, true, true), "")
    vim.cmd("SlimeConfig")
  else
    vim.b.slime_target = "tmux"

    local target_pane = default_target_pane .. count

    local count_as_string = "" .. count
    local two_digits_count_pattern = "^(%d+)(%d)$"

    local window_index, pane_index =
      count_as_string:match(two_digits_count_pattern)

    if window_index and pane_index then
      target_pane = ":" .. window_index .. "." .. pane_index
    end

    slime_config.target_pane = target_pane

    vim.b.slime_config = slime_config

    -- :lua vim.b.slime_config = { socket_name='default', target_pane=':.2' }
    -- cursor will be at 2 (pane number)
    local args = "lua vim.b.slime_config = { "
      .. "socket_name="
      .. "'"
      .. slime_config.socket_name
      .. "'"
      .. ", "
      .. "target_pane="
      .. "'"
      .. slime_config.target_pane
      .. "'"
      .. " }"
      .. "<left><left><left>"

    utils.write_to_command_mode(args)
  end
end, {
  noremap = true,
  desc = "Slime config 0/nvim 1/tmux 114/tmux 11=win 4=pane",
})

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
    slime_dir = utils.create_slime_dir()
  else
    slime_dir = vim.fn.expand("$HOME") .. "/.bash_histories"
    vim.fn.mkdir(slime_dir, "p")
  end

  -- We merely want to query for the history directory.
  if action == "hist_dir" then
    vim.fn.setreg("+", slime_dir)
    return
  end

  local name_affix = "s0" .. timestamp
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
