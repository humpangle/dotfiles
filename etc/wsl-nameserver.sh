#!/bin/bash
echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf 1>/dev/null
