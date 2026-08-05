#!/usr/bin/env bash
# Starts Chasing-Your-Tail-NG's core monitoring (dependencies installed
# by steps/15-install-chasing-your-tail.sh). Run
# `python3 setup_credentials.py` from ~/tools/Chasing-Your-Tail-NG once
# first if you want its WiGLE API lookups.
set -euo pipefail

CYT_DIR="$HOME/tools/Chasing-Your-Tail-NG"

if [[ ! -f "$CYT_DIR/chasing_your_tail.py" ]]; then
  echo "Chasing-Your-Tail-NG isn't cloned yet (${CYT_DIR} missing)." >&2
  echo "Run steps/11-clone-repos.sh first." >&2
  exit 1
fi

cd "$CYT_DIR"
exec python3 chasing_your_tail.py "$@"
