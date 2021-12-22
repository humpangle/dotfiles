local present, packer = pcall(require, "plugins.packerInit")

if not present then
   return false
end

local use = packer.use

return packer.startup(function()
    -- battery included libraries relied upon by several plugins
   use "nvim-lua/plenary.nvim"

   use {
      "wbthomason/packer.nvim",
      event = "VimEnter",
   }

   use {
    -- Themes
        "rakr/vim-one",
        "lifepillar/vim-gruvbox8",
        "lifepillar/vim-solarized8",
   }
end)
