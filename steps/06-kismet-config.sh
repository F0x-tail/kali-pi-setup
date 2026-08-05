#!/usr/bin/env bash
# Append the required lines to Kismet's config files (idempotent - safe to re-run).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source lib/common.sh

# Kismet puts the source into monitor mode itself, so it's given the
# raw interface (wlan1) rather than a pre-existing wlan1mon. Drop any
# stale wlan1mon line from an earlier run before adding the new one.
sudo sed -i '/^source=wlan1mon:name=Alfa$/d' /etc/kismet/kismet.conf
ensure_line /etc/kismet/kismet.conf "source=wlan1:name=Alfa"
ensure_line /etc/kismet/kismet.conf "source=rtladsb-0:name=ADS-B"
ensure_line /etc/kismet/kismet.conf "source=hci0:name=Bluetooth"
ensure_line /etc/kismet/kismet.conf "gps=gpsd:host=localhost,port=2947"

# log_prefix must be an existing absolute directory - Kismet documents
# that it will NOT create it itself, and a relative "./" prefix would
# otherwise depend on whatever cwd start-kismet.sh happens to be run
# from. Fixed, predictable location so other tools (e.g.
# Chasing-Your-Tail-NG, see steps/15) can point at it reliably.
KISMET_LOG_DIR="$HOME/kismet_logs"
mkdir -p "$KISMET_LOG_DIR"
sudo sed -i '/^log_prefix=/d' /etc/kismet/kismet_logging.conf
ensure_line /etc/kismet/kismet_logging.conf "log_prefix=$KISMET_LOG_DIR"
ensure_line /etc/kismet/kismet_logging.conf "log_types=kismet,wiglecsv"
