#!/usr/bin/env bash
# Clones (or updates) each tool listed in repos.txt into ~/tools/<name>,
# asking for confirmation first. Its own install step (steps/1N-install-
# <name>.sh) then runs later in bootstrap.sh - a repo skipped here is
# skipped there too rather than treated as an error.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

TOOLS_DIR="$HOME/tools"
mkdir -p "$TOOLS_DIR"

while IFS='|' read -r name url; do
  [[ -z "$name" || "$name" == \#* ]] && continue

  read -rp "Install $name? [y/N]: " answer < /dev/tty
  case "$answer" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) echo "Skipping $name."; continue ;;
  esac

  dest="$TOOLS_DIR/$name"
  if [[ -d "$dest/.git" ]]; then
    echo "Updating $name"
    git -C "$dest" pull --ff-only
  else
    echo "Cloning $name"
    git clone "$url" "$dest"
  fi
done < repos.txt
