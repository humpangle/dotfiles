-- https://github.com/dag/vim-fish#teach-a-vim-to-fish
vim.o.shell = "/bin/bash"

-- editorconfig/editorconfig-vim
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }

vim.cmd("source ~/.config/nvim/settings.vim")
vim.cmd("source ~/.config/nvim/plugins/lightline.vim")
vim.cmd("source ~/.config/nvim/plugins/fugitive.vim")
vim.cmd("source ~/.config/nvim/plugins/fzf.vim")
vim.cmd("source ~/.config/nvim/plugins/vimspector.vim")
-- vim.cmd("source ~/.config/nvim/plugins/vim-easymotion.vim")
vim.cmd("source ~/.config/nvim/plugins/vim-maximizer.vim")

require('plugins/plugins')

-- THEME SELECTION
local env_vim_theme = os.getenv("EBNIS_VIM_THEME")
if env_vim_theme ~= nil then
  vim.cmd("source ~/.config/nvim/plugins/" .. env_vim_theme .. ".vim")
  if os.getenv("EBNIS_VIM_THEME_BG") == 'd' then
    vim.o.background = "dark"
  else
    vim.o.background = "light"
  end
else
  vim.cmd("colorscheme one")
  vim.o.background = "dark"
end

-- Make ~/.bashrc interactive
-- May be use https://stackoverflow.com/a/19819036
-- vim.o.shellcmdflag = "-ic"

local term_clear = function()
  vim.fn.feedkeys("", 'n')   -- control-L
  local sb = vim.bo.scrollback
  vim.bo.scrollback = 1
  vim.bo.scrollback = sb
end

vim.keymap.set('t', '<C-l>', term_clear)
