#!/usr/bin/env bash
# Clones (or updates) each tool listed in repos.txt into ~/tools/<name>.
# Each tool's own install/build steps are NOT run automatically - see its README.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

TOOLS_DIR="$HOME/tools"
mkdir -p "$TOOLS_DIR"

while IFS='|' read -r name url; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  dest="$TOOLS_DIR/$name"
  if [[ -d "$dest/.git" ]]; then
    echo "Updating $name"
    git -C "$dest" pull --ff-only
  else
    echo "Cloning $name"
    git clone "$url" "$dest"
  fi
done < repos.txt
