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

if os.execute("command -v clip &>/dev/null") then
  -- keymap to sync content of unnamed register with external host's clipboard.
  -- WHY: https://github.com/wincent/clipper#configuration-for-vimrc
  --    This is a workarund for situations where a remote machine's clipboard
  --    does not sync with a macos client machine.
  vim.cmd([[
    nnoremap <leader>gg :call system('nc -N localhost 8377', @")<CR>
  ]])
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
