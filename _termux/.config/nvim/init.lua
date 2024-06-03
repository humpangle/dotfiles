-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.keymap.set("n", "<Space>", "<Nop>", {})
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("plugins/plugin-init")

require("settings")
require("theme_and_bg")

-- Via: https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "json",
    "jsonc",
  },
  callback = function()
    vim.cmd([[syntax match Comment +\/\/.\+$+]])
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
