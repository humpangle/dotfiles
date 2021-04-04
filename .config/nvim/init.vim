so ~/.config/nvim/settings/vim-plug.vim
so ~/.config/nvim/settings/general/settings.vim
so ~/.config/nvim/settings/keys/mappings.vim

" PLUGINS
so ~/.config/nvim/settings/plugins/vim-floaterm.vim
so ~/.config/nvim/settings/plugins/better-white-space.vim
so ~/.config/nvim/settings/plugins/lightline.vim
so ~/.config/nvim/settings/plugins/vim-rest-console.vim
so ~/.config/nvim/settings/plugins/ale.vim
so ~/.config/nvim/settings/plugins/tabular.vim
so ~/.config/nvim/settings/plugins/vim-easy-motion.vim
so ~/.config/nvim/settings/plugins/vim-prosession.vim
so ~/.config/nvim/settings/plugins/vim-fugitive.vim
so ~/.config/nvim/settings/plugins/coc.vim
so ~/.config/nvim/settings/plugins/vim-lua-format.vim
so ~/.config/nvim/settings/plugins/nvim-treesitter.vim

" FUZZY FINDERS
so ~/.config/nvim/settings/plugins/vim-grepper.vim
so ~/.config/nvim/settings/plugins/fzf.vim
so ~/.config/nvim/settings/plugins/fzf-checkout.vim

" THEME SELECTION
if !empty($EBNIS_VIM_THEME)
  so ~/.config/nvim/settings/themes/$EBNIS_VIM_THEME.vim
  if $EBNIS_VIM_THEME_BG == 'd'
    set background=dark
  else
    set background=light
  endif
else
  so ~/.config/nvim/settings/themes/vim-solarized8.vim
  set background=dark
endif
