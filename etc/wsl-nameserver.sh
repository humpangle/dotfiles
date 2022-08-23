#!/bin/bash

filename="/etc/resolv.conf"

[[ -h "$filename" ]] && sudo unlink "$filename"

echo 'nameserver 1.1.1.1' | sudo tee "${filename}" 1>/dev/null
