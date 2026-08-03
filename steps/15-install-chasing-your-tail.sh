#!/usr/bin/env bash
# Installs Chasing-Your-Tail-NG's Python dependencies using the repo
# already cloned by step 11 into ~/tools/Chasing-Your-Tail-NG.
set -euo pipefail

CYT_DIR="$HOME/tools/Chasing-Your-Tail-NG"

if [[ ! -d "$CYT_DIR" ]]; then
  echo "Expected $CYT_DIR to exist (cloned by steps/11-clone-repos.sh) - run that step first." >&2
  exit 1
fi

cd "$CYT_DIR"
# Recent Kali enforces PEP 668 (externally-managed-environment); fall
# back to --break-system-packages only if the plain install is refused.
pip3 install -r requirements.txt || pip3 install --break-system-packages -r requirements.txt
