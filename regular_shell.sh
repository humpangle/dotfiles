#!/usr/bin/env bash

# Add to $PATH only if `it` does not exist in the $PATH
# fish shell has the `fish_add_path` function which does something similar
# CREDIT: https://unix.stackexchange.com/a/217629
# USAGE:
#     pathmunge /sbin/             ## Add to the start; default
#     pathmunge /usr/sbin/ after   ## Add to the end
pathmunge() {
	# first check if folder exists on filesystem
	if [ -d "$1" ]; then
		if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)"; then
			if [ "$2" = "after" ]; then
				PATH="$PATH:$1"
			else
				PATH="$1:$PATH"
			fi
		fi
	fi
}

export EDITOR="nvim"

# skip the java dependency during installation
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
# Do not build erlang docs when installing with
# asdf cos it's slow and unstable
export KERL_BUILD_DOCS=yes
export KERL_INSTALL_MANPAGES=
export KERL_INSTALL_HTMLDOCS=
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
pathmunge "$GEM_HOME/bin"
# Do not use PHP PEAR when installing PHP with asdf
export PHP_WITHOUT_PEAR='yes'
# install with: `sudo apt install ssh-askpass-gnome ssh-askpass -y`
# shellcheck disable=2155
export SUDO_ASKPASS=$(command -v ssh-askpass)

# docker
# docker remove all containers
alias drac='docker rm $(docker ps -a -q) '
# docker remove all containers force
alias dracf='docker rm $(docker ps -a -q) --force'
alias drmi='docker rmi '
alias drim='docker rmi '
alias dim='docker images '
alias dps='docker ps '
alias dpsa='docker ps -a '
alias dc='docker-compose '
alias dce='docker-compose exec '
alias de='docker exec -it '
alias dcu='clear && docker-compose up '
alias dck='docker-compose kill '
alias dcd='docker-compose down '
alias dcv='docker-compose down -v'
alias dcrs='docker-compose restart '
alias dvra='docker volume rm $(docker volume ls -q)'
alias dvls='docker volume ls'
alias dvlsq='docker volume ls -q'
alias ds='sudo service docker start'
alias ngrokd='ngrok http $DOCKER_PUBLISH_WEB_PORT'

alias ug='clear && sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

ggc() {
	google-chrome -incognito &
	disown
}

# yarn
alias yw='yarn workspace '
alias yW='yarn -W '
alias ys='yarn start '
alias yn='yarn nps '
alias ylsp='yarn list --pattern '
alias ywhy='yarn why '
alias ycw='clear && DISABLE_LARAVEL_MIX_NOTIFICATION=1 yarn watch'

# vim
alias vi='/usr/bin/vim'
alias vimdiff="nvim -d"
alias vim="nvim"
alias v="nvim"
alias svim='sudo nvim -u ~/dotfiles/.config/init-min.vim '
alias nvl="VIM_USE_COC=1 nvim "
# set vim theme and background per shell session
# unset
alias vt.='export EBNIS_VIM_THEME='
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

# tmux
alias ta='tmux a -t'
alias tls='tmux ls'
alias tp='rm -rf $HOME/.tmux/resurrect/pane_contents.tar.gz'
alias tn='rm -rf $HOME/.tmux/resurrect/pane_contents.tar.gz && tmux new -s '
alias tndot='cd ~/dotfiles && tn dot'
alias tks='tmux kill-session -t'
alias tkss='tmux kill-server'
alias ts='$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias trs='$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh'

splitp() {
	if [[ "$1" == '-h' ]]; then
		echo "Usage:"
		echo "splitp absolute_path window_name"
		return
	fi

	if [[ -n "$1" ]]; then
		local dir="$1"
	else
		local dir="$PWD"
	fi

	local window_name="$2"

	cd "$dir"

	tmux rename-window "$window_name" \
		\; splitw -c "$dir" -h -p 46 \
		\; splitw -b -p 40 \
		\; splitw -t 3 -b -p 45 \
		\; splitw -t 4 -b -p 55 \
		\; select-pane -t 2 \
		\; send-keys 'nvim ,' C-m \
		\; new-window -c "$dir" \
		\; splitw -c "$dir" -h -p 45 \
		\; splitw -t 1 -p 60 \
		\; splitw -p 45 \
		\; splitw -t 4 -p 87 \
		\; splitw -p 85 \
		\; splitw -p 70 \
		\; splitw \
		\; select-pane -t 1 \
		\; send-keys 'cd storage/logs && clear' C-m \
		\; select-pane -t 2 \
		\; send-keys 'nvim ,' C-m \
		\; select-pane -t 3 \
		\; send-keys 'cd storage/app/public && clear' C-m \
		\; select-pane -t 4 \
		\; rename-window "${window_name}-L" \
		\; last-window \
		\; select-pane -t 5 \
		\; send-keys 'yarn && clear' C-m \
		\; select-pane -t 1 \
		\; send-keys 'clear' C-m
}

