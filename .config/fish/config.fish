# suppress fish welcome message
set -U fish_greeting
set -U fish_prompt_pwd_dir_length 0
fish_add_path -g "$HOME/bin"
fish_add_path -g "$HOME/.local/bin"

set -x EDITOR nvim

# skip the java dependency during installation
set -x KERL_CONFIGURE_OPTIONS "--disable-debug --without-javac"
# Do not build erlang docs when installing with
# asdf cos it's slow and unstable
set -x KERL_BUILD_DOCS yes
set -x KERL_INSTALL_MANPAGES
set -x KERL_INSTALL_HTMLDOCS
# Install Ruby Gems to ~/gems
set -x GEM_HOME "$HOME/gems"
fish_add_path -g "$HOME/gems/bin"
set PHP_WITHOUT_PEAR yes
# install with: `sudo apt install ssh-askpass-gnome ssh-askpass -y`
set SUDO_ASKPASS (which ssh-askpass)
# Do not use PHP PEAR when installing PHP with asdf

# get custom functions from github: razzius/fish-functions

if status --is-interactive
    # docker
    # docker remove all containers
    abbr -a -g drac 'docker rm (docker ps -a -q) '
    # docker remove all containers force
    abbr -a -g dracf 'docker rm (docker ps -a -q) --force'
    abbr -a -g drmi 'docker rmi '
    abbr -a -g drim 'docker rmi '
    abbr -a -g dim 'docker images '
    abbr -a -g dps 'docker ps '
    abbr -a -g dpsa 'docker ps -a '
    abbr -a -g dc 'docker-compose '
    abbr -a -g dce 'docker-compose exec '
    abbr -a -g dcu 'docker-compose up '
    abbr -a -g dcrs 'docker-compose restart '
    abbr -a -g dcd 'docker-compose down '
    abbr -a -g dvra 'docker volume rm (docker volume ls -q)'
    abbr -a -g dvls 'docker volume ls'
    abbr -a -g dvlsq 'docker volume ls -q'
    abbr -a -g ds 'sudo service docker start'
    abbr -a -g ug 'sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
    abbr -a -g gc 'google-chrome -incognito &'

    # yarn
    abbr -a -g yw "yarn workspace "
    abbr -a -g yW "yarn -W "
    abbr -a -g ys "yarn start "
    abbr -a -g ylsp "yarn list --pattern "
    abbr -a -g ywhy "yarn why "

    # vim
    abbr -a -g vi /usr/bin/vim
    abbr -a -g vimdiff "nvim -d"
    abbr -a -g vim nvim
    abbr -a -g v nvim
    abbr -a -g svim 'sudo nvim -u ~/dotfiles/.config/init-min.vim '
    # abbr -a -g nvim "SHELL=/bin/bash nvim"
    # abbr -a -g vim "SHELL=/bin/bash nvim"
    abbr -a -g nvl "VIM_USE_COC=1 nvim "
    #     # set vim theme and background per shell session
    #     # unset
    abbr -a -g vt. 'set EBNIS_VIM_THEME '
    #     # vim-one
    abbr -a -g vt1d 'set -x EBNIS_VIM_THEME vim-one; set -x EBNIS_VIM_THEME_BG d'
    abbr -a -g vt1l 'set -x EBNIS_VIM_THEME vim-one; set -x EBNIS_VIM_THEME_BG l'
    #     # vim-gruvbox8
    abbr -a -g vt8d 'set -x EBNIS_VIM_THEME vim-gruvbox8; set -x EBNIS_VIM_THEME_BG d'
    abbr -a -g vt8l 'set -x EBNIS_VIM_THEME vim-gruvbox8; set -x EBNIS_VIM_THEME_BG l'
    #     # vim-solarized8
    abbr -a -g vtsd 'set -x EBNIS_VIM_THEME vim-solarized8; set -x EBNIS_VIM_THEME_BG d'
    abbr -a -g vtsl 'set -x EBNIS_VIM_THEME vim-solarized8; set -x EBNIS_VIM_THEME_BG l'
    #     # Set vim fuzzy finder
    abbr -a -g vff. 'set -x EBNIS_VIM_FUZZY_FINDER '
    abbr -a -g vfff 'set -x EBNIS_VIM_FUZZY_FINDER fzf'
    abbr -a -g vffc 'set -x EBNIS_VIM_FUZZY_FINDER vim-clap'
    abbr -a -g vscode-vim "MYVIMRC_DIR=$HOME/.config/nvim-vscode/ XDG_DATA_HOME=~/.local/share/nvim-vscode NVIM_RPLUGIN_MANIFEST=~/.local/share/nvim-vscode/rplugin.vim MYVIMRC=$HOME/.config/nvim-vscode/init-vscode.vim nvim -u $HOME/.config/nvim-vscode/init-vscode.vim nvim"

    #     # tmux
    abbr -a -g ta "tmux a -t"
    abbr -a -g tls "tmux ls"
    abbr -a -g tn "tmux new -s "
    abbr -a -g tks "tmux kill-session -t"
    abbr -a -g tkss "tmux kill-server"
    abbr -a -g ts "$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh"
    abbr -a -g trs "$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"

    #     # rsync
    abbr -a -g rsynca "rsync -avzP --delete "
    abbr -a -g rsyncd "rsync -avzP --delete --dry-run "

    #     # GIT
    abbr -a -g gss 'git status '
    #     # abbr -a -g  gst 'git stash '
    #     # abbr -a -g  gsp 'git stash pop'
    abbr -a -g gsl 'git stash list'
    #     # there is a debian package gsc   gambc
    abbr -a -g gsc 'git stash clear'
    abbr -a -g gcma 'git commit --amend '
    abbr -a -g gcma 'git commit -a '
    abbr -a -g gcme 'git commit --amend --no-edit '
    abbr -a -g gcamupm 'git commit -am "updated" && git push github master'
    abbr -a -g ga. 'git add . '
    abbr -a -g gp 'git push '
    abbr -a -g gpgm 'git push github master'
    #     # The following command has serious caveats: see wiki/git.md
    #     # deliberately put an error: stash1 instead of stash so that user is forced
    #     # to edit command and put stash message
    abbr -a -g gsstaged 'git stash1 push -m "" -- (git diff --staged --name-only)'
    abbr -a -g gcm 'git commit '
    abbr -a -g grb 'git rebase -i'
    #     # there is a debian package gpodder=gpo
    abbr -a -g gpo 'git push origin'
    abbr -a -g gpf 'git push --force origin'
    abbr -a -g glone 'git log --oneline'
    #     # there is a debian package gsa   gwenhywfar-tools
    function gsa
        git stash apply "stash@{$argv}"
    end

    function gsd
        git stash drop "stash@{$argv}"
    end

    abbr -a -g ll 'ls -alh '
    abbr -a -g .. 'cd ..'
    abbr -a -g ... 'cd ../..'
    abbr -a -g .3 'cd ../../..'
    abbr -a -g .4 'cd ../../../..'
    abbr -a -g cdo "mkdir -p $HOME/projects/0 && cd $HOME/projects/0"
    abbr -a -g cdp "mkdir -p $HOME/projects && cd $HOME/projects"
    abbr -a -g md "mkdir -p"
    abbr -a -g ff fzf
    # abbr -a -g c "clear && printf '\e[3J'"
    # abbr -a -g C clear
    abbr -a -g py "python "
    abbr -a -g pw "prettier --write "
    abbr -a -g eshell "source ~/.config/fish/config.fish"
    abbr -a -g exshell "set -x SHELL /usr/bin/fish"
    abbr -a -g hb "sudo systemctl hibernate"
    abbr -a -g luamake "$HOME/.local/bin/lua/sumneko/lua-language-server/3rd/luamake/luamake"

    if type sort-package-json &>/dev/null
        abbr -a -g spj 'sort-package-json '
    end

    function  setenvs --no-scope-shadowing
      for line in (cat $argv[1])
        if test $line != ''; and not string match -rq '\s*^#' $line
          set t (string split --max 2 '=' $line)
          echo "set -x $t[1] $t[2]"
          set -x $t[1] $t[2]
        end
      end
    end
