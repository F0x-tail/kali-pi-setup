#!/usr/bin/env bash
# Hardens sshd_config and opens the ufw SSH rule before enabling the
# firewall, so nothing here can lock out remote access. Idempotent -
# safe to re-run.
set -euo pipefail

SSHD_CONFIG=/etc/ssh/sshd_config

set_sshd_option() {
  local key="$1" value="$2"
  if sudo grep -qE "^#?${key}[[:space:]]" "$SSHD_CONFIG"; then
    sudo sed -i -E "s|^#?${key}[[:space:]].*|${key} ${value}|" "$SSHD_CONFIG"
  else
    echo "${key} ${value}" | sudo tee -a "$SSHD_CONFIG" >/dev/null
  fi
}

set_sshd_option PermitRootLogin no
set_sshd_option PermitEmptyPasswords no
set_sshd_option X11Forwarding no

if sudo test -s "$HOME/.ssh/authorized_keys"; then
  set_sshd_option PasswordAuthentication no
  echo "authorized_keys found - password authentication disabled."
else
  echo "WARNING: no $HOME/.ssh/authorized_keys found - leaving PasswordAuthentication untouched to avoid locking out SSH access. Add a key and re-run this step to disable it."
fi

sudo ufw allow ssh
sudo ufw --force enable

sudo systemctl reload ssh