# rsync
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
alias gpf='git push --force-with-lease origin'
alias glone='git log --oneline'
alias gconflict='git diff --name-only --diff-filter=U'
alias gwt='git worktree '
# debian package gsa = gwenhywfar-tools
gsa() {
	git stash apply "stash@{$1}"
}

gsd() {
	git stash drop "stash@{$1}"
}

alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias cdo='mkdir -p $HOME/projects/0 && cd $HOME/projects/0'
alias cdp='mkdir -p $HOME/projects && cd $HOME/projects'
alias cdd='cd $HOME/dotfiles'
alias md='mkdir -p'
alias C="clear && printf '\e[3J'"
alias py='python '
alias pw='prettier --write '
alias eshell='exec $SHELL'
alias exshell='export SHELL=/usr/bin/bash'
alias rmvimswap='rm ~/.local/share/nvim/swap/*'
alias hb='sudo systemctl hibernate'
alias sd='sudo shutdown now'
# debian package `lrzsz`
alias rb='sudo reboot'
alias luamake=/home/kanmii/.local/bin/lua/sumneko/lua-language-server/3rd/luamake/luamake

alias scouser='sudo chown -R $USER:$USER '
alias scmstorage='sudo chmod -R 777 storage'

# https://unix.stackexchange.com/a/179852
# Make bash history unique

make_history_unique() {
	tac "$HISTFILE" | awk '!x[$0]++' >/tmp/tmpfile &&
		tac /tmp/tmpfile >"$HISTFILE" &&
		rm /tmp/tmpfile
}
alias hu='make_history_unique'
# also https://unix.stackexchange.com/a/613644

ltf() {
	local cmd="lt --subdomain $1 --port $2"

	if [[ "$3" == 'd' ]]; then
		$cmd &
	else
		$cmd
	fi
}

export DOCKER_BUILDKIT=1

if [ -x "$(command -v sort-package-json)" ]; then
	alias spj='sort-package-json '
fi

setenvs() {
	set -a
	. "$1"
	set +a
	# set -o allexport; source "$1"; set +o allexport
}
alias se='setenvs'

if [ -x "$(command -v php)" ]; then
	# debian pkg bsdgames
	alias sail='./vendor/bin/sail'
	alias sailartisan='./vendor/bin/sail artisan'

	alias artisan='php artisan'
fi

pathmunge "/usr/lib/dart/bin" "after"

# if [ -d "$HOME/.pyenv" ]; then
#   export PYENV_ROOT="$HOME/.pyenv"
#   pathmunge "$PYENV_ROOT"
#
#   if command -v pyenv 1>/dev/null 2>&1; then
#     eval "$(pyenv init -)"
#
#     if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
#       eval "$(pyenv virtualenv-init -)"
#     fi
#   fi
# fi

if [ -d "$HOME/.fzf" ]; then
	# ripgrep
	export RG_IGNORES="!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}"
	RG_OPTIONS="--hidden --follow --glob '$RG_IGNORES'"

	export FZF_DEFAULT_OPTS="--layout=reverse --border"
	# Use git-ls-files inside git repo, otherwise rg
	export FZF_DEFAULT_COMMAND="rg --files $RG_OPTIONS"
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
	export FZF_COMPLETION_TRIGGER=',,'

	_fzf_compgen_dir() {
		rg --files "$RG_OPTIONS"
	}

	_fzf_compgen_path() {
		rg --files --hidden --follow --glob $RG_IGNORES
	}

	FZF_PREVIEW_APP="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"

	alias ff="fzf $FZF_PREVIEW_APP"
	alias eff='env | fzf'
	alias aff='alias | fzf'
fi

