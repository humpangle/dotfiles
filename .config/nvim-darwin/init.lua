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
  require("settings")
  require("theme_and_bg")
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
