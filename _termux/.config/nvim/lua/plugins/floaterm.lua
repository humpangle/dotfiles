return {
  "voldikss/vim-floaterm",
  config = function()
    local utils = require("utils")

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

    utils.map_key(
      "n",
      "<Leader>vi",
      ":let @+=trim(execute(':pwd'))<bar>:FloatermNew vifm <CR>",
      { noremap = true }
    )

    utils.map_key(
      "n",
      "<Leader>vI",
      ":FloatermNew vifm <CR>",
      { noremap = true }
    )

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
