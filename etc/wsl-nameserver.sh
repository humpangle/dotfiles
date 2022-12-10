#!/bin/bash

filename="/etc/resolv.conf"

if [[ -n "$1" ]]; then
  sudo sed -i -e 's|generateResolvConf = false|generateResolvConf = true|' /etc/wsl.conf

  exit 0
fi

sudo unlink "$filename" 2>/dev/null || true
sudo rm -rf "$filename" 2>/dev/null || true
sudo sed -i -e 's|generateResolvConf = true|generateResolvConf = false|' /etc/wsl.conf
echo 'nameserver 1.1.1.1' | sudo tee "${filename}" 1>/dev/null
