so ~/.config/nvim/settings.vim
so ~/.config/nvim/plugins/functions.vim
so ~/.config/nvim/key-maps.vim

luafile ~/.config/nvim/lua/plugins/packer.lua

so ~/.config/nvim/plugins/lightline.vim
so ~/.config/nvim/plugins/fugitive.vim
so ~/.config/nvim/plugins/fzf.vim
so ~/.config/nvim/plugins/neoformat.vim
so ~/.config/nvim/plugins/floaterm.vim
so ~/.config/nvim/plugins/vcoolor.vim
so ~/.config/nvim/plugins/vimspector.vim
so ~/.config/nvim/plugins/markdown-preview.vim
so ~/.config/nvim/plugins/dadbod-ui.vim
so ~/.config/nvim/plugins/easymotion.vim
so ~/.config/nvim/plugins/maximizer.vim
so ~/.config/nvim/plugins/vim-phpfmt.vim
so ~/.config/nvim/plugins/vim-rest-console.vim

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
--vim.lsp.set_log_level('info') -- debug/error/trace
-- see plugins/packer.lua for globals
EOF
