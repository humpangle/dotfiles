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

    utils.map_key("n", "<leader>tt", function()
      local count = vim.v.count

      if count == 0 then
        vim.cmd("FloatermToggle")
      elseif count == 1 then
        vim.cmd("FloatermNew --hight=0.99 --width=0.99 --title=")
      elseif count == 2 then
        vim.cmd({ cmd = "FloatermKill", bang = true })
      elseif count == 3 then
        vim.cmd("FloatermNext")
      elseif count == 4 then
        vim.cmd("FloatermPrev")
      elseif count == 5 then
        vim.cmd("Floaterms")
      elseif count == 9 then
        vim.cmd.normal({ "yip" })

        local reg_value = vim.fn.getreg('"')
        reg_value = reg_value:gsub("[\n\\]", " ")

        vim.cmd("FloatermNew! --name=bla " .. reg_value)
      end
    end, { noremap = true, desc = "floaterm 0/tt 1/new 2/ls" })

    utils.map_key(
      "n",
      "<localleader>FU",
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
