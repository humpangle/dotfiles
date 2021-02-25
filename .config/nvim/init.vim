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
  source $HOME/.config/nvim/settings/vim-plug.vim

  source $HOME/.config/nvim/settings/general/settings.vim

  source $HOME/.config/nvim/settings/keys/mappings.vim

  " source $HOME/.config/nvim/settings/themes/vim-one.vim
  source $HOME/.config/nvim/settings/themes/vim-gruvbox8.vim

  source $HOME/.config/nvim/settings/plugins/coc.vim
  source $HOME/.config/nvim/settings/plugins/vim-floaterm.vim
  source $HOME/.config/nvim/settings/plugins/fzf.vim
  source $HOME/.config/nvim/settings/plugins/better-white-space.vim
  source $HOME/.config/nvim/settings/plugins/gutentags.vim
  source $HOME/.config/nvim/settings/plugins/lightline.vim
  source $HOME/.config/nvim/settings/plugins/vim-rest-console.vim
  source $HOME/.config/nvim/settings/plugins/ale.vim
  source $HOME/.config/nvim/settings/plugins/vim-grepper.vim
  source $HOME/.config/nvim/settings/plugins/vim-fugitive.vim
  source $HOME/.config/nvim/settings/plugins/tabular.vim
  source $HOME/.config/nvim/settings/plugins/vim-easy-motion.vim
endif
