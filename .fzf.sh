#!/usr/bin/env bash

# ripgrep
RG_OPTIONS="--hidden --follow --glob '!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}'"

# fzf fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
FZF_PREVIEW_APP="--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300'"
export FZF_DEFAULT_OPTS="--layout=reverse --border --bind alt-j:down,alt-k:up $FZF_PREVIEW_APP"
# Use git-ls-files inside git repo, otherwise rg
export FZF_DEFAULT_COMMAND="rg --files $RG_OPTIONS"

_fzf_compgen_dir() {
  rg --files $RG_OPTIONS
}

_fzf_compgen_path() {
  rg --files --hidden --follow --glob '!{.git,node_modules,cover,coverage,.elixir_ls,deps,_build,.build,build}'
}
