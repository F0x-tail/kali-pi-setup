#!/usr/bin/env bash
# Append the required lines to Kismet's config files (idempotent - safe to re-run).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source lib/common.sh

ensure_line /etc/kismet/kismet.conf "source=wlan1mon:name=Alfa"
ensure_line /etc/kismet/kismet.conf "source=rtladsb-0:name=ADS-B"
ensure_line /etc/kismet/kismet.conf "gps=gpsd:host=localhost,port=2947"

ensure_line /etc/kismet/kismet_logging.conf "log_prefix=./.kismet"
ensure_line /etc/kismet/kismet_logging.conf "log_types=kismet,wiglecsv"
