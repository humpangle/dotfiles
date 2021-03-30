#!/usr/bin/env bash

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
alias vim="nvim"
alias v="nvim"
alias vi='/usr/bin/vim'
alias vimdiff="nvim -d"
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
alias rmvimswap='rm ~/.local/share/nvim/swap/*'
alias hb='sudo systemctl hibernate'
alias rsynca='rsync -avzP --delete '
alias rsyncd='rsync -avzP --delete --dry-run '

# GIT
alias gss='git status '
# alias gst='git stash '
# alias gsp='git stash pop'
alias gsl='git stash list'
# there is a debian package gsc = gambc
alias gsc='git stash clear'
alias gcma='git commit --amend '
alias gcma='git commit -a '
alias gcme='git commit --amend --no-edit '
alias gcamupm='git commit -am "updated" && git push github master'
alias ga.='git add . '
alias gp='git push '
alias gpgm='git push github master'
# The following command has serious caveats: see wiki/git.md
# deliberately put an error: stash1 instead of stash so that user is forced
# to edit command and put stash message
alias gsstaged='git stash1 push -m "" -- $(git diff --staged --name-only)'
alias gcm='git commit '
alias grb='git rebase -i'
# debian package gpodder=gpo
alias gpo='git push origin'
alias gpf='git push --force origin'
alias glone='git log --oneline'

# there is a debian package gsa = gwenhywfar-tools
function gsa() {
 git stash apply "stash@{$1}"
}

function gsd() {
 git stash drop "stash@{$1}"
}

# VIM/NEOVIM
unstable_vimrc_path="$HOME/.config/nvim-unstable/init.vim"
unstable_vim_local_path="$HOME/.local/nvim-unstable"

alias nvl="XDG_DATA_HOME=$unstable_vim_local_path MYVIMRC=$unstable_vimrc_path NVIM_RPLUGIN_MANIFEST=$unstable_vim_local_path/rplugin.vim nv -u $unstable_vimrc_path "

if [ -x "$(command -v sort-package-json)" ]; then
  alias spj='sort-package-json '
fi

# set vim theme and background per shell session
# vim-one
alias vt1d='export EBNIS_VIM_THEME=vim-one EBNIS_VIM_THEME_BG=d'
alias vt1l='export EBNIS_VIM_THEME="vim-one" EBNIS_VIM_THEME_BG=l'
# vim-gruvbox8
alias vt8d='export EBNIS_VIM_THEME=vim-gruvbox8 EBNIS_VIM_THEME_BG=d'
alias vt8l='export EBNIS_VIM_THEME=vim-gruvbox8 EBNIS_VIM_THEME_BG=l'
# vim-solarized8
alias vtsd='export EBNIS_VIM_THEME=vim-solarized8 EBNIS_VIM_THEME_BG=d'
alias vtsl='export EBNIS_VIM_THEME=vim-solarized8 EBNIS_VIM_THEME_BG=l'

# Set vim fuzzy finder
alias vff.='export EBNIS_VIM_FUZZY_FINDER='
alias vfff='export EBNIS_VIM_FUZZY_FINDER=fzf'
alias vffc='export EBNIS_VIM_FUZZY_FINDER=vim-clap'
