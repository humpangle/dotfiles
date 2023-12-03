if has('win32')
  language en_US
  set fileformat=unix
  let s:plugins_path = '~\AppData\Local\nvim\autoload'
else
  " unset default paths of regular nvim in unix
  set runtimepath-=~/.config/nvim
  set runtimepath-=~/.config/nvim/after
  set runtimepath-=~/.local/share/nvim/site
  set runtimepath-=~/.local/share/nvim/site/after

  " set custom paths for use in vscode nvim
  set runtimepath+=~/.config/nvim-win/after
  set runtimepath^=~/.config/nvim-win
  set runtimepath+=~/.local/share/nvim-win/site/after
  set runtimepath^=~/.local/share/nvim-win/site

  let &packpath = &runtimepath

  let $MYVIMRC = "$HOME/.config/nvim-win/init.vim"
endif
