#!/usr/bin/env bash
# Sets up flock-back's Python virtualenv using the repo already cloned
# by step 11 into ~/tools/flock-back.
set -euo pipefail

FLOCKBACK_DIR="$HOME/tools/flock-back"

if [[ ! -d "$FLOCKBACK_DIR" ]]; then
  echo "Expected $FLOCKBACK_DIR to exist (cloned by steps/11-clone-repos.sh) - run that step first." >&2
  exit 1
fi

cd "$FLOCKBACK_DIR/src"
python3 -m venv venv
venv/bin/pip install -r ../requirements.txt