end

set -x DOCKER_BUILDKIT 1

if test -d "$HOME/.pyenv"
    set PYENV_ROOT "$HOME/.pyenv"
    fish_add_path "$PYENV_ROOT/bin"

    if type pyenv 1>/dev/null 2>&1
        # eval (bass pyenv init -)

        if test -d "$PYENV_ROOT/plugins/pyenv-virtualenv"
            # eval (pyenv virtualenv-init -)
        end
    end
end

if test -d "$HOME/.fzf"
    # ripgrep
    set -x RG_IGNORES "!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}"
    set RG_OPTIONS "--hidden --follow --glob '$RG_IGNORES'"

    set FZF_PREVIEW_APP "--preview='string match -rq binary (file --mime {}); and echo {} is a binary file; or bat --style=numbers --color=always {}'"
    set -x FZF_DEFAULT_OPTS "--layout=reverse --border $FZF_PREVIEW_APP"
    # Use git-ls-files inside git repo, otherwise rg
    set -x FZF_DEFAULT_COMMAND "rg --files $RG_OPTIONS"
    set -x FZF_CTRL_T_COMMAND = $FZF_DEFAULT_COMMAND
    set -x FZF_COMPLETION_TRIGGER ',,'

    function _fzf_compgen_dir
        rg --files $RG_OPTIONS
    end

    function _fzf_compgen_path
        rg --files --hidden --follow --glob $RG_IGNORES
    end
