so ~/.config/nvim/settings.vim

luafile ~/.config/nvim/lua/plugins/packer.lua

" THEME SELECTION
if !empty($EBNIS_VIM_THEME)
  so ~/.config/nvim/plugins/$EBNIS_VIM_THEME.vim
  if $EBNIS_VIM_THEME_BG == 'd'
    set background=dark
  else
    set background=light
  endif
else
  so ~/.config/nvim/plugins/vim-gruvbox8.vim
  set background=dark
endif

lua <<EOF
--vim.lsp.set_log_level('info') -- debug/error/trace
-- see plugins/packer.lua for globals

  if NO_USE_COC_LSP then
      require("lsp")
      require("plugins/emmet-vim")
      require("plugins/nvim-autopairs")
      require("plugins/nvim-compe")
      require("plugins/treesitter")
      require("plugins/undotree")
      require("plugins/vim-floaterm")
      require("nvim-ts-autotag").setup()
  end

  -- PLUGIN SETTINGS
  require("plugins/gitsigns-nvim")
  require("plugins/vim-fugitive")
  require("plugins/lightline")
  require("plugins/nvim-comment")
EOF

so ~/.config/nvim/plugins/fzf.vim
so ~/.config/nvim/plugins/neoformat.vim
so ~/.config/nvim/lua/plugins/lightline.vim
so ~/.config/nvim/lua/plugins/vim-maximizer.vim
so ~/.config/nvim/plugins/vCoolor.vim

let s:can_use_coc = !empty($VIM_USE_COC)

if s:can_use_coc
  so ~/.config/nvim/vim-plug.vim
endif
