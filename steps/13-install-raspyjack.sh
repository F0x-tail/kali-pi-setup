#!/usr/bin/env bash
# Runs Raspyjack's own installer against the repo already cloned by
# step 11 into ~/tools/Raspyjack, instead of the official docs' separate
# root-owned clone (which would leave two copies of the repo on disk).
#
# The official install ends with a reboot; that's skipped here since a
# mid-bootstrap reboot would kill the remaining steps. bootstrap.sh
# already recommends a reboot once every step has finished.
set -euo pipefail

RASPYJACK_DIR="$HOME/tools/Raspyjack"

if [[ ! -d "$RASPYJACK_DIR" ]]; then
  echo "Expected $RASPYJACK_DIR to exist (cloned by steps/11-clone-repos.sh) - run that step first." >&2
  exit 1
fi

cd "$RASPYJACK_DIR"
chmod +x install_raspyjack.sh
sudo ./install_raspyjack.sh