end
if test -d "$HOME/.asdf"
    source "$HOME/.asdf/asdf.fish"

    set asdf_completion "$HOME/dotfiles/.config/fish/completions/asdf.fish"

    if test -f $asdf_completion
        #
    else
        cp "$HOME/.asdf/completions/asdf.fish" $asdf_completion
    end

    if test asdf 1>/dev/null 2>&1
        # Preprend asdf bin paths for programming executables
        # required to use VSCODE for some programming languages

        # set no_version_set "No version set"

        #     add_asdf_plugins_to_path() {
        #       plugin=$1
        #       activated="$( asdf current $plugin )"

        #       case "$no_version_set" in
        #         *$activated*)
        #           # echo "not activated"
        #         ;;

        #         *)
        #           version="$(echo $activated | cut -d' ' -f1)"
        #           bin_path="$HOME/.asdf/installs/$plugin/$version/bin"
        #           export PATH="$bin_path:$PATH"
        #         ;;
        #       esac
        #     }

        # add_asdf_plugins_to_path elixir
        # add_asdf_plugins_to_path erlang
    end
end

if test -n "$WSL_DISTRO_NAME"
    umask 022

    # following needed so that cypress browser testing can work in WSL2
    set -x DISPLAY (/sbin/ip route | awk '/default/ { print $3 }'):0
    # without the next line, linux executables randomly fail in TMUX in WSL
    # export PATH="$PATH:/c/WINDOWS/system32"

    abbr -a -g e. '/c/WINDOWS/explorer.exe .'
    abbr -a -g wslexe '/c/WINDOWS/system32/wsl.exe '
    abbr -a -g ubuntu20 '/c/WINDOWS/system32/wsl.exe --distribution Ubuntu-20.04'
    abbr -a -g ubuntu18 '/c/WINDOWS/system32/wsl.exe --distribution Ubuntu'

    # This is specific to WSL 2. If the WSL 2 VM goes rogue and decides not to free
    # up memory, this command will free your memory after about 20-30 seconds.
    #   Details: https://github.com/microsoft/WSL/issues/4166#issuecomment-628493643
    abbr drop-cache "sudo sh -c \"echo 3 > '/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
end

# The minimal, blazing-fast, and infinitely customizable prompt for any shell!
# https://github.com/starship/starship
if type starship >/dev/null
    starship init fish | source
end

# settings that vary between machines
if test -f "$HOME/.config/fish/varying.config.fish"
    source "$HOME/.config/fish/varying.config.fish"
end
