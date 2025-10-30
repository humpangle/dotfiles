-- Automatically add the directory containing this init.lua to runtimepath
local config_path = vim.fn.fnamemodify(vim.env.MYVIMRC or "", ":p:h")
vim.opt.runtimepath:prepend(config_path)

-- Also update Lua's package.path so require() works properly
package.path = config_path
  .. "/lua/?.lua;"
  .. config_path
  .. "/lua/?/init.lua;"
  .. package.path

-- make Joakker/lua-json5 work on macos.
-- https://github.com/neovim/neovim/issues/21749#issuecomment-1378720864
table.insert(vim._so_trails, "/?.dylib")

vim.opt.shell = os.getenv("SHELL") or "/bin/bash"

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.keymap.set("n", "<Space>", "<Nop>", {})
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local plugin_enabled = require("plugins/plugin_enabled")

require("plugins/plugin-init")

if plugin_enabled.has_vscode() then
  require("vscode_settings")
else
  require("theme_and_bg")
  require("settings")
  require("select-markdown-region")
end

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
