#!/usr/bin/env bash
# Flip [ifupdown] managed=false -> true in NetworkManager.conf.
set -euo pipefail

CONF=/etc/NetworkManager/NetworkManager.conf
sudo sed -i '/^\[ifupdown\]/,/^\[/{s/^managed[[:space:]]*=[[:space:]]*false/managed=true/}' "$CONF"
grep -A1 '^\[ifupdown\]' "$CONF"
