" https://github.com/dag/vim-fish#teach-a-vim-to-fish
set shell=/bin/bash
let $VIM_USE_COC = 1
let g:can_use_coc = !empty($VIM_USE_COC)

if g:can_use_coc
  so ~/.config/nvim/vim-plug.vim
  so ~/.config/nvim/plugins/coc.vim
endif

so ~/.config/nvim/settings.vim
so ~/.config/nvim/key-maps.vim
" packer plugin manager installs plugins
" luafile ~/.config/nvim/lua/plugins/packer.lua

" THEME SELECTION
if !empty($EBNIS_VIM_THEME)
  so ~/.config/nvim/plugins/$EBNIS_VIM_THEME.vim
  if $EBNIS_VIM_THEME_BG == 'd'
    set background=dark
  else
    set background=light
  endif
else
  colorscheme gruvbox8
  set background=light
endif

lua <<EOF
--vim.lsp.set_log_level('info') -- debug/error/trace
-- see plugins/packer.lua for globals

--  if NO_USE_COC_LSP then
--      require("lsp")
--      require("plugins/emmet-vim")
--      require("plugins/nvim-autopairs")
      -- require("plugins/undotree")
      -- require("nvim-ts-autotag").setup()
--  end

  -- PLUGIN SETTINGS
  -- require("plugins/treesitter")
  -- require("plugins/which-key")
EOF
