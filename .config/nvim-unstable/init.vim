" see: installing-neovim-unstable-alongside-stable.html in wiki
" unset default paths
set runtimepath-=~/.config/nvim
set runtimepath-=~/.config/nvim/after
set runtimepath-=~/.local/share/nvim/site
set runtimepath-=~/.local/share/nvim/site/after

" set custom paths
set runtimepath+=~/.config/nvim-unstable/after
set runtimepath^=~/.config/nvim-unstable
set runtimepath+=~/.local/nvim-unstable/nvim/site/after
set runtimepath^=~/.local/nvim-unstable/nvim/site

let &packpath = &runtimepath
luafile ~/.config/nvim-unstable/init.lua
