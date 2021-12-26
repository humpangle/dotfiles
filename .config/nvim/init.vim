" https://github.com/dag/vim-fish#teach-a-vim-to-fish
set shell=/bin/bash
let $VIM_USE_COC = 1
let g:can_use_coc = !empty($VIM_USE_COC)

so ~/.config/nvim/vim-plug.vim

so ~/.config/nvim/settings.vim
so ~/.config/nvim/plugins/lightline.vim
so ~/.config/nvim/plugins/functions.vim
so ~/.config/nvim/key-maps.vim
so ~/.config/nvim/plugins/fugitive.vim
so ~/.config/nvim/plugins/fzf.vim
so ~/.config/nvim/plugins/neoformat.vim
so ~/.config/nvim/plugins/floaterm.vim
so ~/.config/nvim/plugins/vcoolor.vim
so ~/.config/nvim/plugins/vimspector.vim
so ~/.config/nvim/plugins/coc.vim
so ~/.config/nvim/plugins/markdown-preview.vim
so ~/.config/nvim/plugins/dadbod-ui.vim
so ~/.config/nvim/plugins/easymotion.vim
so ~/.config/nvim/plugins/maximizer.vim
so ~/.config/nvim/plugins/vim-phpfmt.vim
so ~/.config/nvim/plugins/vim-rest-console.vim
so ~/.config/nvim/plugins/vim-choosewin.vim
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
  colorscheme one
  set background=dark
endif

lua <<EOF
-- require("nvim-cmp")
-- require("lsp1")
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
