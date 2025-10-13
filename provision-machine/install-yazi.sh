#!/usr/bin/env bash
# shellcheck disable=

__external--install-yazi() {
  : "Install superfile - a pretty fancy and modern terminal file manager"

  _echo "INSTALLING SUPERFILE"

  if _is_darwin; then
    brew update

    brew install \
      yazi \
      ffmpeg \
      sevenzip \
      poppler \
      fd \
      ripgrep \
      fzf \
      zoxide \
      resvg \
      imagemagick \
      font-symbols-only-nerd-font
  else
    sudo apt install -y ffmpeg 7zip poppler-utils fd-find ripgrep fzf zoxide imagemagick
  fi

  _echo "Superfile installed successfully"
}

__external--install-yazi "$@"
