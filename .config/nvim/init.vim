if has('win32')
  language en_US
  source $VIMRUNTIME/mswin.vim

  source ~\AppData\Local\nvim\settings\vim-plug.vim

  source ~\AppData\Local\nvim\settings\general\settings.vim

  source ~\AppData\Local\nvim\settings\keys\mappings.vim

  source ~\AppData\Local\nvim\settings\themes\vim-gruvbox8.vim

  source ~\AppData\Local\nvim\settings\plugins\coc.vim
  " source ~\AppData\Local\nvim\settings\plugins\vim-floaterm.vim
  source ~\AppData\Local\nvim\settings\plugins\fzf.vim
  source ~\AppData\Local\nvim\settings\plugins\better-white-space.vim
  " source ~\AppData\Local\nvim\settings\plugins\gutentags.vim
  source ~\AppData\Local\nvim\settings\plugins\lightline.vim
  " source ~\AppData\Local\nvim\settings\plugins\vim-rest-console.vim
  " source ~\AppData\Local\nvim\settings\plugins\ale.vim
  " source ~\AppData\Local\nvim\settings\plugins\vim-grepper.vim
  source ~\AppData\Local\nvim\settings\plugins\tabular.vim
  source ~\AppData\Local\nvim\settings\plugins\vim-easy-motion.vim
else
  source ~/.config/nvim/settings/vim-plug.vim

  source ~/.config/nvim/settings/general/settings.vim

  source ~/.config/nvim/settings/keys/mappings.vim

  " THEME SELECTION
  if !empty($EBNIS_VIM_THEME)
    source ~/.config/nvim/settings/themes/$EBNIS_VIM_THEME.vim
    if $EBNIS_VIM_THEME_BG == 'd'
      set background=dark
    else
      set background=light
    endif
  else
    source ~/.config/nvim/settings/themes/vim-gruvbox8.vim
    set background=dark
  endif

  source ~/.config/nvim/settings/plugins/fzf-checkout.vim

  source ~/.config/nvim/settings/plugins/coc.vim
  source ~/.config/nvim/settings/plugins/vim-floaterm.vim
  source ~/.config/nvim/settings/plugins/fzf.vim
  source ~/.config/nvim/settings/plugins/better-white-space.vim
  source ~/.config/nvim/settings/plugins/gutentags.vim
  source ~/.config/nvim/settings/plugins/lightline.vim
  source ~/.config/nvim/settings/plugins/vim-rest-console.vim
  source ~/.config/nvim/settings/plugins/ale.vim
  source ~/.config/nvim/settings/plugins/vim-grepper.vim
  source ~/.config/nvim/settings/plugins/vim-fugitive.vim
  source ~/.config/nvim/settings/plugins/tabular.vim
  source ~/.config/nvim/settings/plugins/vim-easy-motion.vim
  if has('nvim-0.5')
    source ~/.config/nvim/settings/plugins/nvim-treesitter.vim
  endif
  source ~/.config/nvim/settings/plugins/vim-prosession.vim
endif
