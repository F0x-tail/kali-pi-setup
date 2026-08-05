#!/usr/bin/env bash
# Installs convenience launcher scripts into the home folder, so
# Kismet, flock-back, and Chasing-Your-Tail-NG can each be started
# with one command from anywhere instead of remembering venvs, cwd,
# and flags. No sudo needed - these only touch $HOME.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

for script in config/home/*.sh; do
  install -m 755 "$script" "$HOME/$(basename "$script")"
done
