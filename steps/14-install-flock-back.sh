#!/usr/bin/env bash
# Sets up flock-back's Python virtualenv using the repo already cloned
# by step 11 into ~/tools/flock-back.
set -euo pipefail

FLOCKBACK_DIR="$HOME/tools/flock-back"

if [[ ! -d "$FLOCKBACK_DIR" ]]; then
  echo "$FLOCKBACK_DIR not found - skipping (declined at step 11, or that step hasn't run yet)."
  exit 0
fi

cd "$FLOCKBACK_DIR/src"
python3 -m venv venv
venv/bin/pip install -r ../requirements.txt
