#!/usr/bin/env bash
# Installs the authorized SSH public keys from config/ssh/authorized_keys.
# Must run before the ssh-hardening step so key-based access is already
# in place by the time password auth gets disabled. Idempotent - safe
# to re-run.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"

while IFS= read -r key; do
  [[ -z "$key" || "$key" == \#* ]] && continue
  grep -qxF "$key" "$HOME/.ssh/authorized_keys" || echo "$key" >> "$HOME/.ssh/authorized_keys"
done < config/ssh/authorized_keys
