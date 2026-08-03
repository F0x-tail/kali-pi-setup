#!/usr/bin/env bash
# Shared helpers sourced by every step script.

log() { echo -e "\n==> $*"; }

# Append a line to a file only if it isn't already present (idempotent).
ensure_line() {
  local file="$1" line="$2"
  sudo test -f "$file" || sudo touch "$file"
  sudo grep -qxF "$line" "$file" || echo "$line" | sudo tee -a "$file" >/dev/null
}

# Append a marker-delimited block to a file, replacing any previous block
# with the same marker first. Lets a step re-run and pick up an updated
# content_file without accumulating duplicates.
ensure_block() {
  local file="$1" marker="$2" content_file="$3"
  sudo test -f "$file" || sudo touch "$file"
  sudo sed -i "/# BEGIN ${marker}/,/# END ${marker}/d" "$file"
  {
    echo "# BEGIN ${marker}"
    cat "$content_file"
    echo "# END ${marker}"
  } | sudo tee -a "$file" >/dev/null
}
