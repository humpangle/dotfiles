so ~/.config/nvim/settings/settings.vim
so ~/.config/nvim/settings/mappings.vim

luafile ~/.config/nvim/lua/plugins/packer.lua

lua <<EOF
 -- see plugins.lua for globals
  require("theme")

  if NO_USE_COC_LSP then
      require("lsp")
      require("plugins/emmet-vim")
      require("plugins/nvim-comment")
      require("plugins/nvim-autopairs")
      require("plugins/nvim-compe")
      require("plugins/telescope")
      require("plugins/treesitter")
      require("plugins/undotree")
      require("plugins/vim-floaterm")
      require("nvim-ts-autotag").setup()
  end

  -- PLUGIN SETTINGS
  require("plugins/gitsigns-nvim")
  require("plugins/vim-fugitive")
  require("plugins/lightline")
EOF

so ~/.config/nvim/settings/plugins/neoformat.vim
so ~/.config/nvim/lua/plugins/lightline.vim
so ~/.config/nvim/lua/plugins/vim-maximizer.vim

let s:can_use_coc = !empty($VIM_USE_COC)

if s:can_use_coc
  so ~/.config/nvim/settings/vim-plug.vim
endif
