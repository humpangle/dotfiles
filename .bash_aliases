#!/usr/bin/env bash

stable_vimrc_path="$HOME/.config/nvim/init.vim"
nvim="nvim -u $stable_vimrc_path"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias md='mkdir -p'
alias yw='yarn workspace '
alias yW='yarn -W '
alias ys='yarn start '
alias ylsp='yarn list --pattern '
alias ywhy='yarn why '
alias ff='fzf'
alias nvim="$nvim"
alias vim="$nvim"
alias v="$nvim"
alias vi='/usr/bin/vim'
alias vimdiff="$nvim -d"
alias c="clear && printf '\e[3J'"
alias C=clear
alias ta='tmux a -t'
alias tls='tmux ls'
alias tn='tmux new -s '
alias tks='tmux kill-session -t'
alias tkss='tmux kill-server'
alias py='python '
alias pw='prettier --write '
alias ts='$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias trs='$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh'
alias eshell='exec $SHELL'
alias gss='git status '
alias gst='git stash '
alias gsp='git stash pop'
alias gsl='git stash list'
alias gcma='git commit --amend '
alias gcm-a='git commit -a '
alias gcmane='git commit --amend --no-edit '
alias gcamupm='git commit -am "updated" && git push github master'
alias ga.='git add . '
alias gp='git push '
alias gpgm='git push github master'
alias rmvimswap='rm ~/.local/share/nvim/swap/*'
alias hb='sudo systemctl hibernate'
alias rsynca='rsync -avzP --delete '
alias rsyncd='rsync -avzP --delete --dry-run '

# VIM/NEOVIM
unstable_vimrc_path="$HOME/.config/nvim-unstable/init.vim"
unstable_vim_local_path="$HOME/.local/nvim-unstable"

alias nvl="XDG_DATA_HOME=$unstable_vim_local_path MYVIMRC=$unstable_vimrc_path NVIM_RPLUGIN_MANIFEST=$unstable_vim_local_path/rplugin.vim $HOME/nvim.appimage -u $unstable_vimrc_path "

alias nv="$HOME/nvim.appimage -u $stable_vimrc_path "

if [ -x "$(command -v sort-package-json)" ]; then
  alias spj='sort-package-json '
fi
