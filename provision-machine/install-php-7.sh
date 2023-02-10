#!/usr/bin/env bash
# shellcheck disable=2034,2209,2135,2155

# [TAKEN FROM GITHUB ISSUE](https://github.com/phpbrew/phpbrew/issues/1263#issuecomment-1140375871)

local_apps_install_path="$HOME/apps"
open_ssl_bin_path="${local_apps_install_path}/openssl-1.1.1i/bin"

function _restore-asdf-git {
  (
    cd "${HOME}/.asdf/plugins/php/bin" || true
    git restore .
  )
}

function _install-open-ssl {
  mkdir -p "$local_apps_install_path"

  (
    cd "$local_apps_install_path" || true

    wget https://www.openssl.org/source/openssl-1.1.1i.tar.gz
    tar xzf openssl-1.1.1i.tar.gz

    (
      cd openssl-1.1.1i || true

      ./Configure --prefix="${open_ssl_bin_path}" -fPIC -shared linux-x86_64
      make -j 8
      make install
    )

    rm -rf openssl-1.1.1i.tar.gz
  )
}

function install-asdf-php-7 {
  if ! [[ -d "${open_ssl_bin_path}" ]]; then
    _install-open-ssl
  fi

  _restore-asdf-git

  sudo apt-get install -y \
    plocate

  export __ebnis_asdf_php_version=7.3.33
  export __ebnis_asdf_php_version=7.4.30

  # text_to_replace='install_composer "$ASDF_INSTALL_PATH"'
  read -r -d '' text_to_replace <<'eof'
$bin_path/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
eof

  replacement_text='curl https://getcomposer.org/installer --output composer-setup.php'

  # git_branch_name="$(git rev-parse --abbrev-ref HEAD)"
  asdf_php_install_filename="${HOME}/.asdf/plugins/php/bin/install"

  dot_composer_path="${HOME}/.composer"

  if [[ "${__ebnis_asdf_php_version}" = 7.* ]]; then
    if [[ -e "${dot_composer_path}" ]]; then
      mv "${dot_composer_path}" "${dot_composer_path}.old"
    fi

    sed -i -e \
      "s|${text_to_replace}|${replacement_text}|" \
      "${asdf_php_install_filename}"
  fi

  export PKG_CONFIG_PATH="${open_ssl_bin_path}/lib/pkgconfig"
  asdf install php "${__ebnis_asdf_php_version}"

  current_php_version="$(
    asdf current php |
      awk '{print $2}'
  )"

  asdf reshim

  if [[ -f ./.tool-versions ]]; then
    mv ./.tool-versions ./.tool-versions.old
  fi

  asdf local php "${__ebnis_asdf_php_version}"
  # pecl install xdebug

  ###### Undo changes

  if [[ -f ./.tool-versions.old ]]; then
    mv ./.tool-versions.old ./.tool-versions
  else
    rm -rf ./.tool-versions
  fi

  _restore-asdf-git

  unset __ebnis_asdf_php_version

  if [[ -e "${dot_composer_path}.old" ]]; then
    mv "${dot_composer_path}.old" "${dot_composer_path}"
  fi
}

install-asdf-php-7
