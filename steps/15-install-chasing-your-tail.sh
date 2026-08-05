#!/usr/bin/env bash
# Installs Chasing-Your-Tail-NG's Python dependencies using the repo
# already cloned by step 11 into ~/tools/Chasing-Your-Tail-NG.
set -euo pipefail

CYT_DIR="$HOME/tools/Chasing-Your-Tail-NG"

if [[ ! -d "$CYT_DIR" ]]; then
  echo "$CYT_DIR not found - skipping (declined at step 11, or that step hasn't run yet)."
  exit 0
fi

cd "$CYT_DIR"
# Recent Kali enforces PEP 668 (externally-managed-environment); fall
# back to --break-system-packages only if the plain install is refused.
pip3 install -r requirements.txt || pip3 install --break-system-packages -r requirements.txt

# config.json ships with paths.kismet_logs hardcoded to an unrelated
# machine's path (/home/matt/kismet_logs/*.kismet). Point it at the
# directory steps/06-kismet-config.sh actually configures Kismet to
# log into. config.json is tracked in this repo, so a plain edit would
# make step 11's `git pull --ff-only` fail the moment upstream ever
# touches this file too - `update-index --skip-worktree` tells git to
# leave our local copy alone on future pulls instead.
python3 - "$HOME/kismet_logs" <<'PYEOF'
import json
import sys
from pathlib import Path

log_dir = sys.argv[1]
config_path = Path("config.json")
data = json.loads(config_path.read_text())
data.setdefault("paths", {})["kismet_logs"] = f"{log_dir}/*.kismet"
config_path.write_text(json.dumps(data, indent=2) + "\n")
PYEOF
git update-index --skip-worktree config.json
