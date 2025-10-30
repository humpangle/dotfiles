local plugin_enabled = require("plugins/plugin_enabled")
if plugin_enabled.has_vscode() then
  return
end

local utils = require("utils")

return {
  "jpalardy/vim-slime",
  init = function()
    -- https://github.com/jpalardy/vim-slime/blob/main/assets/doc/targets/neovim.md
    vim.g.slime_target = "neovim"
    vim.g.slime_bracketed_paste = 1
    vim.g.slime_paste_file = vim.fn.expand("$HOME") .. "/.slime_paste"
  end,
  config = function()
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

    local default_tmux_target_pane = ":."
    local slime_config = {
      socket_name = "default",
      target_pane = default_tmux_target_pane, -- This means: current session and current window. All that is left to fill is pane number.
    }

    -- Some REPLs can interfere with your text pasting. The
    -- [bracketed-paste](https://cirw.in/blog/bracketed-paste) mode exists to allow
    -- raw pasting.

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

        local target_pane = default_tmux_target_pane .. count

        local count_as_string = "" .. count
        local two_digits_count_pattern = "^(%d+)(%d)$"

        local window_index, pane_index =
          count_as_string:match(two_digits_count_pattern)

        if window_index and pane_index then
          -- 99 is a special count which stands for pane index 0
          -- You must use 991, 992 etc
          -- If you use 99, it will be interpreted as window 9 pane 9
          if window_index == "99" then
            window_index = "0"
          end
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
  end,
}
