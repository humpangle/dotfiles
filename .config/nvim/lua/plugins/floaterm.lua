local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.floaterm() then
  return {}
end

local utils = require("utils")

return {
  "voldikss/vim-floaterm",
  config = function()
    -- vim.g.floaterm_keymap_toggle = '<F1>'
    -- vim.g.floaterm_keymap_next   = '<F2>'
    -- vim.g.floaterm_keymap_prev   = '<F3>'
    -- vim.g.floaterm_keymap_new    = '<F4>'
    vim.g.floaterm_autoinsert = 1
    vim.g.floaterm_width = 0.99
    vim.g.floaterm_height = 0.99
    vim.g.floaterm_wintitle = 0
    vim.g.floaterm_autoclose = 1
    vim.g.floaterm_position = "topright"

    if vim.fn.has("win32") == 1 then
      vim.g.floaterm_shell = "pwsh.exe"
    else
      vim.g.floaterm_shell = os.getenv("SHELL")
    end

    utils.map_key(
      "n",
      "<Leader>tt",
      ":FloatermToggle<CR>",
      { noremap = true }
    )

    utils.map_key(
      "n",
      "<Leader>ff",
      ":FloatermNew --height=0.99 --width=0.99 --title=",
      { noremap = true }
    )

    utils.map_key("n", ",FL", ":Floaterms<CR>", { noremap = true })

    utils.map_key("n", "<Leader>FK", ":FloatermKill!", { noremap = true })

    utils.map_key("n", "<Leader>vi", function()
      local count = vim.v.count
      local path = nil

      --  Use netrw
      if count == 1 then
        utils.handle_cant_re_enter_normal_mode_from_terminal_mode(
          function()
            vim.cmd("Vexplore1")
          end,
          {
            wipe = true,
            split = "vnew",
          }
        )
        return
      elseif count == 2 then
        path = vim.fn.expand("%:p:h")
      elseif count == 3 then
        path = vim.fn.getcwd()
      end

      if path ~= nil then
        vim.cmd("let @+=" .. '"' .. path .. '"')
        vim.cmd("let @z=" .. '"' .. path .. '"')
      end

      utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
        vim.cmd("FloatermNew vifm")
      end, {
        wipe = true,
      })
    end, { noremap = true, desc = "Float vifm 1dir 2pwd" })

    utils.map_key(
      "n",
      ",FU",
      ":FloatermUpdate --height=0.99 --width=0.99 --title",
      { noremap = true }
    )

    -- :FloatermUpdate
    -- title=a
    -- width=0.5
    -- wintype='vsplit' | 'split' | 'float'
  end,
  -- dependencies = { "voldikss/fzf-floaterm" },
}
