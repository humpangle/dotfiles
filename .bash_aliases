#!/usr/bin/env bash
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias md='mkdir -p'
alias yarnw="yarn workspace "
alias yarns="yarn start "
alias yarnlp="yarn list --pattern "
alias ff='fzf'
alias vim="nvim"
alias vi="/usr/bin/vim"
alias vimdiff="nvim -d"
alias c="clear && printf '\e[3J'"
alias C=clear
alias t="tmux"
alias ta="tmux a -t"
alias tls="tmux ls"
alias tn="tmux new -s"
alias tks="tmux kill-session -t"
alias tkss="tmux kill-server"
alias py='python '
alias pw='prettier --write '
alias ts='$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias tr='$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh'
alias eshell='exec $SHELL'
alias gst='git st '
alias gcma='git commit --amend '
alias gcm-a='git commit -a '
alias gcmane='git commit --amend --no-edit '
alias gcamupm='git commit -am "updated" && git push github master'
alias ga.='git add . '
alias gpg='git push github '
alias gp='git push '
alias gpgm='git push github master'
alias hb='sudo systemctl hibernate'
alias rmvimswap='rm ~/.local/share/nvim/swap/*'
if [ -n "$WSL_DISTRO_NAME" ]; then
  # This is specific to WSL 2. If the WSL 2 VM goes rogue and decides not to free
  # up memory, this command will free your memory after about 20-30 seconds.
  #   Details: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
  alias drop-cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
fi
