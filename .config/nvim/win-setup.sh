#!/bin/bash

set -e

if [ -z "$WIN_USER" ]; then
  echo "\$WIN_USER environment variable must be set to windows %USERNAME%"
  exit 1
fi


this_vim_path="$HOME/dotfiles/.config/nvim"
this_vim_settings_path="$this_vim_path/settings"

win_user_path="/c/Users/$WIN_USER"
win_vim_path="$win_user_path/AppData/Local/nvim"
win_settings_path="$win_vim_path/settings"

cp "$this_vim_path/coc-settings.json" "$win_vim_path"

mkdir -p "$win_user_path/.config/nvim/settings"
cp -r "$this_vim_settings_path/ultisnips" "$win_user_path/.config/nvim/settings/"

# dir /s/b | with gvim
mkdir -p "$win_user_path/.adhoc_paths"
cp "$this_vim_path/with.bat" "$win_user_path/.adhoc_paths"

vim_plug_path="$win_vim_path/autoload/plug.vim"

vim_plug_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

mkdir -p "$win_settings_path/general"
mkdir -p "$win_settings_path/keys"
mkdir -p "$win_settings_path/themes"

cp "$this_vim_path/init.vim" "$win_vim_path/init.vim"
cp "$this_vim_settings_path/vim-plug.vim" "$win_vim_path/settings/vim-plug.vim"

cp "$this_vim_settings_path/general/settings.vim" "$win_settings_path/general"
cp "$this_vim_settings_path/keys/mappings.vim" "$win_settings_path/keys"
cp "$this_vim_settings_path/themes/vim-gruvbox8.vim" "$win_settings_path/themes"
cp -r "$this_vim_settings_path/plugins" "$win_settings_path/"

if [ ! -e "$vim_plug_path" ]; then
  curl -fLo "$vim_plug_path" --create-dirs "$vim_plug_url"
fi
