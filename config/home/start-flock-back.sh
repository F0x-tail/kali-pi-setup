#!/usr/bin/env bash
# Starts flock-back using the venv steps/14-install-flock-back.sh set
# up. Always runs with:
#   -w   Wardriver mode - auto-detects all monitor adapters and splits
#        channels by band itself. This makes an explicit -i pointless:
#        main.py's `if not args.w and Variables.iface: ...` only
#        honors -i when -w is absent, so a fixed wlan1 default would
#        just be silently ignored here.
#   -k   Kismet mode - polls Kismet's REST API and runs signature
#        matching against what it's already seen (start-kismet.sh
#        first).
# -b hci0 (onboard Bluetooth) stays a default since BLE scanning runs
# independently of wardriver mode. Pass extra flock-back flags through
# as needed, e.g. `start-flock-back.sh -g /dev/ttyACM0`.
set -euo pipefail

FLOCKBACK_DIR="$HOME/tools/flock-back"

if [[ ! -x "$FLOCKBACK_DIR/src/venv/bin/python3" ]]; then
  echo "flock-back isn't set up yet (${FLOCKBACK_DIR}/src/venv missing)." >&2
  echo "Run steps/11-clone-repos.sh and steps/14-install-flock-back.sh first." >&2
  exit 1
fi

cd "$FLOCKBACK_DIR/src"
exec venv/bin/python3 main.py -w -k -b hci0 "$@"
