#!/bin/bash

if [ -d "$HOME/.asdf" ]; then
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash

  if command -v asdf 1>/dev/null 2>&1; then
    # Preprend asdf bin paths for programming executables
    # required to use VSCODE for some programming languages

    no_version_set="No version set"

    add_asdf_plugins_to_path() {
      plugin=$1
      activated="$( asdf current $plugin )"

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

    # add_asdf_plugins_to_path elixir
    # add_asdf_plugins_to_path erlang
  fi
fi
