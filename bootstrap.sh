#!/usr/bin/env bash
# Entry point: runs every steps/*.sh in order, from a fresh Kali install.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
source lib/common.sh

for step in steps/*.sh; do
  log "Running $step"
  bash "$step"
done

log "Done. Rebooting so NetworkManager, group membership, and the new services take effect."
sudo reboot