if [ -d "$HOME/.asdf" ]; then
	. $HOME/.asdf/asdf.sh
	. $HOME/.asdf/completions/asdf.bash

	if command -v asdf 1>/dev/null 2>&1; then
		# Preprend asdf bin paths for programming executables
		# required to use VSCODE for some programming languages

		no_version_set="No version set"

		add_asdf_plugins_to_path() {
			plugin=$1
			activated="$(asdf current $plugin)"

			case "$no_version_set" in
			*$activated*)
				# echo "not activated"
				;;

			*)
				version="$(echo $activated | cut -d' ' -f1)"
				bin_path="$HOME/.asdf/installs/$plugin/$version/bin"
				export PATH="$bin_path:$PATH"
				;;
			esac
		}

		alias adf='asdf '

		# add_asdf_plugins_to_path elixir
		# add_asdf_plugins_to_path erlang
	fi
fi

if [ -n "$WSL_DISTRO_NAME" ]; then
	# following needed so that cypress browser testing can work in WSL2
	export DISPLAY="$WSL_HOST_IP:0"
	# without the next line, linux executables randomly fail in TMUX in WSL
	# export PATH="$PATH:/c/WINDOWS/system32"

	alias e.='/c/WINDOWS/explorer.exe .'
	alias wslexe='/c/WINDOWS/system32/wsl.exe '
	alias wsls="wslexe --shutdown"
	alias ubuntu20='/c/WINDOWS/system32/wsl.exe --distribution Ubuntu-20.04'
	alias ubuntu18='/c/WINDOWS/system32/wsl.exe --distribution Ubuntu'

	# This is specific to WSL 2. If the WSL 2 VM goes rogue and decides not to free
	# up memory, this command will free your memory after about 20-30 seconds.
	#   Details: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
	alias dpc="clear && sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""

	if [ -x "$(command -v docker)" ]; then
		# export DOCKER_HOST="unix:///mnt/wsl/shared-docker/docker.sock"

		# https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/

		# Start Docker daemon automatically when logging in if not running.
		RUNNING=$(ps aux | grep dockerd | grep -v grep)

		if [ -z "$RUNNING" ]; then
			sudo dockerd >/dev/null 2>&1 &
			disown
		fi
	fi

fi

# The minimal, blazing-fast, and infinitely customizable prompt for any shell!
# https://github.com/starship/starship
# eval "$(starship init bash)" ## will use only in fish shell for now

touchm() {
	local data
	local sep
	local dir_path
	data="$1"
	sep="/"

	dir_path=${data%$sep*}

	if [ "$dir_path" == "$data" ]; then
		touch "$dir_path"
	else
		mkdir -p "$dir_path"
		touch "$data"
	fi
}

# Set the title string at the top of your current terminal window or terminal window tab
# https://github.com/mgedmin/scripts/blob/master/title
# https://discourse.gnome.org/t/rename-terminal-tab/3200/5
set-title() {
	# usage: set-title string
	# Works for xterm clones
	printf "\033]0;%s\a" "$*"
}

MY_JAVA_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
if [ -d "$MY_JAVA_PATH" ]; then
	export JAVA_HOME="$MY_JAVA_PATH"
	pathmunge "$JAVA_HOME/bin"
fi

MY_ANDROID_STUDIO_PATH="$HOME/projects/android-studio"
if [ -d "$MY_ANDROID_STUDIO_PATH" ]; then
	export ANDROID_HOME="$MY_ANDROID_STUDIO_PATH"
	pathmunge "$ANDROID_HOME"
	pathmunge "$ANDROID_HOME/bin"
fi

MY_ANDROID_SDK_PATH="$HOME/projects/android-sdk"
if [ -d "$MY_ANDROID_SDK_PATH" ]; then
	pathmunge "$MY_ANDROID_SDK_PATH/tools"
	pathmunge "$MY_ANDROID_SDK_PATH/tools/bin"
	pathmunge "$MY_ANDROID_SDK_PATH/platform-tools"
fi

MY_FLUTTER_PATH="$HOME/projects/flutter"
if [ -d "$MY_FLUTTER_PATH" ]; then
	pathmunge "$MY_FLUTTER_PATH/bin"
	pathmunge "$MY_FLUTTER_PATH/.pub-cache/bin"
fi

# Automatically start dbus
# sudo /etc/init.d/dbus start &>/dev/null
